Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZKTTBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZKTTBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 14:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZKTTBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 14:01:20 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51896 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbZKTTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 14:01:19 -0500
To: <linux-kernel@vger.kernel.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC][PATCH] security/selinux: Simplify proc inode to security label mapping.
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 20 Nov 2009 11:01:19 -0800
Message-ID: <m11vjtrpfk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently selinux has incestuous knowledge of the implementation details
of procfs and sysctl that it uses to get a pathname from an inode. As it
happens the point we care is in the security_d_instantiate lsm hook so
we have a valid dentry that we can use to get the entire pathname on
the proc filesystem.  With the recent change to sys_sysctl to go through
proc/sys all proc and sysctl accesses go through the vfs, which
means we no longer need a sysctl special case.

So get the path for the dentry, remove the incestuous knowledge
and simplify the code.

caveat: Because the dentry may not yet be hashed I think dentry_path will
        append (deleted) and thus is not the right function to call.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 security/selinux/hooks.c |  114 ++++-----------------------------------------
 1 files changed, 11 insertions(+), 103 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index bb230d5..37ed36e 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -43,7 +43,6 @@
 #include <linux/fdtable.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
-#include <linux/proc_fs.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/tty.h>
@@ -70,7 +69,6 @@
 #include <net/ipv6.h>
 #include <linux/hugetlb.h>
 #include <linux/personality.h>
-#include <linux/sysctl.h>
 #include <linux/audit.h>
 #include <linux/string.h>
 #include <linux/selinux.h>
@@ -1178,39 +1176,27 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 }
 
 #ifdef CONFIG_PROC_FS
-static int selinux_proc_get_sid(struct proc_dir_entry *de,
+static int selinux_proc_get_sid(struct dentry *dentry,
 				u16 tclass,
 				u32 *sid)
 {
-	int buflen, rc;
-	char *buffer, *path, *end;
+	int rc;
+	char *buffer, *path;
 
 	buffer = (char *)__get_free_page(GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-	buflen = PAGE_SIZE;
-	end = buffer+buflen;
-	*--end = '\0';
-	buflen--;
-	path = end-1;
-	*path = '/';
-	while (de && de != de->parent) {
-		buflen -= de->namelen + 1;
-		if (buflen < 0)
-			break;
-		end -= de->namelen;
-		memcpy(end, de->name, de->namelen);
-		*--end = '/';
-		path = end;
-		de = de->parent;
-	}
-	rc = security_genfs_sid("proc", path, tclass, sid);
+	path = dentry_path(dentry, buffer, PAGE_SIZE);
+	if (IS_ERR(path))
+		rc = PTR_ERR(path);
+	else
+		rc = security_genfs_sid("proc", path, tclass, sid);
 	free_page((unsigned long)buffer);
 	return rc;
 }
 #else
-static int selinux_proc_get_sid(struct proc_dir_entry *de,
+static int selinux_proc_get_sid(struct dentry *dentry,
 				u16 tclass,
 				u32 *sid)
 {
@@ -1374,10 +1360,9 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 		isec->sid = sbsec->sid;
 
 		if ((sbsec->flags & SE_SBPROC) && !S_ISLNK(inode->i_mode)) {
-			struct proc_inode *proci = PROC_I(inode);
-			if (proci->pde) {
+			if (opt_dentry) {
 				isec->sclass = inode_mode_to_security_class(inode->i_mode);
-				rc = selinux_proc_get_sid(proci->pde,
+				rc = selinux_proc_get_sid(opt_dentry,
 							  isec->sclass,
 							  &sid);
 				if (rc)
@@ -1939,82 +1924,6 @@ static int selinux_capable(struct task_struct *tsk, const struct cred *cred,
 	return task_has_capability(tsk, cred, cap, audit);
 }
 
-static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
-{
-	int buflen, rc;
-	char *buffer, *path, *end;
-
-	rc = -ENOMEM;
-	buffer = (char *)__get_free_page(GFP_KERNEL);
-	if (!buffer)
-		goto out;
-
-	buflen = PAGE_SIZE;
-	end = buffer+buflen;
-	*--end = '\0';
-	buflen--;
-	path = end-1;
-	*path = '/';
-	while (table) {
-		const char *name = table->procname;
-		size_t namelen = strlen(name);
-		buflen -= namelen + 1;
-		if (buflen < 0)
-			goto out_free;
-		end -= namelen;
-		memcpy(end, name, namelen);
-		*--end = '/';
-		path = end;
-		table = table->parent;
-	}
-	buflen -= 4;
-	if (buflen < 0)
-		goto out_free;
-	end -= 4;
-	memcpy(end, "/sys", 4);
-	path = end;
-	rc = security_genfs_sid("proc", path, tclass, sid);
-out_free:
-	free_page((unsigned long)buffer);
-out:
-	return rc;
-}
-
-static int selinux_sysctl(ctl_table *table, int op)
-{
-	int error = 0;
-	u32 av;
-	u32 tsid, sid;
-	int rc;
-
-	sid = current_sid();
-
-	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
-				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
-	if (rc) {
-		/* Default to the well-defined sysctl SID. */
-		tsid = SECINITSID_SYSCTL;
-	}
-
-	/* The op values are "defined" in sysctl.c, thereby creating
-	 * a bad coupling between this module and sysctl.c */
-	if (op == 001) {
-		error = avc_has_perm(sid, tsid,
-				     SECCLASS_DIR, DIR__SEARCH, NULL);
-	} else {
-		av = 0;
-		if (op & 004)
-			av |= FILE__READ;
-		if (op & 002)
-			av |= FILE__WRITE;
-		if (av)
-			error = avc_has_perm(sid, tsid,
-					     SECCLASS_FILE, av, NULL);
-	}
-
-	return error;
-}
-
 static int selinux_quotactl(int cmds, int type, int id, struct super_block *sb)
 {
 	const struct cred *cred = current_cred();
@@ -5457,7 +5366,6 @@ static struct security_operations selinux_ops = {
 	.ptrace_traceme =		selinux_ptrace_traceme,
 	.capget =			selinux_capget,
 	.capset =			selinux_capset,
-	.sysctl =			selinux_sysctl,
 	.capable =			selinux_capable,
 	.quotactl =			selinux_quotactl,
 	.quota_on =			selinux_quota_on,
-- 
1.6.5.2.143.g8cc62

