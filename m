Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbZBLMn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbZBLMn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbZBLMkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:40:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49256 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759239AbZBLMke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:40:34 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212139.634236515@firstfloor.org>
In-Reply-To: <20090212139.634236515@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/10] x86: MCE: Always use separate work queue to run trigger
Message-Id: <20090212123928.ADA2B3E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:39:28 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Needed for bug fix in next patch

This relaxes the requirement that mce_notify_user has to run in process 
context. Useful for future changes, but also leads to cleaner
behaviour now. Now instead mce_notify_user can be called directly
from interrupt (but not NMI) context.

The work queue only uses a single global work struct, which can be done safely
because it is always free to reuse before the trigger function is executed.
This way no events can be lost.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:21.000000000 +0100
@@ -380,11 +380,17 @@
 	schedule_delayed_work(&mcheck_work, next_interval);
 }
 
+static void mce_do_trigger(struct work_struct *work)
+{
+	call_usermodehelper(trigger, trigger_argv, NULL, UMH_NO_WAIT);
+}
+
+static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
+
 /*
- * This is only called from process context.  This is where we do
- * anything we need to alert userspace about new MCEs.  This is called
- * directly from the poller and also from entry.S and idle, thanks to
- * TIF_MCE_NOTIFY.
+ * Notify the user(s) about new machine check events.
+ * Can be called from interrupt context, but not from machine check/NMI
+ * context.
  */
 int mce_notify_user(void)
 {
@@ -394,9 +400,14 @@
 		unsigned long now = jiffies;
 
 		wake_up_interruptible(&mce_wait);
-		if (trigger[0])
-			call_usermodehelper(trigger, trigger_argv, NULL,
-						UMH_NO_WAIT);
+
+		/*
+		 * There is no risk of missing notifications because
+		 * work_pending is always cleared before the function is
+		 * executed.
+		 */
+		if (trigger[0] && !work_pending(&mce_trigger_work))
+			schedule_work(&mce_trigger_work);
 
 		if (time_after_eq(now, last_print + (check_interval*HZ))) {
 			last_print = now;
