Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712Ab0ANW2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0ANW2Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065Ab0ANW2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:21 -0500
Received: from kroah.org ([198.145.64.141]:60507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0ANW2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Boaz Harrosh <bharrosh@panasas.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/52] exofs: simple_write_end does not mark_inode_dirty
Date: Thu, 14 Jan 2010 14:26:44 -0800
Message-Id: <1263508051-7868-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-4-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <bharrosh@panasas.com>

commit efd124b999fb4d426b30675f1684521af0872789 upstream.

exofs uses simple_write_end() for it's .write_end handler. But
it is not enough because simple_write_end() does not call
mark_inode_dirty() when it extends i_size. So even if we do
call mark_inode_dirty at beginning of write out, with a very
long IO and a saturated system we might get the .write_inode()
called while still extend-writing to file and miss out on the last
i_size updates.

So override .write_end, call simple_write_end(), and afterwords if
i_size was changed call mark_inode_dirty().

It stands to logic that since simple_write_end() was the one extending
i_size it should also call mark_inode_dirty(). But it looks like all
users of simple_write_end() are memory-bound pseudo filesystems, who
could careless about mark_inode_dirty(). I might submit a
warning-comment patch to simple_write_end() in future.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/exofs/inode.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index 6c10f74..6f7df0f 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -731,13 +731,28 @@ static int exofs_write_begin_export(struct file *file,
 					fsdata);
 }
 
+static int exofs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
+{
+	struct inode *inode = mapping->host;
+	/* According to comment in simple_write_end i_mutex is held */
+	loff_t i_size = inode->i_size;
+	int ret;
+
+	ret = simple_write_end(file, mapping,pos, len, copied, page, fsdata);
+	if (i_size != inode->i_size)
+		mark_inode_dirty(inode);
+	return ret;
+}
+
 const struct address_space_operations exofs_aops = {
 	.readpage	= exofs_readpage,
 	.readpages	= exofs_readpages,
 	.writepage	= exofs_writepage,
 	.writepages	= exofs_writepages,
 	.write_begin	= exofs_write_begin_export,
-	.write_end	= simple_write_end,
+	.write_end	= exofs_write_end,
 };
 
 /******************************************************************************
-- 
1.6.6

