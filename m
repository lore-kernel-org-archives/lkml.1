Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbZHMVtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbZHMVtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 17:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZHMVtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 17:49:19 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37339 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbZHMVtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 17:49:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WeJ4u8etSk2Zr4UDKAGJTajMP4n7Z0rXhL5lOC3Pktrb4sntGqVloj8BVtj4YS/pm
	J7zjRydYh+8StUb/Ry8jg==
Date: Thu, 13 Aug 2009 14:49:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric B Munson <ebmunson@us.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 2/3] Add MAP_HUGETLB for mmaping pseudo-anonymous huge
 page regions V2
In-Reply-To: <83949d066e2a7221a25dd74d12d6dcf7e8b4e9ba.1250156841.git.ebmunson@us.ibm.com>
Message-ID: <alpine.DEB.2.00.0908131443350.9805@chino.kir.corp.google.com>
References: <cover.1250156841.git.ebmunson@us.ibm.com> <e9b02974a0cca308927ff3a4a0765b93faa6d12f.1250156841.git.ebmunson@us.ibm.com> <83949d066e2a7221a25dd74d12d6dcf7e8b4e9ba.1250156841.git.ebmunson@us.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Eric B Munson wrote:

> This patch adds a flag for mmap that will be used to request a huge
> page region that will look like anonymous memory to user space.  This
> is accomplished by using a file on the internal vfsmount.  MAP_HUGETLB
> is a modifier of MAP_ANONYMOUS and so must be specified with it.  The
> region will behave the same as a MAP_ANONYMOUS region using small pages.
> 
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> ---
> Changes from V1
>  Rebase to newest linux-2.6 tree
>  Rename MAP_LARGEPAGE to MAP_HUGETLB to match flag name for huge page shm
> 
>  include/asm-generic/mman-common.h |    1 +
>  include/linux/hugetlb.h           |    7 +++++++
>  mm/mmap.c                         |   16 ++++++++++++++++
>  3 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
> index 3b69ad3..12f5982 100644
> --- a/include/asm-generic/mman-common.h
> +++ b/include/asm-generic/mman-common.h
> @@ -19,6 +19,7 @@
>  #define MAP_TYPE	0x0f		/* Mask for type of mapping */
>  #define MAP_FIXED	0x10		/* Interpret addr exactly */
>  #define MAP_ANONYMOUS	0x20		/* don't use a file */
> +#define MAP_HUGETLB	0x40		/* create a huge page mapping */
>  
>  #define MS_ASYNC	1		/* sync memory asynchronously */
>  #define MS_INVALIDATE	2		/* invalidate the caches */
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 78b6ddf..b84361c 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -109,12 +109,19 @@ static inline void hugetlb_report_meminfo(struct seq_file *m)
>  
>  #endif /* !CONFIG_HUGETLB_PAGE */
>  
> +#define HUGETLB_ANON_FILE "anon_hugepage"
> +
>  enum {
>  	/*
>  	 * The file will be used as an shm file so shmfs accounting rules
>  	 * apply
>  	 */
>  	HUGETLB_SHMFS_INODE     = 0x01,
> +	/*
> +	 * The file is being created on the internal vfs mount and shmfs
> +	 * accounting rules do not apply
> +	 */
> +	HUGETLB_ANONHUGE_INODE  = 0x02,
>  };
>  
>  #ifdef CONFIG_HUGETLBFS

While I think it's appropriate to use an enum here, these two "flags" 
can't be used together so it would probably be better to avoid the 
hexadecimal.

If flags were ever needed in the future, you could reserve the upper eight 
bits of the int for such purposes similiar to mempolicy flags.

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 34579b2..3612b20 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -29,6 +29,7 @@
>  #include <linux/rmap.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/perf_counter.h>
> +#include <linux/hugetlb.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
> @@ -954,6 +955,21 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
>  	if (mm->map_count > sysctl_max_map_count)
>  		return -ENOMEM;
>  
> +	if (flags & MAP_HUGETLB) {
> +		if (file)
> +			return -EINVAL;
> +
> +		/*
> +		 * VM_NORESERVE is used because the reservations will be
> +		 * taken when vm_ops->mmap() is called
> +		 */
> +		len = ALIGN(len, huge_page_size(&default_hstate));
> +		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
> +						HUGETLB_ANONHUGE_INODE);
> +		if (IS_ERR(file))
> +			return -ENOMEM;
> +	}
> +
>  	/* Obtain the address to map to. we verify (or select) it and ensure
>  	 * that it represents a valid section of the address space.
>  	 */

hugetlb_file_setup() can fail for reasons other than failing to reserve 
pages, so maybe it would be better to return PTR_ERR(file) instead of 
hardcoding -ENOMEM?
