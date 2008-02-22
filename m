Return-Path: <linux-kernel-owner+w=401wt.eu-S1753597AbYBVFGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbYBVFGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbYBVFGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:06:14 -0500
Received: from web36602.mail.mud.yahoo.com ([209.191.85.19]:33905 "HELO
	web36602.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750782AbYBVFGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:06:12 -0500
X-YMail-OSG: nVBga_MVM1lqw5I9RxV5Dm9J_UFq5NRR8CLdAfJO4Ifj0E.ImZAWlf4qb3moMXMJL9ygauhvvQ--
X-RocketYMMF: rancidfat
Date: Thu, 21 Feb 2008 21:06:12 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 09/37] Security: Allow kernel services to override LSM settings for task actions
To: David Howells <dhowells@redhat.com>, Trond.Myklebust@netapp.com,
       chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <20080220160646.4715.7268.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <55722.57422.qm@web36602.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- David Howells <dhowells@redhat.com> wrote:

> Allow kernel services to override LSM settings appropriate to the actions
> performed by a task by duplicating a security record, modifying it and then
> using task_struct::act_as to point to it when performing operations on behalf
> of a task.
> 
> This is used, for example, by CacheFiles which has to transparently access
> the
> cache on behalf of a process that thinks it is doing, say, NFS accesses with
> a
> potentially inappropriate (with respect to accessing the cache) set of
> security data.
> 
> This patch provides two LSM hooks for modifying a task security record:
> 
>  (*) security_kernel_act_as() which allows modification of the security datum
>      with which a task acts on other objects (most notably files).
> 
>  (*) security_create_files_as() which allows modification of the security
>      datum that is used to initialise the security data on a file that a task
>      creates.
> 
> ...

> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -976,6 +976,36 @@ static int smack_task_dup_security(struct task_security
> *sec)
>  }
>  
>  /**
> + * smack_task_kernel_act_as - Set the subjective context in a security
> record
> + * @p points to the task that nominated @secid.
> + * @sec points to the task security record to be modified.
> + * @secid specifies the security ID to be set
> + *
> + * Set the security data for a kernel service.
> + */
> +static int smack_task_kernel_act_as(struct task_struct *p,
> +				    struct task_security *sec, u32 secid)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +/**
> + * smack_task_create_files_as - Set the file creation label in a security
> record
> + * @p points to the task that nominated @inode.
> + * @sec points to the task security record to be modified.
> + * @inode points to the inode to use as a reference.
> + *
> + * Set the file creation context in a security record to the same as the
> + * objective context of the specified inode
> + */
> +static int smack_task_create_files_as(struct task_struct *p,
> +				      struct task_security *sec,
> +				      struct inode *inode)
> +{
> +	return -ENOTSUPP;
> +}

Hum. ENOTSUPP is not not very satisfying, is it? I will have to
think on this a bit.

> +
> +/**
>   * smack_task_setpgid - Smack check on setting pgid
>   * @p: the task object
>   * @pgid: unused
> @@ -2444,6 +2474,8 @@ static struct security_operations smack_ops = {
>  	.task_alloc_security = 		smack_task_alloc_security,
>  	.task_free_security = 		smack_task_free_security,
>  	.task_dup_security =		smack_task_dup_security,
> +	.task_kernel_act_as =		smack_task_kernel_act_as,
> +	.task_create_files_as =		smack_task_create_files_as,
>  	.task_post_setuid =		cap_task_post_setuid,
>  	.task_setpgid = 		smack_task_setpgid,
>  	.task_getpgid = 		smack_task_getpgid,

Except for the fact that the hooks don't do anything this
looks fine. I'm not sure that I would want these hooks to
do anything, it requires additional thought to determine if
there is a good behavior for them.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
