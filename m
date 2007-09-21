Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbXIUOxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbXIUOxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760414AbXIUOuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:50:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188AbXIUOty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 19/22] AFS: Improve handling of a rejected writeback
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Fri, 21 Sep 2007 15:48:41 +0100
Message-ID: <20070921144840.8323.36854.stgit@warthog.procyon.org.uk>
In-Reply-To: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
References: <20070921144703.8323.50492.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the handling of the case of a server rejecting an attempt to write back
a cached write.  AFS operates a write-back cache, so the following sequence of
events can theoretically occur:

	CLIENT 1		CLIENT 2
	=======================	=======================
	cat data >/the/file
	 (sits in pagecache)
				fs setacl -dir /the/dir/of/the/file \
					-acl system:administrators rlidka
				 (write permission removed for client 1)
	sync
	 (writeback attempt fails)

The way AFS attempts to handle this is:

 (1) The affected region will be excised and discarded on the basis that it
     can't be written back, yet we don't want it lurking in the page cache
     either.  The contents of the affected region will be reread from the
     server when called for again.

 (2) The EOF size will be set to the current server-based file size - usually
     that which it was before the affected write was made - assuming no
     conflicting write has been appended, and assuming the affected write
     extended the file.


This patch makes the following changes:

 (1) Zero-length short reads don't produce EBADMSG now just because the OpenAFS
     server puts a silly value as the size of the returned data.  This prevents
     excised pages beyond the revised EOF being reinstantiated with a surprise
     PG_error.

 (2) Writebacks can now be put into a 'rejected' state in which all further
     attempts to write them back will result in excision of the affected pages
     instead.

 (3) Preparing a page for overwriting now reads the whole page instead of just
     those parts of it that aren't to be covered by the copy to be made.  This
     handles the possibility that the copy might fail on EFAULT.  Corollary to
     this, PG_update can now be set by afs_prepare_page() on behalf of
     afs_prepare_write() rather than setting it in afs_commit_write().

 (4) In the case of a conflicting write, afs_prepare_write() will attempt to
     flush the write to the server, and will then wait for PG_writeback to go
     away - after unlocking the page.  This helps prevent deadlock against the
     writeback-rejection handler.  AOP_TRUNCATED_PAGE is then returned to the
     caller to signify that the page has been unlocked, and that it should be
     revalidated.

 (5) The writeback-rejection handler now calls cancel_rejected_write() added by
     the previous patch to excise the affected pages rather than clearing the
     PG_uptodate flag on all the pages.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/fsclient.c |    4 +
 fs/afs/internal.h |    1 
 fs/afs/write.c    |  154 ++++++++++++++++++++++++++++-------------------------
 3 files changed, 85 insertions(+), 74 deletions(-)

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 023b95b..04584c0 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -353,7 +353,9 @@ static int afs_deliver_fs_fetch_data(struct afs_call *call,
 
 		call->count = ntohl(call->tmp);
 		_debug("DATA length: %u", call->count);
-		if (call->count > PAGE_SIZE)
+		if ((s32) call->count < 0)
+			call->count = 0; /* access completely beyond EOF */
+		else if (call->count > PAGE_SIZE)
 			return -EBADMSG;
 		call->offset = 0;
 		call->unmarshall++;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 6306438..e1bcce0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -156,6 +156,7 @@ struct afs_writeback {
 		AFS_WBACK_PENDING,		/* write pending */
 		AFS_WBACK_CONFLICTING,		/* conflicting writes posted */
 		AFS_WBACK_WRITING,		/* writing back */
+		AFS_WBACK_REJECTED,		/* the writeback was rejected */
 		AFS_WBACK_COMPLETE		/* the writeback record has been unlinked */
 	} state __attribute__((packed));
 };
