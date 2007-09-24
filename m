Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbXIXOdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbXIXOdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 10:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXIXOdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 10:33:01 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:51067 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753089AbXIXOc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 10:32:58 -0400
Subject: Re: [PATCH 2/3] CRED: Split the task security data and move part
	of it into struct cred
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: David Howells <dhowells@redhat.com>, viro@ftp.linux.org.uk,
       hch@infradead.org, Trond.Myklebust@netapp.com, casey@schaufler-ca.com,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
In-Reply-To: <20070924140003.GA25689@vino.hallyn.com>
References: <20070919161749.8334.26064.stgit@warthog.procyon.org.uk>
	 <20070919161759.8334.11581.stgit@warthog.procyon.org.uk>
	 <20070924140003.GA25689@vino.hallyn.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 24 Sep 2007 10:21:59 -0400
Message-Id: <1190643719.487.41.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 09:00 -0500, Serge E. Hallyn wrote:
> Quoting David Howells (dhowells@redhat.com):
> > Move into the cred struct the part of the task security data that defines how a
> > task acts upon an object.  The part that defines how something acts upon a task
> > remains attached to the task.
> > 
> > For SELinux this requires some of task_security_struct to be split off into
> > cred_security_struct which is then attached to struct cred.  Note that the
> > contents of cred_security_struct may not be changed without the generation of a
> > new struct cred.
> > 
> > The split is as follows:
> > 
> >  (*) create_sid, keycreate_sid and sockcreate_sid just move across.
> > 
> >  (*) sid is split into victim_sid - which remains - and action_sid - which
> >      migrates.
> 
> My concern is with this victim_sid.  Whether the concern is valid
> depends on exactly how the other credentials can be used, which isn't
> yet entirely clear to me.
> 
> So my concern is that while a task is acting with alternate creds,
> another task can act upon it based upon victim_sid.  So does this
> open up the possibility for an unprivileged task to ptrace or kill
> a task in the middle of a privileged operation?  Is that somehow
> safe in the way this is used here?

I think that's why they want it - so that things like nfsd and
cachefiles can switch the credentials used for permission checking and
object labeling (actor_sid, fscreate_sid) without exposing them to
access by other tasks via signals, ptrace, etc (victim_sid).  Similar to
fsuid vs. uid.  And then the separate issue of migrating the permission
checking and object labeling state into a separate credential structure
that can have a separate lifecycle from the task.

Precisely when to use one identity vs. the other though isn't always
clear, and the potential for accidental divergence is also a concern.

I think it is a mistake to have selinux_get_task_sid() blindly return
the victim SID btw.  I think you likely need to split that interface and
require the caller to indicate what it wants, so that there is no
accidental misuse of the victim SID where the caller wanted the actor
SID.  Or at least rename that interface to make it clear that it only
returns the victim SID.

