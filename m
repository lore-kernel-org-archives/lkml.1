Return-Path: <linux-kernel-owner+w=401wt.eu-S932499AbXF1Wuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932499AbXF1Wuo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932438AbXF1Wub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:50:31 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:35239 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932429AbXF1Wu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:50:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X2TK97VJrxb/KGNRD+f3sRnvDGvrRlKTYmzdf84iHtg/EEYwxdXea0+/GisuPzASYQhlnMVFSuT7T+1Br5PQmm1tIWACce1j+biAlrXqxxqJDcOS/r7lOP/UuK7oKuxiM/+SaibCqkyiSpp4f4sNyuzDxA+nC9DavxV/QsoPxFg=  ;
X-YMail-OSG: hT4cxkUVM1kswnx0zhBPIHeJ5utXoVV_wfnyK2B5YvEKX5FxFKkaWg9xH3GHwbiXoDNAhygSNA--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCH] PXA27x UDC driver.
Date: Thu, 28 Jun 2007 15:44:32 -0700
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Li Yang-r58472 <LeoLi@freescale.com>
References: <20070628103619.GW13886@enneenne.com> <20070628141205.GA13886@enneenne.com> <20070628142949.02ca9eab.akpm@linux-foundation.org>
In-Reply-To: <20070628142949.02ca9eab.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706281544.32534.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By the way, there are three or four versions of a pxa27x UDC
driver floating around; which one is this?  One you updated?


It looks like it forked from the pxa2xx driver several years ago
but never got cleaned up ... e.g. it's a different controller,
so none of the comments relevant to earlier controller versions
(pxa250 rev a0 etc) could possibly apply, or even later ones
(like pxa255, effectively end-of-the-line for that UDC).

Quite a lot of the code issues in this driver are inherited from
some rather ancient code dating to ... 2.4.19-rmk7 kernels, if
I don't mis-recall.  Some of them are even specific to the now
obsolete "Lubbock" reference hardware.

In short:  whatever version of a pxa27x_udc driver gets submitted,
much cleanup seems *STILL* to be needed.



On Thursday 28 June 2007, Andrew Morton wrote:

> > --- a/arch/arm/mach-pxa/generic.c
> > +++ b/arch/arm/mach-pxa/generic.c
> > @@ -282,7 +282,11 @@ static struct resource pxa2xx_udc_resources[] = {
> >  static u64 udc_dma_mask = ~(u32)0;
> >  
> >  static struct platform_device udc_device = {
> > +#ifdef CONFIG_PXA27x
> > +	.name		= "pxa27x-udc",
> > +#else
> >  	.name		= "pxa2xx-udc",
> > +#endif
> 
> This looks odd.  The same driver presents itself under a different name
> according to a config option?

The PXA 27x platform devices should really have been in a
different file ... the PXA platform has been rather neglected,
since it effectively has no maintainer.

> 
> > + * This UDC hardware wants to implement a bit too much USB protocol, so
> > + * it constrains the sorts of USB configuration change events that work.
> > + * The errata for these chips are misleading; some "fixed" bugs from
> > + * pxa250 a0/a1 b0/b1/b2 sure act like they're still there.

And *STILL* people carry around comments from the pxa2xx_udc
code (for "x" in 1, 6, and mostly 5).

ISTR that every time someone has submitted a pxa27x driver I've
had to ask that obsolete comments be removed.   Still waiting...


> > +#undef	USE_DMA
> 
> So DMA is busted?

This driver was largely cut'n'paste from pxa2xx_udc, which
had to cope with errata which mostly meant that it couldn't
work.  Then there were *DESIGN BUGS* in the DMA, making it
not worth using in the most significant cases ... even in
the later chip revisions where DMA would allegedly work.

(Which reminds me, maybe I should just rip DMA out of the
pxa2xx_udc code ... nobody seems to have picked it up and
finished it, so there's no point in keeping that around.)

I'm told that DMA works better in pxa27x, and that at least
one version of the pxa27x_udc driver enabled it by default.
(For TX, if not RX where it's most useful...)  This would
seem not to be that version.


> > +#ifdef CONFIG_EMBEDDED
> > +/* few strings, and little code to use them */
> > +#undef	DEBUG
> > +#undef	UDC_PROC_FILE
> > +#endif
> 
> gag, this looks like a mess.  Thise sort of logic should be implemented in
> Kconfig, not in .c.

The debug file stuff *DOES* have a Kconfig hook... 


> > +#ifndef	enable_disconnect_irq
> > +#define	enable_disconnect_irq()		do {} while (0)
> > +#define	disable_disconnect_irq()	do {} while (0)
> > +#endif
> 
> hm, OK, I guess this is somewhere where a macro is appropriate.

Not really.  It's an artifact of a rather bizarre FPGA design
on the PXA25x reference design ("Lubbock"), which was very
gratuitously different from what Intel docs recommended.  The
normal case is that there is a single IRQ.

That stuff is long gone even from pxa2xx_udc ... and in any case,
the VBUS irqs should not be called "connect/disconnect", it's
just confusing to do that.


> > +					/* hardware sometimes neglects to tell
> > +					 * tell us about config change events,
> > +					 * so later ones may fail...
> > +					 */

Curious ... did that pxa255 erratum transfer somehow to the
newer pxa27x silicon?


> > +					WARN("config change %02x fail %d?\n",
> > +					     u.r.bRequest, i);
> > +					return;
> > +					/* TODO experiment:  if has_cfr,
> > +					 * hardware didn't ACK; maybe we
> > +					 * could actually STALL!
> > +					 */

Another comment that shouldn't be relevant on this driver.
ISTR that all PXA 27x chips have CFR.  It was new in PXA255,
which is why the pxa2xx_udc had to cope with its absence.


> HEX_DISPLAY2 gets different treatment from HEX_DISPLAY here.

Yeah, but all that stuff was specific to the Lubbock platform.
Best to just remove it.


> > +#define WARN(stuff...) printk(KERN_WARNING "udc: " stuff)
> > +#define INFO(stuff...) printk(KERN_INFO "udc: " stuff)
> 
> hrm.  Why does every driver in the tree need to invent its own boilerplate
> infrastructure?
> 
> can we use dev_warn() here or something?

That stuff dates from 2.4.19-rmk7 kernel support, which
significantly predates dev_warn().  ;)

- Dave



