Return-Path: <linux-kernel-owner+w=401wt.eu-S1757028AbZLDRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757028AbZLDRDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756546AbZLDRDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:03:19 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:26538 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbZLDRDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:03:18 -0500
Date: Fri, 4 Dec 2009 09:01:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com
Subject: Re: [RFC][PATCH 01/10] arm: mxc: New interrupt controller (TZIC)
 for i.MX5 family
Message-Id: <20091204090139.ff60024c.randy.dunlap@oracle.com>
In-Reply-To: <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
	<e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B1940BF.0113:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  4 Dec 2009 04:47:01 +0200 Amit Kucheria wrote:

> Freescale i.MX51 processor uses a different interrupt controller. Add the
> driver and fix the Makefile to account for it.
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/plat-mxc/Kconfig  |    4 +
>  arch/arm/plat-mxc/Makefile |    9 ++-
>  arch/arm/plat-mxc/tzic.c   |  180 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 192 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/plat-mxc/tzic.c
> 
> diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
> new file mode 100644
> index 0000000..3af8fc6
> --- /dev/null
> +++ b/arch/arm/plat-mxc/tzic.c
> @@ -0,0 +1,180 @@
> +/*
> + * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
...
> +
> +/*!
> + * Disable interrupt number "irq" in the TZIC
> + *
> + * @param  irq          interrupt source number
> + */

Hi,
What processes these function comments (if anything does)?


> +static void mxc_mask_irq(unsigned int irq)
> +{
> +	int index, off;
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
...
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
> -- 

thanks,
---
~Randy
