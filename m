Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbZEMEHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbZEMEHI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 00:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbZEMEG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 00:06:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49787 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZEMEGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 00:06:55 -0400
Message-ID: <4A0A472A.8090301@jp.fujitsu.com>
Date: Wed, 13 May 2009 13:06:02 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: michael@ellerman.id.au
CC: Matthew Wilcox <matthew@wil.cx>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix MSI-X with NIU cards
References: <20090508131333.GV8112@parisc-linux.org> <1242004911.7767.26.camel@concordia>
In-Reply-To: <1242004911.7767.26.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman wrote:
> On Fri, 2009-05-08 at 07:13 -0600, Matthew Wilcox wrote:
>> The NIU device refuses to allow accesses to MSI-X registers before MSI-X
>> is enabled.  This patch fixes the problem by moving the read of the mask
>> register to after MSI-X is enabled.
>>
>> Reported-by: David S. Miller <davem@davemloft.net>
>> Tested-by: David S. Miller <davem@davemloft.net>
>> Reviewed-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>>
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index 6f2e629..3627732 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -455,8 +455,6 @@ static int msix_capability_init(struct pci_dev *dev,
>>  		entry->msi_attrib.default_irq = dev->irq;
>>  		entry->msi_attrib.pos = pos;
>>  		entry->mask_base = base;
>> -		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
>> -					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
>>  		msix_mask_irq(entry, 1);
> 
> 158 static void msix_mask_irq(struct msi_desc *desc, u32 flag)                  
> 159 {
> 160         u32 mask_bits = desc->masked;
> ...
> 165         writel(mask_bits, desc->mask_base + offset);
> 
> 
> So I guess this device is just silently ignoring that write?

I guess that write can be ignored while reads are not.

It seems that this issue was introduced by Matthew's commit:
commit f2440d9acbe866b917b16cc0f927366341ce9215
<quote>
@@ -435,11 +432,12 @@ static int msix_capability_init(struct pci_dev *dev,
                entry->msi_attrib.is_msix = 1;
                entry->msi_attrib.is_64 = 1;
                entry->msi_attrib.entry_nr = j;
-               entry->msi_attrib.maskbit = 1;
-               entry->msi_attrib.masked = 1;
                entry->msi_attrib.default_irq = dev->irq;
                entry->msi_attrib.pos = pos;
                entry->mask_base = base;
+               entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
+                                       PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
+               msix_mask_irq(entry, 1);

                list_add_tail(&entry->list, &dev->msi_list);
        }
</quote>

I'm not sure why Matthew changed it to read/write...

> And aren't we violating the spec by writing 0x1 into the device there
> (assuming desc->masked is 0x0 from the kzalloc), ie. we're supposed to
> read and write back the reserved bits unchanged. (§ 6.8.2.9?)

Spec says:
 "This bit's state after reset is 1 (entry is masked).
  This bit is read/write."

>> @@ -493,6 +491,12 @@ static int msix_capability_init(struct pci_dev *dev,
>>  	msix_set_enable(dev, 1);
>>  	dev->msix_enabled = 1;
> 
> Are we safe if we take an interrupt here?

If reset was properly done on the device, we will be safe since entries are
masked.  Otherwise, ... I'm not sure.

>> +	list_for_each_entry(entry, &dev->msi_list, list) {
>> +		int vector = entry->msi_attrib.entry_nr;
>> +		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
>> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
>> +	}
>> +
>>  	return 0;
>>  }

I think we can remove read/write here because it was same as before the
Matthew's change above.

If we really need read/write here, then I believe Matthew can provide
an incremental patch for that.


Thanks,
H.Seto

