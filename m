Return-Path: <linux-kernel-owner+w=401wt.eu-S1422924AbXBATGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422924AbXBATGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 14:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422927AbXBATGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 14:06:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43104 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422924AbXBATGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 14:06:24 -0500
Date: Thu, 1 Feb 2007 20:04:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Cc: Mattia Dongili <malattia@linux.it>
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070201190431.GA12333@elte.hu>
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070131215241.GB2890@inferi.kami.home> <20070131232130.GC4137@inferi.kami.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131232130.GC4137@inferi.kami.home>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -5.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-5.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mattia Dongili <malattia@linux.it> wrote:

> > Full dmesg and config:
> > http://oioio.altervista.org/linux/nohz_soft-lockup.dmesg
> > http://oioio.altervista.org/linux/config-2.6.20-rc6-mm3-1
> > 
> > As a side note the process becomes slower and slower as it proceeds, 
> > it's definitely noticeable during my iptables rules setup (nothing 
> > that complex, just default policies and subnet/lan accept rules). 
> > Building with NO_HZ=n right now.
> 
> yes, slowness is gone. Any useful information I can provide?

thanks for reporting this - i'll try your config. There's one fix ontop 
of -mm3 - see below - but i'm not sure it's related, it addresses resume 
problems.

	Ingo

---
 kernel/timer.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -1120,8 +1120,9 @@ static int timekeeping_resume(struct sys
 
 	if (now && (now > timekeeping_suspend_time)) {
 		unsigned long sleep_length = now - timekeeping_suspend_time;
+
 		xtime.tv_sec += sleep_length;
-		jiffies_64 += (u64)sleep_length * HZ;
+		wall_to_monotonic.tv_sec -= sleep_length;
 	}
 	/* re-base the last cycle value */
 	clock->cycle_last = clocksource_read(clock);
@@ -1130,7 +1131,7 @@ static int timekeeping_resume(struct sys
 	warp_check_clock_was_changed();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	touch_softlockup_watchdog();
 	/* Resume hrtimers */
 	clock_was_set();
 
