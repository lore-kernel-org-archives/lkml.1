Return-Path: <linux-kernel-owner+w=401wt.eu-S1761251AbYJLNOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761251AbYJLNOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 09:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760886AbYJLNNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 09:13:47 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:52523 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbYJLNNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 09:13:45 -0400
Date: Sun, 12 Oct 2008 15:13:44 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] atmel-mci: support multiple mmc slots
Message-ID: <20081012151344.3f81ac75@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <20081012103958.7905356b@mjolnir.drzeus.cx>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
	<20081012103958.7905356b@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 12 Oct 2008 13:13:28.0054 (UTC) FILETIME=[50CE0960:01C92C6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> On Sun,  5 Oct 2008 18:21:27 +0200
> Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> 
> >  
> >  	if (ios->clock) {
> > +		unsigned int clock_min = ~0U;
> >  		u32 clkdiv;
> >  
> > -		if (!host->mode_reg)
> > +		spin_lock_bh(&host->lock);
> > +		if (!host->mode_reg) {
> >  			clk_enable(host->mck);
> > +			mci_writel(host, CR, MCI_CR_SWRST);
> > +			mci_writel(host, CR, MCI_CR_MCIEN);
> > +		}
> >  
> > -		/* Set clock rate */
> > -		clkdiv = DIV_ROUND_UP(host->bus_hz, 2 * ios->clock) - 1;
> > +		/*
> > +		 * Use mirror of ios->clock to prevent race with mmc
> > +		 * core ios update when finding the minimum.
> > +		 */
> > +		slot->clock = ios->clock;
> > +		for (i = 0; i < ATMEL_MCI_MAX_NR_SLOTS; i++) {
> > +			if (host->slot[i] && host->slot[i]->clock
> > +					&& host->slot[i]->clock < clock_min)
> > +				clock_min = host->slot[i]->clock;
> > +		}
> > +
> 
> Hmm... This does not cover the power up case. You can only ignore the
> other slot's clock setting if it is unpowered.

True. I don't have any boards which can control the power to the mmc
slots, so there's currently no way to avoid having a newly inserted
card exposed to a possibly high-speed clock while powered.

Once I get my hands on a board which can do that, I'll try to halt the
queue while powering up a new card and restart it when the clock speed
for the new card is known.

> > +		/* Calculate clock divider */
> > +		clkdiv = DIV_ROUND_UP(host->bus_hz, 2 * clock_min) - 1;
> >  		if (clkdiv > 255) {
> >  			dev_warn(&mmc->class_dev,
> >  				"clock %u too slow; using %lu\n",
> > -				ios->clock, host->bus_hz / (2 * 256));
> > +				clock_min, host->bus_hz / (2 * 256));
> >  			clkdiv = 255;
> >  		}
> >  
> 
> Has this ever happened, or is it just a bit defensive? :)
> 
> (not that there is something wrong with that)

It can happen if the controller is hooked up to a fast bus and fOD is
slow for whatever reason. And if it does, clkdiv will wrap around and
end up at a rate much faster than requested, so saturating it at the
maximum divider is the safe thing to do.

If the card ends up behaving strangely as a result of the clock
frequency being a bit off, at least you have a warning which may
indicate what's wrong.

> >  	default:
> >  		/*
> >  		 * TODO: None of the currently available AVR32-based
> >  		 * boards allow MMC power to be turned off. Implement
> >  		 * power control when this can be tested properly.
> > +		 *
> > +		 * We also need to hook this into the clock management
> > +		 * somehow so that newly inserted cards aren't
> > +		 * subjected to a fast clock before we have a chance
> > +		 * to figure out what the maximum rate is. Currently,
> > +		 * there's no way to avoid this, and there never will
> > +		 * be for boards that don't support power control.
> >  		 */
> >  		break;
> >  	}
> 
> Hmm again... As you've pointed out, this could be a problem. The card
> should survive getting jittery power during the insertion, but I
> wouldn't chance having the clock running at that point (which will
> happen if the other slot is populated).
> 
> I don't see a decent way of solving this, so I guess we'll have to
> stick our heads in the sand for now...

I think we'll just have to say that using multiplexing without power
control might cause problems with some cards.

> (did I mention that I think this slot multiplexing thing is a bad idea?)

Yes, I think you did. But note that this feature is optional (most
boards only request one slot), and I think people who actually have
multiple slots would rather use both of them than just one.

> > @@ -922,9 +1191,11 @@ static void atmci_write_data_pio(struct atmel_mci *host)
> >  			mci_writel(host, IDR, (MCI_NOTBUSY | MCI_TXRDY
> >  						| ATMCI_DATA_ERROR_FLAGS));
> >  			host->data_status = status;
> > +			data->bytes_xfered += nbytes;
> > +			smp_wmb();
> >  			atmci_set_pending(host, EVENT_DATA_ERROR);
> >  			tasklet_schedule(&host->tasklet);
> > -			break;
> > +			return;
> >  		}
> >  	} while (status & MCI_TXRDY);
> >  
> > @@ -937,29 +1208,26 @@ done:
> >  	mci_writel(host, IDR, MCI_TXRDY);
> >  	mci_writel(host, IER, MCI_NOTBUSY);
> >  	data->bytes_xfered += nbytes;
> > +	smp_wmb();
> >  	atmci_set_pending(host, EVENT_XFER_COMPLETE);
> >  }
> >  
> 
> I'm not sure I commented on this during the last run, but bytes_xfered
> should only be updated upon confirmation from the card, not as it goes
> out over the bus (there might be CRC error for instance).

You're right. I'll remove it -- it's updated when the card finishes its
busy signaling anyway.

Haavard
