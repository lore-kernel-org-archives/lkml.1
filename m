Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYEGDgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYEGDgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 23:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbYEGDgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 23:36:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:62516 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYEGDgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 23:36:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=SsYe2bCNs+8Dz82VTMKFIamPgx8X05/vm67j6GkeXvnkQiBUngQQgvzRT/nQn9L2x2PW8V6ArH7UdUsfGevHnlhRoIT4BSNtOxmtnEXSIUpXAL0JLm9frN3jTG5NY7q0pcwC5N0/rOvcT1gcVkvLL+wr3vJXNOxhowPj2tJHMvI=
Date: Wed, 7 May 2008 00:39:33 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com
Subject: Re: x86: Clean up computation of HPET .mult variables
Message-ID: <20080507033931.GA5378@Pilar.virtua.com.br>
References: <20080505231016.GA29072@beyonder.ift.unesp.br> <1210031888.17132.85.camel@localhost.localdomain> <20080506021321.GA4928@Pilar.virtua.com.br> <1210044218.17132.109.camel@localhost.localdomain> <20080506125920.GA26295@beyonder.ift.unesp.br> <1210090880.17132.140.camel@localhost.localdomain> <20080506205003.GA3749@beyonder.ift.unesp.br> <1210126661.17132.223.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210126661.17132.223.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue  6.May'08 at 19:17:41 -0700, Daniel Walker wrote:
> 
> On Tue, 2008-05-06 at 17:50 -0300, Carlos R. Mafra wrote:
> > so there is no difference at all at this precision level!
> > 
> > Out of curiosity I computed the "exact" value by hand and
> > got 292935555.9 so we can't even talk about "error" because
> > the difference is in the extra digit not considered with
> > the precision I used to print the results.
> > 
> > And if you look at the patch to do computation using 
> > clocksource_hz2mult() you will see that it is uglier
> > than the simple call to div_sc(), as you have to
> > consider an extra variable hpet_freq and do an extra
> > do_div() together with an extra rounding.
> > 
> > So I think you will be ok with the patch now, right? :-)
> 
> Not yet ..

Ok.

> I used you patch with some formatting changes and I get,
> 
> clocksource_hpet.mult   walker = 292935555
> clocksource_hpet.mult my patch = 292935555
> 
> Same as yours .. just checking ;)

Good!

> Now I modify the shift value from 22 to 25 and I get this,
> 
> clocksource_hpet.mult   walker = 2343484437
> clocksource_hpet.mult my patch = 2343484446
> 
> I don't think this is due to rounding .. I'm not really sure why they're
> different .. I would assume the clocksource_hz2mult is more correct, but
> feel free to check into it if you want..

Heh, I trust those numbers because they imply that my patch is good :-)

Note that my hpet_period = 69841279 * 10^{-15} secs, then

mult/2^shift = ns/cyc = 69.841279 <-- period in nanoseconds

so, using Kcalc I get for shift 22 (the "exact" value, no rounding)

mult = 2^22 * 69.841279 = 292,935,555.875

while for shift = 25 I get 8 times that, or

mult = 2,343,484,447

So comparing with the numbers you quoted from your experiments
you will realize that the value you got with my patch is actually
10 times better, so your assumption about clocksource_hz2mult
being more correct is not good.

> The reason I'm messing with the shift is cause 22 is actually too low..
> For your period it can be 25, which would give better accuracy.

Is there some formula to decide which shift value is better to
a given period? IOW, how did you arrive at 25? Note that I
want to learn this, that's why I am asking.

> If you want to check the shift calculation I used it looks like this,

Hmm, it is more complicated than div_sc in my humble opinion.

> static inline u32 clocksource_hz2shift(u32 bits, u32 hz)
> {
>        u64 temp;
> 
>        for (; bits > 0; bits--) {
>                temp = (u64) NSEC_PER_SEC << bits;
>                do_div(temp, hz);
>                if ((temp >> 32) == 0)
>                        break;
>        }
>        return bits;
> }
> 
> Daniel
