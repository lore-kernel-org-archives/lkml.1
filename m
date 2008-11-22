Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbYKVDlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbYKVDlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754525AbYKVDkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:40:21 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:53139 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754068AbYKVDkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:40:19 -0500
From: Jeff Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: [RFC v3 PATCH 6/7] Ksplice: Export symbols needed for Ksplice
Date: Fri, 21 Nov 2008 22:36:00 -0500
Message-Id: <1227324961-13273-7-git-send-email-jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <1227324961-13273-6-git-send-email-jbarnold@mit.edu>
References: <1227324961-13273-1-git-send-email-jbarnold@mit.edu>
 <1227324961-13273-2-git-send-email-jbarnold@mit.edu>
 <1227324961-13273-3-git-send-email-jbarnold@mit.edu>
 <1227324961-13273-4-git-send-email-jbarnold@mit.edu>
 <1227324961-13273-5-git-send-email-jbarnold@mit.edu>
 <1227324961-13273-6-git-send-email-jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Ksplice uses several functions from module.c in order to resolve
symbols and implement dependency handling.  Calling these functions
requires holding module_mutex, so it is exported.

Ksplice uses task_curr in order to confirm that no other tasks are
executing during Ksplice's kernel stack check.

Ksplice uses find_bug and search_exception_tables as part of its
conservative check that the user provided the correct source code for
the running kernel.

Ksplice uses init_mm to get access to the ranges of addresses
containing core kernel text and data.  It seems that init_mm was
scheduled to be unexported entirely in 2.6.26, so move it to
EXPORT_SYMBOL_GPL (rather than back to EXPORT_SYMBOL).

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 arch/x86/kernel/init_task.c |    2 +-
 include/linux/module.h      |   28 ++++++++++++++++++++++++++++
 kernel/extable.c            |    3 +++
 kernel/module.c             |   41 +++++++++++++++++------------------------
 kernel/sched.c              |    1 +
 lib/bug.c                   |    1 +
 6 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index ec4a2fe..0c173bd 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -14,7 +14,7 @@ static struct fs_struct init_fs = INIT_FS;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
+EXPORT_SYMBOL_GPL(init_mm);
 
 /*
  * Initial thread structure.
diff --git a/include/linux/module.h b/include/linux/module.h
index 29972a2..cc613f6 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -355,6 +355,8 @@ struct module
 #define MODULE_ARCH_INIT {}
 #endif
 
+extern struct mutex module_mutex;
+
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
    (IDE & SCSI) require entry into the module during init.*/
@@ -370,6 +372,31 @@ struct module *module_data_address(unsigned long addr);
 struct module *__module_data_address(unsigned long addr);
 int is_module_address(unsigned long addr);
 
+/* Search for module by name: must hold module_mutex. */
+struct module *find_module(const char *name);
+
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const unsigned long *crcs;
+	enum {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+		WILL_BE_GPL_ONLY,
+	} licence;
+	bool unused;
+};
+
+/* Search for an exported symbol by name. */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn);
+
+/* Walk the exported symbol table */
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data);
+
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
@@ -435,6 +462,7 @@ static inline void __module_get(struct module *module)
 #define symbol_put_addr(p) do { } while(0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
+int use_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
diff --git a/kernel/extable.c b/kernel/extable.c
index a26cb2e..f7740b1 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -39,6 +39,7 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 		e = search_module_extables(addr);
 	return e;
 }
+EXPORT_SYMBOL_GPL(search_exception_tables);
 
 int core_kernel_text(unsigned long addr)
 {
@@ -59,6 +60,7 @@ int __kernel_text_address(unsigned long addr)
 		return 1;
 	return __module_text_address(addr) != NULL;
 }
+EXPORT_SYMBOL_GPL(__kernel_text_address);
 
 int kernel_text_address(unsigned long addr)
 {
@@ -66,3 +68,4 @@ int kernel_text_address(unsigned long addr)
 		return 1;
 	return module_text_address(addr) != NULL;
 }
+EXPORT_SYMBOL_GPL(kernel_text_address);
diff --git a/kernel/module.c b/kernel/module.c
index 8839d40..b109aae 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -67,7 +67,8 @@
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (delete uses stop_machine/add uses RCU list operations). */
-static DEFINE_MUTEX(module_mutex);
+DEFINE_MUTEX(module_mutex);
+EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Waiting for a module to finish initializing? */
@@ -185,17 +186,6 @@ extern const unsigned long __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
-	enum {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-		WILL_BE_GPL_ONLY,
-	} licence;
-	bool unused;
-};
-
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
@@ -216,10 +206,8 @@ static bool each_symbol_in_section(const struct symsearch *arr,
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-static bool each_symbol(bool (*fn)(const struct symsearch *arr,
-				   struct module *owner,
-				   unsigned int symnum, void *data),
-			void *data)
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data)
 {
 	struct module *mod;
 	const struct symsearch arr[] = {
@@ -272,6 +260,7 @@ static bool each_symbol(bool (*fn)(const struct symsearch *arr,
 	}
 	return false;
 }
+EXPORT_SYMBOL_GPL(each_symbol);
 
 struct find_symbol_arg {
 	/* Input */
@@ -329,11 +318,11 @@ static bool find_symbol_in_section(const struct symsearch *syms,
 
 /* Find a symbol and return it, along with, (optional) crc and
  * (optional) module which owns it */
-static const struct kernel_symbol *find_symbol(const char *name,
-					       struct module **owner,
-					       const unsigned long **crc,
-					       bool gplok,
-					       bool warn)
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn)
 {
 	struct find_symbol_arg fsa;
 
@@ -352,9 +341,10 @@ static const struct kernel_symbol *find_symbol(const char *name,
 	DEBUGP("Failed to find symbol %s\n", name);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_symbol);
 
 /* Search for module by name: must hold module_mutex. */
-static struct module *find_module(const char *name)
+struct module *find_module(const char *name)
 {
 	struct module *mod;
 
@@ -364,6 +354,7 @@ static struct module *find_module(const char *name)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
@@ -607,7 +598,7 @@ static int already_uses(struct module *a, struct module *b)
 }
 
 /* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
 	int no_warn, err;
@@ -640,6 +631,7 @@ static int use_module(struct module *a, struct module *b)
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -903,10 +895,11 @@ static inline void module_unload_free(struct module *mod)
 {
 }
 
-static inline int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	return strong_try_module_get(b) == 0;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 static inline void module_unload_init(struct module *mod)
 {
diff --git a/kernel/sched.c b/kernel/sched.c
index 9b1e793..7dc850e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1769,6 +1769,7 @@ inline int task_curr(const struct task_struct *p)
 {
 	return cpu_curr(task_cpu(p)) == p;
 }
+EXPORT_SYMBOL_GPL(task_curr);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
diff --git a/lib/bug.c b/lib/bug.c
index bfeafd6..b5c0659 100644
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -113,6 +113,7 @@ const struct bug_entry *find_bug(unsigned long bugaddr)
 
 	return module_find_bug(bugaddr);
 }
+EXPORT_SYMBOL_GPL(find_bug);
 
 enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
-- 
1.5.6.3

