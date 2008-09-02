Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYIBW2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYIBW2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:28:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYIBW2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:28:40 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44855 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYIBW2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:28:40 -0400
Date: Tue, 2 Sep 2008 17:28:36 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ZinIV.linux.org.uk, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: Remove retry loop in ecryptfs_readdir()
Message-ID: <20080902222836.GD10186@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The retry block in ecryptfs_readdir() has been in the eCryptfs code
base for a while, apparently for no good reason. This loop could
potentially run without terminating. This patch removes the loop,
instead erroring out if vfs_readdir() on the lower file fails.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Al Viro <viro@ZinIV.linux.org.uk>
---
 fs/ecryptfs/file.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 9244d65..eb3dc4c 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -71,12 +71,11 @@ struct ecryptfs_getdents_callback {
 	void *dirent;
 	struct dentry *dentry;
 	filldir_t filldir;
-	int err;
 	int filldir_called;
 	int entries_written;
 };
 
-/* Inspired by generic filldir in fs/readir.c */
+/* Inspired by generic filldir in fs/readdir.c */
 static int
 ecryptfs_filldir(void *dirent, const char *name, int namelen, loff_t offset,
 		 u64 ino, unsigned int d_type)
@@ -125,18 +124,18 @@ static int ecryptfs_readdir(struct file *file, void *dirent, filldir_t filldir)
 	buf.dirent = dirent;
 	buf.dentry = file->f_path.dentry;
 	buf.filldir = filldir;
-retry:
 	buf.filldir_called = 0;
 	buf.entries_written = 0;
-	buf.err = 0;
 	rc = vfs_readdir(lower_file, ecryptfs_filldir, (void *)&buf);
-	if (buf.err)
-		rc = buf.err;
-	if (buf.filldir_called && !buf.entries_written)
-		goto retry;
 	file->f_pos = lower_file->f_pos;
+	if (rc < 0)
+		goto out;
+	if (buf.filldir_called && !buf.entries_written)
+		goto out;
 	if (rc >= 0)
-		fsstack_copy_attr_atime(inode, lower_file->f_path.dentry->d_inode);
+		fsstack_copy_attr_atime(inode,
+					lower_file->f_path.dentry->d_inode);
+out:
 	return rc;
 }
 
-- 
1.5.3.6

