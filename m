Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXEXVmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXEXVmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXEXVmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:42:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:54719 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXEXVmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:42:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>,
       linux-kernel@vger.kernel.org, tom.l.nguyen@intel.com,
       iss_storagedev@hp.com, jens.axboe@oracle.com,
       Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] msi: Fix the ordering of msix irqs.
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
	<20070524102702.bca37396.akpm@linux-foundation.org>
	<m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>
	<20070524205900.GC14083@beardog.cca.cpqcorp.net>
	<m1hcq2dj5m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070524141720.c02582db.akpm@linux-foundation.org>
Date: Thu, 24 May 2007 15:36:41 -0600
In-Reply-To: <20070524141720.c02582db.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 24 May 2007 14:17:20 -0700")
Message-ID: <m1d50peweu.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 24 May 2007 15:08:21 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Yours looks more complete then my test patch so:
>> 
>> From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:
>> 
>> Found what seems the problem with our vectors being listed backward. In
>> drivers/pci/msi.c we should be using list_add_tail rather than list_add to
>> preserve the ordering across various kernels. Please consider this for
>> inclusion.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
>> index 0e67723..d74975d 100644
>> --- a/drivers/pci/msi.c
>> +++ b/drivers/pci/msi.c
>> @@ -333,7 +333,7 @@ static int msi_capability_init(struct pci_dev *dev)
>>  			msi_mask_bits_reg(pos, is_64bit_address(control)),
>>  			maskbits);
>>  	}
>> -	list_add(&entry->list, &dev->msi_list);
>> +	list_add_tail(&entry->list, &dev->msi_list);
>>  
>>  	/* Configure MSI capability structure */
>>  	ret = arch_setup_msi_irqs(dev, 1, PCI_CAP_ID_MSI);
>> @@ -404,7 +404,7 @@ static int msix_capability_init(struct pci_dev *dev,
>>  		entry->dev = dev;
>>  		entry->mask_base = base;
>>  
>> -		list_add(&entry->list, &dev->msi_list);
>> +		list_add_tail(&entry->list, &dev->msi_list);
>>  	}
>>  
>>  	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
>
> Is this as fragile as I think it is?  What happens when close+open and
> rmmod+modprobe happen?  The list gets reordered then?

No this patch is not that fragile.  We destroy and recreate the list
each time we call pci_disable_msix, pci_enable_msix.  The order only
matters for the duration of pci_enable_msix.

Yes that silly struct msi_entries *entries vector passed into
pci_enable_msix is that fragile.  The right fix is to just kill that
vector and have the driver walk the list.  That is fundamentally more
robust.

> If this is important then perhaps a big-fat-comment which explains wtf is
> going on is needed?

When I get a moment I will remove the need to keep the list in any
sort of order.  That will permanently remove the need for
explanations. 

The truly problematic piece of code is this one below:
	i = 0;
	list_for_each_entry(entry, &dev->msi_list, list) {
		entries[i].vector = entry->irq;
		set_irq_msi(entry->irq, entry);
		i++;
	}

If we don't want to care about order we should really
should make it look something like:

	list_for_each_entry(entry, &dev->msi_list, list) {
        	for (i = 0; i < nvecs; i++) {
                	if (entries[i].vector == entry->entry_nr)
                        	entries[i].vector = entry->irq;
                }
		set_irq_msi(entry->irq, entry);
	}

But that is overkill for a trivial bug fix, and under kill
for a proper fix because the drivers still need to deal with
that complexity.

Letting the drivers walk dev->msi_list should be noticeably more
maintainable long term.  Especially when drivers start using a lot
of msi irqs.

Eric


