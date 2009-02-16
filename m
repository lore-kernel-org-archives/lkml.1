Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZBPWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZBPWmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 17:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750783AbZBPWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 17:42:33 -0500
Received: from 36-99-st.zelcom.ru ([80.92.99.36]:63219 "EHLO edward.zelnet.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750749AbZBPWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 17:42:32 -0500
From: Edward Shishkin <edward.shishkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18841.60432.329341.514726@edward.zelnet.ru>
Date: Tue, 17 Feb 2009 01:43:28 +0300
To: Peter Zijlstra <peterz@infradead.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Ryan Hope <rmh3093@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
In-Reply-To: <1234645893.4695.8.camel@laptop>
References: <18837.24581.181196.569183@edward.zelnet.ru>
	<1234530519.6519.46.camel@twins>
	<49957C43.7050701@gmail.com>
	<1234534150.6519.101.camel@twins>
	<18838.49922.215481.399653@edward.zelnet.ru>
	<1234645893.4695.8.camel@laptop>
X-Mailer: VM 7.17 under 21.5  (beta28) "fuki" (+CVS-20070806) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:
[...]
 > Maybe something like
 > 
 > /*
 >  * set_page_dirty_notag() -- similar to __set_page_dirty_nobuffers()
 >  * except it doesn't tag the page dirty in the page-cache radix tree.
 >  * This means that the address space using this cannot use the regular
 >  * filemap ->writepages() helpers and must provide its own means of
 >  * tracking and finding dirty pages.
 >  *
 >  * NOTE: furthermore, this version also doesn't handle truncate races.
 >  */
 > 

Yup, your version is better. I just have replaced
^finding dirty pages^finding non-tagged dirty pages,
see below..


 > > +int set_page_dirty_notag(struct page *page)
 > > +{
 > > +	struct address_space *mapping = page->mapping;
 > > +
 > > +	if (!TestSetPageDirty(page)) {
 > > +		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 > > +		if (mapping_cap_account_dirty(mapping)) {
 > > +		        /*
 > > +			 * Since we don't tag the page as dirty,
 > > +			 * acquiring the tree_lock is replaced
 > > +			 * with disabling preemption to protect
 > > +			 * per-cpu data used for accounting.
 > > +			 */
 > 
 > This should be local_irq_save(flags)
 > 
 > > +			preempt_disable();
 > > +			__inc_zone_page_state(page, NR_FILE_DIRTY);
 > > +			__inc_bdi_stat(mapping->backing_dev_info,
 > > +				       BDI_RECLAIMABLE);
 > > +			task_dirty_inc(current);
 > > +			task_io_account_write(PAGE_CACHE_SIZE);
 > > +			preempt_enable();
 > 
 > local_irq_restore()
 > 
 > These accounting functions rely on being atomic wrt interrupts.
 > 

Thanks!

 > > +		}
 > > +		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 > > +		return 1;
 > > +	}
 > > +	return 0;
 > > +}
 > > +EXPORT_SYMBOL(set_page_dirty_notag);
 > 
 > How much performance gain do you see by avoiding that radix tree op? 
 > 

Nop. We want to use it with extended semantics.
All dirty pages are divided into 2 categories:

A) tagged in the radix tree (with PAGECACHE_TAG_DIRTY).
B) captured by atoms (usual linked lists).

reiser4_writepages() looks for pages of "A" in the radix tree
and moves them to "B". set_page_dirty_notag(), introduced by
my patch, is needed for pages of "B".

If "B" is empty, then we get the traditional semantics with
regular ->writepages().

That's all!

 > I take it the only reason you don't use the regular
 > __set_page_dirty_nobuffers() and just clear the tag when you do the
 > write-out by whatever alternative means you have to find the page, is
 > that it gains you some performance.
 > 
 > It would be good to have some numbers to judge this on.
 > 

So, performance is not a concern. We want to extend
functionality, which is currently restricted by the unnecessary(*)
property "dirty bit is set <=> dirty tag is installed".

(*) Reiser4 successfully uses such design since 2002.
I don't remember any BUG_ONs, and related problems.

Please, consider the appended patch.

Thanks,
Edward.

Add set_page_dirty_notag() to the core library to enable
extended functionality of radix tree attached to inode->i_mapping.

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
---
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

--- mmotm.orig/include/linux/mm.h
+++ mmotm/include/linux/mm.h
@@ -841,6 +841,7 @@ int redirty_page_for_writepage(struct wr
 				struct page *page);
 int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
+int set_page_dirty_notag(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
 extern unsigned long move_page_tables(struct vm_area_struct *vma,
--- mmotm.orig/mm/page-writeback.c
+++ mmotm/mm/page-writeback.c
@@ -1248,6 +1248,42 @@ int __set_page_dirty_nobuffers(struct pa
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
+ * set_page_dirty_notag() -- similar to __set_page_dirty_nobuffers()
+ * except it doesn't tag the page dirty in the page-cache radix tree.
+ * This means that the address space using this cannot use the regular
+ * filemap ->writepages() helpers and must provide its own means of
+ * tracking and finding non-tagged dirty pages.
+ *
+ * NOTE: furthermore, this version also doesn't handle truncate races.
+ */
+int set_page_dirty_notag(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	if (!TestSetPageDirty(page)) {
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		if (mapping_cap_account_dirty(mapping)) {
+		        /*
+			 * The accounting functions rely on
+			 * being atomic wrt interrupts.
+			 */
+		        unsigned long flags;
+			local_irq_save(flags);
+			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			__inc_bdi_stat(mapping->backing_dev_info,
+				       BDI_RECLAIMABLE);
+			task_dirty_inc(current);
+			task_io_account_write(PAGE_CACHE_SIZE);
+			local_irq_restore(flags);
+		}
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(set_page_dirty_notag);
+
+/*
  * When a writepage implementation decides that it doesn't want to write this
  * page for some reason, it should redirty the locked page via
  * redirty_page_for_writepage() and it should then unlock the page and return 0
