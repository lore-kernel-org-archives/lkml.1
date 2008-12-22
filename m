Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYLVL4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYLVL4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYLVL4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:56:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:34993 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753490AbYLVL4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:56:22 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19X7w8Vk15Xj0tTOJlCuclBfrmzAvLuzuZzBhNQS5
	c6luvTJLkg4HC2
Date: Mon, 22 Dec 2008 12:56:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <20081218225834.GJ20756@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812221240210.5241@axis700.grange>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>
 <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Thanks for the review and for the comments! I'm fixing them all, except 
for a couple points which I'm not sure I agree with:

On Thu, 18 Dec 2008, Sascha Hauer wrote:

> Hi Guennadi,
> 
> On Thu, Dec 18, 2008 at 02:26:19PM +0100, Guennadi Liakhovetski wrote:
> > From: Guennadi Liakhovetski <lg@denx.de>
> > 
> > i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
> > Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
> > Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
> > (PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
> > CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
> > and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
> > supported over dmaengine and irq-chip APIs respectively.
> > 
> > IDMAC is a specialised DMA controller, its DMA channels cannot be used for
> > general-purpose operations, even though it might be possible to configure
> > a memory-to-memory channel for memcpy operation. This driver will not work
> > with generic dmaengine clients, clients, wishing to use it must use
> > respective wrapper structures, they also must specify which channels they
> > require, as channels are hard-wired to specific IPU functions.
> 
> As a place for this driver /me votes for drivers/dma/ Though it does not
> seem like a perfect place for it, it still uses the API provided there.

Yes, I also considered that. Dan, would you accept that? What makes it 
defferent from other drivers/dma drivers, is that this one also has an irq 
driver.

> A general note: Can we get rid of the function names starting with an
> underscore?

Yeah... They are used pretty consistent now throughout the driver, and are 
used for functions internal, static, maybe only called once... But if you 
prefer, I can remove underscores, sure.

> > +/*
> > + * There can be only one, we could allocate it dynamically, but then we'd have
> > + * to add an extra parameter to some functions, and use something as ugly as
> > + *	struct ipu *ipu = to_ipu(to_idmac(ichan->dma_chan.device));
> 
> still you use it in one place

It is used in more than one place - implicitly in others. I did try to use 
the pointer everywhere in the new code where it wasn't too expensive, to 
make it at least easier if anyone ever decides to switch to dynamic 
allocation. So, I wouldn't throw away all those "ugly" calculations and 
replace them with the static variable, but if you think that'd be better, 
I can do that.

> > +		spin_lock_init(&ichan->lock);
> > +		mutex_init(&ichan->chan_mutex);
> 
> Having two locking methods for one dma channel looks like a recipe for
> trouble.

Why? You wouldn't take a mutex under spinlock, and the other way round is 
fine:-). I think both are needed - spinlock for ISR, atomic contexts for 
atomic operations like modifying registers, lists. And the mutex for 
sleeping contexts.

> > +#define IPU_IRQ_NR_FN_IRQS (32 + 32 + 24)
> > +#define IPU_IRQ_NR_ERR_IRQS (32 + 17)
> > +#define IPU_IRQ_NR_IRQS (IPU_IRQ_NR_ERR_IRQS + IPU_IRQ_NR_FN_IRQS)
> 
> Do we really need an interrupt handler behind each status bit the ipu
> has to offer? This looks quite expensive

What are you worried about? The size of irq_desc[]? Well, we could make 
error interrupts dependent on a CONFIG_ macro, and let drivers that need 
them select that option, because so far they are not used. Otherwise, I 
think it is good to have all those bits on separate IRQs. What would you 
do? Request only two IRQs - function and error and then demux them 
manually, reinventing the generic irq subsystem? Doesn't seem very optimal 
to me...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
