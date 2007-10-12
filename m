Return-Path: <linux-kernel-owner+w=401wt.eu-S1761248AbXJLQNO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761248AbXJLQNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXJLQGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:06:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760291AbXJLQGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:06:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 16/52] CRED: Pass credentials through the internals of ext3
	truncation
To: viro@ftp.linux.org.uk
Cc: kwc@citi.umich.edu, Trond.Myklebust@netapp.com,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Fri, 12 Oct 2007 17:06:41 +0100
Message-ID: <20071012160641.15119.5237.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
References: <20071012160519.15119.69608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pass credentials through the internals of ext3 truncation.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext3/inode.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 73b64f3..4313d20 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1770,9 +1770,8 @@ void ext3_set_aops(struct inode *inode)
  * of that block so it doesn't yield old data if the file is later grown.
  */
 static int ext3_block_truncate_page(handle_t *handle, struct page *page,
-		struct address_space *mapping, loff_t from)
+		struct address_space *mapping, loff_t from, struct cred *cred)
 {
-	struct cred *cred = current->cred;
 	ext3_fsblk_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
 	unsigned blocksize, iblock, length, pos;
@@ -2230,6 +2229,7 @@ static void ext3_free_branches(handle_t *handle, struct inode *inode,
  */
 void ext3_truncate(struct inode *inode)
 {
+	struct cred *cred = current->cred;
 	handle_t *handle;
 	struct ext3_inode_info *ei = EXT3_I(inode);
 	__le32 *i_data = ei->i_data;
@@ -2281,7 +2281,8 @@ void ext3_truncate(struct inode *inode)
 					>> EXT3_BLOCK_SIZE_BITS(inode->i_sb);
 
 	if (page)
-		ext3_block_truncate_page(handle, page, mapping, inode->i_size);
+		ext3_block_truncate_page(handle, page, mapping, inode->i_size,
+					 cred);
 
 	n = ext3_block_to_path(inode, last_block, offsets, NULL);
 	if (n == 0)

