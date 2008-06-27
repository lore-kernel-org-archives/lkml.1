Return-Path: <linux-kernel-owner+w=401wt.eu-S1764030AbYF0VGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764030AbYF0VGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757814AbYF0VGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:06:21 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56678 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763881AbYF0VGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:06:19 -0400
Date: Fri, 27 Jun 2008 16:06:16 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 3/4] security: filesystem capabilities refactor kernel
	code
Message-ID: <20080627210616.GC17415@us.ibm.com>
References: <48635823.2080002@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48635823.2080002@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> More optimal kernel locking for filesystem capability support.
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFIY1gi+bHCR3gb8jsRAuqYAJ0c5Vw3WVHJFcSBZoHGhAEDR1RSDQCfUSgy
> m6bfMSlHRkEIulIxqp96t3E=
> =Xs/z
> -----END PGP SIGNATURE-----

> From 73bb5a039e95b9d150c74feaf5824a1f761fb718 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Wed, 25 Jun 2008 23:30:44 -0700
> Subject: [PATCH] Refactor filesystem capability support in main kernel.
> 
> To date, we've tried hard to confine filesystem support for capabilities
> to the security modules. This has left a lot of the code in
> kernel/capability.c in a state where it looks like it supports something
> that filesystem support for capabilities actually suppresses when the
> LSM security/commmoncap.c code runs. What is left is a lot of code that
> uses sub-optimal locking in the main kernel. With this change we refactor
> the main kernel code and make it explicit which locks are needed and that
> the only remaining kernel races in this area are associated with
> non-filesystem capability code.
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

No changelog, so I assume this is essentially the same patch as I
acked+tested on Jun 23.

Acked-by: Serge Hallyn <serue@us.ibm.com>

-serge

