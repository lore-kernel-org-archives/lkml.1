Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYIWSRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYIWSRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbYIWSRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 14:17:15 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:57319 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926AbYIWSRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 14:17:15 -0400
Date: Tue, 23 Sep 2008 20:16:50 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20080923195342.52b1164d@mjolnir.drzeus.cx>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923195342.52b1164d@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Sep 2008 18:16:38.0034 (UTC) FILETIME=[85077720:01C91DA8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Mon, 22 Sep 2008 18:38:16 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> > The Atmel MCI controller can drive multiple cards through separate sets
> > of pins, but only one at a time. This patch adds support for
> > multiplexing access to the controller so that multiple card slots can be
> > used as if they were hooked up to separate mmc controllers.
> > 
> 
> This multiplexing shenanigans seems to be all the rage these days...

Apparently. I suppose it saves a few gates.

> >  
> >  static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> >  {
> > -	struct atmel_mci	*host = mmc_priv(mmc);
> > +	struct atmel_mci_slot	*slot = mmc_priv(mmc);
> > +	struct atmel_mci	*host = slot->host;
> >  
> >  	if (ios->clock) {
> >  		u32 clkdiv;
> 
> You forgot the most important part; how to handle the clock given two
> different requests.

I don't think I did. The set_ios() function merely calculates the value
of MR and stashes it away. It isn't written to the controller until
after the host has been claimed for a request.

> (This will also get a bit more painful when/if the core starts
> disabling the clock when a card is idle)

The atmel-mci driver already stops the clock between requests. Though I
don't understand why the core would care about clocks.

> > +
> > +	if (gpio_is_valid(slot->detect_pin)) {
> > +		int ret;
> > +
> > +		setup_timer(&slot->detect_timer, atmci_detect_change,
> > +				(unsigned long)slot);
> > +
> > +		ret = request_irq(gpio_to_irq(slot->detect_pin),
> > +				atmci_detect_interrupt,
> > +				IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> > +				"mmc-detect", slot);
> > +		if (ret) {
> > +			dev_dbg(&mmc->class_dev,
> > +				"could not request IRQ %d for detect pin\n",
> > +				gpio_to_irq(slot->detect_pin));
> > +			gpio_free(slot->detect_pin);
> > +			slot->detect_pin = -EBUSY;
> > +		}
> > +	}
> 
> Fall back to polling?

Probably, yes. Can I fall back to polling after the host has been
registered?

> > +	/* We need at least one slot to succeed */
> > +	ret = -1;
> > +	if (pdata->slot[0].bus_width)
> > +		ret &= atmci_init_slot(host, &pdata->slot[0],
> > +				MCI_SDCSEL_SLOT_A);
> > +	if (pdata->slot[1].bus_width)
> > +		ret &= atmci_init_slot(host, &pdata->slot[1],
> > +				MCI_SDCSEL_SLOT_B);
> > +	if (ret) {
> > +		ret = -ENODEV;
> > +		goto err_init_slot;
> >  	}
> 
> Memory/resource leak.

Hmm...I guess I was being too clever. I'll redo it with less clever
code.

Haavard
