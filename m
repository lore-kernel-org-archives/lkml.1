Return-Path: <linux-kernel-owner+w=401wt.eu-S1760375AbXGCSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375AbXGCSFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbXGCSFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 14:05:24 -0400
Received: from www.osadl.org ([213.239.205.134]:54289 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754659AbXGCSFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 14:05:23 -0400
Subject: [PATCH] NTP: remove clock_was_set() call to prevent deadlock
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@osdl.org>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Stable Team <stable@kernel.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 20:05:20 +0200
Message-Id: <1183485920.3291.28.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
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

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -122,7 +122,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(-NSEC_PER_SEC);
 			time_state = TIME_OOP;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: inserting leap second "
 					"23:59:60 UTC\n");
 		}
@@ -137,7 +136,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(NSEC_PER_SEC);
 			time_state = TIME_WAIT;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: deleting leap second "
 					"23:59:59 UTC\n");
 		}


