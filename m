Return-Path: <linux-kernel-owner+w=401wt.eu-S1756430Ab0A0Wua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab0A0Wua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 17:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415Ab0A0Wu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 17:50:29 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58128 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385Ab0A0Wu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 17:50:28 -0500
Date: Wed, 27 Jan 2010 22:43:09 +0000
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
Subject: Re: [PATCH 1/5] gic: prevent gic from crossing NR_IRQ
Message-ID: <20100127224309.GD29665@n2100.arm.linux.org.uk>
References: <1264620749-24527-1-git-send-email-adharmap@codeaurora.org> <1264620749-24527-2-git-send-email-adharmap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264620749-24527-2-git-send-email-adharmap@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 11:32:25AM -0800, adharmap@codeaurora.org wrote:
> From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> 
> The gic code tries to initialize interrupts beyond NR_IRQ. Prevent
> code from doing that.

NAK.  This is completely the wrong approach.

        /*
         * Find out how many interrupts are supported.
         */
        max_irq = readl(base + GIC_DIST_CTR) & 0x1f;
        max_irq = (max_irq + 1) * 32;

        /*
         * The GIC only supports up to 1020 interrupt sources.
         * Limit this to either the architected maximum, or the
         * platform maximum.
         */
        if (max_irq > max(1020, NR_IRQS))
                max_irq = max(1020, NR_IRQS);
...
        for (i = irq_start; i < gic_data[gic_nr].irq_offset + max_irq; i++) {

This function is broken if irq_start != 0, and needs fixing - max_irq
needs to be limited to the _minimum_ of 1020 or NR_IRQS - irq_start.
