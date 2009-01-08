Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbZAHQkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbZAHQkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZAHQki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:40:38 -0500
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:39397 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbZAHQkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:40:37 -0500
Message-ID: <49662C7C.2040500@arcor.de>
Date: Thu, 08 Jan 2009 17:40:28 +0100
From: Thomas Dahlmann <dahlmann.thomas@arcor.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: amd5536udc interrupts bug
References: <49661E83.2070703@arcor.de>
In-Reply-To: <49661E83.2070703@arcor.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Vadim Lobanov wrote:
>>  It is my understanding that a handler for a shared interrupt can be
>>  invoked at any time after the corresponding request_irq() call is
>>  made, simply because some other device on the same interrupt may
>>  already be active. This leaves us with a very noticeable race
>>  condition, where udc_irq() can be invoked with uninitialized 'dev'
>>  data.
>
> Yes, your analysis appears correct.

Ah, right. Thanks for your analysis! Never ran into this condition as on the
Geode systems I had the IRQ is shared between UDC and UOC/OTG
(both on the CS5536 chip) and UOC never fires interrupts while UDC
driver is loaded as both drivers (UOC/OTG driver is not in the kernel yet)
register each other which makes sure that interrupts are enabled
after  udc_pci_probe().
 
>>  more complicated fix may be to try to shuffle all the code around to
>>  make sure that 'dev' is fully initialized before we request the irq,
>>  but I don't understand the code well enough (yet) to comfortably do
>>  this.
>
> Yeah, that's the proper fix.

I could provide a fix within the next weeks. Currently I move to another 
company and
have no hardware to test it.

Maybe you want to try this. It should work to place the register init 
from udc_probe()

/* udc csr registers base */
dev->csr = dev->virt_addr + UDC_CSR_ADDR;
/* dev registers base */
dev->regs = dev->virt_addr + UDC_DEVCFG_ADDR;
/* ep registers base */
dev->ep_regs = dev->virt_addr + UDC_EPREGS_ADDR;
/* fifo's base */
dev->rxfifo = (u32 __iomem *)(dev->virt_addr + UDC_RXFIFO_ADDR);
dev->txfifo = (u32 __iomem *)(dev->virt_addr + UDC_TXFIFO_ADDR);

just before request_irq(...) to allow the interrupt handler to read the 
interrupt status
registers.

Thomas



