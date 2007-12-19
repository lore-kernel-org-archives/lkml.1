Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbXLSRpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbXLSRpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 12:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXLSRpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 12:45:42 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbXLSRpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 12:45:41 -0500
Date: Wed, 19 Dec 2007 09:44:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Krzysztof Oledzki <olel@ans.pl>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Osterried <osterried@jesse.de>, protasnb@gmail.com,
       bugme-daemon@bugzilla.kernel.org, Thomas Osterried <osterried@jesse.de>
Subject: Re: [Bug 9182] Critical memory leak (dirty pages)
In-Reply-To: <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
Message-ID: <alpine.LFD.0.9999.0712190903350.21557@woody.linux-foundation.org>
References: <20071215221935.306A5108068@picon.linux-foundation.org> <Pine.LNX.4.64.0712152358240.14491@bizon.gios.gov.pl> <20071215203539.d6f71e96.akpm@linux-foundation.org> <Pine.LNX.4.64.0712161016290.25065@bizon.gios.gov.pl> <20071216015112.d0ab08a1.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0712161440030.25065@bizon.gios.gov.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 16 Dec 2007, Krzysztof Oledzki wrote:
> 
> I'll confirm this tomorrow but it seems that even switching to data=ordered
> (AFAIK default o ext3) is indeed enough to cure this problem.

Ok, do we actually have any ext3 expert following this? I have no idea 
about what the journalling code does, but I have painful memories of ext3 
doing really odd buffer-head-based IO and totally bypassing all the normal 
page dirty logic.

Judging by the symptoms (sorry for not following this well, it came up 
while I was mostly away travelling), something probably *does* clear the 
dirty bit on the pages, but the dirty *accounting* is not done properly, 
so the kernel keeps thinking it has dirty pages.

Now, a simple "grep" shows that ext3 does not actually do any 
ClearPageDirty() or similar on its own, although maybe I missed some other 
subtle way this can happen. And the *normal* VFS routines that do 
ClearPageDirty should all be doing the proper accounting.

So I see a couple of possible cases:

 - actually clearing the PG_dirty bit somehow, without doing the 
   accounting.

   This looks very unlikely. PG_dirty is always cleared by some variant of 
   "*ClearPageDirty()", and that bit definition isn't used for anything 
   else in the whole kernel judging by "grep" (the page allocator tests 
   the bit, that's it).

   And there aren't that many hits for ClearPageDirty, and they all seem 
   to do the proper "dec_zone_page_state(page, NR_FILE_DIRTY);" etc if the 
   mapping has dirty state accounting.

   The exceptions seem to be:
    - the page freeing path, but that path checks that "mapping" is NULL 
      (so no accounting), and would complain loudly if it wasn't
    - the swap state stuff ("move_from_swap_cache()"), but that should 
      only ever trigger for swap cache pages (we have a BUG_ON() in that 
      path), and those don't do dirty accounting anyway.
    - pageout(), but again only for pages that have a NULL mapping.

 - ext3 might be clearing (probably indirectly) the "page->mapping" thing 
   or similar, which in turn will make the VFS think that even a dirty 
   page isn't actually to be accounted for - so when the page *turned* 
   dirty, it was accounted as a dirty page, but then, when it was cleaned, 
   the accounting wasn't reversed because ->mapping had become NULL.

   This would be some interaction with the truncation logic, and quite 
   frankly, that should be all shared with the non-journal case, so I find 
   this all very unlikely. 

However, that second case is interesting, because the pageout case 
actually has a comment like this:

	/*
	 * Some data journaling orphaned pages can have
	 * page->mapping == NULL while being dirty with clean buffers.
	 */

which really sounds like the case in question. 

I may know the VM, but that special case was added due to insane 
journaling filesystems, and I don't know what insane things they do. Which 
is why I'm wondering if there is any ext3 person who knows the journaling 
code?

How/when does it ever "orphan" pages? Because yes, if it ever does that, 
and clears the ->mapping field on a mapped page, then that page will have 
incremented the dirty counts when it became dirty, but will *not* 
decrement the dirty count when it is an orphan.

> Two questions remain then: why system dies when dirty reaches ~200MB and what
> is wrong with ext3+data=journal with >=2.6.20-rc2?

Well, that one is probably pretty straightforward: since the kernel thinks 
that there are too many dirty pages, it will ask everybody who creates 
more dirty pages to clean out some *old* dirty pages, but since they don't 
exist, the whole thing will basically wait forever for a writeout to clean 
things out that will never happen.

200MB is 10% of your 2GB of low-mem RAM, and 10% is the default 
dirty_ratio that causes synchronous waits for writeback. If you use the 
normal 3:1 VM split, the hang should happen even earlier (at the ~100MB 
"dirty" mark).

So that part isn't the bug. The bug is in the accounting, but I'm pretty 
damn sure that the core VM itself is pretty ok, since that code has now 
been stable for people for the last year or so. It seems that ext3 (with 
data journaling) does something dodgy wrt some page.

But how about trying this appended patch. It should warn a few times if 
some page is ever removed from a mapping while it's dirty (and the mapping 
is one that should have been accouned). It also tries to "fix up" the 
case, so *if* this is the cause, it should also fix the bug.

I'd love to hear if you get any stack dumps with this, and what the 
backtrace is (and whether the dirty counts then stay ok).

The patch is totally untested. It compiles for me. That's all I can say.

(There's a few other places that set ->mapping to NULL, but they're pretty 
esoteric. Page migration? Stuff like that).

			Linus

---
 mm/filemap.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 188cf5f..7560843 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -124,6 +124,18 @@ void __remove_from_page_cache(struct page *page)
 	mapping->nrpages--;
 	__dec_zone_page_state(page, NR_FILE_PAGES);
 	BUG_ON(page_mapped(page));
+
+	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
+		static int count = 10;
+		if (count) {
+			count--;
+			WARN_ON(1);
+		}
+
+		/* Try to fix up the bug.. */
+		dec_zone_page_state(page, NR_FILE_DIRTY);
+		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
+	}
 }
 
 void remove_from_page_cache(struct page *page)
