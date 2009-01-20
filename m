Return-Path: <linux-kernel-owner+w=401wt.eu-S1760575AbZATSQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760575AbZATSQg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:16:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753359AbZATSQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:16:25 -0500
Received: from rtr.ca ([76.10.145.34]:36254 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbZATSQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:16:24 -0500
Message-ID: <497614F5.6000301@rtr.ca>
Date: Tue, 20 Jan 2009 13:16:21 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Subject: Re: libata, devm_*, and MSI ?
References: <4975F5C1.8090107@rtr.ca> <da824cf30901200944x545431b2va0233abc14e81f9b@mail.gmail.com>
In-Reply-To: <da824cf30901200944x545431b2va0233abc14e81f9b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Tue, Jan 20, 2009 at 8:03 AM, Mark Lord <liml@rtr.ca> wrote:
..
>> For starters, the MSI HOW-TO suggests that drivers must be careful
>> to invoke pci_disable_msi() on module unload, but I don't see that
>> happening anywhere in libata.
> 
> I don't think that's necessary if free_irq() or disable_irq() are called.
> However, I'm not seeing those get called either.
..

The linux/Documentation/PCI/MSI-HOWTO.txt information is rather explicit
about it, and the pci core code does seem to expect it.

> However, I'm not seeing those get called either.
..

The devres code takes care of the free_irq() normally,
but does not do the pci_disable_msi(), because it doesn't
know enough about the device to do it right now.

..
>> Eg. from ahci.c, we have this:
>>
>>       if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
>>               pci_intx(pdev, 1);
>>
>> Which agrees with the existing code in sata_mv:
>>
>>       if (msi && hi jiqi(pdev))
>>               pci_intx(pdev, 1);
..
>>       if (pci_enable_msi(pdev) == 0)
>>               pci_intx(pdev, 0);
>>
>> Either that one is wrong, or pci_intx() is unnecessary in all cases.
..

Those calls to pci_intx() are definitely redundant,
as the pci core already does that for us on the relevant paths.

>> Perhaps somebody from the PCI side of things might enlighten us all.
> 
>     http://lists.linuxcoding.com/kernel/2005-q3/msg11296.html
> 
> Shows when pci_intx() was added. linux-pci was NOT cc'd on that email.
> And no one asked for Documentation/ update. C'est la vie.
..

I still think the documentation matches the code in the pci core, though.

Patch for sata_mv coming shortly.

Cheers
