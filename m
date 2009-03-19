Return-Path: <linux-kernel-owner+w=401wt.eu-S1759265AbZCSGc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265AbZCSGc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZCSGct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:32:49 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:46601 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754857AbZCSGcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:32:48 -0400
Message-ID: <49C1E70C.2050404@snapgear.com>
Date: Thu, 19 Mar 2009 16:32:44 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven King <sfking@fdwdc.com>
CC: uClinux development list <uclinux-dev@uclinux.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 01/14] Coldfire generic GPIO (m68knommu)
References: <200903111455.42856.sfking@fdwdc.com>
In-Reply-To: <200903111455.42856.sfking@fdwdc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Steven King wrote:
> The basic Coldfire generic gpio implementation.
> 
> Signed-off-by: Steven King <sfking@fdwdc.com>
> 
> diff --git a/arch/m68knommu/platform/coldfire/gpio.c 
> b/arch/m68knommu/platform/coldfire/gpio.c
> new file mode 100644
> index 0000000..c2504b9
> --- /dev/null
> +++ b/arch/m68knommu/platform/coldfire/gpio.c
> @@ -0,0 +1,1969 @@
> +/*
> + * Coldfire generic GPIO support.
> + *
> + * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/sysdev.h>
> +
> +#include <asm/gpio.h>
> +#include <asm/pinmux.h>
> +
> +struct mcf_gpio_chip {
> +	struct gpio_chip gpio_chip;
> +	void __iomem *pddr;
> +	void __iomem *podr;
> +	void __iomem *ppdr;
> +	void __iomem *setr;
> +	void __iomem *clrr;
> +	const u8 *gpio_to_pinmux;
> +};
> +
> +#define MCF_CHIP(chip) container_of(chip, struct mcf_gpio_chip, gpio_chip)
> +
> +static int mcf_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
> +{
> +	unsigned long flags;
> +	MCFGPIO_PORTTYPE dir;
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	local_irq_save(flags);
> +	dir = mcfgpio_read(mcf_chip->pddr);
> +	dir &= ~mcfgpio_bit(chip->base + offset);
> +	mcfgpio_write(dir, mcf_chip->pddr);
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> +
> +static int mcf_gpio_get_value(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	return mcfgpio_read(mcf_chip->ppdr) & mcfgpio_bit(chip->base + offset);
> +}
> +
> +static int mcf_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
> +		int value)
> +{
> +	unsigned long flags;
> +	MCFGPIO_PORTTYPE data;
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	local_irq_save(flags);
> +	/* write the value to the output latch */
> +	data = mcfgpio_read(mcf_chip->podr);
> +	if (value)
> +		data |= mcfgpio_bit(chip->base + offset);
> +	else
> +		data &= ~mcfgpio_bit(chip->base + offset);
> +	mcfgpio_write(data, mcf_chip->podr);
> +
> +	/* now set the direction to output */
> +	data = mcfgpio_read(mcf_chip->pddr);
> +	data |= mcfgpio_bit(chip->base + offset);
> +	mcfgpio_write(data, mcf_chip->pddr);
> +	local_irq_restore(flags);
> +
> +	return 0;
> +}
> +
> +static void mcf_gpio_set_value(struct gpio_chip *chip, unsigned offset,
> +		int value)
> +{
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	unsigned long flags;
> +	MCFGPIO_PORTTYPE data;
> +
> +	local_irq_save(flags);
> +	data = mcfgpio_read(mcf_chip->podr);
> +	if (value)
> +		data |= mcfgpio_bit(chip->base + offset);
> +	else
> +		data &= ~mcfgpio_bit(chip->base + offset);
> +	mcfgpio_write(data, mcf_chip->podr);
> +	local_irq_restore(flags);
> +}
> +
> +#if defined(CONFIG_M520x) || defined(CONFIG_M523x) || \
> +      defined(CONFIG_M527x) || defined(CONFIG_M528x) || defined(CONFIG_M532x)
> +static void mcf_gpio_set_value_fast(struct gpio_chip *chip, unsigned offset,
> +		int value)
> +{
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	if (value)
> +		mcfgpio_write(mcfgpio_bit(chip->base + offset), mcf_chip->setr);
> +	else
> +		mcfgpio_write(~mcfgpio_bit(chip->base + offset), mcf_chip->clrr);
> +}
> +#endif
> +static int mcf_gpio_request(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	return mcf_chip->gpio_to_pinmux ?
> +		mcf_pinmux_request(mcf_chip->gpio_to_pinmux[offset], 0) : 0;
> +}
> +
> +static void mcf_gpio_free(struct gpio_chip *chip, unsigned offset)
> +{
> +	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
> +
> +	mcf_gpio_direction_input(chip, offset);
> +
> +	if (mcf_chip->gpio_to_pinmux)
> +		mcf_pinmux_release(mcf_chip->gpio_to_pinmux[offset], 0);
> +}
> +
> +static struct mcf_gpio_chip mcf_gpio_chips[] = {
> +#if defined(CONFIG_M5206) || defined(CONFIG_M5206e)

I would rather see this table's contents in the per-platform
setup code (so under ~/arch/m68knommu/platform/m5206, etc).
Associated with each family members specific code. I would have a
gpio.c in each platform directory just for this.

Keep the common code above in coldfire/gpio.c (the support functions
could obviously no longer be static). When new family members
are created/added this common coldfire/gpio.c won't need to be
touched.

Otherwise I don't see any specific problems with it.

Regards
Greg





> +	{
> +		.gpio_chip			= {
> +			.label			= "PP",
> +			.request		= mcf_gpio_request,
> +			.free			= mcf_gpio_free,
> +			.direction_input	= mcf_gpio_direction_input,
> +			.direction_output	= mcf_gpio_direction_output,
> +			.get			= mcf_gpio_get_value,
> +			.set			= mcf_gpio_set_value,
> +			.ngpio			= 8,
> +		},
> +		.pddr				= MCFSIM_PADDR,
> +		.podr				= MCFSIM_PADAT,
> +		.ppdr				= MCFSIM_PADAT,
> +	},
> +#elif defined(CONFIG_M520x)
...
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
