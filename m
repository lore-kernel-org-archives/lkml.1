Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXKAPrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXKAPrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbXKAPrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:47:08 -0400
Received: from ns1.suse.de ([195.135.220.2]:39327 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbXKAPrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:47:07 -0400
Date: Thu, 1 Nov 2007 16:47:05 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071101154705.GA745@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com> <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org> <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org> <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org> <20071101023758.GA30613@wotan.suse.de> <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0711010809171.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 08:14:47AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 1 Nov 2007, Nick Piggin wrote:
> 
> > On Wed, Oct 31, 2007 at 04:08:21PM -0700, Linus Torvalds wrote:
> > > 
> > > We made much bigger changes to ptrace support when we disallowed writing 
> > > to read-only shared memory areas (we used to do the magic per-page COW 
> > > thing).
> > 
> > Really? No, we still do that magic COW thing which creates anonymous
> > pages in MAP_SHARED vmas, don't we?
> 
> No, we don't. I'm pretty sure. It didn't work with the VM cleanups, since 
> the MAP_SHARED vma's won't be on the anonymous list any more, and cannot 
> be swapped out.
> 
> So now, if you try to write to a read-only shared page through ptrace, 
> you'll get "Unable to access".
 
No, it COWs it (the file is RW).

I believe do_wp_page will still attach an anon_vma to the vma, which
will make the pte discoverable via rmap.


> Of course, I didn't really look closely, so maybe I just don't remember 
> things right..
> 
> > > access_vm_pages() (things like core-dumping comes to mind - although I 
> > > think we don't dump pure file mappings at all, do we?) it would certainly 
> > > be good to run any such tests on the current -git tree...
> > 
> > We do for MAP_SHARED|MAP_ANONYMOUS, by the looks.
> 
> Well, as we should. There's no way for a debugger to get those pages back. 
> So that all looks sane.
> 
> > -			vm_flags |= VM_SHARED | VM_MAYSHARE;
> > -			if (!(file->f_mode & FMODE_WRITE))
> > -				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
> > +			vm_flags |= VM_MAYSHARE;
> > +			if (file->f_mode & FMODE_WRITE)
> > +				vm_flags |= VM_SHARED;
> > +			if (!(vm_flags & VM_WRITE))
> > +				vm_flags &= ~VM_MAYWRITE;
> 
> This looks totally bogus. What was the intent of this patch?
> 
> The VM_MAYWRITE flag is *not* supposed to track the VM_WRITE flag: that 
> would defeat the whole purpose of it! The whole point of that flag is to 
> say whether mprotect() could turn it into a VM_WRITE mapping, and it 
> depends on the file mode, not VM_WRITE!

Yeah of course that won't work, stupid...

The intent is to stop get_user_pages from proceeding with a write fault (and
subsequent COW) to readonly shared mappings, when force is set. I think it
can be done simply via get_user_pages(), which is what I should have done
to begin with.

Untested patch follows
---
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1031,7 +1031,9 @@ int get_user_pages(struct task_struct *t
 		}
 
 		if (!vma || (vma->vm_flags & (VM_IO | VM_PFNMAP))
-				|| !(vm_flags & vma->vm_flags))
+				|| !(vm_flags & vma->vm_flags)
+				|| (write && ((vma->vm_flags &
+				      (VM_SHARED|VM_MAYSHARE)) == VM_MAYSHARE)))
 			return i ? : -EFAULT;
 
 		if (is_vm_hugetlb_page(vma)) {
@@ -1563,13 +1565,11 @@ static int do_wp_page(struct mm_struct *
 			reuse = can_share_swap_page(old_page);
 			unlock_page(old_page);
 		}
-	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
-					(VM_WRITE|VM_SHARED))) {
+	} else if (unlikely((vma->vm_flags & VM_SHARED))) {
 		/*
-		 * Only catch write-faults on shared writable pages,
-		 * read-only shared pages can get COWed by
-		 * get_user_pages(.write=1, .force=1).
+		 * Only catch write-faults on shared writable pages.
 		 */
+		BUG_ON(!(vma->vm_flags & VM_WRITE));
 		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 			/*
 			 * Notify the address space that the page is about to
