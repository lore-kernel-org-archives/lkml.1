Return-Path: <linux-kernel-owner+w=401wt.eu-S1761560AbZE1IaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761560AbZE1IaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZE1I3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:29:54 -0400
Received: from mx1.auerswald.de ([212.185.163.234]:4812 "EHLO
	mail.auerswald.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbZE1I3u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:29:50 -0400
From: Wolfgang =?utf-8?q?M=C3=BCes?= <wolfgang.mues@auerswald.de>
Organization: Auerswald GmbH & Co. KG
To: Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer - 3rd try
Date: Thu, 28 May 2009 10:28:29 +0200
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200905261311.45725.wolfgang.mues@auerswald.de> <20090527214933.64eafeb5@mjolnir.ossman.eu>
In-Reply-To: <20090527214933.64eafeb5@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905281028.29256.wolfgang.mues@auerswald.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre,

Am Mittwoch, 27. Mai 2009 schrieb Pierre Ossman:
> I think this sounds good in principle.

OK. Good.

> FYI, the situation that we must avoid to not screw up the assumptions
> of the filesystems is to end up with a situation like this on the card:
>
>  NNNNBNNNOOOO
>
>  N = block with new data
>  O = block with previous data
>  B = block with damaged data
>
> This could in theory happen when the card has some internal problem
> (e.g. bad flash cell) as well go through these states:
>
>  NNNNNNNNOOOO (first write, response to stop command is lost)
>  NNNNBNNNOOOO (second write, card has internal problem halfway through)

For SPI and for any controller which gives you a correct bytes_xfered, this 
will only be NNNNNNNNNNNNBOOOOOOOOOOO, because after each transfered sector, 
you get a response from the card. So you will not start from the beginning 
any more.

If a host controller does not give a correct bytes_xfered, you might end in 
the scenario you have pointed out, only after exhausting all retries. This is 
equivalent to a bad of multiple sectors. NBNBNBNB000 == NBBBBBBBOOO.

I think we should code according to the expectations of the user.
A nonrecoverable write results in a data loss for the user. And I think that 
the wish of the user to get the newly aquired data down to the card has 
preceedence against the possible loss of some old data on the card. Remember 
that the "old data" will be unused sectors most of the time. In embedded 
systems, the user often has no chance to repeat the storage process or choose 
another medium, and the data ist lost if the write to SD card fails.

> And please leave out the "o " and indentation in the commit text. :)

Hey, you have accepted 9 patches from me without complaining!

