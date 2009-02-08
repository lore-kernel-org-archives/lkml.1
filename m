Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZBHU6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZBHU6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 15:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZBHU5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 15:57:48 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48224 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331AbZBHU5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 15:57:47 -0500
Date: Sun, 8 Feb 2009 21:57:39 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 04/11] sdhci: Add support for card-detection polling
Message-ID: <20090208215739.26fbb34b@mjolnir.drzeus.cx>
In-Reply-To: <20090206180650.GD11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180650.GD11548@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-4104-1234126663-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-4104-1234126663-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Feb 2009 21:06:50 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch adds SDHCI_QUIRK_BROKEN_CARD_DETECTION quirk. When specified,
> sdhci driver will set MMC_CAP_NEEDS_POLL MMC host capability, and won't
> enable card insert/remove interrupts.
>=20
> This is needed for hosts with unreliable card detection, such as FSL
> eSDHC. The original eSDHC driver was tring to "debounce" card-detection
> IRQs by reading present state and disabling particular interrupts. But
> with this debouncing scheme I noticed that sometimes we miss card
> insertion/removal events.
>=20
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

I guess you need to fix the check at the start of the request function
as well.

> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index b7a79a0..45c5f1f 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -162,6 +162,9 @@ static void sdhci_init(struct sdhci_host *host)
>  		SDHCI_INT_DMA_END | SDHCI_INT_DATA_END | SDHCI_INT_RESPONSE |
>  		SDHCI_INT_ADMA_ERROR;
> =20
> +	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
> +		intmask &=3D ~(SDHCI_INT_CARD_REMOVE | SDHCI_INT_CARD_INSERT);
> +

A matter of taste perhaps, but I think it would make more sense to not
add them in the first place than to add and then remove them.

Card detection interrupts should be handled separately anyway as they
should not be enabled before mmc_add_host() returns and should be
disabled before calling mmc_remove_host(). Patch welcome. ;)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-4104-1234126663-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmPR0cACgkQ7b8eESbyJLinhwCgxCrMV6jlNboNhbhJo9PjcO7P
SHoAoLJekCBLVYJpwVQ4TsgkC+3xqln2
=cNsd
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-4104-1234126663-0001-2--
