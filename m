Return-Path: <linux-kernel-owner+w=401wt.eu-S941241AbXGaEjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941241AbXGaEjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940749AbXGaEct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34731 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940631AbXGaEcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:47 -0400
Date: Mon, 30 Jul 2007 21:33:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, torvalds@osdl.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, akpm@osdl.org,
       johnstul@us.ibm.com, mingo@elte.hu, Vincent.Fortier1@EC.GC.CA,
       Thomas Gleixner <tglx@linutronix.de>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 23/26] NTP: remove clock_was_set() call to prevent deadlock
Message-ID: <20070731043348.GX3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ntp-remove-clock_was_set-call-to-prevent-deadlock.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

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
 1 file changed, 2 deletions(-)

--- linux-2.6.21.6.orig/kernel/time/ntp.c
+++ linux-2.6.21.6/kernel/time/ntp.c
@@ -120,7 +120,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(-NSEC_PER_SEC);
 			time_state = TIME_OOP;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: inserting leap second "
 					"23:59:60 UTC\n");
 		}
@@ -135,7 +134,6 @@ void second_overflow(void)
 			 */
 			time_interpolator_update(NSEC_PER_SEC);
 			time_state = TIME_WAIT;
-			clock_was_set();
 			printk(KERN_NOTICE "Clock: deleting leap second "
 					"23:59:59 UTC\n");
 		}

-- 
