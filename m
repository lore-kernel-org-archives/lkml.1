Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZLCXgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZLCXgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZLCXgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:36:41 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36091 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZLCXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:36:20 -0500
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 21/24] ceph: nfs re-export support
Date: Thu,  3 Dec 2009 15:41:28 -0800
Message-Id: <1259883691-1042-22-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259883691-1042-21-git-send-email-sage@newdream.net>
References: <1259883691-1042-1-git-send-email-sage@newdream.net>
 <1259883691-1042-2-git-send-email-sage@newdream.net>
 <1259883691-1042-3-git-send-email-sage@newdream.net>
 <1259883691-1042-4-git-send-email-sage@newdream.net>
 <1259883691-1042-5-git-send-email-sage@newdream.net>
 <1259883691-1042-6-git-send-email-sage@newdream.net>
 <1259883691-1042-7-git-send-email-sage@newdream.net>
 <1259883691-1042-8-git-send-email-sage@newdream.net>
 <1259883691-1042-9-git-send-email-sage@newdream.net>
 <1259883691-1042-10-git-send-email-sage@newdream.net>
 <1259883691-1042-11-git-send-email-sage@newdream.net>
 <1259883691-1042-12-git-send-email-sage@newdream.net>
 <1259883691-1042-13-git-send-email-sage@newdream.net>
 <1259883691-1042-14-git-send-email-sage@newdream.net>
 <1259883691-1042-15-git-send-email-sage@newdream.net>
 <1259883691-1042-16-git-send-email-sage@newdream.net>
 <1259883691-1042-17-git-send-email-sage@newdream.net>
 <1259883691-1042-18-git-send-email-sage@newdream.net>
 <1259883691-1042-19-git-send-email-sage@newdream.net>
 <1259883691-1042-20-git-send-email-sage@newdream.net>
 <1259883691-1042-21-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basic NFS re-export support is included.  This mostly works.  However,
Ceph's MDS design precludes the ability to generate a (small)
filehandle that will be valid forever, so this is of limited utility.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/export.c |  223 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/export.c

