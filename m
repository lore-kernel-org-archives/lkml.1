Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYLDRrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYLDRrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 12:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYLDRrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 12:47:13 -0500
Received: from gv-out-0910.google.com ([216.239.58.187]:60387 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYLDRrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 12:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:subject:to:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=dTjM4hYBdvYrMTHGN3JY+HLguJ5+6NVJr6ZadvIyieEtmQLBRqrBINQosq7DrZtGQ9
         YpAyKO5BPmViMYfUCnouHvYAuc2Z0rZgpphgBBmI4WPnqe4frNq1bAG3Oenbv71wkt64
         L46IOdZlL86L04OHsgwWdQeOfp0N7BlaYH24s=
From: "Diego Elio 'Flameeyes' =?utf-8?q?Petten=C3=B2?=" 
	<flameeyes@gmail.com>
Subject: [PATCH] Add basic export support to HFS+.
To: linux-kernel@vger.kernel.org
Date: Thu, 04 Dec 2008 18:47:06 +0100
Message-ID: <20081204174706.10397.94789.stgit@localhost>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Diego E. 'Flameeyes' Pettenò <flameeyes@gmail.com>

The functions' skeleton is taken from ext2/super.c and seems to work
fine for R/W access to HFS+ non-journaled case-sensitive filesystems.

It's probably slow and has a lot of space for improvement but it's
still better than having no hope to export HFS+ filesystems.

Signed-off-by: Diego E. 'Flameeyes' Pettenò <flameeyes@gmail.com>
---

 fs/hfsplus/super.c |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index eb74531..45b48cc 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 #include <linux/pagemap.h>
 #include <linux/fs.h>
+#include <linux/exportfs.h>
 #include <linux/slab.h>
 #include <linux/vfs.h>
 #include <linux/nls.h>
@@ -281,6 +282,53 @@ static const struct super_operations hfsplus_sops = {
 	.show_options	= hfsplus_show_options,
 };
 
+static struct inode *hfsplus_export_get_inode(struct super_block *sb,
+					      u64 ino, u32 generation)
+{
+	struct inode *inode;
+
+	if (ino < HFSPLUS_FIRSTUSER_CNID && ino != HFSPLUS_ROOT_CNID)
+		return ERR_PTR(-ESTALE);
+
+	/* iget isn't really right if the inode is currently unallocated!!
+	 */
+	inode = hfsplus_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
+		/* we didn't find the right inode.. */
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+	return inode;
+}
+
+static struct dentry *hfsplus_fh_to_dentry(struct super_block *sb, struct fid *fid,
+					   int fh_len, int fh_type)
+
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    hfsplus_export_get_inode);
+}
+
+static struct dentry *hfsplus_fh_to_parent(struct super_block *sb, struct fid *fid,
+					   int fh_len, int fh_type)
+
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    hfsplus_export_get_inode);
+}
+
+/* Yes, most of these are left as NULL!!
+ * A NULL value implies the default, which (hopefully) works with
+ * hfs+-like file systems, but can be improved upon.
+ * Currently only fh_to_dentry is required.
+ */
+static const struct export_operations hfsplus_export_ops = {
+	.fh_to_dentry = hfsplus_fh_to_dentry,
+	.fh_to_parent = hfsplus_fh_to_parent,
+};
+
 static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct hfsplus_vh *vhdr;
@@ -345,6 +393,7 @@ static int hfsplus_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Set up operations so we can load metadata */
 	sb->s_op = &hfsplus_sops;
+	sb->s_export_op = &hfsplus_export_ops;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 
 	if (!(vhdr->attributes & cpu_to_be32(HFSPLUS_VOL_UNMNT))) {

