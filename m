Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXCYMNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXCYMNG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 08:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXCYMNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 08:13:06 -0400
Received: from amsfep15-int.chello.nl ([62.179.120.10]:59007 "EHLO
	amsfep15-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752820AbXCYMNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 08:13:05 -0400
Subject: Re: [patch 2/3] only allow nonlinear vmas for ram backed
	filesystems
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <E1HVEQJ-0006gF-00@dorka.pomaz.szeredi.hu>
References: <E1HVEOB-0006fX-00@dorka.pomaz.szeredi.hu>
	 <E1HVEQJ-0006gF-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain
Date: Sun, 25 Mar 2007 14:12:32 +0200
Message-Id: <1174824752.5149.28.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-24 at 23:09 +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Dirty page accounting/limiting doesn't work for nonlinear mappings, so
> for non-ram backed filesystems emulate with linear mappings.  This
> retains ABI compatibility with previous kernels at minimal code cost.
> 
> All known users of nonlinear mappings actually use tmpfs, so this
> shouldn't have any negative effect.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> 
> Index: linux-2.6.21-rc4-mm1/mm/fremap.c
> ===================================================================
> --- linux-2.6.21-rc4-mm1.orig/mm/fremap.c	2007-03-24 22:30:05.000000000 +0100
> +++ linux-2.6.21-rc4-mm1/mm/fremap.c	2007-03-24 22:37:59.000000000 +0100
> @@ -181,6 +181,24 @@ asmlinkage long sys_remap_file_pages(uns
>  			goto retry;
>  		}
>  		mapping = vma->vm_file->f_mapping;
> +		/*
> +		 * page_mkclean doesn't work on nonlinear vmas, so if dirty
> +		 * pages need to be accounted, emulate with linear vmas.
> +		 */
> +		if (mapping_cap_account_dirty(mapping)) {
> +			unsigned long addr;
> +
> +			flags &= MAP_NONBLOCK;
> +			addr = mmap_region(vma->vm_file, start, size, flags,
> +					   vma->vm_flags, pgoff, 1);
> +			if (IS_ERR_VALUE(addr))
> +				err = addr;
> +			else {
> +				BUG_ON(addr != start);
> +				err = 0;
> +			}
> +			goto out;
> +		}
>  		spin_lock(&mapping->i_mmap_lock);
>  		flush_dcache_mmap_lock(mapping);
>  		vma->vm_flags |= VM_NONLINEAR;

