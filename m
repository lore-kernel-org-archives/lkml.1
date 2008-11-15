Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYKOX6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYKOX6R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 18:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYKOX6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 18:58:00 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57077 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbYKOX57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 18:57:59 -0500
Date: Sat, 15 Nov 2008 23:57:39 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 7/7] SDHCI: Add change_clock callback for glue drivers
Message-ID: <20081115235739.GB9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk> <20081103201011.011975583@fluff.org.uk> <20081114232021.183de8d9@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114232021.183de8d9@mjolnir.drzeus.cx>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 11:20:21PM +0100, Pierre Ossman wrote:
> On Mon, 03 Nov 2008 20:09:51 +0000
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > Add a change_clock callback to allow drivers to update
> > device specific clock selections and control registers
> > when there is a change in clock.
> > 
> > Move the main part of sdhci_set_clock() to a new routine
> > which can be called by the glue drivers to do the sdhci
> > standard clock management.
> > 
> > Update the sdhci-s3c driver to use this to select the
> > appropriate clock source when clocks change.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> 
> I'm afraid I don't quite follow on the requirements here. Care to
> elaborate as to why this is needed?

The controller has a number of possible clock sources, the bus clock
it is connected to (generally called hclk) and three more clocks from
the heirachy that is muxed/divided from either an 48MHz, 27MHz or the
EPLL.

The callback allows the recalculation and selection of the best clock
to run the card clock for the controller.
 
> > Index: linux.git/drivers/mmc/host/sdhci-pci.c
> > ===================================================================
> > --- linux.git.orig/drivers/mmc/host/sdhci-pci.c	2008-11-03 12:17:50.000000000 +0000
> > +++ linux.git/drivers/mmc/host/sdhci-pci.c	2008-11-03 12:18:41.000000000 +0000
> > @@ -391,6 +391,7 @@ static int sdhci_pci_enable_dma(struct s
> >  
> >  static struct sdhci_ops sdhci_pci_ops = {
> >  	.enable_dma	= sdhci_pci_enable_dma,
> > +	.change_clock	= sdhci_change_clock,
> >  };
> >  
> >  /*****************************************************************************\
> 
> This seems pointless :)
> 
> > @@ -950,6 +955,8 @@ out:
> >  	host->clock = clock;
> >  }
> >  
> > +EXPORT_SYMBOL_GPL(sdhci_set_clock);
> > +
> 
> Wrong symbol. :)

ok, will fix

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
