Return-Path: <linux-kernel-owner+w=401wt.eu-S1763450AbXKTWGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763450AbXKTWGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 17:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXKTWGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 17:06:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49184 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441AbXKTWGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 17:06:07 -0500
Date: Tue, 20 Nov 2007 14:06:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: casey@schaufler-ca.com
Cc: torvalds@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] (2.6.24-rc3 -mm only) Smack Version 11c Simplified
 Mandatory Access Control Kernel
Message-Id: <20071120140603.868fd3df.akpm@linux-foundation.org>
In-Reply-To: <4742769D.60105@schaufler-ca.com>
References: <4742769D.60105@schaufler-ca.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 21:54:37 -0800
Casey Schaufler <casey@schaufler-ca.com> wrote:

> From: Casey Schaufler <casey@schaufler-ca.com>
> 
> Smack is the Simplified Mandatory Access Control Kernel.
> 

This patch seems bigger than the first version ;)

random-trivial-comments-just-to-show-i-read-it:

> +static int smack_inode_setsecurity(struct inode *inode, const char *name,
> +				   const void *value, size_t size, int flags)
> +{
> +	char *sp;
> +	struct inode_smack *nsp = (struct inode_smack *)inode->i_security;

Please avoid casting when assigning to and from void* - it's unneeded and
defeats typechecking - if someone goes and turns inode.i_security into a
float or a struct capiloaddatapart* then we do want this code to warn about
it.

> +	struct socket_smack *ssp;
> +	struct socket *sock;
> +
> +	if (value == NULL || size > SMK_LABELLEN)
> +		return -EACCES;
> +
> +	sp = smk_import(value, size);
> +	if (sp == NULL)
> +		return -EINVAL;
> +
> +	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
> +		mutex_lock(&nsp->smk_lock);
> +		nsp->smk_inode = sp;
> +		mutex_unlock(&nsp->smk_lock);

Does this locking actually do anything?  The only place where it makes
sense is if there is some code elsewhere which reads nsp->smk_inode twice,
both instances under the same taking of ->smk_lock, and in which it expects
both reads to return the same value.

IOW: it's fishy.

> +		return 0;
> +	}
> +	/*
> +	 * The rest of the Smack xattrs are only on sockets.
> +	 */
> +	if (inode->i_sb->s_magic != SOCKFS_MAGIC)
> +		return -EOPNOTSUPP;
> +
> +	sock = SOCKET_I(inode);
> +	if (sock == NULL)
> +		return -EOPNOTSUPP;
> +
> +	ssp = sock->sk->sk_security;
> +
> +	if (strcmp(name, XATTR_SMACK_IPIN) == 0)
> +		ssp->smk_in = sp;
> +	else if (strcmp(name, XATTR_SMACK_IPOUT) == 0)
> +		ssp->smk_out = sp;
> +	else
> +		return -EOPNOTSUPP;
> +	return 0;
> +}
> +
>
> ...
>
> +
> +/**
> + * smack_file_set_fowner - set the file security blob value
> + * @file: object in question
> + *
> + * Returns 0
> + * Further research may be required on this one.
> + */
> +static int smack_file_set_fowner(struct file *file)
> +{
> +	file->f_security = current->security;
> +	return 0;
> +}

hm.  I'd have expected to see some refcounting when a ref to an object is
copied like this.

