Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZBUP6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZBUP6e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 10:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZBUP6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 10:58:15 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50459 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbZBUP6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 10:58:14 -0500
Date: Sat, 21 Feb 2009 16:58:07 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Arnd Bergmann <arnd@arndb.de>, Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 03/13] sdhci: Split card-detection IRQs management from
 sdhci_init()
Message-ID: <20090221165807.3d78c35f@mjolnir.ossman.eu>
In-Reply-To: <20090213144715.GC23889@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144715.GC23889@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-15227-1235231892-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15227-1235231892-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Feb 2009 17:47:15 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> Card detection interrupts should be handled separately as they should
> not be enabled before mmc_add_host() returns and should be disabled
> before calling mmc_remove_host(). The same is for suspend and resume
> routines.
>=20
> sdhci_init() no longer enables card-detection irqs. Instead, two new
> functions implemented: sdhci_enable_card_detection() and
> sdhci_disable_card_detection().
>=20
> New sdhci_reinit() call implemented to behave the same way as the old
> sdhci_init().
>=20
> Also, this patch implements and uses few new helpers to manage IRQs in
> a more conveinient way, that is:
>=20
> - sdhci_clear_set_irqs()
> - sdhci_unmask_irqs()
> - sdhci_mask_irqs()
> - SDHCI_INT_ALL_MASK constant
>=20
> sdhci_enable_sdio_irq() converted to these new helpers, plus the
> helpers will be used by the subsequent patches.
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

That's a lot of indirection, but fair enough. :)

> @@ -1792,6 +1832,8 @@ int sdhci_add_host(struct sdhci_host *host)
> =20
>  	mmc_add_host(mmc);
> =20
> +	sdhci_enable_card_detection(host);
> +
>  	printk(KERN_INFO "%s: SDHCI controller on %s [%s] using %s%s\n",
>  		mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
>  		(host->flags & SDHCI_USE_ADMA)?"A":"",

There is a small race here, but I'm not sure it's worth dealing with.

> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index e907441..45c8309 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -124,6 +124,10 @@
>  		SDHCI_INT_DATA_AVAIL | SDHCI_INT_SPACE_AVAIL | \
>  		SDHCI_INT_DATA_TIMEOUT | SDHCI_INT_DATA_CRC | \
>  		SDHCI_INT_DATA_END_BIT)
> +#define SDHCI_INT_ALL_MASK	(SDHCI_INT_CMD_MASK | SDHCI_INT_DATA_MASK | \
> +		SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE | \
> +		SDHCI_INT_CARD_INT | SDHCI_INT_ERROR | SDHCI_INT_BUS_POWER | \
> +		SDHCI_INT_ACMD12ERR | SDHCI_INT_ADMA_ERROR)
> =20

In the context this is used, why not just use (unsigned)-1?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15227-1235231892-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJJMACgkQ7b8eESbyJLj59QCgpiJ2ffBLK8g3mLGbyl2G5goP
OK0AnjCB7Gxi5FEmSoeVg1HU5p2IdZpe
=VpV9
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15227-1235231892-0001-2--
