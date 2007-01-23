Return-Path: <linux-kernel-owner+w=401wt.eu-S965538AbXAWWCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538AbXAWWCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965531AbXAWWBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:47 -0500
Received: from www.osadl.org ([213.239.205.134]:35979 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965507AbXAWWB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:29 -0500
Message-Id: <20070123211210.219222000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 46/46] Add SysRq-Q to print timer_list debug info
Content-Disposition: inline;
	filename=debugging-feature-sysrq-q-to-print-timers.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Add SysRq-Q to print pending timers and other timer info.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/sysrq.c    |   14 +++++++++++++-
 include/linux/hrtimer.h |    3 +++
 2 files changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6.20-rc4-mm1-bo/drivers/char/sysrq.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/drivers/char/sysrq.c
+++ linux-2.6.20-rc4-mm1-bo/drivers/char/sysrq.c
@@ -36,6 +36,7 @@
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
 #include <linux/irq.h>
+#include <linux/hrtimer.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -159,6 +160,17 @@ static struct sysrq_key_op sysrq_sync_op
 	.enable_mask	= SYSRQ_ENABLE_SYNC,
 };
 
+static void sysrq_handle_show_timers(int key, struct tty_struct *tty)
+{
+	sysrq_timer_list_show();
+}
+
+static struct sysrq_key_op sysrq_show_timers_op = {
+	.handler	= sysrq_handle_show_timers,
+	.help_msg	= "show-all-timers(Q)",
+	.action_msg	= "Show Pending Timers",
+};
+
 static void sysrq_handle_mountro(int key, struct tty_struct *tty)
 {
 	emergency_remount();
@@ -336,7 +348,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	/* o: This will often be registered as 'Off' at init time */
 	NULL,				/* o */
 	&sysrq_showregs_op,		/* p */
-	NULL,				/* q */
+	&sysrq_show_timers_op,		/* q */
 	&sysrq_unraw_op,		/* r */
 	&sysrq_sync_op,			/* s */
 	&sysrq_showstate_op,		/* t */
Index: linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/hrtimer.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/hrtimer.h
@@ -316,6 +316,9 @@ extern unsigned long ktime_divns(const k
 # define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
 #endif
 
+/* Show pending timers: */
+extern void sysrq_timer_list_show(void);
+
 /*
  * Timer-statistics info:
  */

--

