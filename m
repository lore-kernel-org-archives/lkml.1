Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbXIJBb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbXIJBb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 21:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXIJBbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 21:31:49 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:52229 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbXIJBbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 21:31:47 -0400
Date: Mon, 10 Sep 2007 10:31:26 +0900
From: Yuichi Nakamura <ynakam@hitachisoft.jp>
To: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC]selinux: Improving SELinux read/write performance
Cc: ynakam@hitachisoft.jp, selinux@tycho.nsa.gov, busybox@kaigai.gr.jp,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       kaigai@ak.jp.nec.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1189086435.3617.121.camel@moss-spartans.epoch.ncsc.mil>
References: <20070906161242.6767.YNAKAM@hitachisoft.jp> <1189086435.3617.121.camel@moss-spartans.epoch.ncsc.mil>
Message-Id: <20070910102250.FF41.YNAKAM@hitachisoft.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.31 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 09:47:15 -0400
Stephen Smalley  wrote:
<snip>
> >  
> > @@ -431,8 +432,10 @@ static int avc_latest_notif_update(int s
> >  			ret = -EAGAIN;
> >  		}
> >  	} else {
> > -		if (seqno > avc_cache.latest_notif)
> > +		if (seqno > avc_cache.latest_notif) {
> >  			avc_cache.latest_notif = seqno;
> > +			policy_seqno = seqno;
> > +		}
> 
> I would have just provided an avc interface for obtaining the seqno,
> e.g.
> u32 avc_policy_seqno(void)
> {
> 	return avc_cache.latest_notif;
> }
Fixed.


> 
> >  	}
> >  	spin_unlock_irqrestore(&notif_lock, flag);
> >  
> > diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/hooks.c linux-2.6.22/security/selinux/hooks.c
> > --- linux-2.6.22.orig/security/selinux/hooks.c	2007-07-09 08:32:17.000000000 +0900
> > +++ linux-2.6.22/security/selinux/hooks.c	2007-09-06 16:08:36.000000000 +0900
> > @@ -84,6 +84,7 @@
> >  extern unsigned int policydb_loaded_version;
> >  extern int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm);
> >  extern int selinux_compat_net;
> > +extern u32 policy_seqno;
> 
> I think that they frown upon extern declarations in .c files (versus
> in .h files), so we don't want to add more - we ultimately should clean
> up what we presently have.
Removed policy_seqno.

