Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZFQRX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZFQRX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbZFQRXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:23:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49709 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZFQRXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:23:48 -0400
Date: Wed, 17 Jun 2009 19:23:25 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090617172325.GA32332@localhost>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245253102.6067.94.camel@jstultz-laptop>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 08:38:22AM -0700, John Stultz wrote:
> On Tue, 2009-06-16 at 14:52 +0200, Miroslav Lichvar wrote:
> > If Linux really needs to have the fastest PLL, could it be done by
> > modifying the time constant passed in adjtimex structure instead of
> > changing SHIFT_PLL? The PLL response will be exactly the same, but it
> > will allow the applications (and admins) to detect that it is
> > different than expected.
> > 
> > Something like:
> > 
> > --- a/kernel/time/ntp.c
> > +++ b/kernel/time/ntp.c
> > @@ -425,6 +425,8 @@
> >  		time_constant = txc->constant;
> >  		if (!(time_status & STA_NANO))
> >  			time_constant += 4;
> > +		/* We want faster PLL */ 
> > +		time_constant -= 2;
> >  		time_constant = min(time_constant, (long)MAXTC);
> >  		time_constant = max(time_constant, 0l);
> >  	}
> 
> 
> It looks mathematically equivalent, although I've not had time to test
> it yet. Probably needs a bigger comment :)
> 
> The nice thing with this version is that we're able to expose that the
> behavior would be different then other systems, but the other side of
> that coin might be that when the user specifies a time_constant value,
> the interface will show a different one being used. This might cause
> some bug reports saying the interface isn't responding properly, or
> something. Although this is already the case for !STA_NANO, and so far
> few have noticed.

I have checked the NTP sources and the returned time constant is used
only for reporting, at least for NTP it shouldn't cause any problems.

Returning correct time constant will be very useful if NTP developers
decide to use lower values or have it configurable as decreasing the
constant by another two will make the PLL unstable.

Still, I'd really like to see the original behavior restored. Most of
the users complaining about slow convergence are probably just hitting
the calibration problem, which needs to be fixed by other means than
making PLL faster. Also, users of other systems seem to be happy with
their slow convergence. At least that's the impression I have from NTP
lists.

Thanks,

-- 
Miroslav Lichvar
