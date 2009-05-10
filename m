Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZEJSma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZEJSma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756042AbZEJSmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:42:21 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:37557 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZEJSmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:42:21 -0400
Date: Sun, 10 May 2009 20:42:14 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: "Li, Jiebing" <jiebing.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Subject: Re: [PATCH 2/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Message-ID: <20090510204214.2c0ce736@mjolnir.ossman.eu>
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE029D298B1FF@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
	<95608CFE3D0C064B8468DB61F8403BE029D298B1FF@PDSMSX501.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-6087-1241980939-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-6087-1241980939-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2009 17:19:06 +0800
"Li, Jiebing" <jiebing.li@intel.com> wrote:

>=20
> This patch enables support of SDIO bus driver suspend/resume operation an=
d supply sysfs interface for user
> to call suspend/resume selectively.Remind that this function should work =
together with SDIO device driver's
> suspend/resume function.
>=20

As Matthew asked, what's the use case?

> And Moorestown's specific code is added into this patch to enable the sec=
ond SDIO slot of the host controller.
>=20

Again, stop mixing unrelated things in the same patch.

> @@ -452,3 +828,84 @@ err:
>         return err;
>  }
>=20
> +/*
> + * warn device driver and perform a SDIO device reset.
> + * Assume that device driver knows hot to handle resets.
> + */
> +int sdio_reset_device(struct mmc_card *card)
> +{

Use case?

> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index b4cf691..0c9d2eb 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -44,6 +44,14 @@ config MMC_SDHCI_IO_ACCESSORS
>           This is silent Kconfig symbol that is selected by the drivers t=
hat
>           need to overwrite SDHCI IO memory accessors.
>=20
> +config MMC_SDHCI_MRST_SDIO1
> +       bool
> +       depends on MMC_SDHCI
> +       help
> +         This enables Moorestown SD host controller's 2nd SDIO slot.
> +
> +         If unsure, say N.
> +

Detect this at runtime.

> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index a2804f1..4d4ad6d 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -914,6 +914,17 @@ static void sdhci_send_command(struct sdhci_host *ho=
st, struct mmc_command *cmd)
>         if (cmd->data)
>                 flags |=3D SDHCI_CMD_DATA;
>=20
> +#ifdef CONFIG_MMC_SDHCI_MRST_SDIO1
> +       if (host->quirks & SDHCI_QUIRK_MRST_RESTRICTION) {
> +               u16 clk;
> +
> +               clk =3D sdhci_readw(host, SDHCI_CLOCK_CONTROL);
> +
> +               clk |=3D SDHCI_CLOCK_CARD_EN;
> +               sdhci_writew(host, clk, SDHCI_CLOCK_CONTROL);
> +       }
> +#endif
> +
>         sdhci_writew(host, SDHCI_MAKE_CMD(cmd->opcode, flags), SDHCI_COMM=
AND);
>  }
>=20

Huh? Is this some kind of multiplexed nonsense?

> diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> index fa87b8b..50be698 100644
> --- a/drivers/mmc/host/sdhci.h
> +++ b/drivers/mmc/host/sdhci.h
> @@ -227,6 +227,8 @@ struct sdhci_host {
>  #define SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET           (1<<19)
>  /* Controller has to be forced to use block size of 2048 bytes */
>  #define SDHCI_QUIRK_FORCE_BLK_SZ_2048                  (1<<20)
> +/* Controller of Moorestown specific restriction */
> +#define SDHCI_QUIRK_MRST_RESTRICTION                   (1<<21)
>=20

No. Quirks should be defined in a way that allows reuse.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-6087-1241980939-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoHIAsACgkQ7b8eESbyJLgxZACg8y0pWebXbvU34C0EGXszHOdV
USkAoIGUjl96gBhoqotvAYviSnhQXBrt
=VATr
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-6087-1241980939-0001-2--
