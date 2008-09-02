Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbYIBSl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbYIBSl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 14:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYIBSlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 14:41:49 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53868 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbYIBSls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 14:41:48 -0400
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>
In-Reply-To: <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
References: <48BB2116.1060904@lwfinger.net>
	 <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>
	 <48BC2A03.9000104@lwfinger.net>
	 <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>
	 <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 02 Sep 2008 11:41:47 -0700
Message-Id: <1220380907.3929.10.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 11:14 -0700, Thomas Gleixner wrote:
> On Tue, 2 Sep 2008, Linus Torvalds wrote:
> > > So what I'm working on is an algorithm, which is similar to the checks
> > > in the tsc_read_refs() function. That should allow us to detect
> > > whether one of the reads is way off by doing a min/max detection. In
> > > such a case we can either repeat the calibration or try to figure out
> > > whether the pmtimer / hpet can provide us with some useful reference.
> >
> > I think the most trivial approach would be to
> >
> >  - just keep track of the max TSC difference for each loop iteration.
> >
> >  - if the max TSC is bigger than 1% of the total TSC, then something is
> >    already seriously wrong (either we had very few loops indeed, or some
> >    of them were very expensive)
> 
> I went for summing up the deltas and build an average at the
> end. That's from a loop of 10 consecutive runs:
> 
> [    0.000000] TSC min 2160 max       3732 avg  3266 pitcnt 30614
> [    0.000000] TSC min 2160 max    1036164 avg  3299 pitcnt 30310
> [    0.000000] TSC min 2160 max    1032360 avg  3303 pitcnt 30277
> 
> [    0.000000] TSC min 2160 max  210453018 avg 69509 pitcnt 30260
> 
> Hit very late in the loop, as pitcnt is close to the others
> 
> [    0.000000] TSC min 2160 max       3708 avg  3265 pitcnt 30624
> [    0.000000] TSC min 2160 max       3720 avg  3265 pitcnt 30622
> [    0.000000] TSC min 2160 max    1062252 avg  3301 pitcnt 30287
> [    0.000000] TSC min 2160 max       3756 avg  3267 pitcnt 30605
> [    0.000000] TSC min 2160 max       3732 avg  3267 pitcnt 30605
> [    0.000000] TSC min 2136 max     989292 avg  3297 pitcnt 30324
> [    0.000000] TSC min 2136 max       3744 avg  3266 pitcnt 30612
> 
> [    0.000000] TSC min 2160 max   78042006 avg 78045 pitcnt  1001
> 
> This one hit early in the loop as pitcnt is pretty low.
> 
> The min value is pretty constant.
> 
> The max value for sane loops is in the range of 3708 - 3756, the
> average is between 3266 and 3267.
> 
> For those which have a ~500us maximum the average is still in a sane
> range. That seems to be a single glitch, which pushs the maximum, but
> does not really influence the average result.
> 
> The outstanding one is the 100ms (210 453 018 ticks), where the average
> is also off by factor 20.
> 
> I think that information is enough to give us a pretty precice idea
> when to discard the result. I'm currently looking at the hpet/pmtimer
> values for comparison and I should have a patch for testing ready
> later tonight.
> 
Sorry for joining the party this late...am still going through all my
mails.

Ok, so from what I understand until now, we will calibrate TSC against
PIT as was done in 32bit code and use that as default. If that fails to
give any sane results we will fall back to calibrating against PM_timer
or HPET ?
Thomas has already explained the problem with 32bit calibration ( i.e.
just against PIT and no checks for SMI's and all) but would like to
point that this problem is lot more worse in virtualized environment,
because we may fail to get sane values even from multiple loops of
calibrating against PIT. 
If we have a fall back mechanism to detect this SMI event, and then try
calibrating against PM timer or HPET we should be good. 

Anyways I will wait to see the patch.

Thanks,
Alok



