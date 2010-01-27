Return-Path: <linux-kernel-owner+w=401wt.eu-S932183Ab0A0XRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab0A0XRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210Ab0A0XQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:16:58 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37376 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab0A0XQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:16:57 -0500
Date: Wed, 27 Jan 2010 23:09:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: adharmap@codeaurora.org
Cc: linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@elte.hu>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Yinghai Lu <yinghai@kernel.org>, Tony Lindgren <tony@atomide.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Kalle Valo <kalle.valo@iki.fi>, Jean Pihet <jpihet@mvista.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Colin Tuckley <colin.tuckley@arm.com>,
       Philby John <pjohn@in.mvista.com>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Alessandro Rubini <rubini@unipv.it>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [PATCH 3/5] gic: Add set_type callback
Message-ID: <20100127230958.GE29665@n2100.arm.linux.org.uk>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org> <1264620749-24527-4-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264620749-24527-4-git-send-email-adharmap@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:32:27AM -0800, adharmap@codeaurora.org wrote:
> +	if (irq > 1020)
> +		return -1;

*unprintable*.  Always use proper error codes.

> +
> +	/*
> +	* Two bits each, calc the register and bit, 16 per 32 bit register
> +	* accessible long word only
> +	* But the field is NxN 1xN and rising/falling
> +	*/
> +	register_index = (irq/16)<<2;
> +	bit_index = (irq & 0xF)<<1;
> +
> +	spin_lock(&irq_controller_lock);
> +	reg_value = readl(gic_dist_base(irq) + GIC_DIST_CONFIG +
> +						register_index);
> +	/*
> +	* keep the nxn and 1xn , mask the edge level
> +	* Edge is 1, level 0
> +	*/
> +	reg_value = (reg_value & ~(2<<bit_index));
> +	if (flow_type & (IRQ_TYPE_EDGE_RISING|IRQ_TYPE_EDGE_FALLING)) {
> +		reg_value |= (2<<bit_index);
> +		writel(reg_value, gic_dist_base(irq) + GIC_DIST_CONFIG
> +							+ register_index);
> +		__set_irq_handler_unlocked(irq, handle_edge_irq);
> +	}
> +
> +	if (flow_type & (IRQ_TYPE_LEVEL_HIGH|IRQ_TYPE_LEVEL_LOW)) {
> +		writel(reg_value, gic_dist_base(irq) + GIC_DIST_CONFIG
> +							+ register_index);
> +		__set_irq_handler_unlocked(irq, handle_level_irq);
> +	}

This needs to exclude the first 32 interrupts, where the interrupt
configuration is either read-only or banked between multiprocessor
CPUs.
