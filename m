Return-Path: <linux-kernel-owner+w=401wt.eu-S1765510AbXF1S3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765510AbXF1S3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764031AbXF1S3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:29:38 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47024 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761058AbXF1S3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:29:37 -0400
Date: Thu, 28 Jun 2007 13:22:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1] file caps: update selinux xattr hooks
Message-ID: <20070628182255.GA13144@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a shortcoming of the cap_setfcap patch I sent earlier,
pointed out by Stephen Smalley.

Seems to compile and boot on my little systems.

thanks,
-serge

>From d729000b922a2877a48ce2b5a03a9366d8c65d04 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Thu, 28 Jun 2007 11:57:19 -0400
Subject: [PATCH 1/1] file caps: update selinux xattr hooks

SELinux does not call out to it's secondary module for setxattr
or removexattr mediation, as the secondary module would
incorrectly prevent writing of selinux xattrs.  This means
that when selinux and capability are both loaded, admins will
be able to write file capabilities with CAP_SYS_ADMIN as before,
not with CAP_SETFCAP.

Update the selinux hooks to hardcode logic for the special
consideration for file caps.

I changed the flow of the removexattr hook to reduce the amount
of indentation I was getting.  It was probably written the way
it was for a reason, and if it was, I apologize and will
rewrite :)  If it wasn't, hopefully this way is ok.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/selinux/hooks.c |   75 +++++++++++++++++++++++++++++----------------
 1 files changed, 48 insertions(+), 27 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index af42820..db0a4ed 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2289,6 +2289,30 @@ static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
+/* called by selinux_inode_setxattr to mediate setting
+ * of non-selinux xattrs */
+static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+{
+	if (strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof XATTR_SECURITY_PREFIX - 1))
+		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+
+	/* a file capability requires cap_setfcap */
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		else
+			return 0;
+	}
+
+	/* A different attribute in the security namespace.
+	   Restrict to administrator. */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return 0;
+}
+
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
@@ -2299,19 +2323,8 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
 	u32 newsid;
 	int rc = 0;
 
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	sbsec = inode->i_sb->s_security;
 	if (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)
@@ -2385,24 +2398,32 @@ static int selinux_inode_listxattr (struct dentry *dentry)
 
 static int selinux_inode_removexattr (struct dentry *dentry, char *name)
 {
-	if (strcmp(name, XATTR_NAME_SELINUX)) {
-		if (!strncmp(name, XATTR_SECURITY_PREFIX,
-			     sizeof XATTR_SECURITY_PREFIX - 1) &&
-		    !capable(CAP_SYS_ADMIN)) {
-			/* A different attribute in the security namespace.
-			   Restrict to administrator. */
-			return -EPERM;
-		}
+	/* No one is allowed to remove a SELinux security label.
+	   You can change the label, but all data must be labeled. */
+	if (!strcmp(name, XATTR_NAME_SELINUX))
+		return -EACCES;
 
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. Might want a separate
-		   permission for removexattr. */
+	/* Not an attribute we recognize, so just check the
+	   ordinary setattr permission. Might want a separate
+	   permission for removexattr. */
+	if (strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof XATTR_SECURITY_PREFIX - 1))
 		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+
+	/* a file capability requires cap_setfcap */
+	if (!strcmp(name, XATTR_NAME_CAPS)) {
+		if (!capable(CAP_SETFCAP))
+			return -EPERM;
+		else
+			return 0;
 	}
 
-	/* No one is allowed to remove a SELinux security label.
-	   You can change the label, but all data must be labeled. */
-	return -EACCES;
+	/* A different attribute in the security namespace.
+	   Restrict to administrator. */
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return 0;
 }
 
 static const char *selinux_inode_xattr_getsuffix(void)
-- 
1.5.1.1.GIT

