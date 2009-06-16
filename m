Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbZFPMxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbZFPMxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZFPMxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:53:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbZFPMxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:53:02 -0400
Date: Tue, 16 Jun 2009 14:52:48 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090616125248.GA23541@localhost>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616090647.GD13771@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 11:06:47AM +0200, Ingo Molnar wrote:
> 
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > Linus,
> >     You probably didn't see this before merging.  Could you yank the
> > above two patches?  Miroslav (RH package maintainer for ntpd), has
> > voiced concerns that the SHIFT_PLL patch breaks the NTP design and is
> > worried it may negatively effect NTP networks of systems running with
> > different SHIFT_PLL values.
> > 
> > While the patch does greatly improve NTP convergence times, and so 
> > far no negative results have been seen in tests, its out of an 
> > abundance of caution and a desire to keep the adjtimex behavior 
> > stable that I requested Thomas and Ingo to hold off on merging 
> > this patch, while I work with Miroslav to see if we cannot get the 
> > same benefit by adjusting the userspace NTPd.

[..]

> Each OS should converge back to the correct time _as fast as 
> physically possible_. If this is a problem and if someone wants 
> crappy time and longer periods of convergence for some odd reason 
> then that header file change can be edited by hand even. It's not 
> like it's that hard to change, if there's genuine interest.
> 
> So i'm against any revert on this basis. If another basis comes up 
> we can reconsider of course. What do you think?

I think the most important one is following the NTP specification.

If Linux really needs to have the fastest PLL, could it be done by
modifying the time constant passed in adjtimex structure instead of
changing SHIFT_PLL? The PLL response will be exactly the same, but it
will allow the applications (and admins) to detect that it is
different than expected.

Something like:

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -425,6 +425,8 @@
 		time_constant = txc->constant;
 		if (!(time_status & STA_NANO))
 			time_constant += 4;
+		/* We want faster PLL */ 
+		time_constant -= 2;
 		time_constant = min(time_constant, (long)MAXTC);
 		time_constant = max(time_constant, 0l);
 	}

Thanks,

-- 
Miroslav Lichvar
