Return-Path: <linux-kernel-owner+w=401wt.eu-S1764762AbXJRWIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764762AbXJRWIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757998AbXJRWHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:07:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752870AbXJRWHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:07:53 -0400
Date: Thu, 18 Oct 2007 15:05:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org, Paul Sokolovsky <pmiscml@gmail.com>,
       Ben Dooks <ben@trinity.fluff.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH -mm] ASIC3 driver
Message-Id: <20071018150544.6852d5c9.akpm@linux-foundation.org>
In-Reply-To: <20071018091239.GA11360@caravaggio>
References: <20071018091239.GA11360@caravaggio>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 11:12:41 +0200
Samuel Ortiz <sameo@openedhand.com> wrote:

> Hi,
> 
> This is a patch for the Compaq ASIC3 multi function chip, found in many PDAs
> (iPAQs, HTCs...).
> It is a simplified version of Paul Sokolovsky's first proposal [1]. With this
> code, it is basically a GPIO and IRQ expander. My plan is to add more
> features once this patch gets reviewed and accepted.
> 
> [1] http://lkml.org/lkml/2007/5/1/46
> 
> Signed-off-by: Samuel Ortiz <sameo@openedhand.com>

You're not a big fan of checkpatch, I see.

total: 76 errors, 69 warnings, 1054 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

> 
> Index: linux-2.6-htc/drivers/mfd/asic3.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-htc/drivers/mfd/asic3.c	2007-10-18 11:07:09.000000000 +0200
> @@ -0,0 +1,572 @@
> +/*
> + * driver/mfd/asic3.c
> + *
> + * Compaq ASIC3 support.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Copyright 2001 Compaq Computer Corporation.
> + * Copyright 2004-2005 Phil Blundell
> + * Copyright 2007 OpenedHand Ltd.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/version.h>
> +#include <linux/irq.h>

Please see the large comment at the top of linux/irq.h.  I believe this
driver will fial to compile on at least arm.

We really should fix this.

> +#include <linux/io.h>
> +#include <linux/spinlock.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/asic3.h>
> +
> +static inline void asic3_write_register(struct asic3 *asic,
> +				 unsigned int reg, u32 value)
> +{
> +	iowrite16(value, (unsigned long)asic->mapping +
> +		  (reg >> (2 - asic->bus_shift)));
> +}
> +
> +static inline u32 asic3_read_register(struct asic3 *asic,
> +			       unsigned int reg)
> +{
> +	return ioread16((unsigned long)asic->mapping +
> +			(reg >> (2 - asic->bus_shift)));
> +}

You'd get faster code if that "2 - asic->bus_shift" was cached in struct
asic3 rather than recalculated each time.

> +/* IRQs */
> +#define MAX_ASIC_ISR_LOOPS    20
> +#define ASIC3_GPIO_Base_INCR \
> +	(ASIC3_GPIO_B_Base - ASIC3_GPIO_A_Base)
> +
> +static inline void asic3_irq_flip_edge(struct asic3 *asic,
> +				       u32 base, int bit)
> +{
> +	u16 edge;
> +
> +	spin_lock(&asic->lock);
> +	edge = asic3_read_register(asic,
> +				   base + ASIC3_GPIO_EdgeTrigger);
> +	edge ^= bit;
> +	asic3_write_register(asic,
> +			     base + ASIC3_GPIO_EdgeTrigger, edge);
> +	spin_unlock(&asic->lock);
> +}

Too large to be inlined.  If it has only one callsite (it does) then the
compiler will inline it.  If it has more than one callsite then we didn't
want it inlined anyway.

