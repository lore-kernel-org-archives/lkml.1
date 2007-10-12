Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXJLQL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXJLQL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbXJLQGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbXJLQGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/52] CRED: Provide a writeback credentials record
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:30 +0100
Message-ID: <20071012160630.15119.20074.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a set of credentials specifically for the writeback functions.  Since
writeback may well occur in some other process context than the original write
into the pagecache, the current process's credentials are not applicable, and
so there are used instead.

If writeback needs to know the credentials, then those credentials should be
cached by prepare_write(), page_mkwrite() or similar.  Filesystems such as NFS
and AFS need to do this as they need to communicate to a remote store the
appropriate security details under which the write should be made.
Filesystems such as Ext3 should perform allocation and reservation checks
before letting the write to the pagecache occur.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/buffer.c          |    2 +-
 fs/mpage.c           |    2 +-
 include/linux/cred.h |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bb6ab45..0c8444a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1599,7 +1599,7 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
 static int __block_write_full_page(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc)
 {
-	struct cred *cred = current->cred;
+	struct cred *cred = &writeback_cred;
 	int err;
 	sector_t block;
 	sector_t last_block;
diff --git a/fs/mpage.c b/fs/mpage.c
index af97410..c04672d 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -457,7 +457,7 @@ struct mpage_data {
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 			     void *data)
 {
-	struct cred *cred = current->cred;
+	struct cred *cred = &writeback_cred;
 	struct mpage_data *mpd = data;
 	struct bio *bio = mpd->bio;
 	struct address_space *mapping = page->mapping;
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 6ec0132..46f4a64 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -29,6 +29,7 @@ struct cred {
 };
 
 extern struct cred init_cred;
+#define writeback_cred init_cred
 
 struct inode;
 

