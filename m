Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYH1RnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYH1RnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbYH1Rme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:52423 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbYH1Rmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:33 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] FUSE: implement nonseekable open
Date: Fri, 29 Aug 2008 02:40:59 +0900
Message-Id: <1219945263-21074-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the client request nonseekable open using FOPEN_NONSEEKABLE and
call nonseekable_open() on the file if requested.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/file.c       |    2 ++
 include/linux/fuse.h |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index d405865..9c44f9c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -101,6 +101,8 @@ void fuse_finish_open(struct inode *inode, struct file *file,
 		file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
 		invalidate_inode_pages2(inode->i_mapping);
+	if (outarg->open_flags & FOPEN_NONSEEKABLE)
+		nonseekable_open(inode, file);
 	ff->fh = outarg->fh;
 	file->private_data = fuse_file_get(ff);
 }
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 724ca19..431666e 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -101,9 +101,11 @@ struct fuse_file_lock {
  *
  * FOPEN_DIRECT_IO: bypass page cache for this open file
  * FOPEN_KEEP_CACHE: don't invalidate the data cache on open
+ * FOPEN_NONSEEKABLE: the file is not seekable
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
+#define FOPEN_NONSEEKABLE	(1 << 2)
 
 /**
  * INIT request/reply flags
-- 
1.5.4.5

