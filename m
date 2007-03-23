Return-Path: <linux-kernel-owner+w=401wt.eu-S2992607AbXCWX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992607AbXCWX2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 19:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992630AbXCWX2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 19:28:24 -0400
Received: from www.osadl.org ([213.239.205.134]:51725 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992607AbXCWX2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 19:28:14 -0400
Subject: Re: [4/5] 2.6.21-rc4: known regressions (v2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, David L <idht4n@hotmail.com>,
       john stultz <johnstul@us.ibm.com>
In-Reply-To: <1174689791.10840.377.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org>
	 <20070323185028.GR752@stusta.de>
	 <1174677338.10840.321.camel@localhost.localdomain>
	 <46045355.1020105@redhat.com>
	 <1174689791.10840.377.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Mar 2007 00:35:36 +0100
Message-Id: <1174692936.10840.392.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-23 at 23:43 +0100, Thomas Gleixner wrote:
> On Fri, 2007-03-23 at 18:23 -0400, Chuck Ebbert wrote:
> > Thomas Gleixner wrote:
> > > On Fri, 2007-03-23 at 19:50 +0100, Adrian Bunk wrote:
> > >> Subject    : gettimeofday increments too slowly
> > >> References : http://bugzilla.kernel.org/show_bug.cgi?id=8027
> > >> Submitter  : David L <idht4n@hotmail.com>
> > >> Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> > >>              commit 92c7e00254b2d0efc1e36ac3e45474ce1871b6b2
> > >> Handled-By : Thomas Gleixner <tglx@linutronix.de>
> > >> Status     : problem is being debugged
> > > 
> > > Patch available: http://lkml.org/lkml/2007/3/22/301
> > > 
> > > commit 6b3964cde70cfe6db79d35b42137431ef7d2f7e4
> > > 
> > 
> > For the other issue raised there, clock running too slow, I now
> > realize there is a similar report:
> > 
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=231626
> 
> That's a different one, AFAICT. Davids problem is probably caused by me
> breaking the TSC watchdog. 
> 
> /me orders paperbags prophylactically and goes back to look at the code

David,

can you please test the patch below ?

	tglx

--------------------->
Subject: [PATCH] clocksource: Fix thinko in watchdog selection

The watchdog implementation excludes low res / non continuous
clocksources from being selected as a watchdog reference
unintentionally.

Allow using jiffies/PIT as a watchdog reference as long as no better
clocksource is available. This is necessary to detect TSC breakage on
systems, which have no pmtimer/hpet.

The main goal of the initial patch (preventing to switch to highres/nohz
when no reliable fallback clocksource is available) is still guaranteed
by the checks in clocksource_watchdog().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 5b0e46b..fe5c7db 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -151,7 +151,8 @@ static void clocksource_check_watchdog(struct clocksource *cs)
 			watchdog_timer.expires = jiffies + WATCHDOG_INTERVAL;
 			add_timer(&watchdog_timer);
 		}
-	} else if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) {
+	} else {
+		if (cs->flags & CLOCK_SOURCE_IS_CONTINUOUS)
 			cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
 
 		if (!watchdog || cs->rating > watchdog->rating) {


