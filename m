Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbXH2Ptq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbXH2Ptq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756089AbXH2Ptj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:49:39 -0400
Received: from pat.uio.no ([129.240.10.15]:51292 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbXH2Pti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:49:38 -0400
Subject: Re: [BUG] problem with nfs_invalidate_page
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <200708280832.AA00252@paprika.lab.ntt.co.jp>
References: <1188221412.6701.45.camel@heimdal.trondhjem.org>
	 <200708280832.AA00252@paprika.lab.ntt.co.jp>
Content-Type: multipart/mixed; boundary="=-IOgtJVsVpTYsKV/4gbs/"
Date: Wed, 29 Aug 2007 11:49:22 -0400
Message-Id: <1188402562.6580.74.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.0, required=12.0, autolearn=disabled, AWL=-0.038)
X-UiO-Scanned: 1F5628C08987A03947417E526BBE5EACB1F3E0B8
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 894 total 3543500 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IOgtJVsVpTYsKV/4gbs/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, 2007-08-28 at 17:32 +0900, Ryusuke Konishi wrote:
> On Mon, 27 Aug 2007 09:30:12 -0400, Trond Myklebust wrote:
> >It looks as if ecryptfs is dropping the page lock between the calls to
> >prepare_write() and commit_write(). That would be a bug.
> 
> No, ecryptfs is holding the page lock between the calls to 
> nfs_prepare_write() and nfs_commit_write().
> This is a regression since kernel 2.6.20;  kernel 2.6.19 does not 
> yield the BUG.
> 
> Please look at truncate_complete_page() and nfs_wb_page_priority() 
> which is called from nfs_invalidate_page().
> 
> The recent truncate_complete_page() clears the dirty flag from a page
> before calling a_ops->invalidatepage(),
> ^^^^^^
> static void
> truncate_complete_page(struct address_space *mapping, struct page *page)
> {
>         ...
> 	cancel_dirty_page(page, PAGE_CACHE_SIZE);  <--- Inserted here at kernel 2.6.20
> 
> 	if (PagePrivate(page))
> 		do_invalidatepage(page, 0);   ---> will call a_ops->invalidatepage()
>         ...
> }
> 
> and this is disturbing nfs_wb_page_priority() from calling 
> nfs_writepage_locked() that is expected to handle the pending
> request (=nfs_page) associated with the page.
> 
> int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
> {
> 	...
> 	if (clear_page_dirty_for_io(page)) {
> 		ret = nfs_writepage_locked(page, &wbc);
> 		if (ret < 0)
> 			goto out;
> 	}
>  	...
> }
> 
> Since truncate_complete_page() will get rid of the page after
> a_ops->invalidatepage() returns, the request (=nfs_page) associated
> with the page becomes a garbage in nfs_inode->nfs_page_tree.
> 
> This causes the collision of nfs_page and yields the BUG.
> 
> 
> Cheers,
> Ryusuke Konishi

OK. I see your point... Basically, you are saying that the new
->invalidatepage() semantics do not allow us to rely on the dirty status
of the page in order to figure out if we need to clean up.

Andrew, that was a fairly significant change in semantics...

Anyhow, well done debugging it! Does the following patch fix the Oops?

Trond


--=-IOgtJVsVpTYsKV/4gbs/
Content-Disposition: inline; filename=linux-2.6.23-004-fix_nfs_wb_page_priority.dif
Content-Type: message/rfc822; name=linux-2.6.23-004-fix_nfs_wb_page_priority.dif

From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 28 Aug 2007 10:29:36 -0400
NFS: Fix a write request leak in nfs_invalidate_page()
Subject: No Subject
Message-Id: <1188402562.6580.75.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Ryusuke Konishi says:

The recent truncate_complete_page() clears the dirty flag from a page
before calling a_ops->invalidatepage(),
^^^^^^
static void
truncate_complete_page(struct address_space *mapping, struct page *page)
{
        ...
        cancel_dirty_page(page, PAGE_CACHE_SIZE);  <--- Inserted here at
kernel 2.6.20

        if (PagePrivate(page))
                do_invalidatepage(page, 0);   ---> will call
a_ops->invalidatepage()
        ...
}

and this is disturbing nfs_wb_page_priority() from calling 
nfs_writepage_locked() that is expected to handle the pending
request (=nfs_page) associated with the page.

int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
{
        ...
        if (clear_page_dirty_for_io(page)) {
                ret = nfs_writepage_locked(page, &wbc);
                if (ret < 0)
                        goto out;
        }
        ...
}

Since truncate_complete_page() will get rid of the page after
a_ops->invalidatepage() returns, the request (=nfs_page) associated
with the page becomes a garbage in nfs_inode->nfs_page_tree.
------------------------

Fix this by ensuring that nfs_wb_page_priority() recognises that it may
also need to clear out non-dirty pages that have an nfs_page associated
with them.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/file.c          |    2 +-
 fs/nfs/write.c         |   44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/nfs_fs.h |    1 +
 3 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index c87dc71..579cf8a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -316,7 +316,7 @@ static void nfs_invalidate_page(struct page *page, unsigned long offset)
 	if (offset != 0)
 		return;
 	/* Cancel any unstarted writes on this page */
-	nfs_wb_page_priority(page->mapping->host, page, FLUSH_INVALIDATE);
+	nfs_wb_page_cancel(page->mapping->host, page);
 }
 
 static int nfs_release_page(struct page *page, gfp_t gfp)
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index ef97e0c..0d7a77c 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1396,6 +1396,50 @@ out:
 	return ret;
 }
 
+int nfs_wb_page_cancel(struct inode *inode, struct page *page)
+{
+	struct nfs_page *req;
+	loff_t range_start = page_offset(page);
+	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
+	struct writeback_control wbc = {
+		.bdi = page->mapping->backing_dev_info,
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = LONG_MAX,
+		.range_start = range_start,
+		.range_end = range_end,
+	};
+	int ret = 0;
+
+	BUG_ON(!PageLocked(page));
+	for (;;) {
+		req = nfs_page_find_request(page);
+		if (req == NULL)
+			goto out;
+		if (test_bit(PG_NEED_COMMIT, &req->wb_flags)) {
+			nfs_release_request(req);
+			break;
+		}
+		if (nfs_lock_request_dontget(req)) {
+			nfs_inode_remove_request(req);
+			/*
+			 * In case nfs_inode_remove_request has marked the
+			 * page as being dirty
+			 */
+			cancel_dirty_page(page, PAGE_CACHE_SIZE);
+			nfs_unlock_request(req);
+			break;
+		}
+		ret = nfs_wait_on_request(req);
+		if (ret < 0)
+			goto out;
+	}
+	if (!PagePrivate(page))
+		return 0;
+	ret = nfs_sync_mapping_wait(page->mapping, &wbc, FLUSH_INVALIDATE);
+out:
+	return ret;
+}
+
 int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
 {
 	loff_t range_start = page_offset(page);
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 157dcb0..7250eea 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -431,6 +431,7 @@ extern int nfs_sync_mapping_range(struct address_space *, loff_t, loff_t, int);
 extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_page(struct inode *inode, struct page* page);
 extern int nfs_wb_page_priority(struct inode *inode, struct page* page, int how);
+extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_write_data *nfs_commit_alloc(void);

--=-IOgtJVsVpTYsKV/4gbs/--

