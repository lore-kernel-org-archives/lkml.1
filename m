Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYKYOE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYKYOE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:04:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYKYOEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:04:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51903 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255AbYKYOEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:04:46 -0500
Message-ID: <492C05F4.4090006@redhat.com>
Date: Tue, 25 Nov 2008 16:04:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] always assign userspace_addr
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws> <20081119184357.GB25917@poweredge.glommer> <49246014.5000001@codemonkey.ws> <492543CF.6040507@redhat.com> <20081121181111.GA3545@poweredge.glommer>
In-Reply-To: <20081121181111.GA3545@poweredge.glommer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
>> Hm, if !npages we should just kvm_free_physmem_slot(&old, NULL).
>>     
> Actually, I believe we need a little bit more than that, because we can
> have valid rmaps in flight.
>
> Tell me what you think about this.
>
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b1953ee..f605bba 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -735,11 +735,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
>  	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
>  	npages = mem->memory_size >> PAGE_SHIFT;
>  
> -	if (!npages)
> -		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> -
>  	new = old = *memslot;
>  
> +        if (!npages) {
> +                mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> +                kvm_arch_flush_shadow(kvm);
> +                kvm_free_physmem_slot(memslot, NULL);
> +                kvm_arch_set_memory_region(kvm, mem, old, user_alloc);
> +                goto out;
> +        }
>   

Why doesn't the kvm_free_physmem_slot() at the end of the normal path 
work?  I don't like adding a new path, for example you missed the iommu 
call.


-- 
error compiling committee.c: too many arguments to function

