Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZCIWry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZCIWry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZCIWl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:41:56 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50071 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZCIWk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:40:28 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 17/20] ceph: ioctls
Date: Mon,  9 Mar 2009 15:40:36 -0700
Message-Id: <1236638439-6753-18-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236638439-6753-17-git-send-email-sage@newdream.net>
References: <1236638439-6753-1-git-send-email-sage@newdream.net>
 <1236638439-6753-2-git-send-email-sage@newdream.net>
 <1236638439-6753-3-git-send-email-sage@newdream.net>
 <1236638439-6753-4-git-send-email-sage@newdream.net>
 <1236638439-6753-5-git-send-email-sage@newdream.net>
 <1236638439-6753-6-git-send-email-sage@newdream.net>
 <1236638439-6753-7-git-send-email-sage@newdream.net>
 <1236638439-6753-8-git-send-email-sage@newdream.net>
 <1236638439-6753-9-git-send-email-sage@newdream.net>
 <1236638439-6753-10-git-send-email-sage@newdream.net>
 <1236638439-6753-11-git-send-email-sage@newdream.net>
 <1236638439-6753-12-git-send-email-sage@newdream.net>
 <1236638439-6753-13-git-send-email-sage@newdream.net>
 <1236638439-6753-14-git-send-email-sage@newdream.net>
 <1236638439-6753-15-git-send-email-sage@newdream.net>
 <1236638439-6753-16-git-send-email-sage@newdream.net>
 <1236638439-6753-17-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few Ceph ioctls for getting and setting file layout (striping)
parameters.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/ioctl.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ceph/ioctl.h |   12 ++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/ioctl.c
 create mode 100644 fs/ceph/ioctl.h

diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
new file mode 100644
index 0000000..55c992e
--- /dev/null
+++ b/fs/ceph/ioctl.c
@@ -0,0 +1,62 @@
+#include "ioctl.h"
+#include "super.h"
+#include "ceph_debug.h"
+
+int ceph_debug_ioctl __read_mostly = -1;
+#define DOUT_MASK DOUT_MASK_IOCTL
+#define DOUT_VAR ceph_debug_ioctl
+
+
+/*
+ * ioctls
+ */
+
+static long ceph_ioctl_get_layout(struct file *file, void __user *arg)
+{
+	struct ceph_inode_info *ci = ceph_inode(file->f_dentry->d_inode);
+	int err;
+
+	err = ceph_do_getattr(file->f_dentry, CEPH_STAT_CAP_LAYOUT);
+	if (!err) {
+		if (copy_to_user(arg, &ci->i_layout, sizeof(ci->i_layout)))
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
+	struct ceph_file_layout layout;
+	int err;
+
+	/* copy and validate */
+	if (copy_from_user(&layout, arg, sizeof(layout)))
+		return -EFAULT;
+
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LSETLAYOUT,
+				       file->f_dentry, NULL, NULL, NULL,
+				       USE_AUTH_MDS);
+	req->r_args.setlayout.layout = layout;
+	ceph_release_caps(inode, CEPH_CAP_FILE_RDCACHE);
+	err = ceph_mdsc_do_request(mdsc, parent_inode, req);
+	ceph_mdsc_put_request(req);
+	return err;
+}
+
+long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	dout(10, "ioctl file %p cmd %u arg %lu\n", file, cmd, arg);
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
index 0000000..537c27b
--- /dev/null
+++ b/fs/ceph/ioctl.h
@@ -0,0 +1,12 @@
+#ifndef FS_CEPH_IOCTL_H
+#define FS_CEPH_IOCTL_H
+
+#include <linux/ioctl.h>
+#include "types.h"
+
+#define CEPH_IOCTL_MAGIC 0x97
+
+#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1, struct ceph_file_layout)
+#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2, struct ceph_file_layout)
+
+#endif
-- 
1.5.6.5

