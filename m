Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbZBBL7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbZBBL7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZBBL71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:59:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48573 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBBL71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:59:27 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED file segments
Cc: kosaki.motohiro@jp.fujitsu.com, Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Greg KH <gregkh@suse.de>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mikos Szeredi <miklos@szeredi.hu>
In-Reply-To: <alpine.LFD.2.00.0901311010460.3150@localhost.localdomain>
References: <Pine.LNX.4.64.0901311216250.6763@blonde.anvils> <alpine.LFD.2.00.0901311010460.3150@localhost.localdomain>
Message-Id: <20090202205515.EC89.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  2 Feb 2009 20:59:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I went to trip for last three days and I returned today.
I suprised this loooong thread now :)

I have one comment.

> TOTALLY UNTESTED. As usual. But the concept is pretty simple, and it 
> actually removes a fair chunk of hacky code.  The only reason the diffstat 
> output says that it adds more lines than it deletes is that I added more 
> comments and made that helper inline function rather than make a complex 
> conditional.
> 
> Whaddaya think?
> 
> 		Linus
> 
> ---
>  mm/mmap.c  |   48 +++++++++++++++++++++++++-----------------------
>  mm/shmem.c |    2 +-
>  2 files changed, 26 insertions(+), 24 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c581df1..5fcaec3 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1090,6 +1090,15 @@ int vma_wants_writenotify(struct vm_area_struct *vma)
>  		mapping_cap_account_dirty(vma->vm_file->f_mapping);
>  }
>  
> +/*
> + * We account for memory if it's a private writeable mapping,
> + * and VM_NORESERVE wasn't set.
> + */
> +static inline int private_accountable_mapping(unsigned int vm_flags)
> +{
> +	return (vm_flags & (VM_NORESERVE | VM_SHARED | VM_WRITE)) == VM_WRITE;
> +}
> +
>  unsigned long mmap_region(struct file *file, unsigned long addr,
>  			  unsigned long len, unsigned long flags,
>  			  unsigned int vm_flags, unsigned long pgoff,
> @@ -1117,23 +1126,24 @@ munmap_back:
>  	if (!may_expand_vm(mm, len >> PAGE_SHIFT))
>  		return -ENOMEM;
>  
> -	if (flags & MAP_NORESERVE)
> +	/*
> +	 * Set 'VM_NORESERVE' if we should not account for the
> +	 * memory use of this mapping. We only honor MAP_NORESERVE
> +	 * if we're allowed to overcommit memory.
> +	 */
> +	if ((flags & MAP_NORESERVE) && sysctl_overcommit_memory != OVERCOMMIT_NEVER)

I afraid this line a bit.
if following scenario happend, we can lost VM_NORESERVE?

1. admin set overcommit_memory to "never"
2. mmap
3. admin set overcommit_memory to "guess"


thanks.




