Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZHUK4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZHUK4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZHUK4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:56:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33605 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbZHUK4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:56:40 -0400
Date: Fri, 21 Aug 2009 11:56:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       Samuel Ortiz <sameo@linux.intel.com>,
       Russell King <linux@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] AB3100 regulator support v1
Message-ID: <20090821105636.GA2850@sirena.org.uk>
References: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250806271-24419-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: No Canadian coins.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 12:11:11AM +0200, Linus Walleij wrote:

> This is pending some changes that are queued in Samuels
> for-next tree (accessor names) and Russells next tree (I2C
> board init file), so it will have to come in some time
> later in the 2.6.32-rc cycle so mainly reviewing for now
> I guess.

Might be better to split this into multiple patches - at least
separating out the arch/arm stuff from the MFD/regulator stuff.

> +/*
> + * Needed to connect the regulator to this device
> + */
> +extern struct amba_device mmcsd_device;

This isn't needed any more.

> +#include <linux/mfd/ab3100.h>
> +#include <linux/regulator/driver.h>

What is this needed for?

> +	sigfillset(&all);
> +	if (!sigprocmask(SIG_BLOCK, &all, &old)) {
> +		/* Disable LDO D to shut down the system */
> +		if (local_ldo_d)
> +			(void) local_ldo_d->desc->ops->disable(local_ldo_d);

Hrm.  You should be able to do this without peering through the API like
this.  We need a shutdown state to match our suspend states.

> +static struct regulator_consumer_supply supply_LDO_G[] = {
> +	{
> +		.dev = &mmcsd_device.dev,
> +		.supply = "VCARD",
> +	},
> +};

With current regulator API (in -next) you can (and should) use dev_name
rather than dev here, avoiding the need to export the AMBA device.

> +static struct regulator_consumer_supply supply_LDO_H[] = {
> +	{
> +		.dev = NULL,
> +		.supply = "VDISP",
> +	},
> +};

This looks wrong - why are you not able to provide a struct device for
the consumer here?  For the purpose of labelling the supply on the board
I'd expect...

> +static const struct ab3100_platform_data ab3100_plf_data = {
> +	.reg_constraints = {
> +		{
> +			.constraints = {
> +				.name = "LDO_A",

...that the name for the rail on the board would be set here.  Having
the name be the name of the supply on the regulator would be unusual
since the default name is that provided by the regualtor driver.

> +			.constraints = {
> +				.name = "LDO_E",
> +				.min_uV = 0,
> +				.max_uV = 1800000,
> +				.valid_modes_mask = REGULATOR_MODE_NORMAL,
> +				.valid_ops_mask =
> +				REGULATOR_CHANGE_VOLTAGE |
> +				REGULATOR_CHANGE_STATUS,
> +				/* Used for powering DB chip */
> +				.always_on = 1,

REGULATOR_CHANGE_STATUS and always_on is a surprising combination...

> +		{
> +			.constraints = {
> +				.name = "LDO_BUCK",

This name seems wrong - LDOs and bucks are different types of regulator.

> +config REGULATOR_AB3100
> +	tristate "ST-Ericsson AB3100 Regulator functions"
> +	depends on AB3100_CORE
> +	default y if AB3100_CORE
> +	help
> +	 These regulators correspond to functionality in the
> +	 AB3100 analog baseband dealing with power regulators
> +	 for the system.
> +

Hrm, if we're going to the default y thing for the MFD chips we should
probably do it consistently for all of them.  I think I'll send a patch
for that.

> +/* LDO_A 0x16: 2.75V, ON, SLEEP_A, SLEEP OFF GND */
> +#define LDO_A_SETTING		0x16

All these defines seem rather odd - some explanation as to why you're
defining particular settings for them would help.  It looks like this is
either the hardware default or something specific to a particular system
which ought to be in platform data?

> +/*
> + * General functions for enable, disable and is_enabled used for
> + * LDO: A,C,E,F,G,H,K,EXT and BUCK
> + */
> +static int ab3100_enable_regulator_LDO(struct regulator_dev *reg)
> +{
> +	struct ab3100 *ab3100 = reg->reg_data;
> +	int err;
> +	u8 regid, regval;
> +
> +	if (ab3100_get_regid(reg, &regid))
> +		return -EINVAL;

For clarity I'd suggest renaming get_regid() to something like
get_register() - rdev_get_id() provides an ID get but really what this
is doing is getting you the control register for the LDO rather than the
ID.

> +	/* The regulator is already on, no reason to go further */
> +	if (regval | AB3100_LDO_ON_MASK)
> +		return 0;

This should be an &.

> +static const struct ldo_setting
> +ldo_init_settings[] = {
> +	{
> +		.abreg = AB3100_LDO_A,
> +		.setting = LDO_A_SETTING

This should all be being done via constraints, the bootloader or
hardware defaults.  The configuration is going to be system-specific.

> +static int ab3100_disable_regulator_LDO_D(struct regulator_dev *reg)
> +{
> +	struct ab3100 *ab3100 = reg->reg_data;
> +	int i;
> +
> +	/*
> +	 * Set regulators to default values, ignore any errors,
> +	 * we're going DOWN
> +	 */
> +	for (i = 0; i < ARRAY_SIZE(ldo_init_settings); i++)
> +		(void) ab3100_set_register_interruptible(ab3100,
> +					  ldo_init_settings[i].abreg,
> +					  ldo_init_settings[i].setting);

This definately looks board specific...  If software needs to do this it
should be done via the regulator framework.

> +
> +	switch (regid) {
> +	case(AB3100_LDO_A):
> +		return LDO_A_VOLTAGE;

Odd coding style here with the ().

> +		printk(KERN_ERR "AB3100: get voltage for " \
> +		       "unknown regulator 0x%x\n", regid);

dev_err() and please don't split the message over multiple lines, it
makes it harder to grep for error messages (the split messages appear
elsewhere in the driver).

> +static int ab3100_get_voltage_regulator_LDO_E_BUCK(struct regulator_dev *reg)
> +{

...

> +	switch (regval >> 5) {
> +	case 0:
> +		return 1800000;

If you implement list_voltage() (which I would recommend) you should be
able to write this in terms of list_voltage().

> +static int ab3100_set_voltage_regulator_LDO_E_BUCK(struct regulator_dev *reg,
> +						   int min_uV, int max_uV)
> +{

> +	if (min_uV < 900000)
> +		v = 7;

...

> +	else
> +		v = 0;

You should really check for out of range values here, and also verify
that max_uV is satisifed - eg, if you have a voltage step from 1.1V to
1.2V and the consumer asks for exactly 1.15V you won't be able to
deliver that.

> +	err = ab3100_set_register_interruptible(ab3100,
> +						AB3100_LDO_E, regval);

I notice that you're using _interruptible() versions of everything - is
there any great reason for that?  It'd mean that some random user
process getting a signal could cause operations to fail which doesn't
seem desirable.

> +/*
> + * LDO EXT is an external regulator so it is really
> + * not possible to get or set any voltage here, AB3100
> + * acts as a mere on/off switch for this regulator.
> + */
> +static struct regulator_ops regulator_ops_LDO_EXT = {
> +	.enable      = ab3100_enable_regulator_LDO,
> +	.disable     = ab3100_disable_regulator_LDO,
> +	.is_enabled  = ab3100_is_enabled_regulator_LDO,
> +	.get_voltage = ab3100_get_voltage_regulator_LDO_EXT,
> +};

Just don't implement the voltage operations here - they're optional.

> +	/*
> +	 * At last set up the board routings, constraints etc
> +	 * for the regulator.
> +	 */
> +	if (reg->plfdata->regulator_init)
> +		err = reg->plfdata->regulator_init(rdev);

This should be being called by the core.

> +static struct platform_driver ab3100_regulator_driver = {
> +	.driver = {
> +		.name  = "ab3100-regulator",
> +		.owner = THIS_MODULE,
> +	},
> +	.remove = __exit_p(ab3100_regulator_remove),
> +};

MODULE_ALIAS().

> +/*
> + * This creates a platform device for a regulator and
> + * registers it to the platform devices.
> + */
> +static int __init ab3100_add_regulator_pdev(struct device *parent,
> +				    struct ab3100_regulator *rdev,
> +				    struct ab3100 *ab3100,
> +				    struct ab3100_platform_data *plfdata,
> +				    int regid)

> +	/* This would seem logical but makes everything break... */
> +	/* pdev->dev.parent = parent; */

Err...  it does?  In what way?

> +	/* Set up regulators */
> +	for (i = 0; i < ARRAY_SIZE(ldo_init_settings); i++) {
> +		err = ab3100_set_register_interruptible(ab3100,
> +					  ldo_init_settings[i].abreg,
> +					  ldo_init_settings[i].setting);

Again, this is all board-specific and should be done via constraints.

> +	/*
> +	 * This makes the core shut down all unused regulators
> +	 * after all the initcalls have completed.
> +	 */
> +	regulator_has_full_constraints();

This too.

> +/*
> + * This needs to be an fs_initcall() because the
> + * AB3100 core driver that registers the regulators
> + * device comes in at subsys_initcall() later than
> + * this driver due to link order.
> + */
> +fs_initcall(ab3100_regulators_init);

That's only happening because you're using platform_driver_probe() - if
you use platform_driver_register() like the other regulator drivers
this won't be a problem.  I suspect that platform_driver_probe() here
may create issues if we do stuff like multi-threaded driver probe
later.
