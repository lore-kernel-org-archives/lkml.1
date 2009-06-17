Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZFQPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZFQPiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbZFQPis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:38:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59499 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZFQPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:38:47 -0400
Subject: Re: [GIT pull] ntp updates for 2.6.31
From: John Stultz <johnstul@us.ibm.com>
To: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090616125248.GA23541@localhost>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain>
	 <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
	 <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
	 <20090616090647.GD13771@elte.hu>  <20090616125248.GA23541@localhost>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 08:38:22 -0700
Message-Id: <1245253102.6067.94.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 14:52 +0200, Miroslav Lichvar wrote:
> On Tue, Jun 16, 2009 at 11:06:47AM +0200, Ingo Molnar wrote:
> > 
> > * john stultz <johnstul@us.ibm.com> wrote:
> > 
> > > Linus,
> > >     You probably didn't see this before merging.  Could you yank the
> > > above two patches?  Miroslav (RH package maintainer for ntpd), has
> > > voiced concerns that the SHIFT_PLL patch breaks the NTP design and is
> > > worried it may negatively effect NTP networks of systems running with
> > > different SHIFT_PLL values.
> > > 
> > > While the patch does greatly improve NTP convergence times, and so 
> > > far no negative results have been seen in tests, its out of an 
> > > abundance of caution and a desire to keep the adjtimex behavior 
> > > stable that I requested Thomas and Ingo to hold off on merging 
> > > this patch, while I work with Miroslav to see if we cannot get the 
> > > same benefit by adjusting the userspace NTPd.
> 
> [..]
> 
> > Each OS should converge back to the correct time _as fast as 
> > physically possible_. If this is a problem and if someone wants 
> > crappy time and longer periods of convergence for some odd reason 
> > then that header file change can be edited by hand even. It's not 
> > like it's that hard to change, if there's genuine interest.
> > 
> > So i'm against any revert on this basis. If another basis comes up 
> > we can reconsider of course. What do you think?
> 
> I think the most important one is following the NTP specification.
> 
> If Linux really needs to have the fastest PLL, could it be done by
> modifying the time constant passed in adjtimex structure instead of
> changing SHIFT_PLL? The PLL response will be exactly the same, but it
> will allow the applications (and admins) to detect that it is
> different than expected.
> 
> Something like:
> 
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -425,6 +425,8 @@
>  		time_constant = txc->constant;
>  		if (!(time_status & STA_NANO))
>  			time_constant += 4;
> +		/* We want faster PLL */ 
> +		time_constant -= 2;
>  		time_constant = min(time_constant, (long)MAXTC);
>  		time_constant = max(time_constant, 0l);
>  	}


It looks mathematically equivalent, although I've not had time to test
it yet. Probably needs a bigger comment :)

The nice thing with this version is that we're able to expose that the
behavior would be different then other systems, but the other side of
that coin might be that when the user specifies a time_constant value,
the interface will show a different one being used. This might cause
some bug reports saying the interface isn't responding properly, or
something. Although this is already the case for !STA_NANO, and so far
few have noticed.

thanks
-john


