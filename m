Return-Path: <linux-kernel-owner+w=401wt.eu-S1758993AbXJaPMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993AbXJaPMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbXJaPMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:12:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37580 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756346AbXJaPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:12:04 -0400
Date: Wed, 31 Oct 2007 08:11:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Duane Griffin <duaneg@dghda.com>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: 2.6.23 regression: accessing invalid mmap'ed memory from gdb
 causes unkillable spinning
In-Reply-To: <20071031041932.GA12189@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0710310756220.30120@woody.linux-foundation.org>
References: <e9e943910710301745u429b14fj6c5a66fcbf6b0efa@mail.gmail.com>
 <20071031041932.GA12189@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Oct 2007, Nick Piggin wrote:
> 
> However I actually don't really like how this all works. I don't like that
> filemap.c should have to know about ptrace, or exactly what ptrace wants here.

It shouldn't. It should just fail when it fails. Then, handle_mm_fault() 
should return an error code, which should cause get_user_pages() to return 
an error code. Which should make ptrace just stop.

So I think your patch is wrong. mm/filemap.c should *not* care about who 
does the fault.  I think the proper patch is something untested like the 
appended...

> It's a bit hairy to force insert page into pagecache and pte into pagetables
> here, given the races.

It's also wrong. They shouldn't be in the page cache, since that can cause 
problems with truncate etc. Maybe it doesn't any more, but it's reasonable 
to believe that a page outside of i_size should not exist.

> In access_process_vm, can't we just zero fill in the case of a sigbus? Linus?
> That will also avoid changing applicatoin behaviour due to a gdb read...

access_process_vm() should just return how many bytes it could fill (which 
means a truncated copy - very including zero bytes - for an error), and 
the caller should decide what the right thing to do is.

But who knows, maybe I missed something.

Duane? Does this fix things for you?

			Linus

---
 mm/filemap.c |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 9940895..188cf5f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1300,7 +1300,7 @@ int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
-		goto outside_data_content;
+		return VM_FAULT_SIGBUS;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
@@ -1377,7 +1377,7 @@ retry_find:
 	if (unlikely(vmf->pgoff >= size)) {
 		unlock_page(page);
 		page_cache_release(page);
-		goto outside_data_content;
+		return VM_FAULT_SIGBUS;
 	}
 
 	/*
@@ -1388,15 +1388,6 @@ retry_find:
 	vmf->page = page;
 	return ret | VM_FAULT_LOCKED;
 
-outside_data_content:
-	/*
-	 * An external ptracer can access pages that normally aren't
-	 * accessible..
-	 */
-	if (vma->vm_mm == current->mm)
-		return VM_FAULT_SIGBUS;
-
-	/* Fall through to the non-read-ahead case */
 no_cached_page:
 	/*
 	 * We're only likely to ever get here if MADV_RANDOM is in
