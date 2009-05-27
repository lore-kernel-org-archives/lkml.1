Return-Path: <linux-kernel-owner+w=401wt.eu-S1761725AbZE0Tts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761725AbZE0Tts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbZE0Ttk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:49:40 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:49001 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbZE0Ttj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:49:39 -0400
Date: Wed, 27 May 2009 21:49:33 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Matt Fleming" <matt@console-pimps.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
 - 3rd try
Message-ID: <20090527214933.64eafeb5@mjolnir.ossman.eu>
In-Reply-To: <200905261311.45725.wolfgang.mues@auerswald.de>
References: <200905261311.45725.wolfgang.mues@auerswald.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-4357-1243453777-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-4357-1243453777-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 26 May 2009 12:11:45 +0100
Wolfgang M=C3=BCes <wolfgang.mues@auerswald.de> wrote:

> From: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20
> o This patch adds a propper retry managment for reading
>   and writing data blocks for mmc and mmc_spi. Blocks are
>   retransmitted if the cause of failure might be a transmission
>   fault. After a permanent failure, we try to read all other
>   pending sectors, but terminate on write.
>   This patch was tested with induced transmission errors
>   by ESD pulses (and survived).
>=20
> This patch is based on=20
> [PATCH] mmc_spi: don't use EINVAL for possible transmission errors
>=20
> Suggested changes from Matt Fleming and David Brownell are
> incorporated.
>=20
> Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
>=20

I think this sounds good in principle. I just need to think a bit more
about the scenarios and make sure we don't miss anything.

FYI, the situation that we must avoid to not screw up the assumptions
of the filesystems is to end up with a situation like this on the card:

 NNNNBNNNOOOO

 N =3D block with new data
 O =3D block with previous data
 B =3D block with damaged data

This could in theory happen when the card has some internal problem
(e.g. bad flash cell) as well go through these states:

 NNNNNNNNOOOO (first write, response to stop command is lost)
 NNNNBNNNOOOO (second write, card has internal problem halfway through)


And please leave out the "o " and indentation in the commit text. :)


