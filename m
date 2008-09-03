Return-Path: <linux-kernel-owner+w=401wt.eu-S1759346AbYICRwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759346AbYICRwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbYICRwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:52:24 -0400
Received: from ns.suse.de ([195.135.220.2]:54135 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757155AbYICRwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:52:21 -0400
Date: Wed, 3 Sep 2008 10:33:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch 10/16] cramfs: fix named-pipe handling
Message-ID: <20080903173302.GK10429@suse.de>
References: <20080903172849.927077124@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cramfs-fix-named-pipe-handling.patch"
In-Reply-To: <20080903173218.GA10429@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Al Viro <viro@ZenIV.linux.org.uk>

commit 82d63fc9e30687c055b97928942b8893ea65b0bb upstream

After commit a97c9bf33f4612e2aed6f000f6b1d268b6814f3c (fix cramfs
making duplicate entries in inode cache) in kernel 2.6.14, named-pipe
on cramfs does not work properly.

It seems the commit make all named-pipe on cramfs share their inode
(and named-pipe buffer).

Make ..._test() refuse to merge inodes with ->i_ino == 1, take inode setup
back to get_cramfs_inode() and make ->drop_inode() evict ones with ->i_ino
== 1 immediately.

Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cramfs/inode.c |   84 ++++++++++++++++++++++++------------------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

--- a/fs/cramfs/inode.c
+++ b/fs/cramfs/inode.c
@@ -44,58 +44,13 @@ static DEFINE_MUTEX(read_mutex);
 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
 	struct cramfs_inode *cramfs_inode = opaque;
-
-	if (inode->i_ino != CRAMINO(cramfs_inode))
-		return 0; /* does not match */
-
-	if (inode->i_ino != 1)
-		return 1;
-
-	/* all empty directories, char, block, pipe, and sock, share inode #1 */
-
-	if ((inode->i_mode != cramfs_inode->mode) ||
-	    (inode->i_gid != cramfs_inode->gid) ||
-	    (inode->i_uid != cramfs_inode->uid))
-		return 0; /* does not match */
-
-	if ((S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) &&
-	    (inode->i_rdev != old_decode_dev(cramfs_inode->size)))
-		return 0; /* does not match */
-
-	return 1; /* matches */
+	return inode->i_ino == CRAMINO(cramfs_inode) && inode->i_ino != 1;
 }
 
 static int cramfs_iget5_set(struct inode *inode, void *opaque)
 {
-	static struct timespec zerotime;
 	struct cramfs_inode *cramfs_inode = opaque;
-	inode->i_mode = cramfs_inode->mode;
-	inode->i_uid = cramfs_inode->uid;
-	inode->i_size = cramfs_inode->size;
-	inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
-	inode->i_gid = cramfs_inode->gid;
-	/* Struct copy intentional */
-	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
 	inode->i_ino = CRAMINO(cramfs_inode);
-	/* inode->i_nlink is left 1 - arguably wrong for directories,
-	   but it's the best we can do without reading the directory
-           contents.  1 yields the right result in GNU find, even
-	   without -noleaf option. */
-	if (S_ISREG(inode->i_mode)) {
-		inode->i_fop = &generic_ro_fops;
-		inode->i_data.a_ops = &cramfs_aops;
-	} else if (S_ISDIR(inode->i_mode)) {
-		inode->i_op = &cramfs_dir_inode_operations;
-		inode->i_fop = &cramfs_directory_operations;
-	} else if (S_ISLNK(inode->i_mode)) {
-		inode->i_op = &page_symlink_inode_operations;
-		inode->i_data.a_ops = &cramfs_aops;
-	} else {
-		inode->i_size = 0;
-		inode->i_blocks = 0;
-		init_special_inode(inode, inode->i_mode,
-			old_decode_dev(cramfs_inode->size));
-	}
 	return 0;
 }
 
@@ -105,12 +60,48 @@ static struct inode *get_cramfs_inode(st
 	struct inode *inode = iget5_locked(sb, CRAMINO(cramfs_inode),
 					    cramfs_iget5_test, cramfs_iget5_set,
 					    cramfs_inode);
+	static struct timespec zerotime;
+
 	if (inode && (inode->i_state & I_NEW)) {
+		inode->i_mode = cramfs_inode->mode;
+		inode->i_uid = cramfs_inode->uid;
+		inode->i_size = cramfs_inode->size;
+		inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
+		inode->i_gid = cramfs_inode->gid;
+		/* Struct copy intentional */
+		inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
+		/* inode->i_nlink is left 1 - arguably wrong for directories,
+		   but it's the best we can do without reading the directory
+		   contents.  1 yields the right result in GNU find, even
+		   without -noleaf option. */
+		if (S_ISREG(inode->i_mode)) {
+			inode->i_fop = &generic_ro_fops;
+			inode->i_data.a_ops = &cramfs_aops;
+		} else if (S_ISDIR(inode->i_mode)) {
+			inode->i_op = &cramfs_dir_inode_operations;
+			inode->i_fop = &cramfs_directory_operations;
+		} else if (S_ISLNK(inode->i_mode)) {
+			inode->i_op = &page_symlink_inode_operations;
+			inode->i_data.a_ops = &cramfs_aops;
+		} else {
+			inode->i_size = 0;
+			inode->i_blocks = 0;
+			init_special_inode(inode, inode->i_mode,
+				old_decode_dev(cramfs_inode->size));
+		}
 		unlock_new_inode(inode);
 	}
 	return inode;
 }
 
+static void cramfs_drop_inode(struct inode *inode)
+{
+	if (inode->i_ino == 1)
+		generic_delete_inode(inode);
+	else
+		generic_drop_inode(inode);
+}
+
 /*
  * We have our own block cache: don't fill up the buffer cache
  * with the rom-image, because the way the filesystem is set
@@ -535,6 +526,7 @@ static const struct super_operations cra
 	.put_super	= cramfs_put_super,
 	.remount_fs	= cramfs_remount,
 	.statfs		= cramfs_statfs,
+	.drop_inode	= cramfs_drop_inode,
 };
 
 static int cramfs_get_sb(struct file_system_type *fs_type,

-- 
