Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXHKTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXHKTJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763252AbXHKS7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:59:39 -0400
Received: from 1wt.eu ([62.212.114.60]:1618 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762390AbXHKS7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:59:35 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184857.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:48:19 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Vincent Fortier <Vincent.Fortier1@EC.GC.CA>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 27/28] NTP: remove clock_was_set() call to prevent deadlock
Content-Disposition: inline; filename=0027-NTP-remove-clock_was_set-call-to-prevent-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The clock_was_set() call in seconds_overflow() which happens only when
leap seconds are inserted / deleted is wrong in two aspects:

1. it results in a call to on_each_cpu() with interrupts disabled
2. it is potential deadlock source vs. call_lock in smp_call_function()

The only possible side effect of the removal might be, that an absolute
CLOCK_REALTIME timer fires 1 second too late, in the rare case of leap
second deletion and an absolute CLOCK_REALTIME timer which expires in
the affected time frame. It will never fire too early.

This was probably observed by the reporter of a June 30th -> July 1st
hang: http://lkml.org/lkml/2007/7/3/

A similar problem was observed by Dave Jones, who provided a screen shot
with a lockdep back trace, which allowed to analyse the problem.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Vincent Fortier <Vincent.Fortier1@EC.GC.CA>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/time/ntp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 3afeaa3..64744bb 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -116,7 +116,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(-NSEC_PER_SEC);
 			time_state = TIME_OOP;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: inserting leap second "
 					"23:59:60 UTC
");
 		}
@@ -131,7 +130,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(NSEC_PER_SEC);
 			time_state = TIME_WAIT;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: deleting leap second "
 					"23:59:59 UTC
");
 		}
-- 
1.5.2.4

-- 
