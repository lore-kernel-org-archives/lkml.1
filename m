Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZB0Hdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZB0Hdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbZB0Hdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:33:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33626 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZB0Hdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:33:38 -0500
Date: Fri, 27 Feb 2009 08:33:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
Message-ID: <20090227073321.GB13850@elte.hu>
References: <49A6F39F.9040801@krogh.cc> <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain> <49A6FEE2.90700@krogh.cc> <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> <49A70B24.6090706@krogh.cc> <1235685269.6811.11.camel@localhost.localdomain> <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain> <1235687483.6811.26.camel@localhost.localdomain> <alpine.LFD.2.00.0902261434390.3111@localhost.localdomain> <1235689182.6811.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235689182.6811.34.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> On Thu, 2009-02-26 at 14:40 -0800, Linus Torvalds wrote:
> > 
> > On Thu, 26 Feb 2009, john stultz wrote:
> > > 
> > > I'll kick up some of my own testing between these two releases to see if
> > > I can't find something similar.
> > 
> > Since the PIT timer read is possibly hw-dependent, it might be that you 
> > can't necessarily reproduce it on some random hardware.
> > 
> > How sensitive is ntpd to (stable) drift? IOW, if we get the calibration 
> > wrong, the TSC should still hopefully be very _stable_, it's just that the 
> > initial guesstimate for the frequency is off and ntp would have to correct 
> > for that.
>
> NTP can adjust the clock about +/-500ppm (so a 1000ppm range). 
> Past that it starts throwing errors.

Well, it will start throwing errors but still it will correct 
the clock and find the frequency delta between the host clock 
and the reference clock just fine, and converge in a couple of 
hours, correct?

500ppm is 0.05% of a frequency drift which is awfully small - 
thermal effects alone can cause such differences so it should 
not be anything out of the ordinary for ntpd.

> Part of the issue is that if the drift value changes in 
> between boots, NTPd can take a while to settle down on the 
> right freq. I suspect that's whats happening here, and should 
> the box be left alone for a few hours (maybe overnight) NTPd 
> will find the new drift correction the issue will go away.

If the default poll interval of 64 seconds is used then it can 
take that much time - so i'd sugges to decrease that to below 10 
seconds.

It's not like the frequency is changing rapidly here. The 
correction pattern to find is a very simple and very static and 
reliable multiplicator of ~1.000800 between the two frequencies.

Say the over-the-network reference clock ntpd follows has a 10 
msecs of intrinsic observation noise. For that 10 msecs noise to 
go down to the 10 ppm range [to the local but drifted time 
source which has ~10 ppm precision straight away], we need 
roughly 1000 samples. [simplified, fewer are enough in reality, 
especially if you have some known-to-have-converged-before 
cached value to start out with.]

1000 samples with 64 seconds intervals can take half a day to 
converge. 1000 samples with 1 second intervals takes just 15 
minutes to converge.

We'll improve in-kernel calibration but calibration noise in the 
0.05% range should be expected in some cases.

	Ingo
