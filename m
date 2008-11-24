Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYKXNIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYKXNIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbYKXNIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 08:08:25 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:56965 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYKXNIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 08:08:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OLMgZEGJrw2EQ1mWD711gUJ2a6hsfkdGBdWm0HKENPgvwCw6/J5cwrh8kEdjuWJ3Qt
         ET3Wxpe9MzhFCu2krTo2n+r+lZS6RkgHdYMX4ebJUCYJ3gOMn+pmPkalR4pjWbX+uqVa
         eLVSiBXCRTizgyujguo4PnIOQwpZUV9B/16TI=
Message-ID: <5d6222a80811240508k772eecc6h9f75ba46ad9873e1@mail.gmail.com>
Date: Mon, 24 Nov 2008 11:08:22 -0200
From: "Glauber Costa" <glommer@gmail.com>
To: "Glauber Costa" <glommer@redhat.com>
Subject: Re: [PATCH] always assign userspace_addr
Cc: "Avi Kivity" <avi@redhat.com>, "Anthony Liguori" <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20081121181111.GA3545@poweredge.glommer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226977462-8086-1-git-send-email-glommer@redhat.com>
	 <492436DE.2080906@codemonkey.ws>
	 <20081119184357.GB25917@poweredge.glommer>
	 <49246014.5000001@codemonkey.ws> <492543CF.6040507@redhat.com>
	 <20081121181111.GA3545@poweredge.glommer>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b1953ee..f605bba 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -735,11 +735,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
>        base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
>        npages = mem->memory_size >> PAGE_SHIFT;
>
> -       if (!npages)
> -               mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> -
>        new = old = *memslot;
>
> +        if (!npages) {
> +                mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> +                kvm_arch_flush_shadow(kvm);
> +                kvm_free_physmem_slot(memslot, NULL);
> +                kvm_arch_set_memory_region(kvm, mem, old, user_alloc);
> +                goto out;
> +        }
> +
> +
>        new.base_gfn = base_gfn;

Any comments about this version? In the absense of it, I'll submit a
version with a SoB for inclusion.
>        new.npages = npages;
>        new.flags = mem->flags;
> @@ -812,9 +818,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>        }
>  #endif /* not defined CONFIG_S390 */
>
> -       if (!npages)
> -               kvm_arch_flush_shadow(kvm);
> -
>        spin_lock(&kvm->mmu_lock);
>        if (mem->slot >= kvm->nmemslots)
>                kvm->nmemslots = mem->slot + 1;
>
>



-- 
Glauber  Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
