Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXE2W2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXE2W2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbXE2W23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:28:29 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2811 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXE2W22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:28:28 -0400
X-Server-Uuid: 20144BB6-FB76-4F11-80B6-E6B2900CA0D7
Subject: Re: b44: regression in 2.6.22 (resend)
From: "Gary Zambrano" <zambrano@broadcom.com>
To: "Michael Buesch" <mb@bu3sch.de>
cc: "Maximilian Engelhardt" <maxi@daemonizer.de>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Jeff Garzik" <jgarzik@pobox.com>, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <200705292245.22940.mb@bu3sch.de>
References: <20070525172431.60affaca@freepuppy>
 <200705281655.15105.mb@bu3sch.de>
 <1180448075.17146.12.camel@dhcp-10-12-136-115.broadcom.com>
 <200705292245.22940.mb@bu3sch.de>
Date: Tue, 29 May 2007 14:05:41 -0700
Message-ID: <1180472741.17711.19.camel@dhcp-10-12-136-115.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5)
X-WSS-ID: 6A4277733AC1638977-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-29 at 22:45 +0200, Michael Buesch wrote:
> On Tuesday 29 May 2007 16:14:35 Gary Zambrano wrote:
> > On Mon, 2007-05-28 at 16:55 +0200, Michael Buesch wrote:
> > > On Monday 28 May 2007 16:12:12 Maximilian Engelhardt wrote:
> > > > On Monday 28 May 2007, Michael Buesch wrote:
> > > > > Can you also test the following patch?
> > > > > I think there's a bug in b44 that is doesn't properly discard
> > > > > shared IRQs, so it might possibly generate a NAPI storm, dunno.
> > > > > Worth a try.
> > > > >
> > > > > Index: linux-2.6.22-rc3/drivers/net/b44.c
> > > > > ===================================================================
> > > > > --- linux-2.6.22-rc3.orig/drivers/net/b44.c	2007-05-27 23:01:44.000000000
> > > > > +0200 +++ linux-2.6.22-rc3/drivers/net/b44.c	2007-05-28 12:48:27.000000000
> > > > > +0200 @@ -911,6 +911,8 @@ static irqreturn_t b44_interrupt(int irq
> > > > >  	spin_lock(&bp->lock);
> > > > >
> > > > >  	istat = br32(bp, B44_ISTAT);
> > > > > +	if (istat == 0xFFFFFFFF)
> > > > > +		goto out; /* Shared IRQ not for us */
> > > > >  	imask = br32(bp, B44_IMASK);
> > > > >
> > > > >  	/* The interrupt mask register controls which interrupt bits
> > > > > @@ -942,6 +944,7 @@ irq_ack:
> > > > >  		bw32(bp, B44_ISTAT, istat);
> > > > >  		br32(bp, B44_ISTAT);
> > > > >  	}
> > > > > +out:
> > > > >  	spin_unlock(&bp->lock);
> > > > >  	return IRQ_RETVAL(handled);
> > > > >  }
> > > > 
> > > > I did try this patch on a affected kernel, but I didn't notice any big 
> > > > difference. Perhaps the kernel is a bit less slow during the test, but It's 
> > > > hard to tell.
> > > 
> > > Ok, but anyway. I think this is a bug and needs to be fixed this way. Gary?
> > > 
> > 
> > Thanks Michael.
> > No, I don't think this is a bug and it does not need to be fixed.
> 
> Are you sure? I'm not so sure, because
> 1) On bcm43xx the reverse engineers told us that the card
>    returns 0xFFFFFFFF for no-irq-pending. Since b44 and bcm43xx
>    are very similiar in IRQ and DMA I just thought it would
>    be the case there, too. Just guessing.
The b44 interrupt status reg returns a value of 0 if no interrupts are
pending. The b44 uses a mask to determine which bits (events) can
generate device interrupts on the system. If the masked interrupt status
register bits are not asserted, then the b44 will return to the system
with handled = 0. 
So, I think the way the b44 interrupt code is written should be ok and
not a bug. 


> 2) PCMCIA cards usually return all-ones if you try to read a
>    register of a card that's been removed. So it's good
>    practice to check for this and bail out early in the IRQ
>    path. Do PCMCIA cards (PC-card, not neccessarily a real
>    16bit PCMCIA card) for b44 exist?

I do not know of any pccard application of the b44. As far as I know
b44s live on motherboards and in the wireless soc.

Thanks,
Gary

