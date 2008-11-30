Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYK3StI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYK3StI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 13:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYK3Ssz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 13:48:55 -0500
Received: from server.drzeus.cx ([85.8.24.28]:60616 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752488AbYK3Ssz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 13:48:55 -0500
Date: Sun, 30 Nov 2008 19:48:45 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
Message-ID: <20081130194845.4abd0cb8@mjolnir.drzeus.cx>
In-Reply-To: <49083B1C.6060803@nokia.com>
References: <48F7411F.3020109@nokia.com>
	<20081026121155.69692474@mjolnir.drzeus.cx>
	<49083B1C.6060803@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22771-1228070931-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22771-1228070931-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2008 12:29:48 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> Add command response and card status to error
> messages.
>=20
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---
>  drivers/mmc/card/block.c |   56 ++++++++++++++++++++++++++++++++++++++++=
-----
>  1 files changed, 49 insertions(+), 7 deletions(-)
>=20
>=20
> Pierre
>=20
> This patch amends error messages for all error codes and is independent o=
f SPI.

Looks good. It's ready to queue up except for two very small details
(see below).

> Status values are not OR'd together from different commands as that would
> muddy the waters for anyone trying to understand the nature of the error.

I suppose. I'm just generally uneasy about error handling in SD/MMC as
the specs aren't that clear. :)

> Waiting for the card to become ready after an error is also not included,
> as it is not in the standards and is a separate issue anyway.

What do you mean?

This will handle your case of seeing read errors, but for write errors
we probably need to wait for the write to complete fully. But that's
something that can be added later...
> =20
> +static u32 get_card_status(struct mmc_card *card, struct request *req)
> +{
> +	struct mmc_command cmd;
> +	int err;
> +
> +	/* SEND STATUS command is not supported by SDIO */
> +	if (mmc_card_sdio(card))
> +		return 0;
> +

This is redundant. We never bind to a SDIO card.

>  		if (brq.data.error) {
> -			printk(KERN_ERR "%s: error %d transferring data\n",
> -			       req->rq_disk->disk_name, brq.data.error);
> +			if (brq.data.error =3D=3D -ETIMEDOUT) {
> +				/* 'Stop' response contains card status */
> +				if (brq.mrq.stop)
> +					status =3D brq.mrq.stop->resp[0];
> +				printk(KERN_ERR "%s: error transferring data,"
> +				       " sector %u, nr %u, card status %#x\n",
> +				       req->rq_disk->disk_name,
> +				       (unsigned)req->sector,
> +				       (unsigned)req->nr_sectors, status);
> +			} else {
> +				printk(KERN_ERR "%s: error %d transferring data,"
> +				       " sector %u, nr %u, card status %#x\n",
> +				       req->rq_disk->disk_name, brq.data.error,
> +				       (unsigned)req->sector,
> +				       (unsigned)req->nr_sectors, status);
> +			}
>  		}

Do we need the two different printk:s? It would reduce the code a bit
if you just let the if clause modify the status value.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22771-1228070931-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkky4BIACgkQ7b8eESbyJLigWwCgiKn/TlWI44WY1+S+NrLyklOe
YmYAoIsS9oJUbE89oFbd1WGZ0XXoEUVe
=51Xi
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22771-1228070931-0001-2--
