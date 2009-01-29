Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbZA2Utw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbZA2Utw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZA2Utn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:49:43 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbZA2Utm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:49:42 -0500
Date: Thu, 29 Jan 2009 12:48:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Linus Torvalds wrote:
> 
> THIS PATCH IS TOTALLY UNTESTED!

Well, it boots. FWIW. I've not really tested anything interesting with it, 
but any potential breakage is at least not catastrophic and immediate.

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8d95902..3f78ead 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -769,6 +769,10 @@ struct vm_area_struct *vma_merge(struct mm_struct *mm,
>  	if (vm_flags & VM_SPECIAL)
>  		return NULL;
>  
> +	/* Anonymous shared mappings are unsharable */
> +	if ((vm_flags & VM_SHARED) && !file)
> +		return NULL;
> +

.. and I think this part of it is actually unnecessary, because what 
happens is that a shared anon mapping is turned into a shmem mapping when 
it is inserted, and that actually ends up allocating a file for it. So the 
vma->vm_file for anon mappings will not match a NULL file pointer 
_anyway_, so there's no way it would end up merging.

So my patch can be further simplified, I think, to just the following. 
Even more total lines removed.

I still want somebody else to look at and think about it, though.

		Linus

---
 mm/mmap.c |   26 ++++++--------------------
 1 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 8d95902..d3fa10a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1134,16 +1134,11 @@ munmap_back:
 	}
 
 	/*
-	 * Can we just expand an old private anonymous mapping?
-	 * The VM_SHARED test is necessary because shmem_zero_setup
-	 * will create the file object for a shared anonymous map below.
+	 * Can we just expand an old mapping?
 	 */
-	if (!file && !(vm_flags & VM_SHARED)) {
-		vma = vma_merge(mm, prev, addr, addr + len, vm_flags,
-					NULL, NULL, pgoff, NULL);
-		if (vma)
-			goto out;
-	}
+	vma = vma_merge(mm, prev, addr, addr + len, vm_flags, NULL, file, pgoff, NULL);
+	if (vma)
+		goto out;
 
 	/*
 	 * Determine the object being mapped and call the appropriate
@@ -1206,17 +1201,8 @@ munmap_back:
 	if (vma_wants_writenotify(vma))
 		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
 
-	if (file && vma_merge(mm, prev, addr, vma->vm_end,
-			vma->vm_flags, NULL, file, pgoff, vma_policy(vma))) {
-		mpol_put(vma_policy(vma));
-		kmem_cache_free(vm_area_cachep, vma);
-		fput(file);
-		if (vm_flags & VM_EXECUTABLE)
-			removed_exe_file_vma(mm);
-	} else {
-		vma_link(mm, vma, prev, rb_link, rb_parent);
-		file = vma->vm_file;
-	}
+	vma_link(mm, vma, prev, rb_link, rb_parent);
+	file = vma->vm_file;
 
 	/* Once vma denies write, undo our temporary denial count */
 	if (correct_wcount)
