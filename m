Return-Path: <linux-kernel-owner+w=401wt.eu-S1762246AbXGEXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762246AbXGEXH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXGEXHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:07:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066AbXGEXHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:07:11 -0400
Date: Fri, 6 Jul 2007 01:07:02 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] introduce panic_gently
Message-ID: <Pine.LNX.4.58.0707060034330.18989@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19IjLwseTKW2OCUGVpLu+1KI+vlla7kLI8RHIW
 Gf/0V5n3uVvzyvK+EcDqgoggLz4TG9Qa6UK+rmmfa33Xw9ZRO2
 BO9EJg1+mv9wqcGBEkgkQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If the boot process failes to find init or the root fs, the cause has 
usually scrolled off the screen, and because of the panic, it can't be 
reached anymore.

This patch introduces panic_gently, which will allow to use the scrollback 
buffer and to reboot, but it can't be called from unsafe context.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

---

This patch seems to work correctly on bochs/i386, except for the qemu
BIOS hangigng after a ctrl_alt_del, but I did run qemu using -kernel and 
-initrd, which might have caused this behaviour.

Is this function useful outside init code?
Should it be disabled on non-console systems/archs?


diff -X dontdiff -pruN 2.6.21.ori/include/linux/kernel.h 2.6.21/include/linux/kernel.h
--- 2.6.21.ori/include/linux/kernel.h	2007-07-06 00:13:03.000000000 +0200
+++ 2.6.21/include/linux/kernel.h	2007-07-05 23:35:46.000000000 +0200
@@ -96,6 +96,8 @@ extern struct atomic_notifier_head panic
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2)));
+NORET_TYPE void panic_gently(const char * fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 1, 2)));
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
diff -X dontdiff -pruN 2.6.21.ori/init/do_mounts.c 2.6.21/init/do_mounts.c
--- 2.6.21.ori/init/do_mounts.c	2006-11-29 22:57:37.000000000 +0100
+++ 2.6.21/init/do_mounts.c	2007-07-05 23:55:35.000000000 +0200
@@ -315,7 +315,7 @@ retry:
 				root_device_name, b);
 		printk("Please append a correct \"root=\" boot option\n");
 
-		panic("VFS: Unable to mount root fs on %s", b);
+		panic_gently("VFS: Unable to mount root fs on %s", b);
 	}
 
 	printk("No filesystem could mount root, tried: ");
@@ -325,7 +325,7 @@ retry:
 #ifdef CONFIG_BLOCK
 	__bdevname(ROOT_DEV, b);
 #endif
-	panic("VFS: Unable to mount root fs on %s", b);
+	panic_gently("VFS: Unable to mount root fs on %s", b);
 out:
 	putname(fs_names);
 }
diff -X dontdiff -pruN 2.6.21.ori/init/main.c 2.6.21/init/main.c
--- 2.6.21.ori/init/main.c	2007-07-06 00:13:03.000000000 +0200
+++ 2.6.21/init/main.c	2007-07-05 23:43:15.000000000 +0200
@@ -579,7 +579,7 @@ asmlinkage void __init start_kernel(void
 	 */
 	console_init();
 	if (panic_later)
-		panic(panic_later, panic_param);
+		panic_gently(panic_later, panic_param);
 
 	lockdep_info();
 
@@ -769,7 +769,7 @@ static int noinline init_post(void)
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
 
-	panic("No init found.  Try passing init= option to kernel.");
+	panic_gently("No init found.  Try passing init= option to kernel.");
 }
 
 static int __init init(void * unused)
diff -X dontdiff -pruN 2.6.21.ori/kernel/panic.c 2.6.21/kernel/panic.c
--- 2.6.21.ori/kernel/panic.c	2007-07-06 00:13:03.000000000 +0200
+++ 2.6.21/kernel/panic.c	2007-07-05 23:48:28.000000000 +0200
@@ -139,7 +139,64 @@ NORET_TYPE void panic(const char * fmt, 
 	}
 }
 
+NORET_TYPE void panic_gently(const char * fmt, ...)
+{
+	long i;
+	static char buf[1024];
+	va_list args;
+#if defined(CONFIG_S390)
+        unsigned long caller = (unsigned long) __builtin_return_address(0);
+#endif
+
+	va_start(args, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+
+	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+
+	if (!panic_blink)
+		panic_blink = no_blink;
+
+	if (panic_timeout > 0) {
+		/*
+	 	 * Delay timeout seconds before rebooting the machine. 
+		 * We can't use the "normal" timers since we just panicked..
+	 	 */
+		printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
+		for (i = 0; i < panic_timeout*1000; ) {
+			touch_nmi_watchdog();
+			i += panic_blink(i);
+			mdelay(1);
+			i++;
+		}
+		/*	This will not be a clean reboot, with everything
+		 *	shutting down.  But if there is a chance of
+		 *	rebooting the system it will be rebooted.
+		 */
+		kernel_restart(NULL);
+	}
+#ifdef __sparc__
+	{
+		extern int stop_a_enabled;
+		/* Make sure the user can actually press Stop-A (L1-A) */
+		stop_a_enabled = 1;
+		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+	}
+#endif
+#if defined(CONFIG_S390)
+        disabled_wait(caller);
+#endif
+	for (i = 0;;) {
+		touch_softlockup_watchdog();
+		i += panic_blink(i);
+		msleep(1);
+		i++;
+	}
+}
+
 EXPORT_SYMBOL(panic);
+EXPORT_SYMBOL(panic_gently);
 
 /**
  *	print_tainted - return a string to represent the kernel taint state.
-- 
knghtbrd:<JHM> AIX - the Unix from the universe where Spock has a beard.
