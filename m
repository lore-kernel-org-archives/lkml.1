Return-Path: <linux-kernel-owner+w=401wt.eu-S934870AbYBVEr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934870AbYBVEr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbYBVErP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:47:15 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:44148 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759348AbYBVErN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:47:13 -0500
X-YMail-OSG: lpNByLYVM1kR2vu8RO3a4ndPj4TUCpr63K720k2RdxnJNBlKY9kz0aDPMGMu05LDVgvCUdnO_uTDjh2FD9rDRWf7DnZ8gDs4jQi9goJx5Xq2YRlc0bc-
X-RocketYMMF: rancidfat
Date: Thu, 21 Feb 2008 20:47:11 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 06/37] Security: Separate task security context from task_struct
To: David Howells <dhowells@redhat.com>, Trond.Myklebust@netapp.com,
       chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <20080220160630.4715.28518.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <307968.59354.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Separate the task security context from task_struct.  At this point, the
> security data is temporarily embedded in the task_struct with two pointers
> pointing to it.

> ...

> diff --git a/security/smack/smack_access.c b/security/smack/smack_access.c
> index f6b5f6e..722752f 100644
> --- a/security/smack/smack_access.c
> +++ b/security/smack/smack_access.c
> @@ -164,7 +164,7 @@ int smk_curacc(char *obj_label, u32 mode)
>  {
>  	int rc;
>  
> -	rc = smk_access(current->security, obj_label, mode);
> +	rc = smk_access(current->act_as->security, obj_label, mode);
>  	if (rc == 0)
>  		return 0;
>  
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 25cbfa3..a49d94f 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -102,7 +102,8 @@ static int smack_ptrace(struct task_struct *ptp, struct
> task_struct *ctp)
>  	if (rc != 0)
>  		return rc;
>  
> -	rc = smk_access(ptp->security, ctp->security, MAY_READWRITE);
> +	rc = smk_access(ptp->act_as->security, ctp->sec->security,
> +			MAY_READWRITE);
>  	if (rc != 0 && __capable(ptp, CAP_MAC_OVERRIDE))
>  		return 0;
>  
> @@ -120,7 +121,7 @@ static int smack_ptrace(struct task_struct *ptp, struct
> task_struct *ctp)
>  static int smack_syslog(int type)
>  {
>  	int rc;
> -	char *sp = current->security;
> +	char *sp = current->act_as->security;
>  
>  	rc = cap_syslog(type);
>  	if (rc != 0)
> @@ -359,7 +360,7 @@ static int smack_sb_umount(struct vfsmount *mnt, int
> flags)
>   */
>  static int smack_inode_alloc_security(struct inode *inode)
>  {
> -	inode->i_security = new_inode_smack(current->security);
> +	inode->i_security = new_inode_smack(current->act_as->security);
>  	if (inode->i_security == NULL)
>  		return -ENOMEM;
>  	return 0;
> @@ -777,7 +778,7 @@ static int smack_file_permission(struct file *file, int
> mask)
>   */
>  static int smack_file_alloc_security(struct file *file)
>  {
> -	file->f_security = current->security;
> +	file->f_security = current->act_as->security;
>  	return 0;
>  }
>  
> @@ -875,7 +876,7 @@ static int smack_file_fcntl(struct file *file, unsigned
> int cmd,
>   */
>  static int smack_file_set_fowner(struct file *file)
>  {
> -	file->f_security = current->security;
> +	file->f_security = current->act_as->security;
>  	return 0;
>  }
>  
> @@ -900,7 +901,7 @@ static int smack_file_send_sigiotask(struct task_struct
> *tsk,
>  	 * struct fown_struct is never outside the context of a struct file
>  	 */
>  	file = container_of(fown, struct file, f_owner);
> -	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
> +	rc = smk_access(file->f_security, tsk->sec->security, MAY_WRITE);
>  	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
>  		return 0;
>  	return rc;
> @@ -943,7 +944,7 @@ static int smack_file_receive(struct file *file)
>   */
>  static int smack_task_alloc_security(struct task_struct *tsk)
>  {
> -	tsk->security = current->security;
> +	tsk->sec->security = current->act_as->security;
>  
>  	return 0;
>  }
> @@ -958,7 +959,7 @@ static int smack_task_alloc_security(struct task_struct
> *tsk)
>   */
>  static void smack_task_free_security(struct task_struct *task)
>  {
> -	task->security = NULL;
> +	task->sec->security = NULL;
>  }
>  
>  /**
> @@ -970,7 +971,7 @@ static void smack_task_free_security(struct task_struct
> *task)
>   */
>  static int smack_task_setpgid(struct task_struct *p, pid_t pgid)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	return smk_curacc(p->sec->security, MAY_WRITE);
>  }
>  
>  /**
> @@ -981,7 +982,7 @@ static int smack_task_setpgid(struct task_struct *p,
> pid_t pgid)
>   */
>  static int smack_task_getpgid(struct task_struct *p)
>  {
> -	return smk_curacc(p->security, MAY_READ);
> +	return smk_curacc(p->sec->security, MAY_READ);
>  }
>  
>  /**
> @@ -992,7 +993,7 @@ static int smack_task_getpgid(struct task_struct *p)
>   */
>  static int smack_task_getsid(struct task_struct *p)
>  {
> -	return smk_curacc(p->security, MAY_READ);
> +	return smk_curacc(p->sec->security, MAY_READ);
>  }
>  
>  /**
> @@ -1004,7 +1005,7 @@ static int smack_task_getsid(struct task_struct *p)
>   */
>  static void smack_task_getsecid(struct task_struct *p, u32 *secid)
>  {
> -	*secid = smack_to_secid(p->security);
> +	*secid = smack_to_secid(p->sec->security);
>  }
>  
>  /**
> @@ -1016,7 +1017,7 @@ static void smack_task_getsecid(struct task_struct *p,
> u32 *secid)
>   */
>  static int smack_task_setnice(struct task_struct *p, int nice)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	return smk_curacc(p->sec->security, MAY_WRITE);
>  }
>  
>  /**
> @@ -1028,7 +1029,7 @@ static int smack_task_setnice(struct task_struct *p,
> int nice)
>   */
>  static int smack_task_setioprio(struct task_struct *p, int ioprio)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	return smk_curacc(p->sec->security, MAY_WRITE);
>  }
>  
>  /**
> @@ -1039,7 +1040,7 @@ static int smack_task_setioprio(struct task_struct *p,
> int ioprio)
>   */
>  static int smack_task_getioprio(struct task_struct *p)
>  {
> -	return smk_curacc(p->security, MAY_READ);
> +	return smk_curacc(p->sec->security, MAY_READ);
>  }
>  
>  /**
> @@ -1053,7 +1054,7 @@ static int smack_task_getioprio(struct task_struct *p)
>  static int smack_task_setscheduler(struct task_struct *p, int policy,
>  				   struct sched_param *lp)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	return smk_curacc(p->sec->security, MAY_WRITE);
>  }
>  
>  /**
> @@ -1064,7 +1065,7 @@ static int smack_task_setscheduler(struct task_struct
> *p, int policy,
>   */
>  static int smack_task_getscheduler(struct task_struct *p)
>  {
> -	return smk_curacc(p->security, MAY_READ);
> +	return smk_curacc(p->sec->security, MAY_READ);
>  }
>  
>  /**
> @@ -1075,7 +1076,7 @@ static int smack_task_getscheduler(struct task_struct
> *p)
>   */
>  static int smack_task_movememory(struct task_struct *p)
>  {
> -	return smk_curacc(p->security, MAY_WRITE);
> +	return smk_curacc(p->act_as->security, MAY_WRITE);
>  }
>  
>  /**
> @@ -1107,13 +1108,13 @@ static int smack_task_kill(struct task_struct *p,
> struct siginfo *info,
>  	 * can write the receiver.
>  	 */
>  	if (secid == 0)
> -		return smk_curacc(p->security, MAY_WRITE);
> +		return smk_curacc(p->sec->security, MAY_WRITE);
>  	/*
>  	 * If the secid isn't 0 we're dealing with some USB IO
>  	 * specific behavior. This is not clean. For one thing
>  	 * we can't take privilege into account.
>  	 */
> -	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
> +	return smk_access(smack_from_secid(secid), p->sec->security, MAY_WRITE);
>  }
>  
>  /**
> @@ -1126,7 +1127,7 @@ static int smack_task_wait(struct task_struct *p)
>  {
>  	int rc;
>  
> -	rc = smk_access(current->security, p->security, MAY_WRITE);
> +	rc = smk_access(current->act_as->security, p->sec->security, MAY_WRITE);
>  	if (rc == 0)
>  		return 0;
>  
> @@ -1157,7 +1158,7 @@ static int smack_task_wait(struct task_struct *p)
>  static void smack_task_to_inode(struct task_struct *p, struct inode *inode)
>  {
>  	struct inode_smack *isp = inode->i_security;
> -	isp->smk_inode = p->security;
> +	isp->smk_inode = p->act_as->security;
>  }
>  
>  /*
> @@ -1176,7 +1177,7 @@ static void smack_task_to_inode(struct task_struct *p,
> struct inode *inode)
>   */
>  static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t
> gfp_flags)
>  {
> -	char *csp = current->security;
> +	char *csp = current->act_as->security;
>  	struct socket_smack *ssp;
>  
>  	ssp = kzalloc(sizeof(struct socket_smack), gfp_flags);
> @@ -1401,7 +1402,7 @@ static int smack_flags_to_may(int flags)
>   */
>  static int smack_msg_msg_alloc_security(struct msg_msg *msg)
>  {
> -	msg->security = current->security;
> +	msg->security = current->act_as->security;
>  	return 0;
>  }
>  
> @@ -1437,7 +1438,7 @@ static int smack_shm_alloc_security(struct shmid_kernel
> *shp)
>  {
>  	struct kern_ipc_perm *isp = &shp->shm_perm;
>  
> -	isp->security = current->security;
> +	isp->security = current->act_as->security;
>  	return 0;
>  }
>  
> @@ -1545,7 +1546,7 @@ static int smack_sem_alloc_security(struct sem_array
> *sma)
>  {
>  	struct kern_ipc_perm *isp = &sma->sem_perm;
>  
> -	isp->security = current->security;
> +	isp->security = current->act_as->security;
>  	return 0;
>  }
>  
> @@ -1648,7 +1649,7 @@ static int smack_msg_queue_alloc_security(struct
> msg_queue *msq)
>  {
>  	struct kern_ipc_perm *kisp = &msq->q_perm;
>  
> -	kisp->security = current->security;
> +	kisp->security = current->act_as->security;
>  	return 0;
>  }
>  
> @@ -1790,7 +1791,7 @@ static void smack_d_instantiate(struct dentry
> *opt_dentry, struct inode *inode)
>  	struct super_block *sbp;
>  	struct superblock_smack *sbsp;
>  	struct inode_smack *isp;
> -	char *csp = current->security;
> +	char *csp = current->act_as->security;
>  	char *fetched;
>  	char *final;
>  	struct dentry *dp;
> @@ -1935,7 +1936,7 @@ static int smack_getprocattr(struct task_struct *p,
> char *name, char **value)
>  	if (strcmp(name, "current") != 0)
>  		return -EINVAL;
>  
> -	cp = kstrdup(p->security, GFP_KERNEL);
> +	cp = kstrdup(p->sec->security, GFP_KERNEL);
>  	if (cp == NULL)
>  		return -ENOMEM;
>  
> @@ -1981,7 +1982,7 @@ static int smack_setprocattr(struct task_struct *p,
> char *name,
>  	if (newsmack == NULL)
>  		return -EINVAL;
>  
> -	p->security = newsmack;
> +	p->sec->security = newsmack;
>  	return size;
>  }
>  
> @@ -2211,8 +2212,8 @@ static void smack_sock_graft(struct sock *sk, struct
> socket *parent)
>  		return;
>  
>  	ssp = sk->sk_security;
> -	ssp->smk_in = current->security;
> -	ssp->smk_out = current->security;
> +	ssp->smk_in = current->act_as->security;
> +	ssp->smk_out = current->act_as->security;
>  	ssp->smk_packet[0] = '\0';
>  
>  	rc = smack_netlabel(sk);
> @@ -2285,7 +2286,7 @@ static int smack_inet_conn_request(struct sock *sk,
> struct sk_buff *skb,
>  static int smack_key_alloc(struct key *key, struct task_struct *tsk,
>  			   unsigned long flags)
>  {
> -	key->security = tsk->security;
> +	key->security = tsk->act_as->security;
>  	return 0;
>  }
>  
> @@ -2326,10 +2327,11 @@ static int smack_key_permission(key_ref_t key_ref,
>  	/*
>  	 * This should not occur
>  	 */
> -	if (context->security == NULL)
> +	if (context->act_as->security == NULL)
>  		return -EACCES;
>  
> -	return smk_access(context->security, keyp->security, MAY_READWRITE);
> +	return smk_access(context->act_as->security, keyp->security,
> +			  MAY_READWRITE);
>  }
>  #endif /* CONFIG_KEYS */
>  
> @@ -2510,7 +2512,7 @@ static __init int smack_init(void)
>  	/*
>  	 * Set the security state for the initial task.
>  	 */
> -	current->security = &smack_known_floor.smk_known;
> +	current->sec->security = &smack_known_floor.smk_known;
>  
>  	/*
>  	 * Initialize locks
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index 358c92c..2cb3a5e 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -345,7 +345,7 @@ void smk_cipso_doi(void)
>  	struct netlbl_audit audit_info;
>  
>  	audit_info.loginuid = audit_get_loginuid(current);
> -	audit_info.secid = smack_to_secid(current->security);
> +	audit_info.secid = smack_to_secid(current->sec->security);
>  
>  	rc = netlbl_cfg_map_del(NULL, &audit_info);
>  	if (rc != 0)
> @@ -377,7 +377,7 @@ void smk_unlbl_ambient(char *oldambient)
>  	struct netlbl_audit audit_info;
>  
>  	audit_info.loginuid = audit_get_loginuid(current);
> -	audit_info.secid = smack_to_secid(current->security);
> +	audit_info.secid = smack_to_secid(current->sec->security);
>  
>  	if (oldambient != NULL) {
>  		rc = netlbl_cfg_map_del(oldambient, &audit_info);


The Smack portions look fine.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
