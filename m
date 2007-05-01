Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXEAG6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXEAG6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932903AbXEAG6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:58:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932943AbXEAG56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:57:58 -0400
Date: Mon, 30 Apr 2007 23:57:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 3/4] SoC base drivers: ASIC3 driver
Message-Id: <20070430235753.867dc59b.akpm@linux-foundation.org>
In-Reply-To: <06028862.20070501080948@gmail.com>
References: <06028862.20070501080948@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007 08:09:48 +0300 Paul Sokolovsky <pmiscml@gmail.com> wrote:

> Hello linux-kernel,
> 
> Note: This driver depends on ds1wm.h header, recently submitted, and which by now should be in -mm tree.
> -----
> 
> asic3_base: SoC base driver for ASIC3 chip.
> 
> Signed-off-by: Paul Sokolovsky <pmiscml@gmail.com>
> 
> ...
>
> +
> +struct asic3_data
> +{

struct asic3_data {

> +	void *mapping;
> +	unsigned int bus_shift;
> +	int irq_base;
> +	int irq_nr;
> +
> +	u16 irq_bothedge[4];
> +	struct device *dev;
> +
> +	struct platform_device *mmc_dev;
> +};
> +
> +static spinlock_t asic3_gpio_lock;

DEFINE_SPINLOCK(), please - it's better to do it at compile-time.

> +static int asic3_remove(struct platform_device *dev);
> +
> +static inline unsigned long asic3_address(struct device *dev,
> +					  unsigned int reg)
> +{
> +	struct asic3_data *adata;
> +
> +	adata = (struct asic3_data *)dev->driver_data;
> +
> +	return (unsigned long)adata->mapping + (reg >> (2 - adata->bus_shift));
> +}
> +
> +void asic3_write_register(struct device *dev, unsigned int reg, u32 value)
> +{
> +	__raw_writew(value, asic3_address(dev, reg));
> +}
> +EXPORT_SYMBOL(asic3_write_register);
> +
> +u32 asic3_read_register(struct device *dev, unsigned int reg)
> +{
> +	return __raw_readw(asic3_address(dev, reg));
> +}
> +EXPORT_SYMBOL(asic3_read_register);
> +
> +static inline void __asic3_write_register(struct asic3_data *asic,
> +					  unsigned int reg, u32 value)
> +{
> +	__raw_writew(value, (unsigned long)asic->mapping
> +			    + (reg >> (2 - asic->bus_shift)));
> +}
> +
> +static inline u32 __asic3_read_register(struct asic3_data *asic,
> +					unsigned int reg)
> +{
> +	return __raw_readw((unsigned long)asic->mapping
> +			   + (reg >> (2 - asic->bus_shift)));
> +}

Why __raw_*() here?

How come we're using the io.h functions here, but [patch 2/4] open-coded it?

> +#define ASIC3_GPIO_FN(get_fn_name, set_fn_name, REG)			\
> +u32 get_fn_name(struct device *dev)					\
> +{                                                                       \
> +	return asic3_read_register(dev, REG);				\
> +}                                                                       \
> +EXPORT_SYMBOL(get_fn_name);						\
> +									\
> +void set_fn_name(struct device *dev, u32 bits, u32 val)			\
> +{                                                                       \
> +	unsigned long flags;						\
> +									\
> +	spin_lock_irqsave(&asic3_gpio_lock, flags);			\
> +	val |= (asic3_read_register(dev, REG) & ~bits);			\
> +	asic3_write_register(dev, REG, val);				\
> +	spin_unlock_irqrestore(&asic3_gpio_lock, flags);		\
> +}                                                                       \
> +EXPORT_SYMBOL(set_fn_name);
> +
> +#define ASIC3_GPIO_REGISTER(ACTION, action, fn, FN)			\
> +	ASIC3_GPIO_FN (asic3_get_gpio_ ## action ## _ ## fn ,		\
> +		       asic3_set_gpio_ ## action ## _ ## fn ,		\
> +		       _IPAQ_ASIC3_GPIO_ ## FN ## _Base 		\
> +		       + _IPAQ_ASIC3_GPIO_ ## ACTION )
> +
> +#define ASIC3_GPIO_FUNCTIONS(fn, FN)					\
> +	ASIC3_GPIO_REGISTER (Direction, dir, fn, FN)			\
> +	ASIC3_GPIO_REGISTER (Out, out, fn, FN)				\
> +	ASIC3_GPIO_REGISTER (SleepMask, sleepmask, fn, FN)		\
> +	ASIC3_GPIO_REGISTER (SleepOut, sleepout, fn, FN)		\
> +	ASIC3_GPIO_REGISTER (BattFaultOut, battfaultout, fn, FN)	\
> +	ASIC3_GPIO_REGISTER (AltFunction, alt_fn, fn, FN)		\
> +	ASIC3_GPIO_REGISTER (SleepConf, sleepconf, fn, FN)		\
> +	ASIC3_GPIO_REGISTER (Status, status, fn, FN)
> +
> +ASIC3_GPIO_FUNCTIONS(a, A)
> +ASIC3_GPIO_FUNCTIONS(b, B)
> +ASIC3_GPIO_FUNCTIONS(c, C)
> +ASIC3_GPIO_FUNCTIONS(d, D)

Ho hum, fair enough.

Was it deliberate that get_fn_name() and set_fn_name() are given global
scope?  I guess so, given that they're exported to modules.

Please remove the space between the function or macro name and the "("
(whole patchset).

> +int asic3_gpio_get_value(struct device *dev, unsigned gpio)
> +{
> +	u32 mask = ASIC3_GPIO_bit(gpio);
> +	printk("%s(%d)\n", __FUNCTION__, gpio);
> +	switch (gpio >> 4) {
> +	case _IPAQ_ASIC3_GPIO_BANK_A:
> +		return asic3_get_gpio_status_a(dev) & mask;
> +	case _IPAQ_ASIC3_GPIO_BANK_B:
> +		return asic3_get_gpio_status_b(dev) & mask;
> +	case _IPAQ_ASIC3_GPIO_BANK_C:
> +		return asic3_get_gpio_status_c(dev) & mask;
> +	case _IPAQ_ASIC3_GPIO_BANK_D:
> +		return asic3_get_gpio_status_d(dev) & mask;
> +	}
> +
> +	printk(KERN_ERR "%s: invalid GPIO value 0x%x", __FUNCTION__, gpio);
> +	return 0;
> +}
> +EXPORT_SYMBOL(asic3_gpio_get_value);
> +
> +void asic3_gpio_set_value(struct device *dev, unsigned gpio, int val)
> +{
> +	u32 mask = ASIC3_GPIO_bit(gpio);
> +	u32 bitval = 0;
> +	if (val)  bitval = mask;
> +	printk("%s(%d, %d)\n", __FUNCTION__, gpio, val);
> +
> +	switch (gpio >> 4) {
> +	case _IPAQ_ASIC3_GPIO_BANK_A:
> +		asic3_set_gpio_out_a(dev, mask, bitval);
> +		return;
> +	case _IPAQ_ASIC3_GPIO_BANK_B:
> +		asic3_set_gpio_out_b(dev, mask, bitval);
> +		return;
> +	case _IPAQ_ASIC3_GPIO_BANK_C:
> +		asic3_set_gpio_out_c(dev, mask, bitval);
> +		return;
> +	case _IPAQ_ASIC3_GPIO_BANK_D:
> +		asic3_set_gpio_out_d(dev, mask, bitval);
> +		return;
> +	}
> +
> +	printk(KERN_ERR "%s: invalid GPIO value 0x%x", __FUNCTION__, gpio);
> +}
> +EXPORT_SYMBOL(asic3_gpio_set_value);

I assume all these debugging printks won't last long.

> +int asic3_irq_base(struct device *dev)
> +{
> +	struct asic3_data *asic = dev->driver_data;
> +
> +	return asic->irq_base;
> +}
> +EXPORT_SYMBOL(asic3_irq_base);
> +
> +void asic3_set_led(struct device *dev, int led_num, int duty_time,
> +		   int cycle_time, int timebase)
> +{
> +	struct asic3_data *asic = dev->driver_data;
> +	unsigned int led_base;
> +
> +	/* it's a macro thing: see #define _IPAQ_ASIC_LED_0_Base for why you
> +	 * can't substitute led_num in the macros below...
> +	 */
> +
> +	switch (led_num) {
> +	case 0:
> +		led_base = _IPAQ_ASIC3_LED_0_Base;
> +		break;
> +	case 1:
> +		led_base = _IPAQ_ASIC3_LED_1_Base;
> +		break;
> +	case 2:
> +		led_base = _IPAQ_ASIC3_LED_2_Base;
> +		break;
> +	default:
> +		printk(KERN_ERR "%s: invalid led number %d", __FUNCTION__,
> +		       led_num);
> +		return;
> +	}
> +
> +	__asic3_write_register(asic, led_base + _IPAQ_ASIC3_LED_TimeBase,
> +			       timebase | LED_EN);
> +	__asic3_write_register(asic, led_base + _IPAQ_ASIC3_LED_PeriodTime,
> +			       cycle_time);
> +	__asic3_write_register(asic, led_base + _IPAQ_ASIC3_LED_DutyTime,
> +			       0);
> +	udelay(20);     /* asic voodoo - possibly need a whole duty cycle? */
> +	__asic3_write_register(asic, led_base + _IPAQ_ASIC3_LED_DutyTime,
> +			       duty_time);
> +}
> +
> +EXPORT_SYMBOL(asic3_set_led);

Remove the line before EXPORT_SYMBOL().

> +void asic3_set_clock_sel(struct device *dev, u32 bits, u32 val)
> +{
> +	struct asic3_data *asic = dev->driver_data;
> +	unsigned long flags;
> +	u32 v;
> +
> +	spin_lock_irqsave(&asic3_gpio_lock, flags);
> +	v = __asic3_read_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, SEL));
> +	v = (v & ~bits) | val;
> +	__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, SEL), v);
> +	spin_unlock_irqrestore(&asic3_gpio_lock, flags);
> +}
> +EXPORT_SYMBOL(asic3_set_clock_sel);
> +
> +void asic3_set_clock_cdex(struct device *dev, u32 bits, u32 val)
> +{
> +	struct asic3_data *asic = dev->driver_data;
> +	unsigned long flags;
> +	u32 v;
> +
> +	spin_lock_irqsave(&asic3_gpio_lock, flags);
> +	v = __asic3_read_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, CDEX));
> +	v = (v & ~bits) | val;
> +	__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, CDEX), v);
> +	spin_unlock_irqrestore(&asic3_gpio_lock, flags);
> +}
> +EXPORT_SYMBOL(asic3_set_clock_cdex);
> +
> +static int asic3_clock_cdex_enable(struct clk *clk, int enable)
> +{
> +	struct asic3_data *asic = (struct asic3_data *)clk->parent->ctrlbit;
> +	unsigned long flags, val;
> +
> +	local_irq_save(flags);
> +
> +	val = __asic3_read_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, CDEX));
> +	if (enable)
> +		val |= clk->ctrlbit;
> +	else
> +		val &= ~clk->ctrlbit;
> +	__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, CDEX), val);
> +
> +	local_irq_restore(flags);
> +	
> +	return 0;
> +}

