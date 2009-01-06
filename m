Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbZAFKTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbZAFKTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 05:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbZAFKTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 05:19:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60187 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZAFKTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:19:31 -0500
Date: Tue, 6 Jan 2009 11:19:29 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 0/4 v6] i.MX31: dmaengine and framebuffer drivers
Message-ID: <20090106101929.GD18861@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@vger.kernel.org,
	linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Dan Williams <dan.j.williams@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange> <20090106090422.GC18861@pengutronix.de> <Pine.LNX.4.64.0901061021180.5393@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901061021180.5393@axis700.grange>
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
X-Uptime: 10:56:41 up 23 days, 14:24, 26 users,  load average: 1.23, 1.99,
	2.06
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 10:51:37AM +0100, Guennadi Liakhovetski wrote:
> Hi Sascha
> 
> On Tue, 6 Jan 2009, Sascha Hauer wrote:
> 
> > Hi Guennadi,
> > 
> > On Fri, Dec 26, 2008 at 06:11:13PM +0100, Guennadi Liakhovetski wrote:
> > > Hi,
> > > 
> > > This is version 6 of dmaengine and framebuffer drivers for i.MX31.
> > > 
> > > Changes since version 5: as requested by Sascha Hauer switched to dynamic 
> > > IPU IRQ mapping.
> > 
> > I tried to express that it's really odd that you demux your _internal_
> > interrupts as chained handlers.
> 
> Your last comment was:
> 
> > Preferably a way which does not involve introducing 100+ unused
> > interrupts.
> 
> which I have done. Now we're back to demux / not demux...

Can *please* anybody else say something to this issue to calm this down?
To make it easier for you please sign:

[ ] The code is fine the way it is. Sascha go home.
[ ] The code could be better, but hey, it works and the world is not
    perfect.
[ ] No, we shouldn't abuse chained interrupts for internal irq
    dispatching.

> 
> > Consider a network driver which has a
> > rx, tx and an error status bit, all of them can trigger an interrupt. A
> > you aware of a single driver that uses chained interrupts for this
> > case?
> > No, they don't have to, because all this happens inside one driver
> > and this can easily be dispatched in one interrupt handler. IMHO chained
> > interrupts only make sense when you have an interrupt source which
> > leaves your driver code and you don't know who might be interested in,
> > like the assorted non channel interrupts the IPU also provides.
> > 
> > I bet you'd never have the idea for such a code design without the
> > Freescale code as a sample.
> 
> Think about other IPU interrupts. For now I removed the CSI interrupt, but 
> it may well be needed at some point.

That's one of the use cases for chained interrupts, yes.

> Or any of overflow interrupts?

The overflow interrupts are channel interrupts and should be handled by
the idmac code. Who else should know how to recover from a channel
overflow?

> What 
> do we do then? Why shall we build in limitations from the beginning, when 
> there is an implementation already there, which doesn't have them? Sorry, 
> do not understand.
> 
> I know you proposed to dispatch all DMA EOF interrupts to one IRQ number 
> and (optionally / as required) others to single IRQs. But I like to see 
> single DMA sources as separate entries in /proc/interrupts, even if only 
> for debugging.

Then I propose to change all drivers this way. I want to see how
many interrupts in my network driver I get for errors, tx and so on, even
if only for debugging.

> 
> And no, it is not thanks to Freescals code, that I'm doing that, it's more 
> contrary to their code - they do not implement an irq_chip API and instead 
> add an API of their own.

Yes, I know, but it was their idea to treat the channel status bits as
interrupts, even if they invented their own API instead of using the
existing one.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
