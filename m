Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbXDZGLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbXDZGLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXDZGLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:11:22 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:41679 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbXDZGLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:11:21 -0400
Date: Thu, 26 Apr 2007 02:11:19 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH 11/12] selinux: change numbering of boolean directory inodes
 in selinuxfs
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260210570.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Carter <jwcart2@tycho.nsa.gov>

Change the numbering of the booleans directory inodes in selinuxfs to
provide more room for new inodes without a conflict in inode numbers and
to be consistent with how inode numbering is done in the
initial_contexts directory.

Signed-off-by: James Carter <jwcart2@tycho.nsa.gov>
Acked-by: Eric Paris <eparis@parisplace.org>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/selinuxfs.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index 097bc04..aca099a 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -105,6 +105,7 @@ enum sel_inos {
 static unsigned long sel_last_ino = SEL_INO_NEXT - 1;
 
 #define SEL_INITCON_INO_OFFSET 	0x01000000
+#define SEL_BOOL_INO_OFFSET	0x02000000
 #define SEL_INO_MASK		0x00ffffff
 
 #define TMPBUFLEN	12
@@ -782,8 +783,6 @@ static struct inode *sel_make_inode(struct super_block *sb, int mode)
 	return ret;
 }
 
-#define BOOL_INO_OFFSET 30
-
 static ssize_t sel_read_bool(struct file *filep, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
@@ -811,14 +810,14 @@ static ssize_t sel_read_bool(struct file *filep, char __user *buf,
 	}
 
 	inode = filep->f_path.dentry->d_inode;
-	cur_enforcing = security_get_bool_value(inode->i_ino - BOOL_INO_OFFSET);
+	cur_enforcing = security_get_bool_value(inode->i_ino&SEL_INO_MASK);
 	if (cur_enforcing < 0) {
 		ret = cur_enforcing;
 		goto out;
 	}
 
 	length = scnprintf(page, PAGE_SIZE, "%d %d", cur_enforcing,
-			  bool_pending_values[inode->i_ino - BOOL_INO_OFFSET]);
+			  bool_pending_values[inode->i_ino&SEL_INO_MASK]);
 	ret = simple_read_from_buffer(buf, count, ppos, page, length);
 out:
 	mutex_unlock(&sel_mutex);
@@ -870,7 +869,7 @@ static ssize_t sel_write_bool(struct file *filep, const char __user *buf,
 		new_value = 1;
 
 	inode = filep->f_path.dentry->d_inode;
-	bool_pending_values[inode->i_ino - BOOL_INO_OFFSET] = new_value;
+	bool_pending_values[inode->i_ino&SEL_INO_MASK] = new_value;
 	length = count;
 
 out:
@@ -1034,7 +1033,7 @@ static int sel_make_bools(void)
 		isec->sid = sid;
 		isec->initialized = 1;
 		inode->i_fop = &sel_bool_ops;
-		inode->i_ino = i + BOOL_INO_OFFSET;
+		inode->i_ino = i|SEL_BOOL_INO_OFFSET;
 		d_add(dentry, inode);
 	}
 	bool_num = num;
-- 
1.5.0.6

