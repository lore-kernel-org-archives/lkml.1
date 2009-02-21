Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZBUP6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZBUP6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZBUP63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:58:29 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50459 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZBUP62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:58:28 -0500
Date: Sat, 21 Feb 2009 16:58:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 05/13] sdhci: Add support for card-detection polling
Message-ID: <20090221165821.1239aa5a@mjolnir.ossman.eu>
In-Reply-To: <20090213144718.GE23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144718.GE23889@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-15332-1235231906-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15332-1235231906-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2009 17:47:18 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> @@ -1110,13 +1113,18 @@ static void sdhci_request(struct mmc_host *mmc, s=
truct mmc_request *mrq)
> =20
>  	host->mrq =3D mrq;
> =20
> +	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
> +		goto send;
> +
>  	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)
>  		|| (host->flags & SDHCI_DEVICE_DEAD)) {
>  		host->mrq->cmd->error =3D -ENOMEDIUM;
>  		tasklet_schedule(&host->finish_tasklet);
> -	} else
> -		sdhci_send_command(host, mrq->cmd);
> -
> +		goto out;
> +	}
> +send:
> +	sdhci_send_command(host, mrq->cmd);
> +out:
>  	mmiowb();
>  	spin_unlock_irqrestore(&host->lock, flags);
>  }

goto:s seem unnecessary here, and your patch is even incorrect as it
ignores the SDHCI_DEVICE_DEAD flag. Just modify the if-clause and
things will work.

Might want to add a comment also to make it more obvious what the
if-clause does.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15332-1235231906-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJKEACgkQ7b8eESbyJLgiYgCgul2zYdNffIGoipdqiPKO1/nP
5TkAoMa9KdnCdco77jC70kIpJYkXGXTM
=Xy78
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15332-1235231906-0001-2--