> @@ -251,10 +253,8 @@ static int mmc_blk_issue_rq(struct mmc_q
>  		brq.stop.flags =3D MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
>  		brq.data.blocks =3D req->nr_sectors;
>=20
> -		/*
> -		 * After a read error, we redo the request one sector at a time
> -		 * in order to accurately determine which sectors can be read
> -		 * successfully.
> +		/* After an transmission error, we switch to single block
> +		 * transfer until the problem is solved or we fail.
>  		 */
>  		if (disable_multi && brq.data.blocks > 1)
>  			brq.data.blocks =3D 1;

I think we can keep the logic where it uses single blocks for the
remainder of the request. There will be a lot of switching back and
forth to handle the scenario the fallback was originally written for
otherwise. And the system will go back to large transfers in the next
request anyway.

> +#if 0
> +		printk(KERN_INFO "%s transfer sector %d count %d\n",
> +			(rq_data_dir(req) =3D=3D READ) ? "Read" : "Write",
> +			(int)req->sector, (int)brq.data.blocks);
> +#endif

No dead code please.

> +		/* Error reporting */
>  		if (brq.cmd.error) {
> +			error =3D brq.cmd.error;
> +			status =3D get_card_status(card, req);
>  			printk(KERN_ERR "%s: error %d sending read/write "
>  			       "command, response %#x, card status %#x\n",
>  			       req->rq_disk->disk_name, brq.cmd.error,
>  			       brq.cmd.resp[0], status);
> -		}
> -
> -		if (brq.data.error) {
> -			if (brq.data.error =3D=3D -ETIMEDOUT && brq.mrq.stop)
> +		} else if (brq.data.error) {
> +			error =3D brq.data.error;
> +			if ((brq.data.error =3D=3D -ETIMEDOUT)
> +			    && brq.mrq.stop && !brq.stop.error)
>  				/* 'Stop' response contains card status */
>  				status =3D brq.mrq.stop->resp[0];
> +			else
> +				status =3D get_card_status(card, req);
>  			printk(KERN_ERR "%s: error %d transferring data,"
>  			       " sector %u, nr %u, card status %#x\n",
>  			       req->rq_disk->disk_name, brq.data.error,
>  			       (unsigned)req->sector,
>  			       (unsigned)req->nr_sectors, status);
> -		}
> -
> -		if (brq.stop.error) {
> +		} else if (brq.stop.error) {
> +			error =3D brq.stop.error;
> +			status =3D get_card_status(card, req);
>  			printk(KERN_ERR "%s: error %d sending stop command, "
>  			       "response %#x, card status %#x\n",
>  			       req->rq_disk->disk_name, brq.stop.error,
>  			       brq.stop.resp[0], status);
>  		}
>=20

The point of having the continue before this code was to make sure we
didn't get a lot of noise in dmesg for the cases where a retry solved
the issue.

It was also per design that all three errors were printed separately.

> +		/*
> +		 * If this is an SD card and we're writing, we can first
> +		 * mark the known good sectors as ok.
> +		 *
> +		 * If the card is not SD, we can still ok written sectors
> +		 * as reported by the controller (which might be less than
> +		 * the real number of written sectors, but never more).
> +		 *
> +		 * For read transfers, we report the number of tranfered bytes.
> +		 */
> +		if (error && mmc_card_sd(card) && (rq_data_dir(req) !=3D READ)) {
> +			u32 blocks;
> +
> +			blocks =3D mmc_sd_num_wr_blocks(card);
> +			if (blocks !=3D (u32)-1)
> +				brq.data.bytes_xfered =3D blocks << 9;
> +		}
> +		if (brq.data.bytes_xfered) {
> +			spin_lock_irq(&md->lock);
> +			ret =3D __blk_end_request(req, 0, brq.data.bytes_xfered);
> +			spin_unlock_irq(&md->lock);
> +		}

Perhaps this fix can be moved into its own patch? I think it might keep
things cleaner.

> +
> +		/* Wait until card is ready for new data. This information is
> +		 * only available in non-SPI mode. In SPI mode, the busy
> +		 * handling is done in the SPI driver.
> +		 */

Strictly speaking it should be handled in all drivers. Some hardware
doesn't do it properly though so we have this safeguard.

>  		if (!mmc_host_is_spi(card->host) && rq_data_dir(req) !=3D READ) {
>  			do {
>  				int err;
> -
>  				cmd.opcode =3D MMC_SEND_STATUS;
>  				cmd.arg =3D card->rca << 16;
>  				cmd.flags =3D MMC_RSP_R1 | MMC_CMD_AC;

This seems like an unnecessary and negative change.

> @@ -374,66 +395,63 @@ static int mmc_blk_issue_rq(struct mmc_q
>  			} while (!(cmd.resp[0] & R1_READY_FOR_DATA) ||
>  				(R1_CURRENT_STATE(cmd.resp[0]) =3D=3D 7));
>=20
> -#if 0
> -			if (cmd.resp[0] & ~0x00000900)
> -				printk(KERN_ERR "%s: status =3D %08x\n",
> -				       req->rq_disk->disk_name, cmd.resp[0]);
> -			if (mmc_decode_status(cmd.resp))
> -				goto cmd_err;
> -#endif
>  		}
>=20

Might want to move this out as well in order to make this somewhat
complex diff more readable.

> +		/* Do retries for all sort of transmission errors */
> +		switch (error) {
>=20
> -		/*
> -		 * A block was successfully transferred.
> +		case 0:	/* no error: continue, reset error variables */
> +			disable_multi =3D 0;
> +			retries =3D 3;
> +			break;
> +
> +		/* Card has not understand command. As we do only send
> +		 * valid commands, this must be a transmission error. */
> +		case -EPROTO:	/* fall through */

This indicates a layering problem. The host driver should not be aware
of anything but pure bit errors.

Also, this special meaning should be documented in core.h should we
decide to keep it.

> +		/* non-recoverable error or retries exhausted */
> +		default:
> +			/* Terminate, if transfer direction is write.
> +			 * We are not allowed to continue after a non-
> +			 * recoverable write!
> +			 */
> +			if (rq_data_dir(req) !=3D READ)
> +				goto cmd_err;
> +			/* If transfer direction is read, report error
> +			 * for this sector and continue to read
> +			 * the rest. Get all available information!
> +			 */
> +			spin_lock_irq(&md->lock);
> +			ret =3D __blk_end_request(req, -EIO, brq.data.blksz);
> +			spin_unlock_irq(&md->lock);
> +			/* reset error variables */
> +			disable_multi =3D 0;
> +			retries =3D 3;
> +			break;

This looks wrong. What happened to the original logic of retrying reads
on any error?

> diff -uprN 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c 2_6_29_rc7_=
patch_retries/drivers/mmc/host/mmc_spi.c
> --- 2_6_29_rc7_patch_EILSEQ/drivers/mmc/host/mmc_spi.c	2009-05-14 12:49:4=
2.000000000 +0200
> +++ 2_6_29_rc7_patch_retries/drivers/mmc/host/mmc_spi.c	2009-05-14 15:01:=
15.000000000 +0200
> @@ -743,12 +743,11 @@ mmc_spi_writeblock(struct mmc_spi_host *
>  	if (status !=3D 0) {
>  		dev_dbg(&spi->dev, "write error %02x (%d)\n",
>  			scratch->status[0], status);
> -		return status;
> -	}
> -
> +	} else {
>  	t->tx_buf +=3D t->len;
>  	if (host->dma_dev)
>  		t->tx_dma +=3D t->len;
> +	}
>=20
>  	/* Return when not busy.  If we didn't collect that status yet,
>  	 * we'll need some more I/O.

Bad indentation. And chunk seems unrelated to the rest of the patch.

> @@ -756,9 +755,12 @@ mmc_spi_writeblock(struct mmc_spi_host *
>  	for (i =3D 4; i < sizeof(scratch->status); i++) {
>  		/* card is non-busy if the most recent bit is 1 */
>  		if (scratch->status[i] & 0x01)
> -			return 0;
> +		return status;
>  	}
> -	return mmc_spi_wait_unbusy(host, timeout);
> +	i =3D mmc_spi_wait_unbusy(host, timeout);
> +	if (!status)
> +		status =3D i;
> +	return status;
>  }
>=20
>  /*

Same here.

> @@ -1087,7 +1089,15 @@ static void mmc_spi_request(struct mmc_h
>  	status =3D mmc_spi_command_send(host, mrq, mrq->cmd, mrq->data !=3D NUL=
L);
>  	if (status =3D=3D 0 && mrq->data) {
>  		mmc_spi_data_do(host, mrq->cmd, mrq->data, mrq->data->blksz);
> -		if (mrq->stop)
> +		/* filter-out the stop command for multiblock writes,
> +		* only if the data stage has no transmission error.
> +		* If the data stage has a transmission error, send the
> +		* STOP command because there is a great chance that the
> +		* SPI stop token was not accepted by the card.
> +		*/
> +		if (mrq->stop &&
> +		  ((mrq->data->flags & MMC_DATA_READ)
> +		 || mrq->data->error))
>  			status =3D mmc_spi_command_send(host, mrq, mrq->stop, 0);
>  		else
>  			mmc_cs_off(host);

I'm not entirely pleased with this hack, but I'm not sure we can do
much better. Could you add a comment in include/mmc/core.h for *stop in
struct mmc_request that SPI will only use this command on errors.

Could you also move those modifications to its own patch?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-4357-1243453777-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEUEARECAAYFAkodmVEACgkQ7b8eESbyJLhNKQCgg9QINMst1IogPjvs9LOr0suc
hf4AliefEYNr2VLEhRGBel85NNxrVh4=
=GFG0
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-4357-1243453777-0001-2--
