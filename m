Return-Path: <linux-kernel-owner+w=401wt.eu-S1755753AbZDZTup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbZDZTup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 15:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZDZTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 15:50:36 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54566 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZDZTuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 15:50:35 -0400
Date: Sun, 26 Apr 2009 21:50:30 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: cliffcai.sh@gmail.com
Cc: linux-kernel@vger.kernel.org, cliff.cai@analog.com,
       Cliff Cai <cliffcai.sh@gmail.com>
Subject: Re: [PATCH][RESEND][mmc/host]:Blackfin SD Host Controller Driver
Message-ID: <20090426215030.582a6fbb@mjolnir.ossman.eu>
In-Reply-To: <1239903641-14342-1-git-send-email-cliffcai.sh@gmail.com>
References: <1239903641-14342-1-git-send-email-cliffcai.sh@gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-17147-1240775431-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-17147-1240775431-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Apr 2009 01:40:41 +0800
cliffcai.sh@gmail.com wrote:

> From: Cliff Cai <cliffcai.sh@gmail.com>
>=20
> Signed-off-by: Cliff Cai <cliffcai.sh@gmail.com>
> ---
>  drivers/mmc/host/Kconfig    |   19 ++
>  drivers/mmc/host/Makefile   |    1 +
>  drivers/mmc/host/bfin_sdh.c |  648 +++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 668 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mmc/host/bfin_sdh.c
>=20

I'd also like a MAINTAINERS entry for the driver.

> +config SDH_BFIN
> +	tristate "Blackfin Secure Digital Host support"
> +	depends on MMC && ((BF54x && !BF544) || (BF51x && !BF512))

You don't need "depends on MMC" as the entire block is conditioned on
MMC already.

> +/* In term of ADSP_BF5xx_Blackfin_Processor_Peripheral_Hardware_Referenc=
e,
> + * the SDH allows software to detect a card when it is inserted into its=
 slot.
> + * The SD_DATA3 pin powers up low due to a special pull-down resistor. W=
hen an
> + * SD Card is inserted in its slot, the resistance increases and a risin=
g edge
> + * is detected by the SDH module.
> + * But this doesn't work sometimes. When a MMC/SD card is inserted, the =
voltage
> + * doesn't rise on SD_DATA3. In term of The MultiMediaCard System Specif=
ication,
> + * SD_DATA3 is used as CS pin in SPI mode. The MultiMediaCard wakes up i=
n the
> + * MultiMediaCard mode. During the scan procedure, host will send CMD0 t=
o reset
> + * MMC card, if CS pin is low, MMC card will enter SPI mode. Of course S=
ecure
> + * Digital Host controller is not a SPI controller. So the Card detect f=
unction
> + * has to be disabled. After card is inserted run "echo 0 > /proc/driver=
/sdh"
> + * to trigger card scanning */

If the controller can only do DAT3-detection, then I think it's best if
we put it into polling mode.

> +	BUG_ON(data->blksz & (data->blksz -1));

Not a bug so you need to deal with this. Most likely fail the request
with EINVAL.

> +#if defined(CONFIG_BF54x)
> +	dma_cfg |=3D DMAFLOW_ARRAY | NDSIZE_5 | RESTART | WDSIZE_32 | DMAEN;
> +	for (i =3D 0; i < host->dma_len; i++) {
> +		host->sg_cpu[i].start_addr =3D sg_dma_address(&data->sg[i]);

You cannot index sg lists directly anymore. You have to iterate over
them using the iteration helpers.

> +	if (!data->error)
> +		data->bytes_xfered =3D data->blocks * data->blksz;
> +	else
> +		data->bytes_xfered =3D data->blocks * data->blksz - \
> +				     bfin_read_SDH_DATA_CNT();

This is probably wrong. You need to set bytes_xfered to the number of
bytes acked by the card, not the number of bytes sent over the wire
(for writes that is). If your hardware can provide that then fine,
otherwise set bytes_xfered to 0 on failure.

> +	mmc->ops =3D &sdh_ops;
> +	mmc->max_phys_segs =3D NR_SG;
> +	mmc->max_seg_size =3D 1 << 16;
> +	mmc->max_blk_size =3D 2 << 11;
> +	mmc->max_blk_count =3D 2 << 16;

You forgot max_req_size.

> +out3:
> +	free_dma(host->dma_ch);

You need a mmc_remove_host() here.

Also check Mike's comments.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-17147-1240775431-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkn0uwgACgkQ7b8eESbyJLilAACgimO69ZC1nv3uT1OxMmsk9CGH
odkAn2Xtw3JHjoCdAqyxcCBBhYUXv+zM
=DvAp
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-17147-1240775431-0001-2--
