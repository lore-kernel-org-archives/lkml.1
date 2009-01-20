Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbZATTyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbZATTyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 14:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZATTy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 14:54:29 -0500
Received: from rtr.ca ([76.10.145.34]:46992 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbZATTy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 14:54:28 -0500
Message-ID: <49762BF1.2050101@rtr.ca>
Date: Tue, 20 Jan 2009 14:54:25 -0500
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
References: <4975F5C1.8090107@rtr.ca>	 <da824cf30901200944x545431b2va0233abc14e81f9b@mail.gmail.com>	 <497614F5.6000301@rtr.ca> <da824cf30901201051v66ae13c4i3476097ee31db281@mail.gmail.com>
In-Reply-To: <da824cf30901201051v66ae13c4i3476097ee31db281@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Tue, Jan 20, 2009 at 10:16 AM, Mark Lord <liml@rtr.ca> wrote:
> ...
>>> I don't think that's necessary if free_irq() or disable_irq() are called.
>>> However, I'm not seeing those get called either.
> ...
>> The linux/Documentation/PCI/MSI-HOWTO.txt information is rather explicit
>> about it, and the pci core code does seem to expect it.
> 
> It looks like pci_disable_msi() requires free_irq() to be called first in order
> to guarantee the vectors are no longer in use. But I didn't see any code to
> enforce that. Which code was "expecting free_irq()" to be called?
..

The devres subsystem automatically frees resources on device removal,
including calling free_irq() as necessary for any interrupt handler
that was registered with devm_request_irq(), as done in libata.
See linux/drivers/base/devres.c for the actual call to free_irq().

But it doesn't handle pci_disable_msi() in there.

Thus this code from latest sata_mv:

+static void mv_pci_remove_one(struct pci_dev *pdev)
+{
+       struct device *dev = &pdev->dev;
+       struct ata_host *host = dev_get_drvdata(dev);
+       struct mv_host_priv *hpriv = host->private_data;
+
+       if (hpriv->hp_flags & MV_HP_FLAG_MSI) {
+               devm_free_irq(host->dev, pdev->irq, host);
+               pci_disable_msi(pdev);
+       }
+       ata_pci_remove_one(pdev);
+}

I believe that other MSI users might want something similar,
or perhaps Tejun could extend devres to include a pair
of suitable functions, devm_enable_msi() and  devm_disable_msi().
Then it would be just automatic for drivers, without any fuss.

Cheers
