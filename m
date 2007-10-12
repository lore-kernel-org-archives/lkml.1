Return-Path: <linux-kernel-owner+w=401wt.eu-S1759735AbXJLHwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735AbXJLHwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXJLHwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:52:08 -0400
Received: from donetsk.donpac.ru ([80.254.111.38]:49573 "EHLO
	donetsk.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbXJLHwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:52:06 -0400
Date: Fri, 12 Oct 2007 11:51:56 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Bryan Wu <bryan.wu@analog.com>
Cc: dmitry.torokhov@gmail.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142
	joystick driver
Message-ID: <20071012075156.GA23378@pazke.donpac.ru>
Mail-Followup-To: Bryan Wu <bryan.wu@analog.com>, dmitry.torokhov@gmail.com,
	linux-input@atrey.karlin.mff.cuni.cz,
	linux-joystick@atrey.karlin.mff.cuni.cz,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1192174727.6247.20.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1192174727.6247.20.camel@roc-laptop>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 285, 10 12, 2007 at 03:38:47PM +0800, Bryan Wu wrote:
> Subject: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystic=
k driver
>=20
> [try #2] Changelog:
>  - Coding style issues fixed, passed checkpatch.pl
>  - Kill uselss "ad7142_used"
>  - Move request_irq to probe
>  - Move i2c_check_functionality to probe
>  - Error handling added
>=20
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> ---
>  drivers/input/joystick/Kconfig  |   16 ++
>  drivers/input/joystick/Makefile |    1 +
>  drivers/input/joystick/ad7142.c |  485 +++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 502 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/joystick/ad7142.c
>=20
> diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kcon=
fig
> index 7c662ee..aeb7cc9 100644
> --- a/drivers/input/joystick/Kconfig
> +++ b/drivers/input/joystick/Kconfig
> @@ -282,4 +282,20 @@ config JOYSTICK_XPAD_LEDS
>  	  This option enables support for the LED which surrounds the Big X on
>  	  XBox 360 controller.
> =20
> +config JOYSTICK_AD7142
> +         tristate "Analog Devices AD7142 Joystick support"
> +         depends on BFIN && I2C
> +         help
> +           Say Y here if you want to support an AD7142 joystick
> +
> +
> + config BFIN_JOYSTICK_IRQ_PFX
> +         int "GPIO for Interrupt"
> +         depends on (BFIN && JOYSTICK_AD7142)
> +         range 33 120
> +         default "55" if BFIN537_STAMP
> +         default "39" if BFIN533_STAMP
> +         help
> +           Choose an GPIO as Keypad interrupt.[0..15]
> +
>  endif
> diff --git a/drivers/input/joystick/Makefile b/drivers/input/joystick/Mak=
efile
> index e855abb..8df388f 100644
> --- a/drivers/input/joystick/Makefile
> +++ b/drivers/input/joystick/Makefile
> @@ -5,6 +5,7 @@
>  # Each configuration option enables a list of files.
> =20
>  obj-$(CONFIG_JOYSTICK_A3D)		+=3D a3d.o
> +obj-$(CONFIG_JOYSTICK_AD7142)		+=3D ad7142.o
>  obj-$(CONFIG_JOYSTICK_ADI)		+=3D adi.o
>  obj-$(CONFIG_JOYSTICK_AMIGA)		+=3D amijoy.o
>  obj-$(CONFIG_JOYSTICK_ANALOG)		+=3D analog.o
> diff --git a/drivers/input/joystick/ad7142.c b/drivers/input/joystick/ad7=
142.c
> new file mode 100644
> index 0000000..c31e639
> --- /dev/null
> +++ b/drivers/input/joystick/ad7142.c
> @@ -0,0 +1,485 @@
> +/*
> + * File:         drivers/input/joystick/ad7142.c
> + * Based on:     drivers/input/joystick/amijoy.c
> + * Original Author: Aubrey Li
> + * Maintained by: Bryan Wu <bryan.wu@analog.com>
> + *
> + * Created:      Apr 7th, 2006
> + * Description:
> + *
> + * Modified:
> + *               Copyright 2005-2007 Analog Devices Inc.
> + *
> + * Bugs:         Enter bugs at http://blackfin.uclinux.org/
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; see the file COPYING.
> + * If not, write to the Free Software Foundation,
> + * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + */
> +
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/interrupt.h>
> +#include <linux/i2c.h>
> +#include <linux/delay.h>
> +#include <linux/kthread.h>
> +#include <linux/uaccess.h>
> +#include <linux/irq.h>
> +
> +#include <asm/blackfin.h>
> +
> +MODULE_AUTHOR("Aubrey Li, Bryan Wu <bryan.wu@analog.com>");
> +MODULE_DESCRIPTION("Driver for AD7142 joysticks");
> +MODULE_LICENSE("GPL");
> +
> +/*
> + * Feeding the output queue to the device is handled by way of a
> + * workqueue.
> + */
> +static struct task_struct *ad7142_task;
> +static DECLARE_WAIT_QUEUE_HEAD(ad7142_wait);
> +
> +static struct input_dev *ad7142_dev;
> +
> +#define AD7142_DRV_NAME		"ad7142_js"
> +#define AD7142_I2C_ID		0xE622
> +#define AD7142_I2C_ADDR		0x2C
> +/*
> + * Ram map - these registers are defined as we go along
> + */
> +/* RW   Power & conversion control */
> +#define PWRCONVCTL		0x00
> +
> +/* RW   Ambient compensation control register 0 - 3 */
> +#define AMBCOMPCTL_REG0		0x01
> +#define AMBCOMPCTL_REG1		0x02
> +#define AMBCOMPCTL_REG2		0x03
> +#define AMBCOMPCTL_REG3		0x04
> +
> +/* RW   Interrupt enable register 0 - 2 */
> +#define INTEN_REG0		0x05
> +#define INTEN_REG1		0x06
> +#define INTEN_REG2		0x07
> +
> +/* R    Low limit interrupt status register 0 */
> +#define INTSTAT_REG0		0x08
> +/* R    High limit interrupt status register 1 */
> +#define INTSTAT_REG1		0x09
> +/* R    Interrupt status register 2 */
> +#define INTSTAT_REG2		0x0A
> +
> +/* R    ADC stage 0 - 11 result (uncompensated) actually located in SRAM=
 */
> +#define ADCRESULT_S0		0x0B
> +#define ADCRESULT_S1		0x0C
> +#define ADCRESULT_S2		0x0D
> +#define ADCRESULT_S3		0x0E
> +#define ADCRESULT_S4		0x0F
> +#define ADCRESULT_S5		0x10
> +#define ADCRESULT_S6		0x11
> +#define ADCRESULT_S7		0x12
> +#define ADCRESULT_S8		0x13
> +#define ADCRESULT_S9		0x14
> +#define ADCRESULT_S10		0x15
> +#define ADCRESULT_S11		0x16
> +
> +/* R    I.D. Register */
> +#define DEVID			0x17
> +
> +/* R    Current threshold status register 0, 1 */
> +#define THRES_STAT_REG0		0x40
> +#define THRES_STAT_REG1		0x41
> +/* R    Current proximity status register 2 */
> +#define PROX_STAT_REG		0x42
> +
> +#define STAGE0_CONNECTION	0x80
> +#define STAGE1_CONNECTION	0x88
> +#define STAGE2_CONNECTION	0x90
> +#define STAGE3_CONNECTION	0x98
> +#define STAGE4_CONNECTION	0xA0
> +#define STAGE5_CONNECTION	0xA8
> +#define STAGE6_CONNECTION	0xB0
> +#define STAGE7_CONNECTION	0xB8
> +#define STAGE8_CONNECTION	0xC0
> +#define STAGE9_CONNECTION	0xC8
> +#define STAGE10_CONNECTION	0xD0
> +#define STAGE11_CONNECTION	0xD8
> +
> +/*
> + *	STAGE0: Button1   <----> CIN6(+)	Button2    <----> CIN5(-)
> + *	STAGE1: Button3   <----> CIN4(-)	Button4    <----> CIN3(+)
> + *	STAGE2: Axes.Left <----> CIN11(-)	Axes.Right <----> CIN13(+)
> + *	STAGE3: Axes.Up   <----> CIN12(-)	Axes.Down  <----> CIN10(+)
> + */
> +static unsigned short stage[5][8] =3D {
> +	{0xE7FF, 0x3FFF, 0x0005, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
> +	{0xFDBF, 0x3FFF, 0x0001, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
> +	{0xFFFF, 0x2DFF, 0x0001, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
> +	{0xFFFF, 0x37BF, 0x0001, 0x2626, 0x01F4, 0x01F4, 0x028A, 0x028A},
> +	{0xFFFF, 0x3FFF, 0x0000, 0x0606, 0x01F4, 0x01F4, 0x0320, 0x0320},
> +};
> +
> +static struct i2c_driver ad7142_driver;
> +static struct i2c_client *ad7142_client;
> +
> +static unsigned short ignore[] =3D { I2C_CLIENT_END };
> +static unsigned short normal_addr[] =3D { AD7142_I2C_ADDR, I2C_CLIENT_EN=
D };
> +
> +static int intr_flag;
> +
> +static struct i2c_client_address_data addr_data =3D {
> +	.normal_i2c =3D normal_addr,
> +	.probe =3D ignore,
> +	.ignore =3D ignore,
> +};
> +
> +static irqreturn_t ad7142_interrupt(int irq, void *dummy)
> +{
> +	disable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +	intr_flag =3D 1;
> +	wake_up_interruptible(&ad7142_wait);
> +	return IRQ_HANDLED;
> +}
> +
> +static int
> +ad7142_probe(struct i2c_adapter *adap, int addr, int kind)
> +{
> +	struct i2c_client *client;
> +	int rc;
> +
> +	client =3D kmalloc(sizeof(struct i2c_client), GFP_KERNEL);
> +	if (!client)
> +		return -ENOMEM;
> +	memset(client, 0, sizeof(struct i2c_client));
> +	strncpy(client->name, AD7142_DRV_NAME, I2C_NAME_SIZE);
> +	client->addr =3D addr;
> +	client->adapter =3D adap;
> +	client->driver =3D &ad7142_driver;
> +
> +	rc =3D i2c_attach_client(client);
> +	if (rc) {
> +		printk(KERN_ERR "i2c_attach_client fail: %d\n", rc);
> +		goto fail_attach;
> +	}
> +
> +	/*
> +	 * The ADV7142 has an autoincrement function,
> +	 * use it if the adapter understands raw I2C
> +	 */
> +	rc =3D i2c_check_functionality(client->adapter, I2C_FUNC_I2C);
> +	if (!rc) {
> +		printk(KERN_ERR
> +			"AD7142: i2c bus doesn't support raw I2C operation\n");
> +		rc =3D -EINVAL;
> +		goto fail_check;
> +	}
> +
> +	rc =3D request_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt,
> +			IRQF_TRIGGER_LOW, "ad7142_joy", ad7142_interrupt);
> +	if (rc) {
> +		printk(KERN_ERR "AD7142: Can't allocate irq %d\n",
> +			CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +		rc =3D -EBUSY;

This assignment is bogus, you can simply use value returned by request_irq()

> +		goto fail_check;
> +	}
> +
> +	ad7142_client =3D client;
> +	printk(KERN_INFO "%s_attach: at 0x%02x\n",
> +			client->name, client->addr << 1);
> +	return 0;
> +
> +fail_check:
> +	i2c_detach_client(client);
> +fail_attach:
> +	kfree(client);
> +	return rc;
> +}
> +
> +static int ad7142_i2c_write(struct i2c_client *client, unsigned short of=
fset,
> +		unsigned short *data, unsigned int len)
> +{
> +	int ret =3D -1;
> +	int i;
> +	u8 block_data[34];
> +
> +	if (len < 1 || len > 16) {
> +		printk(KERN_ERR "AD7142: Write data length error\n");
> +		return ret;
> +	}
> +
> +	/* Do raw I2C, not smbus compatible */
> +	block_data[0] =3D (offset & 0xFF00) >> 8;
> +	block_data[1] =3D (offset & 0x00FF);
> +
> +	for (i =3D 0; i < len; i++) {
> +		block_data[2 * i + 2] =3D (*data & 0xFF00) >> 8;
> +		block_data[2 * i + 3] =3D *data++ & 0x00FF;
> +	}
> +
> +	ret =3D i2c_master_send(client, block_data, (len * 2 + 2));
> +	if (ret < 0) {
> +		printk(KERN_ERR "AD7142: I2C write error\n");
> +		return ret;
> +	}
> +
> +	return ret;
> +}
> +
> +static int ad7142_i2c_read(struct i2c_client *client, unsigned short off=
set,
> +		unsigned short *data, unsigned int len)
> +{
> +	int ret =3D -1;
> +	int i;
> +	u8 block_data[32];
> +
> +	if (len < 1 && len > 16) {
> +		printk(KERN_ERR "AD7142: read data length error\n");
> +		return ret;
> +	}
> +
> +	/* Do raw I2C, not smbus compatible */
> +	block_data[0] =3D (offset & 0xFF00) >> 8;
> +	block_data[1] =3D (offset & 0x00FF);
> +
> +	ret =3D i2c_master_send(client, block_data, 2);
> +	if (ret < 0) {
> +		printk(KERN_ERR "AD7142: I2C read error\n");
> +		return ret;
> +	}
> +
> +	ret =3D i2c_master_recv(client, block_data, len * 2);
> +	if (ret < 0) {
> +		printk(KERN_ERR "AD7142: I2C transfer error\n");
> +		return ret;
> +	}
> +
> +	for (i =3D 0; i < len; i++) {
> +		unsigned short temp;
> +		temp =3D block_data[2 * i];
> +		temp =3D (temp << 8) & 0xFF00;
> +		*data++ =3D temp | block_data[2 * i + 1];
> +	}
> +
> +	return ret;
> +}
> +
> +static int
> +ad7142_attach(struct i2c_adapter *adap)
> +{
> +	return i2c_probe(adap, &addr_data, &ad7142_probe);
> +}
> +
> +static int
> +ad7142_detach_client(struct i2c_client *client)
> +{
> +	int rc;
> +
> +	rc =3D i2c_detach_client(client);
> +	if (!rc)
> +		kfree(i2c_get_clientdata(client));
> +	return rc;
> +}
> +
> +static struct i2c_driver ad7142_driver =3D {
> +	.driver =3D {
> +		.name =3D AD7142_DRV_NAME,
> +	},
> +	.id =3D AD7142_I2C_ID,
> +	.attach_adapter =3D ad7142_attach,
> +	.detach_client =3D ad7142_detach_client,
> +};
> +
> +unsigned short old_status_low, old_status_high;

Are these variables used outside of your driver ?

> +
> +static void ad7142_decode(void)
> +{
> +	unsigned short irqno_low, irqno_high;
> +	unsigned short temp;
> +
> +	ad7142_i2c_read(ad7142_client, INTSTAT_REG0, &irqno_low, 1);
> +	temp =3D irqno_low ^ old_status_low;
> +	switch (temp) {
> +	case 0x0001:
> +		input_report_key(ad7142_dev, BTN_BASE, (irqno_low & 0x0001));
> +		break;
> +	case 0x0002:
> +		input_report_key(ad7142_dev, BTN_BASE4,
> +					((irqno_low & 0x0002) >> 1));
> +		break;
> +	case 0x0004:
> +		input_report_key(ad7142_dev, KEY_UP,
> +					((irqno_low & 0x0004) >> 2));
> +		break;
> +	case 0x0008:
> +		input_report_key(ad7142_dev, KEY_RIGHT,
> +					((irqno_low & 0x0008) >> 3));
> +		break;
> +	}
> +	old_status_low =3D irqno_low;
> +
> +	ad7142_i2c_read(ad7142_client, INTSTAT_REG1, &irqno_high, 1);
> +	temp =3D irqno_high ^ old_status_high;
> +	switch (temp) {
> +	case 0x0001:
> +		input_report_key(ad7142_dev, BTN_BASE2, irqno_high & 0x0001);
> +		break;
> +	case 0x0002:
> +		input_report_key(ad7142_dev, BTN_BASE3,
> +					((irqno_high & 0x0002) >> 1));
> +		break;
> +	case 0x0004:
> +		input_report_key(ad7142_dev, KEY_DOWN,
> +					((irqno_high & 0x0004) >> 2));
> +		break;
> +	case 0x0008:
> +		input_report_key(ad7142_dev, KEY_LEFT,
> +					((irqno_high & 0x0008) >> 3));
> +		break;
> +	}
> +	old_status_high =3D irqno_high;
> +
> +	input_sync(ad7142_dev);
> +}
> +
> +static int ad7142_thread(void *nothing)
> +{
> +	do {
> +		wait_event_interruptible(ad7142_wait,
> +			kthread_should_stop() || (intr_flag !=3D 0));
> +		ad7142_decode();
> +		intr_flag =3D 0;
> +		enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> +	} while (!kthread_should_stop());
> +
> +	pr_debug("ad7142: kthread exiting\n");
> +
> +	return 0;
> +}
> +
> +static int ad7142_open(struct input_dev *dev)
> +{
> +	unsigned short id, value;
> +
> +	ad7142_i2c_read(ad7142_client, DEVID, &id, 1);
> +	if (id !=3D AD7142_I2C_ID) {
> +		printk(KERN_ERR "Open AD7142 error\n");
> +		return -ENODEV;
> +	}
> +
> +	ad7142_i2c_write(ad7142_client, STAGE0_CONNECTION, stage[0], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE1_CONNECTION, stage[1], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE2_CONNECTION, stage[2], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE3_CONNECTION, stage[3], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE4_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE5_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE6_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE7_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE8_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE9_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE10_CONNECTION, stage[4], 8);
> +	ad7142_i2c_write(ad7142_client, STAGE11_CONNECTION, stage[4], 8);
> +
> +	value =3D 0x00B0;
> +	ad7142_i2c_write(ad7142_client, PWRCONVCTL, &value, 1);
> +
> +	value =3D 0x0690;
> +	ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG1, &value, 1);
> +
> +	value =3D 0x0664;
> +	ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG2, &value, 1);
> +
> +	value =3D 0x290F;
> +	ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG3, &value, 1);
> +
> +	value =3D 0x000F;
> +	ad7142_i2c_write(ad7142_client, INTEN_REG0, &value, 1);
> +	ad7142_i2c_write(ad7142_client, INTEN_REG1, &value, 1);
> +
> +	value =3D 0x0000;
> +	ad7142_i2c_write(ad7142_client, INTEN_REG2, &value, 1);
> +
> +	ad7142_i2c_read(ad7142_client, AMBCOMPCTL_REG1, &value, 1);
> +
> +	value =3D 0x000F;
> +	ad7142_i2c_write(ad7142_client, AMBCOMPCTL_REG0, &value, 1);
> +
> +	ad7142_task =3D kthread_run(ad7142_thread, NULL, "ad7142_task");
> +	if (IS_ERR(ad7142_task)) {
> +		printk(KERN_ERR "serio: Failed to start kseriod\n");
> +		return PTR_ERR(ad7142_task);
> +	}
> +	return 0;
> +}
> +
> +static void ad7142_close(struct input_dev *dev)
> +{
> +	free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> +	kthread_stop(ad7142_task);
> +}
> +
> +static int __init ad7142_init(void)
> +{
> +	int ret;
> +
> +	ad7142_dev =3D input_allocate_device();
> +	if (!ad7142_dev)
> +		return -ENOMEM;
> +
> +	ad7142_dev->open =3D ad7142_open;
> +	ad7142_dev->close =3D ad7142_close;
> +	ad7142_dev->evbit[0] =3D BIT(EV_KEY);
> +	ad7142_dev->keybit[LONG(BTN_BASE)] =3D BIT(BTN_BASE) | BIT(BTN_BASE2) |
> +						BIT(BTN_BASE3) | BIT(BTN_BASE4);
> +	ad7142_dev->keybit[LONG(KEY_UP)] |=3D BIT(KEY_UP) | BIT(KEY_DOWN) |
> +						BIT(KEY_LEFT) | BIT(KEY_RIGHT);
> +
> +	ad7142_dev->name =3D "ad7142 joystick";
> +	ad7142_dev->phys =3D "ad7142/input0";
> +	ad7142_dev->id.bustype =3D BUS_I2C;
> +	ad7142_dev->id.vendor =3D 0x0001;
> +	ad7142_dev->id.product =3D 0x0001;
> +	ad7142_dev->id.version =3D 0x0100;
> +
> +	ret =3D input_register_device(ad7142_dev);
> +	if (ret) {
> +		printk(KERN_ERR "Failed to register AD7142 input device!\n");
> +		goto fail_register;
> +	}
> +
> +	ret =3D i2c_add_driver(&ad7142_driver);
> +	if (ret) {
> +		printk(KERN_ERR "Failed to add AD7142 I2C driver!\n");
> +		goto fail_add;
> +	}
> +	return 0;
> +
> +fail_add:
> +	input_unregister_device(ad7142_dev);
> +fail_register:
> +	input_free_device(ad7142_dev);
> +	return ret;
> +}
> +
> +static void __exit ad7142_exit(void)
> +{
> +	i2c_del_driver(&ad7142_driver);
> +	input_unregister_device(ad7142_dev);
> +}
> +
> +module_init(ad7142_init);
> +module_exit(ad7142_exit);
> --=20
> 1.5.3.4
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHDyebIWZCBzwS8mkRAjlJAJ4sSjrpQFnFme//uBxZjqsaTMqnZgCcD+CK
moHwzG8GpK2KkrwZ5qLFcuY=
=KHej
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
