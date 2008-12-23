Return-Path: <linux-kernel-owner+w=401wt.eu-S1751850AbYLWNOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbYLWNOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 08:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYLWNOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 08:14:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:53101 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750984AbYLWNOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 08:14:07 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/oXTlN9kLoxW0d2mrUSieQDWzoPwxClfJ7LjJxSA
	AeCDnYW+9H07zu
Date: Tue, 23 Dec 2008 14:14:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <20081223125015.GG1614@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812231359030.5188@axis700.grange>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange>
 <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de>
 <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de>
 <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de>
 <Pine.LNX.4.64.0812231157180.5188@axis700.grange> <20081223125015.GG1614@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Sascha Hauer wrote:

> On Tue, Dec 23, 2008 at 12:21:54PM +0100, Guennadi Liakhovetski wrote:
> > Hi Sascha
> > 
> > On Tue, 23 Dec 2008, Sascha Hauer wrote:
> > 
> > > On Mon, Dec 22, 2008 at 09:10:03PM +0100, Guennadi Liakhovetski wrote:
> > > > 
> > > > Ok, so, what would we like to have there? We agree that the proper way to 
> > > > serve them is a irq-chip driver, right?
> > > 
> > > In case of the *_EOF interrupts when they can be used outside the idmac
> > > driver then yes. If not then not for the reasons I explained.
> > 
> > Wait a minute, are you suggesting to handle interrupts that are exported 
> > to client drivers and that are "internal" to ipu_idmac differently? Like 
> > exported once - properly using the irq chip machinery, and internal once 
> > just demux in the driver hiding them from the kernel?... Or have I 
> > misunderstood you? If this is indeed what you mean, then that doesn't 
> > sound like a good idea to me, sorry. Like you configure a chained handler, 
> > then when it is called on an IRQ, you check if the reason is bits 0, 1, or 
> > 2 you call generic_handle_irq(), for other bits you handle them 
> > internally... grrrr... 
> 
> I'm not suggesting that. The *_EOF registers are all 32 bits on the *same*
> register. And these 32 interrupts are inherently occupied by ipu_idmac.c
> as you cannot request a idmac channel without requesting this interrupt.
> So at the moment you are passing 32 bits of the same register through a
> chained interrupt handler and *all* these interrupts go to the very same
> interrupt handler.
> For the corresponding 32 error interrupts it's probably also the idmac
> engine that has to react to these interrupts, not the drivers using it.
> Not sure about the remaining assorted interrupts.

Yes, I understand that. So, you're suggesting to put all EOF interrupts 
under 1 irq-number. Just for example: now I have

167:        351     ipu_irq  idmac
174:        752     ipu_irq  idmac
175:          0     ipu_irq  idmac
230:          1     ipu_irq  csi

where 167 - camera IRQs, 174 - framebuffer (panning), 175 - overlay (ok, 
this one will go), 230 - CSI_EOF from IPU_INT_STAT_3 (ok, it is not used 
ATM, can go too).

So, there are at least two valid users of EOF interrupts. And you're 
suggesting to put them on one interrupt, and even not as a shared IRQ with 
two handlers - one interrupt with one handler with multiple sources / 
users behind it... What likely will happen someone will add support for 
YUV / RGB cameras and will want to use hardware processing for them, like 
encoding and / or rotation, which will add DMA channels DMAIC_0, DMAIC_8, 
DMAIC_6, DMAIC_10... and you want to put them all on one IRQ?... What we 
could improve in the above /proc/interrupts output is register interrupts 
with different names to make distinguishing them easier. But I really 
would not like to put them all together.

> > This is a framebuffer driver for i.MX31 SoCs. It only supports synchronous
> > displays, overlay support is included but has never been tested.
> 
> No, it's not working. The overlay framebuffer maybe there, but it's
> configured to be invisible.

Good, will remove it then.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
