Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXGCNdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXGCNdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 09:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753861AbXGCNdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 09:33:33 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56864 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbXGCNdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 09:33:32 -0400
Date: Tue, 3 Jul 2007 08:33:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <morgan@kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       casey@schaufler-ca.com, Andrew Morton <akpm@google.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file caps: update selinux xattr hooks
Message-ID: <20070703133331.GB5388@sergelap.austin.ibm.com>
References: <20070628182255.GA13144@sergelap.austin.ibm.com> <1183387015.12218.25.camel@moss-spartans.epoch.ncsc.mil> <20070702220627.GA12463@sergelap.austin.ibm.com> <1183464846.12218.248.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183464846.12218.248.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Smalley (sds@tycho.nsa.gov):
> On Mon, 2007-07-02 at 17:06 -0500, Serge E. Hallyn wrote:
> > Thanks Stephen, does the following version appear correct?  It just
> > checks for a different cap for security.capability, then if granted
> > goes on to check FILE__GETATTR before granting setxattr or removexattr
> > on any security.* xattr.
> > 
> > thanks,
> > -serge
> > 
> > >From 5ec50bc22d3320565002658433829f7dc5bc0aa5 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Mon, 2 Jul 2007 14:07:51 -0400
> > Subject: [PATCH 1/1] file caps: update selinux xattr hooks (v2)
> > 
> > SELinux does not call out to it's secondary module for setxattr
> > or removexattr mediation, as the secondary module would
> > incorrectly prevent writing of selinux xattrs.  This means
> > that when selinux and capability are both loaded, admins will
> > be able to write file capabilities with CAP_SYS_ADMIN as before,
> > not with CAP_SETFCAP.
> > 
> > Update the selinux hooks to hardcode logic for the special
> > consideration for file caps.
> > 
> > Note that the setxattr and removexattr logic for non selinux
> > attrs appears to be identical.  So I do have another patch
> > where selinux_inode_setotherxattr takes an extra argument
> > u32 av (in case removexattr ever gets its own av permission)
> > so removexattr can shrink and just use that.  But first I
> > thought I'd see if this version is even close correct :)
> 
> Yes, looks sane, and feel free to have both hooks use a common helper
> for non-selinux attributes.  I don't think you even need to bother with
> the u32 av argument; if we later split the check, we can change it then
> (it isn't as though these functions need to have a stable interface).

Great, here is the new patch then.

thanks,
-serge


>From 3aaf0621dd6903ef7b73cc17df4d72140ad1e922 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Mon, 2 Jul 2007 14:14:40 -0400
Subject: [PATCH 1/1] file caps: update selinux xattr hooks (v4)

SELinux does not call out to its secondary module for setxattr
or removexattr mediation, as the secondary module would
incorrectly prevent writing of selinux xattrs.  This means
that when selinux and capability are both loaded, admins will
be able to write file capabilities with CAP_SYS_ADMIN as before,
not with CAP_SETFCAP.

Update the selinux hooks to hardcode logic for the special
consideration for file caps.  Also consolidate the handling
of non-selinux xattrs in removexattr and setxattr.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/selinux/hooks.c |   50 +++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 27 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index af42820..54e8a47 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2289,6 +2289,25 @@ static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
 	return dentry_has_perm(current, mnt, dentry, FILE__GETATTR);
 }
 
+static int selinux_inode_setotherxattr(struct dentry *dentry, char *name)
+{
+	if (!strncmp(name, XATTR_SECURITY_PREFIX,
+		     sizeof XATTR_SECURITY_PREFIX - 1)) {
+		if (!strcmp(name, XATTR_NAME_CAPS)) {
+			if (!capable(CAP_SETFCAP))
+				return -EPERM;
+		} else if (!capable(CAP_SYS_ADMIN)) {
+			/* A different attribute in the security namespace.
+			   Restrict to administrator. */
+			return -EPERM;
+		}
+	}
+
+	/* Not an attribute we recognize, so just check the
+	   ordinary setattr permission. */
+	return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
+}
+
 static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
 {
 	struct task_security_struct *tsec = current->security;
@@ -2299,19 +2318,8 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
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
@@ -2385,20 +2393,8 @@ static int selinux_inode_listxattr (struct dentry *dentry)
 
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
-
-		/* Not an attribute we recognize, so just check the
-		   ordinary setattr permission. Might want a separate
-		   permission for removexattr. */
-		return dentry_has_perm(current, NULL, dentry, FILE__SETATTR);
-	}
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return selinux_inode_setotherxattr(dentry, name);
 
 	/* No one is allowed to remove a SELinux security label.
 	   You can change the label, but all data must be labeled. */
-- 
1.5.1.1.GIT

