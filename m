Return-Path: <linux-kernel-owner+w=401wt.eu-S1757266AbZLUUsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbZLUUsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZLUUsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:48:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:37488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbZLUUse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:48:34 -0500
Message-ID: <4B2FDEC8.9000700@kernel.org>
Date: Mon, 21 Dec 2009 12:47:04 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 0/12] pci: update pci bridge resources
References: <4B2BEC0E.3050909@kernel.org>	 <1261352672.26429.41.camel@dc7800.home>  <4B2ED29B.7060108@kernel.org> <1261370692.26429.78.camel@dc7800.home>
In-Reply-To: <1261370692.26429.78.camel@dc7800.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Sun, 2009-12-20 at 17:42 -0800, Yinghai Lu wrote:
>> Bjorn Helgaas wrote:
>>> On Fri, 2009-12-18 at 12:54 -0800, Yinghai Lu wrote:
>>>> this patche set is trying to update pci bridge BAR when that BAR is big enough.
>>>>
>>>> default it is disabled.
>>>>
>>>> could use pci=try=2 to enable it.
>>> I think you mean "when the BAR is *not* big enough."  And strictly
>>> speaking, I think you're concerned with the bridge *window*, which isn't
>>> actually a bridge BAR.
>> in PCI bridge to bridge spec 1.1, page 38, 3.2.5.1 still call them bridge "Base Address Registers"
>>
>> so should be fine we call them Bridge BAR, 
>>
>> and we still have device BAR...
> 
> PCI bridges have optional BARs, described as you point out in section
> 3.2.5.1.  These work the same as BARs on any other PCI device, and your
> patches aren't concerned with these.
> 
> Your patch series is primarily concerned with the bridge Base & Limit
> registers described in sections 3.2.5.6 (I/O), 3.2.5.8 (memory), and
> 3.2.5.9 (prefetchable memory).  These define the address ranges
> forwarded from one bridge interface to the other.  The spec doesn't have
> a nice term for these ranges, but they're often referred to as "windows"
> or "apertures" because they are the areas where you can "see through"
> the bridge to devices on the other side.

I have following patch. how to format the "bar reading" ?

[PATCH] pci: reject mmio range start from 0 on pci_bridge read

that is wrong.

exposed by that patch that doesn't shrink pci bridge res.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/probe.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/probe.c
===================================================================
--- linux-2.6.orig/drivers/pci/probe.c
+++ linux-2.6/drivers/pci/probe.c
@@ -316,13 +316,17 @@ void __devinit pci_read_bridge_bases(str
 		limit |= (io_limit_hi << 16);
 	}
 
-	if (base <= limit) {
+	if (base <= limit && base) {
 		res->flags = (io_base_lo & PCI_IO_RANGE_TYPE_MASK) | IORESOURCE_IO;
 		if (!res->start)
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+			 "  bridge window [io  %04lx - %04lx] bar reading\n",
+				 base, limit);
 	}
 
 	res = child->resource[1];
@@ -330,11 +334,15 @@ void __devinit pci_read_bridge_bases(str
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
 	base = (mem_base_lo & PCI_MEMORY_RANGE_MASK) << 16;
 	limit = (mem_limit_lo & PCI_MEMORY_RANGE_MASK) << 16;
-	if (base <= limit) {
+	if (base <= limit && base) {
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+			 "  bridge window [mem 0x%08lx - 0x%08lx] bar reading\n",
+					 base, limit + 0xfffff);
 	}
 
 	res = child->resource[2];
@@ -366,7 +374,7 @@ void __devinit pci_read_bridge_bases(str
 #endif
 		}
 	}
-	if (base <= limit) {
+	if (base <= limit && base) {
 		res->flags = (mem_base_lo & PCI_PREF_RANGE_TYPE_MASK) |
 					 IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		if (res->flags & PCI_PREF_RANGE_TYPE_64)
@@ -374,6 +382,10 @@ void __devinit pci_read_bridge_bases(str
 		res->start = base;
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
+	} else {
+		dev_printk(KERN_DEBUG, &dev->dev,
+			 "  bridge window [mem 0x%016lx - %016lx pref] bar reading\n",
+					 base, limit + 0xfffff);
 	}
 }
 
