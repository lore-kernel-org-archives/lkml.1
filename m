Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXIJNGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXIJNGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbXIJNFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:05:50 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:38350 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755986AbXIJNFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:05:48 -0400
Subject: Re: [RFC]selinux: Improving SELinux read/write performance
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Yuichi Nakamura <ynakam@hitachisoft.jp>
Cc: selinux@tycho.nsa.gov, busybox@kaigai.gr.jp,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       kaigai@ak.jp.nec.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070910102250.FF41.YNAKAM@hitachisoft.jp>
References: <20070906161242.6767.YNAKAM@hitachisoft.jp>
	 <1189086435.3617.121.camel@moss-spartans.epoch.ncsc.mil>
	 <20070910102250.FF41.YNAKAM@hitachisoft.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 10 Sep 2007 09:02:34 -0400
Message-Id: <1189429354.11972.8.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 10:31 +0900, Yuichi Nakamura wrote:
> Next is updated patch.

Thanks.
Please include the short description of the patch though when
re-submitting.

> Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>
> ---
>  fs/open.c                         |    5 +++++
>  include/linux/security.h          |   16 ++++++++++++++++
>  security/selinux/avc.c            |    5 +++++
>  security/selinux/hooks.c          |   36 +++++++++++++++++++++++++++++++++++-
>  security/selinux/include/avc.h    |    2 ++
>  security/selinux/include/objsec.h |    2 ++
>  6 files changed, 65 insertions(+), 1 deletion(-)

Still missing the necessary changes to security/dummy.c (add
dummy_dentry_open() and update security_fixup_ops()).  For
CONFIG_SECURITY=y but SELinux disabled.