I will do next time.
>
> > @@ -251,10 +253,8 @@ static int mmc_blk_issue_rq(struct mmc_q
> >  		brq.stop.flags = MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
> >  		brq.data.blocks = req->nr_sectors;
> >
> > -		/*
> > -		 * After a read error, we redo the request one sector at a time
> > -		 * in order to accurately determine which sectors can be read
> > -		 * successfully.
> > +		/* After an transmission error, we switch to single block
> > +		 * transfer until the problem is solved or we fail.
> >  		 */
> >  		if (disable_multi && brq.data.blocks > 1)
> >  			brq.data.blocks = 1;
>
> I think we can keep the logic where it uses single blocks for the
> remainder of the request.

But this will increase wear leveling problems for the rest of the request.
And this is for a mean value of 64 sectors!

Why on earth should we do this if it is so easy to avoid?

As transmission errors are seldom, we get a request splitted out in 3 blocks: 
n blocks before the error, one single-block transfer, m blocks after the 
error. And you almost will not notice a slowdown in transmission speed.

> > +#if 0
> > +		printk(KERN_INFO "%s transfer sector %d count %d\n",
> > +			(rq_data_dir(req) == READ) ? "Read" : "Write",
> > +			(int)req->sector, (int)brq.data.blocks);
> > +#endif
>
> No dead code please.

Argggh! Matt Flemming requested this to be a pr_debug, and somehow this was 
not getting into the patch. Please drop the patch; I will resend.

>
> > +		/* Error reporting */
> >  		if (brq.cmd.error) {
> > +			error = brq.cmd.error;
> > +			status = get_card_status(card, req);
> >  			printk(KERN_ERR "%s: error %d sending read/write "
> >  			       "command, response %#x, card status %#x\n",
> >  			       req->rq_disk->disk_name, brq.cmd.error,
> >  			       brq.cmd.resp[0], status);
> > -		}
> > -
> > -		if (brq.data.error) {
> > -			if (brq.data.error == -ETIMEDOUT && brq.mrq.stop)
> > +		} else if (brq.data.error) {
> > +			error = brq.data.error;
> > +			if ((brq.data.error == -ETIMEDOUT)
> > +			    && brq.mrq.stop && !brq.stop.error)
> >  				/* 'Stop' response contains card status */
> >  				status = brq.mrq.stop->resp[0];
> > +			else
> > +				status = get_card_status(card, req);
> >  			printk(KERN_ERR "%s: error %d transferring data,"
> >  			       " sector %u, nr %u, card status %#x\n",
> >  			       req->rq_disk->disk_name, brq.data.error,
> >  			       (unsigned)req->sector,
> >  			       (unsigned)req->nr_sectors, status);
> > -		}
> > -
> > -		if (brq.stop.error) {
> > +		} else if (brq.stop.error) {
> > +			error = brq.stop.error;
> > +			status = get_card_status(card, req);
> >  			printk(KERN_ERR "%s: error %d sending stop command, "
> >  			       "response %#x, card status %#x\n",
> >  			       req->rq_disk->disk_name, brq.stop.error,
> >  			       brq.stop.resp[0], status);
> >  		}
>
> The point of having the continue before this code was to make sure we
> didn't get a lot of noise in dmesg for the cases where a retry solved
> the issue.

OK. I will change this behaviour.

> It was also per design that all three errors were printed separately.

Hm. A stop error may occur as consequence of a data error. I will change it.

> > +		/*
> > +		 * If this is an SD card and we're writing, we can first
> > +		 * mark the known good sectors as ok.
> > +		 *
> > +		 * If the card is not SD, we can still ok written sectors
> > +		 * as reported by the controller (which might be less than
> > +		 * the real number of written sectors, but never more).
> > +		 *
> > +		 * For read transfers, we report the number of tranfered bytes.
> > +		 */
> > +		if (error && mmc_card_sd(card) && (rq_data_dir(req) != READ)) {
> > +			u32 blocks;
> > +
> > +			blocks = mmc_sd_num_wr_blocks(card);
> > +			if (blocks != (u32)-1)
> > +				brq.data.bytes_xfered = blocks << 9;
> > +		}
> > +		if (brq.data.bytes_xfered) {
> > +			spin_lock_irq(&md->lock);
> > +			ret = __blk_end_request(req, 0, brq.data.bytes_xfered);
> > +			spin_unlock_irq(&md->lock);
> > +		}
>
> Perhaps this fix can be moved into its own patch? I think it might keep
> things cleaner.

Which fix? The code was only moved and restructured. No new behaviour.

> > +
> > +		/* Wait until card is ready for new data. This information is
> > +		 * only available in non-SPI mode. In SPI mode, the busy
> > +		 * handling is done in the SPI driver.
> > +		 */
>
> Strictly speaking it should be handled in all drivers. Some hardware
> doesn't do it properly though so we have this safeguard.

IMHO no driver and framework is doing this correct. It should not be done 
after a write request, but before the _next_ request. All I have done here 
was to add some documentation about SPI, and leave the previous code intact.
>
> >  		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) != READ) {
> >  			do {
> >  				int err;
> > -
> >  				cmd.opcode = MMC_SEND_STATUS;
> >  				cmd.arg = card->rca << 16;
> >  				cmd.flags = MMC_RSP_R1 | MMC_CMD_AC;
>
> This seems like an unnecessary and negative change.

Removed in the updated patch I will send.

> > @@ -374,66 +395,63 @@ static int mmc_blk_issue_rq(struct mmc_q
> >  			} while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
> >  				(R1_CURRENT_STATE(cmd.resp[0]) == 7));
> >
> > -#if 0
> > -			if (cmd.resp[0] & ~0x00000900)
> > -				printk(KERN_ERR "%s: status = %08x\n",
> > -				       req->rq_disk->disk_name, cmd.resp[0]);
> > -			if (mmc_decode_status(cmd.resp))
> > -				goto cmd_err;
> > -#endif
> >  		}
>
> Might want to move this out as well in order to make this somewhat
> complex diff more readable.

OK, I will leave it in for now.

