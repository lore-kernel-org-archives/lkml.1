Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbYLWQdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbYLWQdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbYLWQdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:33:04 -0500
Received: from mail.gmx.net ([213.165.64.20]:47099 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751069AbYLWQdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:33:02 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19m3M4tFrpmrGUGVaylAaVizREGSVMbA7Ob6R3jtG
	bybmv3ps0WDW5A
Date: Tue, 23 Dec 2008 17:33:11 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/4 v4] i.MX31: Image Processing Unit DMA and IRQ drivers
In-Reply-To: <20081223160942.GJ1614@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0812231727460.5188@axis700.grange>
References: <20081218225834.GJ20756@pengutronix.de>
 <Pine.LNX.4.64.0812221240210.5241@axis700.grange> <20081222183753.GD1614@pengutronix.de>
 <Pine.LNX.4.64.0812221942480.7796@axis700.grange> <20081223105006.GE1614@pengutronix.de>
 <Pine.LNX.4.64.0812231157180.5188@axis700.grange> <20081223125015.GG1614@pengutronix.de>
 <Pine.LNX.4.64.0812231359030.5188@axis700.grange> <20081223140320.GH1614@pengutronix.de>
 <Pine.LNX.4.64.0812231529080.5188@axis700.grange> <20081223160942.GJ1614@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2008, Sascha Hauer wrote:

> You're still not getting it. Consider an implementation of the chained
> interrupt handler like this:
> 
> static struct ipu_irq_bank irq_bank_fn[IPU_IRQ_NR_FN_BANKS] = {
>         {
>                 .nr_irqs        = 1,	/* IDMAC EOF and NF irq */
>         }, {
>                 .nr_irqs        = 24,	/* misc interrupts the IPU is not
> 					 * interested in, but clients drivers
> 					 * may be.
> 					 */
>         },
> };
> 
> static struct ipu_irq_bank irq_bank_err[IPU_IRQ_NR_ERR_BANKS] = {
>         /* 2 groups of error interrupts */
>         {
>                 .nr_irqs        = 1,	/* IDMAC channel error irq */
>         }, {
>                 .nr_irqs        = 17,	/* misc interrupts the IPU is not
>                                          * interested in, but clients drivers
>                                          * may be.
>                                          */
>         },
> };
> 
> /* Chained IRQ handler for IPU error interrupt */
> static void ipu_irq_err(unsigned int irq, struct irq_desc *desc)
> {
>         struct ipu *ipu = get_irq_data(irq);
>         u32 status;
>         int i, line;
> 
> 	/* These interrupts are handled exclusively by the IPU code */
> 	if (ipu_read_reg(ipu, IPU_INT_STAT_4))
> 		generic_handle_irq(IPU_IRQ);
> 
> 	status = ipu_read_reg(ipu, IPU_INT_STAT_5);
>         while ((line = ffs(status))) {
>                 status &= ~(1UL << (line - 1));
>                 generic_handle_irq(irq_bank_err[i].irq_base + line - 1);
>         }
> }
> 
> /* Chained IRQ handler for IPU function interrupt */
> static void ipu_irq_fn(unsigned int irq, struct irq_desc *desc)
> {
>         struct ipu *ipu = get_irq_data(irq);
>         u32 status;
>         int i, line;
> 
>         /* These interrupts are handled exclusively by the IPU code */
>         if (ipu_read_reg(ipu, IPU_INT_STAT_1) || ipu_read_reg(ipu, IPU_INT_STAT_2))
>                 generic_handle_irq(IPU_ERR_IRQ);
> 
>         status = ipu_read_reg(ipu, IPU_INT_STAT_3);
>         while ((line = ffs(status))) {
>                 status &= ~(1UL << (line - 1));
>                 generic_handle_irq(irq_bank_err[i].irq_base + line - 1);
>         }
> }
> 
> 
> and in ipu_idmac.c:
> 
> request_irq(IPU_ERR_IRQ, &ipu_err_handler);
> request_irq(IPU_IRQ, &ipu_irq);

These all are just slightly different variations - with this one you'd 
have to scan dma channels in your dma irq handler, which I currently don't 
have to do.

> That said I'm not sure whether we need a chained interrupt handler at all.
> Looking at the remaining interrupts it seems that for example the
> CSI_EOF (IPU_INT_STAT3 bit 5) interrupt is redundant to the corresponding
> channels interrupt. In the camera driver you already realized that it's
> the dma end event you're interested in, not the CSI_EOF event. Not sure
> if that holds for the other interrupts though.

I think the version with a lookup table is optimal - it uses standard 
mechanisms for irq handling and doesn't waste RAM. The disadvantage - 
every addition will need driver modification...

But ok, this is taking way too long. Just tell me which way you'd like to 
have it and I'll do it.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
