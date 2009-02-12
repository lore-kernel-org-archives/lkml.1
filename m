Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbZBLMwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbZBLMwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758947AbZBLMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54460 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887AbZBLMui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/9] x86: MCE: Replace machine check events logged interval with ratelimit
Message-Id: <20090212124933.4E0463E666F@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: feature

Use a standard leaky bucket ratelimit for the machine check
warning print interval instead of waiting every check_interval. 
Also decrease the limit to twice per minute.
This interacts better with threshold interrupts because
they can happen more often than check_interval.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:17.000000000 +0100
@@ -28,6 +28,7 @@
 #include <linux/kdebug.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
+#include <linux/ratelimit.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/mce.h>
@@ -488,11 +489,11 @@
  */
 int mce_notify_user(void)
 {
+	/* Not more than two messages every minute */
+	static DEFINE_RATELIMIT_STATE(ratelimit, 60*HZ, 2);
+
 	clear_thread_flag(TIF_MCE_NOTIFY);
 	if (test_and_clear_bit(0, &notify_user)) {
-		static unsigned long last_print;
-		unsigned long now = jiffies;
-
 		wake_up_interruptible(&mce_wait);
 
 		/*
@@ -503,10 +504,8 @@
 		if (trigger[0] && !work_pending(&mce_trigger_work))
 			schedule_work(&mce_trigger_work);
 
-		if (time_after_eq(now, last_print + (check_interval*HZ))) {
-			last_print = now;
+		if (__ratelimit(&ratelimit))
 			printk(KERN_INFO "Machine check events logged\n");
-		}
 
 		return 1;
 	}
