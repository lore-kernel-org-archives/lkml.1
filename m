Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYKLXY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYKLXY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYKLXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:23:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127AbYKLXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:23:17 -0500
Date: Thu, 13 Nov 2008 00:23:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H.Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hugh@veritas.com>,
       Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.com>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Message-ID: <20081112232312.GB29363@wotan.suse.de>
References: <20081112212647.259698000@intel.com> <20081112212900.151113000@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112212900.151113000@intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You have to be careful of this, because it can be called with mmap_sem
held for read only. Hmm, I guess vm_insert_page is doing the same thing.
Probably mostly works because all other modifiers of vm_flags are holding
mmap_sem.

However, in some cases, code can do vm_insert_pfn and vm_insert_page
(actually hmm, no vm_insert_mixed actually should cover most of those
cases).

Still, I'd be much happier if we could make these into BUG_ON, and then
teach callers to set it in their .mmap routines.

 
On Wed, Nov 12, 2008 at 01:26:49PM -0800, Venkatesh Pallipadi wrote:
> vm_insert_pfn() is not setting the VM_PFNMAP flag in vma. Fix that.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> ---
>  mm/memory.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: tip/mm/memory.c
> ===================================================================
> --- tip.orig/mm/memory.c	2008-11-06 09:44:56.000000000 -0800
> +++ tip/mm/memory.c	2008-11-10 09:44:47.000000000 -0800
> @@ -1444,6 +1444,8 @@ int vm_insert_pfn(struct vm_area_struct 
>  
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
>  		return -EFAULT;
> +
> +	vma->vm_flags |= VM_PFNMAP;
>  	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
>  }
>  EXPORT_SYMBOL(vm_insert_pfn);
> 
> -- 