How come asic3_clock_cdex_enable() uses local_irq_save() but the
similar-looking functions above use spin_lock_irqsave()?

> +
> +#define MAX_ASIC_ISR_LOOPS    20
> +#define _IPAQ_ASIC3_GPIO_Base_INCR \
> +	(_IPAQ_ASIC3_GPIO_B_Base - _IPAQ_ASIC3_GPIO_A_Base)
> +
> +static inline void asic3_irq_flip_edge(struct asic3_data *asic,
> +				       u32 base, int bit)
> +{
> +	u16 edge = __asic3_read_register(asic,
> +		base + _IPAQ_ASIC3_GPIO_EdgeTrigger);
> +	edge ^= bit;
> +	__asic3_write_register(asic,
> +		base + _IPAQ_ASIC3_GPIO_EdgeTrigger, edge);
> +}

This function doesn't need the spinlock?

> +static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
> +{
> +	int iter;
> +	struct asic3_data *asic;
> +
> +	/* Acknowledge the parrent (i.e. CPU's) IRQ */
> +	desc->chip->ack(irq);
> +
> +	asic = desc->handler_data;
> +
> +	/* printk( KERN_NOTICE "asic3_irq_demux: irq=%d\n", irq ); */
> +	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
> +		u32 status;
> +		int bank;
> +
> +		status = __asic3_read_register(asic,
> +			IPAQ_ASIC3_OFFSET(INTR, PIntStat));
> +		/* Check all ten register bits */
> +		if ((status & 0x3ff) == 0)
> +			break;
> +
> +		/* Handle GPIO IRQs */
> +		for (bank = 0; bank < 4; bank++) {
> +			if (status & (1 << bank)) {
> +				unsigned long base, i, istat;
> +
> +				base = _IPAQ_ASIC3_GPIO_A_Base
> +				       + bank * _IPAQ_ASIC3_GPIO_Base_INCR;
> +				istat = __asic3_read_register(asic,
> +					base + _IPAQ_ASIC3_GPIO_IntStatus);
> +				/* IntStatus is write 0 to clear */
> +				/* XXX could miss interrupts! */
> +				__asic3_write_register(asic,
> +					base + _IPAQ_ASIC3_GPIO_IntStatus, 0);

And neither does this?

> +				for (i = 0; i < 16; i++) {

I hope the magical 16 is meaningful to those who are familiar with the
hardware.

> +					int bit = (1 << i);
> +					unsigned int irqnr;
> +					if (!(istat & bit))
> +						continue;
> +
> +					irqnr = asic->irq_base 
> +						+ (16 * bank) + i;
> +					desc = irq_desc + irqnr;
> +					desc->handle_irq(irqnr, desc);
> +					if (asic->irq_bothedge[bank] & bit) {
> +						asic3_irq_flip_edge(asic, base,
> +								    bit);
> +					}
> +				}
> +			}
> +		}
> +
> +		/* Handle remaining IRQs in the status register */
> +		{
> +			int i;
> +
> +			for (i = ASIC3_LED0_IRQ; i <= ASIC3_OWM_IRQ; i++) {
> +				/* They start at bit 4 and go up */
> +				if (status & (1 << (i - ASIC3_LED0_IRQ + 4))) {
> +					desc = irq_desc + asic->irq_base + i;
> +					desc->handle_irq(asic->irq_base + i,
> +							 desc);
> +				}
> +			}
> +		}
> +
> +	}
> +
> +	if (iter >= MAX_ASIC_ISR_LOOPS)
> +		printk(KERN_ERR "%s: interrupt processing overrun\n",
> +		       __FUNCTION__);
> +}
> +
> +static inline int asic3_irq_to_bank(struct asic3_data *asic, int irq)
> +{
> +	int n;
> +
> +	n = (irq - asic->irq_base) >> 4;
> +
> +	return (n * (_IPAQ_ASIC3_GPIO_B_Base - _IPAQ_ASIC3_GPIO_A_Base));
> +}
> +
> +static inline int asic3_irq_to_index(struct asic3_data *asic, int irq)
> +{
> +	return (irq - asic->irq_base) & 15;
> +}
> +
> +static void asic3_mask_gpio_irq(unsigned int irq)
> +{
> +	struct asic3_data *asic = get_irq_chip_data(irq);
> +	u32 val, bank, index;
> +	unsigned long flags;
> +
> +	bank = asic3_irq_to_bank(asic, irq);
> +	index = asic3_irq_to_index(asic, irq);
> +
> +	spin_lock_irqsave(&asic3_gpio_lock, flags);
> +	val = __asic3_read_register(asic, bank + _IPAQ_ASIC3_GPIO_Mask);
> +	val |= 1 << index;
> +	__asic3_write_register(asic, bank + _IPAQ_ASIC3_GPIO_Mask, val);
> +	spin_unlock_irqrestore(&asic3_gpio_lock, flags);
> +}

