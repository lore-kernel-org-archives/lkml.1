Return-Path: <linux-kernel-owner+w=401wt.eu-S1756118AbZC2NEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbZC2NEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 09:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZC2ND5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 09:03:57 -0400
Received: from 8bytes.org ([88.198.83.132]:42392 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447AbZC2ND4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 09:03:56 -0400
Date: Sun, 29 Mar 2009 15:03:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] kvm mmu: implement necessary data structures for
	second huge page accounting
Message-ID: <20090329130353.GK31080@8bytes.org>
References: <1238164319-16092-1-git-send-email-joerg.roedel@amd.com> <1238164319-16092-5-git-send-email-joerg.roedel@amd.com> <49CF5F68.1020507@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CF5F68.1020507@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 02:45:44PM +0300, Avi Kivity wrote:
> Joerg Roedel wrote:
>> This patch adds the necessary data structures to take care of write
>> protections in place within a second huge page sized page.
>>
>>   struct kvm_vcpu_arch {
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 9936b45..7d4162d 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -390,6 +390,15 @@ static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
>>  	return &slot->lpage_info[idx].write_count;
>>  }
>>  +static int *slot_hugepage_idx(gfn_t gfn, struct kvm_memory_slot 
>> *slot)
>> +{
>> +	unsigned long idx;
>> +
>> +	idx = (gfn / KVM_PAGES_PER_1G_PAGE) -
>> +	      (slot->base_gfn / KVM_PAGES_PER_1G_PAGE);
>> +	return &slot->hpage_info[idx].write_count;
>> +}
>>   
>
> A page level argument would remove the need for this duplication, as  
> well as all the constants.
>
>>  +static int has_wrprotected_largepage(struct kvm *kvm, gfn_t gfn)
>> +{
>> +	struct kvm_memory_slot *slot;
>> +	int *hugepage_idx;
>> +
>> +	gfn = unalias_gfn(kvm, gfn);
>> +	slot = gfn_to_memslot_unaliased(kvm, gfn);
>> +	if (slot) {
>> +		hugepage_idx = slot_hugepage_idx(gfn, slot);
>>   
>
> slot_largepage_idx() here?
>
> I don't think we ever write protect large pages, so why is this needed?

For 2mb pages we need to check if there is a write-protected 4k page in it
before we map a 2mb page for writing. If there is any write-protected 4k
page in a 2mb area this 2mb page is considered write-protected. These
'write-protected' 2mb pages are accounted in the account_shadow()
function. This information is taken into account when we decide if we
can map a guest 1gb page as a 1gb page on the host too.

	Joerg
