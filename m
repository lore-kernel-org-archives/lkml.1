Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab0BGMTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 07:19:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0BGMTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 07:19:04 -0500
Message-ID: <4B6EAF8B.9090707@redhat.com>
Date: Sun, 07 Feb 2010 14:18:19 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, David Woodhouse <dwmw2@infradead.org>,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com> <1264678682-30655-7-git-send-email-joerg.roedel@amd.com> <20100128222455.GA26274@amt.cnet>
In-Reply-To: <20100128222455.GA26274@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 12:24 AM, Marcelo Tosatti wrote:
> On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
>    
>> This patch changes the implementation of of
>> kvm_iommu_map_pages to map the pages with the host page size
>> into the io virtual address space.
>>
>> Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
>> ---
>>   virt/kvm/iommu.c |  106 ++++++++++++++++++++++++++++++++++++++++++-----------
>>   1 files changed, 84 insertions(+), 22 deletions(-)
>>
>> diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
>> index 65a5143..92a434d 100644
>> --- a/virt/kvm/iommu.c
>> +++ b/virt/kvm/iommu.c
>> @@ -32,12 +32,27 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
>>   static void kvm_iommu_put_pages(struct kvm *kvm,
>>   				gfn_t base_gfn, unsigned long npages);
>>
>> +static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
>> +			   gfn_t gfn, unsigned long size)
>> +{
>> +	gfn_t end_gfn;
>> +	pfn_t pfn;
>> +
>> +	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
>>      
> If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
> large iommu translation for it?
>    

How could it return a bad_page?  The whole thing is called for a valid slot.

-- 
error compiling committee.c: too many arguments to function

