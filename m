Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXDZGJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXDZGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbXDZGJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:09:28 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:47140 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbXDZGJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:09:26 -0400
Date: Thu, 26 Apr 2007 02:09:24 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 08/12] selinux: export initial SID contexts via selinuxfs
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260209040.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Carter <jwcart2@tycho.nsa.gov>

Make the initial SID contexts accessible to userspace via selinuxfs.
An initial use of this support will be to make the unlabeled context
available to libselinux for use for invalidated userspace SIDs.

Signed-off-by: James Carter <jwcart2@tycho.nsa.gov>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/include/security.h |    2 +
 security/selinux/selinuxfs.c        |   67 +++++++++++++++++++++++++++++++++++
 security/selinux/ss/services.c      |    7 ++++
 3 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index bfe562c..b94378a 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -123,5 +123,7 @@ static inline int security_netlbl_sid_to_secattr(u32 sid,
 }
 #endif /* CONFIG_NETLABEL */
 
+const char *security_get_initial_sid_context(u32 sid);
+
 #endif /* _SELINUX_SECURITY_H_ */
 
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 93b3177..e24235c 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -102,6 +102,9 @@ enum sel_inos {
 	SEL_COMPAT_NET,	/* whether to use old compat network packet controls */
 };
 
+#define SEL_INITCON_INO_OFFSET 	0x01000000
+#define SEL_INO_MASK		0x00ffffff
+
 #define TMPBUFLEN	12
 static ssize_t sel_read_enforce(struct file *filp, char __user *buf,
 				size_t count, loff_t *ppos)
@@ -1240,6 +1243,55 @@ out:
 	return ret;
 }
 
+static ssize_t sel_read_initcon(struct file * file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	struct inode *inode;
+	char *con;
+	u32 sid, len;
+	ssize_t ret;
+
+	inode = file->f_path.dentry->d_inode;
+	sid = inode->i_ino&SEL_INO_MASK;
+	ret = security_sid_to_context(sid, &con, &len);
+	if (ret < 0)
+		return ret;
+
+	ret = simple_read_from_buffer(buf, count, ppos, con, len);
+	kfree(con);
+	return ret;
+}
+
+static const struct file_operations sel_initcon_ops = {
+	.read		= sel_read_initcon,
+};
+
+static int sel_make_initcon_files(struct dentry *dir)
+{
+	int i, ret = 0;
+
+	for (i = 1; i <= SECINITSID_NUM; i++) {
+		struct inode *inode;
+		struct dentry *dentry;
+		dentry = d_alloc_name(dir, security_get_initial_sid_context(i));
+		if (!dentry) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		inode = sel_make_inode(dir->d_sb, S_IFREG|S_IRUGO);
+		if (!inode) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		inode->i_fop = &sel_initcon_ops;
+		inode->i_ino = i|SEL_INITCON_INO_OFFSET;
+		d_add(dentry, inode);
+	}
+out:
+	return ret;
+}
+
 static int sel_make_dir(struct inode *dir, struct dentry *dentry)
 {
 	int ret = 0;
@@ -1336,6 +1388,21 @@ static int sel_fill_super(struct super_block * sb, void * data, int silent)
 	ret = sel_make_avc_files(dentry);
 	if (ret)
 		goto err;
+
+	dentry = d_alloc_name(sb->s_root, "initial_contexts");
+	if (!dentry) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = sel_make_dir(root_inode, dentry);
+	if (ret)
+		goto err;
+
+	ret = sel_make_initcon_files(dentry);
+	if (ret)
+		goto err;
+
 out:
 	return ret;
 err:
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index d369856..21b8318 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -593,6 +593,13 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
 
 #include "initial_sid_to_string.h"
 
+const char *security_get_initial_sid_context(u32 sid)
+{
+	if (unlikely(sid > SECINITSID_NUM))
+		return NULL;
+	return initial_sid_to_string[sid];
+}
+
 /**
  * security_sid_to_context - Obtain a context for a given SID.
  * @sid: security identifier, SID
-- 
1.5.0.6

