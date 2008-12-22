Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbYLVUJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbYLVUJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 15:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753849AbYLVUJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 15:09:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:54751 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753686AbYLVUJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 15:09:50 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18irY1upsci3QAAbsnyV0pcczLrJLXe80XL0DifF4
	4CQ+AK1ePK9dI9
Date: Mon, 22 Dec 2008 21:10:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <20081222183753.GD1614@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812221942480.7796@axis700.grange>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>
 <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de>
 <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As you surely have seen, I just posted v5 of the patchset.

On Mon, 22 Dec 2008, Sascha Hauer wrote:

> On Mon, Dec 22, 2008 at 12:56:29PM +0100, Guennadi Liakhovetski wrote:
> > Hi Sascha,
> > 
> > Thanks for the review and for the comments! I'm fixing them all, except 
> > for a couple points which I'm not sure I agree with:
> > 
> > On Thu, 18 Dec 2008, Sascha Hauer wrote:
> > 
> > > Hi Guennadi,
> > > 
> > > On Thu, Dec 18, 2008 at 02:26:19PM +0100, Guennadi Liakhovetski wrote:
> > > > From: Guennadi Liakhovetski <lg@denx.de>
> > > > 
> > > > i.MX3x SoCs contain an Image Processing Unit, consisting of a Control
> > > > Module (CM), Display Interface (DI), Synchronous Display Controller (SDC),
> > > > Asynchronous Display Controller (ADC), Image Converter (IC), Post-Filter
> > > > (PF), Camera Sensor Interface (CSI), and an Image DMA Controller (IDMAC).
> > > > CM contains, among other blocks, an Interrupt Generator (IG) and a Clock
> > > > and Reset Control Unit (CRCU). This driver serves IDMAC and IG. They are
> > > > supported over dmaengine and irq-chip APIs respectively.
> > > > 
> > > > IDMAC is a specialised DMA controller, its DMA channels cannot be used for
> > > > general-purpose operations, even though it might be possible to configure
> > > > a memory-to-memory channel for memcpy operation. This driver will not work
> > > > with generic dmaengine clients, clients, wishing to use it must use
> > > > respective wrapper structures, they also must specify which channels they
> > > > require, as channels are hard-wired to specific IPU functions.
> > > 
> > > As a place for this driver /me votes for drivers/dma/ Though it does not
> > > seem like a perfect place for it, it still uses the API provided there.
> > 
> > Yes, I also considered that. Dan, would you accept that? What makes it 
> > defferent from other drivers/dma drivers, is that this one also has an irq 
> > driver.
> > 
> > > A general note: Can we get rid of the function names starting with an
> > > underscore?
> > 
> > Yeah... They are used pretty consistent now throughout the driver, and are 
> > used for functions internal, static, maybe only called once... But if you 
> > prefer, I can remove underscores, sure.
> > 
> > > > +/*
> > > > + * There can be only one, we could allocate it dynamically, but then we'd have
> > > > + * to add an extra parameter to some functions, and use something as ugly as
> > > > + *	struct ipu *ipu = to_ipu(to_idmac(ichan->dma_chan.device));
> > > 
> > > still you use it in one place
> > 
> > It is used in more than one place - implicitly in others. I did try to use 
> > the pointer everywhere in the new code where it wasn't too expensive, to 
> > make it at least easier if anyone ever decides to switch to dynamic 
> > allocation. So, I wouldn't throw away all those "ugly" calculations and 
> > replace them with the static variable, but if you think that'd be better, 
> > I can do that.
> 
> No, it was more the comment that was irritating me.

Hm, well, it could be removed of course, I hope this wouldn't be a 
K.O. criterium:-)

> > > > +		spin_lock_init(&ichan->lock);
> > > > +		mutex_init(&ichan->chan_mutex);
> > > 
> > > Having two locking methods for one dma channel looks like a recipe for
> > > trouble.
> > 
> > Why? You wouldn't take a mutex under spinlock, and the other way round is 
> > fine:-). I think both are needed - spinlock for ISR, atomic contexts for 
> > atomic operations like modifying registers, lists. And the mutex for 
> > sleeping contexts.
> 
> I just remember reading some document which said that using too many
> locks is not a good idea. Well I guess you're prepared for bug reports
> ;)

Sure, you can start now:-)

> > > > +#define IPU_IRQ_NR_FN_IRQS (32 + 32 + 24)
> > > > +#define IPU_IRQ_NR_ERR_IRQS (32 + 17)
> > > > +#define IPU_IRQ_NR_IRQS (IPU_IRQ_NR_ERR_IRQS + IPU_IRQ_NR_FN_IRQS)
> > > 
> > > Do we really need an interrupt handler behind each status bit the ipu
> > > has to offer? This looks quite expensive
> > 
> > What are you worried about? The size of irq_desc[]? Well, we could make 
> > error interrupts dependent on a CONFIG_ macro, and let drivers that need 
> > them select that option, because so far they are not used.
> 
> Sounds good, they are unused in the Freescale BSP aswell-
> 
> > Otherwise, I 
> > think it is good to have all those bits on separate IRQs. What would you 
> > do? Request only two IRQs - function and error and then demux them 
> > manually, reinventing the generic irq subsystem? Doesn't seem very optimal 
> > to me...
> 
> No indeed not. My concern is that of these 137 interrupts only 7 are
> used in the Freescale BSP which shoud be quite feature complete.
> I think we should check the potential use of these interrupts before
> adding ~10k of struct irq_desc to the kernel.
> What about the *_EOF interrupts? They are now demultiplexed in a chained
> interrupt handler and then merged back together to a single handler in
> ipu_idmac.c. Is there a potential use of these interrupts outside this file?

Ok, so, what would we like to have there? We agree that the proper way to 
serve them is a irq-chip driver, right? We could make error IRQs and 
new frame IRQs optional. That would leave 56 IRQs, would that be ok?

> I just had a short look at your framebuffer driver. Am I understanding
> it right that you setup two descriptors and pass them to the DMA engine
> alternately? Wouldn't it be easier to pass just one descriptor and chain
> the end to the beginning? I mean both descriptors read from the same
> memory anyway.

No, addresses are not necessarily the same. With panning addresses are 
different.

> Another thing is the overlay framebuffer. I think it's mainly useful to
> display video streams. Maybe it's better to implement this as a v4l
> device as unlike the framebuffer API the v4l API is designed to handle
> different image buffers.
> These things just popped up in my mind, I don't know if they are
> practical, I still have a quite limited understanding of the whole
> imaging stuff on the MX31.

You mean an output v4l device? I think overlays are handled by framebuffer 
drivers... But I'm also not quite sure about it, however, handling overlay 
as another framebuffer seems logical to me.

If there are no other problems with v5, could we maybe take it as a basis 
and then I would submit a patch to reduce the number of IRQs?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