Locked.

> +static void asic3_mask_irq(unsigned int irq)
> +{
> +	struct asic3_data *asic = get_irq_chip_data(irq);
> +	int regval;
> +
> +	if (irq < ASIC3_NR_GPIO_IRQS) {
> +		printk(KERN_ERR "asic3_base: gpio mask attempt, irq %d\n",
> +		       irq);
> +		return;
> +	}
> +
> +	regval = __asic3_read_register(asic,
> +		_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask);
> +
> +	switch (irq - asic->irq_base) {
> +	case ASIC3_LED0_IRQ:
> +		__asic3_write_register(asic,
> +			_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask,
> +			regval & ~ASIC3_INTMASK_MASK0);
> +		break;
> +	case ASIC3_LED1_IRQ:
> +		__asic3_write_register(asic,
> +			_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask,
> +			regval & ~ASIC3_INTMASK_MASK1);
> +		break;
> +	case ASIC3_LED2_IRQ:
> +		__asic3_write_register(asic,
> +			_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask,
> +			regval & ~ASIC3_INTMASK_MASK2);
> +		break;
> +	case ASIC3_SPI_IRQ:
> +		__asic3_write_register(asic,
> +			_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask,
> +			regval & ~ASIC3_INTMASK_MASK3);
> +		break;
> +	case ASIC3_SMBUS_IRQ:
> +		__asic3_write_register(asic,
> +			_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask,
> +			regval & ~ASIC3_INTMASK_MASK4);
> +		break;
> +	case ASIC3_OWM_IRQ:
> +		__asic3_write_register(asic,
> +			_IPAQ_ASIC3_INTR_Base + _IPAQ_ASIC3_INTR_IntMask,
> +			regval & ~ASIC3_INTMASK_MASK5);
> +		break;
> +	default:
> +		printk(KERN_ERR "asic3_base: bad non-gpio irq %d\n", irq);
> +		break;
> +	}
> +}

