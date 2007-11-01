Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXKACiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXKACiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 22:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXKACiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 22:38:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:44278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbXKACiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 22:38:00 -0400
Date: Thu, 1 Nov 2007 03:37:58 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb causes unkillable spinning
Message-ID: <20071101023758.GA30613@wotan.suse.de>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com> <20071031041932.GA12189@wotan.suse.de> <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org> <20071031151934.GA19211@wotan.suse.de> <alpine.LFD.0.999.0710310854560.3340@woody.linux-foundation.org> <20071031225541.GA28552@wotan.suse.de> <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710311602170.3342@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 04:08:21PM -0700, Linus Torvalds wrote:
> 
> 
> On Wed, 31 Oct 2007, Nick Piggin wrote:
> > 
> > No that would be great. Fingers crossed it won't cause any problems.
> 
> I actually doubt it will cause problems.
> 
> We made much bigger changes to ptrace support when we disallowed writing 
> to read-only shared memory areas (we used to do the magic per-page COW 
> thing).

Really? No, we still do that magic COW thing which creates anonymous
pages in MAP_SHARED vmas, don't we?

But I think that is pretty arbitrary as well. What the "force" argument to
get_user_pages on a MAP_SHARED vma effectively does is punt the permission
check from the vma permissions to the file permissions. If you've opened the
file WR but mmap()ed PROT_READ, it goes ahead and COWs, wheras if you've
opened the file RDONLY it -EFAULTs.

This seems strange wrong, because the act of COWing seems to be exactly
done in order to *absolve* us of file permissions (if we're COWing, why
should it matter if the file happened to be readonly or not).

Could we just try disallow COW for MAP_SHARED mappings?
Seeing as we're doing the break-ptrace thing this release already ;)
All the stuff I know of that requires forced COW (ie. gdb for breakpoints),
does so on MAP_PRIVATE mappings.

I know this is one of Hugh's bugbears. I don't know whether he's thought
out how to remove it, but I wonder if the appended patch is roughly in
the right direction?

> But if people have test-cases for ptrace and/or other magical users of 
> access_vm_pages() (things like core-dumping comes to mind - although I 
> think we don't dump pure file mappings at all, do we?) it would certainly 
> be good to run any such tests on the current -git tree...

We do for MAP_SHARED|MAP_ANONYMOUS, by the looks.

---
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1563,13 +1563,11 @@ static int do_wp_page(struct mm_struct *
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
Index: linux-2.6/mm/mmap.c
===================================================================
--- linux-2.6.orig/mm/mmap.c
+++ linux-2.6/mm/mmap.c
@@ -980,9 +980,11 @@ unsigned long do_mmap_pgoff(struct file 
 			if (locks_verify_locked(inode))
 				return -EAGAIN;
 
-			vm_flags |= VM_SHARED | VM_MAYSHARE;
-			if (!(file->f_mode & FMODE_WRITE))
-				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			vm_flags |= VM_MAYSHARE;
+			if (file->f_mode & FMODE_WRITE)
+				vm_flags |= VM_SHARED;
+			if (!(vm_flags & VM_WRITE))
+				vm_flags &= ~VM_MAYWRITE;
 
 			/* fall through */
 		case MAP_PRIVATE:
@@ -998,6 +1000,7 @@ unsigned long do_mmap_pgoff(struct file 
 
 			if (!file->f_op || !file->f_op->mmap)
 				return -ENODEV;
+
 			break;
 
 		default:
@@ -1007,6 +1010,8 @@ unsigned long do_mmap_pgoff(struct file 
 		switch (flags & MAP_TYPE) {
 		case MAP_SHARED:
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
+			if (!(vm_flags & VM_WRITE))
+				vm_flags &= ~VM_MAYWRITE;
 			break;
 		case MAP_PRIVATE:
 			/*