Also, have you re-run your benchmarks with this version of the patch?
   
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/avc.c linux-2.6.22/security/selinux/avc.c
> --- linux-2.6.22.orig/security/selinux/avc.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/selinux/avc.c	2007-09-10 09:56:22.000000000 +0900
> @@ -913,3 +913,8 @@ int avc_has_perm(u32 ssid, u32 tsid, u16
>  	avc_audit(ssid, tsid, tclass, requested, &avd, rc, auditdata);
>  	return rc;
>  }
> +
> +u32 avc_policy_seqno(void)
> +{
> +	return avc_cache.latest_notif;
> +}
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/hooks.c linux-2.6.22/security/selinux/hooks.c
> --- linux-2.6.22.orig/security/selinux/hooks.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/selinux/hooks.c	2007-09-10 10:11:13.000000000 +0900
> @@ -14,6 +14,8 @@
>   *                          <dgoeddel@trustedcs.com>
>   *  Copyright (C) 2006 Hewlett-Packard Development Company, L.P.
>   *                     Paul Moore, <paul.moore@hp.com>
> + *  Copyright (C) 2007 Hitachi Software Engineering Co., Ltd.
> + *                     Yuichi Nakamura <ynakam@hitachisoft.jp>
>   *
>   *	This program is free software; you can redistribute it and/or modify
>   *	it under the terms of the GNU General Public License version 2,
> @@ -2458,7 +2460,7 @@ static int selinux_inode_listsecurity(st
>  
>  /* file security operations */
>  
> -static int selinux_file_permission(struct file *file, int mask)
> +static int selinux_revalidate_file_permission(struct file *file, int mask)
>  {
>  	int rc;
>  	struct inode *inode = file->f_path.dentry->d_inode;
> @@ -2480,6 +2482,25 @@ static int selinux_file_permission(struc
>  	return selinux_netlbl_inode_permission(inode, mask);
>  }
>  
> +static int selinux_file_permission(struct file *file, int mask)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct task_security_struct *tsec = current->security;
> +	struct file_security_struct *fsec = file->f_security;
> +	struct inode_security_struct *isec = inode->i_security;
> +
> +	if (!mask) {
> +		/* No permission to check.  Existence test. */
> +		return 0;
> +	}
> +
> +	if (tsec->sid == fsec->sid && fsec->isid == isec->sid
> +	    && fsec->pseqno == avc_policy_seqno())
> +		return selinux_netlbl_inode_permission(inode, mask);
> +
> +	return selinux_revalidate_file_permission(file, mask);
> +}
> +
>  static int selinux_file_alloc_security(struct file *file)
>  {
>  	return file_alloc_security(file);
> @@ -2715,6 +2736,17 @@ static int selinux_file_receive(struct f
>  	return file_has_perm(current, file, file_to_av(file));
>  }
>  
> +static int selinux_dentry_open(struct file *file, int flags)
> +{
> +	struct file_security_struct *fsec;
> +	struct inode_security_struct *isec;
> +	fsec = file->f_security;
> +	isec = file->f_path.dentry->d_inode->i_security;
> +	fsec->isid = isec->sid;
> +	fsec->pseqno = avc_policy_seqno();
> +	return 0;
> +}
> +
>  /* task security operations */
>  
>  static int selinux_task_create(unsigned long clone_flags)
> @@ -4780,6 +4812,8 @@ static struct security_operations selinu
>  	.file_send_sigiotask =		selinux_file_send_sigiotask,
>  	.file_receive =			selinux_file_receive,
>  
> +	.dentry_open =                  selinux_dentry_open,
> +
>  	.task_create =			selinux_task_create,
>  	.task_alloc_security =		selinux_task_alloc_security,
>  	.task_free_security =		selinux_task_free_security,
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/avc.h linux-2.6.22/security/selinux/include/avc.h
> --- linux-2.6.22.orig/security/selinux/include/avc.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/selinux/include/avc.h	2007-09-10 09:56:22.000000000 +0900
> @@ -110,6 +110,8 @@ int avc_has_perm(u32 ssid, u32 tsid,
>                   u16 tclass, u32 requested,
>                   struct avc_audit_data *auditdata);
>  
> +u32 avc_policy_seqno(void);
> +
>  #define AVC_CALLBACK_GRANT		1
>  #define AVC_CALLBACK_TRY_REVOKE		2
>  #define AVC_CALLBACK_REVOKE		4
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/include/objsec.h linux-2.6.22/security/selinux/include/objsec.h
> --- linux-2.6.22.orig/security/selinux/include/objsec.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/selinux/include/objsec.h	2007-09-10 09:56:22.000000000 +0900
> @@ -53,6 +53,8 @@ struct file_security_struct {
>  	struct file *file;              /* back pointer to file object */
>  	u32 sid;              /* SID of open file description */
>  	u32 fown_sid;         /* SID of file owner (for SIGIO) */
> +	u32 isid;             /* SID of inode at the time of file open */
> +	u32 pseqno;           /* Policy seqno at the time of file open */
>  };
>  
>  struct superblock_security_struct {
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/fs/open.c linux-2.6.22/fs/open.c
> --- linux-2.6.22.orig/fs/open.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/fs/open.c	2007-09-10 09:56:22.000000000 +0900
> @@ -698,6 +698,11 @@ static struct file *__dentry_open(struct
>  
>  	if (!open && f->f_op)
>  		open = f->f_op->open;
> +
> +	error = security_dentry_open(f, flags);
> +	if (error)
> +		goto cleanup_all;
> +
>  	if (open) {
>  		error = open(inode, f);
>  		if (error)
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/include/linux/security.h linux-2.6.22/include/linux/security.h
> --- linux-2.6.22.orig/include/linux/security.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/include/linux/security.h	2007-09-10 09:56:22.000000000 +0900
> @@ -503,6 +503,11 @@ struct request_sock;
>   *	@file contains the file structure being received.
>   *	Return 0 if permission is granted.
>   *
> + * Security hook for dentry
> + *
> + * @dentry_open
> + *   Check permission or get additional information before opening dentry.
> + *
>   * Security hooks for task operations.
>   *
>   * @task_create:
> @@ -1253,6 +1258,7 @@ struct security_operations {
>  	int (*file_send_sigiotask) (struct task_struct * tsk,
>  				    struct fown_struct * fown, int sig);
>  	int (*file_receive) (struct file * file);
> +	int (*dentry_open)  (struct file *file, int flags);
>  
>  	int (*task_create) (unsigned long clone_flags);
>  	int (*task_alloc_security) (struct task_struct * p);
> @@ -1854,6 +1860,11 @@ static inline int security_file_receive 
>  	return security_ops->file_receive (file);
>  }
>  
> +static inline int security_dentry_open (struct file *file, int flags)
> +{
> +	return security_ops->dentry_open (file, flags);
> +}
> +
>  static inline int security_task_create (unsigned long clone_flags)
>  {
>  	return security_ops->task_create (clone_flags);
> @@ -2529,6 +2540,11 @@ static inline int security_file_receive 
>  	return 0;
>  }
>  
> +static inline int security_dentry_open (struct file *file, int flags)
> +{
> +	return 0;
> +}
> +
>  static inline int security_task_create (unsigned long clone_flags)
>  {
>  	return 0;
> 
> Regards,
-- 
Stephen Smalley
National Security Agency

