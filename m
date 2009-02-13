Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZBMMGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZBMMGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZBMMGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:06:03 -0500
Received: from 36-99-st.zelcom.ru ([80.92.99.36]:60209 "EHLO edward.zelnet.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754036AbZBMMGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:06:00 -0500
From: Edward Shishkin <edward.shishkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18837.24581.181196.569183@edward.zelnet.ru>
Date: Fri, 13 Feb 2009 14:56:53 +0300
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Ryan Hope <rmh3093@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Edward Shishkin <edward.shishkin@gmail.com>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: [patch 2/4] vfs: add set_page_dirty_notag
X-Mailer: VM 7.17 under 21.5  (beta28) "fuki" (+CVS-20070806) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, please, review.
I'll change things, if needed..

This is a fixup for the following "todo":
akpm wrote:
> reiser4_set_page_dirty_internal() pokes around in VFS internals.
> Use __set_page_dirty_no_buffers() or create a new library function
> in mm/page-writeback.c.

Problem:

In accordance with reiser4 transactional model every dirty page
should be "captured" by some atom. However, outside reiser4 context
dirty page can not be captured in some cases, as it is accompanied
with specific work (jnode creation, etc). Reiser4 recognizes such
"anonymous" pages (i.e. pages that were dirtied outside of reiser4)
by the tag PAGECACHE_TAG_DIRTY. Pages dirtied inside reiser4 context
are not tagged at all: we don't need this. Indeed, once page is
dirtied and captured, it is attached to a jnode (a special header
to keep a track of transactions).

reiser4_set_page_dirty_internal() was the internal reiser4 function
that set dirty bit without tagging the page. Having such internal
function led to real problems (incorrect task io accounting, etc.
because of not updating this internal "friend").

Solution:

The following patch adds a core library function that sets a dirty
bit without tagging the page. It should be modified simultaneously
with its "friends": __set_page_dirty_nobuffers, __set_page_dirty.

Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
---
 include/linux/mm.h  |    1 +
 mm/page-writeback.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

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
@@ -1248,6 +1248,34 @@ int __set_page_dirty_nobuffers(struct pa
 EXPORT_SYMBOL(__set_page_dirty_nobuffers);
 
 /*
+ * The same as __set_page_dirty_nobuffers, but this function
+ * 1) doesn't tag the page in its radix tree;
+ * 2) makes an assumption that there is no races with truncate.
+ * 3) is not for anonymous or swap pages.
+ */
+int set_page_dirty_notag(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+
+	if (!TestSetPageDirty(page)) {
+		WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
+		if (mapping_cap_account_dirty(mapping)) {
+			preempt_disable();
+			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			__inc_bdi_stat(mapping->backing_dev_info,
+				       BDI_RECLAIMABLE);
+			task_dirty_inc(current);
+			task_io_account_write(PAGE_CACHE_SIZE);
+			preempt_enable();
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
