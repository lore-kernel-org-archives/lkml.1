Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZF1OgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZF1OgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbZF1Of4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:35:56 -0400
Received: from smtp-out112.alice.it ([85.37.17.112]:4168 "EHLO
	smtp-out112.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZF1Ofy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:35:54 -0400
Date: Sun, 28 Jun 2009 16:35:42 +0200
From: Antonio Ospite <ospite@studenti.unina.it>
To: Daniel Ribeiro <drwyrm@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       openezx-devel <openezx-devel@lists.openezx.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Harald Welte <laforge@gnumonks.org>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] PCAP touchscreen driver (for 2.6.32)
Message-Id: <20090628163542.89473418.ospite@studenti.unina.it>
In-Reply-To: <1246122138.3727.12.camel@brutus>
References: <1246122138.3727.12.camel@brutus>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Jun_2009_16_35_42_+0200_Nz0ZZRWJBoN7BLj1"
X-OriginalArrivalTime: 28 Jun 2009 14:35:54.0481 (UTC) FILETIME=[BE182610:01C9F7FD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Jun_2009_16_35_42_+0200_Nz0ZZRWJBoN7BLj1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Daniel, some trivial comments, I can do the changes if you want.

On Sat, 27 Jun 2009 14:02:18 -0300
Daniel Ribeiro <drwyrm@gmail.com> wrote:

> Touchscreen driver for PCAP2 PMIC.
>=20
> Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>
>=20
> ---
>  drivers/input/touchscreen/Kconfig   |    9 ++
>  drivers/input/touchscreen/Makefile  |    1 +
>  drivers/input/touchscreen/pcap_ts.c |  235 +++++++++++++++++++++++++++++=
++++++
>  3 files changed, 245 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscree=
n/Kconfig
> index 72e2712..8e6fa8b 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -498,4 +498,13 @@ config TOUCHSCREEN_W90X900
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called w90p910_ts.
> =20
> +config TOUCHSCREEN_PCAP
> +	tristate "Motorola PCAP touchscreen"
> +	depends on EZX_PCAP
> +	help
> +	  Say Y here if you have a Motorola EZX telephone and
> +	  want to support the built-in touchscreen.
> +
> +	  If unsure, say N.
> +
>  endif
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscre=
en/Makefile
> index 3e1c5e0..4599bf7 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -40,3 +40,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)	+=3D atmel-wm97x=
x.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+=3D mainstone-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+=3D zylonite-wm97xx.o
>  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+=3D w90p910_ts.o
> +obj-$(CONFIG_TOUCHSCREEN_PCAP)		+=3D pcap_ts.o
> diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscr=
een/pcap_ts.c
> new file mode 100644
> index 0000000..7877fdf
> --- /dev/null
> +++ b/drivers/input/touchscreen/pcap_ts.c
> @@ -0,0 +1,235 @@
> +/*
> + * Driver for Motorola PCAP2 touchscreen as found in the EZX phone platf=
orm.
> + *
> + *  Copyright (C) 2006 Harald Welte <laforge@openezx.org>
> + *  Copyright (C) 2009 Daniel Ribeiro <drwyrm@gmail.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/string.h>
> +#include <linux/pm.h>
> +#include <linux/timer.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/input.h>
> +#include <linux/mfd/ezx-pcap.h>
> +
> +struct pcap_ts {
> +	struct pcap_chip *pcap;
> +	struct input_dev *input;
> +	struct delayed_work work;
> +	u16 x, y;
> +	u16 pressure;
> +	u8 read_state;
> +};
> +
> +#define SAMPLE_DELAY	20 /* msecs */
> +
> +#define X_AXIS_MIN	0
> +#define X_AXIS_MAX	1023
> +#define Y_AXIS_MAX	X_AXIS_MAX
> +#define Y_AXIS_MIN	X_AXIS_MIN
> +#define PRESSURE_MAX	X_AXIS_MAX
> +#define PRESSURE_MIN	X_AXIS_MIN
> +
> +static void pcap_ts_read_xy(void *data, u16 res[2])
> +{
> +	struct pcap_ts *pcap_ts =3D data;
> +
> +	switch (pcap_ts->read_state) {
> +	case PCAP_ADC_TS_M_PRESSURE:
> +		/* pressure reading is unreliable */
> +		if (res[0] > PRESSURE_MIN && res[0] < PRESSURE_MAX)
> +			pcap_ts->pressure =3D res[0];
> +		pcap_ts->read_state =3D PCAP_ADC_TS_M_XY;
> +		schedule_delayed_work(&pcap_ts->work, 0);
> +		break;
> +	case PCAP_ADC_TS_M_XY:
> +		pcap_ts->y =3D res[0];
> +		pcap_ts->x =3D res[1];
> +		if (pcap_ts->x <=3D X_AXIS_MIN || pcap_ts->x >=3D X_AXIS_MAX ||
> +		    pcap_ts->y <=3D Y_AXIS_MIN || pcap_ts->y >=3D Y_AXIS_MAX) {
> +			/* pen has been released */
> +			input_report_abs(pcap_ts->input, ABS_PRESSURE, 0);
> +			input_report_key(pcap_ts->input, BTN_TOUCH, 0);
> +
> +			pcap_ts->read_state =3D PCAP_ADC_TS_M_STANDBY;
> +			schedule_delayed_work(&pcap_ts->work, 0);
> +		} else {
> +			/* pen is touching the screen*/
> +			input_report_abs(pcap_ts->input, ABS_X, pcap_ts->x);
> +			input_report_abs(pcap_ts->input, ABS_Y, pcap_ts->y);
> +			input_report_key(pcap_ts->input, BTN_TOUCH, 1);
> +			input_report_abs(pcap_ts->input, ABS_PRESSURE,
> +						pcap_ts->pressure);
> +
> +			/* switch back to pressure read mode */
> +			pcap_ts->read_state =3D PCAP_ADC_TS_M_PRESSURE;
> +			schedule_delayed_work(&pcap_ts->work,
> +					msecs_to_jiffies(SAMPLE_DELAY));
> +		}
> +		input_sync(pcap_ts->input);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +static void pcap_ts_work(struct work_struct *work)
> +{
> +	struct delayed_work *dw =3D container_of(work, struct delayed_work, wor=
k);
> +	struct pcap_ts *pcap_ts =3D container_of(dw, struct pcap_ts, work);
> +	u8 ch[2];
> +
> +	pcap_set_ts_bits(pcap_ts->pcap,
> +			pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);
> +
> +	if (pcap_ts->read_state =3D=3D PCAP_ADC_TS_M_STANDBY)
> +		return;
> +
> +	/* start adc conversion */
> +	ch[0] =3D PCAP_ADC_CH_TS_X1;
> +	ch[1] =3D PCAP_ADC_CH_TS_Y1;
> +	pcap_adc_async(pcap_ts->pcap, PCAP_ADC_BANK_1, 0, ch,
> +						pcap_ts_read_xy, pcap_ts);
> +}
> +
> +static irqreturn_t pcap_ts_event_touch(int pirq, void *data)
> +{
> +	struct pcap_ts *pcap_ts =3D data;
> +
> +	if (pcap_ts->read_state =3D=3D PCAP_ADC_TS_M_STANDBY) {
> +		pcap_ts->read_state =3D PCAP_ADC_TS_M_PRESSURE;
> +		schedule_delayed_work(&pcap_ts->work, 0);
> +	}
> +	return IRQ_HANDLED;
> +}
> +
> +static int __devinit pcap_ts_probe(struct platform_device *pdev)
> +{
> +	struct input_dev *input_dev;
> +	struct pcap_ts *pcap_ts;
> +	int err =3D -ENOMEM;
> +
> +	pcap_ts =3D kzalloc(sizeof(*pcap_ts), GFP_KERNEL);
> +	if (!pcap_ts)
> +		return err;
> +
> +	pcap_ts->pcap =3D platform_get_drvdata(pdev);
> +	platform_set_drvdata(pdev, pcap_ts);
> +
> +	input_dev =3D input_allocate_device();
> +	if (!pcap_ts || !input_dev)

Can pcap_ts be ever NULL here? This test can be simplified.

> +		goto fail;
> +
> +	INIT_DELAYED_WORK(&pcap_ts->work, pcap_ts_work);
> +
> +	pcap_ts->read_state =3D PCAP_ADC_TS_M_STANDBY;
> +
> +	pcap_ts->input =3D input_dev;
> +
> +	input_dev->name =3D "pcap-touchscreen";
> +	input_dev->phys =3D "pcap_ts/input0";
> +	input_dev->id.bustype =3D BUS_HOST;
> +	input_dev->id.vendor =3D 0x0001;
> +	input_dev->id.product =3D 0x0002;
> +	input_dev->id.version =3D 0x0100;
> +	input_dev->dev.parent =3D &pdev->dev;
> +
> +	input_dev->evbit[0] =3D BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	input_dev->keybit[BIT_WORD(BTN_TOUCH)] =3D BIT_MASK(BTN_TOUCH);
> +	input_set_abs_params(input_dev, ABS_X, X_AXIS_MIN, X_AXIS_MAX, 0, 0);
> +	input_set_abs_params(input_dev, ABS_Y, Y_AXIS_MIN, Y_AXIS_MAX, 0, 0);
> +	input_set_abs_params(input_dev, ABS_PRESSURE, PRESSURE_MIN,
> +			     PRESSURE_MAX, 0, 0);
> +
> +	err =3D request_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS),
> +			pcap_ts_event_touch, 0, "Touch Screen", pcap_ts);
> +	if (err)
> +		goto fail;
> +
> +	err =3D input_register_device(pcap_ts->input);
> +	if (err)
> +		goto fail_touch;
> +
> +	schedule_delayed_work(&pcap_ts->work, 0);
> +
> +	return 0;
> +
> +fail_touch:
> +	free_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS), pcap_ts);
> +fail:
> +	input_free_device(input_dev);
> +	kfree(pcap_ts);
> +
> +	return err;
> +}
> +
> +static int __devexit pcap_ts_remove(struct platform_device *pdev)
> +{
> +	struct pcap_ts *pcap_ts =3D platform_get_drvdata(pdev);
> +
> +	free_irq(pcap_to_irq(pcap_ts->pcap, PCAP_IRQ_TS), pcap_ts);
> +
> +	input_unregister_device(pcap_ts->input);
> +	cancel_delayed_work_sync(&pcap_ts->work);
> +	kfree(pcap_ts);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int pcap_ts_suspend(struct platform_device *pdev, pm_message_t st=
ate)
> +{
> +	struct pcap_ts *pcap_ts =3D platform_get_drvdata(pdev);
> +
> +	pcap_set_ts_bits(pcap_ts->pcap, PCAP_ADC_TS_REF_LOWPWR);
> +	return 0;
> +}
> +
> +static int pcap_ts_resume(struct platform_device *pdev)
> +{
> +	struct pcap_ts *pcap_ts =3D platform_get_drvdata(pdev);
> +
> +	pcap_set_ts_bits(pcap_ts->pcap,
> +				pcap_ts->read_state << PCAP_ADC_TS_M_SHIFT);
> +	return 0;
> +}
> +#endif
> +

define the suspend/resume callbacks as NULL in a #else here and remove
the #ifdef CONFIG_PM below? That seems to be the most used style.

> +static struct platform_driver pcap_ts_driver =3D {
> +	.probe		=3D pcap_ts_probe,
> +	.remove		=3D __devexit_p(pcap_ts_remove),
> +#ifdef CONFIG_PM
> +	.suspend	=3D pcap_ts_suspend,
> +	.resume		=3D pcap_ts_resume,
> +#endif
> +	.driver		=3D {
> +		.name	=3D "pcap-ts",
> +		.owner	=3D THIS_MODULE,
> +	},
> +};
> +
> +static int __init pcap_ts_init(void)
> +{
> +	return platform_driver_register(&pcap_ts_driver);
> +}
> +
> +static void __exit pcap_ts_exit(void)
> +{
> +	platform_driver_unregister(&pcap_ts_driver);
> +}
> +
> +module_init(pcap_ts_init);
> +module_exit(pcap_ts_exit);
> +
> +MODULE_DESCRIPTION("Motorola PCAP2 touchscreen driver");
> +MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
> +MODULE_LICENSE("GPL");
> --=20
> tg: (8892412..) ezx/pcap_ts (depends on: ezx/local/pcap)
>=20
> --=20
> Daniel Ribeiro


--=20
A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

--Signature=_Sun__28_Jun_2009_16_35_42_+0200_Nz0ZZRWJBoN7BLj1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpHf74ACgkQ5xr2akVTsAEQeQCgkchqOo9xc+HDJ2DsjcPQzeTn
Gs0AoJzJW5lhKUr/fJsOgMbYBwpAhnJw
=8DVR
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Jun_2009_16_35_42_+0200_Nz0ZZRWJBoN7BLj1--
