Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZEJS3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZEJS3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 14:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZEJS3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 14:29:12 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36181 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782AbZEJS3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 14:29:11 -0400
Date: Sun, 10 May 2009 20:29:00 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: "Li, Jiebing" <jiebing.li@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Johnson, Charles F" <charles.f.johnson@intel.com>,
       "Zhu, Daniel" <daniel.zhu@intel.com>,
       "Yuan, Hang" <hang.yuan@intel.com>,
       "Pasrija, Geeta" <geeta.pasrija@intel.com>,
       "Li, Jiebing" <jiebing.li@intel.com>
Subject: Re: [PATCH 1/2] MMC: MMC/SD/CE-ATA/SDIO driver for Intel Moorestown
  platform
Message-ID: <20090510202900.55c2d60b@mjolnir.ossman.eu>
In-Reply-To: <95608CFE3D0C064B8468DB61F8403BE029D298B1FC@PDSMSX501.ccr.corp.intel.com>
References: <95608CFE3D0C064B8468DB61F8403BE029D298B1F7@PDSMSX501.ccr.corp.intel.com>
	<95608CFE3D0C064B8468DB61F8403BE029D298B1FC@PDSMSX501.ccr.corp.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-5730-1241980147-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-5730-1241980147-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Apr 2009 17:16:47 +0800
"Li, Jiebing" <jiebing.li@intel.com> wrote:

>=20
> This patch enables CE-ATA HDD support including device initialization and=
  data read/write.
> Validation has been passed with TOSHIBA, SAMSUNG and HITACHI devices.
>=20

I got the impression that CE-ATA was more or less dead. Are there any
devices still being produced?

> And this patch also works for Moorestown platform by dealing with slicon/=
hardware limitations:
> 1. Slot number and first BAR values are fixed instead of reading from PCI=
 configuration space.
> 2. Clock speed is restricted to normal-speed.
> 3. ADMA operation is disabled by adding quirks.

Don't mix things in one patch. You'll need to split things up and do
one change at a time.

> diff --git a/drivers/mmc/Kconfig b/drivers/mmc/Kconfig
> index f2eeb38..3d1c83b 100644
> --- a/drivers/mmc/Kconfig
> +++ b/drivers/mmc/Kconfig
> @@ -19,6 +19,25 @@ config MMC_DEBUG
>           This is an option for use by developers; most people should
>           say N here.  This enables MMC core and driver debugging.
>=20
> +config MRST_MMC_WR
> +       bool "MMC/SD/CEATA workaround for Moorestown"
> +       depends on MMC
> +       help
> +         This is an option for Moorestown developers to add workaround
> +         in the code due to Silicon issues.

No. This should be handled at runtime and through proper detection of
the buggy device. And if it's just for unreleased silicon, then it
shouldn't be in the mainline kernel at all.

> +config MMC_CEATA_WR
> +       bool "disable SDIO device search to support CEATA"
> +       depends on MMC
> +       help
> +         This disables SDIO device search process to support various
> +         brands of CE-ATA devices as some CE-ATA devices may pretends
> +         itself as a SDIO device.
> +
> +         If you want SDIO support, you should say N here and if you
> +         want to support as many as kinds of CE-ATA devices,you should
> +         say Y. If you want to support both SDIO and CE-ATA, just say N.
> +

What kind of SDIO device do these cards present? Can't we support that
as well and avoid this hack?

> +static int ceata_blk_issue_rq(struct mmc_queue *mq, struct request *req)
> +{

This routine shares a lot of code with the MMC/SD handler. Do a better
separation so that we don't have all this code duplication (with
associated lack of bug fixes).

> @@ -449,6 +541,9 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, str=
uct request *req)
>=20
>  static inline int mmc_blk_readonly(struct mmc_card *card)
>  {
> +       if (mmc_card_ceata(card))
> +               return 0;
> +

The read-only flag would not be set on CEATA, so this is meaningless.

> @@ -511,11 +610,20 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mm=
c_card *card)
>          * messages to tell when the card is present.
>          */
>=20
> -       sprintf(md->disk->disk_name, "mmcblk%d", devidx);
> +       snprintf(md->disk->disk_name, sizeof(md->disk->disk_name),
> +               "mmcblk%d", devidx);
>=20

