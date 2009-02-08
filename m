Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbZBHSwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbZBHSwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753099AbZBHSw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:52:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:53611 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbZBHSw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:52:27 -0500
Date: Sun, 8 Feb 2009 10:42:01 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, jkosina@suse.cz, mchehab@infradead.org
Subject: [PATCH 1/3] module: create a request_module_nowait()
Message-ID: <20090208104201.6124ab6a@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 48cd2d5171ae8fb40ef6092a566b4889b9ac72b7 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 1 Feb 2009 12:02:39 -0800
Subject: [PATCH] module: create a request_module_nowait()

There seems to be a common pattern in the kernel where drivers want to
call request_module() from inside a module_init() function. Currently
this would deadlock.

As a result, several drivers go through hoops like scheduling things via
kevent, or creating custom work queues (because kevent can deadlock on them).

This patch changes this to use a request_module_nowait() function macro instead,
which just fires the modprobe off but doesn't wait for it, and thus avoids the
original deadlock entirely.

On my laptop this already results in one less kernel thread running..

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/kmod.h |    9 ++++++---
 kernel/kmod.c        |   10 ++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/kmod.h b/include/linux/kmod.h
index 92213a9..73b2b56 100644
--- a/include/linux/kmod.h
+++ b/include/linux/kmod.h
@@ -29,10 +29,13 @@
 #ifdef CONFIG_MODULES
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
-extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
-#define try_then_request_module(x, mod...) ((x) ?: (request_module(mod), (x)))
+extern int __request_module(int wait, const char *name, ...) __attribute__ ((format (printf, 2, 3)));
+#define request_module(mod...) __request_module(1, mod)
+#define request_module_nowait(mod...) __request_module(0, mod)
+#define try_then_request_module(x, mod...) ((x) ?: (__request_module(0, mod), (x)))
 #else
-static inline int request_module(const char * name, ...) { return -ENOSYS; }
+static inline int request_module(const char *name, ...) { return -ENOSYS; }
+static inline int request_module_nowait(const char *name, ...) { return -ENOSYS; }
 #define try_then_request_module(x, mod...) (x)
 #endif
 
diff --git a/kernel/kmod.c b/kernel/kmod.c
index a27a5f6..3b90ea5 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -50,7 +50,8 @@ static struct workqueue_struct *khelper_wq;
 char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
 
 /**
- * request_module - try to load a kernel module
+ * __request_module - try to load a kernel module
+ * @wait: wait (or not) for the operation to complete
  * @fmt: printf style format string for the name of the module
  * @...: arguments as specified in the format string
  *
@@ -63,7 +64,8 @@ char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
  * If module auto-loading support is disabled then this function
  * becomes a no-operation.
  */
-int request_module(const char *fmt, ...)
+
+int __request_module(int wait, const char *fmt, ...)
 {
 	va_list args;
 	char module_name[MODULE_NAME_LEN];
@@ -108,11 +110,11 @@ int request_module(const char *fmt, ...)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper(modprobe_path, argv, envp, 1);
+	ret = call_usermodehelper(modprobe_path, argv, envp, wait);
 	atomic_dec(&kmod_concurrent);
 	return ret;
 }
-EXPORT_SYMBOL(request_module);
+EXPORT_SYMBOL(__request_module);
 #endif /* CONFIG_MODULES */
 
 struct subprocess_info {
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