Not locked!

Please add a comment to asic3_gpio_lock identifying what resource(s) it
protects.

> +static void  asic3_unmask_gpio_irq(unsigned int irq)

sticky space bar.

> +{
> +	struct asic3_data *asic = get_irq_chip_data(irq);
> +	u32 val, bank, index;
> +	unsigned long flags;
> +
> +	bank = asic3_irq_to_bank(asic, irq);
> +	index = asic3_irq_to_index(asic, irq);
> +
> +	spin_lock_irqsave(&asic3_gpio_lock, flags);
> +	val = __asic3_read_register(asic, bank + _IPAQ_ASIC3_GPIO_Mask);
> +	val &= ~(1 << index);
> +	__asic3_write_register(asic, bank + _IPAQ_ASIC3_GPIO_Mask, val);
> +	spin_unlock_irqrestore(&asic3_gpio_lock, flags);
> +}
>
> ...
>
> +static int asic3_gpio_irq_type(unsigned int irq, unsigned int type)
> +{
> +	struct asic3_data *asic = get_irq_chip_data(irq);
> +	u32 bank, index;
> +	unsigned long flags;
> +	u16 trigger, level, edge, bit;
> +
> +	bank = asic3_irq_to_bank(asic, irq);
> +	index = asic3_irq_to_index(asic, irq);
> +	bit = 1<<index;
> +
> +	spin_lock_irqsave(&asic3_gpio_lock, flags);
> +	level = __asic3_read_register(asic,
> +		bank + _IPAQ_ASIC3_GPIO_LevelTrigger);
> +	edge = __asic3_read_register(asic,
> +		bank + _IPAQ_ASIC3_GPIO_EdgeTrigger);
> +	trigger = __asic3_read_register(asic,
> +		bank + _IPAQ_ASIC3_GPIO_TriggerType);
> +	asic->irq_bothedge[(irq - asic->irq_base) >> 4] &= ~bit;
> +
> +	if (type == IRQT_RISING) {
> +		trigger |= bit;
> +		edge |= bit;
> +	} else if (type == IRQT_FALLING) {
> +		trigger |= bit;
> +		edge &= ~bit;
> +	} else if (type == IRQT_BOTHEDGE) {
> +		trigger |= bit;
> +		if (asic3_gpio_get_value(asic->dev, irq - asic->irq_base))
> +			edge &= ~bit;
> +		else
> +			edge |= bit;
> +		asic->irq_bothedge[(irq - asic->irq_base) >> 4] |= bit;
> +	} else if (type == IRQT_LOW) {
> +		trigger &= ~bit;
> +		level &= ~bit;
> +	} else if (type == IRQT_HIGH) {
> +		trigger &= ~bit;
> +		level |= bit;
> +	} else {
> +		/*
> +		 * if type == IRQT_NOEDGE, we should mask interrupts, but
> +		 * be careful to not unmask them if mask was also called.
> +		 * Probably need internal state for mask.
> +		 */
> +		printk(KERN_NOTICE "asic3: irq type not changed.\n");
> +	}
> +	__asic3_write_register(asic, bank + _IPAQ_ASIC3_GPIO_LevelTrigger,
> +			       level);
> +	__asic3_write_register(asic, bank + _IPAQ_ASIC3_GPIO_EdgeTrigger,
> +			       edge);
> +	__asic3_write_register(asic, bank + _IPAQ_ASIC3_GPIO_TriggerType,
> +			       trigger);
> +	spin_unlock_irqrestore(&asic3_gpio_lock, flags);
> +	return 0;
> +}

