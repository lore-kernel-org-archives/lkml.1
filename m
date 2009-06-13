Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbZFMKdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbZFMKdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbZFMKcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:32:55 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:33555 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbZFMKcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:32:54 -0400
Date: Sat, 13 Jun 2009 12:32:49 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: dpervushin@embeddedalley.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] Freescale STMP SD/MMC driver
Message-ID: <20090613123249.28304386@mjolnir.ossman.eu>
In-Reply-To: <1244147292.4227.191.camel@hp.diimka.lan>
References: <1244147292.4227.191.camel@hp.diimka.lan>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24447-1244889174-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24447-1244889174-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 05 Jun 2009 00:28:12 +0400
dmitry pervushin <dpervushin@embeddedalley.com> wrote:

> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/highmem.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/completion.h>
> +#include <linux/mmc/mmc.h>

Including this header should never be needed in a host driver. It's a
sign you've violated the layering somewhere.

> +
> +#define CLOCKRATE_MIN 400000
> +#define CLOCKRATE_MAX 48000000
> +

This maximum frequency will never be used as you haven't indicated what
kind of highspeed timing the controller supports (MMC and/or SD).

> +/* Return read only state of card */
> +static int stmp3xxx_mmc_get_ro(struct mmc_host *mmc)
> +{
> +	struct stmp3xxx_mmc_host *host =3D mmc_priv(mmc);
> +	struct stmp3xxxmmc_platform_data *pdata =3D host->dev->platform_data;
> +
> +	if (pdata && pdata->get_wp)
> +		return pdata->get_wp();
> +
> +	return 0;
> +}

You should return -ENOSYS when you do not know the state.

> +/*
> + * Check for MMC command errors
> + * Returns error code or zerro if no errors
> + */
> +static inline int stmp3xxx_mmc_cmd_error(u32 status)
> +{
> +	int err =3D 0;
> +
> +	if (status & BM_SSP_STATUS_TIMEOUT)
> +		err =3D -ETIMEDOUT;
> +	else if (status & BM_SSP_STATUS_RESP_TIMEOUT)
> +		err =3D -ETIMEDOUT;
> +	else if (status & BM_SSP_STATUS_RESP_CRC_ERR)
> +		err =3D -EILSEQ;
> +	else if (status & BM_SSP_STATUS_RESP_ERR)
> +		err =3D -EIO;

When does the controller signal RESP_ERR?

> +/* Copy data between sg list and dma buffer */
> +static unsigned int stmp3xxx_sg_dma_copy(struct stmp3xxx_mmc_host *host,
> +					 unsigned int size, int to_dma)

Why do you need to copy to the DMA buffer? Can't the device DMA
directly to/from where we want?

> +{
> +	struct mmc_data *data =3D host->cmd->data;
> +	unsigned int copy_size, bytes_copied =3D 0;
> +	struct scatterlist *sg;
> +	char *dmabuf =3D host->dma_buf;
> +	char *sgbuf;
> +	int len, i;
> +
> +	sg =3D data->sg;
> +	len =3D data->sg_len;
> +
> +	/*
> +	 * Just loop through all entries. Size might not
> +	 * be the entire list though so make sure that
> +	 * we do not transfer too much.
> +	 */
> +	for (i =3D 0; i < len; i++) {

sg lists are not simply arrays anymore so you have to use the helpers
(sg_next and such).

> +	dev_dbg(host->dev, "ADTC command:\n"
> +		"response: %d, ignore crc: %d\n"
> +		"data list: %u, blocksz: %u, blocks: %u, timeout: %uns %uclks, "
> +		"flags: 0x%x\n", resp, ignore_crc, cmd->data->sg_len,
> +		cmd->data->blksz, cmd->data->blocks, cmd->data->timeout_ns,
> +		cmd->data->timeout_clks, cmd->data->flags);

This is all generic stuff that is already printed by the MMC core.

> +	BUG_ON((data_size % 8) > 0);

This is not a bug. You need to check for this case and handle it
properly (failing it with EINVAL if the hardware is completely
incapable of supporting the request).

> +	/*
> +	 * We need to set the hardware register to the logarithm to base 2 of
> +	 * the block size.
> +	 */

And what if the block size isn't a power of two?

> +	if (cmd->opcode =3D=3D MMC_STOP_TRANSMISSION)
> +		ssp_cmd0 |=3D BM_SSP_CMD0_APPEND_8CYC;

I'm not sure what you're doing here. There should be a 8 cycle pause
after every request, not just this opcode.

> +	cmd->error =3D stmp3xxx_mmc_cmd_error(host->status);

Are you putting data errors in here as well? Because I don't see you
setting data->error anywhere.

> +/* Begin sedning a command to the card */
> +static void stmp3xxx_mmc_start_cmd(struct stmp3xxx_mmc_host *host,
> +				   struct mmc_command *cmd)
> +{
> +	dev_dbg(host->dev, "MMC command:\n"
> +		"type: 0x%x opcode: %u, arg: %u, flags 0x%x retries: %u\n",
> +		mmc_cmd_type(cmd), cmd->opcode, cmd->arg, cmd->flags,
> +		cmd->retries);

This is also printed by the core.

> +/* Configure card */
> +static void stmp3xxx_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *i=
os)
> +{
> +	struct stmp3xxx_mmc_host *host =3D mmc_priv(mmc);
> +	struct stmp3xxxmmc_platform_data *pdata;
> +
> +	dev_dbg(host->dev, "MMC set ios:\n"
> +		"Clock %u, vdd %u, bus_mode %u, chip_select %u, "
> +		"power mode %u, bus_width %u\n", ios->clock, ios->vdd,
> +		ios->bus_mode, ios->chip_select, ios->power_mode,
> +		ios->bus_width);

Also printed by the core.

> +	/* Set minimal clock rate */
> +	host->clk =3D clk_get(NULL, "ssp");
> +	if (IS_ERR(host->clk)) {
> +		err =3D PTR_ERR(host->clk);
> +		dev_err(dev, "clocks initialization failed\n");
> +		goto out_clk;
> +	}
> +
> +	clk_enable(host->clk);
> +	stmp3xxx_set_sclk_speed(host, CLOCKRATE_MIN);
> +
> +	/* Reset MMC block */
> +	stmp3xxx_mmc_reset(host);

I'm not entirely sure what the end result is here, but you really
shouldn't enable the clock until the MMC core tells you to.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24447-1244889174-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozgFUACgkQ7b8eESbyJLiP7ACeJJXLoPqxzKezW/tWN55AmGFV
I44AmgJwEvZ6/ZyjtrW1vmyXZD8P4RUG
=FBFk
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24447-1244889174-0001-2--
