Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZKMLKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZKMLKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbZKMLKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:10:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48253 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbZKMLKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:10:31 -0500
Date: Fri, 13 Nov 2009 12:10:19 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/3] [V2] mpc52xx_spi: add gpio chipselect
Message-ID: <20091113111019.GA3563@pengutronix.de>
References: <1257844329-20687-1-git-send-email-l.fu@pengutronix.de> <1258108877-25435-1-git-send-email-l.fu@pengutronix.de> <1258108877-25435-2-git-send-email-l.fu@pengutronix.de> <1258108877-25435-3-git-send-email-l.fu@pengutronix.de> <1258108877-25435-4-git-send-email-l.fu@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <1258108877-25435-4-git-send-email-l.fu@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2009 at 11:41:17AM +0100, Luotao Fu wrote:
> This one enables the mpc52xx_spi driver for usage of user defined gpio li=
nes
> as chipselect. This way we can control some more spi devices than only one
>=20
> V2 Changes:
> * preinitialize the gpio as output in probe function and call gpio_set_va=
lue in
>   the chip select function instead of calling direction_output every time.
> * initialize the gpio line with output high, since we don't support CS_HI=
GH
>   in the driver currently any way. change gpio value setting to default a=
ctive
>   low in chip select call.
> * free the gpio array while error or removing.
>=20
> Signed-off-by: Luotao Fu <l.fu@pengutronix.de>

Just the kfree-comment, otherwise:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

