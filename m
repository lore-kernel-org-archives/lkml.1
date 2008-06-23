Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYFWPYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYFWPYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYFWPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:23:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49136 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbYFWPXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:23:55 -0400
Date: Mon, 23 Jun 2008 10:23:48 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] capabilities: refactor kernel code + bugfix
Message-ID: <20080623152348.GA25255@us.ibm.com>
References: <485BCEEB.30105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485BCEEB.30105@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> This version of the patch includes fixes suggested by David Howells and
> a clarifying comment in the commit message as per Serge.
>
> Cheers
>
> Andrew
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFIW87r+bHCR3gb8jsRAkIDAJ9kJkR40hwUF7UggjiyouFh5igraACdFKMQ
> ZBrpJdQMDjG0xdiSrVFSszA=
> =EDea
> -----END PGP SIGNATURE-----

> From 8a2bffcb5363295ea43ef42c84c121a8e8c7ffa0 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Fri, 20 Jun 2008 08:16:06 -0700
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
> This commit also includes a bugfix for the fragile setuid fixup
> code in the case that filesystem capabilities are supported (in access()).
> The effect of this fix is gated on filesystem capability support because
> changing securebits is only supported when filesystem capabilities support
> is configured.)
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>

In particular I get the same ltp results with and without the patch, and
with file capabilities on and off.  I haven't tried every combination,
in particular not without capabilities, but that shouldn't be affected.

thanks,
-serge

