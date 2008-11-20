Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYKTOwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYKTOwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756144AbYKTOns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:43:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41092 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbYKTOnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:43:43 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 23/45] CacheFiles: Be consistent about the use of mapping vs
	file->f_mapping in Ext3 [ver #41]
To: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Date: Thu, 20 Nov 2008 14:43:38 +0000
Message-ID: <20081120144338.10667.55564.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all the usages of file->f_mapping in ext3_*write_end() functions to use
the mapping argument directly.  This has two consequences:

 (*) Consistency.  Without this patch sometimes one is used and sometimes the
     other is.

 (*) A NULL file pointer can be passed.  This feature is then made use of by
     the generic hook in the next patch, which is used by CacheFiles to write
     pages to a file without setting up a file struct.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/inode.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index f8424ad..10c4c19 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1230,7 +1230,7 @@ static int ext3_generic_write_end(struct file *file,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
@@ -1255,7 +1255,7 @@ static int ext3_ordered_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	unsigned from, to;
 	int ret = 0, ret2;
 
@@ -1297,7 +1297,7 @@ static int ext3_writeback_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 

