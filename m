Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbZLDD7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbZLDD7i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 22:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755242AbZLDD7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 22:59:37 -0500
Received: from lo.gmane.org ([80.91.229.12]:56365 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbZLDD7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 22:59:36 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@collabora.co.uk>
Subject: Re: [RFC][PATCH 01/10] arm: mxc: New interrupt controller (TZIC)
 for i.MX5 family
Date: Thu, 3 Dec 2009 22:59:12 -0500
Message-ID: <20091203225912.6ea38585@mycelium.queued.net>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
	<e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
X-Newsreader: Claws Mail 3.7.3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some minor style comments/changes suggested below..


On Fri,  4 Dec 2009 04:47:01 +0200
Amit Kucheria <amit.kucheria@canonical.com> wrote:

> Freescale i.MX51 processor uses a different interrupt controller. Add the
> driver and fix the Makefile to account for it.
> 
[...]
> +/*
> + *****************************************
> + * TZIC Registers                        *
> + *****************************************
> + */
> +
> +#define TZIC_INTCNTL            0x0000	/* control register */
> +#define TZIC_INTTYPE            0x0004	/* Controller type register */
> +#define TZIC_IMPID              0x0008	/* Distributor Implementer Identification Register */
> +#define TZIC_PRIOMASK           0x000C	/* Priority Mask Reg */
> +#define TZIC_SYNCCTRL           0x0010	/* Synchronizer Control register */
> +#define TZIC_DSMINT             0x0014	/* DSM interrupt Holdoffregister */
> +#define TZIC_INTSEC0            0x0080	/* interrupt security register 0 */
> +#define TZIC_ENSET0             0x0100	/* Enable Set Register 0 */
> +#define TZIC_ENCLEAR0           0x0180	/* Enable Clear Register 0 */
> +#define TZIC_SRCSET0            0x0200	/* Source Set Register 0 */
> +#define TZIC_SRCCLAR0           0x0280	/* Source Clear Register 0 */
> +#define TZIC_PRIORITY0          0x0400	/* Priority Register 0 */
> +#define TZIC_PND0               0x0D00	/* Pending Register 0 */
> +#define TZIC_HIPND0             0x0D80	/* High Priority Pending Register */
> +#define TZIC_WAKEUP0            0x0E00	/* Wakeup Config Register */
> +#define TZIC_SWINT              0x0F00	/* Software Interrupt Rigger Register */
> +#define TZIC_ID0                0x0FD0	/* Indentification Register 0 */

s/Indent/Ident/ ?

> +
> +void __iomem *tzic_base;

This should be static, no?


> +
> +/*!
> + * Disable interrupt number "irq" in the TZIC
> + *
> + * @param  irq          interrupt source number
> + */
> +static void mxc_mask_irq(unsigned int irq)
> +{
> +	int index, off;

Presumably you'll want to use unsigned values here for bit
twiddling, to play it safe.

> +
> +	index = irq >> 5;
> +	off = irq & 0x1F;
> +	__raw_writel(1 << off, tzic_base + TZIC_ENCLEAR0 + (index << 2));
> +}
> +
> +/*!
> + * Enable interrupt number "irq" in the TZIC
> + *
> + * @param  irq          interrupt source number
> + */
> +static void mxc_unmask_irq(unsigned int irq)
> +{
> +	int index, off;

Again, unsigned?

> +
> +	index = irq >> 5;
> +	off = irq & 0x1F;
> +	__raw_writel(1 << off, tzic_base + TZIC_ENSET0 + (index << 2));
> +}
> +
> +static unsigned int wakeup_intr[4];
> +
> +/*
> + * Set interrupt number "irq" in the TZIC as a wake-up source.
> + *
> + * @param  irq          interrupt source number
> + * @param  enable       enable as wake-up if equal to non-zero
> + * 			disble as wake-up if equal to zero
> + *
> + * @return       This function returns 0 on success.
> + */
> +static int mxc_set_wake_irq(unsigned int irq, unsigned int enable)
> +{
> +	unsigned int index, off;
> +
> +	index = irq >> 5;
> +	off = irq & 0x1F;
> +
> +	if (index > 3)
> +		return -1;

I'd suggest -EINVAL here or something.  Not that most set_irq_wake()
callers actually check the results, but still.


> +
> +	if (enable)
> +		wakeup_intr[index] |= (1 << off);
> +	else
> +		wakeup_intr[index] &= ~(1 << off);
> +
> +	return 0;
> +}
> +
> +static struct irq_chip mxc_tzic_chip = {
> +	.name = "MXC_TZIC",
> +	.ack = mxc_mask_irq,
> +	.mask = mxc_mask_irq,
> +	.unmask = mxc_unmask_irq,
> +	.set_wake = mxc_set_wake_irq,
> +};
> +
> +/*
> + * This function initializes the TZIC hardware and disables all the
> + * interrupts. It registers the interrupt enable and disable functions
> + * to the kernel for each interrupt source.
> + */
> +void __init mxc_init_irq(void __iomem *irqbase)
> +{
> +	int i;
> +
> +	tzic_base = irqbase;
> +	/* put the TZIC into the reset value with
> +	 * all interrupts disabled
> +	 */
> +	i = __raw_readl(tzic_base + TZIC_INTCNTL);
> +
> +	__raw_writel(0x80010001, tzic_base + TZIC_INTCNTL);
> +	i = __raw_readl(tzic_base + TZIC_INTCNTL);
> +	__raw_writel(0x1f, tzic_base + TZIC_PRIOMASK);
> +	i = __raw_readl(tzic_base + TZIC_PRIOMASK);
> +	__raw_writel(0x02, tzic_base + TZIC_SYNCCTRL);
> +	i = __raw_readl(tzic_base + TZIC_SYNCCTRL);
> +	for (i = 0; i < 4; i++) {
> +		__raw_writel(0xFFFFFFFF, tzic_base + TZIC_INTSEC0 + i * 4);
> +	}
> +	/* disable all interrupts */
> +	for (i = 0; i < 4; i++) {
> +		__raw_writel(0xFFFFFFFF, tzic_base + TZIC_ENCLEAR0 + i * 4);
> +	}

Either the loops should be merged, or the { } should be dropped from each.


> +
> +	/* all IRQ no FIQ Warning :: No selection */
> +
> +	for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
> +		set_irq_chip(i, &mxc_tzic_chip);
> +		set_irq_handler(i, handle_level_irq);
> +		set_irq_flags(i, IRQF_VALID);
> +	}
> +
> +	printk(KERN_INFO "MXC IRQ initialized\n");
> +}
> +
> +/*
> + * enable wakeup interrupt
> + *
> + * @param is_idle		1 if called in idle loop (enset registers);
> + *				0 to be used when called from low power entry
> + * @return			0 if successful; non-zero otherwise
> + *
> + */
> +int tzic_enable_wake(int is_idle)
> +{
> +	unsigned int i, v;
> +
> +	__raw_writel(1, tzic_base + TZIC_DSMINT);
> +	if (unlikely(__raw_readl(tzic_base + TZIC_DSMINT) == 0))
> +		return -EAGAIN;
> +
> +	if (likely(is_idle)) {
> +		for (i = 0; i < 4; i++) {
> +			v = __raw_readl(tzic_base + TZIC_ENSET0 + i * 4);
> +			__raw_writel(v, tzic_base + TZIC_WAKEUP0 + i * 4);
> +		}
> +	} else {
> +		for (i = 0; i < 4; i++) {
> +			v = wakeup_intr[i];
> +			__raw_writel(v, tzic_base + TZIC_WAKEUP0 + i * 4);
> +		}
> +	}
> +	return 0;
> +}