> > +		/* Do retries for all sort of transmission errors */
> > +		switch (error) {
> >
> > -		/*
> > -		 * A block was successfully transferred.
> > +		case 0:	/* no error: continue, reset error variables */
> > +			disable_multi = 0;
> > +			retries = 3;
> > +			break;
> > +
> > +		/* Card has not understand command. As we do only send
> > +		 * valid commands, this must be a transmission error. */
> > +		case -EPROTO:	/* fall through */
>
> This indicates a layering problem. The host driver should not be aware
> of anything but pure bit errors.
>
> Also, this special meaning should be documented in core.h should we
> decide to keep it.

This is not MY error code. EPROTO is send from mmc_spi_writeblock(), and I 
have listed it here because it is a transmission error.

So there seems to be contrary objections: Matt Flemming has requested that the 
exact cause of error is reported by the driver (because otherwise the caller 
will loose information), and you requested to distinguish only between 
transmission errors and the rest.

Matt Flemming has pointed out that further changes in the code will request to 
get the exact cause of error in the block layer, and that error codes might 
have interpreted different according to the command class, so IMHO it is 
better to transport the exact error cause into block.c and do the error 
handling here, according to the type of request.

> > +		/* non-recoverable error or retries exhausted */
> > +		default:
> > +			/* Terminate, if transfer direction is write.
> > +			 * We are not allowed to continue after a non-
> > +			 * recoverable write!
> > +			 */
> > +			if (rq_data_dir(req) != READ)
> > +				goto cmd_err;
> > +			/* If transfer direction is read, report error
> > +			 * for this sector and continue to read
> > +			 * the rest. Get all available information!
> > +			 */
> > +			spin_lock_irq(&md->lock);
> > +			ret = __blk_end_request(req, -EIO, brq.data.blksz);
> > +			spin_unlock_irq(&md->lock);
> > +			/* reset error variables */
> > +			disable_multi = 0;
> > +			retries = 3;
> > +			break;
>
> This looks wrong. What happened to the original logic of retrying reads
> on any error?

You mean error codes like EINVAL, ENOMEDIUM, ENODEV?
I there any sense in retrying non-recoverable errors? Or should I list the 
non-recoverable errors inside the switch (and do nothing), and do a retry for 
read calls on any other error code, so a new coded driver with a new error 
code will get a read retry (but no write retry!) for this new code regardless 
of making sense?

> > diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c
> > 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c ---
> > 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14
> > 12:49:42.000000000 +0200 +++
> > 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-05-14
> > 15:01:15.000000000 +0200 @@ -743,12 +743,11 @@ mmc_spi_writeblock(struct
> > mmc_spi_host *
> >  	if (status != 0) {
> >  		dev_dbg(&spi->dev, "write error %02x (%d)\n",
> >  			scratch->status[0], status);
> > -		return status;
> > -	}
> > -
> > +	} else {
> >  	t->tx_buf += t->len;
> >  	if (host->dma_dev)
> >  		t->tx_dma += t->len;
> > +	}
> >
> >  	/* Return when not busy.  If we didn't collect that status yet,
> >  	 * we'll need some more I/O.
>
> Bad indentation.
Yepp.

> And chunk seems unrelated to the rest of the patch. 

Ah... no. This is part of sending the STOP command in case of an error.
And sending the STOP command in case of an error is needed for a working retry 
of write commands in SPI mode. Without a STOP command, you can not retry a 
broken write sequence because the card missed the STOP token. 

> I'm not entirely pleased with this hack, but I'm not sure we can do
> much better.

This is the best reaction we can do. The STOP will close/terminate any pending 
write actions. And the card must accept this command in SD mode and in SPI 
read mode, so it is very likely that it will behave if we send it in write 
mode too. And my tests with SD cards were positive.

> Could you add a comment in include/mmc/core.h for *stop in 
> struct mmc_request that SPI will only use this command on errors.
... and for multiblock reads, of course. Yes, I can.

> Could you also move those modifications to its own patch?

Why? It is meaningless without a retry logic for block writes.

Puuhhh... Many points to settle down. Hope we can reach consensus on all open 
points.

regards
 
i. A. Wolfgang Mües
-- 
Auerswald GmbH & Co. KG
Hardware Development
Telefon: +49 (0)5306 9219 0
Telefax: +49 (0)5306 9219 94 
E-Mail: Wolfgang.Mues@Auerswald.de
Web: http://www.auerswald.de
 
--------------------------------------------------------------
Auerswald GmbH & Co. KG, Vor den Grashöfen 1, 38162 Cremlingen
Registriert beim AG Braunschweig HRA 13289
p.h.G Auerswald Geschäftsführungsges. mbH
Registriert beim AG Braunschweig HRB 7463
Geschäftsführer: Dipl-Ing. Gerhard Auerswald
