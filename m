Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbYIRC3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbYIRC3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 22:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYIRC2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 22:28:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752879AbYIRC2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 22:28:50 -0400
Date: Wed, 17 Sep 2008 19:28:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@openedhand.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Core support for the WM8400 AudioPlus HiFi
 CODEC and PMU
Message-Id: <20080917192836.ef3545d2.akpm@linux-foundation.org>
In-Reply-To: <1221558194-15505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20080916094201.GA15271@rakim.wolfsonmicro.main>
	<1221558194-15505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 10:43:13 +0100 Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> The WM8400 is a highly integrated audio CODEC and power management unit
> optimised for use in mobile multimedia applications.  This patch adds
> core support for the WM8400 to the MFD subsystem.
> 
> Both I2C and SPI access are supported by the hardware but currently only
> I2C access is implemented.  The code is structured to allow SPI support
> to be slotted in later.
> 

Various ankle-biting comments, just to show I read it:

>
> ...
>
> +#include <linux/bug.h>
> +#include <linux/i2c.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/wm8400-private.h>
> +#include <linux/mfd/wm8400-audio.h>
> +
> +static struct
> +{

hm, checkpatch chews a couple minutes CPU time then misses this error.

static struct {

please.

> +	u16  readable;    /* Mask of readable bits */
> +	u16  writable;    /* Mask of writable bits */
> +	u16  vol;         /* Mask of volatile bits */
> +	int  is_codec;    /* Register controlled by codec reset */
> +	u16  default_val; /* Value on reset */
> +} reg_data[] =
> +{

} reg_data[] = {

would be conventional, too.

> +	{ 0xFFFF, 0xFFFF, 0x0000, 0, 0x6172 }, /* R0 */
> +	{ 0x7000, 0x0000, 0x8000, 0, 0x0000 }, /* R1 */
> +	{ 0xFF17, 0xFF17, 0x0000, 0, 0x0000 }, /* R2 */
> +	{ 0xEBF3, 0xEBF3, 0x0000, 1, 0x6000 }, /* R3 */
> +	{ 0x3CF3, 0x3CF3, 0x0000, 1, 0x0000 }, /* R4  */
>
> ...
>
> +/**
> + * wm8400_reg_read - Single register read
> + *
> + * @wm8400: Pointer to wm8400 control structure
> + * @reg:    Register to read
> + *
> + * @return  Read value
> + */
> +u16 wm8400_reg_read(struct wm8400 *wm8400, u8 reg)
> +{
> +	u16 val;
> +
> +	mutex_lock(&wm8400->io_lock);
> +
> +	wm8400_read(wm8400, reg, 1, &val);
> +
> +	mutex_unlock(&wm8400->io_lock);
> +
> +	return val;
> +}
> +EXPORT_SYMBOL_GPL(wm8400_reg_read);

Is it just me, or do all the useless newlines there look silly?  sigh.

> +int wm8400_block_read(struct wm8400 *wm8400, u8 reg, int count, u16 *data)
> +{
> +	int ret;
> +
> +	mutex_lock(&wm8400->io_lock);
> +
> +	ret = wm8400_read(wm8400, reg, count, data);
> +
> +	mutex_unlock(&wm8400->io_lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(wm8400_block_read);
> +
>
> ...
>
> +static void wm8400_release(struct wm8400 *wm8400)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(wm8400->regulators); i++)
> +		if (wm8400->regulators[i].name)
> +			platform_device_unregister(&wm8400->regulators[i]);
> +}
> +
> +#if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)

Is CONFIG_I2C=n worth supporting?  Is anyone likely to test and
maintain that combination?

> +static int wm8400_i2c_read(void *io_data, char reg, int count, u16 *dest)
> +{
> +	struct i2c_client *i2c = io_data;
> +	struct i2c_msg xfer[2];
> +	int ret;
> +
> +	/* Write register */
> +	xfer[0].addr = i2c->addr;
> +	xfer[0].flags = 0;
> +	xfer[0].len = 1;
> +	xfer[0].buf = &reg;
> +
> +	/* Read data */
> +	xfer[1].addr = i2c->addr;
> +	xfer[1].flags = I2C_M_RD;
> +	xfer[1].len = count * sizeof(u16);
> +	xfer[1].buf = (u8 *)dest;
> +
> +	ret = i2c_transfer(i2c->adapter, xfer, 2);
> +	if (ret == 2)
> +		ret = 0;
> +	else if (ret >= 0)
> +		ret = -EIO;
> +
> +	return ret;
> +}
> +
> +static int wm8400_i2c_write(void *io_data, char reg, int count, const u16 *src)
> +{
> +	struct i2c_client *i2c = io_data;
> +	u8 *msg;
> +	int ret;
> +
> +	/* We add 1 byte for device register - ideally I2C would gather. */
> +	msg = kmalloc((count * sizeof(u16)) + 1, GFP_KERNEL);
> +	if (msg == NULL)
> +		return -ENOMEM;
> +
> +	msg[0] = reg;
> +	memcpy(&msg[1], src, count * sizeof(u16));
> +
> +	ret = i2c_master_send(i2c, msg, (count * sizeof(u16)) + 1);
> +
> +	if (ret == (count * 2) + 1)
> +		ret = 0;
> +	else if (ret >= 0)
> +		ret = -EIO;
> +
> +	kfree(msg);
> +
> +	return ret;
> +}

Always freaks me out to see read/write methods returning `int' instead
of `ssize_t'.  i2c weirdness, iirc.

>
> ...
>
> +struct wm8400 {
> +	struct device *dev;
> +
> +	int (*read_dev)(void *data, char reg, int count, u16 *dst);
> +	int (*write_dev)(void *data, char reg, int count, const u16 *src);
> +
> +	struct mutex io_lock;
> +	void *io_data;
> +
> +	u16 reg_cache[WM8400_REGISTER_COUNT];

Should this be __be16?

> +	struct platform_device regulators[6];
> +};
> +
>
> ...
>
> +#define WM8400_LINE_CMP_VTHD_MASK               0x000F  /* LINE_CMP_VTHD - [3:0] */
> +#define WM8400_LINE_CMP_VTHD_SHIFT                   0  /* LINE_CMP_VTHD - [3:0] */
> +#define WM8400_LINE_CMP_VTHD_WIDTH                   4  /* LINE_CMP_VTHD - [3:0] */
> +

This patch adds an amazing 1733 #defines, of which only a few
percent are used.  Oh well.

