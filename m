Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbYLWOzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbYLWOzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:55:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbYLWOze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:55:34 -0500
Received: from mail.gmx.net ([213.165.64.20]:33348 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750758AbYLWOzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:55:33 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+ad2pwqTaa80YOj2JAyZurImt6yg27lQQDLLRR7a
	8tMZRuGmSL/2DR
Date: Tue, 23 Dec 2008 15:55:36 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <20081223140320.GH1614@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812231529080.5188@axis700.grange>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>
 <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de>
 <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de>
 <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de>
 <Pine.LNX.4.64.0812231157180.5188@axis700.grange> <20081223125015.GG1614@pengutronix.de>
 <Pine.LNX.4.64.0812231359030.5188@axis700.grange> <20081223140320.GH1614@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Sascha Hauer wrote:

> On Tue, Dec 23, 2008 at 02:14:12PM +0100, Guennadi Liakhovetski wrote:
> > On Tue, 23 Dec 2008, Sascha Hauer wrote:
> > 
> > > On Tue, Dec 23, 2008 at 12:21:54PM +0100, Guennadi Liakhovetski wrote:
> > > > Hi Sascha
> > > > 
> > > > On Tue, 23 Dec 2008, Sascha Hauer wrote:
> > > > 
> > > > > On Mon, Dec 22, 2008 at 09:10:03PM +0100, Guennadi Liakhovetski wrote:
> > > > > > 
> > > > > > Ok, so, what would we like to have there? We agree that the proper way to 
> > > > > > serve them is a irq-chip driver, right?
> > > > > 
> > > > > In case of the *_EOF interrupts when they can be used outside the idmac
> > > > > driver then yes. If not then not for the reasons I explained.
> > > > 
> > > > Wait a minute, are you suggesting to handle interrupts that are exported 
> > > > to client drivers and that are "internal" to ipu_idmac differently? Like 
> > > > exported once - properly using the irq chip machinery, and internal once 
> > > > just demux in the driver hiding them from the kernel?... Or have I 
> > > > misunderstood you? If this is indeed what you mean, then that doesn't 
> > > > sound like a good idea to me, sorry. Like you configure a chained handler, 
> > > > then when it is called on an IRQ, you check if the reason is bits 0, 1, or 
> > > > 2 you call generic_handle_irq(), for other bits you handle them 
> > > > internally... grrrr... 
> > > 
> > > I'm not suggesting that. The *_EOF registers are all 32 bits on the *same*
> > > register. And these 32 interrupts are inherently occupied by ipu_idmac.c
> > > as you cannot request a idmac channel without requesting this interrupt.
> > > So at the moment you are passing 32 bits of the same register through a
> > > chained interrupt handler and *all* these interrupts go to the very same
> > > interrupt handler.
> > > For the corresponding 32 error interrupts it's probably also the idmac
> > > engine that has to react to these interrupts, not the drivers using it.
> > > Not sure about the remaining assorted interrupts.
> > 
> > Yes, I understand that. So, you're suggesting to put all EOF interrupts 
> > under 1 irq-number. Just for example: now I have
> > 
> > 167:        351     ipu_irq  idmac
> > 174:        752     ipu_irq  idmac
> > 175:          0     ipu_irq  idmac
> > 230:          1     ipu_irq  csi
> > 
> > where 167 - camera IRQs, 174 - framebuffer (panning), 175 - overlay (ok, 
> > this one will go), 230 - CSI_EOF from IPU_INT_STAT_3 (ok, it is not used 
> > ATM, can go too).
> > 
> > So, there are at least two valid users of EOF interrupts. 
> 
> No, there are no two users, there is *one* user, namely idmac, as
> the output from /proc/interrupts clearly shows. The users are *not* the
> client drivers but the idmac code.
> 
> Hm, what else can I say that you understand what I mean?
> 
> Why would you dispatch one physical interrupt to 32 interrupts (only
> counting the *_EOF irqs) which all lead back to the same interrupt handler?
> 
> The client drivers are not interested in the interrupts, only the idmac
> code is. Even if they were, you provided a callback function for this
> case in your idmac interrupt handling code:
> 
> +	if (done && (desc->txd.flags & DMA_PREP_INTERRUPT) && callback)
> +		callback(callback_param);

Ok, fair enough, you can see all *_EOF interrupts as being consumed by one 
user - the dma channel driver. So then it is similar to a serial (or 
whatever else) driver handling multiple instances of the hardware on one 
system.

Let's consider what we would get, if we don't use the irq chip API:

1. we request two interrupts - function and error - normally using 
   request_irq in the ipu irq driver

2. in the dma channel driver you have to register new clients with the ipu 
   irq driver so it can call the dma channel driver EOF irq handler with 
   the correct argument - the number of interrupting DMA channel

3. on an interrupt you have to implement masking / unmasking / acking of 
   interrupts, list locking, whatever it takes yourself

so you end up with an API similar to ipu_request_irq() from Freescale... 
Yes, you can allocate your interrupt descriptors dynamically, you can save 
a few more bytes in every descriptor object... But is it all worth it?

Ok, we can make this differently:

1. I create a static constant array of virtual irq number <-> ipu irq bit 
   maps, with currently only two elements - for the framebuffer and the 
   camera, and use it in irq demultiplexing.

2. I increment NR_IRQS by two and put a comment explaining where to look 
   for implementing support for more IPU interrupts.

3. as new users come and implement support for more IPU interrupts, they 
   add entries to the array and increment NR_IRQS.

This way we add only as many irq descriptors as we really use, but the 
mapping becomes absolutely internal, so looking in /proc/interupts gives 
you little understanding of whose interrupts you see there.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
