Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbYAaIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbYAaIzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 03:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765946AbYAaIzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 03:55:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765567AbYAaIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 03:55:18 -0500
Subject: Re: Hang in work_resched
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <3d8471ca0801301454l56dd8607g25aad3ac3cd88e75@mail.gmail.com>
References: <3d8471ca0801291430n68c0a845u1b24a590df8360f4@mail.gmail.com>
	 <3d8471ca0801301454l56dd8607g25aad3ac3cd88e75@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 09:55:10 +0100
Message-Id: <1201769710.28547.248.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 23:54 +0100, Guillaume Chazarain wrote:
> On Jan 29, 2008 11:30 PM, Guillaume Chazarain <guichaz@gmail.com> wrote:
> >  =======================
> > gnome-termina S 00000027     0  2201      1
> >        f6711fb0 00200082 cb330d62 00000027 f664105c 00000b1e 00000000 cb331880
> >        00000027 f660d780 009e3840 080ab7d8 080ab298 f6711000 c0103e7e 009e3840
> >        000e0002 00000002 080ab7d8 080ab298 bfb41be8 080ab7d8 0000007b c010007b
> > Call Trace:
> >  [<c0103e7e>] work_resched+0x5/0x16
> >  =======================
> >
> > This corresponds to the cli instruction:
> > c0103e7e:       fa                      cli
> 
> I bisected it, and the resulting commit is appended. Rerverting this
> commit applies cleanly on today's git
> (dd430ca20c40ecccd6954a7efd13d4398f507728) and makes the hang go away
> -:)

> commit 37bb6cb4097e29ffee970065b74499cbf10603a3

Does this patch from thomas fix it as well?

---

From: Thomas Gleixner <tglx@linutronix.de>

I justed walked trough the code, which updates xtime _AND_
wall_to_monotonic w/o updating xtime_cache:

There are a couple of places missing the xtime_cache update. 

Signed-off-by: Thomas Gleixner <tglx@linuxtronix.de>
---
 include/linux/time.h      |    1 +
 kernel/time.c             |    1 +
 kernel/time/timekeeping.c |    6 ++++--
 3 files changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/time.h
===================================================================
--- linux-2.6.orig/include/linux/time.h
+++ linux-2.6/include/linux/time.h
@@ -122,6 +122,7 @@ extern void monotonic_to_bootbased(struc
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_is_continuous(void);
 extern void update_wall_time(void);
+extern void update_xtime_cache(u64 nsec);
 
 /**
  * timespec_to_ns - Convert timespec to nanoseconds
Index: linux-2.6/kernel/time.c
===================================================================
--- linux-2.6.orig/kernel/time.c
+++ linux-2.6/kernel/time.c
@@ -129,6 +129,7 @@ static inline void warp_clock(void)
 	write_seqlock_irq(&xtime_lock);
 	wall_to_monotonic.tv_sec -= sys_tz.tz_minuteswest * 60;
 	xtime.tv_sec += sys_tz.tz_minuteswest * 60;
+	update_xtime_cache(0);
 	write_sequnlock_irq(&xtime_lock);
 	clock_was_set();
 }
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -47,7 +47,7 @@ struct timespec wall_to_monotonic __attr
 static unsigned long total_sleep_time;		/* seconds */
 
 static struct timespec xtime_cache __attribute__ ((aligned (16)));
-static inline void update_xtime_cache(u64 nsec)
+void update_xtime_cache(u64 nsec)
 {
 	xtime_cache = xtime;
 	timespec_add_ns(&xtime_cache, nsec);
@@ -145,6 +145,7 @@ int do_settimeofday(struct timespec *tv)
 
 	set_normalized_timespec(&xtime, sec, nsec);
 	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
+	update_xtime_cache(0);
 
 	clock->error = 0;
 	ntp_clear();
@@ -252,8 +253,8 @@ void __init timekeeping_init(void)
 	xtime.tv_nsec = 0;
 	set_normalized_timespec(&wall_to_monotonic,
 		-xtime.tv_sec, -xtime.tv_nsec);
+	update_xtime_cache(0);
 	total_sleep_time = 0;
-
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 }
 
@@ -290,6 +291,7 @@ static int timekeeping_resume(struct sys
 	}
 	/* Make sure that we have the correct xtime reference */
 	timespec_add_ns(&xtime, timekeeping_suspend_nsecs);
+	update_xtime_cache(0);
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
 	clock->error = 0;


