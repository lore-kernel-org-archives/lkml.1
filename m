Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbZFSWgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbZFSWgi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 18:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759488AbZFSWcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 18:32:35 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44730 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995AbZFSWbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 18:31:04 -0400
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 18/21] ceph: ioctls
Date: Fri, 19 Jun 2009 15:31:39 -0700
Message-Id: <1245450702-31343-19-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245450702-31343-18-git-send-email-sage@newdream.net>
References: <1245450702-31343-1-git-send-email-sage@newdream.net>
 <1245450702-31343-2-git-send-email-sage@newdream.net>
 <1245450702-31343-3-git-send-email-sage@newdream.net>
 <1245450702-31343-4-git-send-email-sage@newdream.net>
 <1245450702-31343-5-git-send-email-sage@newdream.net>
 <1245450702-31343-6-git-send-email-sage@newdream.net>
 <1245450702-31343-7-git-send-email-sage@newdream.net>
 <1245450702-31343-8-git-send-email-sage@newdream.net>
 <1245450702-31343-9-git-send-email-sage@newdream.net>
 <1245450702-31343-10-git-send-email-sage@newdream.net>
 <1245450702-31343-11-git-send-email-sage@newdream.net>
 <1245450702-31343-12-git-send-email-sage@newdream.net>
 <1245450702-31343-13-git-send-email-sage@newdream.net>
 <1245450702-31343-14-git-send-email-sage@newdream.net>
 <1245450702-31343-15-git-send-email-sage@newdream.net>
 <1245450702-31343-16-git-send-email-sage@newdream.net>
 <1245450702-31343-17-git-send-email-sage@newdream.net>
 <1245450702-31343-18-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few Ceph ioctls for getting and setting file layout (striping)
parameters.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/staging/ceph/ioctl.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/staging/ceph/ioctl.h |   12 ++++++++
 2 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 fs/staging/ceph/ioctl.c
 create mode 100644 fs/staging/ceph/ioctl.h

diff --git a/fs/staging/ceph/ioctl.c b/fs/staging/ceph/ioctl.c
new file mode 100644
index 0000000..69c65c1
--- /dev/null
+++ b/fs/staging/ceph/ioctl.c
@@ -0,0 +1,65 @@
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
+	err = ceph_do_getattr(file->f_dentry->d_inode, CEPH_STAT_CAP_LAYOUT);
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
+	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_SETLAYOUT,
+				       USE_AUTH_MDS);
+	if (IS_ERR(req))
+		return PTR_ERR(req);
+	req->r_inode = igrab(inode);
+	req->r_inode_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_FILE_EXCL;
+	req->r_args.setlayout.layout = layout;
+
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
diff --git a/fs/staging/ceph/ioctl.h b/fs/staging/ceph/ioctl.h
new file mode 100644
index 0000000..537c27b
--- /dev/null
+++ b/fs/staging/ceph/ioctl.h
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

