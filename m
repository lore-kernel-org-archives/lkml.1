Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbYGQPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbYGQPuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbYGQPun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:50:43 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55243 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755050AbYGQPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:50:42 -0400
Date: Thu, 17 Jul 2008 16:50:37 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: MMC: s3cmci: ensure host stopped on machine shutdown
Message-ID: <20080717155037.GI24620@fluff.org.uk>
References: <20080717143253.823429733@fluff.org.uk> <20080717172945.3481eefa@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717172945.3481eefa@mjolnir.drzeus.cx>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:29:45PM +0200, Pierre Ossman wrote:
> On Thu, 17 Jul 2008 15:32:54 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > Ensure that the s3cmci host controller is turned off
> > when the machine is shutdown, otherwise we end up
> > leaving the card powered and processing insertion and
> > removal events after the system prints "System halted."
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> > Index: linux-2.6.26-quilt3/drivers/mmc/host/s3cmci.c
> > ===================================================================
> > --- linux-2.6.26-quilt3.orig/drivers/mmc/host/s3cmci.c	2008-07-17 15:15:35.000000000 +0100
> > +++ linux-2.6.26-quilt3/drivers/mmc/host/s3cmci.c	2008-07-17 15:29:23.000000000 +0100
> > @@ -1331,21 +1331,30 @@ static int __devinit s3cmci_probe(struct
> >  	return ret;
> >  }
> >  
> > +static void s3cmci_shutdown(struct platform_device *pdev)
> > +{
> > +	struct mmc_host	*mmc = platform_get_drvdata(pdev);
> > +	struct s3cmci_host *host = mmc_priv(mmc);
> > +
> > +	if (host->irq_cd >= 0)
> > +		free_irq(host->irq_cd, host);
> > +
> > +	mmc_remove_host(mmc);
> > +	clk_disable(host->clk);
> > +}
> > +
> 
> The core can send requests your way until mmc_remove_host() returns so
> you can't remove the interrupt before then.

I'm only removing the card-detect interrupt, the main host one
is not being disabled here.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
