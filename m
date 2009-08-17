Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZHQHH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZHQHH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 03:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZHQHH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 03:07:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35079 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZHQHHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 03:07:55 -0400
Date: Mon, 17 Aug 2009 03:07:47 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       Amerigo Wang <amwang@redhat.com>, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, sds@tycho.nsa.gov,
       hirofumi@mail.parknet.co.jp, viro@zeniv.linux.org.uk
Message-Id: <20090817071011.5913.69970.sendpatchset@localhost.localdomain>
In-Reply-To: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
References: <20090817071001.5913.94767.sendpatchset@localhost.localdomain>
Subject: [Patch 1/2] selinux: ajust rules for ATTR_FORCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As suggested by OGAWA Hirofumi in thread: http://lkml.org/lkml/2009/8/7/132,
we should let selinux_inode_setattr() to match our ATTR_* rules.
ATTR_FORCE should not force things like ATTR_SIZE.

Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1e8cfc4..3ee3365 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2708,18 +2708,24 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 			      file_mask_to_av(inode->i_mode, mask), NULL);
 }
 
+#define SELINUX_FORCED_MASK	(ATTR_MODE | ATTR_UID | ATTR_GID | \
+				ATTR_ATIME_SET | ATTR_MTIME_SET)
 static int selinux_inode_setattr(struct dentry *dentry, struct iattr *iattr)
 {
 	const struct cred *cred = current_cred();
+	unsigned int ia_valid = iattr->ia_valid;
+	int err = 0;
 
-	if (iattr->ia_valid & ATTR_FORCE)
-		return 0;
-
-	if (iattr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
-			       ATTR_ATIME_SET | ATTR_MTIME_SET))
-		return dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
-
-	return dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
+	if ((ia_valid & ATTR_FORCE) && (ia_valid & SELINUX_FORCED_MASK)) {
+		err = dentry_has_perm(cred, NULL, dentry, FILE__SETATTR);
+		if (err)
+			return err;
+		ia_valid &= ~SELINUX_FORCED_MASK;
+		ia_valid &= ~ATTR_FORCE;
+	}
+	if (ia_valid)
+		err = dentry_has_perm(cred, NULL, dentry, FILE__WRITE);
+	return err;
 }
 
 static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
