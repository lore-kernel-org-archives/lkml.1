Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYJ3VWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYJ3VWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758799AbYJ3VVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:21:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55995 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758792AbYJ3VVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:21:54 -0400
Subject: Re: next-20081030: voyager compile busted
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20081030210704.GA25665@elte.hu>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au>
	 <20081030180323.GA13399@x200.localdomain>
	 <1225398287.19324.1.camel@localhost.localdomain>
	 <20081030205230.GO27407@elte.hu>
	 <1225400283.19324.6.camel@localhost.localdomain>
	 <20081030210704.GA25665@elte.hu>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:21:48 -0500
Message-Id: <1225401708.19324.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 22:07 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > Would you be interested in helping us out with such a project? It 
> > > would be a nice cleanup for sure.
> > 
> > Sure, I'd be interested in looking into that.
> > 
> > However, it won't help the problems since they're mostly compile 
> > breakages caused by tampering with the HAL API for x86 and not 
> > seeing that this affects various subarches. [...]
> 
> it would fix that problem largely because we'd no longer have such 
> 'HAL API' - we'd have runtime differences and function pointers.

Before you advocate this, think what it would entail.  Voyager replaces
(and has to replace because its not apic based) the entirety of smp.c
and smpboot.c ... they'd all have to be abstracted through function
pointers.

Originally I wanted to do this ... after all, it's the way solaris does
its SMP hal replacement as well, but a lot of argument on the mailing
lists back in 1998 convinced me that we didn't want to pay the pipeline
disruption penalty of a function pointer for every SMP operation.  I
know CPUs have become way faster over that decade, but I believe (feel
free to correct) that the pipeline disruption penalty of function
pointers has actually become worse, not better.

The subarchitectures, with their direct function replacement (and
consequent having to accept a particular one to compile with) was the
final compromise.

I really think you don't want voyager slowing down mainline SMP by even
a few percentage points?

> > [...]  Moving voyager to a quirk wouldn't fix that problem.
> 
> btw., Voyager would not be a "quirk" (putting it that way looks a bit 
> derogatory perhaps) - instead it would be a regular x86 platform, with 
> a couple of quirk handlers to handle Voyager specialities.
> 
> Look at how CONFIG_X86_VISWS works today for example: that option only 
> activates the quirk handlers - and a VISWS bzImage will boot fine on a 
> regular PC. This is a far more powerful way of handling x86 hardware 
> deviations than a full build-time thing. It makes it also far easier 
> to test - while we cannot test the _quirks_, we can easily test the 
> build and still boot it on regular PCs. (which makes it far more 
> likely for people to enable this option)
> 
> This principle was followed for all the x86 subarchitectures we've 
> converted already: visws and numaq is done, rdc3210 is basically there 
> already. (waiting for generic gpio bits to complete that fully - but 
> rdc otherwise has no differences from the generic arch code)
> 
> Voyager is certainly one of the most complex subarch cases, hence was 
> it left last :-)

Yes ... but the problem is that all the rest (even numa and visws) use
smp.c and smpboot.c.  That makes them essentially x86 apic systems with
a few quirks (which is ideal for a quirk based system).  Voyager
isn't ... it replaces the entire SMP HAL.

James


