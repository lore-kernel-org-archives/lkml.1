Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZFPIyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZFPIyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZFPIyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:54:12 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:57321 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZFPIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:54:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=OXjdQUekTa78oyE2jdi1Q8Qy0R7Wgq8E/vizS4cv1c3JOIxUqo1aRiFFU443frZGX2
         x9K0ANASSGtcaucd0iTr0xLf4rewqrwz1ylPm3Q2pz3rxSOk8FmlRC1BkcURflsVJL0c
         OIGkqLhBTc11F/gZlPTBwIkCQK9Uw3dEZIegI=
MIME-Version: 1.0
Date: Tue, 16 Jun 2009 16:54:12 +0800
Message-ID: <a8e1da0906160154r3c7ab4d4u378efe4f5545e077@mail.gmail.com>
Subject: [PATCH] printk: add printk_delay to make messages readable for some 
	scenarios
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When syslog is not possible, at the same time there's no serial/net console
available, it will be hard to read the printk messages.
For example oops/panic/warning messages in shutdown phase.

Here add a printk delay feature, we can make each printk message
delay some milliseconds.

Setting the delay by proc/sysctl interface: /proc/sys/kernel/printk_delay

The value range from 0 - 10000, default value is 0

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
Documentation/sysctl/kernel.txt |    8 ++++++++
include/linux/kernel.h          |    2 ++
include/linux/sysctl.h          |    1 +
kernel/printk.c                 |   14 ++++++++++++++
kernel/sysctl.c                 |   12 ++++++++++++
5 files changed, 37 insertions(+)

--- linux-2.6.orig/kernel/printk.c	2009-06-16 11:07:15.000000000 +0800
+++ linux-2.6/kernel/printk.c	2009-06-16 11:31:01.000000000 +0800
@@ -638,6 +638,19 @@ static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];

+int printk_delay_msec;
+
+static inline void printk_delay(void)
+{
+	if (unlikely(printk_delay_msec)) {
+		int m = printk_delay_msec;
+		while (m--) {
+			mdelay(1);
+			touch_nmi_watchdog();
+		}
+	}
+}
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -647,6 +660,7 @@ asmlinkage int vprintk(const char *fmt,
 	char *p;

 	boot_delay_msec();
+	printk_delay();

 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
--- linux-2.6.orig/include/linux/kernel.h	2009-04-18 19:48:06.000000000 +0800
+++ linux-2.6/include/linux/kernel.h	2009-06-16 11:24:43.000000000 +0800
@@ -243,6 +243,8 @@ extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);

+extern int printk_delay_msec;
+
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
--- linux-2.6.orig/kernel/sysctl.c	2009-06-15 10:33:11.000000000 +0800
+++ linux-2.6/kernel/sysctl.c	2009-06-16 11:29:52.000000000 +0800
@@ -102,6 +102,7 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+static int ten_thousand = 10000;

 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -699,6 +700,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= KERN_PRINTK_DELAY,
+		.procname	= "printk_delay",
+		.data		= &printk_delay_msec,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &ten_thousand,
+	},
 #endif
 	{
 		.ctl_name	= KERN_NGROUPS_MAX,
--- linux-2.6.orig/include/linux/sysctl.h	2009-04-09 16:23:01.000000000 +0800
+++ linux-2.6/include/linux/sysctl.h	2009-06-16 12:30:14.000000000 +0800
@@ -163,6 +163,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_PRINTK_DELAY = 77,	/* int: tune printk delay*/
 };


--- linux-2.6.orig/Documentation/sysctl/kernel.txt	2009-06-15
10:33:07.000000000 +0800
+++ linux-2.6/Documentation/sysctl/kernel.txt	2009-06-16
12:29:18.000000000 +0800
@@ -297,6 +297,14 @@ send before ratelimiting kicks in.

 ==============================================================

+printk_delay:
+
+Delay each printk message in printk_delay milliseconds
+
+Value from 0 - 10000 is allowed.
+
+==============================================================
+
 randomize-va-space:

 This option can be used to select the type of process address