> I guess I need to look more at the actual nfs patches etc.
> 
> thanks,
> -serge
> 
> 
> >  (*) osid, exec_sid and ptrace_sid remain.
> > 
> > victim_sid is the SID used to govern actions upon the task.  action_sid is used
> > to govern actions made by the task.
> > 
> > When accessing the cred_security_struct of another process, RCU read procedures
> > must be observed.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> > ---
> > 
> >  include/linux/cred.h              |    1 
> >  include/linux/security.h          |   34 +++
> >  kernel/cred.c                     |    7 +
> >  security/dummy.c                  |   11 +
> >  security/selinux/exports.c        |    6 
> >  security/selinux/hooks.c          |  497 +++++++++++++++++++++++--------------
> >  security/selinux/include/objsec.h |   16 +
> >  security/selinux/selinuxfs.c      |    8 -
> >  security/selinux/xfrm.c           |    6 
> >  9 files changed, 380 insertions(+), 206 deletions(-)
> > 
> > diff --git a/include/linux/cred.h b/include/linux/cred.h
> > index 22ae610..6c6feec 100644
> > --- a/include/linux/cred.h
> > +++ b/include/linux/cred.h
> > @@ -26,6 +26,7 @@ struct cred {
> >  	gid_t			gid;		/* fsgid as was */
> >  	struct rcu_head		exterminate;	/* cred destroyer */
> >  	struct group_info	*group_info;
> > +	void			*security;
> >  
> >  	/* caches for references to the three task keyrings
> >  	 * - note that key_ref_t isn't typedef'd at this point, hence the odd
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 1a15526..e5ed2ea 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -504,6 +504,18 @@ struct request_sock;
> >   *	@file contains the file structure being received.
> >   *	Return 0 if permission is granted.
> >   *
> > + * Security hooks for credential structure operations.
> > + *
> > + * @cred_dup:
> > + *	Duplicate the credentials onto a duplicated cred structure.
> > + *	@cred points to the credentials structure.  cred->security points to the
> > + *	security struct that was attached to the original cred struct, but it
> > + *	lacks a reference for the duplication if reference counting is needed.
> > + *
> > + * @cred_destroy:
> > + *	Destroy the credentials attached to a cred structure.
> > + *	@cred points to the credentials structure that is to be destroyed.
> > + *
> >   * Security hooks for task operations.
> >   *
> >   * @task_create:
> > @@ -1257,6 +1269,9 @@ struct security_operations {
> >  				    struct fown_struct * fown, int sig);
> >  	int (*file_receive) (struct file * file);
> >  
> > +	int (*cred_dup)(struct cred *cred);
> > +	void (*cred_destroy)(struct cred *cred);
> > +
> >  	int (*task_create) (unsigned long clone_flags);
> >  	int (*task_alloc_security) (struct task_struct * p);
> >  	void (*task_free_security) (struct task_struct * p);
> > @@ -1864,6 +1879,16 @@ static inline int security_file_receive (struct file *file)
> >  	return security_ops->file_receive (file);
> >  }
> >  
> > +static inline int security_cred_dup(struct cred *cred)
> > +{
> > +	return security_ops->cred_dup(cred);
> > +}
> > +
> > +static inline void security_cred_destroy(struct cred *cred)
> > +{
> > +	return security_ops->cred_destroy(cred);
> > +}
> > +
> >  static inline int security_task_create (unsigned long clone_flags)
> >  {
> >  	return security_ops->task_create (clone_flags);
> > @@ -2546,6 +2571,15 @@ static inline int security_file_receive (struct file *file)
> >  	return 0;
> >  }
> >  
> > +static inline int security_cred_dup(struct cred *cred)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline void security_cred_destroy(struct cred *cred)
> > +{
> > +}
> > +
> >  static inline int security_task_create (unsigned long clone_flags)
> >  {
> >  	return 0;
> > diff --git a/kernel/cred.c b/kernel/cred.c
> > index e96dafe..6a9dda2 100644
> > --- a/kernel/cred.c
> > +++ b/kernel/cred.c
> > @@ -92,6 +92,12 @@ struct cred *dup_cred(const struct cred *pcred)
> >  	if (likely(cred)) {
> >  		*cred = *pcred;
> >  		atomic_set(&cred->usage, 1);
> > +
> > +		if (security_cred_dup(cred) < 0) {
> > +			kfree(cred);
> > +			return NULL;
> > +		}
> > +
> >  		get_group_info(cred->group_info);
> >  		key_get(key_ref_to_ptr(cred->session_keyring));
> >  		key_get(key_ref_to_ptr(cred->process_keyring));
> > @@ -109,6 +115,7 @@ static void put_cred_rcu(struct rcu_head *rcu)
> >  {
> >  	struct cred *cred = container_of(rcu, struct cred, exterminate);
> >  
> > +	security_cred_destroy(cred);
> >  	put_group_info(cred->group_info);
> >  	key_ref_put(cred->session_keyring);
> >  	key_ref_put(cred->process_keyring);
> > diff --git a/security/dummy.c b/security/dummy.c
> > index 62de89c..f535cc6 100644
> > --- a/security/dummy.c
> > +++ b/security/dummy.c
> > @@ -468,6 +468,15 @@ static int dummy_file_receive (struct file *file)
> >  	return 0;
> >  }
> >  
> > +static int dummy_cred_dup(struct cred *cred)
> > +{
> > +	return 0;
> > +}
> > +
> > +static void dummy_cred_destroy(struct cred *cred)
> > +{
> > +}
> > +
> >  static int dummy_task_create (unsigned long clone_flags)
> >  {
> >  	return 0;
> > @@ -1038,6 +1047,8 @@ void security_fixup_ops (struct security_operations *ops)
> >  	set_to_dummy_if_null(ops, file_set_fowner);
> >  	set_to_dummy_if_null(ops, file_send_sigiotask);
> >  	set_to_dummy_if_null(ops, file_receive);
> > +	set_to_dummy_if_null(ops, cred_dup);
> > +	set_to_dummy_if_null(ops, cred_destroy);
> >  	set_to_dummy_if_null(ops, task_create);
> >  	set_to_dummy_if_null(ops, task_alloc_security);
> >  	set_to_dummy_if_null(ops, task_free_security);
> > diff --git a/security/selinux/exports.c b/security/selinux/exports.c
> > index b6f9694..29cb87a 100644
> > --- a/security/selinux/exports.c
> > +++ b/security/selinux/exports.c
> > @@ -57,7 +57,7 @@ void selinux_get_task_sid(struct task_struct *tsk, u32 *sid)
> >  {
> >  	if (selinux_enabled) {
> >  		struct task_security_struct *tsec = tsk->security;
> > -		*sid = tsec->sid;
> > +		*sid = tsec->victim_sid;
> >  		return;
> >  	}
> >  	*sid = 0;
> > @@ -77,9 +77,9 @@ EXPORT_SYMBOL_GPL(selinux_string_to_sid);
> >  int selinux_relabel_packet_permission(u32 sid)
> >  {
> >  	if (selinux_enabled) {
> > -		struct task_security_struct *tsec = current->security;
> > +		struct cred_security_struct *csec = current->cred->security;
> >  
> > -		return avc_has_perm(tsec->sid, sid, SECCLASS_PACKET,
> > +		return avc_has_perm(csec->action_sid, sid, SECCLASS_PACKET,
> >  				    PACKET__RELABELTO, NULL);
> >  	}
> >  	return 0;
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 3694662..6fc41da 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -162,7 +162,8 @@ static int task_alloc_security(struct task_struct *task)
> >  		return -ENOMEM;
> >  
> >  	tsec->task = task;
> > -	tsec->osid = tsec->sid = tsec->ptrace_sid = SECINITSID_UNLABELED;
> > +	tsec->osid = tsec->victim_sid = tsec->ptrace_sid =
> > +		SECINITSID_UNLABELED;
> >  	task->security = tsec;
> >  
> >  	return 0;
> > @@ -177,7 +178,7 @@ static void task_free_security(struct task_struct *task)
> >  
> >  static int inode_alloc_security(struct inode *inode)
> >  {
> > -	struct task_security_struct *tsec = current->security;
> > +	struct cred_security_struct *csec = current->cred->security;
> >  	struct inode_security_struct *isec;
> >  
> >  	isec = kmem_cache_zalloc(sel_inode_cache, GFP_KERNEL);
> > @@ -189,7 +190,7 @@ static int inode_alloc_security(struct inode *inode)
> >  	isec->inode = inode;
> >  	isec->sid = SECINITSID_UNLABELED;
> >  	isec->sclass = SECCLASS_FILE;
> > -	isec->task_sid = tsec->sid;
> > +	isec->task_sid = csec->action_sid;
> >  	inode->i_security = isec;
> >  
> >  	return 0;
> > @@ -211,7 +212,7 @@ static void inode_free_security(struct inode *inode)
> >  
> >  static int file_alloc_security(struct file *file)
> >  {
> > -	struct task_security_struct *tsec = current->security;
> > +	struct cred_security_struct *csec = current->cred->security;
> >  	struct file_security_struct *fsec;
> >  
> >  	fsec = kzalloc(sizeof(struct file_security_struct), GFP_KERNEL);
> > @@ -219,8 +220,8 @@ static int file_alloc_security(struct file *file)
> >  		return -ENOMEM;
> >  
> >  	fsec->file = file;
> > -	fsec->sid = tsec->sid;
> > -	fsec->fown_sid = tsec->sid;
> > +	fsec->sid = csec->action_sid;
> > +	fsec->fown_sid = csec->action_sid;
> >  	file->f_security = fsec;
> >  
> >  	return 0;
> > @@ -333,26 +334,26 @@ static match_table_t tokens = {
> >  
> >  static int may_context_mount_sb_relabel(u32 sid,
> >  			struct superblock_security_struct *sbsec,
> > -			struct task_security_struct *tsec)
> > +			struct cred_security_struct *csec)
> >  {
> >  	int rc;
> >  
> > -	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
> > +	rc = avc_has_perm(csec->action_sid, sbsec->sid, SECCLASS_FILESYSTEM,
> >  			  FILESYSTEM__RELABELFROM, NULL);
> >  	if (rc)
> >  		return rc;
> >  
> > -	rc = avc_has_perm(tsec->sid, sid, SECCLASS_FILESYSTEM,
> > +	rc = avc_has_perm(csec->action_sid, sid, SECCLASS_FILESYSTEM,
> >  			  FILESYSTEM__RELABELTO, NULL);
> >  	return rc;
> >  }
> >  
> >  static int may_context_mount_inode_relabel(u32 sid,
> >  			struct superblock_security_struct *sbsec,
> > -			struct task_security_struct *tsec)
> > +			struct cred_security_struct *csec)
> >  {
> >  	int rc;
> > -	rc = avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
> > +	rc = avc_has_perm(csec->action_sid, sbsec->sid, SECCLASS_FILESYSTEM,
> >  			  FILESYSTEM__RELABELFROM, NULL);
> >  	if (rc)
> >  		return rc;
> > @@ -369,7 +370,7 @@ static int try_context_mount(struct super_block *sb, void *data)
> >  	const char *name;
> >  	u32 sid;
> >  	int alloc = 0, rc = 0, seen = 0;
> > -	struct task_security_struct *tsec = current->security;
> > +	struct cred_security_struct *csec = current->cred->security;
> >  	struct superblock_security_struct *sbsec = sb->s_security;
> >  
> >  	if (!data)
> > @@ -501,7 +502,7 @@ static int try_context_mount(struct super_block *sb, void *data)
> >  			goto out_free;
> >  		}
> >  
> > -		rc = may_context_mount_sb_relabel(sid, sbsec, tsec);
> > +		rc = may_context_mount_sb_relabel(sid, sbsec, csec);
> >  		if (rc)
> >  			goto out_free;
> >  
> > @@ -523,12 +524,12 @@ static int try_context_mount(struct super_block *sb, void *data)
> >  		}
> >  
> >  		if (!fscontext) {
> > -			rc = may_context_mount_sb_relabel(sid, sbsec, tsec);
> > +			rc = may_context_mount_sb_relabel(sid, sbsec, csec);
> >  			if (rc)
> >  				goto out_free;
> >  			sbsec->sid = sid;
> >  		} else {
> > -			rc = may_context_mount_inode_relabel(sid, sbsec, tsec);
> > +			rc = may_context_mount_inode_relabel(sid, sbsec, csec);
> >  			if (rc)
> >  				goto out_free;
> >  		}
> > @@ -548,7 +549,7 @@ static int try_context_mount(struct super_block *sb, void *data)
> >  			goto out_free;
> >  		}
> >  
> > -		rc = may_context_mount_inode_relabel(sid, sbsec, tsec);
> > +		rc = may_context_mount_inode_relabel(sid, sbsec, csec);
> >  		if (rc)
> >  			goto out_free;
> >  
> > @@ -568,7 +569,7 @@ static int try_context_mount(struct super_block *sb, void *data)
> >  		if (sid == sbsec->def_sid)
> >  			goto out_free;
> >  
> > -		rc = may_context_mount_inode_relabel(sid, sbsec, tsec);
> > +		rc = may_context_mount_inode_relabel(sid, sbsec, csec);
> >  		if (rc)
> >  			goto out_free;
> >  
> > @@ -1023,15 +1024,22 @@ static inline u32 signal_to_av(int sig)
> >  
> >  /* Check permission betweeen a pair of tasks, e.g. signal checks,
> >     fork check, ptrace check, etc. */
> > -static int task_has_perm(struct task_struct *tsk1,
> > -			 struct task_struct *tsk2,
> > +static int task_has_perm(struct task_struct *actor,
> > +			 struct task_struct *victim,
> >  			 u32 perms)
> >  {
> > -	struct task_security_struct *tsec1, *tsec2;
> > +	struct cred_security_struct *csec;
> > +	struct task_security_struct *tsec;
> > +	u32 action_sid;
> > +
> > +	/* the actor may not be the current task */
> > +	rcu_read_lock();
> > +	csec = task_cred(actor)->security;
> > +	action_sid = csec->action_sid;
> > +	rcu_read_unlock();
> >  
> > -	tsec1 = tsk1->security;
> > -	tsec2 = tsk2->security;
> > -	return avc_has_perm(tsec1->sid, tsec2->sid,
> > +	tsec = victim->security;
> > +	return avc_has_perm(action_sid, tsec->victim_sid,
> >  			    SECCLASS_PROCESS, perms, NULL);
> >  }
> >  
> > @@ -1039,16 +1047,16 @@ static int task_has_perm(struct task_struct *tsk1,
> >  static int task_has_capability(struct task_struct *tsk,
> >  			       int cap)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct avc_audit_data ad;
> >  
> > -	tsec = tsk->security;
> > +	csec = tsk->cred->security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad,CAP);
> >  	ad.tsk = tsk;
> >  	ad.u.cap = cap;
> >  
> > -	return avc_has_perm(tsec->sid, tsec->sid,
> > +	return avc_has_perm(csec->action_sid, csec->action_sid,
> >  			    SECCLASS_CAPABILITY, CAP_TO_MASK(cap), &ad);
> >  }
> >  
> > @@ -1056,11 +1064,11 @@ static int task_has_capability(struct task_struct *tsk,
> >  static int task_has_system(struct task_struct *tsk,
> >  			   u32 perms)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  
> > -	tsec = tsk->security;
> > +	csec = tsk->cred->security;
> >  
> > -	return avc_has_perm(tsec->sid, SECINITSID_KERNEL,
> > +	return avc_has_perm(csec->action_sid, SECINITSID_KERNEL,
> >  			    SECCLASS_SYSTEM, perms, NULL);
> >  }
> >  
> > @@ -1072,14 +1080,14 @@ static int inode_has_perm(struct task_struct *tsk,
> >  			  u32 perms,
> >  			  struct avc_audit_data *adp)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct inode_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  
> >  	if (unlikely (IS_PRIVATE (inode)))
> >  		return 0;
> >  
> > -	tsec = tsk->security;
> > +	csec = tsk->cred->security;
> >  	isec = inode->i_security;
> >  
> >  	if (!adp) {
> > @@ -1088,7 +1096,8 @@ static int inode_has_perm(struct task_struct *tsk,
> >  		ad.u.fs.inode = inode;
> >  	}
> >  
> > -	return avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, adp);
> > +	return avc_has_perm(csec->action_sid, isec->sid, isec->sclass, perms,
> > +			    adp);
> >  }
> >  
> >  /* Same as inode_has_perm, but pass explicit audit data containing
> > @@ -1119,7 +1128,7 @@ static int file_has_perm(struct task_struct *tsk,
> >  				struct file *file,
> >  				u32 av)
> >  {
> > -	struct task_security_struct *tsec = tsk->security;
> > +	struct cred_security_struct *csec = tsk->cred->security;
> >  	struct file_security_struct *fsec = file->f_security;
> >  	struct vfsmount *mnt = file->f_path.mnt;
> >  	struct dentry *dentry = file->f_path.dentry;
> > @@ -1131,8 +1140,8 @@ static int file_has_perm(struct task_struct *tsk,
> >  	ad.u.fs.mnt = mnt;
> >  	ad.u.fs.dentry = dentry;
> >  
> > -	if (tsec->sid != fsec->sid) {
> > -		rc = avc_has_perm(tsec->sid, fsec->sid,
> > +	if (csec->action_sid != fsec->sid) {
> > +		rc = avc_has_perm(csec->action_sid, fsec->sid,
> >  				  SECCLASS_FD,
> >  				  FD__USE,
> >  				  &ad);
> > @@ -1152,36 +1161,36 @@ static int may_create(struct inode *dir,
> >  		      struct dentry *dentry,
> >  		      u16 tclass)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct inode_security_struct *dsec;
> >  	struct superblock_security_struct *sbsec;
> >  	u32 newsid;
> >  	struct avc_audit_data ad;
> >  	int rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	dsec = dir->i_security;
> >  	sbsec = dir->i_sb->s_security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, FS);
> >  	ad.u.fs.dentry = dentry;
> >  
> > -	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR,
> > +	rc = avc_has_perm(csec->action_sid, dsec->sid, SECCLASS_DIR,
> >  			  DIR__ADD_NAME | DIR__SEARCH,
> >  			  &ad);
> >  	if (rc)
> >  		return rc;
> >  
> > -	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
> > -		newsid = tsec->create_sid;
> > +	if (csec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
> > +		newsid = csec->create_sid;
> >  	} else {
> > -		rc = security_transition_sid(tsec->sid, dsec->sid, tclass,
> > -					     &newsid);
> > +		rc = security_transition_sid(csec->action_sid, dsec->sid,
> > +					     tclass, &newsid);
> >  		if (rc)
> >  			return rc;
> >  	}
> >  
> > -	rc = avc_has_perm(tsec->sid, newsid, tclass, FILE__CREATE, &ad);
> > +	rc = avc_has_perm(csec->action_sid, newsid, tclass, FILE__CREATE, &ad);
> >  	if (rc)
> >  		return rc;
> >  
> > @@ -1194,11 +1203,12 @@ static int may_create(struct inode *dir,
> >  static int may_create_key(u32 ksid,
> >  			  struct task_struct *ctx)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  
> > -	tsec = ctx->security;
> > +	csec = ctx->cred->security;
> >  
> > -	return avc_has_perm(tsec->sid, ksid, SECCLASS_KEY, KEY__CREATE, NULL);
> > +	return avc_has_perm(csec->action_sid, ksid, SECCLASS_KEY, KEY__CREATE,
> > +			    NULL);
> >  }
> >  
> >  #define MAY_LINK   0
> > @@ -1211,13 +1221,13 @@ static int may_link(struct inode *dir,
> >  		    int kind)
> >  
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct inode_security_struct *dsec, *isec;
> >  	struct avc_audit_data ad;
> >  	u32 av;
> >  	int rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	dsec = dir->i_security;
> >  	isec = dentry->d_inode->i_security;
> >  
> > @@ -1226,7 +1236,7 @@ static int may_link(struct inode *dir,
> >  
> >  	av = DIR__SEARCH;
> >  	av |= (kind ? DIR__REMOVE_NAME : DIR__ADD_NAME);
> > -	rc = avc_has_perm(tsec->sid, dsec->sid, SECCLASS_DIR, av, &ad);
> > +	rc = avc_has_perm(csec->action_sid, dsec->sid, SECCLASS_DIR, av, &ad);
> >  	if (rc)
> >  		return rc;
> >  
> > @@ -1245,7 +1255,7 @@ static int may_link(struct inode *dir,
> >  		return 0;
> >  	}
> >  
> > -	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass, av, &ad);
> > +	rc = avc_has_perm(csec->action_sid, isec->sid, isec->sclass, av, &ad);
> >  	return rc;
> >  }
> >  
> > @@ -1254,14 +1264,14 @@ static inline int may_rename(struct inode *old_dir,
> >  			     struct inode *new_dir,
> >  			     struct dentry *new_dentry)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct inode_security_struct *old_dsec, *new_dsec, *old_isec, *new_isec;
> >  	struct avc_audit_data ad;
> >  	u32 av;
> >  	int old_is_dir, new_is_dir;
> >  	int rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	old_dsec = old_dir->i_security;
> >  	old_isec = old_dentry->d_inode->i_security;
> >  	old_is_dir = S_ISDIR(old_dentry->d_inode->i_mode);
> > @@ -1270,16 +1280,16 @@ static inline int may_rename(struct inode *old_dir,
> >  	AVC_AUDIT_DATA_INIT(&ad, FS);
> >  
> >  	ad.u.fs.dentry = old_dentry;
> > -	rc = avc_has_perm(tsec->sid, old_dsec->sid, SECCLASS_DIR,
> > +	rc = avc_has_perm(csec->action_sid, old_dsec->sid, SECCLASS_DIR,
> >  			  DIR__REMOVE_NAME | DIR__SEARCH, &ad);
> >  	if (rc)
> >  		return rc;
> > -	rc = avc_has_perm(tsec->sid, old_isec->sid,
> > +	rc = avc_has_perm(csec->action_sid, old_isec->sid,
> >  			  old_isec->sclass, FILE__RENAME, &ad);
> >  	if (rc)
> >  		return rc;
> >  	if (old_is_dir && new_dir != old_dir) {
> > -		rc = avc_has_perm(tsec->sid, old_isec->sid,
> > +		rc = avc_has_perm(csec->action_sid, old_isec->sid,
> >  				  old_isec->sclass, DIR__REPARENT, &ad);
> >  		if (rc)
> >  			return rc;
> > @@ -1289,15 +1299,17 @@ static inline int may_rename(struct inode *old_dir,
> >  	av = DIR__ADD_NAME | DIR__SEARCH;
> >  	if (new_dentry->d_inode)
> >  		av |= DIR__REMOVE_NAME;
> > -	rc = avc_has_perm(tsec->sid, new_dsec->sid, SECCLASS_DIR, av, &ad);
> > +	rc = avc_has_perm(csec->action_sid, new_dsec->sid, SECCLASS_DIR, av,
> > +			  &ad);
> >  	if (rc)
> >  		return rc;
> >  	if (new_dentry->d_inode) {
> >  		new_isec = new_dentry->d_inode->i_security;
> >  		new_is_dir = S_ISDIR(new_dentry->d_inode->i_mode);
> > -		rc = avc_has_perm(tsec->sid, new_isec->sid,
> > +		rc = avc_has_perm(csec->action_sid, new_isec->sid,
> >  				  new_isec->sclass,
> > -				  (new_is_dir ? DIR__RMDIR : FILE__UNLINK), &ad);
> > +				  (new_is_dir ? DIR__RMDIR : FILE__UNLINK),
> > +				  &ad);
> >  		if (rc)
> >  			return rc;
> >  	}
> > @@ -1311,12 +1323,12 @@ static int superblock_has_perm(struct task_struct *tsk,
> >  			       u32 perms,
> >  			       struct avc_audit_data *ad)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct superblock_security_struct *sbsec;
> >  
> > -	tsec = tsk->security;
> > +	csec = tsk->cred->security;
> >  	sbsec = sb->s_security;
> > -	return avc_has_perm(tsec->sid, sbsec->sid, SECCLASS_FILESYSTEM,
> > +	return avc_has_perm(csec->action_sid, sbsec->sid, SECCLASS_FILESYSTEM,
> >  			    perms, ad);
> >  }
> >  
> > @@ -1369,7 +1381,7 @@ static inline u32 file_to_av(struct file *file)
> >  
> >  static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
> >  {
> > -	struct task_security_struct *psec = parent->security;
> > +	struct cred_security_struct *psec;
> >  	struct task_security_struct *csec = child->security;
> >  	int rc;
> >  
> > @@ -1379,8 +1391,12 @@ static int selinux_ptrace(struct task_struct *parent, struct task_struct *child)
> >  
> >  	rc = task_has_perm(parent, child, PROCESS__PTRACE);
> >  	/* Save the SID of the tracing process for later use in apply_creds. */
> > -	if (!(child->ptrace & PT_PTRACED) && !rc)
> > -		csec->ptrace_sid = psec->sid;
> > +	if (!(child->ptrace & PT_PTRACED) && !rc) {
> > +		rcu_read_lock();
> > +		psec = task_cred(parent)->security;
> > +		csec->ptrace_sid = psec->action_sid;
> > +		rcu_read_unlock();
> > +	}
> >  	return rc;
> >  }
> >  
> > @@ -1470,7 +1486,7 @@ static int selinux_sysctl(ctl_table *table, int op)
> >  {
> >  	int error = 0;
> >  	u32 av;
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	u32 tsid;
> >  	int rc;
> >  
> > @@ -1478,7 +1494,7 @@ static int selinux_sysctl(ctl_table *table, int op)
> >  	if (rc)
> >  		return rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  
> >  	rc = selinux_sysctl_get_sid(table, (op == 0001) ?
> >  				    SECCLASS_DIR : SECCLASS_FILE, &tsid);
> > @@ -1490,7 +1506,7 @@ static int selinux_sysctl(ctl_table *table, int op)
> >  	/* The op values are "defined" in sysctl.c, thereby creating
> >  	 * a bad coupling between this module and sysctl.c */
> >  	if(op == 001) {
> > -		error = avc_has_perm(tsec->sid, tsid,
> > +		error = avc_has_perm(csec->action_sid, tsid,
> >  				     SECCLASS_DIR, DIR__SEARCH, NULL);
> >  	} else {
> >  		av = 0;
> > @@ -1499,7 +1515,7 @@ static int selinux_sysctl(ctl_table *table, int op)
> >  		if (op & 002)
> >  			av |= FILE__WRITE;
> >  		if (av)
> > -			error = avc_has_perm(tsec->sid, tsid,
> > +			error = avc_has_perm(csec->action_sid, tsid,
> >  					     SECCLASS_FILE, av, NULL);
> >          }
> >  
> > @@ -1587,11 +1603,11 @@ static int selinux_syslog(int type)
> >  static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
> >  {
> >  	int rc, cap_sys_admin = 0;
> > -	struct task_security_struct *tsec = current->security;
> > +	struct cred_security_struct *csec = current->cred->security;
> >  
> >  	rc = secondary_ops->capable(current, CAP_SYS_ADMIN);
> >  	if (rc == 0)
> > -		rc = avc_has_perm_noaudit(tsec->sid, tsec->sid,
> > +		rc = avc_has_perm_noaudit(csec->action_sid, csec->action_sid,
> >  					  SECCLASS_CAPABILITY,
> >  					  CAP_TO_MASK(CAP_SYS_ADMIN),
> >  					  0,
> > @@ -1624,6 +1640,7 @@ static int selinux_bprm_alloc_security(struct linux_binprm *bprm)
> >  static int selinux_bprm_set_security(struct linux_binprm *bprm)
> >  {
> >  	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct inode *inode = bprm->file->f_path.dentry->d_inode;
> >  	struct inode_security_struct *isec;
> >  	struct bprm_security_struct *bsec;
> > @@ -1641,15 +1658,16 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
> >  		return 0;
> >  
> >  	tsec = current->security;
> > +	csec = bprm->cred->security;
> >  	isec = inode->i_security;
> >  
> >  	/* Default to the current task SID. */
> > -	bsec->sid = tsec->sid;
> > +	bsec->sid = csec->action_sid;
> >  
> >  	/* Reset fs, key, and sock SIDs on execve. */
> > -	tsec->create_sid = 0;
> > -	tsec->keycreate_sid = 0;
> > -	tsec->sockcreate_sid = 0;
> > +	csec->create_sid = 0;
> > +	csec->keycreate_sid = 0;
> > +	csec->sockcreate_sid = 0;
> >  
> >  	if (tsec->exec_sid) {
> >  		newsid = tsec->exec_sid;
> > @@ -1657,7 +1675,7 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
> >  		tsec->exec_sid = 0;
> >  	} else {
> >  		/* Check for a default transition on this program. */
> > -		rc = security_transition_sid(tsec->sid, isec->sid,
> > +		rc = security_transition_sid(csec->action_sid, isec->sid,
> >  		                             SECCLASS_PROCESS, &newsid);
> >  		if (rc)
> >  			return rc;
> > @@ -1668,16 +1686,16 @@ static int selinux_bprm_set_security(struct linux_binprm *bprm)
> >  	ad.u.fs.dentry = bprm->file->f_path.dentry;
> >  
> >  	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
> > -		newsid = tsec->sid;
> > +		newsid = csec->action_sid;
> >  
> > -        if (tsec->sid == newsid) {
> > -		rc = avc_has_perm(tsec->sid, isec->sid,
> > +        if (csec->action_sid == newsid) {
> > +		rc = avc_has_perm(csec->action_sid, isec->sid,
> >  				  SECCLASS_FILE, FILE__EXECUTE_NO_TRANS, &ad);
> >  		if (rc)
> >  			return rc;
> >  	} else {
> >  		/* Check permissions for the transition. */
> > -		rc = avc_has_perm(tsec->sid, newsid,
> > +		rc = avc_has_perm(csec->action_sid, newsid,
> >  				  SECCLASS_PROCESS, PROCESS__TRANSITION, &ad);
> >  		if (rc)
> >  			return rc;
> > @@ -1709,11 +1727,11 @@ static int selinux_bprm_secureexec (struct linux_binprm *bprm)
> >  	struct task_security_struct *tsec = current->security;
> >  	int atsecure = 0;
> >  
> > -	if (tsec->osid != tsec->sid) {
> > +	if (tsec->osid != tsec->victim_sid) {
> >  		/* Enable secure mode for SIDs transitions unless
> >  		   the noatsecure permission is granted between
> >  		   the two SIDs, i.e. ahp returns 0. */
> > -		atsecure = avc_has_perm(tsec->osid, tsec->sid,
> > +		atsecure = avc_has_perm(tsec->osid, tsec->victim_sid,
> >  					 SECCLASS_PROCESS,
> >  					 PROCESS__NOATSECURE, NULL);
> >  	}
> > @@ -1823,6 +1841,7 @@ static inline void flush_unauthorized_files(struct files_struct * files)
> >  static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
> >  {
> >  	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct bprm_security_struct *bsec;
> >  	u32 sid;
> >  	int rc;
> > @@ -1830,17 +1849,17 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
> >  	secondary_ops->bprm_apply_creds(bprm, unsafe);
> >  
> >  	tsec = current->security;
> > -
> > +	csec = bprm->cred->security;
> >  	bsec = bprm->security;
> >  	sid = bsec->sid;
> >  
> > -	tsec->osid = tsec->sid;
> > +	tsec->osid = tsec->victim_sid;
> >  	bsec->unsafe = 0;
> > -	if (tsec->sid != sid) {
> > +	if (tsec->victim_sid != sid) {
> >  		/* Check for shared state.  If not ok, leave SID
> >  		   unchanged and kill. */
> >  		if (unsafe & LSM_UNSAFE_SHARE) {
> > -			rc = avc_has_perm(tsec->sid, sid, SECCLASS_PROCESS,
> > +			rc = avc_has_perm(tsec->victim_sid, sid, SECCLASS_PROCESS,
> >  					PROCESS__SHARE, NULL);
> >  			if (rc) {
> >  				bsec->unsafe = 1;
> > @@ -1859,7 +1878,9 @@ static void selinux_bprm_apply_creds(struct linux_binprm *bprm, int unsafe)
> >  				return;
> >  			}
> >  		}
> > -		tsec->sid = sid;
> > +		if (csec->action_sid == tsec->victim_sid)
> > +			csec->action_sid = sid;
> > +		tsec->victim_sid = sid;
> >  	}
> >  }
> >  
> > @@ -1881,7 +1902,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
> >  		force_sig_specific(SIGKILL, current);
> >  		return;
> >  	}
> > -	if (tsec->osid == tsec->sid)
> > +	if (tsec->osid == tsec->victim_sid)
> >  		return;
> >  
> >  	/* Close files for which the new task SID is not authorized. */
> > @@ -1893,7 +1914,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
> >  	   signals. This must occur _after_ the task SID has
> >  	  been updated so that any kill done after the flush
> >  	  will be checked against the new SID. */
> > -	rc = avc_has_perm(tsec->osid, tsec->sid, SECCLASS_PROCESS,
> > +	rc = avc_has_perm(tsec->osid, tsec->victim_sid, SECCLASS_PROCESS,
> >  			  PROCESS__SIGINH, NULL);
> >  	if (rc) {
> >  		memset(&itimer, 0, sizeof itimer);
> > @@ -1920,7 +1941,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
> >  	   than the default soft limit for cases where the default
> >  	   is lower than the hard limit, e.g. RLIMIT_CORE or
> >  	   RLIMIT_STACK.*/
> > -	rc = avc_has_perm(tsec->osid, tsec->sid, SECCLASS_PROCESS,
> > +	rc = avc_has_perm(tsec->osid, tsec->victim_sid, SECCLASS_PROCESS,
> >  			  PROCESS__RLIMITINH, NULL);
> >  	if (rc) {
> >  		for (i = 0; i < RLIM_NLIMITS; i++) {
> > @@ -2122,21 +2143,21 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
> >  				       char **name, void **value,
> >  				       size_t *len)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct inode_security_struct *dsec;
> >  	struct superblock_security_struct *sbsec;
> >  	u32 newsid, clen;
> >  	int rc;
> >  	char *namep = NULL, *context;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	dsec = dir->i_security;
> >  	sbsec = dir->i_sb->s_security;
> >  
> > -	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
> > -		newsid = tsec->create_sid;
> > +	if (csec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
> > +		newsid = csec->create_sid;
> >  	} else {
> > -		rc = security_transition_sid(tsec->sid, dsec->sid,
> > +		rc = security_transition_sid(csec->action_sid, dsec->sid,
> >  					     inode_mode_to_security_class(inode->i_mode),
> >  					     &newsid);
> >  		if (rc) {
> > @@ -2295,7 +2316,7 @@ static int selinux_inode_getattr(struct vfsmount *mnt, struct dentry *dentry)
> >  
> >  static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value, size_t size, int flags)
> >  {
> > -	struct task_security_struct *tsec = current->security;
> > +	struct cred_security_struct *csec = current->cred->security;
> >  	struct inode *inode = dentry->d_inode;
> >  	struct inode_security_struct *isec = inode->i_security;
> >  	struct superblock_security_struct *sbsec;
> > @@ -2327,7 +2348,7 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
> >  	AVC_AUDIT_DATA_INIT(&ad,FS);
> >  	ad.u.fs.dentry = dentry;
> >  
> > -	rc = avc_has_perm(tsec->sid, isec->sid, isec->sclass,
> > +	rc = avc_has_perm(csec->action_sid, isec->sid, isec->sclass,
> >  			  FILE__RELABELFROM, &ad);
> >  	if (rc)
> >  		return rc;
> > @@ -2336,12 +2357,12 @@ static int selinux_inode_setxattr(struct dentry *dentry, char *name, void *value
> >  	if (rc)
> >  		return rc;
> >  
> > -	rc = avc_has_perm(tsec->sid, newsid, isec->sclass,
> > +	rc = avc_has_perm(csec->action_sid, newsid, isec->sclass,
> >  			  FILE__RELABELTO, &ad);
> >  	if (rc)
> >  		return rc;
> >  
> > -	rc = security_validate_transition(isec->sid, newsid, tsec->sid,
> > +	rc = security_validate_transition(isec->sid, newsid, csec->action_sid,
> >  	                                  isec->sclass);
> >  	if (rc)
> >  		return rc;
> > @@ -2575,8 +2596,9 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
> >  			     unsigned long prot, unsigned long flags,
> >  			     unsigned long addr, unsigned long addr_only)
> >  {
> > +	struct cred_security_struct *csec = current->cred->security;
> >  	int rc = 0;
> > -	u32 sid = ((struct task_security_struct*)(current->security))->sid;
> > +	u32 sid = csec->action_sid;
> >  
> >  	if (addr < mmap_min_addr)
> >  		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
> > @@ -2690,7 +2712,7 @@ static int selinux_file_set_fowner(struct file *file)
> >  
> >  	tsec = current->security;
> >  	fsec = file->f_security;
> > -	fsec->fown_sid = tsec->sid;
> > +	fsec->fown_sid = tsec->victim_sid;
> >  
> >  	return 0;
> >  }
> > @@ -2714,7 +2736,7 @@ static int selinux_file_send_sigiotask(struct task_struct *tsk,
> >  	else
> >  		perm = signal_to_av(signum);
> >  
> > -	return avc_has_perm(fsec->fown_sid, tsec->sid,
> > +	return avc_has_perm(fsec->fown_sid, tsec->victim_sid,
> >  			    SECCLASS_PROCESS, perm, NULL);
> >  }
> >  
> > @@ -2723,6 +2745,31 @@ static int selinux_file_receive(struct file *file)
> >  	return file_has_perm(current, file, file_to_av(file));
> >  }
> >  
> > +/* credential security operations */
> > +
> > +/*
> > + * duplicate the security information attached to a credentials record that is
> > + * itself undergoing duplication
> > + */
> > +static int selinux_cred_dup(struct cred *cred)
> > +{
> > +	cred->security = kmemdup(cred->security,
> > +				 sizeof(struct cred_security_struct),
> > +				 GFP_KERNEL);
> > +	return cred->security ? 0 : -ENOMEM;
> > +}
> > +
> > +/*
> > + * destroy the security information attached to a credentials record
> > + * - this is done under RCU, and may not be associated with the task that set it
> > + *   up
> > + */
> > +static void selinux_cred_destroy(struct cred *cred)
> > +{
> > +	kfree(cred->security);
> > +}
> > +
> > +
> >  /* task security operations */
> >  
> >  static int selinux_task_create(unsigned long clone_flags)
> > @@ -2749,13 +2796,10 @@ static int selinux_task_alloc_security(struct task_struct *tsk)
> >  	tsec2 = tsk->security;
> >  
> >  	tsec2->osid = tsec1->osid;
> > -	tsec2->sid = tsec1->sid;
> > +	tsec2->victim_sid = tsec1->victim_sid;
> >  
> > -	/* Retain the exec, fs, key, and sock SIDs across fork */
> > +	/* Retain the exec SID across fork */
> >  	tsec2->exec_sid = tsec1->exec_sid;
> > -	tsec2->create_sid = tsec1->create_sid;
> > -	tsec2->keycreate_sid = tsec1->keycreate_sid;
> > -	tsec2->sockcreate_sid = tsec1->sockcreate_sid;
> >  
> >  	/* Retain ptracer SID across fork, if any.
> >  	   This will be reset by the ptrace hook upon any
> > @@ -2893,7 +2937,8 @@ static int selinux_task_kill(struct task_struct *p, struct siginfo *info,
> >  		perm = signal_to_av(sig);
> >  	tsec = p->security;
> >  	if (secid)
> > -		rc = avc_has_perm(secid, tsec->sid, SECCLASS_PROCESS, perm, NULL);
> > +		rc = avc_has_perm(secid, tsec->victim_sid,
> > +				  SECCLASS_PROCESS, perm, NULL);
> >  	else
> >  		rc = task_has_perm(current, p, perm);
> >  	return rc;
> > @@ -2927,8 +2972,8 @@ static void selinux_task_reparent_to_init(struct task_struct *p)
> >  	secondary_ops->task_reparent_to_init(p);
> >  
> >  	tsec = p->security;
> > -	tsec->osid = tsec->sid;
> > -	tsec->sid = SECINITSID_KERNEL;
> > +	tsec->osid = tsec->victim_sid;
> > +	tsec->victim_sid = SECINITSID_KERNEL;
> >  	return;
> >  }
> >  
> > @@ -2938,7 +2983,7 @@ static void selinux_task_to_inode(struct task_struct *p,
> >  	struct task_security_struct *tsec = p->security;
> >  	struct inode_security_struct *isec = inode->i_security;
> >  
> > -	isec->sid = tsec->sid;
> > +	isec->sid = tsec->victim_sid;
> >  	isec->initialized = 1;
> >  	return;
> >  }
> > @@ -3163,11 +3208,11 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
> >  			   u32 perms)
> >  {
> >  	struct inode_security_struct *isec;
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct avc_audit_data ad;
> >  	int err = 0;
> >  
> > -	tsec = task->security;
> > +	csec = task->cred->security;
> >  	isec = SOCK_INODE(sock)->i_security;
> >  
> >  	if (isec->sid == SECINITSID_KERNEL)
> > @@ -3175,7 +3220,8 @@ static int socket_has_perm(struct task_struct *task, struct socket *sock,
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad,NET);
> >  	ad.u.net.sk = sock->sk;
> > -	err = avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, &ad);
> > +	err = avc_has_perm(csec->action_sid, isec->sid, isec->sclass, perms,
> > +			   &ad);
> >  
> >  out:
> >  	return err;
> > @@ -3185,15 +3231,15 @@ static int selinux_socket_create(int family, int type,
> >  				 int protocol, int kern)
> >  {
> >  	int err = 0;
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	u32 newsid;
> >  
> >  	if (kern)
> >  		goto out;
> >  
> > -	tsec = current->security;
> > -	newsid = tsec->sockcreate_sid ? : tsec->sid;
> > -	err = avc_has_perm(tsec->sid, newsid,
> > +	csec = current->cred->security;
> > +	newsid = csec->sockcreate_sid ? : csec->action_sid;
> > +	err = avc_has_perm(csec->action_sid, newsid,
> >  			   socket_type_to_security_class(family, type,
> >  			   protocol), SOCKET__CREATE, NULL);
> >  
> > @@ -3206,14 +3252,14 @@ static int selinux_socket_post_create(struct socket *sock, int family,
> >  {
> >  	int err = 0;
> >  	struct inode_security_struct *isec;
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct sk_security_struct *sksec;
> >  	u32 newsid;
> >  
> >  	isec = SOCK_INODE(sock)->i_security;
> >  
> > -	tsec = current->security;
> > -	newsid = tsec->sockcreate_sid ? : tsec->sid;
> > +	csec = current->cred->security;
> > +	newsid = csec->sockcreate_sid ? : csec->action_sid;
> >  	isec->sclass = socket_type_to_security_class(family, type, protocol);
> >  	isec->sid = kern ? SECINITSID_KERNEL : newsid;
> >  	isec->initialized = 1;
> > @@ -4027,7 +4073,7 @@ static int ipc_alloc_security(struct task_struct *task,
> >  			      struct kern_ipc_perm *perm,
> >  			      u16 sclass)
> >  {
> > -	struct task_security_struct *tsec = task->security;
> > +	struct cred_security_struct *csec = task->cred->security;
> >  	struct ipc_security_struct *isec;
> >  
> >  	isec = kzalloc(sizeof(struct ipc_security_struct), GFP_KERNEL);
> > @@ -4036,7 +4082,7 @@ static int ipc_alloc_security(struct task_struct *task,
> >  
> >  	isec->sclass = sclass;
> >  	isec->ipc_perm = perm;
> > -	isec->sid = tsec->sid;
> > +	isec->sid = csec->action_sid;
> >  	perm->security = isec;
> >  
> >  	return 0;
> > @@ -4075,17 +4121,18 @@ static void msg_msg_free_security(struct msg_msg *msg)
> >  static int ipc_has_perm(struct kern_ipc_perm *ipc_perms,
> >  			u32 perms)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = ipc_perms->security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >  	ad.u.ipc_id = ipc_perms->key;
> >  
> > -	return avc_has_perm(tsec->sid, isec->sid, isec->sclass, perms, &ad);
> > +	return avc_has_perm(csec->action_sid, isec->sid, isec->sclass, perms,
> > +			    &ad);
> >  }
> >  
> >  static int selinux_msg_msg_alloc_security(struct msg_msg *msg)
> > @@ -4101,7 +4148,7 @@ static void selinux_msg_msg_free_security(struct msg_msg *msg)
> >  /* message queue security operations */
> >  static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  	int rc;
> > @@ -4110,13 +4157,13 @@ static int selinux_msg_queue_alloc_security(struct msg_queue *msq)
> >  	if (rc)
> >  		return rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = msq->q_perm.security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >   	ad.u.ipc_id = msq->q_perm.key;
> >  
> > -	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
> > +	rc = avc_has_perm(csec->action_sid, isec->sid, SECCLASS_MSGQ,
> >  			  MSGQ__CREATE, &ad);
> >  	if (rc) {
> >  		ipc_free_security(&msq->q_perm);
> > @@ -4132,17 +4179,17 @@ static void selinux_msg_queue_free_security(struct msg_queue *msq)
> >  
> >  static int selinux_msg_queue_associate(struct msg_queue *msq, int msqflg)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = msq->q_perm.security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >  	ad.u.ipc_id = msq->q_perm.key;
> >  
> > -	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
> > +	return avc_has_perm(csec->action_sid, isec->sid, SECCLASS_MSGQ,
> >  			    MSGQ__ASSOCIATE, &ad);
> >  }
> >  
> > @@ -4176,13 +4223,13 @@ static int selinux_msg_queue_msgctl(struct msg_queue *msq, int cmd)
> >  
> >  static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg, int msqflg)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct msg_security_struct *msec;
> >  	struct avc_audit_data ad;
> >  	int rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = msq->q_perm.security;
> >  	msec = msg->security;
> >  
> > @@ -4194,7 +4241,7 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
> >  		 * Compute new sid based on current process and
> >  		 * message queue this message will be stored in
> >  		 */
> > -		rc = security_transition_sid(tsec->sid,
> > +		rc = security_transition_sid(csec->action_sid,
> >  					     isec->sid,
> >  					     SECCLASS_MSG,
> >  					     &msec->sid);
> > @@ -4206,11 +4253,11 @@ static int selinux_msg_queue_msgsnd(struct msg_queue *msq, struct msg_msg *msg,
> >  	ad.u.ipc_id = msq->q_perm.key;
> >  
> >  	/* Can this process write to the queue? */
> > -	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_MSGQ,
> > +	rc = avc_has_perm(csec->action_sid, isec->sid, SECCLASS_MSGQ,
> >  			  MSGQ__WRITE, &ad);
> >  	if (!rc)
> >  		/* Can this process send the message */
> > -		rc = avc_has_perm(tsec->sid, msec->sid,
> > +		rc = avc_has_perm(csec->action_sid, msec->sid,
> >  				  SECCLASS_MSG, MSG__SEND, &ad);
> >  	if (!rc)
> >  		/* Can the message be put in the queue? */
> > @@ -4237,10 +4284,10 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >   	ad.u.ipc_id = msq->q_perm.key;
> >  
> > -	rc = avc_has_perm(tsec->sid, isec->sid,
> > +	rc = avc_has_perm(tsec->victim_sid, isec->sid,
> >  			  SECCLASS_MSGQ, MSGQ__READ, &ad);
> >  	if (!rc)
> > -		rc = avc_has_perm(tsec->sid, msec->sid,
> > +		rc = avc_has_perm(tsec->victim_sid, msec->sid,
> >  				  SECCLASS_MSG, MSG__RECEIVE, &ad);
> >  	return rc;
> >  }
> > @@ -4248,7 +4295,7 @@ static int selinux_msg_queue_msgrcv(struct msg_queue *msq, struct msg_msg *msg,
> >  /* Shared Memory security operations */
> >  static int selinux_shm_alloc_security(struct shmid_kernel *shp)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  	int rc;
> > @@ -4257,13 +4304,13 @@ static int selinux_shm_alloc_security(struct shmid_kernel *shp)
> >  	if (rc)
> >  		return rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = shp->shm_perm.security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >   	ad.u.ipc_id = shp->shm_perm.key;
> >  
> > -	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_SHM,
> > +	rc = avc_has_perm(csec->action_sid, isec->sid, SECCLASS_SHM,
> >  			  SHM__CREATE, &ad);
> >  	if (rc) {
> >  		ipc_free_security(&shp->shm_perm);
> > @@ -4279,17 +4326,17 @@ static void selinux_shm_free_security(struct shmid_kernel *shp)
> >  
> >  static int selinux_shm_associate(struct shmid_kernel *shp, int shmflg)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = shp->shm_perm.security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >  	ad.u.ipc_id = shp->shm_perm.key;
> >  
> > -	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_SHM,
> > +	return avc_has_perm(csec->action_sid, isec->sid, SECCLASS_SHM,
> >  			    SHM__ASSOCIATE, &ad);
> >  }
> >  
> > @@ -4347,7 +4394,7 @@ static int selinux_shm_shmat(struct shmid_kernel *shp,
> >  /* Semaphore security operations */
> >  static int selinux_sem_alloc_security(struct sem_array *sma)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  	int rc;
> > @@ -4356,13 +4403,13 @@ static int selinux_sem_alloc_security(struct sem_array *sma)
> >  	if (rc)
> >  		return rc;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = sma->sem_perm.security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >   	ad.u.ipc_id = sma->sem_perm.key;
> >  
> > -	rc = avc_has_perm(tsec->sid, isec->sid, SECCLASS_SEM,
> > +	rc = avc_has_perm(csec->action_sid, isec->sid, SECCLASS_SEM,
> >  			  SEM__CREATE, &ad);
> >  	if (rc) {
> >  		ipc_free_security(&sma->sem_perm);
> > @@ -4378,17 +4425,17 @@ static void selinux_sem_free_security(struct sem_array *sma)
> >  
> >  static int selinux_sem_associate(struct sem_array *sma, int semflg)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct ipc_security_struct *isec;
> >  	struct avc_audit_data ad;
> >  
> > -	tsec = current->security;
> > +	csec = current->cred->security;
> >  	isec = sma->sem_perm.security;
> >  
> >  	AVC_AUDIT_DATA_INIT(&ad, IPC);
> >  	ad.u.ipc_id = sma->sem_perm.key;
> >  
> > -	return avc_has_perm(tsec->sid, isec->sid, SECCLASS_SEM,
> > +	return avc_has_perm(csec->action_sid, isec->sid, SECCLASS_SEM,
> >  			    SEM__ASSOCIATE, &ad);
> >  }
> >  
> > @@ -4504,6 +4551,7 @@ static int selinux_getprocattr(struct task_struct *p,
> >  			       char *name, char **value)
> >  {
> >  	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	u32 sid;
> >  	int error;
> >  	unsigned len;
> > @@ -4515,22 +4563,25 @@ static int selinux_getprocattr(struct task_struct *p,
> >  	}
> >  
> >  	tsec = p->security;
> > +	rcu_read_lock();
> > +	csec = task_cred(p)->security;
> >  
> >  	if (!strcmp(name, "current"))
> > -		sid = tsec->sid;
> > +		sid = tsec->victim_sid;
> >  	else if (!strcmp(name, "prev"))
> >  		sid = tsec->osid;
> >  	else if (!strcmp(name, "exec"))
> >  		sid = tsec->exec_sid;
> >  	else if (!strcmp(name, "fscreate"))
> > -		sid = tsec->create_sid;
> > +		sid = csec->create_sid;
> >  	else if (!strcmp(name, "keycreate"))
> > -		sid = tsec->keycreate_sid;
> > +		sid = csec->keycreate_sid;
> >  	else if (!strcmp(name, "sockcreate"))
> > -		sid = tsec->sockcreate_sid;
> > +		sid = csec->sockcreate_sid;
> >  	else
> > -		return -EINVAL;
> > +		goto invalid;
> >  
> > +	rcu_read_unlock();
> >  	if (!sid)
> >  		return 0;
> >  
> > @@ -4538,13 +4589,20 @@ static int selinux_getprocattr(struct task_struct *p,
> >  	if (error)
> >  		return error;
> >  	return len;
> > +
> > +invalid:
> > +	rcu_read_unlock();
> > +	return -EINVAL;
> >  }
> >  
> >  static int selinux_setprocattr(struct task_struct *p,
> >  			       char *name, void *value, size_t size)
> >  {
> >  	struct task_security_struct *tsec;
> > -	u32 sid = 0;
> > +	struct cred_security_struct *csec;
> > +	struct av_decision avd;
> > +	struct cred *cred;
> > +	u32 sid = 0, perm;
> >  	int error;
> >  	char *str = value;
> >  
> > @@ -4560,17 +4618,19 @@ static int selinux_setprocattr(struct task_struct *p,
> >  	 * above restriction is ever removed.
> >  	 */
> >  	if (!strcmp(name, "exec"))
> > -		error = task_has_perm(current, p, PROCESS__SETEXEC);
> > +		perm = PROCESS__SETEXEC;
> >  	else if (!strcmp(name, "fscreate"))
> > -		error = task_has_perm(current, p, PROCESS__SETFSCREATE);
> > +		perm = PROCESS__SETFSCREATE;
> >  	else if (!strcmp(name, "keycreate"))
> > -		error = task_has_perm(current, p, PROCESS__SETKEYCREATE);
> > +		perm = PROCESS__SETKEYCREATE;
> >  	else if (!strcmp(name, "sockcreate"))
> > -		error = task_has_perm(current, p, PROCESS__SETSOCKCREATE);
> > +		perm = PROCESS__SETSOCKCREATE;
> >  	else if (!strcmp(name, "current"))
> > -		error = task_has_perm(current, p, PROCESS__SETCURRENT);
> > +		perm = PROCESS__SETCURRENT;
> >  	else
> > -		error = -EINVAL;
> > +		return -EINVAL;
> > +
> > +	error = task_has_perm(current, p, perm);
> >  	if (error)
> >  		return error;
> >  
> > @@ -4592,20 +4652,37 @@ static int selinux_setprocattr(struct task_struct *p,
> >  	   checks and may_create for the file creation checks. The
> >  	   operation will then fail if the context is not permitted. */
> >  	tsec = p->security;
> > -	if (!strcmp(name, "exec"))
> > +	csec = p->cred->security;
> > +	switch (perm) {
> > +	case PROCESS__SETEXEC:
> >  		tsec->exec_sid = sid;
> > -	else if (!strcmp(name, "fscreate"))
> > -		tsec->create_sid = sid;
> > -	else if (!strcmp(name, "keycreate")) {
> > +		break;
> > +
> > +	case PROCESS__SETKEYCREATE:
> >  		error = may_create_key(sid, p);
> >  		if (error)
> >  			return error;
> > -		tsec->keycreate_sid = sid;
> > -	} else if (!strcmp(name, "sockcreate"))
> > -		tsec->sockcreate_sid = sid;
> > -	else if (!strcmp(name, "current")) {
> > -		struct av_decision avd;
> > +	case PROCESS__SETFSCREATE:
> > +	case PROCESS__SETSOCKCREATE:
> > +		cred = dup_cred(current->cred);
> > +		if (!cred)
> > +			return -ENOMEM;
> > +		csec = cred->security;
> > +		switch (perm) {
> > +		case PROCESS__SETKEYCREATE:
> > +			csec->keycreate_sid = sid;
> > +			break;
> > +		case PROCESS__SETFSCREATE:
> > +			csec->create_sid = sid;
> > +			break;
> > +		case PROCESS__SETSOCKCREATE:
> > +			csec->sockcreate_sid = sid;
> > +			break;
> > +		}
> > +		set_current_cred(cred);
> > +		break;
> >  
> > +	case PROCESS__SETCURRENT:
> >  		if (sid == 0)
> >  			return -EINVAL;
> >  
> > @@ -4624,11 +4701,16 @@ static int selinux_setprocattr(struct task_struct *p,
> >                  }
> >  
> >  		/* Check permissions for the transition. */
> > -		error = avc_has_perm(tsec->sid, sid, SECCLASS_PROCESS,
> > +		error = avc_has_perm(csec->action_sid, sid, SECCLASS_PROCESS,
> >  		                     PROCESS__DYNTRANSITION, NULL);
> >  		if (error)
> >  			return error;
> >  
> > +		cred = dup_cred(current->cred);
> > +		if (!cred)
> > +			return -ENOMEM;
> > +		csec = cred->security;
> > +
> >  		/* Check for ptracing, and update the task SID if ok.
> >  		   Otherwise, leave SID unchanged and fail. */
> >  		task_lock(p);
> > @@ -4636,20 +4718,25 @@ static int selinux_setprocattr(struct task_struct *p,
> >  			error = avc_has_perm_noaudit(tsec->ptrace_sid, sid,
> >  						     SECCLASS_PROCESS,
> >  						     PROCESS__PTRACE, 0, &avd);
> > -			if (!error)
> > -				tsec->sid = sid;
> > +			if (!error) {
> > +				csec->action_sid = tsec->victim_sid = sid;
> > +			}
> >  			task_unlock(p);
> >  			avc_audit(tsec->ptrace_sid, sid, SECCLASS_PROCESS,
> >  				  PROCESS__PTRACE, &avd, error, NULL);
> > -			if (error)
> > +			if (error) {
> > +				put_cred(cred);
> >  				return error;
> > +			}
> >  		} else {
> > -			tsec->sid = sid;
> > +			csec->action_sid = tsec->victim_sid = sid;
> >  			task_unlock(p);
> >  		}
> > -	}
> > -	else
> > +		set_current_cred(cred);
> > +		break;
> > +	default:
> >  		return -EINVAL;
> > +	}
> >  
> >  	return size;
> >  }
> > @@ -4669,18 +4756,21 @@ static void selinux_release_secctx(char *secdata, u32 seclen)
> >  static int selinux_key_alloc(struct key *k, struct task_struct *tsk,
> >  			     unsigned long flags)
> >  {
> > -	struct task_security_struct *tsec = tsk->security;
> > +	struct cred_security_struct *csec;
> >  	struct key_security_struct *ksec;
> >  
> >  	ksec = kzalloc(sizeof(struct key_security_struct), GFP_KERNEL);
> >  	if (!ksec)
> >  		return -ENOMEM;
> >  
> > +	rcu_read_lock();
> > +	csec = task_cred(tsk)->security;
> >  	ksec->obj = k;
> > -	if (tsec->keycreate_sid)
> > -		ksec->sid = tsec->keycreate_sid;
> > +	if (csec->keycreate_sid)
> > +		ksec->sid = csec->keycreate_sid;
> >  	else
> > -		ksec->sid = tsec->sid;
> > +		ksec->sid = csec->action_sid;
> > +	rcu_read_unlock();
> >  	k->security = ksec;
> >  
> >  	return 0;
> > @@ -4695,17 +4785,13 @@ static void selinux_key_free(struct key *k)
> >  }
> >  
> >  static int selinux_key_permission(key_ref_t key_ref,
> > -			    struct task_struct *ctx,
> > -			    key_perm_t perm)
> > +				  struct task_struct *ctx,
> > +				  key_perm_t perm)
> >  {
> >  	struct key *key;
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  	struct key_security_struct *ksec;
> > -
> > -	key = key_ref_to_ptr(key_ref);
> > -
> > -	tsec = ctx->security;
> > -	ksec = key->security;
> > +	u32 action_sid;
> >  
> >  	/* if no specific permissions are requested, we skip the
> >  	   permission check. No serious, additional covert channels
> > @@ -4713,7 +4799,16 @@ static int selinux_key_permission(key_ref_t key_ref,
> >  	if (perm == 0)
> >  		return 0;
> >  
> > -	return avc_has_perm(tsec->sid, ksec->sid,
> > +	key = key_ref_to_ptr(key_ref);
> > +
> > +	rcu_read_lock();
> > +	csec = task_cred(ctx)->security;
> > +	action_sid = csec->action_sid;
> > +	rcu_read_unlock();
> > +
> > +	ksec = key->security;
> > +
> > +	return avc_has_perm(action_sid, ksec->sid,
> >  			    SECCLASS_KEY, perm, NULL);
> >  }
> >  
> > @@ -4788,6 +4883,9 @@ static struct security_operations selinux_ops = {
> >  	.file_send_sigiotask =		selinux_file_send_sigiotask,
> >  	.file_receive =			selinux_file_receive,
> >  
> > +	.cred_dup =			selinux_cred_dup,
> > +	.cred_destroy =			selinux_cred_destroy,
> > +
> >  	.task_create =			selinux_task_create,
> >  	.task_alloc_security =		selinux_task_alloc_security,
> >  	.task_free_security =		selinux_task_free_security,
> > @@ -4896,6 +4994,17 @@ static struct security_operations selinux_ops = {
> >  #endif
> >  };
> >  
> > +/*
> > + * initial security credentials
> > + * - attached to init_cred which is never released
> > + */
> > +static struct cred_security_struct init_cred_sec = {
> > +	.action_sid	= SECINITSID_KERNEL,
> > +	.create_sid	= SECINITSID_UNLABELED,
> > +	.keycreate_sid	= SECINITSID_UNLABELED,
> > +	.sockcreate_sid	= SECINITSID_UNLABELED,
> > +};
> > +
> >  static __init int selinux_init(void)
> >  {
> >  	struct task_security_struct *tsec;
> > @@ -4907,11 +5016,15 @@ static __init int selinux_init(void)
> >  
> >  	printk(KERN_INFO "SELinux:  Initializing.\n");
> >  
> > +	/* Set the security state for the initial credentials */
> > +	init_cred.security = &init_cred_sec;
> > +	BUG_ON(current->cred != &init_cred);
> > +
> >  	/* Set the security state for the initial task. */
> >  	if (task_alloc_security(current))
> >  		panic("SELinux:  Failed to initialize initial task.\n");
> >  	tsec = current->security;
> > -	tsec->osid = tsec->sid = SECINITSID_KERNEL;
> > +	tsec->osid = tsec->victim_sid = SECINITSID_KERNEL;
> >  
> >  	sel_inode_cache = kmem_cache_create("selinux_inode_security",
> >  					    sizeof(struct inode_security_struct),
> > diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
> > index 91b88f0..a1dbc1c 100644
> > --- a/security/selinux/include/objsec.h
> > +++ b/security/selinux/include/objsec.h
> > @@ -27,14 +27,22 @@
> >  #include "flask.h"
> >  #include "avc.h"
> >  
> > +/*
> > + * the security parameters associated with the credentials record structure
> > + * (struct cred::security)
> > + */
> > +struct cred_security_struct {
> > +	u32	action_sid;	/* perform action as SID */
> > +	u32	create_sid;	/* filesystem object creation as SID */
> > +	u32	keycreate_sid;	/* key creation as SID */
> > +	u32	sockcreate_sid;	/* socket creation as SID */
> > +};
> > +
> >  struct task_security_struct {
> >  	struct task_struct *task;      /* back pointer to task object */
> >  	u32 osid;            /* SID prior to last execve */
> > -	u32 sid;             /* current SID */
> > +	u32 victim_sid;	     /* current SID affecting victimisation of this task */
> >  	u32 exec_sid;        /* exec SID */
> > -	u32 create_sid;      /* fscreate SID */
> > -	u32 keycreate_sid;   /* keycreate SID */
> > -	u32 sockcreate_sid;  /* fscreate SID */
> >  	u32 ptrace_sid;      /* SID of ptrace parent */
> >  };
> >  
> > diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> > index c9e92da..9c6737f 100644
> > --- a/security/selinux/selinuxfs.c
> > +++ b/security/selinux/selinuxfs.c
> > @@ -77,13 +77,13 @@ extern void selnl_notify_setenforce(int val);
> >  static int task_has_security(struct task_struct *tsk,
> >  			     u32 perms)
> >  {
> > -	struct task_security_struct *tsec;
> > +	struct cred_security_struct *csec;
> >  
> > -	tsec = tsk->security;
> > -	if (!tsec)
> > +	csec = tsk->cred->security;
> > +	if (!csec)
> >  		return -EACCES;
> >  
> > -	return avc_has_perm(tsec->sid, SECINITSID_SECURITY,
> > +	return avc_has_perm(csec->action_sid, SECINITSID_SECURITY,
> >  			    SECCLASS_SECURITY, perms, NULL);
> >  }
> >  
> > diff --git a/security/selinux/xfrm.c b/security/selinux/xfrm.c
> > index ba715f4..902d302 100644
> > --- a/security/selinux/xfrm.c
> > +++ b/security/selinux/xfrm.c
> > @@ -240,7 +240,7 @@ static int selinux_xfrm_sec_ctx_alloc(struct xfrm_sec_ctx **ctxp,
> >  	/*
> >  	 * Does the subject have permission to set security context?
> >  	 */
> > -	rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
> > +	rc = avc_has_perm(tsec->action_sid, ctx->ctx_sid,
> >  			  SECCLASS_ASSOCIATION,
> >  			  ASSOCIATION__SETCONTEXT, NULL);
> >  	if (rc)
> > @@ -341,7 +341,7 @@ int selinux_xfrm_policy_delete(struct xfrm_policy *xp)
> >  	int rc = 0;
> >  
> >  	if (ctx)
> > -		rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
> > +		rc = avc_has_perm(tsec->action_sid, ctx->ctx_sid,
> >  				  SECCLASS_ASSOCIATION,
> >  				  ASSOCIATION__SETCONTEXT, NULL);
> >  
> > @@ -383,7 +383,7 @@ int selinux_xfrm_state_delete(struct xfrm_state *x)
> >  	int rc = 0;
> >  
> >  	if (ctx)
> > -		rc = avc_has_perm(tsec->sid, ctx->ctx_sid,
> > +		rc = avc_has_perm(tsec->action_sid, ctx->ctx_sid,
> >  				  SECCLASS_ASSOCIATION,
> >  				  ASSOCIATION__SETCONTEXT, NULL);
> >  
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Stephen Smalley
National Security Agency

