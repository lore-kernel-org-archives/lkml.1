Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZLKFbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZLKFbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755165AbZLKFb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:31:26 -0500
Received: from kroah.org ([198.145.64.141]:53607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933102AbZLKFaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:30:06 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:57 2009
Message-Id: <20091211052556.560487193@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Monakhov <dmonakhov@openvz.org>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [30/34] ext4: quota macros cleanup
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=0026-ext4-quota-macros-cleanup.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit 5aca07eb7d8f14d90c740834d15ca15277f4820c)

Currently all quota block reservation macros contains hard-coded "2"
aka MAXQUOTAS value. This is no good because in some places it is not
obvious to understand what does this digit represent. Let's introduce
new macro with self descriptive name.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/ext4_jbd2.h |    8 ++++++--
 fs/ext4/extents.c   |    2 +-
 fs/ext4/inode.c     |    2 +-
 fs/ext4/migrate.c   |    4 ++--
 fs/ext4/namei.c     |    8 ++++----
 5 files changed, 14 insertions(+), 10 deletions(-)

--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -49,7 +49,7 @@
 
 #define EXT4_DATA_TRANS_BLOCKS(sb)	(EXT4_SINGLEDATA_TRANS_BLOCKS(sb) + \
 					 EXT4_XATTR_TRANS_BLOCKS - 2 + \
-					 2*EXT4_QUOTA_TRANS_BLOCKS(sb))
+					 EXT4_MAXQUOTAS_TRANS_BLOCKS(sb))
 
 /*
  * Define the number of metadata blocks we need to account to modify data.
@@ -57,7 +57,7 @@
  * This include super block, inode block, quota blocks and xattr blocks
  */
 #define EXT4_META_TRANS_BLOCKS(sb)	(EXT4_XATTR_TRANS_BLOCKS + \
-					2*EXT4_QUOTA_TRANS_BLOCKS(sb))
+					EXT4_MAXQUOTAS_TRANS_BLOCKS(sb))
 
 /* Delete operations potentially hit one directory's namespace plus an
  * entire inode, plus arbitrary amounts of bitmap/indirection data.  Be
@@ -92,6 +92,7 @@
  * but inode, sb and group updates are done only once */
 #define EXT4_QUOTA_INIT_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_INIT_ALLOC*\
 		(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)+3+DQUOT_INIT_REWRITE) : 0)
+
 #define EXT4_QUOTA_DEL_BLOCKS(sb) (test_opt(sb, QUOTA) ? (DQUOT_DEL_ALLOC*\
 		(EXT4_SINGLEDATA_TRANS_BLOCKS(sb)-3)+3+DQUOT_DEL_REWRITE) : 0)
 #else
@@ -99,6 +100,9 @@
 #define EXT4_QUOTA_INIT_BLOCKS(sb) 0
 #define EXT4_QUOTA_DEL_BLOCKS(sb) 0
 #endif
+#define EXT4_MAXQUOTAS_TRANS_BLOCKS(sb) (MAXQUOTAS*EXT4_QUOTA_TRANS_BLOCKS(sb))
+#define EXT4_MAXQUOTAS_INIT_BLOCKS(sb) (MAXQUOTAS*EXT4_QUOTA_INIT_BLOCKS(sb))
+#define EXT4_MAXQUOTAS_DEL_BLOCKS(sb) (MAXQUOTAS*EXT4_QUOTA_DEL_BLOCKS(sb))
 
 int
 ext4_mark_iloc_dirty(handle_t *handle,
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2167,7 +2167,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 			correct_index = 1;
 			credits += (ext_depth(inode)) + 1;
 		}
-		credits += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
+		credits += EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
 
 		err = ext4_ext_truncate_extend_restart(handle, inode, credits);
 		if (err)
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5231,7 +5231,7 @@ int ext4_setattr(struct dentry *dentry,
 
 		/* (user+group)*(old+new) structure, inode write (sb,
 		 * inode block, ? - but truncate inode update has it) */
-		handle = ext4_journal_start(inode, 2*(EXT4_QUOTA_INIT_BLOCKS(inode->i_sb)+
+		handle = ext4_journal_start(inode, (EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)+
 					EXT4_QUOTA_DEL_BLOCKS(inode->i_sb))+3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -238,7 +238,7 @@ static int extend_credit_for_blkdel(hand
 	 * So allocate a credit of 3. We may update
 	 * quota (user and group).
 	 */
-	needed = 3 + 2*EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
+	needed = 3 + EXT4_MAXQUOTAS_TRANS_BLOCKS(inode->i_sb);
 
 	if (ext4_journal_extend(handle, needed) != 0)
 		retval = ext4_journal_restart(handle, needed);
@@ -477,7 +477,7 @@ int ext4_ext_migrate(struct inode *inode
 	handle = ext4_journal_start(inode,
 					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					2 * EXT4_QUOTA_INIT_BLOCKS(inode->i_sb)
+					EXT4_MAXQUOTAS_INIT_BLOCKS(inode->i_sb)
 					+ 1);
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1769,7 +1769,7 @@ static int ext4_create(struct inode *dir
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -1803,7 +1803,7 @@ static int ext4_mknod(struct inode *dir,
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -1840,7 +1840,7 @@ static int ext4_mkdir(struct inode *dir,
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
-					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 
@@ -2253,7 +2253,7 @@ static int ext4_symlink(struct inode *di
 retry:
 	handle = ext4_journal_start(dir, EXT4_DATA_TRANS_BLOCKS(dir->i_sb) +
 					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 5 +
-					2*EXT4_QUOTA_INIT_BLOCKS(dir->i_sb));
+					EXT4_MAXQUOTAS_INIT_BLOCKS(dir->i_sb));
 	if (IS_ERR(handle))
 		return PTR_ERR(handle);
 