> 
> >  
> >  #ifdef CONFIG_SECURITY_SELINUX_DEVELOP
> >  int selinux_enforcing = 0;
> > @@ -220,6 +221,8 @@ static int file_alloc_security(struct fi
> >  
> >  	fsec->file = file;
> >  	fsec->sid = tsec->sid;
> > +	fsec->tsid = tsec->sid;
> 
> I'm not sure why we need the separate field here, as fsec->sid already
> holds the allocating task SID and doesn't change.
I see.
removed fsec->tsid.

> > +	fsec->pseqno = policy_seqno;
> 
> Not sure that you want to set the seqno here versus from your new hook,
> as it could conceivably change in between.
Fixed, pseqno is set in selinux_dentry_open.


> >  	fsec->fown_sid = tsec->sid;
> >  	file->f_security = fsec;
> >  
> > @@ -2458,7 +2461,7 @@ static int selinux_inode_listsecurity(st
> >  
> >  /* file security operations */
> >  
> > -static int selinux_file_permission(struct file *file, int mask)
> > +static int do_selinux_file_permission(struct file *file, int mask)
> 
> Might want to rename for clarity, e.g. 
> selinux_revalidate_file_permission or
> selinux_file_permission_slow (slow path) or
> something similar.
Renamed to selinux_revalidate_file_permission.


> 
> >  {
> >  	int rc;
> >  	struct inode *inode = file->f_path.dentry->d_inode;
> > @@ -2480,6 +2483,43 @@ static int selinux_file_permission(struc
> >  	return selinux_netlbl_inode_permission(inode, mask);
> >  }
> >  
> > +static int selinux_file_permission(struct file *file, int mask)
> > +{
> > +	struct inode *inode = file->f_path.dentry->d_inode;
> > +	struct task_security_struct *tsec = current->security;
> > +	struct file_security_struct *fsec = file->f_security;
> > +	struct inode_security_struct *isec = inode->i_security;
> > +
> > +	if (!mask) {
> > +		/* No permission to check.  Existence test. */
> > +		return 0;
> > +	}
> > +
> > +	if (tsec->sid != fsec->tsid) {
> > +		if (tsec->sid != fsec->sid) {
> > +			struct vfsmount *mnt = file->f_path.mnt;
> > +			struct dentry *dentry = file->f_path.dentry;
> > +			struct avc_audit_data ad;
> > +			int rc;
> > +			AVC_AUDIT_DATA_INIT(&ad, FS);
> > +			ad.u.fs.mnt = mnt;
> > +			ad.u.fs.dentry = dentry;
> > +			rc = avc_has_perm(tsec->sid, fsec->sid,
> > +					  SECCLASS_FD,
> > +					  FD__USE,
> > +					  &ad);
> > +			if (rc)
> > +				return rc;
> > +		}
> 
> Why inline the FD_USE check here given that you are falling back to the
> full function call anyway?  I also don't see why you separate this from
> the rest of the comparison - I'd just make it something like:
> 	if (tsec->sid == fsec->sid && isec->sid == fsec->isid &&
> 	    avc_seqno() == fsec->seqno)
> 		return selinux_netlbl_inode_permission(inode, mask);
> 	return selinux_revalidate_file_permission(file, mask);
Thanks, I missed that.
FD_USE check is called in file_permission..
Fixed like you pointed out.


> >  static int selinux_file_alloc_security(struct file *file)
> >  {
> >  	return file_alloc_security(file);
> > @@ -2715,6 +2755,16 @@ static int selinux_file_receive(struct f
> >  	return file_has_perm(current, file, file_to_av(file));
> >  }
> >  
> > +static int selinux_dentry_open(struct file *file, int flags)
> > +{
> > +	struct file_security_struct *fsec;
> > +	struct inode_security_struct *isec;
> > +	fsec = file->f_security;
> > +	isec = file->f_path.dentry->d_inode->i_security;
> > +	fsec->isid = isec->sid;
> 
> Set the seqno here too.  Ideally, it would come straight from the AVC
> entry that was used for the open-time check, but that is a bit more
> invasive and there will always be a small window there.
Fixed, setting pseqno now.


> > diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/objsec.h linux-2.6.22/security/selinux/include/objsec.h
> > --- linux-2.6.22.orig/security/selinux/include/objsec.h	2007-07-09 08:32:17.000000000 +0900
> > +++ linux-2.6.22/security/selinux/include/objsec.h	2007-09-06 14:58:11.000000000 +0900
> > @@ -53,6 +53,9 @@ struct file_security_struct {
> >  	struct file *file;              /* back pointer to file object */
> >  	u32 sid;              /* SID of open file description */
> >  	u32 fown_sid;         /* SID of file owner (for SIGIO) */
> > +	u32 tsid;             /* SID of task at the time of file open*/
> > +	u32 isid;             /* SID of inode at the time of file open */
> > +	u32 pseqno;           /* Policy seqno at the time of file open */
> 
> No need for tsid above I think.
Removed tsid.


> > diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/include/linux/security.h linux-2.6.22/include/linux/security.h
> > --- linux-2.6.22.orig/include/linux/security.h	2007-07-09 08:32:17.000000000 +0900
> > +++ linux-2.6.22/include/linux/security.h	2007-09-06 15:22:39.000000000 +0900
> > @@ -503,6 +503,11 @@ struct request_sock;
> >   *	@file contains the file structure being received.
> >   *	Return 0 if permission is granted.
> >   *
> > + * Security hook for dentry
> > + *
> > + * @dentry_open
> > + *   Check permission or get additional information before opening dentry.
> > + *
> >   * Security hooks for task operations.
> >   *
> >   * @task_create:
> > @@ -1253,6 +1258,7 @@ struct security_operations {
> >  	int (*file_send_sigiotask) (struct task_struct * tsk,
> >  				    struct fown_struct * fown, int sig);
> >  	int (*file_receive) (struct file * file);
> > +	int (*dentry_open)  (struct file *file, int flags);
> >  
> >  	int (*task_create) (unsigned long clone_flags);
> >  	int (*task_alloc_security) (struct task_struct * p);
> > @@ -1854,6 +1860,11 @@ static inline int security_file_receive 
> >  	return security_ops->file_receive (file);
> >  }
> >  
> > +static inline int security_dentry_open (struct file *file, int flags)
> > +{
> > +	return security_ops->dentry_open (file, flags);
> > +}
> > +
> >  static inline int security_task_create (unsigned long clone_flags)
> >  {
> >  	return security_ops->task_create (clone_flags);
> 
> Need to also provide the stub definition in the #else case (SECURITY=n)
> and a stub function for the dummy security module.
Fixed.


> 
> Thanks.
> 
> -- 
> Stephen Smalley
> National Security Agency

Next is updated patch.

Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
---
 fs/open.c                         |    5 +++++
 include/linux/security.h          |   16 ++++++++++++++++
 security/selinux/avc.c            |    5 +++++
 security/selinux/hooks.c          |   36 +++++++++++++++++++++++++++++++++++-
 security/selinux/include/avc.h    |    2 ++
 security/selinux/include/objsec.h |    2 ++
 6 files changed, 65 insertions(+), 1 deletion(-)
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/avc.c linux-2.6.22/security/selinux/avc.c
--- linux-2.6.22.orig/security/selinux/avc.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/avc.c	2007-09-10 09:56:22.000000000 +0900
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
+++ linux-2.6.22/security/selinux/hooks.c	2007-09-10 10:11:13.000000000 +0900
@@ -14,6 +14,8 @@
  *                          <dgoeddel@trustedcs.com>
  *  Copyright (C) 2006 Hewlett-Packard Development Company, L.P.
  *                     Paul Moore, <paul.moore@hp.com>
+ *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
+ *                     Yuichi Nakamura <ynakam@hitachisoft.jp>
  *
  *	This program is free software; you can redistribute it and/or modify
  *	it under the terms of the GNU General Public License version 2,
@@ -2458,7 +2460,7 @@ static int selinux_inode_listsecurity(st
 
 /* file security operations */
 
-static int selinux_file_permission(struct file *file, int mask)
+static int selinux_revalidate_file_permission(struct file *file, int mask)
 {
 	int rc;
 	struct inode *inode = file->f_path.dentry->d_inode;
@@ -2480,6 +2482,25 @@ static int selinux_file_permission(struc
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
@@ -2715,6 +2736,17 @@ static int selinux_file_receive(struct f
 	return file_has_perm(current, file, file_to_av(file));
 }
 
+static int selinux_dentry_open(struct file *file, int flags)
+{
+	struct file_security_struct *fsec;
+	struct inode_security_struct *isec;
+	fsec = file->f_security;
+	isec = file->f_path.dentry->d_inode->i_security;
+	fsec->isid = isec->sid;
+	fsec->pseqno = avc_policy_seqno();
+	return 0;
+}
+
 /* task security operations */
 
 static int selinux_task_create(unsigned long clone_flags)
@@ -4780,6 +4812,8 @@ static struct security_operations selinu
 	.file_send_sigiotask =		selinux_file_send_sigiotask,
 	.file_receive =			selinux_file_receive,
 
+	.dentry_open =                  selinux_dentry_open,
+
 	.task_create =			selinux_task_create,
 	.task_alloc_security =		selinux_task_alloc_security,
 	.task_free_security =		selinux_task_free_security,
diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/avc.h linux-2.6.22/security/selinux/include/avc.h
--- linux-2.6.22.orig/security/selinux/include/avc.h	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22/security/selinux/include/avc.h	2007-09-10 09:56:22.000000000 +0900
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
+++ linux-2.6.22/security/selinux/include/objsec.h	2007-09-10 09:56:22.000000000 +0900
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
+++ linux-2.6.22/fs/open.c	2007-09-10 09:56:22.000000000 +0900
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
+++ linux-2.6.22/include/linux/security.h	2007-09-10 09:56:22.000000000 +0900
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
@@ -2529,6 +2540,11 @@ static inline int security_file_receive 
 	return 0;
 }
 
+static inline int security_dentry_open (struct file *file, int flags)
+{
+	return 0;
+}
+
 static inline int security_task_create (unsigned long clone_flags)
 {
 	return 0;

Regards,
-- 
Yuichi Nakamura
Hitachi Software Engineering Co., Ltd.
Japan SELinux Users Group(JSELUG): http://www.selinux.gr.jp/
SELinux Policy Editor: http://seedit.sourceforge.net/

