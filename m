Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbZERUdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbZERUdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 16:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZERUdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 16:33:38 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:63067 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZERUdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 16:33:37 -0400
Date: Mon, 18 May 2009 21:33:38 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
	- rewritten
Message-ID: <20090518203338.GB10274@console-pimps.org>
References: <20090518152001.GA29472@console-pimps.org> <200905181800.41014.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905181800.41014.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 18, 2009 at 06:00:40PM +0200, Wolfgang Mües wrote:
> Matt,
> 
> Am Montag, 18. Mai 2009 schrieb Matt Fleming:
> >
> > When you say "proper retry management", what problem are you having
> > with the current code?
> 
> a) Writes were not retried at all, so every transmission error created a data 
> loss.
> b) There was no clear distinction between errors which comes from transmission 
> faults and errors which are by nature non-recoverable.
> c) After one error, the remaining sectors were read one by one. This is 
> unneccessary time-consuming.
> 
> Cause a) was my initial problem with this code. This was not production 
> quality.  
> 

Ah, now I understand. I've also been contacted privately by someone
who says that they've been experiencing similar issues and that your
patch has fixed them. Clearly there are people out there with flaky
hardware ;-)

> > > @@ -262,10 +262,12 @@ static int mmc_blk_issue_rq(struct mmc_q
> > >  		if (brq.data.blocks > 1) {
> > >  			/* SPI multiblock writes terminate using a special
> > >  			 * token, not a STOP_TRANSMISSION request.
> > > +			 * Here, this request is set for ALL types of
> > > +			 * hosts, so that we can use it in the lower
> > > +			 * layers if the data transfer stage has failed
> > > +			 * and the card is not able to accept the token.
> > >  			 */
> > > -			if (!mmc_host_is_spi(card->host)
> > > -					|| rq_data_dir(req) == READ)
> > > -				brq.mrq.stop = &brq.stop;
> > > +			brq.mrq.stop = &brq.stop;
> > >  			readcmd = MMC_READ_MULTIPLE_BLOCK;
> > >  			writecmd = MMC_WRITE_MULTIPLE_BLOCK;
> > >  		} else {
> >
> > Hmm.. is it OK to abuse the STOP_TRANSMISSION request like this? Does
> > SPI multiblock write still terminate with this patch?
> 
> IMHO, this is the right thing to do. If you have a transmission error 
> while SPI multiblock write, the card will miss the stop token. So the
> card is in multiblock write mode and has to be stopped. You cannot
> retry the stop token. Every card I have tested accepted the STOP_TRANSMISSION 
> request. So it is better to try a STOP_TRANSMISSION, because this will 
> recover communication with the card. If a particular card will not respond to 
> the STOP_TRANSMISSION, the situation is not worse as before...
> 
> The STOP_TRANSMISSION request is only send to the card if the card
> has not responded to the stop token (see the change in mmc_spi.c).
> The default non-error behaviour has not changed.
> 

I'll defer to Pierre on that one.

I feel that retrying data accesses should be done at a higher layer
than the MMC/SD subsystem. But maybe I'm just being impractical. This
patch solves a real world problem that is biting some people, and so
based on that, the approach seems OK to me FWIW.


diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c
--- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14 12:49:42.000000000 +0200
+++ 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-05-14 15:01:15.000000000 +0200
@@ -743,12 +743,11 @@ mmc_spi_writeblock(struct mmc_spi_host *
 	if (status != 0) {
 		dev_dbg(&spi->dev, "write error %02x (%d)\n",
 			scratch->status[0], status);
-		return status;
-	}
-
+	} else {
 	t->tx_buf += t->len;
 	if (host->dma_dev)
 		t->tx_dma += t->len;
+	}

By the way, the indentation needs fixing here.

@@ -1087,7 +1089,15 @@ static void mmc_spi_request(struct mmc_h
 	status = mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data != NULL);
 	if (status == 0 && mrq->data) {
 		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
-		if (mrq->stop)
+		/* filter-out the stop command for multiblock writes,
+		* only if the data stage has no transmission error.
+		* If the data stage has a transmission error, send the
+		* STOP command because there is a great chance that the
+		* SPI stop token was not accepted by the card.
+		*/
+		if (mrq->stop &&
+		  ((mrq->data->flags & MMC_DATA_READ)
+		 || mrq->data->error))
			status = mmc_spi_command_send(host, mrq, mrq->stop, 0);
 		else
 			mmc_cs_off(host);

And here..
