Return-Path: <linux-kernel-owner+w=401wt.eu-S1759793AbXIQUwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759793AbXIQUwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbXIQUvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:51:55 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:41247 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751409AbXIQUvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:51:54 -0400
Subject: Re: [PATCH] selinux: Improving SELinux read/write performance
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Yuichi Nakamura <ynakam@hitachisoft.jp>
Cc: selinux@tycho.nsa.gov, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, kaigai@ak.jp.nec.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070914092048.C8F1.YNAKAM@hitachisoft.jp>
References: <20070914092048.C8F1.YNAKAM@hitachisoft.jp>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 17 Sep 2007 16:45:15 -0400
Message-Id: <1190061915.4034.78.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 09:27 +0900, Yuichi Nakamura wrote:
> Hello.
> 
> I would like to propose patch that reduces overhead in read/write by SELinux.
> I sent RFC in previous thread.
> http://lkml.org/lkml/2007/9/6/14
> As a result of discussion in previous thread, 
> quality of code has improved, so I would like to submit patch here.
> 
> 1. Background
> Look at benchmark result below.
> lmbench simple read/write(average of 5 run).
> Big overhead exists especially on SH(SuperH) arch.
> 
> 1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
>                 Base  SELinux  Overhead(%)
> Simple read     1.10  1.24     12.3
> Simple write    1.02  1.14     14.0
> * Base: kernel compiled without SELinux support
> 
> 2) Result for SH(SH4, SH7751R), kernel 2.6.22
>                 Base    SELinux   Overhead(%)
> Simple read     2.39    5.49      130.5
> Simple write    2.07    5.10      146.6
> 
> 2. About patch
> It reduces the selinux overhead on read/write by only revalidating
> permissions in selinux_file_permission if the task or inode labels have
> changed or the policy has changed since the open-time check.  
> A new LSM hook, security_dentry_open,  is added to capture 
> the necessary state at open time to allow this optimization.
> 
> 3. Result of benchmark after applying patch
> 1) Result for x86(Pentium 4 2.6Ghz), kernel 2.6.22
>                 Base  SELinux  Overhead(%)
> Simple read     1.10  1.13     2.3(Before 12.3)
> Simple write    1.02  1.024    0.6(Before 14.0)
> * Base: kernel compiled without SELinux support
> 
> 2) Result for SH(SH4, SH7751R), kernel 2.6.22
>                 Base    SELinux   Overhead(%)
> Simple read     2.39    2.63      10.4(Before 130.5)
> Simple write    2.07    2.34      13.1(Before 146.6)
> 
> Overhead in read/write is reduced a lot.
> This patch adds permission check at open time(in __dentry_open), 
> but open/close performance does not get worse as shown below.
> 
> * Lmbench simple open/close
> Pentium 4(before patch):
>                 Base  SELinux  Overhead(%)
> open/close      5.97  7.45     24.9
> after patch:
> open/close      5.97  7.48     25.3
> 
> SH(before patch):
>                 Base  SELinux  Overhead(%)
> open/close      32.6  62.8   93.0
> after patch:
> open/close      32.6    58.7    80.2
> 
> Next is a patch for 2.6.22.
> 
> It reduces the selinux overhead on read/write by only revalidating
> permissions in selinux_file_permission if the task or inode labels have
> changed or the policy has changed since the open-time check.  A new LSM
> hook, security_dentry_open, is added to capture the necessary state at
> open time to allow this optimization.
> 
> Signed-off-by: Yuichi Nakamura<ynakam@hitachisoft.jp>

