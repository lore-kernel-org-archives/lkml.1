Return-Path: <linux-kernel-owner+w=401wt.eu-S933641AbZLJKcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641AbZLJKcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 05:32:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933619AbZLJKcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 05:32:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33184 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbZLJKcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 05:32:01 -0500
Date: Thu, 10 Dec 2009 10:31:57 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 05/10] mxc: Add board support for the i.MX51
	babbage board
Message-ID: <20091210103157.GB6207@n2100.arm.linux.org.uk>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <0559d42bc9f32e30264fea6ca6fa679121f6a241.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0559d42bc9f32e30264fea6ca6fa679121f6a241.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 04:47:05AM +0200, Amit Kucheria wrote:
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <mach/common.h>
> +#include <mach/hardware.h>
> +#include <asm/irq.h>
> +#include <asm/setup.h>
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <asm/mach/time.h>
> +#include <mach/memory.h>

No one should be including mach/memory.h.  Please remove it and find a
better include to use.  (mach/memory.h exists to provide asm/memory.h
with the platform specific bits it needs, so maybe asm/memory.h is
what you want here).

> +#define SPIN_DELAY	1000000 /* in nanoseconds */

That's 1ms.

> +	/* Wait for lock */
> +	getnstimeofday(&nstimeofday);
> +	while (!(__raw_readl(pllbase + MXC_PLL_DP_CTL) & MXC_PLL_DP_CTL_LRF)) {
> +		getnstimeofday(&curtime);

I doubt getnstimeofday is particularly light-weight, so I'm not sure
what you're gaining over a loop based around udelay() and counting the
iterations.

> +		if (curtime.tv_nsec - nstimeofday.tv_nsec > SPIN_DELAY)
> +			panic("pll relock failed\n");

Is a panic really justified?

> diff --git a/arch/arm/mach-mx5/mm.c b/arch/arm/mach-mx5/mm.c
> new file mode 100644
> index 0000000..b258917
> --- /dev/null
> +++ b/arch/arm/mach-mx5/mm.c
> @@ -0,0 +1,86 @@
> +/*
> + * Copyright 2008-2009 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License.  You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + *
> + * Create static mapping between physical to virtual memory.
> + */
> +
> +#include <linux/mm.h>
> +#include <linux/init.h>
> +#include <mach/hardware.h>
> +#include <asm/pgtable.h>

I don't see anything needing asm/pgtable.h in here.
