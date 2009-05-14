Return-Path: <linux-kernel-owner+w=401wt.eu-S1761853AbZENGXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853AbZENGXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 02:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZENGXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 02:23:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59239 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbZENGXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 02:23:37 -0400
Message-ID: <4A0BB8B2.8060008@jp.fujitsu.com>
Date: Thu, 14 May 2009 15:22:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "David S. Miller" <davem@davemloft.net>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI MSI: Yet another fix for MSI-X with NIU cards, v2
References: <20090508131333.GV8112@parisc-linux.org> <4A0A5284.1000705@jp.fujitsu.com> <4A0A5556.9050209@jp.fujitsu.com> <20090513184349.GJ15360@parisc-linux.org>
In-Reply-To: <20090513184349.GJ15360@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, May 13, 2009 at 02:06:30PM +0900, Hidetoshi Seto wrote:
>>  		entry->mask_base = base;
>> -		entry->masked = readl(base + j * PCI_MSIX_ENTRY_SIZE +
>> -					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
>> -		msix_mask_irq(entry, 1);
>> +		entry->masked = 1;
>>  
> 
> Why do you add the setting of entry->masked here?

That was a temporal value for a window between later MSI-X and read/write.
But I agree that using global mask bit like your "Better fix" is better
idea.

>> +	/*
>> +	 * The states of Reserved bits[31:01] of Vector Control for MSI-X
>> +	 * Table Entries must be 0.  However, for potential future use,
>> +	 * software must preserve the value of these reserved bits.
>> +	 * Refer PCI spec 3.0, 6.8.2.9.
>> +	 *
>> +	 * Note that there are some device that refuses access to MSI-X
>> +	 * Table Entries before MSI-X is enabled.  Therefore we do it here. 
>> +	 */
> 
> I think you need to refer to PCIe 2.1 (or an ECN incorporated into it).
> Some of these bits are now used.

Wow, thank you for telling me that PCIe 2.1 is available now!
Anyway I recommend you to add a comment like this, to tell why we do
read/write, and why it is placed here.  It will be help for future
developers not to move this before enable of MSI-X.

>> +	list_for_each_entry(entry, &dev->msi_list, list) {
>> +		int vector = entry->msi_attrib.entry_nr;
>> +		entry->masked = readl(base + vector * PCI_MSIX_ENTRY_SIZE +
>> +					PCI_MSIX_ENTRY_VECTOR_CTRL_OFFSET);
>> +		/* Make sure it is masked */
>> +		msix_mask_irq(entry, 1);
>> +	}
>> +
>>  	return 0;
> 
> This looks to be the same as the replacement patch I sent earlier.

Yes.
I posted it because there were no response from you in last few days.


Thanks,
H.Seto

