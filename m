Return-Path: <linux-kernel-owner+w=401wt.eu-S968650AbXEIGTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968650AbXEIGTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934720AbXEIGS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:18:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:39388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933482AbXEIGS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:18:56 -0400
Date: Wed, 9 May 2007 08:18:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Message-ID: <20070509061854.GA8171@wotan.suse.de>
References: <20070508113709.GA19294@wotan.suse.de> <10196.1178626976@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10196.1178626976@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 01:22:56PM +0100, David Howells wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > +There are two special bitops with lock barrier semantics (acquire/release,
> > +same as spinlocks).
> 
> You should update Documentation/memory-barriers.txt also.
> 
> >  #define TestSetPageLocked(page)		\
> >  		test_and_set_bit(PG_locked, &(page)->flags)
> > +#define TestSetPageLocked_Lock(page)		\
> > +		test_and_set_bit_lock(PG_locked, &(page)->flags)
> 
> Can we get away with just moving TestSetPageLocked() to the new function
> rather than adding another accessor?  Or how about LockPageLocked() and
> UnlockPageLocked() rather than SetPageLocked_Lock() that last looks wrong

Updated memory-barriers.txt, made the generic routines #defines because
smp_mb isn't always included early enough, and culled some of the page-
flags.h macros in favour of coding the lock operations directly.
--

Introduce test_and_set_bit_lock / clear_bit_unlock bitops with lock semantics.
Add non-trivial implementations for powerpc and ia64. Convert page lock, buffer
lock, bit_spin_lock, tasklet locks to use the new locks.

---
 Documentation/atomic_ops.txt      |    9 +++++++
 Documentation/memory-barriers.txt |   14 ++++++++++--
 drivers/scsi/sg.c                 |    2 -
 fs/buffer.c                       |    7 ++----
 fs/cifs/file.c                    |    2 -
 fs/jbd/commit.c                   |    4 +--
 fs/jbd2/commit.c                  |    4 +--
 fs/ntfs/aops.c                    |    2 -
 fs/ntfs/compress.c                |    2 -
 fs/ntfs/mft.c                     |    4 +--
 fs/reiserfs/inode.c               |    2 -
 fs/reiserfs/journal.c             |    4 +--
 fs/xfs/linux-2.6/xfs_aops.c       |    4 +--
 include/asm-alpha/bitops.h        |    1 
 include/asm-arm/bitops.h          |    1 
 include/asm-arm26/bitops.h        |    1 
 include/asm-avr32/bitops.h        |    1 
 include/asm-cris/bitops.h         |    1 
 include/asm-frv/bitops.h          |    1 
 include/asm-generic/bitops.h      |    1 
 include/asm-generic/bitops/lock.h |   13 +++++++++++
 include/asm-h8300/bitops.h        |    1 
 include/asm-i386/bitops.h         |    1 
 include/asm-ia64/bitops.h         |   33 ++++++++++++++++++++++++++++
 include/asm-m32r/bitops.h         |    1 
 include/asm-m68k/bitops.h         |    1 
 include/asm-m68knommu/bitops.h    |    1 
 include/asm-mips/bitops.h         |    1 
 include/asm-parisc/bitops.h       |    1 
 include/asm-powerpc/bitops.h      |   44 ++++++++++++++++++++++++++++++++++++++
 include/asm-s390/bitops.h         |    1 
 include/asm-sh/bitops.h           |    1 
 include/asm-sh64/bitops.h         |    1 
 include/asm-sparc/bitops.h        |    1 
 include/asm-sparc64/bitops.h      |    1 
 include/asm-v850/bitops.h         |    1 
 include/asm-x86_64/bitops.h       |    1 
 include/asm-xtensa/bitops.h       |    1 
 include/linux/bit_spinlock.h      |   11 +++++----
 include/linux/buffer_head.h       |    8 +++++-
 include/linux/interrupt.h         |    5 +---
 include/linux/page-flags.h        |    6 -----
 include/linux/pagemap.h           |    9 ++++++-
 kernel/wait.c                     |    2 -
 mm/filemap.c                      |   17 ++++++--------
 mm/memory.c                       |    2 -
 mm/migrate.c                      |    4 +--
 mm/rmap.c                         |    2 -
 mm/shmem.c                        |    4 +--
 mm/swap.c                         |    2 -
 mm/swap_state.c                   |    2 -
 mm/swapfile.c                     |    2 -
 mm/truncate.c                     |    4 +--
 mm/vmscan.c                       |    4 +--
 54 files changed, 193 insertions(+), 63 deletions(-)