Thanks, looks good.

Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  fs/open.c                         |    4 ++
>  include/linux/security.h          |   18 ++++++++++++
>  security/dummy.c                  |    6 ++++
>  security/selinux/avc.c            |    5 +++
>  security/selinux/hooks.c          |   53 +++++++++++++++++++++++++++++++++++++-
>  security/selinux/include/avc.h    |    2 +
>  security/selinux/include/objsec.h |    2 +
>  7 files changed, 89 insertions(+), 1 deletion(-)
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/security/selinux/avc.c linux-2.6.22/security/selinux/avc.c
> --- linux-2.6.22.orig/security/selinux/avc.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/selinux/avc.c	2007-09-14 08:35:04.000000000 +0900
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
> +++ linux-2.6.22/security/selinux/hooks.c	2007-09-14 08:43:51.000000000 +0900
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
> @@ -2715,6 +2736,34 @@ static int selinux_file_receive(struct f
>  	return file_has_perm(current, file, file_to_av(file));
>  }
>  
> +static int selinux_dentry_open(struct file *file)
> +{
> +	struct file_security_struct *fsec;
> +	struct inode *inode;
> +	struct inode_security_struct *isec;
> +	inode = file->f_path.dentry->d_inode;
> +	fsec = file->f_security;
> +	isec = inode->i_security;
> +	/*
> +	 * Save inode label and policy sequence number
> +	 * at open-time so that selinux_file_permission
> +	 * can determine whether revalidation is necessary.
> +	 * Task label is already saved in the file security
> +	 * struct as its SID.
> +	 */
> +	fsec->isid = isec->sid;
> +	fsec->pseqno = avc_policy_seqno();
> +	/*
> +	 * Since the inode label or policy seqno may have changed
> +	 * between the selinux_inode_permission check and the saving
> +	 * of state above, recheck that access is still permitted.
> +	 * Otherwise, access might never be revalidated against the
> +	 * new inode label or new policy.
> +	 * This check is not redundant - do not remove.
> +	 */
> +	return inode_has_perm(current, inode, file_to_av(file), NULL);
> +}
> +
>  /* task security operations */
>  
>  static int selinux_task_create(unsigned long clone_flags)
> @@ -4780,6 +4829,8 @@ static struct security_operations selinu
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
> +++ linux-2.6.22/security/selinux/include/avc.h	2007-09-14 08:35:04.000000000 +0900
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
> +++ linux-2.6.22/security/selinux/include/objsec.h	2007-09-14 08:35:04.000000000 +0900
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
> +++ linux-2.6.22/fs/open.c	2007-09-14 08:40:46.000000000 +0900
> @@ -696,6 +696,10 @@ static struct file *__dentry_open(struct
>  	f->f_op = fops_get(inode->i_fop);
>  	file_move(f, &inode->i_sb->s_files);
>  
> +	error = security_dentry_open(f);
> +	if (error)
> +		goto cleanup_all;
> +
>  	if (!open && f->f_op)
>  		open = f->f_op->open;
>  	if (open) {
> diff -purN -X linux-2.6.22/Documentation/dontdiff linux-2.6.22.orig/include/linux/security.h linux-2.6.22/include/linux/security.h
> --- linux-2.6.22.orig/include/linux/security.h	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/include/linux/security.h	2007-09-14 08:44:13.000000000 +0900
> @@ -503,6 +503,13 @@ struct request_sock;
>   *	@file contains the file structure being received.
>   *	Return 0 if permission is granted.
>   *
> + * Security hook for dentry
> + *
> + * @dentry_open
> + *	Save open-time permission checking state for later use upon
> + *	file_permission, and recheck access if anything has changed
> + *	since inode_permission.
> + *
>   * Security hooks for task operations.
>   *
>   * @task_create:
> @@ -1253,6 +1260,7 @@ struct security_operations {
>  	int (*file_send_sigiotask) (struct task_struct * tsk,
>  				    struct fown_struct * fown, int sig);
>  	int (*file_receive) (struct file * file);
> +	int (*dentry_open)  (struct file *file);
>  
>  	int (*task_create) (unsigned long clone_flags);
>  	int (*task_alloc_security) (struct task_struct * p);
> @@ -1854,6 +1862,11 @@ static inline int security_file_receive 
>  	return security_ops->file_receive (file);
>  }
>  
> +static inline int security_dentry_open (struct file *file)
> +{
> +	return security_ops->dentry_open (file);
> +}
> +
>  static inline int security_task_create (unsigned long clone_flags)
>  {
>  	return security_ops->task_create (clone_flags);
> @@ -2529,6 +2542,11 @@ static inline int security_file_receive 
>  	return 0;
>  }
>  
> +static inline int security_dentry_open (struct file *file)
> +{
> +	return 0;
> +}
> +
>  static inline int security_task_create (unsigned long clone_flags)
>  {
>  	return 0;
> --- linux-2.6.22.orig/security/dummy.c	2007-07-09 08:32:17.000000000 +0900
> +++ linux-2.6.22/security/dummy.c	2007-09-14 08:35:04.000000000 +0900
> @@ -459,6 +459,11 @@ static int dummy_file_receive (struct fi
>  	return 0;
>  }
>  
> +static int dummy_dentry_open (struct file *file)
> +{
> +	return 0;
> +}
> +
>  static int dummy_task_create (unsigned long clone_flags)
>  {
>  	return 0;
> @@ -1029,6 +1034,7 @@ void security_fixup_ops (struct security
>  	set_to_dummy_if_null(ops, file_set_fowner);
>  	set_to_dummy_if_null(ops, file_send_sigiotask);
>  	set_to_dummy_if_null(ops, file_receive);
> +	set_to_dummy_if_null(ops, dentry_open);
>  	set_to_dummy_if_null(ops, task_create);
>  	set_to_dummy_if_null(ops, task_alloc_security);
>  	set_to_dummy_if_null(ops, task_free_security);
> 
> Regards,
-- 
Stephen Smalley
National Security Agency

