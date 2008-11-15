Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYKOX7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYKOX7A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 18:59:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbYKOX6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 18:58:52 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57113 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbYKOX6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 18:58:52 -0500
Date: Sat, 15 Nov 2008 23:58:49 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 4/7] SDHCI: Add quirk for controller with no
	end-of-busy IRQ
Message-ID: <20081115235849.GC9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk> <20081103201010.464075837@fluff.org.uk> <20081114224114.5b5932a0@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114224114.5b5932a0@mjolnir.drzeus.cx>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 10:41:14PM +0100, Pierre Ossman wrote:
> On Mon, 03 Nov 2008 20:09:48 +0000
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > The Samsung SDHCI controller block seems to fail to generate an
> > INT_DATA_END after the transfer has completed and the bus busy
> > state finished. 
> > 
> > Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
> > new busy method are the cause of the behaviour change.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> > Index: linux.git/drivers/mmc/host/sdhci.c
> > ===================================================================
> > --- linux.git.orig/drivers/mmc/host/sdhci.c	2008-11-03 10:01:03.000000000 +0000
> > +++ linux.git/drivers/mmc/host/sdhci.c	2008-11-03 12:20:40.000000000 +0000
> > @@ -1291,11 +1291,24 @@ static void sdhci_cmd_irq(struct sdhci_h
> >  	 *       controllers.
> >  	 */
> >  	if (host->cmd->flags & MMC_RSP_BUSY) {
> > +		u32 present;
> > +
> >  		if (host->cmd->data)
> >  			DBG("Cannot wait for busy signal when also "
> >  				"doing a data transfer");
> > -		else
> > +		else if (!(host->quirks & SDHCI_QUIRK_NO_TCIRQ_ON_NOT_BUSY))
> >  			return;
> 
> Not the clearest naming I've ever seen. :)
> How about NO_BUSY_IRQ?

ok, will change.
 
> > +
> > +		/* The Samsung SDHCI does not seem to provide an INT_DATA_END
> > +		 * when the system goes non-busy, so check the state of the
> > +		 * transfer by reading SDHCI_PRESENT_STATE to see if the
> > +		 * controller is ready
> > +		 */
> 
> There is already a note about this being a problem earlier up, so I
> don't think we need another.

right.
 
> > +
> > +		present = readl(host->ioaddr + SDHCI_PRESENT_STATE);
> > +		DBG("busy? present %08x, intstat %08x\n", present, intmask);
> > +
> 
> And what does this add really? Controllers not being able to wait for
> the busy state to end is so common that we can just ignore the problem
> here.
> 

that was debug.

> > +#define  SDHCI_DATA_BIT(x)	(1 << ((x) + 20))
> 
> This was not supposed to be included I suppose :)

was with teh debug.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
