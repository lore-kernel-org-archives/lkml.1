Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZAEBsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZAEBsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 20:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbZAEBs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 20:48:26 -0500
Received: from mx1.suse.de ([195.135.220.2]:43641 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbZAEBs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 20:48:26 -0500
Date: Mon, 5 Jan 2009 02:48:21 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Klotz <peter.klotz@aon.at>, Roman Kononov <kernel@kononov.ftml.net>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: BUG: soft lockup - is this XFS problem?
Message-ID: <20090105014821.GA367@wotan.suse.de>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103214443.GA6612@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 03, 2009 at 04:44:43PM -0500, Christoph Hellwig wrote:
> On Tue, Dec 30, 2008 at 05:23:33AM +0100, Nick Piggin wrote:
> > On Tue, Dec 23, 2008 at 12:12:59PM -0500, Christoph Hellwig wrote:
> > > 
> > > Nick, I've seen various reports like this by Roman.  It seems to be
> > > caused by an interaction of the lockless pagecache with the xfs
> > > I/O code.  Any idea what might be wrong here:
> > 
> > Hmm, it could get into a loop here if there is a page in the pagecache
> > with a zero refcount, which might be a problem with XFS... other looping
> > conditions might indicate a problem iwth lockless pagecache or radix
> > tree. It would be very helpful to know what condition it is looping on...
> 
> See http://oss.sgi.com/bugzilla/show_bug.cgi?id=805

OK.. Hmm, well here is a modification to your patch which might help further.
I'll see if I can reproduce it here meanwhile.

---
 mm/filemap.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -770,11 +770,13 @@ EXPORT_SYMBOL(find_or_create_page);
  * find_get_pages() returns the number of pages which were found.
  */
 unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
-			    unsigned int nr_pages, struct page **pages)
+			    unsigned int nr_pages,
+			    struct page **pages)
 {
 	unsigned int i;
 	unsigned int ret;
 	unsigned int nr_found;
+	int locked = 0;
 
 	rcu_read_lock();
 restart:
@@ -785,27 +787,46 @@ restart:
 		struct page *page;
 repeat:
 		page = radix_tree_deref_slot((void **)pages[i]);
-		if (unlikely(!page))
+		if (unlikely(!page)) {
+			if (printk_ratelimit())
+				printk(KERN_INFO "unable to deref page\n");
 			continue;
+		}
+
 		/*
 		 * this can only trigger if nr_found == 1, making livelock
 		 * a non issue.
 		 */
-		if (unlikely(page == RADIX_TREE_RETRY))
+		if (unlikely(page == RADIX_TREE_RETRY)) {
+			printk(KERN_INFO "got RADIX_TREE_RETRY\n");
 			goto restart;
+		}
 
-		if (!page_cache_get_speculative(page))
+		if (!page_cache_get_speculative(page)) {
+			/* If the page is in the radix-tree, and the radix-tree
+			 * is locked, the page must have a non-zero refcount */
+			BUG_ON(locked);
+			printk(KERN_INFO "page_cache_get failed\n");
+			spin_lock_irq(&mapping->tree_lock);
+			locked = 1;
 			goto repeat;
+		}
 
 		/* Has the page moved? */
 		if (unlikely(page != *((void **)pages[i]))) {
+			BUG_ON(locked);
+			printk(KERN_INFO "page moved\n");
 			page_cache_release(page);
+			spin_lock_irq(&mapping->tree_lock);
+			locked = 1;
 			goto repeat;
 		}
 
 		pages[ret] = page;
 		ret++;
 	}
+	if (locked)
+		spin_unlock_irq(&mapping->tree_lock);
 	rcu_read_unlock();
 	return ret;
 }
