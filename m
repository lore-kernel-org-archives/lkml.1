Return-Path: <linux-kernel-owner+w=401wt.eu-S1764768AbXILIvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764768AbXILIvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbXILIvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:51:40 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50896 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbXILIvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:51:37 -0400
Date: Wed, 12 Sep 2007 17:51:15 +0900
From: Yuichi Nakamura <ynakam@hitachisoft.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC]selinux: Improving SELinux read/write performance
Cc: ynakam@hitachisoft.jp, selinux@tycho.nsa.gov, busybox@kaigai.gr.jp,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       kaigai@ak.jp.nec.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1189429354.11972.8.camel@moss-spartans.epoch.ncsc.mil>
References: <20070910102250.FF41.YNAKAM@hitachisoft.jp> <1189429354.11972.8.camel@moss-spartans.epoch.ncsc.mil>
Message-Id: <20070912174759.1B94.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.31 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. 

Stephen Smalley pointed out possibility of race condition
in off-list discussion.
Stephen Smalley said:
> One other observation about the patch:  it presently leaves open a
> (small) race window in which the file could get relabeled or policy gets
> reloaded between the time of the normal permission check (from
> selinux_inode_permission) and the time you copy the inode SID and policy
> seqno to the file security struct.  In which case you might end up never
> revalidating access upon read/write even though conditions changed since
> the open-time permission check.  Not sure how to cleanly fix in a
> lock-free manner, and adding locks here will only make matters worse.

To fix that, permission has to be checked in selinux_dentry_open.
Therefore, in open, number of permission checks increased.
As shown in benchmark result below, it does not affect open/close 
performance so much.

Following is benchmark result.
* Benchmark
lmbench simple read,write,open/close.

* Before tuning
1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
                Base  SELinux  Overhead(%)
Simple read     1.10  1.24     12.3
Simple write    1.02  1.14     14.0
open/close      5.97  7.45     24.9
* Base: kernel compiled without SELinux support

2) Result for SH(SH4, SH7751R), kernel 2.6.22
                Base    SELinux   Overhead(%)
Simple read     2.39    5.49      130.5
Simple write    2.07    5.10      146.6
open/close      32.6    62.8      93.0

* After tuning
1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
                Base  SELinux  Overhead(%)
Simple read     1.10  1.13     2.3(Before 12.3)
Simple write    1.02  1.024    0.6(Before 14.0)
open/close      5.97  7.48     25.3(Before 24.9)
* Base: kernel compiled without SELinux support

2) Result for SH(SH4, SH7751R), kernel 2.6.22
                Base    SELinux   Overhead(%)
Simple read     2.39    2.63      10.4(Before 130.5)
Simple write    2.07    2.34      13.1(Before 146.6)
open/close      32.6    58.7      80.2(before 93.0)

Next is a patch.

* Description of patch
This patch improves performance of read/write in SELinux.
It improves performance by skipping permission check in 
selinux_file_permission. Permission is only checked when 
sid change or policy load is detected after file open.
To detect sid change, new LSM hook securiy_dentry_open is added.

Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
---
 fs/open.c                         |    5 ++++
 include/linux/security.h          |   16 ++++++++++++++
 security/dummy.c                  |    6 +++++
 security/selinux/avc.c            |    5 ++++
 security/selinux/hooks.c          |   43 +++++++++++++++++++++++++++++++++++++-
 security/selinux/include/avc.h    |    2 +
 security/selinux/include/objsec.h |    2 +
 7 files changed, 78 insertions(+), 1 deletion(-)
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/avc.c linux-2.6.22/security/selinux/avc.c
--- linux-2.6.22.orig/security/selinux/avc.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/avc.c	2007-09-12 08:24:27.000000000 +0900
@@ -913,3 +913,8 @@ int avc_has_perm(u32 ssid, u32 tsid, u16
 	avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
 	return rc;
 }
+
+u32 avc_policy_seqno(void)
+{
+	return avc_cache.latest_notif;
+}
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/hooks.c linux-2.6.22/security/selinux/hooks.c
--- linux-2.6.22.orig/security/selinux/hooks.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/hooks.c	2007-09-12 08:42:49.000000000 +0900
@@ -14,6 +14,8 @@
  *                          <dgoeddel@trustedcs.com>
  *  Copyright (C) 2006 Hewlett-Packard Development Company, L.P.
  *                     Paul Moore, <paul.moore@hp.com>
+ *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
+ *                     Yuichi Nakamura <ynakam@hitachisoft.jp>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -80,6 +82,7 @@
 
 #define XATTR_SELINUX_SUFFIX "selinux"
 #define XATTR_NAME_SELINUX XATTR_SECURITY_PREFIX XATTR_SELINUX_SUFFIX
+#define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])
 
 extern unsigned int policydb_loaded_version;
 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
