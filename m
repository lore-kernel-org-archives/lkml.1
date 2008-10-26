Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbYJZLcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbYJZLcq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYJZLch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:32:37 -0400
Received: from server.drzeus.cx ([85.8.24.28]:37866 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752059AbYJZLcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:32:36 -0400
Date: Sun, 26 Oct 2008 12:32:28 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have
 errors are read
Message-ID: <20081026123228.26d2a86a@mjolnir.drzeus.cx>
In-Reply-To: <48F74121.1020409@nokia.com>
References: <48F74121.1020409@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8375-1225020756-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8375-1225020756-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Oct 2008 16:26:57 +0300
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> If a card encounters an ECC error while reading a sector it will
> timeout.  Instead of reporting the entire I/O request as having
> an error, redo the I/O one sector at a time so that all readable
> sectors are provided to the upper layers.
>=20
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---

We actually had something like this on the table some time ago. It got
scrapped because of data integrity problems. This is just for reads
though, so I guess it should be safe.

> @@ -278,6 +279,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, str=
uct request *req)
>  		brq.stop.flags =3D MMC_RSP_SPI_R1B | MMC_RSP_R1B | MMC_CMD_AC;
>  		brq.data.blocks =3D req->nr_sectors;
> =20
> +		if (disable_multi && brq.data.blocks > 1)
> +			brq.data.blocks =3D 1;
> +

A comment here would be nice.

You also need to adjust the sg list when you change the block count.
There was code there that did that previously, but it got removed in
2.6.27-rc1.

> @@ -312,6 +318,13 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, st=
ruct request *req)
> =20
>  		mmc_queue_bounce_post(mq);
> =20
> +		if (multi && rq_data_dir(req) =3D=3D READ &&
> +		    brq.data.error =3D=3D -ETIMEDOUT) {
> +			/* Redo read one sector at a time */
> +			disable_multi =3D 1;
> +			continue;
> +		}
> +

Some concerns here:

1. "brq.data.blocks > 1" doesn't need to be optimised into its own
variable. It just obscures things.

2. A comment here as well. Explain what this does and why it is safe
(so people don't try to extend it to writes)

3. You should check all errors, not just data.error and ETIMEDOUT.

4. You should first report the successfully transferred blocks as ok.

> @@ -360,14 +373,21 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, s=
truct request *req)
>  #endif
>  		}
> =20
> -		if (brq.cmd.error || brq.data.error || brq.stop.error)
> +		if (brq.cmd.error || brq.stop.error)
>  			goto cmd_err;

Move your code to inside this if clause and you'll solve 3. and 4. in a
neat manner. You might also want to print something so that it is
visible that the driver retried the transfer.

> =20
> -		/*
> -		 * A block was successfully transferred.
> -		 */
> +		if (brq.data.error) {
> +			if (brq.data.error =3D=3D -ETIMEDOUT &&
> +			    rq_data_dir(req) =3D=3D READ) {
> +				err =3D -EIO;
> +				brq.data.bytes_xfered =3D brq.data.blksz;
> +			} else
> +				goto cmd_err;
> +		} else
> +			err =3D 0;
> +
>  		spin_lock_irq(&md->lock);
> -		ret =3D __blk_end_request(req, 0, brq.data.bytes_xfered);
> +		ret =3D __blk_end_request(req, err, brq.data.bytes_xfered);
>  		spin_unlock_irq(&md->lock);
>  	} while (ret);
> =20

Instead of this big song and dance routine, just have a dedicated piece
of code for calling __blk_end_request() for the single sector failure.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8375-1225020756-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkEVVEACgkQ7b8eESbyJLj2mgCdEHz35kmnt8JHTjUNKzBC2CmB
KscAn0wfBYYqbZWlOUt5Co8Ng1ROhIu4
=efad
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8375-1225020756-0001-2--
