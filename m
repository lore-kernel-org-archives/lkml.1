Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbXIFHfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbXIFHfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 03:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXIFHfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 03:35:39 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:56292 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbXIFHfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 03:35:37 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Sep 2007 03:35:36 EDT
Date: Thu, 06 Sep 2007 16:27:16 +0900
From: Yuichi Nakamura <ynakam@hitachisoft.jp>
To: selinux@tycho.nsa.gov
Subject: [RFC]selinux: Improving SELinux read/write performance
Cc: ynakam@hitachisoft.jp, Stephen Smalley <sds@tycho.nsa.gov>,
       busybox@kaigai.gr.jp, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, kaigai@ak.jp.nec.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20070906161242.6767.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.31 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

As I posted before in selinux list,
I found big overhead of SELinux in read/write on some CPUs,
and trying tuning.
There were discussion in previous threads.
Part 1:
http://marc.info/?t=118845343400001&r=1&w=2
Part 2:
http://marc.info/?t=118880749800004&r=1&w=2

I would like to RFC again about this topic.

1. Background
Look at benchmark result below.
lmbench simple read/write.
Big overhead exists especially on SH(SuperH) arch.

1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
                Base  SELinux  Overhead(%)
Simple read     1.10  1.24     12.3
Simple write    1.00  1.14     14.0
* Base: kernel compiled without SELinux support

2) Result for SH(SH4, SH7751R), kernel 2.6.22
                Base    SELinux   Overhead(%)
Simple read     2.39    5.49      130.5
Simple write    2.07    5.10      146.6
# This result is a little different from previous threads, 
# because I changed some kernel configs.

Overhead more than 100%
I also found about 70-90% overhead in ARM.

2. About patch
I found a overhead in selinux_file_permission function.
This is a function that is called in read/write calls, 
and does SELinux permission check.
SELinux checks permission both in open and read/write time.
Stephen Smalley sugessted that we can usually skip permission check 
in selinux_file_permission.
By this patch, 
permission check in selinux_file_permssion is done only when
- sid of task has changed after file open
- sid of inode has changed after file open
- policy load or boolean change happen after file open

To detect these changes,
I added entries in file_security struct and saving these values at file open.

And to save sid of inode at the time of file open,
I had to add new LSM hook in __dentry_open function.

3. Benchmark after applying this patch
1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
                Base  SELinux  Overhead(%)
Simple read     1.10  1.12     1.6(Before 12.3)
Simple write    1.00  1.03     3.6(Before 14.0)

2) Result for SH(SH4, SH7751R), kernel 2.6.22
                Base    SELinux   Overhead(%)
Simple read     2.39    2.65      11.1(Before 130.5)
Simple write    2.07    2.28      10.5(Before 146.6)

Performance has improved a lot.
I want comments from community.

Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
---
 fs/open.c                         |    5 +++
 include/linux/security.h          |   11 +++++++
 security/selinux/avc.c            |    5 ++-
 security/selinux/hooks.c          |   54 +++++++++++++++++++++++++++++++++++++-
 security/selinux/include/objsec.h |    3 ++
 5 files changed, 76 insertions(+), 2 deletions(-)
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/avc.c linux-2.6.22/security/selinux/avc.c
--- linux-2.6.22.orig/security/selinux/avc.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/avc.c	2007-09-06 14:33:35.000000000 +0900
@@ -123,6 +123,7 @@ DEFINE_PER_CPU(struct avc_cache_stats, a
 #endif
 
 static struct avc_cache avc_cache;
+u32 policy_seqno = 0;
 static struct avc_callback_node *avc_callbacks;
 static struct kmem_cache *avc_node_cachep;
 
@@ -431,8 +432,10 @@ static int avc_latest_notif_update(int s
 			ret = -EAGAIN;
 		}
 	} else {
-		if (seqno > avc_cache.latest_notif)
+		if (seqno > avc_cache.latest_notif) {
 			avc_cache.latest_notif = seqno;
+			policy_seqno = seqno;
+		}
 	}
 	spin_unlock_irqrestore(&notif_lock, flag);
 
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/hooks.c linux-2.6.22/security/selinux/hooks.c
--- linux-2.6.22.orig/security/selinux/hooks.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/hooks.c	2007-09-06 16:08:36.000000000 +0900
@@ -84,6 +84,7 @@
 extern unsigned int policydb_loaded_version;
 extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
 extern int selinux_compat_net;
+extern u32 policy_seqno;
 
 #ifdef CONFIG_SECURITY_SELINUX_DEVELOP
 int selinux_enforcing = 0;
