Return-Path: <linux-kernel-owner+w=401wt.eu-S1751368AbZGaFWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368AbZGaFWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZGaFWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:22:49 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:49283 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbZGaFWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:22:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wH1ypBu/3bwPuNSxByR+EM0xkd09pes7uJahvAcnoSF8NmMJb8ezOOuDCixuDOUn24
         2TlgGcYIjsAbqvR58GhBfP55ImlImqD2Q9Pi2yTeXpCxIH3eW776CuovqqWCBt7HSWy3
         3RS6rvOFTfaBU5oh9W4odjiHlfe2qYdKK7JBc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] kill-the-bkl/reiserfs: release the lock only for first entry in readdir
Date: Fri, 31 Jul 2009 07:22:43 +0200
Message-Id: <1249017763-7229-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The filldir callback, provided by the VFS, performs a copy of a
directory entry given by the filesystem to a buffer from the user.
And this buffer may be swapped out.

When the write lock was the bkl, if the buffer was swapped out while
copying the directory entry, the lock was automatically relaxed until
the page becomes swapped in because this action involves a sleep.

Now that the lock is a mutex, we explicitly relax the lock during each
filldir call, so that if the buffer page is swapped out, other users
can use the filesystem while we are sleeping.

The problem is that if someone else takes the lock and moves the
entries we are processing in the tree, we have to search one more
time the directory entry in the tree, which is costly.

The ideal behaviour would be to only relax the lock if we know in
advance the next access to the user buffer will fault. The time
involved in a page swap-in is the only profitable case for the lock
to be relaxed and the door to be opened for other users of the
filesystem. Otherwise, going back to search the directory item in the
tree is wasteful.

This patch optimizes this by assuming the first access to the user
buffer is the most likely to fault due to a page swapped out (even
though further access may lead to another page access that might
fault).
We then only relax the lock during the first directory entry copy.
This is also optimized by fixing the need to copy each entry name in
a local buffer, which avoided racy accesses to the buffer_head
content while relaxing the lock. Now we only need to do this middle
stage copy for the first entry.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Alexander Beregalov <a.beregalov@gmail.com>
---
 fs/reiserfs/dir.c |  109 +++++++++++++++++++++++++++++++++--------------------
 1 files changed, 68 insertions(+), 41 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 17f31ad..d6fb8d3 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -51,6 +51,46 @@ static inline bool is_privroot_deh(struct dentry *dir,
 	        deh->deh_objectid == INODE_PKEY(privroot->d_inode)->k_objectid);
 }
 
+/*
+ * The first entry will be the first one to be copied in the user buffer,
+ * hence the first time it is touched by reiserfs_readdir_dentry(). We assume
+ * the buffer has chances to be swapped out at this time and not after,
+ * unless we switch to another page in further entry.
+ * This assumption lead us to:
+ *
+ * - while the page is swapped in, we want the filesystem to be available
+ *   for others, we then relax the write lock.
+ * - because we relax the lock, the entry from which we have read the name
+ *   may have moved somewhere else, we then copy the name in a temporary buffer
+ */
+static int
+fill_first_entry(void * dirent, const char *d_name, int d_reclen, loff_t d_off,
+		 u64 d_ino, filldir_t filldir, struct super_block *sb)
+{
+	int ret;
+	char *local_buf;
+	char small_buf[32];	/* avoid kmalloc if we can */
+
+	if (d_reclen <= 32) {
+		local_buf = small_buf;
+	} else {
+		local_buf = kmalloc(d_reclen, GFP_NOFS);
+		if (!local_buf)
+			return -ENOMEM;
+	}
+
+	memcpy(local_buf, d_name, d_reclen);
+
+	reiserfs_write_unlock(sb);
+	ret = filldir(dirent, local_buf, d_reclen, d_off, d_ino, DT_UNKNOWN);
+	reiserfs_write_lock(sb);
+
+	if (local_buf != small_buf)
+		kfree(local_buf);
+
+	return ret;
+}
+
 int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 			   filldir_t filldir, loff_t *pos)
 {
@@ -62,9 +102,7 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 	const struct reiserfs_key *rkey;
 	struct item_head *ih, tmp_ih;
 	int search_res;
-	char *local_buf;
 	loff_t next_pos;
-	char small_buf[32];	/* avoid kmalloc if we can */
 	struct reiserfs_dir_entry de;
 	int ret = 0;
 
@@ -79,6 +117,8 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 
 	path_to_entry.reada = PATH_READA;
 	while (1) {
+	      bool first_entry = true;
+
 	      research:
 		/* search the directory item, containing entry with specified key */
 		search_res =
@@ -154,51 +194,38 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 				d_off = deh_offset(deh);
 				*pos = d_off;
 				d_ino = deh_objectid(deh);
-				if (d_reclen <= 32) {
-					local_buf = small_buf;
-				} else {
-					local_buf = kmalloc(d_reclen,
-							    GFP_NOFS);
-					if (!local_buf) {
-						pathrelse(&path_to_entry);
-						ret = -ENOMEM;
-						goto out;
-					}
-					if (item_moved(&tmp_ih, &path_to_entry)) {
-						kfree(local_buf);
-						goto research;
-					}
-				}
-				// Note, that we copy name to user space via temporary
-				// buffer (local_buf) because filldir will block if
-				// user space buffer is swapped out. At that time
-				// entry can move to somewhere else
-				memcpy(local_buf, d_name, d_reclen);
 
 				/*
-				 * Since filldir might sleep, we can release
-				 * the write lock here for other waiters
+				 * next entry should be looked for with such
+				 * offset
 				 */
-				reiserfs_write_unlock(inode->i_sb);
-				if (filldir
-				    (dirent, local_buf, d_reclen, d_off, d_ino,
-				     DT_UNKNOWN) < 0) {
-					reiserfs_write_lock(inode->i_sb);
-					if (local_buf != small_buf) {
-						kfree(local_buf);
-					}
-					goto end;
-				}
-				reiserfs_write_lock(inode->i_sb);
-				if (local_buf != small_buf) {
-					kfree(local_buf);
-				}
-				// next entry should be looked for with such offset
 				next_pos = deh_offset(deh) + 1;
 
-				if (item_moved(&tmp_ih, &path_to_entry)) {
-					goto research;
+				if (first_entry) {
+					int fillret;
+
+					fillret = fill_first_entry(dirent,
+								   d_name,
+								   d_reclen,
+								   d_off, d_ino,
+								   filldir,
+								   inode->i_sb);
+					if (fillret == -ENOMEM) {
+						pathrelse(&path_to_entry);
+						ret = -ENOMEM;
+						goto out;
+					}
+					if (fillret < 0)
+						goto end;
+					first_entry = false;
+
+					if (item_moved(&tmp_ih, &path_to_entry))
+						goto research;
+					continue;
 				}
+				if (filldir(dirent, d_name, d_reclen, d_off,
+					    d_ino, DT_UNKNOWN) < 0)
+						goto end;
 			}	/* for */
 		}
 
-- 
1.6.2.3

