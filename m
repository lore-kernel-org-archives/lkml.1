Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYA1TH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYA1TH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYA1THR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:07:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:56814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbYA1THP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:07:15 -0500
Date: Mon, 28 Jan 2008 20:07:06 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: Bodo Eggert <7eggert@gmx.de>
cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] Introduce softpanic V.2
In-Reply-To: <alpine.LSU.0.999.0801251836420.2201@be1.lrz>
Message-ID: <alpine.LSU.0.999.0801281930580.4906@be1.lrz>
References: <alpine.LSU.0.999.0801251551060.21522@be1.lrz>
 <Pine.LNX.4.64.0801251603380.15243@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.0.999.0801251836420.2201@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19RLrVRRasGLqNfWqo6+DqFo8bDqP+Ljm5ZIXs
 O6UHm5enyzlrmgV3OTG96Z4W+Cbb+KbQZRygt2uh7fuq0J8lS3
 qHnIxCcpVqpqm50oebzUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling this option changes a hard panic on boot errors to a
soft panic, which does not stop the system completely.
You can still scroll the screen and read the messages.

Signed-Off-By: Bodo Eggert <7eggert@gmx.de>

---

Fixed: s/SOFTPANIC/CONFIG_SOFTPANIC/

I did not implement shutting down the network on panic, which was requested 
to let the watchdog reboot the machine. For this purpose, you should use 
"panic=$n".


diff -pruN -X dontdiff linux-2.6.24.pure/include/linux/kernel.h linux-2.6.24.softpanic/include/linux/kernel.h
--- linux-2.6.24.pure/include/linux/kernel.h	2008-01-25 15:09:36.000000000 +0100
+++ linux-2.6.24.softpanic/include/linux/kernel.h	2008-01-25 15:31:26.000000000 +0100
@@ -130,6 +130,12 @@ extern struct atomic_notifier_head panic
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
 	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+#ifdef SOFTPANIC
+NORET_TYPE void softpanic(const char *fmt, ...)
+	__attribute__ ((NORET_AND format (printf, 1, 2))) __cold;
+#else
+# define softpanic(...) do { panic(__VA_ARGS__); } while (0)
+#endif
 extern void oops_enter(void);
 extern void oops_exit(void);
 extern int oops_may_print(void);
diff -pruN -X dontdiff linux-2.6.24.pure/init/Kconfig linux-2.6.24.softpanic/init/Kconfig
--- linux-2.6.24.pure/init/Kconfig	2008-01-25 15:09:38.000000000 +0100
+++ linux-2.6.24.softpanic/init/Kconfig	2008-01-25 15:15:08.000000000 +0100
@@ -526,6 +526,14 @@ config BUG
           option for embedded systems with no facilities for reporting errors.
           Just say Y.
 
+config SOFTPANIC
+	bool "Enable softpanic for boot errors" if EMBEDDED
+	default y
+	help
+		Enabling this option changes a hard panic on boot errors to a
+		soft panic, which does not stop the system completely.
+		You can still scroll the screen and read the messages.
+
 config ELF_CORE
 	default y
 	bool "Enable ELF core dumps" if EMBEDDED
diff -pruN -X dontdiff linux-2.6.24.pure/init/do_mounts.c linux-2.6.24.softpanic/init/do_mounts.c
--- linux-2.6.24.pure/init/do_mounts.c	2008-01-25 15:08:31.000000000 +0100
+++ linux-2.6.24.softpanic/init/do_mounts.c	2008-01-25 15:15:08.000000000 +0100
@@ -330,7 +330,7 @@ retry:
 		printk("Please append a correct \"root=\" boot option; here are the available partitions:\n");
 
 		printk_all_partitions();
-		panic("VFS: Unable to mount root fs on %s", b);
+		softpanic("VFS: Unable to mount root fs on %s", b);
 	}
 
 	printk("List of all partitions:\n");
@@ -342,7 +342,7 @@ retry:
 #ifdef CONFIG_BLOCK
 	__bdevname(ROOT_DEV, b);
 #endif
-	panic("VFS: Unable to mount root fs on %s", b);
+	softpanic("VFS: Unable to mount root fs on %s", b);
 out:
 	putname(fs_names);
 }
diff -pruN -X dontdiff linux-2.6.24.pure/init/main.c linux-2.6.24.softpanic/init/main.c
--- linux-2.6.24.pure/init/main.c	2008-01-25 15:09:38.000000000 +0100
+++ linux-2.6.24.softpanic/init/main.c	2008-01-25 15:15:08.000000000 +0100
@@ -585,7 +585,7 @@ asmlinkage void __init start_kernel(void
 	 */
 	console_init();
 	if (panic_later)
-		panic(panic_later, panic_param);
+		softpanic(panic_later, panic_param);
 
 	lockdep_info();
 
@@ -800,7 +800,7 @@ static int noinline init_post(void)
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
 
-	panic("No init found.  Try passing init= option to kernel.");
+	softpanic("No init found.  Try passing init= option to kernel.");
 }
 
 static int __init kernel_init(void * unused)
diff -pruN -X dontdiff linux-2.6.24.pure/kernel/panic.c linux-2.6.24.softpanic/kernel/panic.c
--- linux-2.6.24.pure/kernel/panic.c	2008-01-25 15:09:38.000000000 +0100
+++ linux-2.6.24.softpanic/kernel/panic.c	2008-01-25 18:37:59.000000000 +0100
@@ -142,6 +142,66 @@ NORET_TYPE void panic(const char * fmt, 
 
 EXPORT_SYMBOL(panic);
 
+#ifdef CONFIG_SOFTPANIC
+NORET_TYPE void softpanic(const char *fmt, ...)
+{
+	long i;
+	static char buf[1024];
+	va_list args;
+#if defined(CONFIG_S390)
+	unsigned long caller = (unsigned long) __builtin_return_address(0);
+#endif
+
+	va_start(args, fmt);
+	vsnprintf(buf, sizeof(buf), fmt, args);
+	va_end(args);
+	printk(KERN_EMERG "Kernel panic - not syncing: %s\n", buf);
+
+	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+
+	if (!panic_blink)
+		panic_blink = no_blink;
+
+	if (panic_timeout > 0) {
+		/*
+		 * Delay timeout seconds before rebooting the machine.
+		 * We can't use the "normal" timers since we just panicked..
+		 */
+		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
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
+		printk(KERN_EMERG
+		       "Press Stop-A (L1-A) to return to the boot prom\n");
+	}
+#endif
+#if defined(CONFIG_S390)
+	disabled_wait(caller);
+#endif
+	for (i = 0;;) {
+		touch_softlockup_watchdog();
+		i += panic_blink(i);
+		msleep(1);
+		i++;
+	}
+}
+EXPORT_SYMBOL(softpanic);
+#endif
+
 /**
  *	print_tainted - return a string to represent the kernel taint state.
  *
-- 
Top 100 things you don't want the sysadmin to say:
15. now it's funny you should ask that, because I don't know either
