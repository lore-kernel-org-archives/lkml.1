Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0COHec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 03:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0COHea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 03:34:30 -0400
Message-ID: <4B9DE2FF.4080909@redhat.com>
Date: Mon, 15 Mar 2010 09:34:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com> <20100304144255.GA26657@amt.cnet> <20100304155820.GA6019@amd.com> <20100311205803.GA18849@amt.cnet> <4B99EF09.1080608@redhat.com> <20100315062721.GA3654@amt.cnet>
In-Reply-To: <20100315062721.GA3654@amt.cnet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 08:27 AM, Marcelo Tosatti wrote:
>>
>>> You should disable out of sync shadow so that l1 guest writes to
>>> l1-nested-ptables always trap.
>>>        
>> Why?  The guest is under obligation to flush the tlb if it writes to
>> a page table, and we will resync on that tlb flush.
>>      
> The guests hypervisor will not flush the tlb with invlpg for updates of
> its NPT pagetables. It'll create a new ASID, and KVM will not trap
> that.
>    

We'll get a kvm_set_cr3() on the next vmrun.

>>> And in the trap case, you'd have to
>>> invalidate l2 shadow pagetable entries that used the (now obsolete)
>>> l1-nested-ptable entry. Does that happen automatically?
>>>        
>> What do you mean by 'l2 shadow ptable entries'?  There are the
>> guest's page tables (ordinary direct mapped, unless the guest's
>> guest is also running an npt-enabled hypervisor), and the host page
>> tables.  When the guest writes to each page table, we invalidate the
>> shadows.
>>      
> With 'l2 shadow ptable entries' i mean the shadow pagetables that
> translate GPA-L2 ->  HPA.
>    

kvm_mmu_pte_write() will invalidate those sptes and will also install 
new translations if possible.

Beautiful, isn't it?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

