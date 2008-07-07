Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYGGQxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYGGQxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbYGGQuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:13 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754776AbYGGQuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:10 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/20] SELinux: enable processes with mac_admin to get the raw inode contexts
Date: Tue,  8 Jul 2008 01:42:09 +0900
Message-Id: <1215448942-17581-8-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Smalley <sds@tycho.nsa.gov>

Enable processes with CAP_MAC_ADMIN + mac_admin permission in policy
to get undefined contexts on inodes.  This extends the support for
deferred mapping of security contexts in order to permit restorecon
and similar programs to see the raw file contexts unknown to the
system policy in order to check them.

Signed-off-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/hooks.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4be1563..91b666a 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2754,9 +2754,7 @@ static int selinux_inode_removexattr(struct dentry *dentry, const char *name)
 }
 
 /*
- * Copy the in-core inode security context value to the user.  If the
- * getxattr() prior to this succeeded, check to see if we need to
- * canonicalize the value to be finally returned to the user.
+ * Copy the inode security context value to the user.
  *
  * Permission check is handled by selinux_inode_getxattr hook.
  */
@@ -2765,12 +2763,33 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
 	u32 size;
 	int error;
 	char *context = NULL;
+	struct task_security_struct *tsec = current->security;
 	struct inode_security_struct *isec = inode->i_security;
 
 	if (strcmp(name, XATTR_SELINUX_SUFFIX))
 		return -EOPNOTSUPP;
 
-	error = security_sid_to_context(isec->sid, &context, &size);
+	/*
+	 * If the caller has CAP_MAC_ADMIN, then get the raw context
+	 * value even if it is not defined by current policy; otherwise,
+	 * use the in-core value under current policy.
+	 * Use the non-auditing forms of the permission checks since
+	 * getxattr may be called by unprivileged processes commonly
+	 * and lack of permission just means that we fall back to the
+	 * in-core context value, not a denial.
+	 */
+	error = secondary_ops->capable(current, CAP_MAC_ADMIN);
+	if (!error)
+		error = avc_has_perm_noaudit(tsec->sid, tsec->sid,
+					     SECCLASS_CAPABILITY2,
+					     CAPABILITY2__MAC_ADMIN,
+					     0,
+					     NULL);
+	if (!error)
+		error = security_sid_to_context_force(isec->sid, &context,
+						      &size);
+	else
+		error = security_sid_to_context(isec->sid, &context, &size);
 	if (error)
 		return error;
 	error = size;
-- 
1.5.5.1