Locking here looks good.

> +static struct irq_chip asic3_gpio_irq_chip = {
> +	.name		= "ASIC3-GPIO",
> +	.ack		= asic3_mask_gpio_irq,
> +	.mask		= asic3_mask_gpio_irq,
> +	.unmask		= asic3_unmask_gpio_irq,
> +	.set_type	= asic3_gpio_irq_type,
> +};
> +
> +static struct irq_chip asic3_irq_chip = {
> +	.name		= "ASIC3",
> +	.ack		= asic3_mask_irq,
> +	.mask		= asic3_mask_irq,
> +	.unmask		= asic3_unmask_irq,
> +};
> +
> +static void asic3_release(struct device *dev)
> +{
> +	struct platform_device *sdev = to_platform_device(dev);
> +
> +	kfree(sdev->resource);
> +	kfree(sdev);
> +}
> +
> +int asic3_register_mmc(struct device *dev)
> +{
> +	struct platform_device *sdev = kzalloc(sizeof(*sdev), GFP_KERNEL);
> +	struct tmio_mmc_hwconfig *mmc_config = kmalloc(sizeof(*mmc_config),
> +						       GFP_KERNEL);
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct asic3_data *asic = dev->driver_data;
> +	struct asic3_platform_data *asic3_pdata = dev->platform_data;
> +	struct resource *res;
> +	int rc;
> +
> +	if (sdev == NULL || mmc_config == NULL)
> +		return -ENOMEM;

That'll leak *sdev if *mmc_config==NULL.

> +	if (asic3_pdata->tmio_mmc_hwconfig) {
> +		memcpy(mmc_config, asic3_pdata->tmio_mmc_hwconfig,
> +		       sizeof(*mmc_config));
> +	} else {
> +		memset(mmc_config, 0, sizeof(*mmc_config));
> +	}
> +	mmc_config->address_shift = asic->bus_shift;
> +
> +	sdev->id = -1;
> +	sdev->name = "asic3_mmc";
> +	sdev->dev.parent = dev;
> +	sdev->num_resources = 2;
> +	sdev->dev.platform_data = mmc_config;
> +	sdev->dev.release = asic3_release;
> +
> +	res = kzalloc(sdev->num_resources * sizeof(struct resource),
> +		      GFP_KERNEL);
> +	if (res == NULL) {
> +		kfree(sdev);
> +		kfree(mmc_config);
> +		return -ENOMEM;
> +	}
> +	sdev->resource = res;
> +
> +	res[0].start = pdev->resource[2].start;
> +	res[0].end   = pdev->resource[2].end;
> +	res[0].flags = IORESOURCE_MEM;
> +	res[1].start = res[1].end = pdev->resource[3].start;
> +	res[1].flags = IORESOURCE_IRQ;
> +
> +	rc = platform_device_register(sdev);
> +	if (rc) {
> +		printk(KERN_ERR "asic3_base: "
> +		       "Could not register asic3_mmc device\n");
> +		kfree(res);
> +		kfree(sdev);

		kfree(mmc_config);	?

> +		return rc;
> +	}
> +
> +	asic->mmc_dev = sdev;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(asic3_register_mmc);
> +
> +int asic3_unregister_mmc(struct device *dev)
> +{
> +	struct asic3_data *asic = dev->driver_data;
> +	platform_device_unregister(asic->mmc_dev);
> +	asic->mmc_dev = 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(asic3_unregister_mmc);
> +
>
> ...
>
> +		for (i = 0 ; i < ASIC3_NR_IRQS ; i++) {

Use
		for (i = 0; i < ASIC3_NR_IRQS; i++) {

> +		for (i = 0 ; i < ASIC3_NR_IRQS ; i++) {

Ditto (check all patches) (soon we'll have a script to do this) (hopefully)

> +			int irq = i + asic->irq_base;
> +			set_irq_flags(irq, 0);
> +			set_irq_handler (irq, NULL);
> +			set_irq_chip (irq, NULL);
> +			set_irq_chip_data(irq, NULL);
> +		}
> +
> +		set_irq_chained_handler(asic->irq_nr, NULL);
> +	}
> +
> +	if (asic->mmc_dev)
> +		asic3_unregister_mmc(&pdev->dev);
> +
> +	for (i = 0; i < ARRAY_SIZE(asic3_clocks); i++)
> +		clk_unregister(&asic3_clocks[i]);
> +	clk_unregister(&clk_g);
> +
> +	__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, SEL), 0);
> +	__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(INTR, IntMask), 0);
> +
> +	iounmap(asic->mapping);
> +
> +	kfree(asic);
> +
> +	return 0;
> +}
>
> ...
>
> +static int asic3_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct asic3_data *asic = platform_get_drvdata(pdev);
> +	suspend_cdex = __asic3_read_register(asic,
> +		_IPAQ_ASIC3_CLOCK_Base + _IPAQ_ASIC3_CLOCK_CDEX);
> +	/* The LEDs are still active during suspend */
> +	__asic3_write_register(asic,
> +		_IPAQ_ASIC3_CLOCK_Base + _IPAQ_ASIC3_CLOCK_CDEX,
> +		suspend_cdex & ASIC3_SUSPEND_CDEX_MASK);
> +	return 0;
> +}
> +
> +static int asic3_resume(struct platform_device *pdev)
> +{
> +	struct asic3_data *asic = platform_get_drvdata(pdev);
> +	unsigned short intmask;
> +
> +	__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(CLOCK, CDEX),
> +			       suspend_cdex);
> +
> +	if (asic->irq_nr != -1) {
> +		/* Toggle the interrupt mask to try to get ASIC3 to show
> +		 * the CPU an interrupt edge. For more details see the
> +		 * kernel-discuss thread around 13 June 2005 with the
> +		 * subject "asic3 suspend / resume". */
> +		intmask = __asic3_read_register(asic,
> +				IPAQ_ASIC3_OFFSET(INTR, IntMask));
> +		__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(INTR, IntMask),
> +				       intmask & ~ASIC3_INTMASK_GINTMASK);
> +		mdelay(1);
> +		__asic3_write_register(asic, IPAQ_ASIC3_OFFSET(INTR, IntMask),
> +				       intmask | ASIC3_INTMASK_GINTMASK);
> +	}
> +
> +	return 0;
> +}
> +
> +static struct platform_driver asic3_device_driver = {
> +	.driver		= {
> +		.name	= "asic3",
> +	},
> +	.probe		= asic3_probe,
> +	.remove		= asic3_remove,

Should .remove be __devexit_p()?

> +	.suspend	= asic3_suspend,
> +	.resume		= asic3_resume,
> +	.shutdown	= asic3_shutdown,
> +};

