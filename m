Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXIVW3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXIVW3s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754262AbXIVW3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:29:10 -0400
Received: from www.osadl.org ([213.239.205.134]:35559 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753696AbXIVW3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:29:08 -0400
Message-Id: <20070922222118.995338086@linutronix.de>
References: <20070922220347.586903979@linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 22 Sep 2007 22:29:06 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 2/2] clockevents: remove the suspend/resume workaround^Wthinko
Content-Disposition: inline; filename=clockevents-remove-the-wrong-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In a desparate attempt to fix the suspend/resume problem on Andrews
VAIO I added a workaround which enforced the broadcast of the oneshot
timer on resume. This was actually resolving the problem on the VAIO
but was just a stupid workaround, which was not tackling the root
cause: the assignement of lower idle C-States in the ACPI processor_idle
code. The cpuidle patches, which utilize the dynamic tick feature and
go faster into deeper C-states exposed the problem again. The correct
solution is the previous patch, which prevents lower C-states across
the suspend/resume.

Remove the enforcement code, including the conditional broadcast timer
arming, which helped to pamper over the real problem for quite a time.
The oneshot broadcast flag for the cpu, which runs the resume code can
never be set at the time when this code is executed. It only gets set,
when the CPU is entering a lower idle C-State.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>

---
 kernel/time/tick-broadcast.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c	2007-09-23 00:00:59.000000000 +0200
+++ linux-2.6/kernel/time/tick-broadcast.c	2007-09-23 00:01:00.000000000 +0200
@@ -382,23 +382,8 @@ static int tick_broadcast_set_event(ktim
 
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
-	int cpu = smp_processor_id();
-
-	/*
-	 * If the CPU is marked for broadcast, enforce oneshot
-	 * broadcast mode. The jinxed VAIO does not resume otherwise.
-	 * No idea why it ends up in a lower C State during resume
-	 * without notifying the clock events layer.
-	 */
-	if (cpu_isset(cpu, tick_broadcast_mask))
-		cpu_set(cpu, tick_broadcast_oneshot_mask);
-
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
-
-	if(!cpus_empty(tick_broadcast_oneshot_mask))
-		tick_broadcast_set_event(ktime_get(), 1);
-
-	return cpu_isset(cpu, tick_broadcast_oneshot_mask);
+	return 0;
 }
 
 /*

-- 

