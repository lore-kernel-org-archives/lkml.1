Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZA2XDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZA2XDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 18:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbZA2XD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 18:03:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbZA2XDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 18:03:25 -0500
Date: Thu, 29 Jan 2009 15:02:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Hugh Dickins <hugh@veritas.com>
cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maksim Yevmenkin <maksim.yevmenkin@gmail.com>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, will@crowder-design.com,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Fix OOPS in mmap_region() when merging adjacent VM_LOCKED
 file segments
In-Reply-To: <Pine.LNX.4.64.0901292200220.17808@blonde.anvils>
Message-ID: <alpine.LFD.2.00.0901291448360.3054@localhost.localdomain>
References: <bb4a86c70901281151w4300605r3882461cd6e9774a@mail.gmail.com>  <alpine.LFD.2.00.0901281316450.3123@localhost.localdomain> <1233259410.2315.75.camel@lts-notebook> <alpine.LFD.2.00.0901291228250.3123@localhost.localdomain>
 <alpine.LFD.2.00.0901291245170.3054@localhost.localdomain> <Pine.LNX.4.64.0901292200220.17808@blonde.anvils>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Jan 2009, Hugh Dickins wrote:
> 
> The problem has always been that file->f_op->mmap(file, vma) on a
> special file can do various strange things, changing surprising
> fields of the struct vma passed to it, changing its mergeability.

Ahh, you're right. That's somewhat bogus, but it does explain why we have 
those two separate merge_vma() calls.

And as you also point out:

> Now it may well be that every driver which does something strange
> there already sets one of the VM_SPECIAL flags which prevent merging,
> or can easily be fixed to do so, or otherwise clearly cannot pose a
> problem.

.. and I think this is the right answer. If a device driver really does 
something as odd as play games with the offset that would make merging 
wrong, it had better set some of the VM_SPECIAL bits (presumably VM_IO) in 
order to never merge at all.

I added DaveM to the cc, since he's the one who is credited with the 
comment saying that several drivers change addr (vm_start). I only really 
see one, namely bf54x-lq043fb.c, and that one really depends on the whole 
nommu thing (ie it seems to simply require a particular virtual address, 
broken as that may be).

Btw, changing vm_start is actually very very wrong - it cannot work in 
general. Why? Because we earlier checked the "overlapping mmap" case with 
the original vm_start, an a driver that changes its vm_start in its mmap() 
routine would cause odd issues there. We also pass in "prev" to vma_link, 
so it could end up in totally the wrong place.

So changing vm_start is a sign of a driver bug, nothing less.

But there are more drivers who do change vm_pgoff, which is at least valid 
(if a bit dodgy), and is indeed a mergeability issue.  But at least a 
subset of those do already set VM_IO (eg fbmem.c - I only looked at one, 
and was happy that it already did that).

As background for Davem, here's the patch once more.

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
