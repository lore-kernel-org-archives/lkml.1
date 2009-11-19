Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZKSRWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZKSRWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbZKSRWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754731AbZKSRWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/28] CacheFiles: Handle truncate unlocking the page we're
	reading
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:37 +0000
Message-ID: <20091119172237.1679.96864.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle truncate unlocking the page we're attempting to read from the backing
device before the read has completed.

This was causing reports like the following to occur:

	Pid: 4765, comm: kslowd Not tainted 2.6.30.1 #1
	Call Trace:
	 [<ffffffffa0331d7a>] ? cachefiles_read_waiter+0xd9/0x147 [cachefiles]
	 [<ffffffff804b74bd>] ? __wait_on_bit+0x60/0x6f
	 [<ffffffff8022bbbb>] ? __wake_up_common+0x3f/0x71
	 [<ffffffff8022cc32>] ? __wake_up+0x30/0x44
	 [<ffffffff8024a41f>] ? __wake_up_bit+0x28/0x2d
	 [<ffffffffa003a793>] ? ext3_truncate+0x4d7/0x8ed [ext3]
	 [<ffffffff80281f90>] ? pagevec_lookup+0x17/0x1f
	 [<ffffffff8028c2ff>] ? unmap_mapping_range+0x59/0x1ff
	 [<ffffffff8022cc32>] ? __wake_up+0x30/0x44
	 [<ffffffff8028e286>] ? vmtruncate+0xc2/0xe2
	 [<ffffffff802b82cf>] ? inode_setattr+0x22/0x10a
	 [<ffffffffa003baa5>] ? ext3_setattr+0x17b/0x1e6 [ext3]
	 [<ffffffff802b853d>] ? notify_change+0x186/0x2c9
	 [<ffffffffa032d9de>] ? cachefiles_attr_changed+0x133/0x1cd [cachefiles]
	 [<ffffffffa032df7f>] ? cachefiles_lookup_object+0xcf/0x12a [cachefiles]
	 [<ffffffffa0318165>] ? fscache_lookup_object+0x110/0x122 [fscache]
	 [<ffffffffa03188c3>] ? fscache_object_slow_work_execute+0x590/0x6bc
	[fscache]
	 [<ffffffff80278f82>] ? slow_work_thread+0x285/0x43a
	 [<ffffffff8024a446>] ? autoremove_wake_function+0x0/0x2e
	 [<ffffffff80278cfd>] ? slow_work_thread+0x0/0x43a
	 [<ffffffff8024a317>] ? kthread+0x54/0x81
	 [<ffffffff8020c93a>] ? child_rip+0xa/0x20
	 [<ffffffff8024a2c3>] ? kthread+0x0/0x81
	 [<ffffffff8020c930>] ? child_rip+0x0/0x20
	CacheFiles: I/O Error: Readpage failed on backing file 200000000000810
	FS-Cache: Cache cachefiles stopped due to I/O error

Reported-by: Christian Kujau <lists@nerdbynature.de>
Reported-by: Takashi Iwai <tiwai@suse.de>
Reported-by: Duc Le Minh <duclm.vn@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/rdwr.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 93 insertions(+), 6 deletions(-)

