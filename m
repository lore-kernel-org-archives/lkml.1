Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYD2WuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYD2WuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYD2WuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:50:11 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:50909
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYD2WuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:50:10 -0400
Message-ID: <4817A5C6.7070704@qumranet.com>
Date: Wed, 30 Apr 2008 01:48:38 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Amit Shah <amit.shah@qumranet.com>
CC: Glauber Costa <gcosta@redhat.com>, kvm-devel@lists.sourceforge.net,
       virtualization@lists.linux-foundation.org, muli@il.ibm.com,
       BENAMI@il.ibm.com, chrisw@redhat.com, dor.laor@qumranet.com,
       allen.m.kay@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM x86: Handle hypercalls for assigned PCI devices
References: <1209465451-3758-1-git-send-email-amit.shah@qumranet.com> <1209465451-3758-3-git-send-email-amit.shah@qumranet.com> <48173440.304@redhat.com> <200804292128.52268.amit.shah@qumranet.com>
In-Reply-To: <200804292128.52268.amit.shah@qumranet.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah wrote:
>
>>> +	if (is_error_page(host_page)) {
>>> +		printk(KERN_INFO "%s: gfn %p not valid\n",
>>> +		       __func__, (void *)page_gfn);
>>> +		r = -1;
>>>       
>> r = -1 is not really informative. Better use some meaningful error.
>>     
>
> The error's going to the guest. The guest, as we know, has already done a 
> successful DMA allocation. Something went wrong in the hypercall, and we 
> don't know why (bad page). Any kind of error here isn't going to be 
> intelligible to the guest anyway. It's mostly a host thing if we ever hit 
> this.
>
>   

If the guest is not able to handle it, why bother returning an error?  
Better to kill it.

But in any case, -1 is not a good error number.

>>> +	if (find_pci_pt_dev(&vcpu->kvm->arch.pci_pt_dev_head,
>>> +			    &pci_pt_info, 0, KVM_PT_SOURCE_ASSIGN))
>>> +		r++; /* We have assigned the device */
>>> +
>>> +	kunmap(host_page);
>>>       
>> better use atomic mappings here.
>>     
>
> We can't use atomic mappings for guest pages. They can be swapped out.
>   

kmap()ed pages can't be swapped out either.  The atomic in kmap_atomic() 
only refers to the context in which the pages are used.  Atmoic kmaps 
are greatly preferable to the nonatomic ones.

-- 
Any sufficiently difficult bug is indistinguishable from a feature.