> +/**
> + * smack_file_send_sigiotask - Smack on sigio
> + * @tsk: The target task
> + * @fown: the object the signal come from
> + * @signum: unused
> + *
> + * Allow a privileged task to get signals even if it shouldn't
> + *
> + * Returns 0 if a subject with the object's smack could
> + * write to the task, an error code otherwise.
> + */
> +static int smack_file_send_sigiotask(struct task_struct *tsk,
> +				     struct fown_struct *fown, int signum)
> +{
> +	struct file *file;
> +	int rc;
> +
> +	/*
> +	 * struct fown_struct is never outside the context of a struct file
> +	 */
> +	file = (struct file *)((long)fown - offsetof(struct file, f_owner));

Will container_of() work here?

> +	rc = smk_access(file->f_security, tsk->security, MAY_WRITE);
> +	if (rc != 0 && __capable(tsk, CAP_MAC_OVERRIDE))
> +		return 0;
> +	return rc;
> +}
> +
> +/**
> + * smack_file_receive - Smack file receive check
> + * @file: the object
> + *
> + * Returns 0 if current has access, error code otherwise
> + */
> +static int smack_file_receive(struct file *file)
> +{
> +	int may = 0;
> +
> +	/*
> +	 * This code relies on bitmasks.
> +	 */
> +	if (file->f_mode & FMODE_READ)
> +		may = MAY_READ;
> +	if (file->f_mode & FMODE_WRITE)
> +		may |= MAY_WRITE;
> +
> +	return smk_curacc(file->f_security, may);
> +}
> +
> +/*
> + * Task hooks
> + */
> +
> +/**
> + * smack_task_alloc_security - "allocate" a task blob
> + * @tsk: the task in need of a blob
> + *
> + * Smack isn't using copies of blobs. Everyone
> + * points to an immutible list. No alloc required.
> + * No data copy required.

I guess that answers my refcounting question above.

Spello: "immutable".

> + * Always returns 0
> + */
> +static int smack_task_alloc_security(struct task_struct *tsk)
> +{
> +	tsk->security = current->security;
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_task_free_security - "free" a task blob
> + * @task: the task with the blob
> + *
> + * Smack isn't using copies of blobs. Everyone
> + * points to an immutible list. The blobs never go away.
> + * There is no leak here.

Thoroughly answered.

Ditto on the spello tho.

> + */
> +static void smack_task_free_security(struct task_struct *task)
> +{
> +	task->security = NULL;
> +}
> +
>
> ...
>
> +static int smack_task_kill(struct task_struct *p, struct siginfo *info,
> +			   int sig, u32 secid)
> +{
> +	/*
> +	 * Special cases where signals really ought to go through
> +	 * in spite of policy. Stephen Smalley suggests it may
> +	 * make sense to change the caller so that it doesn't
> +	 * bother with the LSM hook in these cases.
> +	 */
> +	if (info != SEND_SIG_NOINFO &&
> +	    (is_si_special(info) || SI_FROMKERNEL(info)))
> +		return 0;
> +	/*
> +	 * Sending a signal requires that the sender
> +	 * can write the receiver.
> +	 */
> +	if (secid == 0)
> +		return smk_curacc(p->security, MAY_WRITE);
> +	/*
> +	 * If the secid isn't 0 we're dealing with some USB IO
> +	 * specific behavior. This is not clean. For one thing
> +	 * we can't take privilege into account.
> +	 */
> +	return smk_access(smack_from_secid(secid), p->security, MAY_WRITE);
> +}

remind me again why some things are smk_foo and others are smack_foo? 
Internal versus external?  Is the code consistent in this?

> +/**
> + * smack_sk_alloc_security - Allocate a socket blob
> + * @sk: the socket
> + * @family: unused
> + * @priority: memory allocation priority

"gfp_flags" or "gfp_mask" would reduce surprise.

> + *
> + * Assign Smack pointers to current
> + *
> + * Returns 0 on success, -ENOMEM is there's no memory
> + */
> +static int smack_sk_alloc_security(struct sock *sk, int family, gfp_t priority)
> +{
> +	char *csp = current->security;
> +	struct socket_smack *ssp;
> +
> +	ssp = kzalloc(sizeof(struct socket_smack), priority);
> +	if (ssp == NULL)
> +		return -ENOMEM;
> +
> +	ssp->smk_in = csp;
> +	ssp->smk_out = csp;
> +
> +	sk->sk_security = ssp;
> +
> +	return 0;
> +}
> +
> +/**
> + * smack_sk_free_security - Free a socket blob
> + * @sk: the socket
> + *
> + * Clears the blob pointer
> + */
> +static void smack_sk_free_security(struct sock *sk)
> +{
> +	kfree(sk->sk_security);
> +	sk->sk_security = NULL;
> +}

Hopefully that assignment of NULL isn't needed.

> +
> +DEFINE_MUTEX(smack_list_lock);
> +DEFINE_MUTEX(smack_known_lock);
> +DEFINE_MUTEX(smack_cipso_lock);
> +
> +/**
> + * smack_init - initialize the smack system
> + *
> + * Returns 0
> + */
> +static __init int smack_init(void)
> +{
> +	printk(KERN_INFO "Smack:  Initializing.\n");
> +
> +	/*
> +	 * Set the security state for the initial task.
> +	 */
> +	current->security = &smack_known_floor.smk_known;
> +
> +	/*
> +	 * Initialize locks
> +	 */
> +	spin_lock_init(&smack_known_unset.smk_cipsolock);
> +	spin_lock_init(&smack_known_huh.smk_cipsolock);
> +	spin_lock_init(&smack_known_hat.smk_cipsolock);
> +	spin_lock_init(&smack_known_star.smk_cipsolock);
> +	spin_lock_init(&smack_known_floor.smk_cipsolock);
> +	spin_lock_init(&smack_known_invalid.smk_cipsolock);
> +
> +	mutex_init(&smack_known_lock);
> +	mutex_init(&smack_list_lock);
> +	mutex_init(&smack_cipso_lock);

The mutex_init()s aren't needed.

It might be feasible to replace the spin_lock_init()s with compile-time
initialisation too.

> +	/*
> +	 * Register with LSM
> +	 */
> +	if (register_security(&smack_ops))
> +		panic("smack: Unable to register with kernel.\n");
> +
> +	return 0;
> +}
> +
> +/*
> + * Smack requires early initialization in order to label
> + * all processes and objects when they are created.
> + */
> +security_initcall(smack_init);