diff --git a/fs/cachefiles/rdwr.c b/fs/cachefiles/rdwr.c
index 5a84fd7..1d83325 100644
--- a/fs/cachefiles/rdwr.c
+++ b/fs/cachefiles/rdwr.c
@@ -40,8 +40,10 @@ static int cachefiles_read_waiter(wait_queue_t *wait, unsigned mode,
 
 	_debug("--- monitor %p %lx ---", page, page->flags);
 
-	if (!PageUptodate(page) && !PageError(page))
-		dump_stack();
+	if (!PageUptodate(page) && !PageError(page)) {
+		/* unlocked, not uptodate and not erronous? */
+		_debug("page probably truncated");
+	}
 
 	/* remove from the waitqueue */
 	list_del(&wait->task_list);
@@ -61,6 +63,84 @@ static int cachefiles_read_waiter(wait_queue_t *wait, unsigned mode,
 }
 
 /*
+ * handle a probably truncated page
+ * - check to see if the page is still relevant and reissue the read if
+ *   possible
+ * - return -EIO on error, -ENODATA if the page is gone, -EINPROGRESS if we
+ *   must wait again and 0 if successful
+ */
+static int cachefiles_read_reissue(struct cachefiles_object *object,
+				   struct cachefiles_one_read *monitor)
+{
+	struct address_space *bmapping = object->backer->d_inode->i_mapping;
+	struct page *backpage = monitor->back_page, *backpage2;
+	int ret;
+
+	kenter("{ino=%lx},{%lx,%lx}",
+	       object->backer->d_inode->i_ino,
+	       backpage->index, backpage->flags);
+
+	/* skip if the page was truncated away completely */
+	if (backpage->mapping != bmapping) {
+		kleave(" = -ENODATA [mapping]");
+		return -ENODATA;
+	}
+
+	backpage2 = find_get_page(bmapping, backpage->index);
+	if (!backpage2) {
+		kleave(" = -ENODATA [gone]");
+		return -ENODATA;
+	}
+
+	if (backpage != backpage2) {
+		put_page(backpage2);
+		kleave(" = -ENODATA [different]");
+		return -ENODATA;
+	}
+
+	/* the page is still there and we already have a ref on it, so we don't
+	 * need a second */
+	put_page(backpage2);
+
+	INIT_LIST_HEAD(&monitor->op_link);
+	add_page_wait_queue(backpage, &monitor->monitor);
+
+	if (trylock_page(backpage)) {
+		ret = -EIO;
+		if (PageError(backpage))
+			goto unlock_discard;
+		ret = 0;
+		if (PageUptodate(backpage))
+			goto unlock_discard;
+
+		kdebug("reissue read");
+		ret = bmapping->a_ops->readpage(NULL, backpage);
+		if (ret < 0)
+			goto unlock_discard;
+	}
+
+	/* but the page may have been read before the monitor was installed, so
+	 * the monitor may miss the event - so we have to ensure that we do get
+	 * one in such a case */
+	if (trylock_page(backpage)) {
+		_debug("jumpstart %p {%lx}", backpage, backpage->flags);
+		unlock_page(backpage);
+	}
+
+	/* it'll reappear on the todo list */
+	kleave(" = -EINPROGRESS");
+	return -EINPROGRESS;
+
+unlock_discard:
+	unlock_page(backpage);
+	spin_lock_irq(&object->work_lock);
+	list_del(&monitor->op_link);
+	spin_unlock_irq(&object->work_lock);
+	kleave(" = %d", ret);
+	return ret;
+}
+
+/*
  * copy data from backing pages to netfs pages to complete a read operation
  * - driven by FS-Cache's thread pool
  */
@@ -92,20 +172,26 @@ static void cachefiles_read_copier(struct fscache_operation *_op)
 
 		_debug("- copy {%lu}", monitor->back_page->index);
 
-		error = -EIO;
+	recheck:
 		if (PageUptodate(monitor->back_page)) {
 			copy_highpage(monitor->netfs_page, monitor->back_page);
 
 			pagevec_add(&pagevec, monitor->netfs_page);
 			fscache_mark_pages_cached(monitor->op, &pagevec);
 			error = 0;
-		}
-
-		if (error)
+		} else if (!PageError(monitor->back_page)) {
+			/* the page has probably been truncated */
+			error = cachefiles_read_reissue(object, monitor);
+			if (error == -EINPROGRESS)
+				goto next;
+			goto recheck;
+		} else {
 			cachefiles_io_error_obj(
 				object,
 				"Readpage failed on backing file %lx",
 				(unsigned long) monitor->back_page->flags);
+			error = -EIO;
+		}
 
 		page_cache_release(monitor->back_page);
 
@@ -114,6 +200,7 @@ static void cachefiles_read_copier(struct fscache_operation *_op)
 		fscache_put_retrieval(op);
 		kfree(monitor);
 
+	next:
 		/* let the thread pool have some air occasionally */
 		max--;
 		if (max < 0 || need_resched()) {

