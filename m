Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbXLETpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbXLETpo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 14:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXLETj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 14:39:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbXLETj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 14:39:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 14/28] CacheFiles: Be consistent about the use of mapping vs
	file->f_mapping in Ext3 [try #2]
To: viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       sds@tycho.nsa.gov, casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 05 Dec 2007 19:39:29 +0000
Message-ID: <20071205193929.24617.40.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
References: <20071205193818.24617.79771.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
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
index 9b162cd..bc918d3 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1227,7 +1227,7 @@ static int ext3_generic_write_end(struct file *file,
 				loff_t pos, unsigned len, unsigned copied,
 				struct page *page, void *fsdata)
 {
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
@@ -1252,7 +1252,7 @@ static int ext3_ordered_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	unsigned from, to;
 	int ret = 0, ret2;
 
@@ -1293,7 +1293,7 @@ static int ext3_writeback_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext3_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 