@@ -220,6 +221,8 @@ static int file_alloc_security(struct fi
 
 	fsec->file = file;
 	fsec->sid = tsec->sid;
+	fsec->tsid = tsec->sid;
+	fsec->pseqno = policy_seqno;
 	fsec->fown_sid = tsec->sid;
 	file->f_security = fsec;
 
@@ -2458,7 +2461,7 @@ static int selinux_inode_listsecurity(st
 
 /* file security operations */
 
-static int selinux_file_permission(struct file *file, int mask)
+static int do_selinux_file_permission(struct file *file, int mask)
 {
 	int rc;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -2480,6 +2483,43 @@ static int selinux_file_permission(struc
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
+	if (tsec->sid != fsec->tsid) {
+		if (tsec->sid != fsec->sid) {
+			struct vfsmount *mnt = file->f_path.mnt;
+			struct dentry *dentry = file->f_path.dentry;
+			struct avc_audit_data ad;
+			int rc;
+			AVC_AUDIT_DATA_INIT(&ad, FS);
+			ad.u.fs.mnt = mnt;
+			ad.u.fs.dentry = dentry;
+			rc = avc_has_perm(tsec->sid, fsec->sid,
+					  SECCLASS_FD,
+					  FD__USE,
+					  &ad);
+			if (rc)
+				return rc;
+		}
+		return do_selinux_file_permission(file, mask);
+	}
+
+	if (fsec->isid == isec->sid && fsec->pseqno == policy_seqno)
+		return selinux_netlbl_inode_permission(inode, mask);
+
+	return do_selinux_file_permission(file, mask);
+}
+
 static int selinux_file_alloc_security(struct file *file)
 {
 	return file_alloc_security(file);
@@ -2715,6 +2755,16 @@ static int selinux_file_receive(struct f
 	return file_has_perm(current, file, file_to_av(file));
 }
 
+static int selinux_dentry_open(struct file *file, int flags)
+{
+	struct file_security_struct *fsec;
+	struct inode_security_struct *isec;
+	fsec = file->f_security;
+	isec = file->f_path.dentry->d_inode->i_security;
+	fsec->isid = isec->sid;
+	return 0;
+}
+
 /* task security operations */
 
 static int selinux_task_create(unsigned long clone_flags)
@@ -4780,6 +4830,8 @@ static struct security_operations selinu
 	.file_send_sigiotask =		selinux_file_send_sigiotask,
 	.file_receive =			selinux_file_receive,
 
+	.dentry_open =                  selinux_dentry_open,
+
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/objsec.h linux-2.6.22/security/selinux/include/objsec.h
--- linux-2.6.22.orig/security/selinux/include/objsec.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/include/objsec.h	2007-09-06 14:58:11.000000000 +0900
@@ -53,6 +53,9 @@ struct file_security_struct {
 	struct file *file;              /* back pointer to file object */
 	u32 sid;              /* SID of open file description */
 	u32 fown_sid;         /* SID of file owner (for SIGIO) */
+	u32 tsid;             /* SID of task at the time of file open*/
+	u32 isid;             /* SID of inode at the time of file open */
+	u32 pseqno;           /* Policy seqno at the time of file open */
 };
 
 struct superblock_security_struct {
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/fs/open.c linux-2.6.22/fs/open.c
--- linux-2.6.22.orig/fs/open.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/fs/open.c	2007-09-06 15:12:29.000000000 +0900
@@ -698,6 +698,11 @@ static struct file *__dentry_open(struct
 
 	if (!open && f->f_op)
 		open = f->f_op->open;
+
+	error = security_dentry_open(f, flags);
+	if (error)
+		goto cleanup_all;
+
 	if (open) {
 		error = open(inode, f);
 		if (error)
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/include/linux/security.h linux-2.6.22/include/linux/security.h
--- linux-2.6.22.orig/include/linux/security.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/include/linux/security.h	2007-09-06 15:22:39.000000000 +0900
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
+	int (*dentry_open)  (struct file *file, int flags);
 
 	int (*task_create) (unsigned long clone_flags);
 	int (*task_alloc_security) (struct task_struct * p);
@@ -1854,6 +1860,11 @@ static inline int security_file_receive 
 	return security_ops->file_receive (file);
 }
 
+static inline int security_dentry_open (struct file *file, int flags)
+{
+	return security_ops->dentry_open (file, flags);
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return security_ops->task_create (clone_flags);

Regards,
-- 
Yuichi Nakamura
Hitachi Software Engineering Co., Ltd.
Japan SELinux Users Group(JSELUG): http://www.selinux.gr.jp/
SELinux Policy Editor: http://seedit.sourceforge.net/

