Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784AbYLWODe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbYLWODe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbYLWODZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:03:25 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58259 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYLWODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:03:24 -0500
Date: Tue, 23 Dec 2008 15:03:20 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ
	drivers
Message-ID: <20081223140320.GH1614@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>
References: <Pine.LNX.4.64.0812181406000.5510@axis700.grange> <Pine.LNX.4.64.0812181414280.5510@axis700.grange> <20081218225834.GJ20756@pengutronix.de> <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de> <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de> <Pine.LNX.4.64.0812231157180.5188@axis700.grange> <20081223125015.GG1614@pengutronix.de> <Pine.LNX.4.64.0812231359030.5188@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812231359030.5188@axis700.grange>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:19:57 up 9 days, 17:47, 10 users,  load average: 0.00, 0.00,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 02:14:12PM +0100, Guennadi Liakhovetski wrote:
> On Tue, 23 Dec 2008, Sascha Hauer wrote:
> 
> > On Tue, Dec 23, 2008 at 12:21:54PM +0100, Guennadi Liakhovetski wrote:
> > > Hi Sascha
> > > 
> > > On Tue, 23 Dec 2008, Sascha Hauer wrote:
> > > 
> > > > On Mon, Dec 22, 2008 at 09:10:03PM +0100, Guennadi Liakhovetski wrote:
> > > > > 
> > > > > Ok, so, what would we like to have there? We agree that the proper way to 
> > > > > serve them is a irq-chip driver, right?
> > > > 
> > > > In case of the *_EOF interrupts when they can be used outside the idmac
> > > > driver then yes. If not then not for the reasons I explained.
> > > 
> > > Wait a minute, are you suggesting to handle interrupts that are exported 
> > > to client drivers and that are "internal" to ipu_idmac differently? Like 
> > > exported once - properly using the irq chip machinery, and internal once 
> > > just demux in the driver hiding them from the kernel?... Or have I 
> > > misunderstood you? If this is indeed what you mean, then that doesn't 
> > > sound like a good idea to me, sorry. Like you configure a chained handler, 
> > > then when it is called on an IRQ, you check if the reason is bits 0, 1, or 
> > > 2 you call generic_handle_irq(), for other bits you handle them 
> > > internally... grrrr... 
> > 
> > I'm not suggesting that. The *_EOF registers are all 32 bits on the *same*
> > register. And these 32 interrupts are inherently occupied by ipu_idmac.c
> > as you cannot request a idmac channel without requesting this interrupt.
> > So at the moment you are passing 32 bits of the same register through a
> > chained interrupt handler and *all* these interrupts go to the very same
> > interrupt handler.
> > For the corresponding 32 error interrupts it's probably also the idmac
> > engine that has to react to these interrupts, not the drivers using it.
> > Not sure about the remaining assorted interrupts.
> 
> Yes, I understand that. So, you're suggesting to put all EOF interrupts 
> under 1 irq-number. Just for example: now I have
> 
> 167:        351     ipu_irq  idmac
> 174:        752     ipu_irq  idmac
> 175:          0     ipu_irq  idmac
> 230:          1     ipu_irq  csi
> 
> where 167 - camera IRQs, 174 - framebuffer (panning), 175 - overlay (ok, 
> this one will go), 230 - CSI_EOF from IPU_INT_STAT_3 (ok, it is not used 
> ATM, can go too).
> 
> So, there are at least two valid users of EOF interrupts. 

No, there are no two users, there is *one* user, namely idmac, as
the output from /proc/interrupts clearly shows. The users are *not* the
client drivers but the idmac code.

Hm, what else can I say that you understand what I mean?

Why would you dispatch one physical interrupt to 32 interrupts (only
counting the *_EOF irqs) which all lead back to the same interrupt handler?

The client drivers are not interested in the interrupts, only the idmac
code is. Even if they were, you provided a callback function for this
case in your idmac interrupt handling code:

+	if (done && (desc->txd.flags & DMA_PREP_INTERRUPT) && callback)
+		callback(callback_param);



> And you're 
> suggesting to put them on one interrupt, and even not as a shared IRQ with 
> two handlers - one interrupt with one handler with multiple sources / 
> users behind it... What likely will happen someone will add support for 
> YUV / RGB cameras and will want to use hardware processing for them, like 
> encoding and / or rotation, which will add DMA channels DMAIC_0, DMAIC_8, 
> DMAIC_6, DMAIC_10...

Who is going to handle these channels along with the interrupts? Right,
ipu_idmac.c.


> and you want to put them all on one IRQ?... What we 
> could improve in the above /proc/interrupts output is register interrupts 
> with different names to make distinguishing them easier.

No, the output of /proc/interrupts shows the correct situation. You can
take this as a hint for what is going wrong here.

> But I really 
> would not like to put them all together.
> 
> > > This is a framebuffer driver for i.MX31 SoCs. It only supports synchronous
> > > displays, overlay support is included but has never been tested.
> > 
> > No, it's not working. The overlay framebuffer maybe there, but it's
> > configured to be invisible.
> 
> Good, will remove it then.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
