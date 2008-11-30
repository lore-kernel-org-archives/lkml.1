Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYK3TGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYK3TGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 14:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYK3TGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 14:06:06 -0500
Received: from server.drzeus.cx ([85.8.24.28]:50074 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752556AbYK3TGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 14:06:05 -0500
Date: Sun, 30 Nov 2008 20:05:58 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mmc_block: ensure all sectors that do not have
 errors are read
Message-ID: <20081130200558.21f2561b@mjolnir.drzeus.cx>
In-Reply-To: <4908727F.5080003@nokia.com>
References: <48F74121.1020409@nokia.com>
	<20081026123228.26d2a86a@mjolnir.drzeus.cx>
	<4908727F.5080003@nokia.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22822-1228071962-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22822-1228071962-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2008 16:26:07 +0200
Adrian Hunter <ext-adrian.hunter@nokia.com> wrote:

> Pierre Ossman wrote:
> > You also need to adjust the sg list when you change the block count.
> > There was code there that did that previously, but it got removed in
> > 2.6.27-rc1.
>=20
> That is not necessary.  It is an optimisation.  In general, optimising an
> error path serves no purpose.
>=20

Actually, it is a requirement that some drivers rely on. There is also
a WARN_ON(), or possibly a BUG_ON() in the request handling path. I
think it only triggers with MMC_DEBUG though...

> >=20
> > Some concerns here:
> >=20
> > 1. "brq.data.blocks > 1" doesn't need to be optimised into its own
> > variable. It just obscures things.
>=20
> But you have to assume that no driver changes the 'blocks' variable e.g.
> counts it down.

That would be a no-no. I guess this is not properly documented, but it
is strongly implied that the request structure should be read-only
except for fields that contain result data. ;)

> It is not an optimisation, it is just to improve
> reliability and readability.  What does it obscure?

if-clauses look like they're different, but they're not.

> > 3. You should check all errors, not just data.error and ETIMEDOUT.
>=20
> No.  Data timeout is a special case.  The other errors are system errors.
> If there is a command error or stop error (which is also a command error)
> it means either there is a bug in the kernel or the controller or card
> has failed to follow the specification.  Under those circumstances

Controllers do not follow the specs. Welcome to reality. :)

(sad fact: I don't think there is a single controller out there that
follows the specs to 100%).

Anyway, for this specific case, a controller might not be able to
differentiate between command and data timeouts. Or it might report
"data error" for anything unexpected (I seem to recall one of the
currently supported controllers behaves like this).

Generally it's about being as flexible as we can be. This is a world of
crappy hardware, so strict spec adherence just leads to a lot of hurt.
And I have the scars to prove it. :)

> > 4. You should first report the successfully transferred blocks as ok.
>=20
> That is another optimisation of the error path i.e. not necessary.  It
> is simpler to just start processing the request again - which the patch
> does.
>=20

I suppose.

> > You might also want to print something so that it is
> > visible that the driver retried the transfer.
>=20
> There are already two error messages per sector (one from this function
> and one from '__blk_end_request()', so another message is too much.
>=20

I didn't mean an error for the bad sector, but something like
"encountered an error during multi-block transfer. retrying...". This
could save a lot of time and headache during debugging in the future.

> @@ -362,12 +380,19 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, s=
truct request *req)
>  #endif
>  		}
> =20
> -		if (brq.cmd.error || brq.data.error || brq.stop.error)
> +		if (brq.cmd.error || brq.stop.error)
> +			goto cmd_err;
> +
> +		if (brq.data.error =3D=3D -ETIMEDOUT && rq_data_dir(req) =3D=3D READ) {
> +			spin_lock_irq(&md->lock);
> +			ret =3D __blk_end_request(req, -EIO, brq.data.blksz);
> +			spin_unlock_irq(&md->lock);
> +			continue;
> +		}
> +

This could use a comment explaining that if we've reached this point,
we know that it was a single sector that failed.

> +		if (brq.cmd.error)
>  			goto cmd_err;
> =20
> -		/*
> -		 * A block was successfully transferred.
> -		 */
>  		spin_lock_irq(&md->lock);
>  		ret =3D __blk_end_request(req, 0, brq.data.bytes_xfered);
>  		spin_unlock_irq(&md->lock);

Shouldn't this comment stay now? :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22822-1228071962-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkky5BoACgkQ7b8eESbyJLhQLACgl0aUkHhxjn7bc3qDwhEs1zeg
t9wAnjyJdqKoph9IasZNYeUDgXBN//gj
=wHQ2
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22822-1228071962-0001-2--