> ---
>  drivers/spi/mpc52xx_spi.c |   64 +++++++++++++++++++++++++++++++++++++++=
+++---
>  1 files changed, 60 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/spi/mpc52xx_spi.c b/drivers/spi/mpc52xx_spi.c
> index 64862cf..97beba2 100644
> --- a/drivers/spi/mpc52xx_spi.c
> +++ b/drivers/spi/mpc52xx_spi.c
> @@ -21,6 +21,7 @@
>  #include <linux/spi/mpc52xx_spi.h>
>  #include <linux/of_spi.h>
>  #include <linux/io.h>
> +#include <linux/of_gpio.h>
>  #include <asm/time.h>
>  #include <asm/mpc52xx.h>
> =20
> @@ -79,7 +80,6 @@ struct mpc52xx_spi {
>  	spinlock_t lock;
>  	struct work_struct work;
> =20
> -
>  	/* Details of current transfer (length, and buffer pointers) */
>  	struct spi_message *message;	/* current message */
>  	struct spi_transfer *transfer;	/* current transfer */
> @@ -89,6 +89,8 @@ struct mpc52xx_spi {
>  	u8 *rx_buf;
>  	const u8 *tx_buf;
>  	int cs_change;
> +	int gpio_cs_count;
> +	unsigned int *gpio_cs;
>  };
> =20
>  /*
> @@ -96,7 +98,13 @@ struct mpc52xx_spi {
>   */
>  static void mpc52xx_spi_chipsel(struct mpc52xx_spi *ms, int value)
>  {
> -	out_8(ms->regs + SPI_PORTDATA, value ? 0 : 0x08);
> +	int cs;
> +
> +	if (ms->gpio_cs_count > 0) {
> +		cs =3D ms->message->spi->chip_select;
> +		gpio_set_value(ms->gpio_cs[cs], value ? 0 : 1);
> +	} else
> +		out_8(ms->regs + SPI_PORTDATA, value ? 0 : 0x08);
>  }
> =20
>  /*
> @@ -390,8 +398,9 @@ static int __devinit mpc52xx_spi_probe(struct of_devi=
ce *op,
>  	struct spi_master *master;
>  	struct mpc52xx_spi *ms;
>  	void __iomem *regs;
> -	int rc;
>  	u8 ctrl1;
> +	int rc, i =3D 0;
> +	int gpio_cs;
> =20
>  	/* MMIO registers */
>  	dev_dbg(&op->dev, "probing mpc5200 SPI device\n");
> @@ -426,8 +435,8 @@ static int __devinit mpc52xx_spi_probe(struct of_devi=
ce *op,
>  		rc =3D -ENOMEM;
>  		goto err_alloc;
>  	}
> +
>  	master->bus_num =3D -1;
> -	master->num_chipselect =3D 1;
>  	master->setup =3D mpc52xx_spi_setup;
>  	master->transfer =3D mpc52xx_spi_transfer;
>  	master->mode_bits =3D SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
> @@ -441,6 +450,40 @@ static int __devinit mpc52xx_spi_probe(struct of_dev=
ice *op,
>  	ms->irq1 =3D irq_of_parse_and_map(op->node, 1);
>  	ms->state =3D mpc52xx_spi_fsmstate_idle;
>  	ms->ipb_freq =3D mpc5xxx_get_bus_frequency(op->node);
> +	ms->gpio_cs_count =3D of_gpio_count(op->node);
> +	if (ms->gpio_cs_count > 0) {
> +		master->num_chipselect =3D ms->gpio_cs_count;
> +		ms->gpio_cs =3D kmalloc(ms->gpio_cs_count * sizeof(unsigned int),
> +				GFP_KERNEL);
> +		if (!ms->gpio_cs) {
> +			rc =3D -ENOMEM;
> +			goto err_alloc;
> +		}
> +
> +		for (i =3D 0; i < ms->gpio_cs_count; i++) {
> +			gpio_cs =3D of_get_gpio(op->node, i);
> +			if (gpio_cs < 0) {
> +				dev_err(&op->dev,
> +					"could not parse the gpio field "
> +					"in oftree\n");
> +				rc =3D -ENODEV;
> +				goto err_gpio;
> +			}
> +
> +			rc =3D gpio_request(gpio_cs, dev_name(&op->dev));
> +			if (rc) {
> +				dev_err(&op->dev,
> +					"can't request spi cs gpio #%d "
> +					"on gpio line %d\n", i, gpio_cs);
> +				goto err_gpio;
> +			}
> +
> +			gpio_direction_output(gpio_cs, 1);
> +			ms->gpio_cs[i] =3D gpio_cs;
> +		}
> +	} else
> +		master->num_chipselect =3D 1;
> +
>  	spin_lock_init(&ms->lock);
>  	INIT_LIST_HEAD(&ms->queue);
>  	INIT_WORK(&ms->work, mpc52xx_spi_wq);
> @@ -477,6 +520,12 @@ static int __devinit mpc52xx_spi_probe(struct of_dev=
ice *op,
>   err_register:
>  	dev_err(&ms->master->dev, "initialization failed\n");
>  	spi_master_put(master);
> + err_gpio:
> +	while (i-- > 0)
> +		gpio_free(ms->gpio_cs[i]);
> +
> +	if (ms->gpio_cs !=3D NULL)
> +		kfree(ms->gpio_cs);

kfree() is NULL aware, so no if needed.

>   err_alloc:
>   err_init:
>  	iounmap(regs);
> @@ -487,10 +536,17 @@ static int __devexit mpc52xx_spi_remove(struct of_d=
evice *op)
>  {
>  	struct spi_master *master =3D dev_get_drvdata(&op->dev);
>  	struct mpc52xx_spi *ms =3D spi_master_get_devdata(master);
> +	int i;
> =20
>  	free_irq(ms->irq0, ms);
>  	free_irq(ms->irq1, ms);
> =20
> +	for (i =3D 0; i < ms->gpio_cs_count; i++)
> +		gpio_free(ms->gpio_cs[i]);
> +
> +	if (ms->gpio_cs !=3D NULL)
> +		kfree(ms->gpio_cs);

ditto.

> +
>  	spi_unregister_master(master);
>  	spi_master_put(master);
>  	iounmap(ms->regs);
> --=20
> 1.6.5.2
>=20
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr9PpsACgkQD27XaX1/VRtDeQCdF9aF62sEtOdLD9XkUqaKg4e1
OO8AnijPFkv2a+f17NUf+SWSkP0c6ksk
=KHPk
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
