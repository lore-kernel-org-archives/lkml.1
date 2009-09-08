Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbZIHW6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbZIHW6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 18:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752663AbZIHW6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 18:58:15 -0400
Received: from cobra.newdream.net ([66.33.216.30]:57546 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbZIHW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 18:57:42 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 18/20] ceph: ioctls
Date: Tue,  8 Sep 2009 15:56:39 -0700
Message-Id: <1252450601-17610-19-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1252450601-17610-18-git-send-email-sage@newdream.net>
References: <1252450601-17610-1-git-send-email-sage@newdream.net>
 <1252450601-17610-2-git-send-email-sage@newdream.net>
 <1252450601-17610-3-git-send-email-sage@newdream.net>
 <1252450601-17610-4-git-send-email-sage@newdream.net>
 <1252450601-17610-5-git-send-email-sage@newdream.net>
 <1252450601-17610-6-git-send-email-sage@newdream.net>
 <1252450601-17610-7-git-send-email-sage@newdream.net>
 <1252450601-17610-8-git-send-email-sage@newdream.net>
 <1252450601-17610-9-git-send-email-sage@newdream.net>
 <1252450601-17610-10-git-send-email-sage@newdream.net>
 <1252450601-17610-11-git-send-email-sage@newdream.net>
 <1252450601-17610-12-git-send-email-sage@newdream.net>
 <1252450601-17610-13-git-send-email-sage@newdream.net>
 <1252450601-17610-14-git-send-email-sage@newdream.net>
 <1252450601-17610-15-git-send-email-sage@newdream.net>
 <1252450601-17610-16-git-send-email-sage@newdream.net>
 <1252450601-17610-17-git-send-email-sage@newdream.net>
 <1252450601-17610-18-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few Ceph ioctls for getting and setting file layout (striping)
parameters.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/ioctl.c |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/ioctl.h |   20 +++++++++++
 2 files changed, 118 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/ioctl.c
 create mode 100644 fs/ceph/ioctl.h

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
new file mode 100644
index 0000000..bf5a9d9
--- /dev/null
+++ b/fs/ceph/ioctl.c
@@ -0,0 +1,98 @@
+#include "ioctl.h"
+#include "super.h"
+#include "ceph_debug.h"
+
+
+/*
+ * ioctls
+ */
+
+/*
+ * get and set the file layout
+ */
+static long ceph_ioctl_get_layout(struct file *file, void __user *arg)
+{
+	struct ceph_inode_info *ci = ceph_inode(file->f_dentry->d_inode);
+	struct ceph_ioctl_layout l;
+	int err;
+
+	err = ceph_do_getattr(file->f_dentry->d_inode, CEPH_STAT_CAP_LAYOUT);
+	if (!err) {
+		l.stripe_unit = ceph_file_layout_su(ci->i_layout);
+		l.stripe_count = ceph_file_layout_stripe_count(ci->i_layout);
+		l.object_size = ceph_file_layout_object_size(ci->i_layout);
+		l.data_pool = le32_to_cpu(ci->i_layout.fl_pg_pool);
+		if (copy_to_user(arg, &l, sizeof(l)))
+			return -EFAULT;
+	}
+
+	return err;
+}
+
+static long ceph_ioctl_set_layout(struct file *file, void __user *arg)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *parent_inode = file->f_dentry->d_parent->d_inode;
+	struct ceph_mds_client *mdsc = &ceph_sb_to_client(inode->i_sb)->mdsc;
+	struct ceph_mds_request *req;
+	struct ceph_ioctl_layout l;
+	int err, i;
+
+	/* copy and validate */
+	if (copy_from_user(&l, arg, sizeof(l)))
+		return -EFAULT;
+
+	if ((l.object_size & ~PAGE_MASK) ||
+	    (l.stripe_unit & ~PAGE_MASK) ||
+	    !l.stripe_unit ||
+	    (l.object_size &&
+	     (unsigned)l.object_size % (unsigned)l.stripe_unit)) 
+		return -EINVAL;
+
+	/* make sure it's a valid data pool */
+	if (l.data_pool > 0) {
+		mutex_lock(&mdsc->mutex);
+		err = -EINVAL;
+		for (i = 0; i < mdsc->mdsmap->m_num_data_pg_pools; i++)
+			if (mdsc->mdsmap->m_data_pg_pools[i] == l.data_pool) {
+				err = 0;
+				break;
+			}
+		mutex_unlock(&mdsc->mutex);
+		if (err)
+			return err;
+	}
+
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SETLAYOUT,
+				       USE_AUTH_MDS);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	req->r_inode = igrab(inode);
+	req->r_inode_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL;
+
+	req->r_args.setlayout.layout.fl_stripe_unit =
+		cpu_to_le32(l.stripe_unit);
+	req->r_args.setlayout.layout.fl_stripe_count =
+		cpu_to_le32(l.stripe_count);
+	req->r_args.setlayout.layout.fl_object_size =
+		cpu_to_le32(l.object_size);
+	req->r_args.setlayout.layout.fl_pg_pool = cpu_to_le32(l.data_pool);
+	req->r_args.setlayout.layout.fl_pg_preferred = cpu_to_le32((s32)-1);
+
+	err = ceph_mdsc_do_request(mdsc, parent_inode, req);
+	ceph_mdsc_put_request(req);
+	return err;
+}
+
+long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	dout("ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
+	switch (cmd) {
+	case CEPH_IOC_GET_LAYOUT:
+		return ceph_ioctl_get_layout(file, (void __user *)arg);
+
+	case CEPH_IOC_SET_LAYOUT:
+		return ceph_ioctl_set_layout(file, (void __user *)arg);
+	}
+	return -ENOTTY;
+}
diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
new file mode 100644
index 0000000..56f5e2c
--- /dev/null
+++ b/fs/ceph/ioctl.h
@@ -0,0 +1,20 @@
+#ifndef FS_CEPH_IOCTL_H
+#define FS_CEPH_IOCTL_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+#define CEPH_IOCTL_MAGIC 0x97
+
+/* just use u64 to align sanely on all archs */
+struct ceph_ioctl_layout {
+	__u64 stripe_unit, stripe_count, object_size;
+	__u64 data_pool;
+};
+
+#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1,		\
+				   struct ceph_ioctl_layout)
+#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2,		\
+				   struct ceph_ioctl_layout)
+
+#endif
-- 
1.5.6.5

