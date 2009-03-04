Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZCDSRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZCDSRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZCDSRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:17:33 -0500
Received: from [213.79.90.228] ([213.79.90.228]:43917 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753581AbZCDSRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:17:32 -0500
Date: Wed, 4 Mar 2009 20:47:44 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 12/13] sdhci: Add quirk for controllers with max. block
	size up to 4096 bytes
Message-ID: <20090304174744.GB7477@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru> <20090213144739.GL23889@oksana.dev.rtsoft.ru> <20090221165844.4f494043@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090221165844.4f494043@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 04:58:44PM +0100, Pierre Ossman wrote:
> On Fri, 13 Feb 2009 17:47:39 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > @@ -831,7 +832,12 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_data *data)
> >  	sdhci_set_transfer_irqs(host);
> >  
> >  	/* We do not handle DMA boundaries, so set it to max (512 KiB) */
> > -	sdhci_writew(host, SDHCI_MAKE_BLKSZ(7, data->blksz), SDHCI_BLOCK_SIZE);
> > +	if (host->quirks & SDHCI_QUIRK_MAX_BLK_SZ_4096)
> > +		blksz = data->blksz;
> > +	else
> > +		blksz = SDHCI_MAKE_BLKSZ(7, data->blksz);
> > +
> > +	sdhci_writew(host, blksz, SDHCI_BLOCK_SIZE);
> >  	sdhci_writew(host, data->blocks, SDHCI_BLOCK_COUNT);
> >  }
> >  
> 
> Hmm.. I seem to have overlooked this part previously. I guess they've
> basically stripped out the DMA boundary stuff and used the bits for
> other things?

Yes, the last two "DMA boundary" bits are reserved, and the first
one is re-used for blksz of 4096 bytes.

> At this point I'm leaning more towards simply not supporting their
> extended block size.

Eh. But well, OK. We can always persuade you later. :-)

I'll get rid of this particular patch, and put some BLOCK_SIZE
magic into the writew accessor (to clean the DMA bits) instead.

Though, I'll prepare another patch to force blksz to 2048, since
eSDHC specifies "3" in the blksz capability bitfield, and that
causes SDHCI core to fall back to the 512 byte blocks.

> After all, is it ever used?

Not sure, maybe `dd bs=' can use it? A bit lazy to check this
right now, but from the quick tests, enabling/disabling "blksz
of 4096 bytes" doesn't cause any performance change. At least
with the ordinary SD cards.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
