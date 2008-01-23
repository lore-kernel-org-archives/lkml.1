Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYAWRHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYAWRHp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYAWRHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 12:07:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925AbYAWRHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 12:07:16 -0500
Date: Wed, 23 Jan 2008 09:05:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Salikhmetov <salikhmetov@gmail.com>
cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in
 sys_msync()
In-Reply-To: <1201044083504-git-send-email-salikhmetov@gmail.com>
Message-ID: <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org>
References: <12010440803930-git-send-email-salikhmetov@gmail.com> <1201044083504-git-send-email-salikhmetov@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jan 2008, Anton Salikhmetov wrote:
> +
> +		if (pte_dirty(*pte) && pte_write(*pte)) {

Not correct.

You still need to check "pte_present()" before you can test any other 
bits. For a non-present pte, none of the other bits are defined, and for 
all we know there might be architectures out there that require them to 
be non-dirty.

As it is, you just possibly randomly corrupted the pte.

Yeah, on all architectures I know of, it the pte is clear, neither of 
those tests will trigger, so it just happens to work, but it's still 
wrong. And for a MAP_SHARED mapping, it should be either clear or valid, 
although I can imagine that we might do swap-cache entries for tmpfs or 
something (in which case trying to clear the write-enable bit would 
corrupt the swap entry!).

So the bug might be hard or even impossible to trigger in practice, but 
it's still wrong.

I realize that "page_mkclean_one()" doesn't do this very obviously, but 
it's actually there (it's just hidden in page_check_address()). 

Quite frankly, at this point I'm getting *very* tired of this series. 
Especially since you ignored me when I suggested you just revert the 
commit that removed the page table walking - and instead send in a buggy 
patch.

Yes, the VM is hard. I agree. It's nasty. But exactly because it's nasty 
and subtle and horrid, I'm also very anal about it, and I get really 
nervous when somebody touches it without (a) knowing all the rules 
intimately and (b) listening to people who do.

So here's even a patch to get you started. Do this:

	git revert 204ec841fbea3e5138168edbc3a76d46747cc987

and then use this appended patch on top of that as a starting point for 
something that compiles and *possibly* works.

And no, I do *not* guarantee that this is right either! I have not tested 
it or thought about it a lot, and S390 tends to be odd about some of these 
things. In particular, I actually suspect that we should possibly do this 
the same way we do

	ptep_clear_flush_young()

except we would do "ptep_clear_flush_wrprotect()". So even though this is 
a revert plus a simple patch to make it compile again (we've changed how 
we do dirty bits), I think a patch like this needs testing and other 
people like Nick and Peter to ack it.

Nick? Peter? Testing? Other comments?

		Linus

---
 mm/msync.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/msync.c b/mm/msync.c
index a30487f..9b0af8f 100644
--- a/mm/msync.c
+++ b/mm/msync.c
@@ -32,6 +32,7 @@ static unsigned long msync_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 again:
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	do {
+		pte_t entry;
 		struct page *page;
 
 		if (progress >= 64) {
@@ -47,9 +48,11 @@ again:
 		page = vm_normal_page(vma, addr, *pte);
 		if (!page)
 			continue;
-		if (ptep_clear_flush_dirty(vma, addr, pte) ||
-				page_test_and_clear_dirty(page))
-			ret += set_page_dirty(page);
+		entry = ptep_clear_flush(vma, addr, pte);
+		entry = pte_wrprotect(entry);
+		set_pte_at(mm, address, pte, entry);
+
+		ret += 1;
 		progress += 3;
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	pte_unmap_unlock(pte - 1, ptl);
