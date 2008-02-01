Return-Path: <linux-kernel-owner+w=401wt.eu-S1762104AbYBAXnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762104AbYBAXnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbYBAXnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:43:03 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56992 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759896AbYBAXnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:43:02 -0500
Date: Sat, 2 Feb 2008 00:43:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Sterba <dsterba@suse.cz>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jkosina@suse.cz, benm@symmetric.co.nz, stephen@symmetric.co.nz
Subject: Re: [PATCH] ipwireless: driver for 3G PC Card
Message-ID: <20080201234315.GA1761@elf.ucw.cz>
References: <20080128171929.GA3906@ds.suse.cz> <20080130134046.GB5139@elf.ucw.cz> <200802011621.27239.dsterba@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802011621.27239.dsterba@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +static irqreturn_t ipwireless_handle_v1_interrupt(int irq,
> > > +						  struct ipw_hardware *hw)
> > > +{
> > > +	unsigned short irqn;
> > > +	unsigned short ack;
> > > +
> > > +	irqn = inw(hw->base_port + IOIR);
> > > +
> > > +	/* Check if card is present */
> > > +	if (irqn == (unsigned short) 0xFFFF) {
> > > +		if (++hw->bad_interrupt_count >= 100) {
> > > +			/*
> > > +			 * It is necessary to disable the interrupt at this
> > > +			 * point, or the kernel hangs, interrupting repeatedly
> > > +			 * forever.
> > > +			 */
> > > +			hw->irq = irq;
> > > +			hw->removed = 1;
> > > +			disable_irq_nosync(irq);
> > > +			printk(KERN_DEBUG IPWIRELESS_PCCARD_NAME
> > > +					": Mr. Fluffy is not happy!\n");
> > > +		}
> > > +		return IRQ_HANDLED;
> >
> > Not sure how this is supposed to work. If you assume unshared
> > interrupts, it should be possible to return something and make core
> > care.
> >
> > If you are assuming shared interrupts, either you should disable on
> > first 0xFFFF (are you sure cast is needed, btw?), or not at all,
> > because it could be the other device sedning you 100 of those...
> >
> > ...so which one is it?
> 
> Shared. It'll check if device has interrupt pending, else exit.

can you remove bad_interrupt_count? It seems very random in presence
of shared interrupt.

> > > +static int config_ipwireless(struct ipw_dev *ipw)
> > > +{
> > > +	struct pcmcia_device *link = ipw->link;
> > > +	int ret;
> > > +	config_info_t conf;
> > > +	tuple_t tuple;
> > > +	unsigned short buf[64];
> > > +	cisparse_t parse;
> > > +	unsigned short cor_value;
> > > +	win_req_t reqAM;
> > > +	win_req_t reqCM;
> >
> > Hiding structs BehindTypedefsIsEvil.
> 
> Unfortunatelly PCMCIA subsystem is full of these and all drivers use them. 
> I'll stay consistent for now.

Sorry if they were not yours.

> Updated patch v4 will follow.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
