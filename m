Return-Path: <linux-kernel-owner+w=401wt.eu-S1751481AbXEXPlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbXEXPlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750738AbXEXPl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:41:28 -0400
Received: from mx2.netapp.com ([216.240.18.37]:65093 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbXEXPl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:41:27 -0400
X-IronPort-AV: E=Sophos;i="4.14,574,1170662400"; 
   d="scan'208";a="62289700"
Subject: [GIT pull] 3 more NFS client fixes for 2.6.22-rc2
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       "Mr. Charles Edward Lever" <Chuck.Lever@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Thu, 24 May 2007 11:41:16 -0400
Message-Id: <1180021276.6413.68.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 24 May 2007 15:41:25.0841 (UTC) FILETIME=[FCF19410:01C79E19]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "fixes" branch of the repository at

   git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git fixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/direct.c          |   53 ++++++++++++++++++++++++++++-----------------
 fs/nfs/pagelist.c        |   20 +++++++++++++++++
 fs/nfs/write.c           |    6 +++-
 include/linux/nfs_page.h |    1 +
 4 files changed, 58 insertions(+), 22 deletions(-)

commit d4a8f3677fe2c2fc86443254fe42825e244c194d
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Tue May 22 10:22:27 2007 -0400

    NFS: Fix nfs_direct_dirty_pages()
    
    We only need to dirty the pages that were actually read in.
    
    Also convert nfs_direct_dirty_pages() to call set_page_dirty() instead of
    set_page_dirty_lock(). A call to lock_page() is unacceptable in an rpciod
    callback function.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 749e146e01cf87ce3c1d6f6077b877471b04df5b
Author: Chuck Lever <chuck.lever@oracle.com>
Date:   Sat May 19 17:22:46 2007 -0400

    NFS: Fix handful of compiler warnings in direct.c
    
    This patch fixes a couple of signage issues that were causing an Oops
    when running the LTP diotest4 test. get_user_pages() returns a signed
    error, hence we need to be careful when comparing with the unsigned
    number of pages from data->npages.
    
    Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 7fe7f8487ae742239dd8c66596e2311c30d057d1
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Sun May 20 10:18:27 2007 -0400

    NFS: Avoid a deadlock situation on write
    
    When processes are allowed to attempt to lock a non-contiguous range of nfs
    write requests, it is possible for generic_writepages to 'wrap round' the
    address space, and call writepage() on a request that is already locked by
    the same process.
    
    We avoid the deadlock by checking if the page index is contiguous with the
    list of nfs write requests that is already held in our
    nfs_pageio_descriptor prior to attempting to lock a new request.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 345aa5c..0c542ec 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -122,19 +122,25 @@ ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_
 	return -EINVAL;
 }
 
