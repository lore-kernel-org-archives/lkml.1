Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYG1Fun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYG1Fun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 01:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYG1Fue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 01:50:34 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:53191 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751062AbYG1Fud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 01:50:33 -0400
To: a.p.zijlstra@chello.nl
Cc: nickpiggin@yahoo.com.au, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fix task dirty balancing
In-Reply-To: Your message of "Fri, 25 Jul 2008 11:57:52 +0200"
	<1216979872.7257.361.camel@twins>
References: <1216979872.7257.361.camel@twins>
X-Mailer: Cue version 0.8 (080625-0732/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20080728055031.DB0BF5A5D@siro.lan>
Date: Mon, 28 Jul 2008 14:50:31 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> > @@ -1074,8 +1074,13 @@ int __set_page_dirty_no_writeback(struct page *page)
> >   */
> >  int __set_page_dirty_nobuffers(struct page *page)
> >  {
> > -	if (!TestSetPageDirty(page)) {
> > -		struct address_space *mapping = page_mapping(page);
> > +	struct address_space *mapping;
> > +
> > +	if (TestSetPageDirty(page))
> > +		return 0;
> > +
> > +	mapping = page_mapping(page);
> > +	if (likely(mapping)) {
> >  		struct address_space *mapping2;
> >  
> >  		if (!mapping)
> 
> This results in funny code..

oops, you're right.
i removed the dead code.

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
index 29b1d1e..3062f26 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -176,7 +176,7 @@ void bdi_writeout_inc(struct backing_dev_info *bdi)
 }
 EXPORT_SYMBOL_GPL(bdi_writeout_inc);
 
-static inline void task_dirty_inc(struct task_struct *tsk)
+void task_dirty_inc(struct task_struct *tsk)
 {
 	prop_inc_single(&vm_dirties, &tsk->dirties);
 }
@@ -1074,12 +1074,14 @@ int __set_page_dirty_no_writeback(struct page *page)
  */
 int __set_page_dirty_nobuffers(struct page *page)
 {
-	if (!TestSetPageDirty(page)) {
-		struct address_space *mapping = page_mapping(page);
-		struct address_space *mapping2;
+	struct address_space *mapping;
 
-		if (!mapping)
-			return 1;
+	if (TestSetPageDirty(page))
+		return 0;
+
+	mapping = page_mapping(page);
+	if (likely(mapping)) {
+		struct address_space *mapping2;
 
 		spin_lock_irq(&mapping->tree_lock);
 		mapping2 = page_mapping(page);
@@ -1100,9 +1102,11 @@ int __set_page_dirty_nobuffers(struct page *page)
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
 
@@ -1122,7 +1126,7 @@ EXPORT_SYMBOL(redirty_page_for_writepage);
  * If the mapping doesn't provide a set_page_dirty a_op, then
  * just fall through and assume that it wants buffer_heads.
  */
-static int __set_page_dirty(struct page *page)
+int set_page_dirty(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 
@@ -1140,14 +1144,6 @@ static int __set_page_dirty(struct page *page)
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
