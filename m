Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbXKMCwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbXKMCwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXKMCwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:52:30 -0500
Received: from ozlabs.org ([203.10.76.45]:45882 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXKMCw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:52:29 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [PATCH] module loader should not complain about unknown symbol
Date: Tue, 13 Nov 2007 13:52:22 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       Andi Kleen <andi@firstfloor.org>, Jon Masters <jonathan@jonmasters.org>
References: <1194877107.5656.31.camel@localhost.localdomain> <200711130923.12616.rusty@rustcorp.com.au>
In-Reply-To: <200711130923.12616.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711131352.23244.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007 09:23:12 Rusty Russell wrote:
> Better might be to put in a waitqueue and wake it up whenever a module is
> deleted or changes status.  Then use_module() can wait if
> strong_try_module_get() returns -EBUSY (up to 30 seconds, then print a
> warning and fail).

And here it is.  Does it work for you Jan?

==
modules: wait for dependent modules doing init.

There have been reports of modules failing to load because the modules
they depend on are still loading.  This changes the modules to wait
for a reasonable length of time in that case.  We time out eventually,
because there can be module loops or broken modules.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a38c2f5e95f8 kernel/module.c
--- a/kernel/module.c	Tue Nov 13 09:06:30 2007 +1100
+++ b/kernel/module.c	Tue Nov 13 13:45:46 2007 +1100
@@ -67,6 +67,9 @@ static DEFINE_MUTEX(module_mutex);
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
 
+/* Waiting for a module to finish initializing? */
+static DECLARE_WAIT_QUEUE_HEAD(module_wq);
+
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
 int register_module_notifier(struct notifier_block * nb)
@@ -86,8 +89,11 @@ static inline int strong_try_module_get(
 static inline int strong_try_module_get(struct module *mod)
 {
 	if (mod && mod->state == MODULE_STATE_COMING)
+		return -EBUSY;
+	if (try_module_get(mod))
 		return 0;
-	return try_module_get(mod);
+	else
+		return -ENOENT;
 }
 
 static inline void add_taint_module(struct module *mod, unsigned flag)
@@ -539,11 +545,21 @@ static int use_module(struct module *a, 
 static int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
-	int no_warn;
+	int no_warn, err;
 
 	if (b == NULL || already_uses(a, b)) return 1;
 
-	if (!strong_try_module_get(b))
+	/* If we're interrupted or time out, we fail. */
+	if (wait_event_interruptible_timeout(
+		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
+		    30 * HZ) <= 0) {
+		printk("%s: gave up waiting for init of module %s.\n",
+		       a->name, b->name);
+		return 0;
+	}
+
+	/* If strong_try_module_get() returned a different error, we fail. */
+	if (err)
 		return 0;
 
 	DEBUGP("Allocating new usage for %s.\n", a->name);
@@ -814,7 +830,7 @@ static inline void module_unload_free(st
 
 static inline int use_module(struct module *a, struct module *b)
 {
-	return strong_try_module_get(b);
+	return strong_try_module_get(b) == 0;
 }
 
 static inline void module_unload_init(struct module *mod)
@@ -1330,7 +1346,7 @@ void *__symbol_get(const char *symbol)
 
 	preempt_disable();
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && !strong_try_module_get(owner))
+	if (value && strong_try_module_get(owner) != 0)
 		value = 0;
 	preempt_enable();
 
@@ -2133,6 +2149,7 @@ sys_init_module(void __user *umod,
 		mutex_lock(&module_mutex);
 		free_module(mod);
 		mutex_unlock(&module_mutex);
+		wake_up(&module_wq);
 		return ret;
 	}
 
@@ -2147,6 +2164,7 @@ sys_init_module(void __user *umod,
 	mod->init_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
+	wake_up(&module_wq);
 
 	return 0;
 }


