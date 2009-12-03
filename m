Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZLCSZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZLCSZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 13:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZLCSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 13:25:13 -0500
Received: from cantor.suse.de ([195.135.220.2]:36970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZLCSZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 13:25:12 -0500
Message-ID: <4B180462.4050904@suse.de>
Date: Fri, 04 Dec 2009 02:33:06 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steve French <sfrench@samba.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
       KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>,
       Bob Copeland <me@bobcopeland.com>, Anders Larsen <al@alarsen.net>
Subject: [PATCH] remove compiling warning by adding uninitialized_var()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some "may be used uninitialized" compiling warnings by adding uninitialized_var(), while the
uninitialized variables are initialized properly.

Signed-off-by: Coly Li <coly.li@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steve French <sfrench@samba.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: Anders Larsen <al@alarsen.net>
---
 fs/cifs/cifssmb.c         |    2 +-
 fs/fat/namei_vfat.c       |    6 ++++--
 fs/freevxfs/vxfs_lookup.c |    2 +-
 fs/nilfs2/btree.c         |    3 ++-
 fs/omfs/file.c            |    2 +-
 fs/qnx4/namei.c           |    2 +-
 6 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 941441d..87a6edc 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3043,7 +3043,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 		__u32 parm_len;
 		__u32 acl_len;
 		struct smb_com_ntransact_rsp *pSMBr;
-		char *pdata;
+		char *uninitialized_var(pdata);

 /* validate_nttransact */
 		rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index f565f24..9fdd7e9 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -587,12 +587,14 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 	struct fat_mount_options *opts = &sbi->options;
 	struct msdos_dir_slot *ps;
 	struct msdos_dir_entry *de;
-	unsigned char cksum, lcase;
+	unsigned char cksum;
+	unsigned char uninitialized_var(lcase);
 	unsigned char msdos_name[MSDOS_NAME];
 	wchar_t *uname;
 	__le16 time, date;
 	u8 time_cs;
-	int err, ulen, usize, i;
+	int err, usize, i;
+	int uninitialized_var(ulen);
 	loff_t offset;

 	*nr_slots = 0;
diff --git a/fs/freevxfs/vxfs_lookup.c b/fs/freevxfs/vxfs_lookup.c
index aee049c..02c9718 100644
--- a/fs/freevxfs/vxfs_lookup.c
+++ b/fs/freevxfs/vxfs_lookup.c
@@ -174,7 +174,7 @@ static ino_t
 vxfs_inode_by_name(struct inode *dip, struct dentry *dp)
 {
 	struct vxfs_direct		*de;
-	struct page			*pp;
+	struct page			*uninitialized_var(pp);
 	ino_t				ino = 0;

 	de = vxfs_find_entry(dip, dp, &pp);
diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
index e25b507..4e6edda 100644
--- a/fs/nilfs2/btree.c
+++ b/fs/nilfs2/btree.c
@@ -1911,7 +1911,8 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
 				   struct nilfs_btree_path *path,
 				   int level, struct buffer_head *bh)
 {
-	int maxlevel, ret;
+	int ret;
+	int uninitialized_var(maxlevel);
 	struct nilfs_btree_node *parent;
 	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
 	__u64 ptr;
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 399487c..f01e1e8 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -222,7 +222,7 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 	struct buffer_head *bh;
 	sector_t next, offset;
 	int ret;
-	u64 new_block;
+	u64 uninitialized_var(new_block);
 	u32 max_extents;
 	int extent_count;
 	struct omfs_extent *oe;
diff --git a/fs/qnx4/namei.c b/fs/qnx4/namei.c
index ae1e7ed..4e60c3b 100644
--- a/fs/qnx4/namei.c
+++ b/fs/qnx4/namei.c
@@ -101,7 +101,7 @@ static struct buffer_head *qnx4_find_entry(int len, struct inode *dir,

 struct dentry * qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 {
-	int ino;
+	int uninitialized_var(ino);
 	struct qnx4_inode_entry *de;
 	struct qnx4_link_info *lnk;
 	struct buffer_head *bh;
-- 
Coly Li
SuSE Labs
