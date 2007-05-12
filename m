Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbXELSqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbXELSqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612AbXELSq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:46:26 -0400
Received: from www.osadl.org ([213.239.205.134]:38056 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750833AbXELSqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:46:25 -0400
Subject: Re: [patch 3/3] clockevents: Fix resume logic - updated version
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
       linux-acpi@vger.kernel.org
In-Reply-To: <1178989302.22481.185.camel@localhost.localdomain>
References: <20070430102837.748238000@linutronix.de>
	 <20070511132846.5ebf4437.akpm@linux-foundation.org>
	 <200705112302.47726.rjw@sisk.pl> <200705112309.15996.rjw@sisk.pl>
	 <20070511235607.83ad0eb5.akpm@linux-foundation.org>
	 <1178959563.22481.126.camel@localhost.localdomain>
	 <20070512020056.a24cf472.akpm@linux-foundation.org>
	 <1178961489.22481.133.camel@localhost.localdomain>
	 <20070512030754.90488f79.akpm@linux-foundation.org>
	 <1178970253.22481.143.camel@localhost.localdomain>
	 <20070512095145.0cf58a57.akpm@linux-foundation.org>
	 <1178989302.22481.185.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 12 May 2007 20:49:32 +0200
Message-Id: <1178995772.22481.205.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 19:01 +0200, Thomas Gleixner wrote:
> On Sat, 2007-05-12 at 09:51 -0700, Andrew Morton wrote:
> > The locking in clocksource_resume_watchdog looks pretty pointless anyway.
> > Can't we just delete it?
> > 
> > The only thing it can race against is, conceivably,
> > 
> >         resumed = watchdog_resumed;
> >         if (unlikely(resumed))
> >                 watchdog_resumed = 0;
> > 
> > which could be solved by using test_and_clear_bit().
> 
> True. I'll redo it.

Here you go.

	tglx

------------------------------->
Subject: clocksource fix lock order in the resume path

lockdep complains about the lock nesting of clocksource and watchdog
lock in the resume path.

Change the resume marker to a bit operation and remove the lock from
this path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -74,7 +74,7 @@ static struct clocksource *watchdog;
 static struct timer_list watchdog_timer;
 static DEFINE_SPINLOCK(watchdog_lock);
 static cycle_t watchdog_last;
-static int watchdog_resumed;
+static unsigned long watchdog_resumed;
 
 /*
  * Interval: 0.5sec Threshold: 0.0625s
@@ -104,9 +104,7 @@ static void clocksource_watchdog(unsigned long data)
 
 	spin_lock(&watchdog_lock);
 
-	resumed = watchdog_resumed;
-	if (unlikely(resumed))
-		watchdog_resumed = 0;
+	resumed = test_and_clear_bit(0, &watchdog_resumed);
 
 	wdnow = watchdog->read();
 	wd_nsec = cyc2ns(watchdog, (wdnow - watchdog_last) & watchdog->mask);
@@ -151,9 +149,7 @@ static void clocksource_watchdog(unsigned long data)
 }
 static void clocksource_resume_watchdog(void)
 {
-	spin_lock(&watchdog_lock);
-	watchdog_resumed = 1;
-	spin_unlock(&watchdog_lock);
+	set_bit(0, &watchdog_resumed);
 }
 
 static void clocksource_check_watchdog(struct clocksource *cs)


