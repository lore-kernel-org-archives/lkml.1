Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZA3LoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZA3LoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 06:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZA3Lnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 06:43:43 -0500
Received: from www.tglx.de ([62.245.132.106]:40337 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZA3Lnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 06:43:43 -0500
Message-Id: <20090130114306.814457946@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 30 Jan 2009 11:43:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Carsten Emde <cbe@osadl.org>
Subject: [patch-rt 2/5] commit 6626bff24578753808c8b5bd4f1619e14e980f0f
	Author: Thomas Gleixner <tglx@linutronix.de> Date: Sun Jan 25
	11:31:36 2009 +0100
References: <20090130114230.100052140@linutronix.de>
Content-Disposition: inline;
	filename=hrtimer-prevent-negative-expiry-value.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    hrtimer: prevent negative expiry value after clock_was_set()
    
    Impact: prevent false positive WARN_ON() in clockevents_program_event()
    
    clock_was_set() changes the base->offset of CLOCK_REALTIME and
    enforces the reprogramming of the clockevent device to expire timers
    which are based on CLOCK_REALTIME. If the clock change is large enough
    then the subtraction of the timer expiry value and base->offset can
    become negative which triggers the warning in
    clockevents_program_event().
    
    Check the subtraction result and set a negative value to 0.
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/hrtimer.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.26.8/kernel/hrtimer.c
===================================================================
--- linux-2.6.26.8.orig/kernel/hrtimer.c
+++ linux-2.6.26.8/kernel/hrtimer.c
@@ -520,6 +520,13 @@ static void hrtimer_force_reprogram(stru
 			continue;
 		timer = rb_entry(base->first, struct hrtimer, node);
 		expires = ktime_sub(timer->expires, base->offset);
+		/*
+		 * clock_was_set() has changed base->offset so the
+		 * result might be negative. Fix it up to prevent a
+		 * false positive in clockevents_program_event()
+		 */
+		if (expires.tv64 < 0)
+			expires.tv64 = 0;
 		if (expires.tv64 < cpu_base->expires_next.tv64)
 			cpu_base->expires_next = expires;
 	}