> +static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
> +{
> +	int iter, i;
> +	struct asic3 *asic;
> +
> +	desc->chip->ack(irq);

hm, so this delves into the innards of the IRQ management.  Does it work OK
with and without CONFIG_GENERIC_HARDIRQS?  If not, some Kconfig work will
be needed.

> +	asic = desc->handler_data;
> +
> +	for (iter = 0 ; iter < MAX_ASIC_ISR_LOOPS; iter++) {
> +		u32 status;
> +		int bank;
> +
> +		spin_lock(&asic->lock);
> +		status = asic3_read_register(asic,
> +					     ASIC3_OFFSET(INTR, PIntStat));
> +		spin_unlock(&asic->lock);
> +
> +		/* Check all ten register bits */
> +		if ((status & 0x3ff) == 0)
> +			break;
> +
> +		/* Handle GPIO IRQs */
> +		for (bank = 0; bank < ASIC3_NUM_GPIO_BANKS; bank++) {
> +			if (status & (1 << bank)) {
> +				unsigned long base, istat;
> +
> +				base = ASIC3_GPIO_A_Base
> +				       + bank * ASIC3_GPIO_Base_INCR;
> +
> +				spin_lock(&asic->lock);
> +				istat = asic3_read_register(asic,
> +							    base +
> +							    ASIC3_GPIO_IntStatus);
> +				/* Clearing IntStatus */
> +				asic3_write_register(asic,
> +						     base +
> +						     ASIC3_GPIO_IntStatus, 0);
> +				spin_unlock(&asic->lock);
> +
> +				for (i = 0; i < ASIC3_GPIOS_PER_BANK; i++) {
> +					int bit = (1 << i);
> +					unsigned int irqnr;
> +					if (!(istat & bit))
> +						continue;

Most people prefer a blank line between end-of-definitions and start-of-code.

> +					irqnr = asic->irq_base +
> +						(ASIC3_GPIOS_PER_BANK * bank) + i;
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
> +		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
> +			/* They start at bit 4 and go up */
> +			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
> +				desc = irq_desc +  + i;
> +				desc->handle_irq(asic->irq_base + i,
> +						 desc);
> +			}
> +		}
> +	}
> +
> +	if (iter >= MAX_ASIC_ISR_LOOPS)
> +		printk(KERN_ERR "%s: interrupt processing overrun\n",
> +		       __FUNCTION__);
> +}
>
> ...
>
> +static void asic3_mask_gpio_irq(unsigned int irq)
> +{
> +	struct asic3 *asic = get_irq_chip_data(irq);
> +	u32 val, bank, index;
> +
> +	bank = asic3_irq_to_bank(asic, irq);
> +	index = asic3_irq_to_index(asic, irq);
> +
> +	spin_lock(&asic->lock);
> +	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
> +	val |= 1 << index;
> +	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
> +	spin_unlock(&asic->lock);
> +}
> +
> +static void asic3_mask_irq(unsigned int irq)
> +{
> +	struct asic3 *asic = get_irq_chip_data(irq);
> +	int regval;
> +
> +	spin_lock(&asic->lock);
> +	regval = asic3_read_register(asic,
> +				     ASIC3_INTR_Base +
> +				     ASIC3_INTR_IntMask);
> +
> +	regval &= ~(ASIC3_INTMASK_MASK0 <<
> +		    (irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
> +
> +	asic3_write_register(asic,
> +			     ASIC3_INTR_Base +
> +			     ASIC3_INTR_IntMask,
> +			     regval);
> +	spin_unlock(&asic->lock);
> +}
> +
> +static void asic3_unmask_gpio_irq(unsigned int irq)
> +{
> +	struct asic3 *asic = get_irq_chip_data(irq);
> +	u32 val, bank, index;
> +
> +	bank = asic3_irq_to_bank(asic, irq);
> +	index = asic3_irq_to_index(asic, irq);
> +
> +	spin_lock(&asic->lock);
> +	val = asic3_read_register(asic, bank + ASIC3_GPIO_Mask);
> +	val &= ~(1 << index);
> +	asic3_write_register(asic, bank + ASIC3_GPIO_Mask, val);
> +	spin_unlock(&asic->lock);
> +}

Am wondering about the handling of asic->lock.  As it is taken from hard
interrupts, it is a bug to take it with local interrupts enabled.  afacit
that is what this code is doing and is hence deadlockable.  But I didn't
look very hard.

Has this code been exercised with lockdep enabled?

> +static void asic3_unmask_irq(unsigned int irq)
> +{
> +	struct asic3 *asic = get_irq_chip_data(irq);
> +	int regval;
> +
> +	spin_lock(&asic->lock);
> +	regval = asic3_read_register(asic,
> +				     ASIC3_INTR_Base +
> +				     ASIC3_INTR_IntMask);
> +
> +	regval |= (ASIC3_INTMASK_MASK0 <<
> +		   (irq - (asic->irq_base + ASIC3_NUM_GPIOS)));
> +
> +	asic3_write_register(asic,
> +			     ASIC3_INTR_Base +
> +			     ASIC3_INTR_IntMask,
> +			     regval);
> +	spin_unlock(&asic->lock);
> +}
>
> ...
>
> +static inline void asic3_set_gpio(struct asic3 *asic, unsigned int base,
> +				  unsigned int function, u32 bits, u32 val)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&asic->lock, flags);
> +	val |= (asic3_read_register(asic, base + function) & ~bits);
> +
> +	asic3_write_register(asic, base + function, val);
> +	spin_unlock_irqrestore(&asic->lock, flags);
> +}

OK, there you go.  Maybe I was wrong about that lock.

This looks rather large for inlining too, btw.

> +#define asic3_get_gpio_a(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##function)
> +#define asic3_get_gpio_b(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##function)
> +#define asic3_get_gpio_c(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##function)
> +#define asic3_get_gpio_d(asic, function) asic3_get_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##function)
> +
> +#define asic3_set_gpio_a(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_A_Base, ASIC3_GPIO_##function, bits, val)
> +#define asic3_set_gpio_b(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_B_Base, ASIC3_GPIO_##function, bits, val)
> +#define asic3_set_gpio_c(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_C_Base, ASIC3_GPIO_##function, bits, val)
> +#define asic3_set_gpio_d(asic, function, bits, val) asic3_set_gpio(asic, ASIC3_GPIO_D_Base, ASIC3_GPIO_##function, bits, val)
> +
> +#define asic3_set_gpio_banks(asic, function, bits, pdata, field) \
> +	asic3_set_gpio_a((asic), function, (bits), (pdata)->gpio_a.field); \
> +	asic3_set_gpio_b((asic), function, (bits), (pdata)->gpio_b.field); \
> +	asic3_set_gpio_c((asic), function, (bits), (pdata)->gpio_c.field); \
> +	asic3_set_gpio_d((asic), function, (bits), (pdata)->gpio_d.field);

whee.

> +int asic3_gpio_get_value(struct asic3 *asic, unsigned gpio)
> +{
> +	u32 mask = ASIC3_GPIO_bit(gpio);
> +
> +	switch (gpio >> 4) {
> +	case ASIC3_GPIO_BANK_A:
> +		return asic3_get_gpio_a(asic, Status) & mask;
> +	case ASIC3_GPIO_BANK_B:
> +		return asic3_get_gpio_b(asic, Status) & mask;
> +	case ASIC3_GPIO_BANK_C:
> +		return asic3_get_gpio_c(asic, Status) & mask;
> +	case ASIC3_GPIO_BANK_D:
> +		return asic3_get_gpio_d(asic, Status) & mask;
> +	default:
> +		printk(KERN_ERR "%s: invalid GPIO value 0x%x",
> +		       __FUNCTION__, gpio);
> +		return -EINVAL;
> +	}
> +}
> +EXPORT_SYMBOL(asic3_gpio_get_value);
> ...
> +EXPORT_SYMBOL(asic3_gpio_set_value);

To what are these exported?

