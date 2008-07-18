Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbYGRWSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbYGRWSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 18:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbYGRWRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 18:17:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:47964 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760435AbYGRWRi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 18:17:38 -0400
Date: Fri, 18 Jul 2008 15:16:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu
Subject: [patch 1/3] fastboot: Create a "asynchronous" initlevel
Message-ID: <20080718151608.46dc17c0@infradead.org>
In-Reply-To: <20080718151524.5ef9e29b@infradead.org>
References: <20080718151524.5ef9e29b@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7cdd9446f49f430ff29bfb2d2e20759cc9f2d9e8 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 18 Jul 2008 11:30:52 -0700
Subject: [PATCH] fastboot: Create a "asynchronous" initlevel

This patch creates an asynchronous initlevel (6a) which is at the same level as
the normal device initcalls, but with the difference that they are run asynchronous
from all the other initcalls. The purpose of this *selective* level is that we can
move long waiting inits that are not boot-critical to this level one at a time.

To keep things not totally insane, the asynchronous initcalls are async to the other
initcalls, but are still ordered to themselves; think of it as "bottom-half-not-softirq".
This has the benefit that async drivers still have stable device ordering between them.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/asm-generic/vmlinux.lds.h |    3 +++
 include/linux/init.h              |    6 ++++++
 init/main.c                       |   37 ++++++++++++++++++++++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 729f6b0..72691e8 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -372,6 +372,9 @@
   	*(.initcall5.init)						\
   	*(.initcall5s.init)						\
 	*(.initcallrootfs.init)						\
+	__async_initcall_start = .;					\
+	*(.initcall6a.init)						\
+	__async_initcall_end = .;					\
   	*(.initcall6.init)						\
   	*(.initcall6s.init)						\
   	*(.initcall7.init)						\
diff --git a/include/linux/init.h b/include/linux/init.h
index 21d658c..96474ff 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -189,11 +189,13 @@ extern void (*late_time_init)(void);
 #define fs_initcall_sync(fn)		__define_initcall("5s",fn,5s)
 #define rootfs_initcall(fn)		__define_initcall("rootfs",fn,rootfs)
 #define device_initcall(fn)		__define_initcall("6",fn,6)
+#define device_initcall_async(fn)	__define_initcall("6a", fn, 6a)
 #define device_initcall_sync(fn)	__define_initcall("6s",fn,6s)
 #define late_initcall(fn)		__define_initcall("7",fn,7)
 #define late_initcall_sync(fn)		__define_initcall("7s",fn,7s)
 
 #define __initcall(fn) device_initcall(fn)
+#define __initcall_async(fn) device_initcall_async(fn)
 
 #define __exitcall(fn) \
 	static exitcall_t __exitcall_##fn __exit_call = fn
@@ -249,6 +251,7 @@ void __init parse_early_param(void);
  * be one per module.
  */
 #define module_init(x)	__initcall(x);
+#define module_init_async(x)	__initcall_async(x);
 
 /**
  * module_exit() - driver exit entry point
@@ -271,10 +274,13 @@ void __init parse_early_param(void);
 #define subsys_initcall(fn)		module_init(fn)
 #define fs_initcall(fn)			module_init(fn)
 #define device_initcall(fn)		module_init(fn)
+#define device_initcall_async(fn)	module_init(fn)
 #define late_initcall(fn)		module_init(fn)
 
 #define security_initcall(fn)		module_init(fn)
 
+#define module_init_async(fn)		module_init(fn)
+
 /* These macros create a dummy inline: gcc 2.9x does not count alias
  as usage, hence the `unused function' warning when __init functions
  are declared static. We use the dummy __*_module_inline functions
diff --git a/init/main.c b/init/main.c
index edeace0..42d5a5f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -738,16 +738,46 @@ static void __init do_one_initcall(initcall_t fn)
 
 
 extern initcall_t __initcall_start[], __initcall_end[];
+extern initcall_t __async_initcall_start[], __async_initcall_end[];
 
-static void __init do_initcalls(void)
+static void __init do_async_initcalls(struct work_struct *dummy)
 {
 	initcall_t *call;
 
-	for (call = __initcall_start; call < __initcall_end; call++)
+	for (call = __async_initcall_start; call < __async_initcall_end; call++)
 		do_one_initcall(*call);
+}
+
+static struct workqueue_struct *async_init_wq;
 
-	/* Make sure there is no pending stuff from the initcall sequence */
+
+
+static void __init do_initcalls(void)
+{
+	initcall_t *call;
+	static DECLARE_WORK(async_work, do_async_initcalls);
+	int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after level 6a */
+
+	async_init_wq = create_singlethread_workqueue("kasyncinit");
+
+	for (call = __initcall_start; call < __initcall_end; call++) {
+		if (phase == 0 && call >= __async_initcall_start) {
+			phase = 1;
+			queue_work(async_init_wq, &async_work);
+		}
+		if (phase == 1 && call >= __async_initcall_end)
+			phase = 2;
+		if (phase != 1)
+			do_one_initcall(*call);
+	}
+
+	/*
+	 * Make sure there is no pending stuff from the initcall sequence,
+	 * including the async initcalls
+	 */
 	flush_scheduled_work();
+	flush_workqueue(async_init_wq);
+	destroy_workqueue(async_init_wq);
 }
 
 /*
-- 
1.5.5.1