Index: linux-2.6/include/asm-powerpc/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-powerpc/bitops.h	2007-05-09 14:00:42.000000000 +1000
@@ -87,6 +87,24 @@
 	: "cc" );
 }
 
+static __inline__ void clear_bit_unlock(int nr, volatile unsigned long *addr)
+{
+	unsigned long old;
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	__asm__ __volatile__(
+	LWSYNC_ON_SMP
+"1:"	PPC_LLARX "%0,0,%3	# clear_bit_unlock\n"
+	"andc	%0,%0,%2\n"
+	PPC405_ERR77(0,%3)
+	PPC_STLCX "%0,0,%3\n"
+	"bne-	1b"
+	: "=&r" (old), "+m" (*p)
+	: "r" (mask), "r" (p)
+	: "cc" );
+}
+
 static __inline__ void change_bit(int nr, volatile unsigned long *addr)
 {
 	unsigned long old;
@@ -126,6 +144,27 @@
 	return (old & mask) != 0;
 }
 
+static __inline__ int test_and_set_bit_lock(unsigned long nr,
+				       volatile unsigned long *addr)
+{
+	unsigned long old, t;
+	unsigned long mask = BITOP_MASK(nr);
+	unsigned long *p = ((unsigned long *)addr) + BITOP_WORD(nr);
+
+	__asm__ __volatile__(
+"1:"	PPC_LLARX "%0,0,%3		# test_and_set_bit_lock\n"
+	"or	%1,%0,%2 \n"
+	PPC405_ERR77(0,%3)
+	PPC_STLCX "%1,0,%3 \n"
+	"bne-	1b"
+	ISYNC_ON_SMP
+	: "=&r" (old), "=&r" (t)
+	: "r" (mask), "r" (p)
+	: "cc", "memory");
+
+	return (old & mask) != 0;
+}
+
 static __inline__ int test_and_clear_bit(unsigned long nr,
 					 volatile unsigned long *addr)
 {
Index: linux-2.6/include/linux/pagemap.h
===================================================================
--- linux-2.6.orig/include/linux/pagemap.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/linux/pagemap.h	2007-05-09 13:57:33.000000000 +1000
@@ -135,13 +135,18 @@
 extern void FASTCALL(__lock_page_nosync(struct page *page));
 extern void FASTCALL(unlock_page(struct page *page));
 
+static inline int trylock_page(struct page *page)
+{
+	return (likely(!test_and_set_bit_lock(PG_locked, &page->flags)));
+}
+
 /*
  * lock_page may only be called if we have the page's inode pinned.
  */
 static inline void lock_page(struct page *page)
 {
 	might_sleep();
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		__lock_page(page);
 }
 
@@ -152,7 +157,7 @@
 static inline void lock_page_nosync(struct page *page)
 {
 	might_sleep();
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		__lock_page_nosync(page);
 }
 	
Index: linux-2.6/drivers/scsi/sg.c
===================================================================
--- linux-2.6.orig/drivers/scsi/sg.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/drivers/scsi/sg.c	2007-05-09 13:57:33.000000000 +1000
@@ -1734,7 +1734,7 @@
                  */
 		flush_dcache_page(pages[i]);
 		/* ?? Is locking needed? I don't think so */
-		/* if (TestSetPageLocked(pages[i]))
+		/* if (!trylock_page(pages[i]))
 		   goto out_unlock; */
         }
 
Index: linux-2.6/fs/cifs/file.c
===================================================================
--- linux-2.6.orig/fs/cifs/file.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/cifs/file.c	2007-05-09 13:57:33.000000000 +1000
@@ -1229,7 +1229,7 @@
 
 			if (first < 0)
 				lock_page(page);
