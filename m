Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYJZLMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYJZLMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 07:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYJZLMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 07:12:09 -0400
Received: from server.drzeus.cx ([85.8.24.28]:42327 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752425AbYJZLMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 07:12:07 -0400
Date: Sun, 26 Oct 2008 12:11:55 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mmc_block: print better data error message after
 timeout
Message-ID: <20081026121155.69692474@mjolnir.drzeus.cx>
In-Reply-To: <48F7411F.3020109@nokia.com>
References: <48F7411F.3020109@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8327-1225019525-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8327-1225019525-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Oct 2008 16:26:55 +0300
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> In particular, if the card gets an ECC error it will
> timeout, in which case it is much more helpful to see
> an ECC error rather than a timeout error.
>=20
> Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
> ---

Woo. I think you're the first I've seen that has been able to trigger
an actual card error. :)

As for the patch, I like the idea but I'm not entirely satisfied with
the implementation.

> +static void print_data_error(struct mmc_blk_request *brq, struct mmc_car=
d *card,
> +			     struct request *req)
> +{
> +	struct mmc_command cmd;
> +	char *emsg;
> +	u32 status;
> +	int status_err =3D 0;
> +
> +	if (brq->data.error !=3D -ETIMEDOUT || mmc_host_is_spi(card->host))
> +		goto out_print;
> +

The error codes are more of a hint than anything else, so you should
check the status for all non-zero codes. You should also not just check
data.error, but all of them.

And why exclude spi?

> +	if (brq->mrq.stop)
> +		/* 'Stop' response contains card status */
> +		status =3D brq->mrq.stop->resp[0];
> +	else {
> +		cmd.opcode =3D MMC_SEND_STATUS;
> +		cmd.arg =3D card->rca << 16;
> +		cmd.flags =3D MMC_RSP_R1 | MMC_CMD_AC;
> +		status_err =3D mmc_wait_for_cmd(card->host, &cmd, 0);
> +		if (status_err)
> +			goto out_print;
> +		status =3D cmd.resp[0];
> +	}

Errors can occur on writes as well, so I suggest accumulating the
status bits instead of trying to get the entire set in one go. I.e.:

status =3D 0;
if (mrq.stop)
	status |=3D mrq.stop.resp[0];
while (card not ready)
	status |=3D send_status();

IOW, you should do this in the main handler (that already has the
status loop for writes).

> +
> +	emsg =3D (status & R1_CARD_ECC_FAILED) ? "ECC" : "I/O";
> +

There are also some other error codes that can be of interest.
"Internal controller error" for example.

(it's probably also better to state "Unknown" error and not "I/O" for
the fallback)

> @@ -281,10 +322,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, st=
ruct request *req)
>  			       req->rq_disk->disk_name, brq.cmd.error);
>  		}
> =20
> -		if (brq.data.error) {
> -			printk(KERN_ERR "%s: error %d transferring data\n",
> -			       req->rq_disk->disk_name, brq.data.error);
> -		}
> +		if (brq.data.error)
> +			print_data_error(&brq, card, req);
> =20

Please keep the old message and add this as a new extra piece of
information. It is helpful for debugging to see both what the driver
and the card reported.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8327-1225019525-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEUEARECAAYFAkkEUIEACgkQ7b8eESbyJLjRsgCg5fiWRwB/w3eDrWrniguOZnO2
OeAAljRlhu+jHexSqepst5CC7SCnQh0=
=nLGh
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8327-1225019525-0001-2--
