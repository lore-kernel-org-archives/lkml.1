Return-Path: <linux-kernel-owner+w=401wt.eu-S933841AbXGSMPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933841AbXGSMPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 08:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758471AbXGSMPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 08:15:35 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:35849 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911AbXGSMPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 08:15:35 -0400
Message-ID: <469F55D0.4050203@ah.jp.nec.com>
Date: Thu, 19 Jul 2007 21:15:12 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
CC: k-miyoshi@cb.jp.nec.com
Subject: [patch] add kdump_after_notifier
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In latest kernel, we can't use panic_notifier_list if kdump is enabled.
panic_notifier_list is very useful function for debug, failover, etc...

So this patch adds a control file /proc/sys/kernel/dump_after_notifier
and resolves a problem users can not use both kdump and panic_notifier_list
at the same time.

kdump_after_notifier = 0
 -> panic()
    -> crash_kexec(NULL)

kdump_after_notifier = 1
 -> panic()
    -> atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
    -> crash_kexec(NULL)


Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
Signed-off-by: Kazuto Miyoshi <k-miyoshi@cb.jp.nec.com>
---

diff -uprN linux-2.6.22.orig/include/linux/kexec.h
linux-2.6.22/include/linux/kexec.h
--- linux-2.6.22.orig/include/linux/kexec.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/include/linux/kexec.h	2007-07-19 18:55:04.236000000 +0900
@@ -123,6 +123,7 @@ int kexec_should_crash(struct task_struc
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
+extern int kdump_after_notifier;

 #ifndef kexec_flush_icache_page
 #define kexec_flush_icache_page(page)
@@ -160,5 +161,6 @@ struct pt_regs;
 struct task_struct;
 static inline void crash_kexec(struct pt_regs *regs) { }
 static inline int kexec_should_crash(struct task_struct *p) { return 0; }
+#define kdump_after_notifier 0
 #endif /* CONFIG_KEXEC */
 #endif /* LINUX_KEXEC_H */
diff -uprN linux-2.6.22.orig/include/linux/sysctl.h
linux-2.6.22/include/linux/sysctl.h
--- linux-2.6.22.orig/include/linux/sysctl.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/include/linux/sysctl.h	2007-07-19 18:55:04.260000000 +0900
@@ -165,6 +165,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_KDUMP_AFTER_NOTIFIER=77, /* int: kdump after panic_notifier */
 };


diff -uprN linux-2.6.22.orig/kernel/kexec.c linux-2.6.22/kernel/kexec.c
--- linux-2.6.22.orig/kernel/kexec.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/kernel/kexec.c	2007-07-19 18:55:04.304000000 +0900
@@ -22,6 +22,7 @@
 #include <linux/hardirq.h>
 #include <linux/elf.h>
 #include <linux/elfcore.h>
+#include <linux/sysctl.h>

 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -31,6 +32,7 @@

 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t* crash_notes;
+int kdump_after_notifier;

 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
@@ -1123,6 +1125,30 @@ void crash_save_cpu(struct pt_regs *regs
 	final_note(buf);
 }

+#ifdef CONFIG_SYSCTL
+static ctl_table kdump_after_notifier_table[] = {
+	{
+		.ctl_name = KERN_KDUMP_AFTER_NOTIFIER,
+		.procname = "kdump_after_notifier",
+		.data = &kdump_after_notifier,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = &proc_dointvec,
+	},
+	{ .ctl_name = 0 }
+};
+
+static ctl_table kexec_sys_table[] = {
+	{
+		.ctl_name = CTL_KERN,
+		.procname = "kernel",
+		.mode = 0555,
+		.child = kdump_after_notifier_table,
+	},
+	{ .ctl_name = 0 }
+};
+#endif
+
 static int __init crash_notes_memory_init(void)
 {
 	/* Allocate memory for saving cpu registers. */
@@ -1132,6 +1158,9 @@ static int __init crash_notes_memory_ini
 		" states failed\n");
 		return -ENOMEM;
 	}
+#ifdef CONFIG_SYSCTL
+	register_sysctl_table(kexec_sys_table, 0);
+#endif
 	return 0;
 }
 module_init(crash_notes_memory_init)
diff -uprN linux-2.6.22.orig/kernel/panic.c linux-2.6.22/kernel/panic.c
--- linux-2.6.22.orig/kernel/panic.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/kernel/panic.c	2007-07-19 18:55:04.340000000 +0900
@@ -85,7 +85,8 @@ NORET_TYPE void panic(const char * fmt,
 	 * everything else.
 	 * Do we want to call this before we try to display a message?
 	 */
-	crash_kexec(NULL);
+	if (!kdump_after_notifier)
+		crash_kexec(NULL);

 #ifdef CONFIG_SMP
 	/*
@@ -98,6 +99,8 @@ NORET_TYPE void panic(const char * fmt,

 	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);

+	crash_kexec(NULL);
+
 	if (!panic_blink)
 		panic_blink = no_blink;