@@ -2458,7 +2461,7 @@ static int selinux_inode_listsecurity(st
 
 /* file security operations */
 
-static int selinux_file_permission(struct file *file, int mask)
+static int selinux_revalidate_file_permission(struct file *file, int mask)
 {
 	int rc;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -2480,6 +2483,25 @@ static int selinux_file_permission(struc
 	return selinux_netlbl_inode_permission(inode, mask);
 }
 
+static int selinux_file_permission(struct file *file, int mask)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct task_security_struct *tsec = current->security;
+	struct file_security_struct *fsec = file->f_security;
+	struct inode_security_struct *isec = inode->i_security;
+
+	if (!mask) {
+		/* No permission to check.  Existence test. */
+		return 0;
+	}
+
+	if (tsec->sid == fsec->sid && fsec->isid == isec->sid
+	    && fsec->pseqno == avc_policy_seqno())
+		return selinux_netlbl_inode_permission(inode, mask);
+
+	return selinux_revalidate_file_permission(file, mask);
+}
+
 static int selinux_file_alloc_security(struct file *file)
 {
 	return file_alloc_security(file);
@@ -2715,6 +2737,23 @@ static int selinux_file_receive(struct f
 	return file_has_perm(current, file, file_to_av(file));
 }
 
+static int selinux_dentry_open(struct file *file)
+{
+	struct file_security_struct *fsec;
+	struct inode *inode;
+	struct inode_security_struct *isec;
+	inode = file->f_path.dentry->d_inode;
+	fsec = file->f_security;
+	isec = inode->i_security;
+	fsec->isid = isec->sid;
+	fsec->pseqno = avc_policy_seqno();
+
+	/*Permission has to be rechecked here.
+	  Policy load of inode sid can happen between
+	  may_open and selinux_dentry_open.*/
+	return inode_has_perm(current, inode, file_to_av(file), NULL);
+}
+
 /* task security operations */
 
 static int selinux_task_create(unsigned long clone_flags)
@@ -4780,6 +4819,8 @@ static struct security_operations selinu
 	.file_send_sigiotask =		selinux_file_send_sigiotask,
 	.file_receive =			selinux_file_receive,
 
+	.dentry_open =                  selinux_dentry_open,
+
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/avc.h linux-2.6.22/security/selinux/include/avc.h
--- linux-2.6.22.orig/security/selinux/include/avc.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/include/avc.h	2007-09-12 08:24:27.000000000 +0900
@@ -110,6 +110,8 @@ int avc_has_perm(u32 ssid, u32 tsid,
                  u16 tclass, u32 requested,
                  struct avc_audit_data *auditdata);
 
+u32 avc_policy_seqno(void);
+
 #define AVC_CALLBACK_GRANT		1
 #define AVC_CALLBACK_TRY_REVOKE		2
 #define AVC_CALLBACK_REVOKE		4
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/objsec.h linux-2.6.22/security/selinux/include/objsec.h
--- linux-2.6.22.orig/security/selinux/include/objsec.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/include/objsec.h	2007-09-12 08:24:27.000000000 +0900
@@ -53,6 +53,8 @@ struct file_security_struct {
 	struct file *file;              /* back pointer to file object */
 	u32 sid;              /* SID of open file description */
 	u32 fown_sid;         /* SID of file owner (for SIGIO) */
+	u32 isid;             /* SID of inode at the time of file open */
+	u32 pseqno;           /* Policy seqno at the time of file open */
 };
 
 struct superblock_security_struct {
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/fs/open.c linux-2.6.22/fs/open.c
--- linux-2.6.22.orig/fs/open.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/fs/open.c	2007-09-12 08:31:24.000000000 +0900
@@ -696,8 +696,13 @@ static struct file *__dentry_open(struct
 	f->f_op = fops_get(inode->i_fop);
 	file_move(f, &inode->i_sb->s_files);
 
+	error = security_dentry_open(f);
+	if (error)
+		goto cleanup_all;
+
 	if (!open && f->f_op)
 		open = f->f_op->open;
+
 	if (open) {
 		error = open(inode, f);
 		if (error)
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/include/linux/security.h linux-2.6.22/include/linux/security.h
--- linux-2.6.22.orig/include/linux/security.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/include/linux/security.h	2007-09-12 08:30:16.000000000 +0900
@@ -503,6 +503,11 @@ struct request_sock;
  *	@file contains the file structure being received.
  *	Return 0 if permission is granted.
  *
+ * Security hook for dentry
+ *
+ * @dentry_open
+ *   Check permission or get additional information before opening dentry.
+ *
  * Security hooks for task operations.
  *
  * @task_create:
@@ -1253,6 +1258,7 @@ struct security_operations {
 	int (*file_send_sigiotask) (struct task_struct * tsk,
 				    struct fown_struct * fown, int sig);
 	int (*file_receive) (struct file * file);
+	int (*dentry_open)  (struct file *file);
 
 	int (*task_create) (unsigned long clone_flags);
 	int (*task_alloc_security) (struct task_struct * p);
@@ -1854,6 +1860,11 @@ static inline int security_file_receive 
 	return security_ops->file_receive (file);
 }
 
+static inline int security_dentry_open (struct file *file)
+{
+	return security_ops->dentry_open (file);
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return security_ops->task_create (clone_flags);
@@ -2529,6 +2540,11 @@ static inline int security_file_receive 
 	return 0;
 }
 
+static inline int security_dentry_open (struct file *file)
+{
+	return 0;
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return 0;
--- linux-2.6.22.orig/security/dummy.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/dummy.c	2007-09-12 08:29:45.000000000 +0900
@@ -459,6 +459,11 @@ static int dummy_file_receive (struct fi
 	return 0;
 }
 
+static int dummy_dentry_open (struct file *file)
+{
+	return 0;
+}
+
 static int dummy_task_create (unsigned long clone_flags)
 {
 	return 0;
@@ -1029,6 +1034,7 @@ void security_fixup_ops (struct security
 	set_to_dummy_if_null(ops, file_set_fowner);
 	set_to_dummy_if_null(ops, file_send_sigiotask);
 	set_to_dummy_if_null(ops, file_receive);
+	set_to_dummy_if_null(ops, dentry_open);
 	set_to_dummy_if_null(ops, task_create);
 	set_to_dummy_if_null(ops, task_alloc_security);
 	set_to_dummy_if_null(ops, task_free_security);

Regards,
-- 
Yuichi Nakamura
Hitachi Software Engineering Co., Ltd.
Japan SELinux Users Group(JSELUG): http://www.selinux.gr.jp/
SELinux Policy Editor: http://seedit.sourceforge.net/

