Return-Path: <linux-kernel-owner+w=401wt.eu-S1755858Ab0A1NTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0A1NTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 08:19:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314Ab0A1NTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 08:19:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33172 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285Ab0A1NTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 08:19:12 -0500
Subject: Re: [PATCH 1/5] gic: prevent gic from crossing NR_IRQ
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: adharmap@codeaurora.org, linux-arm-kernel@lists.infradead.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Tony Lindgren <tony@atomide.com>,
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
In-Reply-To: <20100127224309.GD29665@n2100.arm.linux.org.uk>
References: <20100127224309.GD29665@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 28 Jan 2010 13:19:07 +0000
Message-Id: <1264684747.7064.61.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jan 2010 13:19:09.0023 (UTC) FILETIME=[796D86F0:01CAA01C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 22:43 +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 27, 2010 at 11:32:25AM -0800, adharmap@codeaurora.org wrote:
> > From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> >
> > The gic code tries to initialize interrupts beyond NR_IRQ. Prevent
> > code from doing that.
> 
> NAK.  This is completely the wrong approach.
> 
>         /*
>          * Find out how many interrupts are supported.
>          */
>         max_irq = readl(base + GIC_DIST_CTR) & 0x1f;
>         max_irq = (max_irq + 1) * 32;
> 
>         /*
>          * The GIC only supports up to 1020 interrupt sources.
>          * Limit this to either the architected maximum, or the
>          * platform maximum.
>          */
>         if (max_irq > max(1020, NR_IRQS))
>                 max_irq = max(1020, NR_IRQS);
> ...
>         for (i = irq_start; i < gic_data[gic_nr].irq_offset + max_irq; i++) {
> 
> This function is broken if irq_start != 0, and needs fixing - max_irq
> needs to be limited to the _minimum_ of 1020 or NR_IRQS - irq_start.

Actually I think in this case max_irq should be left to whatever the
hardware reads (but not more than 1020) since further down in this
function we configure the IRQs for the GIC and we also want to disable
those beyond NR_IRQS.

The "for" loop for set_irq_chip() should go to the minimum of max_irqs
and NR_IRQS.

-- 
Catalin

