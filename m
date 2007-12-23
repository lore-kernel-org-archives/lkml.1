Return-Path: <linux-kernel-owner+w=401wt.eu-S1756513AbXLWSQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513AbXLWSQW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 13:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXLWSQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 13:16:14 -0500
Received: from il.qumranet.com ([82.166.9.18]:52301 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753477AbXLWSQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 13:16:13 -0500
Message-ID: <476EA5EB.8090205@qumranet.com>
Date: Sun, 23 Dec 2007 20:16:11 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 27/50] KVM: Support assigning userspace memory
 to the guest
References: <1198421495-31481-1-git-send-email-avi@qumranet.com> <1198421495-31481-28-git-send-email-avi@qumranet.com>
In-Reply-To: <1198421495-31481-28-git-send-email-avi@qumranet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> From: Izik Eidus <izike@qumranet.com>
>
> Instead of having the kernel allocate memory to the guest, let userspace
> allocate it and pass the address to the kernel.
>
> This is required for s390 support, but also enables features like memory
> sharing and using hugetlbfs backed memory.
>
>   

[...]

> @@ -728,11 +752,27 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
>  
>  		memset(new.phys_mem, 0, npages * sizeof(struct page *));
>  		memset(new.rmap, 0, npages * sizeof(*new.rmap));
> -		for (i = 0; i < npages; ++i) {
> -			new.phys_mem[i] = alloc_page(GFP_HIGHUSER
> -						     | __GFP_ZERO);
> -			if (!new.phys_mem[i])
> +		if (user_alloc) {
> +			unsigned long pages_num;
> +
> +			new.user_alloc = 1;
> +			down_read(&current->mm->mmap_sem);
> +
> +			pages_num = get_user_pages(current, current->mm,
> +						   mem->userspace_addr,
> +						   npages, 1, 0, new.phys_mem,
> +						   NULL);
> +
>   

I just combined a patch that changes the 'force' parameter to 
get_user_pages from 0 to 1, into this patch, to avoid introducing a bug 
and its fix in the same patchset.  I won't be resending this patch since 
the change is too trivial.  Same change applies to patch 48, "KVM: MMU: 
Partial swapping of guest memory".

-- 
error compiling committee.c: too many arguments to function

