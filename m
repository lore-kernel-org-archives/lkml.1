Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYFGRSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYFGRSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbYFGRS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:18:27 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:46964 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbYFGRS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:18:26 -0400
Date: Sat, 7 Jun 2008 19:18:15 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: linux-mtd@lists.infradead.org, kernel@avr32linux.org,
       "Nicolas Ferre" <nicolas.ferre@atmel.com>,
       "Patrice VILCHEZ" <patrice.vilchez@atmel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] atmel_nand: Clean up and fix probe() error path
Message-ID: <20080607191815.3dc24360@siona.local>
In-Reply-To: <cd73a99e0806070908n5c9b6be4ned0386905555a1b7@mail.gmail.com>
References: <1212768298-13614-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1212768298-13614-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1212768298-13614-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1212768298-13614-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1212768298-13614-5-git-send-email-haavard.skinnemoen@atmel.com>
	<cd73a99e0806070908n5c9b6be4ned0386905555a1b7@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jun 2008 17:18:12.0325 (UTC) FILETIME=[76D9B950:01C8C8C2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Jun 2008 18:08:07 +0200
"Andrew Victor" <avictor.za@gmail.com> wrote:

> hi Haavard,
> 
> > This fixes several bugs in the atmel_nand_probe() error path, including
> > at least one memory leak.
> 
> There is an issue with the current at91_nand driver here.

Hmm, right.

> The driver currently ioremap()'s the ECC controller's registers, but
> on the AT91 the ECC controller is part of the System Peripherals and
> so it is already mapped at startup.
> I don't think it can/should be remapped twice.

I don't see why that's really a problem -- it may get a different
virtual address and possibly waste a TLB entry, but it should work.

> The AT91 patch (on maxim.org.za) current does:
>     regs = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>          ....
>     host->ecc = (void __force __iomem *) (AT91_VA_BASE_SYS - AT91_BASE_SYS);
>     host->ecc += regs->start;
> instead of the ioremap().  But this is not portable to the AVR32.

How about sticking a "void __iomem *ecc_regs" field in struct
atmel_nand_data and allow platforms to specify a pre-mapped pointer?
Then the driver can do

	if (host->board->ecc_regs)
		host->ecc = host->board->ecc_regs;
	else if (regs)
		host->ecc = ioremap(regs->start, regs->end - regs->start + 1);

	if (hard_ecc && !host->ecc)
		printk("Hardware ECC not available\n");

Right? I think we use a similar trick in the atmel_serial driver too.

Haavard
