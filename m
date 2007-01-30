Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbXA3CkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbXA3CkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 21:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752035AbXA3CkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 21:40:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38833 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbXA3CkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 21:40:21 -0500
Date: Mon, 29 Jan 2007 18:39:50 -0800
From: Andrew Morton <akpm@osdl.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] TSL2550 support (I2C device driver)
Message-Id: <20070129183950.00ef3a04.akpm@osdl.org>
In-Reply-To: <20070129235619.GA8882@enneenne.com>
References: <20070129235619.GA8882@enneenne.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 00:56:19 +0100
Rodolfo Giometti <giometti@enneenne.com> wrote:

> Hello,
> 
> attached a patch to add support for Taos TSL2550 ambient light sensors
> (http://www.taosinc.com/product_detail.asp?cateid=4&proid=18).
> 

Some minor things:

> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/mutex.h>
> +#include <linux/delay.h>
> +
> +/* Address to scan */
> +static unsigned short normal_i2c[] = { 0x39, I2C_CLIENT_END };
> +
> +/* Insmod parameters */
> +I2C_CLIENT_INSMOD_1(tsl2550);
> +
> +static int operating_mode = 0;

The `= 0' is unneeded and undesirable.

> ...
>
> +static int tsl2550_get_adc_value(struct i2c_client *client, int channel)
> +{
> +	u8 cmd = channel == 0 ? TSL2550_READ_ADC0 : TSL2550_READ_ADC1;
> +	int timeout, ret;
> +
> +	/* Read ADC channel waiting at most 400ms (see data sheet for further
> +         * info) */
> +	for (timeout = 400; timeout > 0; timeout--) {
> +		i2c_smbus_write_byte(client, cmd);
> +		mdelay(1);
> +		ret = i2c_smbus_read_byte(client);
> +		if (ret < 0)
> +			return ret;
> +		else if (ret & 0x0080)
> +			break;
> +	}
> +	if (timeout == 0)
> +		return -EIO;
> +	return ((u8) ret) & 0x7f;	/* remove the "valid" bit */
> +}

eek.  Is there no way to avoid the busy-wait?  We cannot sleep here?

> +/* --- LUX calculation ----------------------------------------------------- */
> +
> +#define	TSL2550_MAX_LUX		1846
> +
> +static u8 ratio_lut[] = {
> +	100, 100, 100, 100, 100, 100, 100, 100, 
> +	100, 100, 100, 100, 100, 100, 99, 99, 
> +	99, 99, 99, 99, 99, 99, 99, 99, 
> +	99, 99, 99, 98, 98, 98, 98, 98, 
> +	98, 98, 97, 97, 97, 97, 97, 96, 
> +	96, 96, 96, 95, 95, 95, 94, 94, 
> +	93, 93, 93, 92, 92, 91, 91, 90, 
> +	89, 89, 88, 87, 87, 86, 85, 84, 
> +	83, 82, 81, 80, 79, 78, 77, 75, 
> +	74, 73, 71, 69, 68, 66, 64, 62, 
> +	60, 58, 56, 54, 52, 49, 47, 44, 
> +	42, 41, 40, 40, 39, 39, 38, 38, 
> +	37, 37, 37, 36, 36, 36, 35, 35, 
> +	35, 35, 34, 34, 34, 34, 33, 33, 
> +	33, 33, 32, 32, 32, 32, 32, 31, 
> +	31, 31, 31, 31, 30, 30, 30, 30, 
> +	30, 
> +};
> +
> +static u16 count_lut[] = {
> +	0, 1, 2, 3, 4, 5, 6, 7, 
> +	8, 9, 10, 11, 12, 13, 14, 15, 
> +	16, 18, 20, 22, 24, 26, 28, 30, 
> +	32, 34, 36, 38, 40, 42, 44, 46, 
> +	49, 53, 57, 61, 65, 69, 73, 77, 
> +	81, 85, 89, 93, 97, 101, 105, 109, 
> +	115, 123, 131, 139, 147, 155, 163, 171, 
> +	179, 187, 195, 203, 211, 219, 227, 235, 
> +	247, 263, 279, 295, 311, 327, 343, 359, 
> +	375,  391, 407, 423, 439, 455, 471, 487, 
> +	511, 543, 575, 607, 639, 671, 703, 735, 
> +	767, 799, 831, 863, 895, 927, 959, 991, 
> +	1039, 1103, 1167, 1231, 1295, 1359, 1423, 1487, 
> +	1551, 1615, 1679, 1743, 1807, 1871, 1935, 1999, 
> +	2095, 2223, 2351, 2479, 2607, 2735, 2863, 2991, 
> +	3119, 3247, 3375, 3503, 3631, 3759, 3887, 4015
> +};

These tables could perhaps be const?

> +static ssize_t tsl2550_show_power_state(struct device *dev, struct device_attribute *attr, char *buf)

It's preferred to try to fit the code into an 80-col window.  (But some
people disagree with this specifically for function definitions such as
this).

> +static ssize_t tsl2550_store_power_state(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)

Ditto (and other places).

> +static int tsl2550_detach_client(struct i2c_client *client)
> +{
> +	int err;
> +
> +	sysfs_remove_group(&client->dev.kobj, &tsl2550_attr_group);
> +
> +	if ((err = i2c_detach_client(client)))
> +		return err;

Preferred coding style is

	err = i2c_detach_client(client);
	if (err)
		return err;

(multiple places)


