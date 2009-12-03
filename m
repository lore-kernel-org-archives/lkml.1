Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055AbZLCXhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbZLCXhF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 18:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZLCXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 18:36:58 -0500
Received: from cobra.newdream.net ([66.33.216.30]:36115 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZLCXgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 18:36:20 -0500
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Sage Weil <sage@newdream.net>
Subject: [PATCH 22/24] ceph: ioctls
Date: Thu,  3 Dec 2009 15:41:29 -0800
Message-Id: <1259883691-1042-23-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1259883691-1042-22-git-send-email-sage@newdream.net>
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
 <1259883691-1042-22-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few Ceph ioctls for getting and setting file layout (striping)
parameters, and learning the identity and network address of the OSD a
given region of a file is stored on.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 Documentation/ioctl/ioctl-number.txt |    1 +
 fs/ceph/ioctl.c                      |  160 ++++++++++++++++++++++++++++++++++
 fs/ceph/ioctl.h                      |   40 +++++++++
 3 files changed, 201 insertions(+), 0 deletions(-)
 create mode 100644 fs/ceph/ioctl.c
 create mode 100644 fs/ceph/ioctl.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 9473749..91cfdd7 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -182,6 +182,7 @@ Code	Seq#	Include File		Comments
 					<http://www.proximity.com.au/~brian/winradio/>
 0x90	00	drivers/cdrom/sbpcd.h
 0x93	60-7F	linux/auto_fs.h
+0x97    00-7F   fs/ceph/ioctl.h         Ceph file system
 0x99	00-0F				537-Addinboard driver
 					<mailto:buk@buks.ipn.de>
 0xA0	all	linux/sdp/sdp.h		Industrial Device Project
diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
new file mode 100644
index 0000000..8a5bcae
--- /dev/null
+++ b/fs/ceph/ioctl.c
@@ -0,0 +1,160 @@
+#include <linux/in.h>
+
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
+		l.preferred_osd =
+			(s32)le32_to_cpu(ci->i_layout.fl_pg_preferred);
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
+	req->r_args.setlayout.layout.fl_pg_preferred =
+		cpu_to_le32(l.preferred_osd);
+
+	err = ceph_mdsc_do_request(mdsc, parent_inode, req);
+	ceph_mdsc_put_request(req);
+	return err;
+}
+
+/*
+ * Return object name, size/offset information, and location (OSD
+ * number, network address) for a given file offset.
+ */
+static long ceph_ioctl_get_dataloc(struct file *file, void __user *arg)
+{
+	struct ceph_ioctl_dataloc dl;
+	struct inode *inode = file->f_dentry->d_inode;
+	struct ceph_inode_info *ci = ceph_inode(inode);
+	struct ceph_osd_client *osdc = &ceph_client(inode->i_sb)->osdc;
+	u64 len = 1, olen;
+	u64 tmp;
+	struct ceph_object_layout ol;
+	struct ceph_pg pgid;
+
+	/* copy and validate */
+	if (copy_from_user(&dl, arg, sizeof(dl)))
+		return -EFAULT;
+
+	down_read(&osdc->map_sem);
+	ceph_calc_file_object_mapping(&ci->i_layout, dl.file_offset, &len,
+				      &dl.object_no, &dl.object_offset, &olen);
+	dl.file_offset -= dl.object_offset;
+	dl.object_size = ceph_file_layout_object_size(ci->i_layout);
+	dl.block_size = ceph_file_layout_su(ci->i_layout);
+
+	/* block_offset = object_offset % block_size */
+	tmp = dl.object_offset;
+	dl.block_offset = do_div(tmp, dl.block_size);
+
+	snprintf(dl.object_name, sizeof(dl.object_name), "%llx.%08llx",
+		 ceph_ino(inode), dl.object_no);
+	ceph_calc_object_layout(&ol, dl.object_name, &ci->i_layout,
+				osdc->osdmap);
+
+	pgid = ol.ol_pgid;
+	dl.osd = ceph_calc_pg_primary(osdc->osdmap, pgid);
+	if (dl.osd >= 0) {
+		struct ceph_entity_addr *a =
+			ceph_osd_addr(osdc->osdmap, dl.osd);
+		if (a)
+			memcpy(&dl.osd_addr, &a->in_addr, sizeof(dl.osd_addr));
+	} else {
+		memset(&dl.osd_addr, 0, sizeof(dl.osd_addr));
+	}
+	up_read(&osdc->map_sem);
+
+	/* send result back to user */
+	if (copy_to_user(arg, &dl, sizeof(dl)))
+		return -EFAULT;
+
+	return 0;
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
+
+	case CEPH_IOC_GET_DATALOC:
+		return ceph_ioctl_get_dataloc(file, (void __user *)arg);
+	}
+	return -ENOTTY;
+}
diff --git a/fs/ceph/ioctl.h b/fs/ceph/ioctl.h
new file mode 100644
index 0000000..25e4f1a
--- /dev/null
+++ b/fs/ceph/ioctl.h
@@ -0,0 +1,40 @@
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
+	__s64 preferred_osd;
+};
+
+#define CEPH_IOC_GET_LAYOUT _IOR(CEPH_IOCTL_MAGIC, 1,		\
+				   struct ceph_ioctl_layout)
+#define CEPH_IOC_SET_LAYOUT _IOW(CEPH_IOCTL_MAGIC, 2,		\
+				   struct ceph_ioctl_layout)
+
+/*
+ * Extract identity, address of the OSD and object storing a given
+ * file offset.
+ */
+struct ceph_ioctl_dataloc {
+	__u64 file_offset;           /* in+out: file offset */
+	__u64 object_offset;         /* out: offset in object */
+	__u64 object_no;             /* out: object # */
+	__u64 object_size;           /* out: object size */
+	char object_name[64];        /* out: object name */
+	__u64 block_offset;          /* out: offset in block */
+	__u64 block_size;            /* out: block length */
+	__s64 osd;                   /* out: osd # */
+	struct sockaddr_storage osd_addr; /* out: osd address */
+};
+
+#define CEPH_IOC_GET_DATALOC _IOWR(CEPH_IOCTL_MAGIC, 3,	\
+				   struct ceph_ioctl_dataloc)
+
+#endif
-- 
1.6.5

