Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbXITH2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbXITH2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 03:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759960AbXITH02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 03:26:28 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33305 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbXITH0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 03:26:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=EZdhOOEKlPVyfTaCaaqI/KiV+nlLXV/OExSeofXr9a62Hmz9z6uMgyk4lxvDTs97bTux1UWzZshhe8NNCjuacKkr1scQ5jSi1RucV10Rg5YNlIoOUdOYKQSjAnAAR3p7m2apULtyWmrOn0c4yssH2iQOLZcJGu2yW9yEAKcRAp8=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/4] module: implement module_inhibit_unload()
In-Reply-To: <11902731752407-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 16:26:15 +0900
Message-Id: <11902731752708-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As its name suggests, module_inhibit_unload() inhibits all module
unloading till the matching module_allow_unload() is called.  This
unload inhibition doesn't affect whether a module can be unloaded or
not.  It just stalls the final module free till the inhibition is
lifted.

This sledgehammer mechanism is to be used briefly in obscure cases
where identifying or getting the module to prevent from unloading is
difficult or not worth the effort.  Note that module unloading is
siberia-cold path.  If the inhibion is relatively brief in human
scale, that is, upto a few secs at maximum, it should be fine.  So, if
this sledgehammer simplifies API and fixes premature unload bugs which
unfortunately aren't too rare, there isn't much reason not to use it.

Even if something goes wrong with unload inhibition (e.g. someone
forgets to lift the inhibition), it doesn't prevent modules from being
loaded.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |   17 +++++++++++++
 kernel/module.c        |   59 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 72 insertions(+), 4 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index b6a646c..a835659 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -418,6 +418,9 @@ static inline int try_module_get(struct module *module)
 
 extern void module_put(struct module *module);
 
+void module_inhibit_unload(void);
+void module_allow_unload(void);
+
 #else /*!CONFIG_MODULE_UNLOAD*/
 static inline int try_module_get(struct module *module)
 {
@@ -431,6 +434,12 @@ static inline void __module_get(struct module *module)
 }
 #define symbol_put(x) do { } while(0)
 #define symbol_put_addr(p) do { } while(0)
+static inline void module_inhibit_unload(void)
+{
+}
+static inline void module_allow_unload(void)
+{
+}
 
 #endif /* CONFIG_MODULE_UNLOAD */
 
@@ -516,6 +525,14 @@ static inline void module_put(struct module *module)
 {
 }
 
+static inline void module_inhibit_unload(void)
+{
+}
+
+static inline void module_allow_unload(void)
+{
+}
+
 #define module_name(mod) "kernel"
 
 #define __unsafe(mod)
diff --git a/kernel/module.c b/kernel/module.c
index db0ead0..8daff45 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -44,6 +44,7 @@
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <asm/cacheflush.h>
+#include <asm/atomic.h>
 #include <linux/license.h>
 
 extern int module_sysfs_initialized;
@@ -65,6 +66,8 @@ extern int module_sysfs_initialized;
  * (add/delete uses stop_machine). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
+static atomic_t module_unload_inhibit_cnt = ATOMIC_INIT(0);
+static DECLARE_WAIT_QUEUE_HEAD(module_unload_wait);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
@@ -656,6 +659,7 @@ static void wait_for_zero_refcount(struct module *mod)
 asmlinkage long
 sys_delete_module(const char __user *name_user, unsigned int flags)
 {
+	DECLARE_WAITQUEUE(wait, current);
 	struct module *mod;
 	char name[MODULE_NAME_LEN];
 	int ret, forced = 0;
@@ -714,12 +718,22 @@ sys_delete_module(const char __user *name_user, unsigned int flags)
 	if (!forced && module_refcount(mod) != 0)
 		wait_for_zero_refcount(mod);
 
+	mutex_unlock(&module_mutex);
+
 	/* Final destruction now noone is using it. */
-	if (mod->exit != NULL) {
-		mutex_unlock(&module_mutex);
+	if (mod->exit != NULL)
 		mod->exit();
-		mutex_lock(&module_mutex);
-	}
+
+	/* Don't proceed till inhibition is lifted. */
+	add_wait_queue(&module_unload_wait, &wait);
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	if (atomic_read(&module_unload_inhibit_cnt))
+		schedule();
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&module_unload_wait, &wait);
+
+	mutex_lock(&module_mutex);
+
 	free_module(mod);
 
  out:
@@ -805,6 +819,43 @@ void module_put(struct module *module)
 }
 EXPORT_SYMBOL(module_put);
 
+/**
+ *	module_inhibit_unload - inhibit module unload
+ *
+ *	Inhibit module unload until allowed again.  All module unload
+ *	operations which reach zero reference count after this call
+ *	has returned are guaranteed to be stalled till inhibition is
+ *	lifted.
+ *
+ *	This is a simple mechanism to prevent premature unload while
+ *	code on a to-be-unloaded module is still executing.  Unload
+ *	inhibitions must be finite and relatively short.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void module_inhibit_unload(void)
+{
+	atomic_inc(&module_unload_inhibit_cnt);
+}
+
+/**
+ *	module_allow_unload - allow module unload
+ *
+ *	Allow module unload.  Must be balanced with calls to
+ *	module_inhibit_unload().
+ *
+ *	LOCKING:
+ *	None.
+ */
+void module_allow_unload(void)
+{
+	if (atomic_dec_and_test(&module_unload_inhibit_cnt))
+		wake_up_all(&module_unload_wait);
+
+	BUG_ON(atomic_read(&module_unload_inhibit_cnt) < 0);
+}
+
 #else /* !CONFIG_MODULE_UNLOAD */
 static void print_unload_info(struct seq_file *m, struct module *mod)
 {
-- 
1.5.0.3


