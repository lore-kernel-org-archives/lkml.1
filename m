Return-Path: <linux-kernel-owner+w=401wt.eu-S932617AbYBVE5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617AbYBVE5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbYBVE5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:57:21 -0500
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:29580 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753654AbYBVE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:57:19 -0500
X-YMail-OSG: 2SE5M30VM1mEO6WzAVPg6UR.k7Udml448esGxg2tC4QlA4L07DCeVFRAzptf41_SIvVBKEQNzw--
X-RocketYMMF: rancidfat
Date: Thu, 21 Feb 2008 20:57:18 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 07/37] Security: De-embed task security record from task and use refcounting
To: David Howells <dhowells@redhat.com>, Trond.Myklebust@netapp.com,
       chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <20080220160635.4715.81967.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <847728.57737.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Remove the temporarily embedded task security record from task_struct. 
> Instead
> it is made to dangle from the task_struct::sec and task_struct::act_as
> pointers
> with references counted for each.
> 
> ...
> 
> The LSM hooks for dealing with task security are modified to deal with the
> task
> security struct directly rather than going via the task_struct as appopriate.
> 
> ...

> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index a49d94f..dbce607 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -957,9 +957,22 @@ static int smack_task_alloc_security(struct task_struct
> *tsk)
>   * points to an immutable list. The blobs never go away.
>   * There is no leak here.
>   */
> -static void smack_task_free_security(struct task_struct *task)
> +static void smack_task_free_security(struct task_security *sec)
>  {
> -	task->sec->security = NULL;
> +	sec->security = NULL;
> +}
> +
> +/**
> + * task_dup_security - Duplicate task security
> + * @p points to the task_security struct that has been copied
> + *
> + * Duplicate the security structure currently attached to the p->security
> field
> + * and attach back to p->security (the pointer itself was copied, so there's
> + * nothing to be done here).
> + */
> +static int smack_task_dup_security(struct task_security *sec)
> +{
> +	return 0;
>  }

Thank you for adding this hook. The comment is helpful.
  
>  /**
> @@ -2276,17 +2289,17 @@ static int smack_inet_conn_request(struct sock *sk,
> struct sk_buff *skb,
>  /**
>   * smack_key_alloc - Set the key security blob
>   * @key: object
> - * @tsk: the task associated with the key
> + * @context: the task security associated with the key
>   * @flags: unused
>   *
>   * No allocation required
>   *
>   * Returns 0
>   */
> -static int smack_key_alloc(struct key *key, struct task_struct *tsk,
> +static int smack_key_alloc(struct key *key, struct task_security *context,
>  			   unsigned long flags)
>  {
> -	key->security = tsk->act_as->security;
> +	key->security = context->security;
>  	return 0;
>  }
>  
> @@ -2304,14 +2317,14 @@ static void smack_key_free(struct key *key)
>  /*
>   * smack_key_permission - Smack access on a key
>   * @key_ref: gets to the object
> - * @context: task involved
> + * @context: task security involved
>   * @perm: unused
>   *
>   * Return 0 if the task has read and write to the object,
>   * an error code otherwise
>   */
>  static int smack_key_permission(key_ref_t key_ref,
> -				struct task_struct *context, key_perm_t perm)
> +				struct task_security *context, key_perm_t perm)
>  {
>  	struct key *keyp;
>  
> @@ -2327,10 +2340,10 @@ static int smack_key_permission(key_ref_t key_ref,
>  	/*
>  	 * This should not occur
>  	 */
> -	if (context->act_as->security == NULL)
> +	if (context->security == NULL)
>  		return -EACCES;
>  
> -	return smk_access(context->act_as->security, keyp->security,
> +	return smk_access(context->security, keyp->security,
>  			  MAY_READWRITE);
>  }
>  #endif /* CONFIG_KEYS */
> @@ -2430,6 +2443,7 @@ static struct security_operations smack_ops = {
>  
>  	.task_alloc_security = 		smack_task_alloc_security,
>  	.task_free_security = 		smack_task_free_security,
> +	.task_dup_security =		smack_task_dup_security,
>  	.task_post_setuid =		cap_task_post_setuid,
>  	.task_setpgid = 		smack_task_setpgid,
>  	.task_getpgid = 		smack_task_getpgid,

No objections from the Smack side. Thank you.


Casey Schaufler
casey@schaufler-ca.com