diff --git a/fs/ceph/export.c b/fs/ceph/export.c
new file mode 100644
index 0000000..fc68e39
--- /dev/null
+++ b/fs/ceph/export.c
@@ -0,0 +1,223 @@
+#include "ceph_debug.h"
+
+#include <linux/exportfs.h>
+#include <asm/unaligned.h>
+
+#include "super.h"
+
+/*
+ * NFS export support
+ *
+ * NFS re-export of a ceph mount is, at present, only semireliable.
+ * The basic issue is that the Ceph architectures doesn't lend itself
+ * well to generating filehandles that will remain valid forever.
+ *
+ * So, we do our best.  If you're lucky, your inode will be in the
+ * client's cache.  If it's not, and you have a connectable fh, then
+ * the MDS server may be able to find it for you.  Otherwise, you get
+ * ESTALE.
+ *
+ * There are ways to this more reliable, but in the non-connectable fh
+ * case, we won't every work perfectly, and in the connectable case,
+ * some changes are needed on the MDS side to work better.
+ */
+
+/*
+ * Basic fh
+ */
+struct ceph_nfs_fh {
+	u64 ino;
+} __attribute__ ((packed));
+
+/*
+ * Larger 'connectable' fh that includes parent ino and name hash.
+ * Use this whenever possible, as it works more reliably.
+ */
+struct ceph_nfs_confh {
+	u64 ino, parent_ino;
+	u32 parent_name_hash;
+} __attribute__ ((packed));
+
+static int ceph_encode_fh(struct dentry *dentry, u32 *rawfh, int *max_len,
+			  int connectable)
+{
+	struct ceph_nfs_fh *fh = (void *)rawfh;
+	struct ceph_nfs_confh *cfh = (void *)rawfh;
+	struct dentry *parent = dentry->d_parent;
+	struct inode *inode = dentry->d_inode;
+	int type;
+
+	/* don't re-export snaps */
+	if (ceph_snap(inode) != CEPH_NOSNAP)
+		return -EINVAL;
+
+	if (*max_len >= sizeof(*cfh)) {
+		dout("encode_fh %p connectable\n", dentry);
+		cfh->ino = ceph_ino(dentry->d_inode);
+		cfh->parent_ino = ceph_ino(parent->d_inode);
+		cfh->parent_name_hash = parent->d_name.hash;
+		*max_len = sizeof(*cfh);
+		type = 2;
+	} else if (*max_len > sizeof(*fh)) {
+		if (connectable)
+			return -ENOSPC;
+		dout("encode_fh %p\n", dentry);
+		fh->ino = ceph_ino(dentry->d_inode);
+		*max_len = sizeof(*fh);
+		type = 1;
+	} else {
+		return -ENOSPC;
+	}
+	return type;
+}
+
+/*
+ * convert regular fh to dentry
+ *
+ * FIXME: we should try harder by querying the mds for the ino.
+ */
+static struct dentry *__fh_to_dentry(struct super_block *sb,
+				     struct ceph_nfs_fh *fh)
+{
+	struct inode *inode;
+	struct dentry *dentry;
+	struct ceph_vino vino;
+	int err;
+
+	dout("__fh_to_dentry %llx\n", fh->ino);
+	vino.ino = fh->ino;
+	vino.snap = CEPH_NOSNAP;
+	inode = ceph_find_inode(sb, vino);
+	if (!inode)
+		return ERR_PTR(-ESTALE);
+
+	dentry = d_obtain_alias(inode);
+	if (!dentry) {
+		pr_err("fh_to_dentry %llx -- inode %p but ENOMEM\n",
+		       fh->ino, inode);
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	err = ceph_init_dentry(dentry);
+
+	if (err < 0) {
+		iput(inode);
+		return ERR_PTR(err);
+	}
+	dout("__fh_to_dentry %llx %p dentry %p\n", fh->ino, inode, dentry);
+	return dentry;
+}
+
+/*
+ * convert connectable fh to dentry
+ */
+static struct dentry *__cfh_to_dentry(struct super_block *sb,
+				      struct ceph_nfs_confh *cfh)
+{
+	struct ceph_mds_client *mdsc = &ceph_client(sb)->mdsc;
+	struct inode *inode;
+	struct dentry *dentry;
+	struct ceph_vino vino;
+	int err;
+
+	dout("__cfh_to_dentry %llx (%llx/%x)\n",
+	     cfh->ino, cfh->parent_ino, cfh->parent_name_hash);
+
+	vino.ino = cfh->ino;
+	vino.snap = CEPH_NOSNAP;
+	inode = ceph_find_inode(sb, vino);
+	if (!inode) {
+		struct ceph_mds_request *req;
+
+		req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPHASH,
+					       USE_ANY_MDS);
+		if (IS_ERR(req))
+			return ERR_PTR(PTR_ERR(req));
+
+		req->r_ino1 = vino;
+		req->r_ino2.ino = cfh->parent_ino;
+		req->r_ino2.snap = CEPH_NOSNAP;
+		req->r_path2 = kmalloc(16, GFP_NOFS);
+		snprintf(req->r_path2, 16, "%d", cfh->parent_name_hash);
+		req->r_num_caps = 1;
+		err = ceph_mdsc_do_request(mdsc, NULL, req);
+		ceph_mdsc_put_request(req);
+		inode = ceph_find_inode(sb, vino);
+		if (!inode)
+			return ERR_PTR(err ? err : -ESTALE);
+	}
+
+	dentry = d_obtain_alias(inode);
+	if (!dentry) {
+		pr_err("cfh_to_dentry %llx -- inode %p but ENOMEM\n",
+		       cfh->ino, inode);
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	err = ceph_init_dentry(dentry);
+	if (err < 0) {
+		iput(inode);
+		return ERR_PTR(err);
+	}
+	dout("__cfh_to_dentry %llx %p dentry %p\n", cfh->ino, inode, dentry);
+	return dentry;
+}
+
+static struct dentry *ceph_fh_to_dentry(struct super_block *sb, struct fid *fid,
+					int fh_len, int fh_type)
+{
+	if (fh_type == 1)
+		return __fh_to_dentry(sb, (struct ceph_nfs_fh *)fid->raw);
+	else
+		return __cfh_to_dentry(sb, (struct ceph_nfs_confh *)fid->raw);
+}
+
+/*
+ * get parent, if possible.
+ *
+ * FIXME: we could do better by querying the mds to discover the
+ * parent.
+ */
+static struct dentry *ceph_fh_to_parent(struct super_block *sb,
+					 struct fid *fid,
+					int fh_len, int fh_type)
+{
+	struct ceph_nfs_confh *cfh = (void *)fid->raw;
+	struct ceph_vino vino;
+	struct inode *inode;
+	struct dentry *dentry;
+	int err;
+
+	if (fh_type == 1)
+		return ERR_PTR(-ESTALE);
+
+	pr_debug("fh_to_parent %llx/%d\n", cfh->parent_ino,
+		 cfh->parent_name_hash);
+
+	vino.ino = cfh->ino;
+	vino.snap = CEPH_NOSNAP;
+	inode = ceph_find_inode(sb, vino);
+	if (!inode)
+		return ERR_PTR(-ESTALE);
+
+	dentry = d_obtain_alias(inode);
+	if (!dentry) {
+		pr_err("fh_to_parent %llx -- inode %p but ENOMEM\n",
+		       cfh->ino, inode);
+		iput(inode);
+		return ERR_PTR(-ENOMEM);
+	}
+	err = ceph_init_dentry(dentry);
+	if (err < 0) {
+		iput(inode);
+		return ERR_PTR(err);
+	}
+	dout("fh_to_parent %llx %p dentry %p\n", cfh->ino, inode, dentry);
+	return dentry;
+}
+
+const struct export_operations ceph_export_ops = {
+	.encode_fh = ceph_encode_fh,
+	.fh_to_dentry = ceph_fh_to_dentry,
+	.fh_to_parent = ceph_fh_to_parent,
+};
-- 
1.6.5

