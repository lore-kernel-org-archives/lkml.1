Return-Path: <linux-kernel-owner+w=401wt.eu-S1752758AbZA3Ieg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758AbZA3Ieg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 03:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZA3Ie1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 03:34:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:40636 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZA3Ie0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 03:34:26 -0500
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent
 VM_LOCKED file segments
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>
	 <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain>
	 <1233259410.2315.75.camel@lts-notebook>
	 <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
	 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 09:34:10 +0100
Message-Id: <1233304450.4495.147.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-29 at 12:48 -0800, Linus Torvalds wrote:
> I still want somebody else to look at and think about it, though.
> 
>                 Linus
> 
> ---
>  mm/mmap.c |   26 ++++++--------------------
>  1 files changed, 6 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8d95902..d3fa10a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1134,16 +1134,11 @@ munmap_back:
>         }
>  
>         /*
> -        * Can we just expand an old private anonymous mapping?
> -        * The VM_SHARED test is necessary because shmem_zero_setup
> -        * will create the file object for a shared anonymous map below.
> +        * Can we just expand an old mapping?
>          */
> -       if (!file && !(vm_flags & VM_SHARED)) {
> -               vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
> -                                       NULL, NULL, pgoff, NULL);
> -               if (vma)
> -                       goto out;
> -       }
> +       vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
> +       if (vma)
> +               goto out;

You've made checkpatch unhappy ;-)

So we don't bother with anonymous only, always attempt the merge.

> @@ -1206,17 +1201,8 @@ munmap_back:
>         if (vma_wants_writenotify(vma))
>                 vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
>  
> -       if (file && vma_merge(mm, prev, addr, vma->vm_end,
> -                       vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
> -               mpol_put(vma_policy(vma));
> -               kmem_cache_free(vm_area_cachep, vma);
> -               fput(file);
> -               if (vm_flags & VM_EXECUTABLE)
> -                       removed_exe_file_vma(mm);
> -       } else {
> -               vma_link(mm, vma, prev, rb_link, rb_parent);
> -               file = vma->vm_file;
> -       }
> +       vma_link(mm, vma, prev, rb_link, rb_parent);
> +       file = vma->vm_file;

And here we don't bother merging because that would have been done
before. Assuming ->mmap() doesn't go wild, in which case it ought to
have set a VM_SPECIAL bit anyway to discourage merging.

[ And even if it didn't, failing to merge shouldn't be a problem, as
minimizing the vmas is an optimization, not a strict requirement
afaik. ]

The obvious glaring difference is the vma_policy() cruft. But staring at
the code a bit I can't see how the new vma can have acquired a vm_policy
here, so it ought to not matter.

Looks ok to my eyes, so I guess:

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

