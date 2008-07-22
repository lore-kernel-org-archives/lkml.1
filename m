Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYGVJGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYGVJGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 05:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYGVJGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 05:06:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751666AbYGVJF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 05:05:59 -0400
Date: Tue, 22 Jul 2008 02:05:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Eric Miao <eric.y.miao@gmail.com>,
       Jean Delvare <khali@linux-fr.org>, Jack Ren <jack.ren@marvell.com>
Subject: Re: [patch 2.6.26-rc-mm] gpio: max732x driver
Message-Id: <20080722020542.d180162d.akpm@linux-foundation.org>
In-Reply-To: <200807131918.06377.david-b@pacbell.net>
References: <200807131918.06377.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008 19:18:06 -0700 David Brownell <david-b@pacbell.net> wrote:

> From: Eric Miao <eric.miao@marvell.com>
> 
> This adds a driver supporting a family of I2C port expanders from
> Maxim, which includes the MAX7319 and MAX7320-7327 chips.
> 
> Signed-off-by: Jack Ren <jack.ren@marvell.com>
> Signed-off-by: Eric Miao <eric.miao@marvell.com>
> Acked-by: Jean Delvare <khali@linux-fr.org>
> [ dbrownell@users.sourceforge.net: minor fixes ]
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
> We're growing quite the collection of dedicated GPIO expander drivers!
> And the multi-function chip support is growing too.  This applies after
> the patch adding support for max7301 chips.
> 
>
> ...
>
> +static int max732x_write(struct max732x_chip *chip, int group_a, uint8_t val)
> +{
> +	struct i2c_client *client;
> +	int ret;
> +
> +	client = group_a ? chip->client_group_a : chip->client_group_b;
> +	ret = i2c_smbus_write_byte(client, val);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed writing\n");
> +		return ret;
> +	}

This..

> +	return 0;
> +}
> +
> +static int max732x_read(struct max732x_chip *chip, int group_a, uint8_t *val)
> +{
> +	struct i2c_client *client;
> +	int ret;
> +
> +	client = group_a ? chip->client_group_a : chip->client_group_b;
> +	ret = i2c_smbus_read_byte(client);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed reading\n");
> +		return ret;
> +	}

and this demonstrate how weird it is that i2c_smbus_write_byte() and
i2c_smbus_read_byte() return an `s32' instead of plain old `int'.


> +	*val = (uint8_t)ret;
> +	return 0;
> +}
> +
> +static inline int is_group_a(struct max732x_chip *chip, unsigned off)
> +{
> +	return (1u << off) & chip->mask_group_a;

strange random unnecessary usage of "1u" in here

> +}
> +
>
> ...
>
> +static int max732x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
> +{
> +	struct max732x_chip *chip;
> +	unsigned int mask = 1u << off;
> +
> +	chip = container_of(gc, struct max732x_chip, gpio_chip);
> +
> +	if ((mask & chip->dir_input) == 0) {
> +		dev_dbg(&chip->client->dev, "%s port %d is output only\n",
> +			chip->client->name, off);
> +		return -EACCES;

I don't think that EACCES is a suitable error code here.  That's a
security/permissions sort of thing.  If userspace is requesting this
driver to do something which the hardware cannot do then probably
EINVAL is the appropriate return code.

> +	}
> +
> +	return 0;
> +}
> +
> +static int max732x_gpio_direction_output(struct gpio_chip *gc,
> +		unsigned off, int val)
> +{
> +	struct max732x_chip *chip;
> +	unsigned int mask = 1u << off;
> +
> +	chip = container_of(gc, struct max732x_chip, gpio_chip);
> +
> +	if ((mask & chip->dir_output) == 0) {
> +		dev_dbg(&chip->client->dev, "%s port %d is input only\n",
> +			chip->client->name, off);
> +		return -EACCES;

Ditto

> +	}
> +
> +	max732x_gpio_set_value(gc, off, val);
> +	return 0;
> +}
> +
>
> ...
>
> +static int __devinit max732x_probe(struct i2c_client *client,
> +				   const struct i2c_device_id *id)
> +{
> +	struct max732x_platform_data *pdata;
> +	struct max732x_chip *chip;
> +	struct i2c_client *c;
> +	uint16_t addr_a, addr_b;
> +	int ret, nr_port;
> +
> +	pdata = client->dev.platform_data;
> +	if (pdata == NULL)
> +		return -ENODEV;
> +
> +	chip = kzalloc(sizeof(struct max732x_chip), GFP_KERNEL);

<goes back and checks that `chip' is a `struct max732x_chip*'>

I do find

	p = kmalloc(sizeof(*p), ...)

to be more conforting to read.

> +	if (chip == NULL)
> +		return -ENOMEM;
> +	chip->client = client;
> +
> +	nr_port = max732x_setup_gpio(chip, id, pdata->gpio_base);
> +
> +	addr_a = (client->addr & 0x0f) | 0x60;
> +	addr_b = (client->addr & 0x0f) | 0x50;
> +
> +	switch (client->addr & 0x70) {
> +	case 0x60:
> +		chip->client_group_a = client;
> +		if (nr_port > 7) {
> +			c = i2c_new_dummy(client->adapter, addr_b);
> +			chip->client_group_b = chip->client_dummy = c;
> +		}
> +		break;
> +	case 0x50:
> +		chip->client_group_b = client;
> +		if (nr_port > 7) {
> +			c = i2c_new_dummy(client->adapter, addr_a);
> +			chip->client_group_a = chip->client_dummy = c;

Multiple assignments get nasty comments from Linus when he's feeling
perky.

> +		}
> +		break;
> +	default:
> +		dev_err(&client->dev, "invalid I2C address specified %02x\n",
> +				client->addr);
> +		ret = -EINVAL;
> +		goto out_failed;
> +	}
> +
> +	mutex_init(&chip->lock);
> +
> +	max732x_read(chip, is_group_a(chip, 0), &chip->reg_out[0]);
> +	if (nr_port > 7)
> +		max732x_read(chip, is_group_a(chip, 8), &chip->reg_out[1]);
> +
> +	ret = gpiochip_add(&chip->gpio_chip);
> +	if (ret)
> +		goto out_failed;
> +
> +	if (pdata->setup) {
> +		ret = pdata->setup(client, chip->gpio_chip.base,
> +				chip->gpio_chip.ngpio, pdata->context);
> +		if (ret < 0)
> +			dev_warn(&client->dev, "setup failed, %d\n", ret);
> +	}
> +
> +	i2c_set_clientdata(client, chip);
> +	return 0;
> +
> +out_failed:
> +	kfree(chip);
> +	return ret;
> +}
>
> ...
>

But that's all very minor stuff.  Nice-looking driver.