-static void nfs_direct_dirty_pages(struct page **pages, int npages)
+static void nfs_direct_dirty_pages(struct page **pages, unsigned int pgbase, size_t count)
 {
-	int i;
+	unsigned int npages;
+	unsigned int i;
+
+	if (count == 0)
+		return;
+	pages += (pgbase >> PAGE_SHIFT);
+	npages = (count + (pgbase & ~PAGE_MASK) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	for (i = 0; i < npages; i++) {
 		struct page *page = pages[i];
 		if (!PageCompound(page))
-			set_page_dirty_lock(page);
+			set_page_dirty(page);
 	}
 }
 
-static void nfs_direct_release_pages(struct page **pages, int npages)
+static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
 {
-	int i;
+	unsigned int i;
 	for (i = 0; i < npages; i++)
 		page_cache_release(pages[i]);
 }
@@ -224,17 +230,18 @@ static void nfs_direct_read_result(struct rpc_task *task, void *calldata)
 	if (nfs_readpage_result(task, data) != 0)
 		return;
 
-	nfs_direct_dirty_pages(data->pagevec, data->npages);
-	nfs_direct_release_pages(data->pagevec, data->npages);
-
 	spin_lock(&dreq->lock);
-
-	if (likely(task->tk_status >= 0))
-		dreq->count += data->res.count;
-	else
+	if (unlikely(task->tk_status < 0)) {
 		dreq->error = task->tk_status;
-
-	spin_unlock(&dreq->lock);
+		spin_unlock(&dreq->lock);
+	} else {
+		dreq->count += data->res.count;
+		spin_unlock(&dreq->lock);
+		nfs_direct_dirty_pages(data->pagevec,
+				data->args.pgbase,
+				data->res.count);
+	}
+	nfs_direct_release_pages(data->pagevec, data->npages);
 
 	if (put_dreq(dreq))
 		nfs_direct_complete(dreq);
@@ -279,9 +286,12 @@ static ssize_t nfs_direct_read_schedule(struct nfs_direct_req *dreq, unsigned lo
 		result = get_user_pages(current, current->mm, user_addr,
 					data->npages, 1, 0, data->pagevec, NULL);
 		up_read(&current->mm->mmap_sem);
-		if (unlikely(result < data->npages)) {
-			if (result > 0)
-				nfs_direct_release_pages(data->pagevec, result);
+		if (result < 0) {
+			nfs_readdata_release(data);
+			break;
+		}
+		if ((unsigned)result < data->npages) {
+			nfs_direct_release_pages(data->pagevec, result);
 			nfs_readdata_release(data);
 			break;
 		}
@@ -610,9 +620,12 @@ static ssize_t nfs_direct_write_schedule(struct nfs_direct_req *dreq, unsigned l
 		result = get_user_pages(current, current->mm, user_addr,
 					data->npages, 0, 0, data->pagevec, NULL);
 		up_read(&current->mm->mmap_sem);
-		if (unlikely(result < data->npages)) {
-			if (result > 0)
-				nfs_direct_release_pages(data->pagevec, result);
+		if (result < 0) {
+			nfs_writedata_release(data);
+			break;
+		}
+		if ((unsigned)result < data->npages) {
+			nfs_direct_release_pages(data->pagevec, result);
 			nfs_writedata_release(data);
 			break;
 		}
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index cbdd1c6..c5bb51a 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -355,6 +355,26 @@ void nfs_pageio_complete(struct nfs_pageio_descriptor *desc)
 	nfs_pageio_doio(desc);
 }
 
+/**
+ * nfs_pageio_cond_complete - Conditional I/O completion
+ * @desc: pointer to io descriptor
+ * @index: page index
+ *
+ * It is important to ensure that processes don't try to take locks
+ * on non-contiguous ranges of pages as that might deadlock. This
+ * function should be called before attempting to wait on a locked
+ * nfs_page. It will complete the I/O if the page index 'index'
+ * is not contiguous with the existing list of pages in 'desc'.
+ */
+void nfs_pageio_cond_complete(struct nfs_pageio_descriptor *desc, pgoff_t index)
+{
+	if (!list_empty(&desc->pg_list)) {
+		struct nfs_page *prev = nfs_list_entry(desc->pg_list.prev);
+		if (index != prev->wb_index + 1)
+			nfs_pageio_doio(desc);
+	}
+}
+
 #define NFS_SCAN_MAXENTRIES 16
 /**
  * nfs_scan_list - Scan a list for matching requests
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index b084c03..af344a1 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -273,8 +273,6 @@ static int nfs_page_async_flush(struct nfs_pageio_descriptor *pgio,
 		 *	 request as dirty (in which case we don't care).
 		 */
 		spin_unlock(req_lock);
-		/* Prevent deadlock! */
-		nfs_pageio_complete(pgio);
 		ret = nfs_wait_on_request(req);
 		nfs_release_request(req);
 		if (ret != 0)
@@ -321,6 +319,8 @@ static int nfs_writepage_locked(struct page *page, struct writeback_control *wbc
 		pgio = &mypgio;
 	}
 
+	nfs_pageio_cond_complete(pgio, page->index);
+
 	err = nfs_page_async_flush(pgio, page);
 	if (err <= 0)
 		goto out;
@@ -329,6 +329,8 @@ static int nfs_writepage_locked(struct page *page, struct writeback_control *wbc
 	if (!offset)
 		goto out;
 
+	nfs_pageio_cond_complete(pgio, page->index);
+
 	ctx = nfs_find_open_context(inode, NULL, FMODE_WRITE);
 	if (ctx == NULL) {
 		err = -EBADF;
diff --git a/include/linux/nfs_page.h b/include/linux/nfs_page.h
index 41afab6..bd193af 100644
--- a/include/linux/nfs_page.h
+++ b/include/linux/nfs_page.h
@@ -81,6 +81,7 @@ extern	void nfs_pageio_init(struct nfs_pageio_descriptor *desc,
 extern	int nfs_pageio_add_request(struct nfs_pageio_descriptor *,
 				   struct nfs_page *);
 extern	void nfs_pageio_complete(struct nfs_pageio_descriptor *desc);
+extern	void nfs_pageio_cond_complete(struct nfs_pageio_descriptor *, pgoff_t);
 extern  int nfs_wait_on_request(struct nfs_page *);
 extern	void nfs_unlock_request(struct nfs_page *req);
 extern  int nfs_set_page_writeback_locked(struct nfs_page *req);