-			else if (TestSetPageLocked(page))
+			else if (!trylock_page(page))
 				break;
 
 			if (unlikely(page->mapping != mapping)) {
Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/jbd/commit.c	2007-05-09 13:57:33.000000000 +1000
@@ -64,7 +64,7 @@
 		goto nope;
 
 	/* OK, it's a truncated page */
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		goto nope;
 
 	page_cache_get(page);
@@ -209,7 +209,7 @@
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/jbd2/commit.c	2007-05-09 13:57:33.000000000 +1000
@@ -64,7 +64,7 @@
 		goto nope;
 
 	/* OK, it's a truncated page */
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		goto nope;
 
 	page_cache_get(page);
@@ -209,7 +209,7 @@
 		 * blocking lock_buffer().
 		 */
 		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
 				/* Write out all data to prevent deadlocks */
Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2007-05-09 13:57:33.000000000 +1000
@@ -601,7 +601,7 @@
 			} else
 				pg_offset = PAGE_CACHE_SIZE;
 
-			if (page->index == tindex && !TestSetPageLocked(page)) {
+			if (page->index == tindex && trylock_page(page)) {
 				len = xfs_probe_page(page, pg_offset, mapped);
 				unlock_page(page);
 			}
@@ -685,7 +685,7 @@
 
 	if (page->index != tindex)
 		goto fail;
-	if (TestSetPageLocked(page))
+	if (!trylock_page(page))
 		goto fail;
 	if (PageWriteback(page))
 		goto fail_unlock_page;
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/linux/page-flags.h	2007-05-09 13:57:33.000000000 +1000
@@ -112,12 +112,6 @@
 		test_bit(PG_locked, &(page)->flags)
 #define SetPageLocked(page)		\
 		set_bit(PG_locked, &(page)->flags)
-#define TestSetPageLocked(page)		\
-		test_and_set_bit(PG_locked, &(page)->flags)
-#define ClearPageLocked(page)		\
-		clear_bit(PG_locked, &(page)->flags)
-#define TestClearPageLocked(page)	\
-		test_and_clear_bit(PG_locked, &(page)->flags)
 
 #define PageError(page)		test_bit(PG_error, &(page)->flags)
 #define SetPageError(page)	set_bit(PG_error, &(page)->flags)
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/memory.c	2007-05-09 13:57:33.000000000 +1000
@@ -1550,7 +1550,7 @@
 	 * not dirty accountable.
 	 */
 	if (PageAnon(old_page)) {
-		if (!TestSetPageLocked(old_page)) {
+		if (trylock_page(old_page)) {
 			reuse = can_share_swap_page(old_page);
 			unlock_page(old_page);
 		}
Index: linux-2.6/mm/migrate.c
===================================================================
--- linux-2.6.orig/mm/migrate.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/migrate.c	2007-05-09 13:57:33.000000000 +1000
@@ -569,7 +569,7 @@
 	 * establishing additional references. We are the only one
 	 * holding a reference to the new page at this point.
 	 */
-	if (TestSetPageLocked(newpage))
+	if (!trylock_page(newpage))
 		BUG();
 
 	/* Prepare mapping for the new page.*/
@@ -621,7 +621,7 @@
 		goto move_newpage;
 
 	rc = -EAGAIN;
-	if (TestSetPageLocked(page)) {
+	if (!trylock_page(page)) {
 		if (!force)
 			goto move_newpage;
 		lock_page(page);
Index: linux-2.6/mm/rmap.c
===================================================================
--- linux-2.6.orig/mm/rmap.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/rmap.c	2007-05-09 13:57:33.000000000 +1000
@@ -426,7 +426,7 @@
 			referenced += page_referenced_anon(page);
 		else if (is_locked)
 			referenced += page_referenced_file(page);
-		else if (TestSetPageLocked(page))
+		else if (!trylock_page(page))
 			referenced++;
 		else {
 			if (page->mapping)
Index: linux-2.6/mm/shmem.c
===================================================================
--- linux-2.6.orig/mm/shmem.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/shmem.c	2007-05-09 13:57:33.000000000 +1000
@@ -1154,7 +1154,7 @@
 		}
 
 		/* We have to do this with page locked to prevent races */
-		if (TestSetPageLocked(swappage)) {
+		if (!trylock_page(swappage)) {
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			wait_on_page_locked(swappage);
@@ -1213,7 +1213,7 @@
 		shmem_swp_unmap(entry);
 		filepage = find_get_page(mapping, idx);
 		if (filepage &&
-		    (!PageUptodate(filepage) || TestSetPageLocked(filepage))) {
+		    (!PageUptodate(filepage) || !trylock_page(filepage))) {
 			spin_unlock(&info->lock);
 			wait_on_page_locked(filepage);
 			page_cache_release(filepage);
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/swap.c	2007-05-09 13:57:33.000000000 +1000
@@ -412,7 +412,7 @@
 	for (i = 0; i < pagevec_count(pvec); i++) {
 		struct page *page = pvec->pages[i];
 
-		if (PagePrivate(page) && !TestSetPageLocked(page)) {
+		if (PagePrivate(page) && trylock_page(page)) {
 			if (PagePrivate(page))
 				try_to_release_page(page, 0);
 			unlock_page(page);
Index: linux-2.6/mm/swap_state.c
===================================================================
--- linux-2.6.orig/mm/swap_state.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/swap_state.c	2007-05-09 13:57:33.000000000 +1000
@@ -252,7 +252,7 @@
  */
 static inline void free_swap_cache(struct page *page)
 {
-	if (PageSwapCache(page) && !TestSetPageLocked(page)) {
+	if (PageSwapCache(page) && trylock_page(page)) {
 		remove_exclusive_swap_page(page);
 		unlock_page(page);
 	}
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/swapfile.c	2007-05-09 13:57:33.000000000 +1000
@@ -401,7 +401,7 @@
 	if (p) {
 		if (swap_entry_free(p, swp_offset(entry)) == 1) {
 			page = find_get_page(&swapper_space, entry.val);
-			if (page && unlikely(TestSetPageLocked(page))) {
+			if (page && unlikely(!trylock_page(page))) {
 				page_cache_release(page);
 				page = NULL;
 			}
Index: linux-2.6/mm/truncate.c
===================================================================
--- linux-2.6.orig/mm/truncate.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/truncate.c	2007-05-09 13:57:33.000000000 +1000
@@ -185,7 +185,7 @@
 			if (page_index > next)
 				next = page_index;
 			next++;
-			if (TestSetPageLocked(page))
+			if (!trylock_page(page))
 				continue;
 			if (PageWriteback(page)) {
 				unlock_page(page);
@@ -281,7 +281,7 @@
 			pgoff_t index;
 			int lock_failed;
 
-			lock_failed = TestSetPageLocked(page);
+			lock_failed = !trylock_page(page);
 
 			/*
 			 * We really shouldn't be looking at the ->index of an
Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/vmscan.c	2007-05-09 13:57:33.000000000 +1000
@@ -466,7 +466,7 @@
 		page = lru_to_page(page_list);
 		list_del(&page->lru);
 
-		if (TestSetPageLocked(page))
+		if (!trylock_page(page))
 			goto keep;
 
 		VM_BUG_ON(PageActive(page));
@@ -538,7 +538,7 @@
 				 * A synchronous write - probably a ramdisk.  Go
 				 * ahead and try to reclaim the page.
 				 */
-				if (TestSetPageLocked(page))
+				if (!trylock_page(page))
 					goto keep;
 				if (PageDirty(page) || PageWriteback(page))
 					goto keep_locked;
Index: linux-2.6/include/linux/bit_spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/bit_spinlock.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/linux/bit_spinlock.h	2007-05-09 13:57:33.000000000 +1000
@@ -18,7 +18,7 @@
 	 */
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	while (test_and_set_bit(bitnum, addr)) {
+	while (unlikely(test_and_set_bit_lock(bitnum, addr))) {
 		while (test_bit(bitnum, addr)) {
 			preempt_enable();
 			cpu_relax();
@@ -36,7 +36,7 @@
 {
 	preempt_disable();
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-	if (test_and_set_bit(bitnum, addr)) {
+	if (test_and_set_bit_lock(bitnum, addr)) {
 		preempt_enable();
 		return 0;
 	}
@@ -50,10 +50,11 @@
  */
 static inline void bit_spin_unlock(int bitnum, unsigned long *addr)
 {
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+#ifdef CONFIG_DEBUG_SPINLOCK
 	BUG_ON(!test_bit(bitnum, addr));
-	smp_mb__before_clear_bit();
-	clear_bit(bitnum, addr);
+#endif
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+	clear_bit_unlock(bitnum, addr);
 #endif
 	preempt_enable();
 	__release(bitlock);
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/mm/filemap.c	2007-05-09 13:57:33.000000000 +1000
@@ -525,17 +525,14 @@
  * mechananism between PageLocked pages and PageWriteback pages is shared.
  * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
  *
- * The first mb is necessary to safely close the critical section opened by the
- * TestSetPageLocked(), the second mb is necessary to enforce ordering between
- * the clear_bit and the read of the waitqueue (to avoid SMP races with a
- * parallel wait_on_page_locked()).
+ * The mb is necessary to enforce ordering between the clear_bit and the read
+ * of the waitqueue (to avoid SMP races with a parallel wait_on_page_locked()).
  */
 void fastcall unlock_page(struct page *page)
 {
-	smp_mb__before_clear_bit();
-	if (!TestClearPageLocked(page))
-		BUG();
-	smp_mb__after_clear_bit(); 
+	VM_BUG_ON(!PageLocked(page));
+	clear_bit_unlock(PG_locked, &page->flags);
+	smp_mb__after_clear_bit();
 	wake_up_page(page, PG_locked);
 }
 EXPORT_SYMBOL(unlock_page);
@@ -625,7 +622,7 @@
 	page = radix_tree_lookup(&mapping->page_tree, offset);
 	if (page) {
 		page_cache_get(page);
-		if (TestSetPageLocked(page)) {
+		if (!trylock_page(page)) {
 			read_unlock_irq(&mapping->tree_lock);
 			__lock_page(page);
 			read_lock_irq(&mapping->tree_lock);
@@ -798,7 +795,7 @@
 	struct page *page = find_get_page(mapping, index);
 
 	if (page) {
-		if (!TestSetPageLocked(page))
+		if (trylock_page(page))
 			return page;
 		page_cache_release(page);
 		return NULL;
Index: linux-2.6/include/asm-alpha/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-alpha/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-alpha/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -359,6 +359,7 @@
 #else
 #include <asm-generic/bitops/hweight.h>
 #endif
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-arm/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-arm/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-arm/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -286,6 +286,7 @@
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /*
  * Ext2 is defined to use little-endian byte ordering.
Index: linux-2.6/include/asm-arm26/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-arm26/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-arm26/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -167,6 +167,7 @@
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /*
  * Ext2 is defined to use little-endian byte ordering.
Index: linux-2.6/include/asm-avr32/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-avr32/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-avr32/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -288,6 +288,7 @@
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
Index: linux-2.6/include/asm-cris/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-cris/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-cris/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -154,6 +154,7 @@
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
 #include <asm-generic/bitops/find.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
Index: linux-2.6/include/asm-frv/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-frv/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-frv/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -302,6 +302,7 @@
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 
Index: linux-2.6/include/asm-generic/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-generic/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-generic/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -22,6 +22,7 @@
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
Index: linux-2.6/include/asm-generic/bitops/lock.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/asm-generic/bitops/lock.h	2007-05-09 13:57:33.000000000 +1000
@@ -0,0 +1,13 @@
+#ifndef _ASM_GENERIC_BITOPS_LOCK_H_
+#define _ASM_GENERIC_BITOPS_LOCK_H_
+
+#define test_and_set_bit_lock(nr, addr)	test_and_set_bit(nr, addr)
+
+#define clear_bit_unlock(nr, addr)	\
+do {					\
+	smp_mb__before_clear_bit();	\
+	clear_bit(nr, addr);		\
+} while (0)
+
+#endif /* _ASM_GENERIC_BITOPS_LOCK_H_ */
+
Index: linux-2.6/include/asm-h8300/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-h8300/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-h8300/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -194,6 +194,7 @@
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
Index: linux-2.6/include/asm-i386/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-i386/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-i386/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -402,6 +402,7 @@
 }
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-ia64/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-ia64/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -94,6 +94,30 @@
 }
 
 /**
+ * clear_bit_unlock - Clears a bit in memory with release
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and may not be reordered.  It does
+ * contain a memory barrier suitable for unlock type operations.
+ */
+static __inline__ void
+clear_bit_unlock (int nr, volatile void *addr)
+{
+	__u32 mask, old, new;
+	volatile __u32 *m;
+	CMPXCHG_BUGCHECK_DECL
+
+	m = (volatile __u32 *) addr + (nr >> 5);
+	mask = ~(1 << (nr & 31));
+	do {
+		CMPXCHG_BUGCHECK(m);
+		old = *m;
+		new = old & mask;
+	} while (cmpxchg_rel(m, old, new) != old);
+}
+
+/**
  * __clear_bit - Clears a bit in memory (non-atomic version)
  */
 static __inline__ void
@@ -170,6 +194,15 @@
 }
 
 /**
+ * test_and_set_bit_lock - Set a bit and return its old value for lock
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This is the same as test_and_set_bit on ia64
+ */
+#define test_and_set_bit_lock test_and_set_bit
+
+/**
  * __test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
Index: linux-2.6/include/asm-m32r/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-m32r/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-m32r/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -255,6 +255,7 @@
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-m68k/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-m68k/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-m68k/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -314,6 +314,7 @@
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /* Bitmap functions for the minix filesystem */
 
Index: linux-2.6/include/asm-m68knommu/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-m68knommu/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-m68knommu/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -160,6 +160,7 @@
 
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 static __inline__ int ext2_set_bit(int nr, volatile void * addr)
 {
Index: linux-2.6/include/asm-mips/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-mips/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-mips/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -569,6 +569,7 @@
 
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
 #include <asm-generic/bitops/minix.h>
Index: linux-2.6/include/asm-parisc/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-parisc/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-parisc/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -208,6 +208,7 @@
 
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 
 #endif /* __KERNEL__ */
Index: linux-2.6/include/asm-s390/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-s390/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-s390/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -746,6 +746,7 @@
 #include <asm-generic/bitops/fls64.h>
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 /*
  * ATTENTION: intel byte ordering convention for ext2 and minix !!
Index: linux-2.6/include/asm-sh/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-sh/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-sh/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -137,6 +137,7 @@
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
Index: linux-2.6/include/asm-sh64/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-sh64/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-sh64/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -136,6 +136,7 @@
 #include <asm-generic/bitops/__ffs.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/ffs.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
Index: linux-2.6/include/asm-sparc/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-sparc/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-sparc/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -96,6 +96,7 @@
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/fls64.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #include <asm-generic/bitops/ext2-atomic.h>
Index: linux-2.6/include/asm-sparc64/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-sparc64/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-sparc64/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -81,6 +81,7 @@
 #include <asm-generic/bitops/hweight.h>
 
 #endif
+#include <asm-generic/bitops/lock.h>
 #endif /* __KERNEL__ */
 
 #include <asm-generic/bitops/find.h>
Index: linux-2.6/include/asm-v850/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-v850/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-v850/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -145,6 +145,7 @@
 #include <asm-generic/bitops/find.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #include <asm-generic/bitops/ext2-non-atomic.h>
 #define ext2_set_bit_atomic(l,n,a)      test_and_set_bit(n,a)
Index: linux-2.6/include/asm-x86_64/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-x86_64/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -408,6 +408,7 @@
 #define ARCH_HAS_FAST_MULTIPLIER 1
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-xtensa/bitops.h
===================================================================
--- linux-2.6.orig/include/asm-xtensa/bitops.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/asm-xtensa/bitops.h	2007-05-09 13:57:33.000000000 +1000
@@ -115,6 +115,7 @@
 #endif
 
 #include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/lock.h>
 #include <asm-generic/bitops/sched.h>
 #include <asm-generic/bitops/minix.h>
 
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/buffer.c	2007-05-09 13:57:33.000000000 +1000
@@ -78,8 +78,7 @@
 
 void fastcall unlock_buffer(struct buffer_head *bh)
 {
-	smp_mb__before_clear_bit();
-	clear_buffer_locked(bh);
+	clear_bit_unlock(BH_Lock, &bh->b_state);
 	smp_mb__after_clear_bit();
 	wake_up_bit(&bh->b_state, BH_Lock);
 }
@@ -1664,7 +1663,7 @@
 		 */
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
-		} else if (test_set_buffer_locked(bh)) {
+		} else if (!trylock_buffer(bh)) {
 			redirty_page_for_writepage(wbc, page);
 			continue;
 		}
@@ -2719,7 +2718,7 @@
 
 		if (rw == SWRITE)
 			lock_buffer(bh);
-		else if (test_set_buffer_locked(bh))
+		else if (!trylock_buffer(bh))
 			continue;
 
 		if (rw == WRITE || rw == SWRITE) {
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/linux/buffer_head.h	2007-05-09 13:57:33.000000000 +1000
@@ -115,7 +115,6 @@
 BUFFER_FNS(Dirty, dirty)
 TAS_BUFFER_FNS(Dirty, dirty)
 BUFFER_FNS(Lock, locked)
-TAS_BUFFER_FNS(Lock, locked)
 BUFFER_FNS(Req, req)
 TAS_BUFFER_FNS(Req, req)
 BUFFER_FNS(Mapped, mapped)
@@ -301,10 +300,15 @@
 		__wait_on_buffer(bh);
 }
 
+static inline int trylock_buffer(struct buffer_head *bh)
+{
+	return likely(!test_and_set_bit_lock(BH_Lock, &bh->b_state));
+}
+
 static inline void lock_buffer(struct buffer_head *bh)
 {
 	might_sleep();
-	if (test_set_buffer_locked(bh))
+	if (!trylock_buffer(bh))
 		__lock_buffer(bh);
 }
 
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/include/linux/interrupt.h	2007-05-09 13:57:33.000000000 +1000
@@ -310,13 +310,12 @@
 #ifdef CONFIG_SMP
 static inline int tasklet_trylock(struct tasklet_struct *t)
 {
-	return !test_and_set_bit(TASKLET_STATE_RUN, &(t)->state);
+	return !test_and_set_bit_lock(TASKLET_STATE_RUN, &(t)->state);
 }
 
 static inline void tasklet_unlock(struct tasklet_struct *t)
 {
-	smp_mb__before_clear_bit(); 
-	clear_bit(TASKLET_STATE_RUN, &(t)->state);
+	clear_bit_unlock(TASKLET_STATE_RUN, &(t)->state);
 }
 
 static inline void tasklet_unlock_wait(struct tasklet_struct *t)
Index: linux-2.6/kernel/wait.c
===================================================================
--- linux-2.6.orig/kernel/wait.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/kernel/wait.c	2007-05-09 13:57:33.000000000 +1000
@@ -195,7 +195,7 @@
 			if ((ret = (*action)(q->key.flags)))
 				break;
 		}
-	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
+	} while (test_and_set_bit_lock(q->key.bit_nr, q->key.flags));
 	finish_wait(wq, &q->wait);
 	return ret;
 }
Index: linux-2.6/Documentation/atomic_ops.txt
===================================================================
--- linux-2.6.orig/Documentation/atomic_ops.txt	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/Documentation/atomic_ops.txt	2007-05-09 13:57:33.000000000 +1000
@@ -369,6 +369,15 @@
 	 */
 	 smp_mb__after_clear_bit();
 
+There are two special bitops with lock barrier semantics (acquire/release,
+same as spinlocks). These operate in the same way as their non-_lock/unlock
+postfixed variants, except that they are to provide acquire/release semantics,
+respectively. This means they can be used for bit_spin_trylock and
+bit_spin_unlock type operations without specifying any more barriers.
+
+	int test_and_set_bit_lock(unsigned long nr, unsigned long *addr);
+	void clear_bit_unlock(unsigned long nr, unsigned long *addr);
+
 Finally, there are non-atomic versions of the bitmask operations
 provided.  They are used in contexts where some other higher-level SMP
 locking scheme is being used to protect the bitmask, and thus less
Index: linux-2.6/fs/ntfs/aops.c
===================================================================
--- linux-2.6.orig/fs/ntfs/aops.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/ntfs/aops.c	2007-05-09 13:57:33.000000000 +1000
@@ -1199,7 +1199,7 @@
 		tbh = bhs[i];
 		if (!tbh)
 			continue;
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			BUG();
 		/* The buffer dirty state is now irrelevant, just clean it. */
 		clear_buffer_dirty(tbh);
Index: linux-2.6/fs/ntfs/compress.c
===================================================================
--- linux-2.6.orig/fs/ntfs/compress.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/ntfs/compress.c	2007-05-09 13:57:33.000000000 +1000
@@ -655,7 +655,7 @@
 	for (i = 0; i < nr_bhs; i++) {
 		struct buffer_head *tbh = bhs[i];
 
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			continue;
 		if (unlikely(buffer_uptodate(tbh))) {
 			unlock_buffer(tbh);
Index: linux-2.6/fs/ntfs/mft.c
===================================================================
--- linux-2.6.orig/fs/ntfs/mft.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/ntfs/mft.c	2007-05-09 13:57:33.000000000 +1000
@@ -586,7 +586,7 @@
 		for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
 			struct buffer_head *tbh = bhs[i_bhs];
 
-			if (unlikely(test_set_buffer_locked(tbh)))
+			if (!trylock_buffer(tbh))
 				BUG();
 			BUG_ON(!buffer_uptodate(tbh));
 			clear_buffer_dirty(tbh);
@@ -779,7 +779,7 @@
 	for (i_bhs = 0; i_bhs < nr_bhs; i_bhs++) {
 		struct buffer_head *tbh = bhs[i_bhs];
 
-		if (unlikely(test_set_buffer_locked(tbh)))
+		if (!trylock_buffer(tbh))
 			BUG();
 		BUG_ON(!buffer_uptodate(tbh));
 		clear_buffer_dirty(tbh);
Index: linux-2.6/fs/reiserfs/inode.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/inode.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/reiserfs/inode.c	2007-05-09 13:57:33.000000000 +1000
@@ -2448,7 +2448,7 @@
 		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
 			lock_buffer(bh);
 		} else {
-			if (test_set_buffer_locked(bh)) {
+			if (!trylock_buffer(bh)) {
 				redirty_page_for_writepage(wbc, page);
 				continue;
 			}
Index: linux-2.6/fs/reiserfs/journal.c
===================================================================
--- linux-2.6.orig/fs/reiserfs/journal.c	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/fs/reiserfs/journal.c	2007-05-09 13:57:33.000000000 +1000
@@ -830,7 +830,7 @@
 		jh = JH_ENTRY(list->next);
 		bh = jh->bh;
 		get_bh(bh);
-		if (test_set_buffer_locked(bh)) {
+		if (!trylock_buffer(bh)) {
 			if (!buffer_dirty(bh)) {
 				list_move(&jh->list, &tmp);
 				goto loop_next;
@@ -3838,7 +3838,7 @@
 {
 	PROC_INFO_INC(p_s_sb, journal.prepare);
 
-	if (test_set_buffer_locked(bh)) {
+	if (!trylock_buffer(bh)) {
 		if (!wait)
 			return 0;
 		lock_buffer(bh);
Index: linux-2.6/Documentation/memory-barriers.txt
===================================================================
--- linux-2.6.orig/Documentation/memory-barriers.txt	2007-05-09 13:56:56.000000000 +1000
+++ linux-2.6/Documentation/memory-barriers.txt	2007-05-09 13:57:33.000000000 +1000
@@ -1479,7 +1479,8 @@
 
 Any atomic operation that modifies some state in memory and returns information
 about the state (old or new) implies an SMP-conditional general memory barrier
-(smp_mb()) on each side of the actual operation.  These include:
+(smp_mb()) on each side of the actual operation (with the exception of
+explicit lock operations, described later).  These include:
 
 	xchg();
 	cmpxchg();
@@ -1536,10 +1537,19 @@
 do need memory barriers as a lock primitive generally has to do things in a
 specific order.
 
-
 Basically, each usage case has to be carefully considered as to whether memory
 barriers are needed or not.
 
+The following operations are special locking primitives:
+
+	test_and_set_bit_lock();
+	clear_bit_unlock();
+
+These implement LOCK-class and UNLOCK-class operations, respectively. These
+should be used in preference to other operations when implementing locking
+primitives, because their implementations can be optimised on many
+architectures.
+
 [!] Note that special memory barrier primitives are available for these
 situations because on some CPUs the atomic instructions used imply full memory
 barriers, and so barrier instructions are superfluous in conjunction with them,
