Return-Path: <linux-kernel-owner+w=401wt.eu-S1755011AbYEOXeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbYEOXeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 19:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYEOXeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 19:34:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbYEOXeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 19:34:09 -0400
Date: Thu, 15 May 2008 16:33:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nate Case <ncase@xes-inc.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add support for Philips PCA955x I2C LED drivers
Message-Id: <20080515163331.0677f4b1.akpm@linux-foundation.org>
In-Reply-To: <1210808866.13845.428.camel@localhost.localdomain>
References: <1210808866.13845.428.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2008 18:47:46 -0500
Nate Case <ncase@xes-inc.com> wrote:

> This driver supports the PCA9550, PCA9551, PCA9552, and PCA9553
> LED driver chips.
>
> ...
>
> +/* Set only the two bits in the LED selector register of the specified LED */
> +#define LED_SET(reg, led, state) \
> +	((reg & (~(0x3 << (led << 1)))) | ((state & 0x0F) << (led << 1)))

Please prefer to implement code in C rather than as a macro.  Only use
macros when the code *must* be a macro.

For many reasons, one of which is: the above expression references
`led' twice and will misbehave if passed an expression which has
side-effects.

static inline void led_set(suitabletype reg, suitabletype led,
				suitabletype state)

would suit.

(ditto NUM_INPUT_REGS, etc.  Writing it in C will generate equivalent
code but we get a nicely lower-cased C function)

> +enum pca955x_type {
> +	pca9550,
> +	pca9551,
> +	pca9552,
> +	pca9553,
> +};
> +
> +struct pca955x_chipdef {
> +	int			bits;
> +	u8			slv_addr;	/* 7-bit slave address mask */
> +	int			slv_addr_shift;	/* Number of bits to ignore */
> +};
> +
> +static struct pca955x_chipdef pca955x_chipdefs[] = {
> +[pca9550] = {
> +	.bits		= 2,
> +	.slv_addr	= /* 110000x */ 0x60,
> +	.slv_addr_shift	= 1,
> +},
> +[pca9551] = {
> +	.bits		= 8,
> +	.slv_addr	= /* 1100xxx */ 0x60,
> +	.slv_addr_shift	= 3,
> +},
> +[pca9552] = {
> +	.bits		= 16,
> +	.slv_addr	= /* 1100xxx */ 0x60,
> +	.slv_addr_shift	= 3,
> +},
> +[pca9553] = {
> +	.bits		= 4,
> +	.slv_addr	= /* 110001x */ 0x62,
> +	.slv_addr_shift	= 1,
> +},
> +};

the innards of the above should be tabbed one stop to the right.

> +static const struct i2c_device_id pca955x_id[] = {
> +	{ "pca9550", pca9550 },
> +	{ "pca9551", pca9551 },
> +	{ "pca9552", pca9552 },
> +	{ "pca9553", pca9553 },
> +};

oops, we forgot the terminating { } entry.  It will crash...

> +MODULE_DEVICE_TABLE(i2c, pca955x_id);
>
> +struct pca955x_led {
> +	struct pca955x_chipdef	*chipdef;
> +	struct i2c_client	*client;
> +	struct work_struct	work;
> +	spinlock_t		lock;
> +	enum led_brightness	brightness;
> +	struct led_classdev	led_cdev;
> +	int			led_num;	/* 0 .. 15 potentially */
> +	char			name[32];
> +};
> +
> +/*
> + * Write to frequency prescaler register, used to program the
> + * period of the PWM output.  period = (PSCx + 1) / 38
> + */
> +static void pca955x_write_psc(struct i2c_client *client, int n, u8 val)
> +{
> +	struct pca955x_led	*pca955x = i2c_get_clientdata(client);

nanonit: most kernel code uses a single space between the type and the
identifier.

> +
> +	i2c_smbus_write_byte_data(client,
> +		NUM_INPUT_REGS(pca955x->chipdef->bits) + 2*n,
> +		val);
> +}
>
> ...
>
> +void pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness value)
> +{
> +	struct pca955x_led *pca955x =
> +			container_of(led_cdev, struct pca955x_led, led_cdev);

You're allowed to do

	struct pca955x_led *pca955x;

	pca955x = container_of(led_cdev, struct pca955x_led, led_cdev);

;)

> +	spin_lock(&(pca955x->lock));

unneeded parens

> +	pca955x->brightness = value;
> +
> +	/*
> +	 * Must use workqueue for the actual I/O since I2C operations
> +	 * can sleep.
> +	 */
> +	schedule_work(&(pca955x->work));
> +
> +	spin_unlock(&(pca955x->lock));

dittoes.

> +}
> +
> +static int __devinit pca955x_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	struct pca955x_led		*pca955x;
> +	int				i;
> +	int				err = -ENODEV;
> +	struct pca955x_chipdef		*chip =
> +				&pca955x_chipdefs[id->driver_data];
> +	struct i2c_adapter		*adapter =
> +				to_i2c_adapter(client->dev.parent);
> +	struct led_platform_data	*pdata = client->dev.platform_data;
> +
> +	DBG("probe() enter: chip 0x%02x, with type='%s'\n", client->addr,
> +			id->name);
> +
> +	/* Make sure the slave address / chip type combo given is possible */
> +	if (((client->addr >> chip->slv_addr_shift) << chip->slv_addr_shift)
> +		!= chip->slv_addr) {

equivalent to the simpler

	if (client->addr & ((1 << chip->slv_addr_shift) - 1)) {

I think?

> +		dev_err(&client->dev, "invalid slave address %02x\n",
> +				client->addr);
> +		return -ENODEV;
> +	}
> +
> +	printk(KERN_INFO "leds-pca955x: Using %s %d-bit LED driver at "
> +			"slave address 0x%02x\n",
> +			id->name, chip->bits, client->addr);
> +
> +	DBG("probe() checking i2c functionality\n");
> +	if (!i2c_check_functionality(adapter, I2C_FUNC_I2C))
> +		return -EIO;
> +
> +	if (pdata) {
> +		if (pdata->num_leds != chip->bits) {
> +			dev_err(&client->dev, "board info claims %d LEDs"
> +					" on a %d-bit chip\n",
> +					pdata->num_leds, chip->bits);
> +			return -ENODEV;
> +		}
> +	}
> +
> +	for (i = 0; i < chip->bits; i++) {
> +		pca955x = kzalloc(sizeof(struct pca955x_led), GFP_KERNEL);
> +		if (!pca955x) {
> +			err = -ENOMEM;
> +			goto exit;
> +		}
> +
> +		pca955x->chipdef = chip;
> +		pca955x->client = client;
> +		pca955x->led_num = i;
> +		/* Platform data can specify LED names and default triggers */
> +		if (pdata) {
> +			if (pdata->leds[i].name)
> +				snprintf(pca955x->name, 32, "pca955x:%s",
> +							pdata->leds[i].name);
> +			if (pdata->leds[i].default_trigger)
> +				pca955x->led_cdev.default_trigger =
> +					pdata->leds[i].default_trigger;
> +		} else {
> +			snprintf(pca955x->name, 32, "pca955x:%d", i);
> +		}
> +		spin_lock_init(&pca955x->lock);
> +
> +		pca955x->led_cdev.name = pca955x->name;
> +		pca955x->led_cdev.brightness_set =
> +				pca955x_led_set;
> +
> +		/*
> +		 * Client data is a pointer to the _first_ pca955x_led
> +		 * struct
> +		 */
> +		if (i == 0)
> +			i2c_set_clientdata(client, pca955x);
> +
> +		INIT_WORK(&(pca955x->work), pca955x_led_work);
> +
> +		led_classdev_register(&client->dev, &(pca955x->led_cdev));
> +	}
> +
> +	/* Turn off LEDs */
> +	for (i = 0; i < NUM_LED_REGS(chip->bits); i++)
> +		pca955x_write_ls(client, i, 0x55);
> +
> +	/* PWM0 is used for half brightness or 50% duty cycle */
> +	pca955x_write_pwm(client, 0, 255-LED_HALF);
> +
> +	/* PWM1 is used for variable brightness, default to OFF */
> +	pca955x_write_pwm(client, 1, 0);
> +
> +	/* Set to fast frequency so we do not see flashing */
> +	pca955x_write_psc(client, 0, 0);
> +	pca955x_write_psc(client, 1, 0);
> +
> +	DBG("probe() returning\n");
> +
> +	return 0;
> +exit:
> +	return err;
> +}
> +


It's a neat-looking driver.
