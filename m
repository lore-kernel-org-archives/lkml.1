Return-Path: <linux-kernel-owner+w=401wt.eu-S1759325AbXJOWSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbXJOWSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbXJOWSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:18:00 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39684 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXJOWR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:17:59 -0400
Message-ID: <4713E713.9060702@pobox.com>
Date: Mon, 15 Oct 2007 18:17:55 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Ayaz Abdulla <aabdulla@nvidia.com>, nedev <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MSI interrupts and disable_irq
References: <46FC15A9.1070803@nvidia.com> <46FDBCB4.9090802@pobox.com> <4710901F.8010206@colorfullife.com>
In-Reply-To: <4710901F.8010206@colorfullife.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Jeff Garzik wrote:
>>
>> I think the scenario you outline is an illustration of the approach's 
>> fragility:  disable_irq() is a heavy hammer that originated with INTx, 
>> and it relies on a chip-specific disable method (kernel/irq/manage.c) 
>> that practically guarantees behavior will vary across MSI/INTx/etc.
>>
> I checked the code: IRQ_DISABLE is implemented in software, i.e. 
> handle_level_irq() only calls handle_IRQ_event() [and then the nic irq 
> handler] if IRQ_DISABLE is not set.
> OTHO: The last trace looks as if nv_do_nic_poll() is interrupted by an irq.
> 
> Perhaps something corrupts dev->irq? The irq is requested with
>    request_irq(np->pci_dev->irq, handler, IRQF_SHARED, dev->name, dev)
> and disabled with
>    disable_irq_lockdep(dev->irq);
> 
> Someone around with a MSI capable board? The forcedeth driver does
>    dev->irq = pci_dev->irq
> in nv_probe(), especially before pci_enable_msi().
> Does pci_enable_msi() change pci_dev->irq? Then we would disable the 
> wrong interrupt....

Remember, fundamentally MSI-X is a one-to-many relationship, when you 
consider a single PCI device might have multiple vectors.

	Jeff