diff --git a/fs/afs/write.c b/fs/afs/write.c
index a03b92a..ac621e8 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -81,18 +81,16 @@ void afs_put_writeback(struct afs_writeback *wb)
 }
 
 /*
- * partly or wholly fill a page that's under preparation for writing
+ * fill a page that's under preparation for writing
  */
 static int afs_fill_page(struct afs_vnode *vnode, struct key *key,
-			 unsigned start, unsigned len, struct page *page)
+			 unsigned len, struct page *page)
 {
 	int ret;
 
-	_enter(",,%u,%u", start, len);
+	_enter(",,%u,", len);
 
-	ASSERTCMP(start + len, <=, PAGE_SIZE);
-
-	ret = afs_vnode_fetch_data(vnode, key, start, len, page);
+	ret = afs_vnode_fetch_data(vnode, key, 0, len, page);
 	if (ret < 0) {
 		if (ret == -ENOENT) {
 			_debug("got NOENT from server"
@@ -110,18 +108,15 @@ static int afs_fill_page(struct afs_vnode *vnode, struct key *key,
  * prepare a page for being written to
  */
 static int afs_prepare_page(struct afs_vnode *vnode, struct page *page,
-			    struct key *key, unsigned offset, unsigned to)
+			    struct key *key)
 {
-	unsigned eof, tail, start, stop, len;
+	unsigned len;
 	loff_t i_size, pos;
 	void *p;
 	int ret;
 
 	_enter("");
 
-	if (offset == 0 && to == PAGE_SIZE)
-		return 0;
-
 	p = kmap_atomic(page, KM_USER0);
 
 	i_size = i_size_read(&vnode->vfs_inode);
@@ -129,10 +124,7 @@ static int afs_prepare_page(struct afs_vnode *vnode, struct page *page,
 	if (pos >= i_size) {
 		/* partial write, page beyond EOF */
 		_debug("beyond");
-		if (offset > 0)
-			memset(p, 0, offset);
-		if (to < PAGE_SIZE)
-			memset(p + to, 0, PAGE_SIZE - to);
+		memset(p, 0, PAGE_SIZE);
 		kunmap_atomic(p, KM_USER0);
 		return 0;
 	}
@@ -140,31 +132,20 @@ static int afs_prepare_page(struct afs_vnode *vnode, struct page *page,
 	if (i_size - pos >= PAGE_SIZE) {
 		/* partial write, page entirely before EOF */
 		_debug("before");
-		tail = eof = PAGE_SIZE;
+		len = PAGE_SIZE;
 	} else {
 		/* partial write, page overlaps EOF */
-		eof = i_size - pos;
-		_debug("overlap %u", eof);
-		tail = max(eof, to);
-		if (tail < PAGE_SIZE)
-			memset(p + tail, 0, PAGE_SIZE - tail);
-		if (offset > eof)
-			memset(p + eof, 0, PAGE_SIZE - eof);
+		len = i_size - pos;
+		_debug("overlap %u", len);
+		ASSERTRANGE(0, <, len, <, PAGE_SIZE);
+		memset(p + len, 0, PAGE_SIZE - len);
 	}
 
 	kunmap_atomic(p, KM_USER0);
 
-	ret = 0;
-	if (offset > 0 || eof > to) {
-		/* need to fill one or two bits that aren't going to be written
-		 * (cover both fillers in one read if there are two) */
-		start = (offset > 0) ? 0 : to;
-		stop = (eof > to) ? eof : offset;
-		len = stop - start;
-		_debug("wr=%u-%u av=0-%u rd=%u@%u",
-		       offset, to, eof, start, len);
-		ret = afs_fill_page(vnode, key, start, len, page);
-	}
+	ret = afs_fill_page(vnode, key, len, page);
+	if (ret == 0)
+		SetPageUptodate(page);
 
 	_leave(" = %d", ret);
 	return ret;
@@ -187,6 +168,8 @@ int afs_prepare_write(struct file *file, struct page *page,
 	_enter("{%x:%u},{%lx},%u,%u",
 	       vnode->fid.vid, vnode->fid.vnode, page->index, offset, to);
 
+	BUG_ON(PageError(page));
+
 	candidate = kzalloc(sizeof(*candidate), GFP_KERNEL);
 	if (!candidate)
 		return -ENOMEM;
@@ -200,7 +183,7 @@ int afs_prepare_write(struct file *file, struct page *page,
 
 	if (!PageUptodate(page)) {
 		_debug("not up to date");
-		ret = afs_prepare_page(vnode, page, key, offset, to);
+		ret = afs_prepare_page(vnode, page, key);
 		if (ret < 0) {
 			kfree(candidate);
 			_leave(" = %d [prep]", ret);
@@ -269,21 +252,41 @@ flush_conflicting_wb:
 	_debug("flush conflict");
 	if (wb->state == AFS_WBACK_PENDING)
 		wb->state = AFS_WBACK_CONFLICTING;
+	wb->usage++;
 	spin_unlock(&vnode->writeback_lock);
-	if (PageDirty(page)) {
+	if (!PageDirty(page) && !PageWriteback(page)) {
+		/* no change outstanding - just reuse the page */
+		_debug("reuse");
+		afs_put_writeback(wb);
+		set_page_private(page, 0);
+		ClearPagePrivate(page);
+		goto try_again;
+	}
+
+	kfree(candidate);
+
+	/* if we're busy writing back a conflicting write, then unlock the page
+	 * and wait for the writeback to complete - this lets the process doing
+	 * the write-out handle rejection without deadlock */
+	if (PageWriteback(page)) {
+		_debug("wait wb");
+		unlock_page(page);
+	} else {
+		/* there's a conflicting modification we have to write back and
+		 * wait for before letting the next one proceed */
+		_debug("dirty");
 		ret = afs_write_back_from_locked_page(wb, page);
 		if (ret < 0) {
-			afs_put_writeback(candidate);
+			afs_put_writeback(wb);
 			_leave(" = %d", ret);
 			return ret;
 		}
 	}
 
-	/* the page holds a ref on the writeback record */
 	afs_put_writeback(wb);
-	set_page_private(page, 0);
-	ClearPagePrivate(page);
-	goto try_again;
+	wait_on_page_writeback(page);
+	_leave(" = A_T_P");
+	return AOP_TRUNCATED_PAGE;
 }
 
 /*
@@ -310,7 +313,6 @@ int afs_commit_write(struct file *file, struct page *page,
 		spin_unlock(&vnode->writeback_lock);
 	}
 
-	SetPageUptodate(page);
 	set_page_dirty(page);
 	if (PageDirty(page))
 		_debug("dirtied");
@@ -319,38 +321,35 @@ int afs_commit_write(struct file *file, struct page *page,
 }
 
 /*
- * kill all the pages in the given range
+ * note the failure of a write, either due to an error or to a permission
+ * failure
+ * - all the pages in the affected range must have PG_writeback set
+ * - the caller must be responsible for the pages: no-one else should be trying
+ *   to note rejection
  */
-static void afs_kill_pages(struct afs_vnode *vnode, bool error,
-			   pgoff_t first, pgoff_t last)
+static void afs_write_rejected(struct afs_writeback *wb, bool error,
+			       pgoff_t first, pgoff_t last)
 {
-	struct pagevec pv;
-	unsigned count, loop;
+	struct afs_vnode *vnode = wb->vnode;
+	loff_t i_size;
 
 	_enter("{%x:%u},%lx-%lx",
 	       vnode->fid.vid, vnode->fid.vnode, first, last);
 
-	pagevec_init(&pv, 0);
-
-	do {
-		_debug("kill %lx-%lx", first, last);
-
-		count = last - first + 1;
-		if (count > PAGEVEC_SIZE)
-			count = PAGEVEC_SIZE;
-		pv.nr = find_get_pages_contig(vnode->vfs_inode.i_mapping,
-					      first, count, pv.pages);
-		ASSERTCMP(pv.nr, ==, count);
-
-		for (loop = 0; loop < count; loop++) {
-			ClearPageUptodate(pv.pages[loop]);
-			if (error)
-				SetPageError(pv.pages[loop]);
-			end_page_writeback(pv.pages[loop]);
-		}
+	spin_lock(&vnode->writeback_lock);
+	wb->state = AFS_WBACK_REJECTED;
+
+	/* wind back the file size if this write extended the file, and wasn't
+	 * followed by a conflicting write */
+	i_size = ((loff_t) wb->last) << PAGE_SHIFT;
+	i_size += wb->to_last;
+	if (i_size_read(&vnode->vfs_inode) == i_size) {
+		_debug("shorten");
+		i_size_write(&vnode->vfs_inode, vnode->status.size);
+	}
 
-		__pagevec_release(&pv);
-	} while (first < last);
+	spin_unlock(&vnode->writeback_lock);
+	cancel_rejected_write(vnode->vfs_inode.i_mapping, first, last);
 
 	_leave("");
 }
@@ -358,6 +357,7 @@ static void afs_kill_pages(struct afs_vnode *vnode, bool error,
 /*
  * synchronously write back the locked page and any subsequent non-locked dirty
  * pages also covered by the same writeback record
+ * - all pages written will be unlocked prior to returning
  */
 static int afs_write_back_from_locked_page(struct afs_writeback *wb,
 					   struct page *primary_page)
@@ -407,6 +407,7 @@ static int afs_write_back_from_locked_page(struct afs_writeback *wb,
 			if (TestSetPageLocked(page))
 				break;
 			if (!PageDirty(page) ||
+			    PageWriteback(page) ||
 			    page_private(page) != (unsigned long) wb) {
 				unlock_page(page);
 				break;
@@ -430,14 +431,22 @@ static int afs_write_back_from_locked_page(struct afs_writeback *wb,
 
 no_more:
 	/* we now have a contiguous set of dirty pages, each with writeback set
-	 * and the dirty mark cleared; the first page is locked and must remain
-	 * so, all the rest are unlocked */
+	 * and the dirty mark cleared; all the pages barring the first are now
+	 * unlocked */
 	first = primary_page->index;
 	last = first + count - 1;
+	unlock_page(primary_page);
 
 	offset = (first == wb->first) ? wb->offset_first : 0;
 	to = (last == wb->last) ? wb->to_last : PAGE_SIZE;
 
+	if (wb->state == AFS_WBACK_REJECTED) {
+		cancel_rejected_write(wb->vnode->vfs_inode.i_mapping,
+				      first, last);
+		ret = 0;
+		goto out;
+	}
+
 	_debug("write back %lx[%u..] to %lx[..%u]", first, offset, last, to);
 
 	ret = afs_vnode_store_data(wb, first, last, offset, to);
@@ -455,7 +464,7 @@ no_more:
 		case -ENOENT:
 		case -ENOMEDIUM:
 		case -ENXIO:
-			afs_kill_pages(wb->vnode, true, first, last);
+			afs_write_rejected(wb, true, first, last);
 			set_bit(AS_EIO, &wb->vnode->vfs_inode.i_mapping->flags);
 			break;
 		case -EACCES:
@@ -464,7 +473,7 @@ no_more:
 		case -EKEYEXPIRED:
 		case -EKEYREJECTED:
 		case -EKEYREVOKED:
-			afs_kill_pages(wb->vnode, false, first, last);
+			afs_write_rejected(wb, false, first, last);
 			break;
 		default:
 			break;
@@ -473,6 +482,7 @@ no_more:
 		ret = count;
 	}
 
+out:
 	_leave(" = %d", ret);
 	return ret;
 }
@@ -493,7 +503,6 @@ int afs_writepage(struct page *page, struct writeback_control *wbc)
 	ASSERT(wb != NULL);
 
 	ret = afs_write_back_from_locked_page(wb, page);
-	unlock_page(page);
 	if (ret < 0) {
 		_leave(" = %d", ret);
 		return 0;
@@ -565,7 +574,6 @@ int afs_writepages_region(struct address_space *mapping,
 		spin_unlock(&wb->vnode->writeback_lock);
 
 		ret = afs_write_back_from_locked_page(wb, page);
-		unlock_page(page);
 		page_cache_release(page);
 		if (ret < 0) {
 			_leave(" = %d", ret);

