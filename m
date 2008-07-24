Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbYGXA10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbYGXA10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757074AbYGXA1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:27:09 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:45538 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757058AbYGXA1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:27:07 -0400
To: nickpiggin@yahoo.com.au
Cc: a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fix task dirty balancing
In-Reply-To: Your message of "Thu, 10 Jul 2008 17:23:36 +1000"
	<200807101723.36713.nickpiggin@yahoo.com.au>
References: <200807101723.36713.nickpiggin@yahoo.com.au>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080724002706.008305A56@siro.lan>
Date: Thu, 24 Jul 2008 09:27:05 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> On Thursday 10 July 2008 13:10, YAMAMOTO Takashi wrote:
> > hi,
> >
> > thanks for the review.
> >
> > > On Wednesday 09 July 2008 09:38, YAMAMOTO Takashi wrote:
> > > > hi,
> > > >
> > > > > Please beat me to cleaning up this stuff - otherwise I'll have to
> > > > > look at it when I get back from holidays.
> > > >
> > > > how about the following?
> > >
> > > Quite good, however I would like to keep the buffers warning if it isn't
> > > too difficult (it has already caught one or two real bugs).
> >
> > isn't the WARN_ON_ONCE in __set_page_dirty_nobuffers enough?
> 
> No, because it will skip warning if the page has buffers (which is a
> very common case for fs/buffer.c :)).

i see.  thanks.

> > > Also, we should
> > > split out the bugfix from the cleanup. But yes overall I think the result
> > > looks quite nice.
> >
> > honestly, i don't think it makes much sense to separate the fix and
> > the cleanup in this particular case.  trying to keep the bug while
> > the code cleanup naturally fixes it, or vice versa, would be a waste
> > of time.
> 
> It always makes sense to separate fix and cleanup IMO. The most important
> reason is that it makes it clearer to review the fix. Secondarily, it
> makes it easier to ensure no unwanted changes in the cleanup part.

ok, i removed the cleanup part because i don't want to participate in
this kind of discussion.  is the following patch ok for you?

YAMAMOTO Takashi


Signed-off-by: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
---

diff --git a/fs/buffer.c b/fs/buffer.c
index 4ffb5bb..3a89d58 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -708,27 +708,29 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
 static int __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
-	if (unlikely(!mapping))
-		return !TestSetPageDirty(page);
 
 	if (TestSetPageDirty(page))
 		return 0;
 
-	spin_lock_irq(&mapping->tree_lock);
-	if (page->mapping) {	/* Race with truncate? */
-		WARN_ON_ONCE(warn && !PageUptodate(page));
+	if (likely(mapping)) {
+		spin_lock_irq(&mapping->tree_lock);
+		if (page->mapping) {	/* Race with truncate? */
+			WARN_ON_ONCE(warn && !PageUptodate(page));
 
-		if (mapping_cap_account_dirty(mapping)) {
-			__inc_zone_page_state(page, NR_FILE_DIRTY);
-			__inc_bdi_stat(mapping->backing_dev_info,
-					BDI_RECLAIMABLE);
-			task_io_account_write(PAGE_CACHE_SIZE);
+			if (mapping_cap_account_dirty(mapping)) {
+				__inc_zone_page_state(page, NR_FILE_DIRTY);
+				__inc_bdi_stat(mapping->backing_dev_info,
+						BDI_RECLAIMABLE);
+				task_io_account_write(PAGE_CACHE_SIZE);
+			}
+			radix_tree_tag_set(&mapping->page_tree,
+					page_index(page), PAGECACHE_TAG_DIRTY);
 		}
-		radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
+		spin_unlock_irq(&mapping->tree_lock);
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 	}
-	spin_unlock_irq(&mapping->tree_lock);
-	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+
+	task_dirty_inc(current);
 
 	return 1;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a4eeb3c..33fd91a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1167,6 +1167,7 @@ extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
 
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
+void task_dirty_inc(struct task_struct *tsk);
 
 /* readahead.c */
 #define VM_MAX_READAHEAD	128	/* kbytes */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 29b1d1e..382f742 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -176,10 +176,11 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL_GPL(bdi_writeout_inc);
 
-static inline void task_dirty_inc(struct task_struct *tsk)
+void task_dirty_inc(struct task_struct *tsk)
 {
 	prop_inc_single(&vm_dirties, &tsk->dirties);
 }
+EXPORT_SYMBOL_GPL(task_dirty_inc);
 
 /*
  * Obtain an accurate fraction of the BDI's portion.
@@ -1074,8 +1075,13 @@ int __set_page_dirty_no_writeback(struct page *page)
  */
 int __set_page_dirty_nobuffers(struct page *page)
 {
-	if (!TestSetPageDirty(page)) {
-		struct address_space *mapping = page_mapping(page);
+	struct address_space *mapping;
+
+	if (TestSetPageDirty(page))
+		return 0;
+
+	mapping = page_mapping(page);
+	if (likely(mapping)) {
 		struct address_space *mapping2;
 
 		if (!mapping)
@@ -1100,9 +1106,11 @@ int __set_page_dirty_nobuffers(struct page *page)
 			/* !PageAnon && !swapper_space */
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 		}
-		return 1;
 	}
-	return 0;
+
+	task_dirty_inc(current);
+
+	return 1;
 }
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
@@ -1122,7 +1130,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
  * If the mapping doesn't provide a set_page_dirty a_op, then
  * just fall through and assume that it wants buffer_heads.
  */
-static int __set_page_dirty(struct page *page)
+int set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -1140,14 +1148,6 @@ static int __set_page_dirty(struct page *page)
 	}
 	return 0;
 }
-
-int set_page_dirty(struct page *page)
-{
-	int ret = __set_page_dirty(page);
-	if (ret)
-		task_dirty_inc(current);
-	return ret;
-}
 EXPORT_SYMBOL(set_page_dirty);
 
 /*