> ---
>  fs/open.c                  |   38 +++--
>  include/linux/capability.h |    2 +
>  include/linux/securebits.h |   15 +-
>  kernel/capability.c        |  359 +++++++++++++++++++++++++++++--------------
>  4 files changed, 275 insertions(+), 139 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index a145008..3b53948 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -16,6 +16,7 @@
>  #include <linux/namei.h>
>  #include <linux/backing-dev.h>
>  #include <linux/capability.h>
> +#include <linux/securebits.h>
>  #include <linux/security.h>
>  #include <linux/mount.h>
>  #include <linux/vfs.h>
> @@ -425,7 +426,7 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
>  {
>  	struct nameidata nd;
>  	int old_fsuid, old_fsgid;
> -	kernel_cap_t old_cap;
> +	kernel_cap_t uninitialized_var(old_cap);  /* !SECURE_NO_SETUID_FIXUP */
>  	int res;
>  
>  	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
> @@ -433,23 +434,27 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
>  
>  	old_fsuid = current->fsuid;
>  	old_fsgid = current->fsgid;
> -	old_cap = current->cap_effective;
>  
>  	current->fsuid = current->uid;
>  	current->fsgid = current->gid;
>  
> -	/*
> -	 * Clear the capabilities if we switch to a non-root user
> -	 *
> -	 * FIXME: There is a race here against sys_capset.  The
> -	 * capabilities can change yet we will restore the old
> -	 * value below.  We should hold task_capabilities_lock,
> -	 * but we cannot because user_path_walk can sleep.
> -	 */
> -	if (current->uid)
> -		cap_clear(current->cap_effective);
> -	else
> -		current->cap_effective = current->cap_permitted;
> +	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
> +		/*
> +		 * Clear the capabilities if we switch to a non-root user
> +		 */
> +#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
> +		/*
> +		 * FIXME: There is a race here against sys_capset.  The
> +		 * capabilities can change yet we will restore the old
> +		 * value below.  We should hold task_capabilities_lock,
> +		 * but we cannot because user_path_walk can sleep.
> +		 */
> +#endif /* ndef CONFIG_SECURITY_FILE_CAPABILITIES */
> +		if (current->uid)
> +			old_cap = cap_set_effective(__cap_empty_set);
> +		else
> +			old_cap = cap_set_effective(current->cap_permitted);
> +	}
>  
>  	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
>  	if (res)
> @@ -478,7 +483,10 @@ out_path_release:
>  out:
>  	current->fsuid = old_fsuid;
>  	current->fsgid = old_fsgid;
> -	current->cap_effective = old_cap;
> +
> +	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
> +		(void) cap_set_effective(old_cap);
> +	}
>  
>  	return res;
>  }
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index fa830f8..0267384 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -501,6 +501,8 @@ extern const kernel_cap_t __cap_empty_set;
>  extern const kernel_cap_t __cap_full_set;
>  extern const kernel_cap_t __cap_init_eff_set;
>  
> +kernel_cap_t cap_set_effective(const kernel_cap_t pE_new);
> +
>  int capable(int cap);
>  int __capable(struct task_struct *t, int cap);
>  
> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index c1f19db..92f09bd 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -7,14 +7,15 @@
>     inheritance of root-permissions and suid-root executable under
>     compatibility mode. We raise the effective and inheritable bitmasks
>     *of the executable file* if the effective uid of the new process is
> -   0. If the real uid is 0, we raise the inheritable bitmask of the
> +   0. If the real uid is 0, we raise the effective (legacy) bit of the
>     executable file. */
>  #define SECURE_NOROOT			0
>  #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
>  
> -/* When set, setuid to/from uid 0 does not trigger capability-"fixes"
> -   to be compatible with old programs relying on set*uid to loose
> -   privileges. When unset, setuid doesn't change privileges. */
> +/* When set, setuid to/from uid 0 does not trigger capability-"fixup".
> +   When unset, to provide compatiblility with old programs relying on
> +   set*uid to gain/lose privilege, transitions to/from uid 0 cause
> +   capabilities to be gained/lost. */
>  #define SECURE_NO_SETUID_FIXUP		2
>  #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
>  
> @@ -26,10 +27,10 @@
>  #define SECURE_KEEP_CAPS		4
>  #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
>  
> -/* Each securesetting is implemented using two bits. One bit specify
> +/* Each securesetting is implemented using two bits. One bit specifies
>     whether the setting is on or off. The other bit specify whether the
> -   setting is fixed or not. A setting which is fixed cannot be changed
> -   from user-level. */
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
>  #define issecure_mask(X)	(1 << (X))
>  #define issecure(X)		(issecure_mask(X) & current->securebits)
>  
> diff --git a/kernel/capability.c b/kernel/capability.c
> index cfbe442..50a81d5 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -115,11 +115,229 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
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
> +
> +/*
> + * Atomically modify the effective capabilities returning the original
> + * value. No permission check is performed here - it is assumed that the
> + * caller is permitted to set the desired effective capabilities.
> + */
> +kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
> +{
> +	kernel_cap_t pE_old;
> +
> +	spin_lock(&task_capability_lock);
> +
> +	pE_old = current->cap_effective;
> +	current->cap_effective = pE_new;
> +
> +	spin_unlock(&task_capability_lock);
> +
> +	return pE_old;
> +}
> +
> +EXPORT_SYMBOL(cap_set_effective);
>  
>  /**
>   * sys_capget - get the capabilities of a given process.
> @@ -134,7 +352,6 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
>  {
>  	int ret = 0;
>  	pid_t pid;
> -	struct task_struct *target;
>  	unsigned tocopy;
>  	kernel_cap_t pE, pI, pP;
>  
> @@ -148,23 +365,7 @@ asmlinkage long sys_capget(cap_user_header_t header, cap_user_data_t dataptr)
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
> @@ -195,7 +396,6 @@ out:
>  		 * before modification is attempted and the application
>  		 * fails.
>  		 */
> -
>  		if (copy_to_user(dataptr, kdata, tocopy
>  				 * sizeof(struct __user_cap_data_struct))) {
>  			return -EFAULT;
> @@ -205,70 +405,8 @@ out:
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
> @@ -292,7 +430,6 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
>  	unsigned i, tocopy;
>  	kernel_cap_t inheritable, permitted, effective;
> -	struct task_struct *target;
>  	int ret;
>  	pid_t pid;
>  
> @@ -303,9 +440,6 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
>  	if (get_user(pid, &header->pid))
>  		return -EFAULT;
>  
> -	if (pid && pid != task_pid_vnr(current) && !capable(CAP_SETPCAP))
> -		return -EPERM;
> -
>  	if (copy_from_user(&kdata, data, tocopy
>  			   * sizeof(struct __user_cap_data_struct))) {
>  		return -EFAULT;
> @@ -323,40 +457,31 @@ asmlinkage long sys_capset(cap_user_header_t header, const cap_user_data_t data)
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