Does this driver have a Kconfig dependency upon CONFIG_PM?

If not, you should support CONFIG_PM=n.  The typical way of doing that is

#ifdef CONFIG_PM
static int asic3_suspend(struct platform_device *pdev, pm_message_t state)
{
	...
}

static int asic3_resume(struct platform_device *pdev)
{
	...
}
#else
#define asic3_suspend NULL
#define asic3_resume NULL
#endif

> +static int __init asic3_base_init(void)
> +{
> +	int retval = 0;
> +	retval = platform_driver_register(&asic3_device_driver);
> +	return retval;
> +}
> +
> +static void __exit asic3_base_exit(void)
> +{
> +	platform_driver_unregister(&asic3_device_driver);
> +}
> +
> +#ifdef MODULE
> +module_init(asic3_base_init);
> +#else	/* start early for dependencies */
> +subsys_initcall(asic3_base_init);
> +#endif

hm, I'd expect that subsys_initcall() from within a module will do the
right thing, in which case the ifdef isn't needed.

I certainly hope that's the case.

> +module_exit(asic3_base_exit);
>
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Phil Blundell <pb@handhelds.org>");
> +MODULE_DESCRIPTION("Core driver for HTC ASIC3");
> +MODULE_SUPPORTED_DEVICE("asic3");
> diff --git a/include/linux/soc/asic3_base.h b/include/linux/soc/asic3_base.h
> new file mode 100644
> index 0000000..f17acda
> --- /dev/null
> +++ b/include/linux/soc/asic3_base.h
> @@ -0,0 +1,100 @@
> +#include <asm/types.h>
> +
> +/* Private API - for ASIC3 devices internal use only */
> +#define HDR_IPAQ_ASIC3_ACTION(ACTION,action,fn,FN)                  \
> +u32  asic3_get_gpio_ ## action ## _ ## fn (struct device *dev);      \
> +void asic3_set_gpio_ ## action ## _ ## fn (struct device *dev, u32 bits, u32 val);
> +
> +#define HDR_IPAQ_ASIC3_FN(fn,FN)					\
> +	HDR_IPAQ_ASIC3_ACTION ( MASK,mask,fn,FN)			\
> +	HDR_IPAQ_ASIC3_ACTION ( DIR, dir, fn, FN)			\
> +	HDR_IPAQ_ASIC3_ACTION ( OUT, out, fn, FN)			\
> +	HDR_IPAQ_ASIC3_ACTION ( LEVELTRI, trigtype, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( RISING, rising, fn, FN)			\
> +	HDR_IPAQ_ASIC3_ACTION ( LEVEL, triglevel, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( SLEEP_MASK, sleepmask, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( SLEEP_OUT, sleepout, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( BATT_FAULT_OUT, battfaultout, fn, FN)	\
> +	HDR_IPAQ_ASIC3_ACTION ( INT_STATUS, intstatus, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( ALT_FUNCTION, alt_fn, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( SLEEP_CONF, sleepconf, fn, FN)		\
> +	HDR_IPAQ_ASIC3_ACTION ( STATUS, status, fn, FN) 

s/ (/(/g

> +struct tmio_mmc_hwconfig;
> +
> +struct asic3_platform_data
> +{

struct asic3_platform_data {

(review whole patchset)

> +	struct {
> +		u32 dir;
> +		u32 init;
> +		u32 sleep_mask;
> +		u32 sleep_out;
> +		u32 batt_fault_out;
> +		u32 sleep_conf;
> +		u32 alt_function;
> +	} gpio_a, gpio_b, gpio_c, gpio_d;
> +
> +	int irq_base;
> +	unsigned int bus_shift;
> +
> +	struct platform_device **child_platform_devs;
> +	int num_child_platform_devs;
> +
> +	struct tmio_mmc_hwconfig *tmio_mmc_hwconfig;
> +};
> diff --git a/include/linux/soc/tmio_mmc.h b/include/linux/soc/tmio_mmc.h
> new file mode 100644
> index 0000000..b8c407c
> --- /dev/null
> +++ b/include/linux/soc/tmio_mmc.h
> @@ -0,0 +1,17 @@
> +#include <linux/platform_device.h>
> +
> +#define MMC_CLOCK_DISABLED 0
> +#define MMC_CLOCK_ENABLED  1
> +
> +#define TMIO_WP_ALWAYS_RW ((void*)-1)
> +
> +struct tmio_mmc_hwconfig {
> +	void (*hwinit)(struct platform_device *sdev);
> +	void (*set_mmc_clock)(struct platform_device *sdev, int state);
> +
> +	/* NULL - use ASIC3 signal, 
> +	   TMIO_WP_ALWAYS_RW - assume always R/W (e.g. miniSD) 
> +	   otherwise - machine-specific handler */
> +	int (*mmc_get_ro)(struct platform_device *pdev);
> +	short address_shift;
> +};

