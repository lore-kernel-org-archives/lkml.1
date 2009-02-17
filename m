Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZBQLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZBQLZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZBQLZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:25:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50856 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZBQLZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:25:15 -0500
Date: Tue, 17 Feb 2009 12:25:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: set_page_dirty races (was: Re: [patch 2/4] vfs: add set_page_dirty_notag)
Message-ID: <20090217112512.GD26402@wotan.suse.de>
References: <49957C43.7050701@gmail.com> <1234534150.6519.101.camel@twins> <18838.49922.215481.399653@edward.zelnet.ru> <1234645893.4695.8.camel@laptop> <18841.60432.329341.514726@edward.zelnet.ru> <1234861781.4744.21.camel@laptop> <20090217093805.GB31323@wotan.suse.de> <1234865116.4744.46.camel@laptop> <20090217102443.GA26402@wotan.suse.de> <1234867200.4744.65.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234867200.4744.65.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 11:40:00AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 11:24 +0100, Nick Piggin wrote:
> > On Tue, Feb 17, 2009 at 11:05:16AM +0100, Peter Zijlstra wrote:
> > > On Tue, 2009-02-17 at 10:38 +0100, Nick Piggin wrote:
> > > 
> > > > It is a great shame that filesystems are not properly notified
> > > > that a page may become dirty before the actual set_page_dirty
> > > > event (which is not allowed to fail and is called after the
> > > > page is already dirty).
> > > 
> > > Not quite true, for example the set_page_dirty() done by the write fault
> > > code is done _before_ the page becomes dirty.
> > > 
> > > This before/after thing was the reason for that horrid file corruption
> > > bug that dragged on for a few weeks back in .19 (IIRC).
> > 
> > Yeah, there are actually races though. The page can become cleaned
> > before set_page_dirty is reached, and there are also nasty races with
> > truncate.
> 
> Hmm, so you're saying that never got properly fixed?

For the purposes of dirty accounting and syncing they are OK I think.

The problem is with page_mkwrite which is just another thing in
the equation. Unfortunately it was introduced without a very
clear statement of what kind of locking and concurrency it was
expected, and a vauge promise that the filesystem would be able
to handle synchronisation with the pagecache and virtual memory
(yeah right).

I should hopefully get around to splitting up fsblock and
submitting some of the generic code changes (there aren't too
many but mainly giving filesystems better and and less racy
dirty page handling ability).


> > For XFS purpose (ie. -ENOSPC handling), the current code is reasonable
> > although there could be some truncate races with block allocation. But
> > mostly probably works. For something like fsblock it can be much more
> > common to have the metadata refcount reach 0 and freed before spd is
> > called. In that case the code actually goes into a bug situation so it
> > is a bit more critical.
> > 
> > But no that's the "easy" part. The hard part is get_user_pages
> > because the caller can hold onto the page indefinitely simply with a
> > refcount, and go along happily dirtying it at any stage (actually
> > writing to the page memory) before actually calling set_page_dirty.
> 
> Should a gup user not specify .write=1 if it wants to dirty the page, at
> which point the follow_page() will do the dirty-fault thingy.
> 
> Ah, but then we can clean it because we're not holding the page-lock. I
> see.

Yep.

 
> > The "cleanest" way to fix this from VM point of view is probably to
> > force gup callers to hold the page locked for the duration to
> > prevent truncation or writeout after the filesystem notification.
> > Don't know if that would be very popular, however.
> 
> Right, so you'd want to keep the page locked over gup(.write=1)
> sections.

Something like that. lock_page might cause complaints ;) But
that appears to be the easiest and cleanest way, so I don't
want to hurt my brain thinking of something better yet! 


> So should we extend the gup() with put_user_page()?

put_user_pages simply defined to do the put_page thing for now would
yes allow callers to slowly migrate over and perhaps one day allow a
solution. At least it would make things more flexible in case any
other issues arise in future.

I had a patch... can't find it now. I don't think I'd done many
driver conversions. Here is another one to kick it off. Thoughts?
--

Introduce put_user_pages function.

In order to have more flexibility to deal with issues surrounding
get_user_pages difficulties[*], introduce put_user_pages function
intended to release pages acquired by get_user_pages. For now, just
do the regular put_page thing. If all callers are converted, it could
be used to help with such races. In the meantime, it will actually
serve as a small extra piece of documentation for the code.

[*] eg. get_user_pages caller can bypass page_mkwrite calls into the
    filesystem to notify of page dirty activity if the page gets cleaned
    before the caller calls its final set_page_dirty).

---
 include/linux/mm.h |    1 +
 mm/memory.c        |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -826,6 +826,7 @@ extern int access_process_vm(struct task
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
 		int len, int write, int force, struct page **pages, struct vm_area_struct **vmas);
 
+void put_user_pages(struct page **pages, int nr);
 extern int try_to_release_page(struct page * page, gfp_t gfp_mask);
 extern void do_invalidatepage(struct page *page, unsigned long offset);
 
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -1370,9 +1370,20 @@ int get_user_pages(struct task_struct *t
 				start, len, flags,
 				pages, vmas);
 }
-
 EXPORT_SYMBOL(get_user_pages);
 
+/*
+ * put_user_pages should be used to release pages acquired with get_user_pages.
+ */
+void put_user_pages(struct page **pages, int nr)
+{
+	int i;
+
+	for (i = 0; i < nr; i++)
+		put_page(pages[i]);
+}
+EXPORT_SYMBOL(put_user_pages);
+
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
 			spinlock_t **ptl)
 {

