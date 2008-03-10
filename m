Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYCJQH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYCJQH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYCJQHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:07:15 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:41548 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750913AbYCJQHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:07:13 -0400
X-YMail-OSG: z9RGl1wVM1mlcaBr2Wmm7p_w5IkDHw.LOhFy6oQSnRNS6bZHKUKyY3oyWeiE1KhNgxVs6XFuhqtwzODo27GFldSzKZRSvDFYnB6AYCSFo_ABdvjSi7SUzIAJPbsi3U7DjNKc1b6SEOl6SmosXSMncg--
X-RocketYMMF: rancidfat
Date: Mon, 10 Mar 2008 09:07:08 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC][PATCH] Smack<->Audit integration
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>
Cc: Paul Moore <paul.moore@hp.com>, LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>,
       Audit-ML <linux-audit@redhat.com>
In-Reply-To: <20080310124928.GA30534@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <135060.71118.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi all,
> 
> This is the second step of integrating Audit with Smack. 
> 
> The AUDIT_SUBJ_USER and AUDIT_OBJ_USER SELinux flags are recycled
> for Smack to avoid `auditd' userspace modifications. Smack only
> needs auditing on subject/object bases, so those flags were enough.
> 
> Patch below setups the new Audit LSM hooks and add a secid field in 
> smack inode and ipc security structures. The secid field was needed
> cause it's the main Audit way of distinguishing kernel objects to
> be audited from the remaining ones.
> 
> Possibly the last steps would be to:
> 1- report smack access grants and denials through Audit (like AVC)
> 2- Letting Audit send an OBJ_USER event in case of a process that 
>    recieved a signal without affecting SELinux.
> 
> Thank you for your reviews.
> 
> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> ---
> 
>  smack.h     |    9 ++
>  smack_lsm.c |  211
> +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
> 
>  2 files changed, 200 insertions(+), 17 deletions(-)
> 
> Patch is generated over James security/next branch cause it's the 
> only tree that currently has the Audit hooks merged:
>
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6.git#next
> 
> diff --git a/security/smack/smack.h b/security/smack/smack.h
> index c444f48..2c8bb4c 100644
> --- a/security/smack/smack.h
> +++ b/security/smack/smack.h
> @@ -57,6 +57,15 @@ struct inode_smack {
>  	char		*smk_inode;	/* label of the fso */
>  	struct mutex	smk_lock;	/* initialization lock */
>  	int		smk_flags;	/* smack inode flags */
> +	int		secid;		/* security identifier */

No.

Secid's are horrid things and every effort should be made to
expunge them from the known universe. Under no circumstances
should thier use be expanded. The only reason Smack has them
at all is because certain interfaces that in my mind should
have known better use them. If you must deal with secids,
and for this round of audit I think that's a given, use
smack_to_secid(sp->smk_inode) where you need to. If there's a
real performance issue apply intelligence to smack_to_secid
instead of storing the secid. There ought to be a way to
use container_of to do smack_to_secid, but I had trouble with
that and moved along without figuring out what I had done
wrong.

> +};
> +
> +/*
> + * IPC smack data
> + */
> +struct ipc_smack {
> +	char		*smk_ipc;	/* ipc object label */
> +	int		secid;		/* security identifier */

As above.

>  };
>  
>  #define	SMK_INODE_INSTANT	0x01	/* inode is instantiated */
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index afa7967..5b5e1fd 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -6,6 +6,9 @@
>   *  Author:
>   *	Casey Schaufler <casey@schaufler-ca.com>
>   *
> + *  Audit integration by:
> + *	Ahmed S. Darwish <darwish.07@gmail.com>
> + *
>   *  Copyright (C) 2007 Casey Schaufler <casey@schaufler-ca.com>
>   *
>   *	This program is free software; you can redistribute it and/or modify
> @@ -24,6 +27,7 @@
>  #include <linux/udp.h>
>  #include <linux/mutex.h>
>  #include <linux/pipe_fs_i.h>
> +#include <linux/audit.h>
>  #include <net/netlabel.h>
>  #include <net/cipso_ipv4.h>
>  
> @@ -75,6 +79,7 @@ struct inode_smack *new_inode_smack(char *smack)
>  
>  	isp->smk_inode = smack;
>  	isp->smk_flags = 0;
> +	isp->secid = smack_to_secid(smack);

As above

>  	mutex_init(&isp->smk_lock);
>  
>  	return isp;
> @@ -638,6 +643,8 @@ static void smack_inode_post_setxattr(struct dentry
> *dentry, char *name,
>  	else
>  		isp->smk_inode = smack_known_invalid.smk_known;
>  
> +	isp->secid = smack_to_secid(isp->smk_inode);

As above

> +
>  	return;
>  }
>  
> @@ -759,6 +766,17 @@ static int smack_inode_listsecurity(struct inode *inode,
> char *buffer,
>  	return -EINVAL;
>  }
>  
> +/**
> + * smack_inode_getsecid - Extract inode's security id
> + * @inode: inode to extract the info from
> + * @secid: where the result will be saved
> + */
> +static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
> +{
> +	struct inode_smack *isp = inode->i_security;
> +	*secid = isp->secid;

        *secid = smack_to_secid(isp->smk_inode);

> +}
> +
>  /*
>   * File Hooks
>   */
> @@ -1344,6 +1362,7 @@ static int smack_inode_setsecurity(struct inode *inode,
> const char *name,
>  				   const void *value, size_t size, int flags)
>  {
>  	char *sp;
> +	struct smack_known *skp;
>  	struct inode_smack *nsp = inode->i_security;
>  	struct socket_smack *ssp;
>  	struct socket *sock;
> @@ -1352,12 +1371,14 @@ static int smack_inode_setsecurity(struct inode
> *inode, const char *name,
>  	if (value == NULL || size > SMK_LABELLEN)
>  		return -EACCES;
>  
> -	sp = smk_import(value, size);
> -	if (sp == NULL)
> +	skp = smk_import_entry(value, size);
> +	if (skp == NULL)
>  		return -EINVAL;
>  
> +	sp = skp->smk_known;
>  	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
>  		nsp->smk_inode = sp;
> +		nsp->secid = skp->smk_secid;
>  		return 0;
>  	}

No need to change this hook with no smk_secid.

>  	/*
> @@ -1471,9 +1492,16 @@ static char *smack_of_shm(struct shmid_kernel *shp)
>   */
>  static int smack_shm_alloc_security(struct shmid_kernel *shp)
>  {
> -	struct kern_ipc_perm *isp = &shp->shm_perm;
> +	struct ipc_smack *isp;
> +	struct kern_ipc_perm *ipcp = &shp->shm_perm;
>  
> -	isp->security = current->security;
> +	isp = kzalloc(sizeof(struct ipc_smack), GFP_KERNEL);
> +	if (isp == NULL)
> +		return -ENOMEM;
> +
> +	isp->smk_ipc = current->security;
> +	isp->secid = smack_to_secid(isp->smk_ipc);
> +	ipcp->security = isp;
>  	return 0;
>  }

Same here.

> @@ -1485,9 +1513,9 @@ static int smack_shm_alloc_security(struct shmid_kernel
> *shp)
>   */
>  static void smack_shm_free_security(struct shmid_kernel *shp)
>  {
> -	struct kern_ipc_perm *isp = &shp->shm_perm;
> +	struct kern_ipc_perm *ipcp = &shp->shm_perm;
>  
> -	isp->security = NULL;
> +	kfree(ipcp->security);
>  }

Same here, and all the more reason to leave the data as is.

>  /**
> @@ -1579,9 +1607,16 @@ static char *smack_of_sem(struct sem_array *sma)
>   */
>  static int smack_sem_alloc_security(struct sem_array *sma)
>  {
> -	struct kern_ipc_perm *isp = &sma->sem_perm;
> +	struct ipc_smack *isp;
> +	struct kern_ipc_perm *ipcp = &sma->sem_perm;
> +
> +	isp = kzalloc(sizeof(struct ipc_smack), GFP_KERNEL);
> +	if (isp == NULL)
> +		return -ENOMEM;
>  
> -	isp->security = current->security;
> +	isp->smk_ipc = current->security;
> +	isp->secid = smack_to_secid(isp->smk_ipc);
> +	ipcp->security = isp;
>  	return 0;
>  }

'nuff said?

> @@ -1595,7 +1630,7 @@ static void smack_sem_free_security(struct sem_array
> *sma)
>  {
>  	struct kern_ipc_perm *isp = &sma->sem_perm;
>  
> -	isp->security = NULL;
> +	kfree(isp->security);
>  }

And again.

>  /**
> @@ -1682,9 +1717,16 @@ static int smack_sem_semop(struct sem_array *sma,
> struct sembuf *sops,
>   */
>  static int smack_msg_queue_alloc_security(struct msg_queue *msq)
>  {
> -	struct kern_ipc_perm *kisp = &msq->q_perm;
> +	struct ipc_smack *isp;
> +	struct kern_ipc_perm *ipcp = &msq->q_perm;
>  
> -	kisp->security = current->security;
> +	isp = kzalloc(sizeof(struct ipc_smack), GFP_KERNEL);
> +	if (isp == NULL)
> +		return -ENOMEM;
> +
> +	isp->smk_ipc = current->security;
> +	isp->secid = smack_to_secid(isp->smk_ipc);
> +	ipcp->security = isp;
>  	return 0;
>  }

And again
  
> @@ -1696,9 +1738,9 @@ static int smack_msg_queue_alloc_security(struct
> msg_queue *msq)
>   */
>  static void smack_msg_queue_free_security(struct msg_queue *msq)
>  {
> -	struct kern_ipc_perm *kisp = &msq->q_perm;
> +	struct kern_ipc_perm *ipcp = &msq->q_perm;
>  
> -	kisp->security = NULL;
> +	kfree(ipcp->security);
>  }

Don't you just hate repetative reviewers?
  
>  /**
> @@ -1800,18 +1842,30 @@ static int smack_msg_queue_msgrcv(struct msg_queue
> *msq, struct msg_msg *msg,
>  
>  /**
>   * smack_ipc_permission - Smack access for ipc_permission()
> - * @ipp: the object permissions
> + * @ipcp: the object permissions
>   * @flag: access requested
>   *
>   * Returns 0 if current has read and write access, error code otherwise
>   */
> -static int smack_ipc_permission(struct kern_ipc_perm *ipp, short flag)
> +static int smack_ipc_permission(struct kern_ipc_perm *ipcp, short flag)
>  {
> -	char *isp = ipp->security;
>  	int may;
> +	struct ipc_smack *isp = ipcp->security;
>  
>  	may = smack_flags_to_may(flag);
> -	return smk_curacc(isp, may);
> +	return smk_curacc(isp->smk_ipc, may);
> +}

Last time, I think ...

> +
> +/**
> + * smack_ipc_getsecid - extract Smack security id
> + * @ipcp: the object permissions
> + * @secid: where result will be saved
> + */
> +static void smack_ipc_getsecid(struct kern_ipc_perm *ipcp, u32 *secid)
> +{
> +	struct inode_smack *isp = ipcp->security;
> +
> +	*secid = isp->secid;

        *secid = smack_to_secid(ipcp->security);

>  }
>  
>  /* module stacking operations */
> @@ -1967,6 +2021,7 @@ static void smack_d_instantiate(struct dentry
> *opt_dentry, struct inode *inode)
>  	else
>  		isp->smk_inode = final;
>  
> +	isp->secid = smack_to_secid(isp->smk_inode);

Out she goes.

>  	isp->smk_flags |= SMK_INODE_INSTANT;
>  
>  unlockandout:
> @@ -2391,6 +2446,116 @@ static int smack_key_permission(key_ref_t key_ref,
>  #endif /* CONFIG_KEYS */
>  
>  /*
> + * Smack Audit hooks
> + *
> + * Audit requires an internal representation of each Smack specific
> + * rule which works as a glue between the audit hooks. Since smack_known
> + * repository entries are added but never deleted, we'll use the
> + * smack_known entry related to the given audit rule as the needed
> + * smack representation.
> + *
> + * This will also save us from searching the smack labels repository
> + * each time the audit_rule_match hook get called.
> + */
> +#ifdef CONFIG_AUDIT
> +
> +/**
> + * smack_audit_rule_init - Initialize a smack audit rule
> + * @field: Message flags given from user-space (audit.h)
> + * @op: Required operation (Only equality testing is allowed)
> + * @rulestr: Given user-space rule
> + * @vrule: Where we'll save our own audit rule representation
> + *
> + * The label to be audited (rulestr) is created if necessay
> + */
> +static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void
> **vrule)
> +{
> +	struct smack_known **smk_rule = (struct smack_known **)vrule;
> +	*smk_rule = NULL;
> +
> +	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
> +		return -EINVAL;
> +
> +	if (op != AUDIT_EQUAL && op != AUDIT_NOT_EQUAL)
> +		return -EINVAL;
> +
> +	*smk_rule = smk_import_entry(rulestr, 0);
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_audit_rule_known - Distinguish smack audit rules from others
> + * @krule: rule of interest, in internal kernel representation format
> + *
> + * This is used to filter rules related to Smack from other saved
> + * Audit rules. If it's proved that this rule belongs to us, the
> + * audit_rule_match hook will be used to check a specific kernel
> + * object against its smack audit rule.
> + */
> +static int smack_audit_rule_known(struct audit_krule *krule)
> +{
> +	struct audit_field *f;
> +	int i;
> +
> +	for (i = 0; i < krule->field_count; i++) {
> +		f = &krule->fields[i];
> +
> +		if (f->type == AUDIT_SUBJ_USER || f->type == AUDIT_OBJ_USER)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_audit_rule_match - Audit given secid identified object ?
> + * @secid: Security id to test
> + * @field: Message flags given from user-space
> + * @op: Required operation (only equality is allowed)
> + * @vrule: Smack audit rule that will be checked against the secid object
> + * @actx: audit context associated with the check (used for Audit logging)
> + *
> + * This is the core Audit hook. It's used to identify objects like 
> + * syscalls and inodes requested from user-space to be audited from 
> + * remaining kernel objects.
> + */
> +static int smack_audit_rule_match(u32 secid, u32 field, u32 op, void *vrule,
> +				  struct audit_context *actx)
> +{
> +	struct smack_known *smk_rule = vrule;

        char *smack;

> +
> +	if (!smk_rule) {
> +		audit_log(actx, GFP_KERNEL, AUDIT_SELINUX_ERR,
> +			  "Smack: missing rule\n");
> +		return -ENOENT;
> +	}
> +
> +	if (field != AUDIT_SUBJ_USER && field != AUDIT_OBJ_USER)
> +		return 0;
> +

        smack = smack_from_secid(secid);

> +	if (op == AUDIT_EQUAL)
> +		return (smk_rule->smk_secid == secid);
> +	if (op == AUDIT_NOT_EQUAL)
> +		return (smk_rule->smk_secid != secid);

 	if (op == AUDIT_EQUAL)
		return (smk_rule->smk_smack == smack);
	if (op == AUDIT_NOT_EQUAL)
		return (smk_rule->smk_smack == smack);

It would be more Smack consistant to use Smack labels than
secids here. Secids are tolerable for talking to other
components, but I do not want them used internally. Since
the Smack labels are stored in a list the pointer comparison
will hold (unless it's in the inbound networking).

> +
> +	return 0;
> +}
> +
> +/**
> + * smack_audit_rule_free - free internal audit rule representation
> + * @vrule: rule to be freed.
> + *
> + * No memory was allocated in audit_rule_init.
> + */
> +static void smack_audit_rule_free(void *vrule)
> +{
> +	/* No-op */
> +}
> +
> +#endif /* CONFIG_AUDIT */
> +
> +/*
>   * smack_secid_to_secctx - return the smack label for a secid
>   * @secid: incoming integer
>   * @secdata: destination
> @@ -2476,6 +2641,7 @@ struct security_operations smack_ops = {
>  	.inode_getsecurity = 		smack_inode_getsecurity,
>  	.inode_setsecurity = 		smack_inode_setsecurity,
>  	.inode_listsecurity = 		smack_inode_listsecurity,
> +	.inode_getsecid =		smack_inode_getsecid,
>  
>  	.file_permission = 		smack_file_permission,
>  	.file_alloc_security = 		smack_file_alloc_security,
> @@ -2506,6 +2672,7 @@ struct security_operations smack_ops = {
>  	.task_to_inode = 		smack_task_to_inode,
>  
>  	.ipc_permission = 		smack_ipc_permission,
> +	.ipc_getsecid =			smack_ipc_getsecid,
>  
>  	.msg_msg_alloc_security = 	smack_msg_msg_alloc_security,
>  	.msg_msg_free_security = 	smack_msg_msg_free_security,
> @@ -2550,12 +2717,22 @@ struct security_operations smack_ops = {
>  	.sk_free_security = 		smack_sk_free_security,
>  	.sock_graft = 			smack_sock_graft,
>  	.inet_conn_request = 		smack_inet_conn_request,
> +
>   /* key management security hooks */
>  #ifdef CONFIG_KEYS
>  	.key_alloc = 			smack_key_alloc,
>  	.key_free = 			smack_key_free,
>  	.key_permission = 		smack_key_permission,
>  #endif /* CONFIG_KEYS */
> +
> + /* Audit hooks */
> +#ifdef CONFIG_AUDIT
> +	.audit_rule_init =		smack_audit_rule_init,
> +	.audit_rule_known =		smack_audit_rule_known,
> +	.audit_rule_match =		smack_audit_rule_match,
> +	.audit_rule_free =		smack_audit_rule_free,
> +#endif /* CONFIG_AUDIT */
> +
>  	.secid_to_secctx = 		smack_secid_to_secctx,
>  	.secctx_to_secid = 		smack_secctx_to_secid,
>  	.release_secctx = 		smack_release_secctx,
> 
> Regards,
> 
> -- 
> 
> "Better to light a candle, than curse the darkness"
> 
> Ahmed S. Darwish
> Homepage: http://darwish.07.googlepages.com
> Blog: http://darwish-07.blogspot.com
> 
> 
> 


Casey Schaufler
casey@schaufler-ca.com