Unrelated change. Send a separate patch.

>         blk_queue_hardsect_size(md->queue.queue, 512);
>=20
> -       if (!mmc_card_sd(card) && mmc_card_blockaddr(card)) {
> +       if (mmc_card_ceata(card)) {
> +               /* max_lba[0] covers all current ceata devices */
> +               WARN_ON(card->ceata_info->max_lba[1]);

If the standard defines max_lba[1], we might as well be prepared to
handle it.

> @@ -575,7 +683,8 @@ static int mmc_blk_probe(struct mmc_card *card)
>         /*
>          * Check that the card supports the command class(es) we need.
>          */
> -       if (!(card->csd.cmdclass & CCC_BLOCK_READ))
> +       if (!(card->csd.cmdclass & CCC_BLOCK_READ) &&
> +       !mmc_card_ceata(card))
>                 return -ENODEV;
>=20

Indentation.

> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index bdb165f..5f66c5a 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -36,6 +36,8 @@ static ssize_t mmc_type_show(struct device *dev,
>                 return sprintf(buf, "SD\n");
>         case MMC_TYPE_SDIO:
>                 return sprintf(buf, "SDIO\n");
> +       case MMC_TYPE_CEATA:
> +               return snprintf(buf, sizeof(buf), "CEATA\n");
>         default:
>                 return -EFAULT;
>         }

CEATA is a sub-type of MMC, and compatible enough that only mmc_block
needs to care about the difference. I'm not sure we need a new type
here.

> diff --git a/drivers/mmc/core/ceata.c b/drivers/mmc/core/ceata.c

All of the stuff in this file seems to be things that only mmc_block
needs. As such, move it into that module and don't fill up the core
with it.

It's probably still a good idea to have all of it in it's own file
though.

> +
> +       printk(KERN_ERR "%s: after %d ms wait, CE-ATA still busy\n",
> +                       mmc_hostname(card->host), wait);

This is a lie. As the command takes some time to execute, just assuming
that the loops have taken roughly 1 ms is incorrect.

> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index fa073ab..2aa638d 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -248,6 +248,18 @@ void mmc_set_data_timeout(struct mmc_data *data, con=
st struct mmc_card *card)
>         unsigned int mult;
>=20
>         /*
> +        * CEATA hdds could take as long as 35 s in corner cases,
> +        * according to at least one datasheet.
> +        * TODO: implement longer timeout in SW, since max HW timeout
> +        * is just ~2 s (2^27 / 48MHz)
> +        */

There is no way you can handle this in software as you'll be unable to
read the response from the card.

Does the CE-ATA spec really allow timeouts larger than the MMC spec.?
Or have the card vendors just decided to ignore the specs?

> @@ -715,8 +727,12 @@ static void mmc_power_up(struct mmc_host *host)
>         /*
>          * This delay must be at least 74 clock sizes, or 1 ms, or the
>          * time required to reach a stable voltage.
> +        *
> +        * Three different CEATA hdds from Toshiba, Samsung
> +        * and Hitachi fail when the delay is less than 20 ms, but
> +        * work with 40 ms (doubling just in case).
>          */
> -       mmc_delay(2);
> +       mmc_delay(80);
>  }
>=20

How do they fail?

> @@ -121,7 +122,7 @@ static int mmc_decode_csd(struct mmc_card *card)
>          * v1.2 has extra information in bits 15, 11 and 10.
>          */
>         csd_struct =3D UNSTUFF_BITS(resp, 126, 2);
> -       if (csd_struct !=3D 1 && csd_struct !=3D 2) {
> +       if (csd_struct !=3D 1 && csd_struct !=3D 2 && csd_struct !=3D 3) {
>                 printk(KERN_ERR "%s: unrecognised CSD structure version %=
d\n",
>                         mmc_hostname(card->host), csd_struct);
>                 return -EINVAL;

This should probably also go in a separate patch.

> @@ -285,6 +288,39 @@ static struct device_type mmc_type =3D {
>         .groups =3D mmc_attr_groups,
>  };
>=20
> +MMC_DEV_ATTR(capacity, "%d KB\n", card->ceata_info->max_lba[0] / 2);
> +MMC_DEV_ATTR(seclen, "%d bytes\n", 1 << card->ceata_info->seclen);

Redundant. You'll get this info from the block layer.

> +MMC_DEV_ATTR(globalid, "%08x%08x\n", card->ceata_info->global_id[1],
> +       card->ceata_info->global_id[0]);
> +MMC_DEV_ATTR(serial2, "%s\n", card->ceata_info->serialnum);
> +MMC_DEV_ATTR(fwrev2, "%s\n", card->ceata_info->fw_ver);
> +MMC_DEV_ATTR(model, "%s\n", card->ceata_info->model_num);

Have you made sure these have the same names and formats as the libata
counterparts?

> @@ -614,22 +637,40 @@ static int __devinit sdhci_pci_probe(struct pci_dev=
 *pdev,
>         dev_info(&pdev->dev, "SDHCI controller found [%04x:%04x] (rev %x)=
\n",
>                  (int)pdev->vendor, (int)pdev->device, (int)rev);
>=20
> -       ret =3D pci_read_config_byte(pdev, PCI_SLOT_INFO, &slots);
> -       if (ret)
> -               return ret;
> +       /*
> +        * slots number is fixed to 2 by Moorestown architecture
> +        */
> +       if (pdev->device =3D=3D PCI_DEVICE_ID_INTEL_MRST_SD0 ||
> +               pdev->device =3D=3D PCI_DEVICE_ID_INTEL_MRST_SD1) {
> +               slots =3D 1;

Comment and code do not match. And how many slots are in the slots field
in the PCI configuration?

> -       ret =3D pci_read_config_byte(pdev, PCI_SLOT_INFO, &first_bar);
> -       if (ret)
> -               return ret;
> +       /*
> +        * first BAR is fixed to 0 by Moorestown architecture
> +        */
> +       if (pdev->device =3D=3D PCI_DEVICE_ID_INTEL_MRST_SD0 ||
> +               pdev->device =3D=3D PCI_DEVICE_ID_INTEL_MRST_SD1) {
> +               first_bar =3D 0;

Same here, what's in the PCI config?

Both should be handled by quirks anyway.

> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 9234be2..a2804f1 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1123,12 +1123,18 @@ static void sdhci_set_ios(struct mmc_host *mmc, s=
truct mmc_ios *ios)
>=20
>         ctrl =3D sdhci_readb(host, SDHCI_HOST_CONTROL);
>=20
> -       if (ios->bus_width =3D=3D MMC_BUS_WIDTH_4)
> +       if (ios->bus_width =3D=3D MMC_BUS_WIDTH_8) {
> +               ctrl |=3D SDHCI_CTRL_8BITBUS;
>                 ctrl |=3D SDHCI_CTRL_4BITBUS;
> -       else
> +       } else if (ios->bus_width =3D=3D MMC_BUS_WIDTH_4) {
> +               ctrl &=3D ~SDHCI_CTRL_8BITBUS;
> +               ctrl |=3D SDHCI_CTRL_4BITBUS;
> +       } else {
> +               ctrl &=3D ~SDHCI_CTRL_8BITBUS;
>                 ctrl &=3D ~SDHCI_CTRL_4BITBUS;
> +       }

This is not in any spec I've seen. :)

>=20
> -       if (ios->timing =3D=3D MMC_TIMING_SD_HS)
> +       if (ios->timing =3D=3D MMC_TIMING_SD_HS || ios->timing =3D=3D MMC=
_TIMING_MMC_HS)
>                 ctrl |=3D SDHCI_CTRL_HISPD;
>         else
>                 ctrl &=3D ~SDHCI_CTRL_HISPD;
> @@ -1724,7 +1730,7 @@ int sdhci_add_host(struct sdhci_host *host)
>         mmc->caps =3D MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
>=20
>         if (caps & SDHCI_CAN_DO_HISPD)
> -               mmc->caps |=3D MMC_CAP_SD_HIGHSPEED;
> +               mmc->caps |=3D MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPE=
ED;
>=20
>         if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
>                 mmc->caps |=3D MMC_CAP_NEEDS_POLL;

No, this isn't safe.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-5730-1241980147-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoHHPEACgkQ7b8eESbyJLhwPQCg6pYV0UIuEt6liJSVXodE1pU3
7n0AoNZbfEef8Stg5WCy4DCTbLNKuI/1
=wEpA
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-5730-1241980147-0001-2--