> ---
>  kernel/capability.c |  338 +++++++++++++++++++++++++++++++++------------------
>  1 files changed, 221 insertions(+), 117 deletions(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 901e0fd..0101e84 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -115,11 +115,208 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
>  	return 0;
>  }
>  
> +#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
> +
> +/*
> + * Without filesystem capability support, we nominally support one process
> + * setting the capabilities of another
> + */
> +static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
> +				     kernel_cap_t *pIp, kernel_cap_t *pPp)
> +{
> +	struct task_struct *target;
> +	int ret;
> +
> +	spin_lock(&task_capability_lock);
> +	read_lock(&tasklist_lock);
> +
> +	if (pid && pid != task_pid_vnr(current)) {
> +		target = find_task_by_vpid(pid);
> +		if (!target) {
> +			ret = -ESRCH;
> +			goto out;
> +		}
> +	} else
> +		target = current;
> +
> +	ret = security_capget(target, pEp, pIp, pPp);
> +
> +out:
> +	read_unlock(&tasklist_lock);
> +	spin_unlock(&task_capability_lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * cap_set_pg - set capabilities for all processes in a given process
> + * group.  We call this holding task_capability_lock and tasklist_lock.
> + */
> +static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
> +			     kernel_cap_t *inheritable,
> +			     kernel_cap_t *permitted)
> +{
> +	struct task_struct *g, *target;
> +	int ret = -EPERM;
> +	int found = 0;
> +	struct pid *pgrp;
> +
> +	spin_lock(&task_capability_lock);
> +	read_lock(&tasklist_lock);
> +
> +	pgrp = find_vpid(pgrp_nr);
> +	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
> +		target = g;
> +		while_each_thread(g, target) {
> +			if (!security_capset_check(target, effective,
> +						   inheritable, permitted)) {
> +				security_capset_set(target, effective,
> +						    inheritable, permitted);
> +				ret = 0;
> +			}
> +			found = 1;
> +		}
> +	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
> +
> +	read_unlock(&tasklist_lock);
> +	spin_unlock(&task_capability_lock);
> +
> +	if (!found)
> +		ret = 0;
> +	return ret;
> +}
> +
>  /*
> - * For sys_getproccap() and sys_setproccap(), any of the three
> - * capability set pointers may be NULL -- indicating that that set is
> - * uninteresting and/or not to be changed.
> + * cap_set_all - set capabilities for all processes other than init
> + * and self.  We call this holding task_capability_lock and tasklist_lock.
>   */
> +static inline int cap_set_all(kernel_cap_t *effective,
> +			      kernel_cap_t *inheritable,
> +			      kernel_cap_t *permitted)
> +{
> +	struct task_struct *g, *target;
> +	int ret = -EPERM;
> +	int found = 0;
> +
> +	spin_lock(&task_capability_lock);
> +	read_lock(&tasklist_lock);
> +
> +	do_each_thread(g, target) {
> +		if (target == current
> +		    || is_container_init(target->group_leader))
> +			continue;
> +		found = 1;
> +		if (security_capset_check(target, effective, inheritable,
> +					  permitted))
> +			continue;
> +		ret = 0;
> +		security_capset_set(target, effective, inheritable, permitted);
> +	} while_each_thread(g, target);
> +
> +	read_unlock(&tasklist_lock);
> +	spin_unlock(&task_capability_lock);
> +
> +	if (!found)
> +		ret = 0;
> +
> +	return ret;
> +}
> +
> +/*
> + * Given the target pid does not refer to the current process we
> + * need more elaborate support... (This support is not present when
> + * filesystem capabilities are configured.)
> + */
> +static inline int do_sys_capset_other_tasks(pid_t pid, kernel_cap_t *effective,
> +					    kernel_cap_t *inheritable,
> +					    kernel_cap_t *permitted)
> +{
> +	struct task_struct *target;
> +	int ret;
> +
> +	if (!capable(CAP_SETPCAP))
> +		return -EPERM;
> +
> +	if (pid == -1)	          /* all procs other than current and init */
> +		return cap_set_all(effective, inheritable, permitted);
> +
> +	else if (pid < 0)                    /* all procs in process group */
> +		return cap_set_pg(-pid, effective, inheritable, permitted);
> +
> +	/* target != current */
> +	spin_lock(&task_capability_lock);
> +	read_lock(&tasklist_lock);
> +
> +	target = find_task_by_vpid(pid);
> +	if (!target)
> +		ret = -ESRCH;
> +	else {
> +		ret = security_capset_check(target, effective, inheritable,
> +					    permitted);
> +
> +		/* having verified that the proposed changes are legal,
> +		   we now put them into effect. */
> +		if (!ret)
> +			security_capset_set(target, effective, inheritable,
> +					    permitted);
> +	}
> +
> +	read_unlock(&tasklist_lock);
> +	spin_unlock(&task_capability_lock);
> +
> +	return ret;
> +}
> +
> +#else /* ie., def CONFIG_SECURITY_FILE_CAPABILITIES */
> +
> +/*
> + * If we have configured with filesystem capability support, then the
> + * only thing that can change the capabilities of the current process
> + * is the current process. As such, we can't be in this code at the
> + * same time as we are in the process of setting capabilities in this
> + * process. The net result is that we can limit our use of locks to
> + * when we are reading the caps of another process.
> + */
> +static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
> +				     kernel_cap_t *pIp, kernel_cap_t *pPp)
> +{
> +	int ret;
> +
> +	if (pid && (pid != task_pid_vnr(current))) {
> +		struct task_struct *target;
> +
> +		spin_lock(&task_capability_lock);
> +		read_lock(&tasklist_lock);
> +
> +		target = find_task_by_vpid(pid);
> +		if (!target)
> +			ret = -ESRCH;
> +		else
> +			ret = security_capget(target, pEp, pIp, pPp);
> +
> +		read_unlock(&tasklist_lock);
> +		spin_unlock(&task_capability_lock);
> +	} else
> +		ret = security_capget(current, pEp, pIp, pPp);
> +
> +	return ret;
> +}
> +
> +/*
> + * With filesystem capability support configured, the kernel does not
> + * permit the changing of capabilities in one process by another
> + * process. (CAP_SETPCAP has much less broad semantics when configured
> + * this way.)
> + */
> +static inline int do_sys_capset_other_tasks(pid_t pid,
> +					    kernel_cap_t *effective,
> +					    kernel_cap_t *inheritable,
> +					    kernel_cap_t *permitted)
> +{
> +	return -EPERM;
> +}
> +
> +#endif /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
>  
>  /*
>   * Atomically modify the effective capabilities returning the original
> @@ -155,7 +352,6 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
>  {
>  	int ret = 0;
>  	pid_t pid;
> -	struct task_struct *target;
>  	unsigned tocopy;
>  	kernel_cap_t pE, pI, pP;
>  
> @@ -169,23 +365,7 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
>  	if (pid < 0)
>  		return -EINVAL;
>  
> -	spin_lock(&task_capability_lock);
> -	read_lock(&tasklist_lock);
> -
> -	if (pid && pid != task_pid_vnr(current)) {
> -		target = find_task_by_vpid(pid);
> -		if (!target) {
> -			ret = -ESRCH;
> -			goto out;
> -		}
> -	} else
> -		target = current;
> -
> -	ret = security_capget(target, &pE, &pI, &pP);
> -
> -out:
> -	read_unlock(&tasklist_lock);
> -	spin_unlock(&task_capability_lock);
> +	ret = cap_get_target_pid(pid, &pE, &pI, &pP);
>  
>  	if (!ret) {
>  		struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
> @@ -216,7 +396,6 @@ out:
>  		 * before modification is attempted and the application
>  		 * fails.
>  		 */
> -
>  		if (copy_to_user(dataptr, kdata, tocopy
>  				 * sizeof(struct __user_cap_data_struct))) {
>  			return -EFAULT;
> @@ -226,70 +405,8 @@ out:
>  	return ret;
>  }
>  
> -/*
> - * cap_set_pg - set capabilities for all processes in a given process
> - * group.  We call this holding task_capability_lock and tasklist_lock.
> - */
> -static inline int cap_set_pg(int pgrp_nr, kernel_cap_t *effective,
> -			      kernel_cap_t *inheritable,
> -			      kernel_cap_t *permitted)
> -{
> -	struct task_struct *g, *target;
> -	int ret = -EPERM;
> -	int found = 0;
> -	struct pid *pgrp;
> -
> -	pgrp = find_vpid(pgrp_nr);
> -	do_each_pid_task(pgrp, PIDTYPE_PGID, g) {
> -		target = g;
> -		while_each_thread(g, target) {
> -			if (!security_capset_check(target, effective,
> -							inheritable,
> -							permitted)) {
> -				security_capset_set(target, effective,
> -							inheritable,
> -							permitted);
> -				ret = 0;
> -			}
> -			found = 1;
> -		}
> -	} while_each_pid_task(pgrp, PIDTYPE_PGID, g);
> -
> -	if (!found)
> -		ret = 0;
> -	return ret;
> -}
> -
> -/*
> - * cap_set_all - set capabilities for all processes other than init
> - * and self.  We call this holding task_capability_lock and tasklist_lock.
> - */
> -static inline int cap_set_all(kernel_cap_t *effective,
> -			       kernel_cap_t *inheritable,
> -			       kernel_cap_t *permitted)
> -{
> -     struct task_struct *g, *target;
> -     int ret = -EPERM;
> -     int found = 0;
> -
> -     do_each_thread(g, target) {
> -             if (target == current || is_container_init(target->group_leader))
> -                     continue;
> -             found = 1;
> -	     if (security_capset_check(target, effective, inheritable,
> -						permitted))
> -		     continue;
> -	     ret = 0;
> -	     security_capset_set(target, effective, inheritable, permitted);
> -     } while_each_thread(g, target);
> -
> -     if (!found)
> -	     ret = 0;
> -     return ret;
> -}
> -
>  /**
> - * sys_capset - set capabilities for a process or a group of processes
> + * sys_capset - set capabilities for a process or (*) a group of processes
>   * @header: pointer to struct that contains capability version and
>   *	target pid data
>   * @data: pointer to struct that contains the effective, permitted,
> @@ -313,7 +430,6 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
>  	unsigned i, tocopy;
>  	kernel_cap_t inheritable, permitted, effective;
> -	struct task_struct *target;
>  	int ret;
>  	pid_t pid;
>  
> @@ -324,9 +440,6 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  	if (get_user(pid, &header->pid))
>  		return -EFAULT;
>  
> -	if (pid && pid != task_pid_vnr(current) && !capable(CAP_SETPCAP))
> -		return -EPERM;
> -
>  	if (copy_from_user(&kdata, data, tocopy
>  			   * sizeof(struct __user_cap_data_struct))) {
>  		return -EFAULT;
> @@ -344,40 +457,31 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  		i++;
>  	}
>  
> -	spin_lock(&task_capability_lock);
> -	read_lock(&tasklist_lock);
> -
> -	if (pid > 0 && pid != task_pid_vnr(current)) {
> -		target = find_task_by_vpid(pid);
> -		if (!target) {
> -			ret = -ESRCH;
> -			goto out;
> -		}
> -	} else
> -		target = current;
> -
> -	ret = 0;
> -
> -	/* having verified that the proposed changes are legal,
> -	   we now put them into effect. */
> -	if (pid < 0) {
> -		if (pid == -1)	/* all procs other than current and init */
> -			ret = cap_set_all(&effective, &inheritable, &permitted);
> +	if (pid && (pid != task_pid_vnr(current)))
> +		ret = do_sys_capset_other_tasks(pid, &effective, &inheritable,
> +						&permitted);
> +	else {
> +		/*
> +		 * This lock is required even when filesystem
> +		 * capability support is configured - it protects the
> +		 * sys_capget() call from returning incorrect data in
> +		 * the case that the targeted process is not the
> +		 * current one.
> +		 */
> +		spin_lock(&task_capability_lock);
>  
> -		else		/* all procs in process group */
> -			ret = cap_set_pg(-pid, &effective, &inheritable,
> -					 &permitted);
> -	} else {
> -		ret = security_capset_check(target, &effective, &inheritable,
> +		ret = security_capset_check(current, &effective, &inheritable,
>  					    &permitted);
> +		/*
> +		 * Having verified that the proposed changes are
> +		 * legal, we now put them into effect.
> +		 */
>  		if (!ret)
> -			security_capset_set(target, &effective, &inheritable,
> +			security_capset_set(current, &effective, &inheritable,
>  					    &permitted);
> +		spin_unlock(&task_capability_lock);
>  	}
>  
> -out:
> -	read_unlock(&tasklist_lock);
> -	spin_unlock(&task_capability_lock);
>  
>  	return ret;
>  }
> -- 
> 1.5.3.7
> 

