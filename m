Return-Path: <linux-kernel-owner+w=401wt.eu-S934043AbXGMAJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbXGMAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 20:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932790AbXGMAJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 20:09:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39327 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933419AbXGMAJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 20:09:42 -0400
Date: Thu, 12 Jul 2007 17:08:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Trilok Soni" <soni.trilok@gmail.com>
Cc: i2c@lm-sensors.org, "Jean Delvare" <khali@linux-fr.org>,
       "Tony Lindgren" <tony@atomide.com>,
       "David Brownell" <david-b@pacbell.net>, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org, amit.kucheria@gmail.com
Subject: Re: OMAP: Add TI TWL92330/Menelaus Power Management chip driver
Message-Id: <20070712170844.a367b8c9.akpm@linux-foundation.org>
In-Reply-To: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
References: <5d5443650707092353v153fe90clbd1a42d465ed79a4@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:23:06 +0530
"Trilok Soni" <soni.trilok@gmail.com> wrote:

> Add Texas Instruments TWL92330/Menelaus Power Management chip driver.
> This includes voltage regulators, Dual slot memory card tranceivers and
> real-time clock(RTC).
> 
> The support for RTC is integrated with this driver only; it is not separate
> module. Passes 'rtctest' on OMAP H4 EVM, other than lack of
> "periodic" (1/N second) IRQs. System wakeup alarms (from suspend-to-RAM)
> work too.
> 
> The battery keeps the RTC active over power off, so once you set clock
> (rdate/ntpdate/etc, then "hwclock -w") then RTC_HCTOSYS at boot time
> will behave as expected.
> 
> ...
>
> +
> +struct menelaus_chip {
> +	struct mutex		lock;
> +	struct i2c_client	*client;
> +	struct work_struct	work;
> +#ifdef CONFIG_RTC_DRV_TWL92330
> +	struct rtc_device	*rtc;
> +	u8			rtc_control;
> +	unsigned		uie:1;
> +#endif
> +	unsigned		vcore_hw_mode:1;

uie and vcore_hw_mode will share the same memory word.  Consequently, on
preemptible or SMP kernels, a simple

	p->uie = 1;

can race with a simple

	p->vcore_hw_mode = 1;

in a different thread of control, potentially corrupting the other value. 

The same race can occur even on uniprocessor, non-preempt kernels if one of
these fields gets assigned to from interrupt/softirq/etc contexts.

Does your code have suitable locking to prevent such races?  If not, I'd
suggest that these two fields be converted to int or char or whatever.

> +	u8			mask1, mask2;
> +	void			(*handlers[16])(struct menelaus_chip *);

What determined the value of this hard-wired 16?

> +	void			(*mmc_callback)(void *data, u8 mask);
> +	void			*mmc_callback_data;
> +};
> +
>
> ...
>
> +/* Adds a handler for an interrupt. Does not run in interrupt context */
> +static int menelaus_add_irq_work(int irq,
> +		void (*handler)(struct menelaus_chip *))
> +{
> +	int ret = 0;

Unneeded initialisation.

> +	mutex_lock(&the_menelaus->lock);
> +	the_menelaus->handlers[irq] = handler;
> +	ret = menelaus_enable_irq(irq);
> +	mutex_unlock(&the_menelaus->lock);
> +
> +	return ret;
> +}
> +
> +/* Removes handler for an interrupt */
> +static int menelaus_remove_irq_work(int irq)
> +{
> +	int ret = 0;

Ditto

> +	mutex_lock(&the_menelaus->lock);
> +	ret = menelaus_disable_irq(irq);
> +	the_menelaus->handlers[irq] = NULL;
> +	mutex_unlock(&the_menelaus->lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * Gets scheduled when a card detect interrupt happens. Note that in some cases
> + * this line is wired to card cover switch rather than the card detect switch
> + * in each slot. In this case the cards are not seen by menelaus.
> + * FIXME: Add handling for D1 too
> + */
> +static void menelaus_mmc_cd_work(struct menelaus_chip *menelaus_hw)
> +{
> +	int reg;
> +	unsigned char card_mask = 0;
> +
> +	reg = menelaus_read_reg(MENELAUS_MCT_PIN_ST);
> +	if (reg < 0)
> +		return;
> +
> +	if (!(reg & 0x1))
> +		card_mask |= (1 << 0);
> +
> +	if (!(reg & 0x2))
> +		card_mask |= (1 << 1);

The above looks like a slow way of doing

	card_mask = (reg & 3) ^ 3;

But perhaps what you have is a little clearer.

> +	if (menelaus_hw->mmc_callback)
> +		menelaus_hw->mmc_callback(menelaus_hw->mmc_callback_data,
> +					  card_mask);
> +}
> +
> +/*
> + * Toggles the MMC slots between open-drain and push-pull mode.
> + */
> +int menelaus_set_mmc_opendrain(int slot, int enable)
> +{
> +	int ret, val;
> +
> +	if (slot != 1 && slot != 2)
> +		return -EINVAL;

Can this happen?

> +	mutex_lock(&the_menelaus->lock);
> +	ret = menelaus_read_reg(MENELAUS_MCT_CTRL1);
> +	if (ret < 0) {
> +		mutex_unlock(&the_menelaus->lock);
> +		return ret;
> +	}
> +	val = ret;
> +	if (slot == 1) {
> +		if (enable)
> +			val |= 1 << 2;
> +		else
> +			val &= ~(1 << 2);
> +	} else {
> +		if (enable)
> +			val |= 1 << 3;
> +		else
> +			val &= ~(1 << 3);
> +	}
> +	ret = menelaus_write_reg(MENELAUS_MCT_CTRL1, val);
> +	mutex_unlock(&the_menelaus->lock);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(menelaus_set_mmc_opendrain);

Nothing uses this export.  We should remove the export until some code
which requires it is merged.

> +int menelaus_set_slot_sel(int enable)
> +{
> +	int ret;
> +
> +	mutex_lock(&the_menelaus->lock);
> +	ret = menelaus_read_reg(MENELAUS_GPIO_CTRL);
> +	if (ret < 0)
> +		goto out;
> +	ret |= 0x02;
> +	if (enable)
> +		ret |= 1 << 5;
> +	else
> +		ret &= ~(1 << 5);
> +	ret = menelaus_write_reg(MENELAUS_GPIO_CTRL, ret);
> +out:
> +	mutex_unlock(&the_menelaus->lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(menelaus_set_slot_sel);

Ditto.

> +EXPORT_SYMBOL(menelaus_set_mmc_slot);

Ditto on all ten of these new exports.

> +
> +int menelaus_register_mmc_callback(void (*callback)(void *data, u8 card_mask),
> +				   void *data)
> +{
> +	int ret = 0;

Unneeded intialisation.

Probably gcc just fixes this up, but it is poor practice: if someone later
comes along and modifies this code and forgets an initialisation path, your
needless initialisation here will suppress the "might be used
uninitialised" warning which they wanted to see.

> +	the_menelaus->mmc_callback_data = data;
> +	the_menelaus->mmc_callback = callback;
> +	ret = menelaus_add_irq_work(MENELAUS_MMC_S1CD_IRQ,
> +				    menelaus_mmc_cd_work);
> +	if (ret < 0)
> +		return ret;
> +	ret = menelaus_add_irq_work(MENELAUS_MMC_S2CD_IRQ,
> +				    menelaus_mmc_cd_work);
> +	if (ret < 0)
> +		return ret;
> +	ret = menelaus_add_irq_work(MENELAUS_MMC_S1D1_IRQ,
> +				    menelaus_mmc_cd_work);
> +	if (ret < 0)
> +		return ret;
> +	ret = menelaus_add_irq_work(MENELAUS_MMC_S2D1_IRQ,
> +				    menelaus_mmc_cd_work);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(menelaus_register_mmc_callback);
> +
>
> ...
>
> +EXPORT_SYMBOL(menelaus_unregister_mmc_callback);

If we decide to remove all these exports for now, we really should make the
symbols static as well.  Until they are really used externally.

> +struct menelaus_vtg {
> +	const char *name;
> +	u8 vtg_reg;
> +	u8 vtg_shift;
> +	u8 vtg_bits;
> +	u8 mode_reg;
> +};
> +
> +struct menelaus_vtg_value {
> +	u16 vtg;
> +	u16 val;
> +};

Please try to document each field of each struct with inlined comments.

> +static int menelaus_set_voltage(const struct menelaus_vtg *vtg, int mV,
> +				int vtg_val, int mode)
> +{
> +	int val, ret;
> +	struct i2c_client *c = the_menelaus->client;
> +
> +	mutex_lock(&the_menelaus->lock);
> +	if (vtg == 0)
> +		goto set_voltage;

Please use NULL for zero-valued pointers.  The code as you have it here
will generate a sparse warning (Documentation/SubmitChecklist, point 9,
guys) so I end up getting sent a dopey fixup patch a few weeks later.

> +	ret = menelaus_read_reg(vtg->vtg_reg);
> +	if (ret < 0)
> +		goto out;
> +	val = ret & ~(((1 << vtg->vtg_bits) - 1) << vtg->vtg_shift);
> +	val |= vtg_val << vtg->vtg_shift;
> +
> +	dev_dbg(&c->dev, "Setting voltage '%s'"
> +			 "to %d mV (reg 0x%02x, val 0x%02x)\n",
> +			vtg->name, mV, vtg->vtg_reg, val);
> +
> +	ret = menelaus_write_reg(vtg->vtg_reg, val);
> +	if (ret < 0)
> +		goto out;
> +set_voltage:
> +	ret = menelaus_write_reg(vtg->mode_reg, mode);
> +out:
> +	mutex_unlock(&the_menelaus->lock);
> +	if (ret == 0) {
> +		/* Wait for voltage to stabilize */
> +		msleep(1);
> +	}
> +	return ret;
> +}
>
> ...
>
> +
> +int menelaus_set_vcore_sw(unsigned int mV)

Please check whether all the newly-added global symbols in fact need to be
global.

> +{
> +	int val, ret;
> +	struct i2c_client *c = the_menelaus->client;
> +
> +	val = menelaus_get_vtg_value(mV, vcore_values,
> +				     ARRAY_SIZE(vcore_values));
> +	if (val < 0)
> +		return -EINVAL;
> +
> +	dev_dbg(&c->dev, "Setting VCORE to %d mV (val 0x%02x)\n", mV, val);
> +
> +	/* Set SW mode and the voltage in one go. */
> +	mutex_lock(&the_menelaus->lock);
> +	ret = menelaus_write_reg(MENELAUS_VCORE_CTRL1, val);
> +	if (ret == 0)
> +		the_menelaus->vcore_hw_mode = 0;
> +	mutex_unlock(&the_menelaus->lock);
> +	msleep(1);

It is not possible for the reader to determine why this msleep() is here
just by reading the code.  Hence an explanatory comment is needed.

> +	return ret;
> +}
> +
> +int menelaus_set_vcore_hw(unsigned int roof_mV, unsigned int floor_mV)
> +{
> +	int fval, rval, val, ret;
> +	struct i2c_client *c = the_menelaus->client;
> +
> +	rval = menelaus_get_vtg_value(roof_mV, vcore_values,
> +				      ARRAY_SIZE(vcore_values));
> +	if (rval < 0)
> +		return -EINVAL;
> +	fval = menelaus_get_vtg_value(floor_mV, vcore_values,
> +				      ARRAY_SIZE(vcore_values));
> +	if (fval < 0)
> +		return -EINVAL;
> +
> +	dev_dbg(&c->dev, "Setting VCORE FLOOR to %d mV and ROOF to %d mV\n",
> +	       floor_mV, roof_mV);
> +
> +	mutex_lock(&the_menelaus->lock);
> +	ret = menelaus_write_reg(MENELAUS_VCORE_CTRL3, fval);
> +	if (ret < 0)
> +		goto out;
> +	ret = menelaus_write_reg(MENELAUS_VCORE_CTRL4, rval);
> +	if (ret < 0)
> +		goto out;
> +	if (!the_menelaus->vcore_hw_mode) {
> +		val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
> +		/* HW mode, turn OFF byte comparator */
> +		val |= ((1 << 7) | (1 << 5));
> +		ret = menelaus_write_reg(MENELAUS_VCORE_CTRL1, val);
> +		the_menelaus->vcore_hw_mode = 1;
> +	}
> +	msleep(1);

Ditto, for all msleep()s, please.

> +out:
> +	mutex_unlock(&the_menelaus->lock);
> +	return ret;
> +}
> +
>
> ...
>
> +/*-----------------------------------------------------------------------*/
> +
> +/* Handles Menelaus interrupts. Does not run in interrupt context */
> +static void menelaus_work(struct work_struct *_menelaus)
> +{
> +	struct menelaus_chip *menelaus =
> +			container_of(_menelaus, struct menelaus_chip, work);
> +	void (*handler)(struct menelaus_chip *menelaus);
> +
> +	while (1) {
> +		unsigned isr;
> +
> +		isr = (menelaus_read_reg(MENELAUS_INT_STATUS2)
> +				& ~menelaus->mask2) << 8;
> +		isr |= menelaus_read_reg(MENELAUS_INT_STATUS1)
> +				& ~menelaus->mask1;
> +		if (!isr)
> +			break;
> +
> +		while (isr) {
> +			int irq = fls(isr) - 1;
> +			isr &= ~(1 << irq);
> +
> +			mutex_lock(&menelaus->lock);
> +			menelaus_disable_irq(irq);
> +			menelaus_ack_irq(irq);
> +			handler = menelaus->handlers[irq];
> +			if (handler)
> +				handler(menelaus);
> +			menelaus_enable_irq(irq);
> +			mutex_unlock(&menelaus->lock);
> +		}
> +	}
> +	enable_irq(menelaus->client->irq);

This can do an enable_irq() of an already-enabled IRQ.  I don't know if
that will cause runtime problems, but it doesn't seem desirable.

> +}
> +
> +/*
> + * We cannot use I2C in interrupt context, so we just schedule work.
> + */
> +static irqreturn_t menelaus_irq(int irq, void *_menelaus)
> +{
> +	struct menelaus_chip *menelaus = _menelaus;
> +
> +	disable_irq_nosync(irq);

I guess the reader of this code will wonder why the nosync variant was
used.  A comment would explain that.

In fact the reader might wonder why the heck we use a workqueue at all,
rather than just doing the work in interrupt context as drivers normally
do.

Perhaps that was all explained somewhere and I missed it.  If not, I'd
suggest that this design decision should be described in a code comment
somewhere.

> +	(void)schedule_work(&menelaus->work);

Please remove the (void).

> +	return IRQ_HANDLED;
> +}
>
> ...
>
> +#ifdef CONFIG_RTC_INTF_DEV
> +
> +static void menelaus_rtc_update_work(struct menelaus_chip *m)
> +{
> +	/* report 1/sec update */
> +	local_irq_disable();
> +	rtc_update_irq(m->rtc, 1, RTC_IRQF | RTC_UF);
> +	local_irq_enable();
> +}

ow.  Is that local_irq_disable() assuming that this code will only ever run
on a uniprocessor machine?

If so, that's pretty poor, IMO.  It would be better to design the code to
be SMP-capable from day one.

> +static int menelaus_ioctl(struct device *dev, unsigned cmd, unsigned long arg)
> +{
> +	int	status;
> +
> +	if (the_menelaus->client->irq <= 0)
> +		return -ENOIOCTLCMD;
> +
> +	switch (cmd) {
> +	/* alarm IRQ */
> +	case RTC_AIE_ON:
> +		if (the_menelaus->rtc_control & RTC_CTRL_AL_EN)
> +			return 0;
> +		the_menelaus->rtc_control |= RTC_CTRL_AL_EN;
> +		break;
> +	case RTC_AIE_OFF:
> +		if (!(the_menelaus->rtc_control & RTC_CTRL_AL_EN))
> +			return 0;
> +		the_menelaus->rtc_control &= ~RTC_CTRL_AL_EN;
> +		break;
> +	/* 1/second "update" IRQ */
> +	case RTC_UIE_ON:
> +		if (the_menelaus->uie)
> +			return 0;
> +		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
> +		status = menelaus_add_irq_work(MENELAUS_RTCTMR_IRQ,
> +				menelaus_rtc_update_work);
> +		if (status == 0)
> +			the_menelaus->uie = 1;
> +		return status;
> +	case RTC_UIE_OFF:
> +		if (!the_menelaus->uie)
> +			return 0;
> +		status = menelaus_remove_irq_work(MENELAUS_RTCTMR_IRQ);
> +		if (status == 0)
> +			the_menelaus->uie = 0;
> +		return status;
> +	default:
> +		return -ENOIOCTLCMD;
> +	}
> +	return menelaus_write_reg(MENELAUS_RTC_CTRL, the_menelaus->rtc_control);
> +}
> +
> +#else
> +#define menelaus_ioctl	NULL
> +#endif
> +
> +/* REVISIT no compensation register support ... */
> +
> +static const struct rtc_class_ops menelaus_rtc_ops = {
> +	.ioctl			= menelaus_ioctl,
> +	.read_time		= menelaus_read_time,
> +	.set_time		= menelaus_set_time,
> +	.read_alarm		= menelaus_read_alarm,
> +	.set_alarm		= menelaus_set_alarm,
> +};
> +
>
> ...
>
> +static inline void menelaus_rtc_init(struct menelaus_chip *m)
> +{

The `inline' isn't needed here.  If it has one callsite the compiler will
inline it for you.  If we later gain a second callsite, your inline becomes
wrong: the function is far too large to be worth inlining at both callsites.

> +	int	alarm = (m->client->irq > 0);
> +
> +	/* assume 32KDETEN pin is pulled high */
> +	if (!(menelaus_read_reg(MENELAUS_OSC_CTRL) & 0x80)) {
> +		dev_dbg(&m->client->dev, "no 32k oscillator\n");
> +		return;
> +	}
> +
> +	/* support RTC alarm; it can issue wakeups */
> +	if (alarm) {
> +		if (menelaus_add_irq_work(MENELAUS_RTCALM_IRQ,
> +				menelaus_rtc_alarm_work) < 0) {
> +			dev_err(&m->client->dev, "can't handle RTC alarm\n");
> +			return;
> +		}
> +		device_init_wakeup(&m->client->dev, 1);
> +	}
> +
> +	/* be sure RTC is enabled; allow 1/sec irqs; leave 12hr mode alone */
> +	m->rtc_control = menelaus_read_reg(MENELAUS_RTC_CTRL);
> +	if (!(m->rtc_control & RTC_CTRL_RTC_EN)
> +			|| (m->rtc_control & RTC_CTRL_AL_EN)
> +			|| (m->rtc_control & RTC_CTRL_EVERY_MASK)) {
> +		if (!(m->rtc_control & RTC_CTRL_RTC_EN)) {
> +			dev_warn(&m->client->dev, "rtc clock needs setting\n");
> +			m->rtc_control |= RTC_CTRL_RTC_EN;
> +		}
> +		m->rtc_control &= ~RTC_CTRL_EVERY_MASK;
> +		m->rtc_control &= ~RTC_CTRL_AL_EN;
> +		menelaus_write_reg(MENELAUS_RTC_CTRL, m->rtc_control);
> +	}
> +
> +	m->rtc = rtc_device_register(DRIVER_NAME,
> +			&m->client->dev,
> +			&menelaus_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(m->rtc)) {
> +		if (alarm) {
> +			menelaus_remove_irq_work(MENELAUS_RTCALM_IRQ);
> +			device_init_wakeup(&m->client->dev, 0);
> +		}
> +		dev_err(&m->client->dev, "can't register RTC: %d\n",
> +				(int) PTR_ERR(m->rtc));
> +		the_menelaus->rtc = NULL;
> +	}
> +}
> +
> +#else
> +
> +static inline void menelaus_rtc_init(struct menelaus_chip *m)
> +{
> +	/* nothing */
> +}

The inline here is OK.  Strictly it isn't needed either, but what you have
here is a very typical kernel pattern.

> +#endif
> +
> +/*-----------------------------------------------------------------------*/
> +
> +static struct i2c_driver menelaus_i2c_driver;
> +
> +static int menelaus_probe(struct i2c_client *client)
> +{
> +	struct menelaus_chip	*menelaus;
> +	int			rev = 0, val;

unneeded initialisation.

> +	int			err = 0;
> +	struct menelaus_platform_data *menelaus_pdata =
> +					client->dev.platform_data;
> +
> +	if (the_menelaus) {
> +		dev_dbg(&client->dev, "only one %s for now\n",
> +				DRIVER_NAME);
> +		return -ENODEV;

I doubt if this can happen?

> +	}
> +
> +	menelaus = kzalloc(sizeof *menelaus, GFP_KERNEL);
> +	if (!menelaus)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, menelaus);
> +
> +	the_menelaus = menelaus;
> +	menelaus->client = client;
> +
> +	/* If a true probe check the device */
> +	rev = menelaus_read_reg(MENELAUS_REV);
> +	if (rev < 0) {
> +		pr_err("device not found");
> +		err = -ENODEV;
> +		goto fail1;
> +	}
> +
> +	/* Ack and disable all Menelaus interrupts */
> +	menelaus_write_reg(MENELAUS_INT_ACK1, 0xff);
> +	menelaus_write_reg(MENELAUS_INT_ACK2, 0xff);
> +	menelaus_write_reg(MENELAUS_INT_MASK1, 0xff);
> +	menelaus_write_reg(MENELAUS_INT_MASK2, 0xff);
> +	menelaus->mask1 = 0xff;
> +	menelaus->mask2 = 0xff;
> +
> +	/* Set output buffer strengths */
> +	menelaus_write_reg(MENELAUS_MCT_CTRL1, 0x73);
> +
> +	if (client->irq > 0) {
> +		err = request_irq(client->irq, menelaus_irq, IRQF_DISABLED,
> +				  DRIVER_NAME, menelaus);
> +		if (err) {
> +			dev_dbg(&client->dev,  "can't get IRQ %d, err %d",
> +					client->irq, err);
> +			goto fail1;
> +		}
> +	}
> +
> +	mutex_init(&menelaus->lock);
> +	INIT_WORK(&menelaus->work, menelaus_work);
> +
> +	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
> +
> +	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
> +	if (val < 0)
> +		goto fail2;
> +	if (val & (1 << 7))
> +		menelaus->vcore_hw_mode = 1;
> +	else
> +		menelaus->vcore_hw_mode = 0;
> +
> +	if (menelaus_pdata != NULL && menelaus_pdata->late_init != NULL) {
> +		err = menelaus_pdata->late_init(&client->dev);
> +		if (err < 0)
> +			goto fail2;
> +	}
> +
> +	menelaus_rtc_init(menelaus);
> +
> +	return 0;
> +fail2:
> +	free_irq(client->irq, menelaus);
> +	flush_scheduled_work();
> +fail1:
> +	kfree(menelaus);
> +	return err;
> +}
> +

