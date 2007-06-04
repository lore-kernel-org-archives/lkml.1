Return-Path: <linux-kernel-owner+w=401wt.eu-S1754063AbXFDUvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063AbXFDUvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758070AbXFDUve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:51:34 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:49071 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757964AbXFDUvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:51:32 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 16:51:31 EDT
Date: Mon, 4 Jun 2007 23:44:18 +0300
From: Samuel Ortiz <samuel@sortiz.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       bjorn.helgaas@hp.com, Linus Walleij <linus.walleij@ericsson.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Message-ID: <20070604204418.GA4214@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <200706031200.07514.arvidjaar@mail.ru> <200706031216.06172.arvidjaar@mail.ru> <20070603231050.GA3829@sortiz.org> <200706040634.01622.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706040634.01622.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Ovh-Remote: 90.28.104.183 (aannecy-257-1-25-183.w90-28.abo.wanadoo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Linus Walleij, who wrote part of the smsc driver, to Cc:)

On Mon, Jun 04, 2007 at 06:33:56AM +0400, Andrey Borzenkov wrote:
> On Monday 04 June 2007, Samuel Ortiz wrote:
> > It seems that PnP tells us that the FIR port is at 0x2e8 while we're
> > expecting it at 0x2f8.
> > Could you apply this patch and then send me a dmesg dump of the
> > smsc-ircc initialisation ?
> >
> 
> here is dmesg:
> 
> Detected unconfigured Toshiba laptop with ALi ISA bridge SMSC IrDA chip, 
> pre-configuring device.
> Activated ALi 1533 ISA bridge port 0x02e8.
> Activated ALi 1533 ISA bridge port 0x02f8.
> pnp: Device 00:0a activated.
> smsc_ircc_pnp_probe(): fir 0x2e8 sir 0x100 dma 1 irq 5
Ok, FIR and SIR are definitey mixed up. So, now could you please try Bjorn's
patch ? I wonder if the curent code (without PnP) enables 0x2f8 as the SIR
port through the preconfiguration code...

Cheers,
Samuel.


> High: 0xef, Chip 0x1
> smsc_ircc_present(), addr 0x02e8 - no device found!
> pnp: Device 00:0a disabled.
> 
> And here is what PnP tells us:
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/options
> port 0x100-0x130, align 0xf, size 0x8, 16-bit address decoding
> irq 3,4,5,6,7,10,11 High-Edge
> dma 1,2,3 16-bit compatible
> Dependent: 01 - Priority acceptable
>    port 0x3f8-0x3f8, align 0x0, size 0x8, 16-bit address decoding
> Dependent: 02 - Priority acceptable
>    port 0x2e8-0x2e8, align 0x0, size 0x8, 16-bit address decoding
> Dependent: 03 - Priority acceptable
>    port 0x2f8-0x2f8, align 0x0, size 0x8, 16-bit address decoding
> Dependent: 04 - Priority acceptable
>    port 0x3e8-0x3e8, align 0x0, size 0x8, 16-bit address decoding
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> state = disabled
> {pts/1}% sudo sh -c 'echo activate > /sys/bus/pnp/devices/00:0a/resources'
> {pts/1}% cat /sys/bus/pnp/devices/00:0a/resources
> state = active
> io 0x100-0x107
> io 0x2e8-0x2ef
> irq 5
> dma 1
> 
> -andrey
> 
> > Cheers,
> > Samuel.
> >
> >
> > diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
> > index 9043bf4..d1d46a6 100644
> > --- a/drivers/net/irda/smsc-ircc2.c
> > +++ b/drivers/net/irda/smsc-ircc2.c
> > @@ -391,6 +391,9 @@ static int __init smsc_ircc_pnp_probe(struct pnp_dev
> > *dev, dma = pnp_dma(dev, 0);
> >  	irq = pnp_irq(dev, 0);
> >
> > +	printk("%s(): fir 0x%x sir 0x%x dma %d irq %d\n",
> > +	       __FUNCTION__, firbase, sirbase, dma, irq);
> > +
> >  	if (smsc_ircc_open(firbase, sirbase, dma, irq))
> >  		return -ENODEV;
> >
> > @@ -655,6 +658,7 @@ static int smsc_ircc_present(unsigned int fir_base,
> > unsigned int sir_base) irq     = (config & IRCC_INTERFACE_IRQ_MASK) >> 4;
> >
> >  	if (high != 0x10 || low != 0xb8 || (chip != 0xf1 && chip != 0xf2)) {
> > +		printk("High: 0x%x, Chip 0x%x\n", high, chip);
> >  		IRDA_WARNING("%s(), addr 0x%04x - no device found!\n",
> >  			     __FUNCTION__, fir_base);
> >  		goto out3;
> 
> 


