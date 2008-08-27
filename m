Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYH0OEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYH0OEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbYH0NwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:52:21 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55406 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbYH0NwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:52:19 -0400
Date: Wed, 27 Aug 2008 08:52:06 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Message-ID: <20080827135206.GA12919@us.ibm.com>
References: <200808262057.51606.agruen@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808262057.51606.agruen@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andreas Gruenbacher (agruen@suse.de):
> Hello,
> 
> here is a patch allowing to disable file capabilities via a kernel command
> line option (once compiled in with CONFIG_SECURITY_FILE_CAPABILITIES).
> 
> We would like to ship our next round of products with file capabilities
> compiled in, yet we feel that too many system utilities are still file
> capabilitiy unaware, and so we would like to turn them off by default
> initially. File capabilities can be used to grant privileges to binaries
> which otherwise look "harmless", which is a security risk until utilities
> like rpm have learned how to install and verify capabilities, etc.
> 
> Any objections?

Hi Andreas,

No objections in general - if it makes you more comfortable shipping
kernels with CONFIG_SECURITY_FILE_CAPABILITIES=y then it's worthwhile.
However, can you elaborate on your concerns?

In particular, if as you say above the concern is really just that a
file might have capabilities accidentally (or maliciously) enabled, then
we should be able to just check for file_caps_enabled() at
get_file_caps(), refusing to fill in the file capabilities.

The other changes which you are canceling out confuscate the code but
actually make no difference.  In particular, the change in behavior
wrt CAP_SETPCAP is as follows:  With
CONFIG_SECURITY_FILE_CAPABILITIES=n, CAP_SETPCAP means that you
can give your capabilities to another task.  With
CONFIG_SECURITY_FILE_CAPABILITIES=y, CAP_SETPCAP *only* means that
you can add bits to your pI.  But pI is always masked with fI, so
if we refuse to fill in fI at get_file_caps(), then that is ok :)

Do you want me to send a such a patch?

thanks,
-serge

> Thanks.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> 
> ---
>  include/linux/init_task.h |   13 ------
>  kernel/capability.c       |   79 +++++++++++++--------------------------
>  kernel/sched.c            |    9 ++++
>  security/commoncap.c      |   93 +++++++++++++++++++++++-----------------------
>  4 files changed, 85 insertions(+), 109 deletions(-)
> 
> Index: b/include/linux/init_task.h
> ===================================================================
> --- a/include/linux/init_task.h
> +++ b/include/linux/init_task.h
> @@ -102,17 +102,6 @@ extern struct group_info init_groups;
>  #define INIT_IDS
>  #endif
> 
> -#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> -/*
> - * Because of the reduced scope of CAP_SETPCAP when filesystem
> - * capabilities are in effect, it is safe to allow CAP_SETPCAP to
> - * be available in the default configuration.
> - */
> -# define CAP_INIT_BSET  CAP_FULL_SET
> -#else
> -# define CAP_INIT_BSET  CAP_INIT_EFF_SET
> -#endif
> -
>  /*
>   *  INIT_TASK is used to set up the first task table, touch at
>   * your own risk!. Base=0, limit=0x1fffff (=2MB)
> @@ -151,7 +140,7 @@ extern struct group_info init_groups;
>  	.cap_effective	= CAP_INIT_EFF_SET,				\
>  	.cap_inheritable = CAP_INIT_INH_SET,				\
>  	.cap_permitted	= CAP_FULL_SET,					\
> -	.cap_bset 	= CAP_INIT_BSET,				\
> +	.cap_bset 	= CAP_INIT_EFF_SET, /* also see sched_init() */	\
>  	.securebits     = SECUREBITS_DEFAULT,				\
>  	.user		= INIT_USER,					\
>  	.comm		= "swapper",					\
> Index: b/kernel/capability.c
> ===================================================================
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -33,6 +33,19 @@ EXPORT_SYMBOL(__cap_empty_set);
>  EXPORT_SYMBOL(__cap_full_set);
>  EXPORT_SYMBOL(__cap_init_eff_set);
> 
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +int file_caps_enabled = 1;
> +
> +static int __init file_caps_disable(char *str)
> +{
> +	file_caps_enabled = 0;
> +	return 1;
> +}
> +__setup("no_file_caps", file_caps_disable);
> +#else
> +static const int file_caps_enabled = 0;
> +#endif
> +
>  /*
>   * More recent versions of libcap are available from:
>   *
> @@ -115,39 +128,6 @@ static int cap_validate_magic(cap_user_h
>  	return 0;
>  }
> 
> -#ifndef CONFIG_SECURITY_FILE_CAPABILITIES
> -
> -/*
> - * Without filesystem capability support, we nominally support one process
> - * setting the capabilities of another
> - */
> -static inline int cap_get_target_pid(pid_t pid, kernel_cap_t *pEp,
> -				     kernel_cap_t *pIp, kernel_cap_t *pPp)
> -{
> -	struct task_struct *target;
> -	int ret;
> -
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
> -	ret = security_capget(target, pEp, pIp, pPp);
> -
> -out:
> -	read_unlock(&tasklist_lock);
> -	spin_unlock(&task_capability_lock);
> -
> -	return ret;
> -}
> -
>  /*
>   * cap_set_pg - set capabilities for all processes in a given process
>   * group.  We call this holding task_capability_lock and tasklist_lock.
> @@ -234,6 +214,17 @@ static inline int do_sys_capset_other_ta
>  	struct task_struct *target;
>  	int ret;
> 
> +	if (file_caps_enabled) {
> +		/*
> +		 * With filesystem capability support configured, the kernel
> +		 * does not permit the changing of capabilities in one process
> +		 * by another process. (CAP_SETPCAP has much less broad
> +		 * semantics when configured this way.)
> +		 */
> +
> +		return -EPERM;
> +	}
> +
>  	if (!capable(CAP_SETPCAP))
>  		return -EPERM;
> 
> @@ -267,8 +258,6 @@ static inline int do_sys_capset_other_ta
>  	return ret;
>  }
> 
> -#else /* ie., def CONFIG_SECURITY_FILE_CAPABILITIES */
> -
>  /*
>   * If we have configured with filesystem capability support, then the
>   * only thing that can change the capabilities of the current process
> @@ -296,6 +285,10 @@ static inline int cap_get_target_pid(pid
> 
>  		read_unlock(&tasklist_lock);
>  		spin_unlock(&task_capability_lock);
> +	} else if (!file_caps_enabled) {
> +		spin_lock(&task_capability_lock);
> +		ret = security_capget(current, pEp, pIp, pPp);
> +		spin_unlock(&task_capability_lock);
>  	} else
>  		ret = security_capget(current, pEp, pIp, pPp);
> 
> @@ -303,22 +296,6 @@ static inline int cap_get_target_pid(pid
>  }
> 
>  /*
> - * With filesystem capability support configured, the kernel does not
> - * permit the changing of capabilities in one process by another
> - * process. (CAP_SETPCAP has much less broad semantics when configured
> - * this way.)
> - */
> -static inline int do_sys_capset_other_tasks(pid_t pid,
> -					    kernel_cap_t *effective,
> -					    kernel_cap_t *inheritable,
> -					    kernel_cap_t *permitted)
> -{
> -	return -EPERM;
> -}
> -
> -#endif /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
> -
> -/*
>   * Atomically modify the effective capabilities returning the original
>   * value. No permission check is performed here - it is assumed that the
>   * caller is permitted to set the desired effective capabilities.
> Index: b/kernel/sched.c
> ===================================================================
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -8149,6 +8149,15 @@ void __init sched_init(void)
>  	plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);
>  #endif
> 
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +	/*
> +	 * Because of the reduced scope of CAP_SETPCAP when filesystem
> +	 * capabilities are in effect, it is safe to allow CAP_SETPCAP to
> +	 * be available in the default configuration.
> +	 */
> +	init_task.cap_bset = CAP_FULL_SET;
> +#endif
> +
>  	/*
>  	 * The boot idle thread does lazy MMU switching as well:
>  	 */
> Index: b/security/commoncap.c
> ===================================================================
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -27,6 +27,12 @@
>  #include <linux/prctl.h>
>  #include <linux/securebits.h>
> 
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +extern int file_caps_enabled;
> +#else
> +static const int file_caps_enabled = 0;
> +#endif
> +
>  int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
>  {
>  	NETLINK_CB(skb).eff_cap = current->cap_effective;
> @@ -93,10 +99,11 @@ int cap_capget (struct task_struct *targ
>  	return 0;
>  }
> 
> -#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> -
>  static inline int cap_block_setpcap(struct task_struct *target)
>  {
> +	if (!file_caps_enabled)
> +		return 0;
> +
>  	/*
>  	 * No support for remote process capability manipulation with
>  	 * filesystem capability support.
> @@ -106,6 +113,9 @@ static inline int cap_block_setpcap(stru
> 
>  static inline int cap_inh_is_capped(void)
>  {
> +	if (!file_caps_enabled)
> +		return 1;
> +
>  	/*
>  	 * Return 1 if changes to the inheritable set are limited
>  	 * to the old permitted set. That is, if the current task
> @@ -114,18 +124,13 @@ static inline int cap_inh_is_capped(void
>  	return (cap_capable(current, CAP_SETPCAP) != 0);
>  }
> 
> -static inline int cap_limit_ptraced_target(void) { return 1; }
> -
> -#else /* ie., ndef CONFIG_SECURITY_FILE_CAPABILITIES */
> -
> -static inline int cap_block_setpcap(struct task_struct *t) { return 0; }
> -static inline int cap_inh_is_capped(void) { return 1; }
>  static inline int cap_limit_ptraced_target(void)
>  {
> -	return !capable(CAP_SETPCAP);
> -}
> +	if (!file_caps_enabled)
> +		return !capable(CAP_SETPCAP);
> 
> -#endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
> +	return 1;
> +}
> 
>  int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
>  		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
> @@ -176,13 +181,14 @@ static inline void bprm_clear_caps(struc
>  	bprm->cap_effective = false;
>  }
> 
> -#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> -
>  int cap_inode_need_killpriv(struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
>  	int error;
> 
> +	if (!file_caps_enabled)
> +		return 0;
> +
>  	if (!inode->i_op || !inode->i_op->getxattr)
>  	       return 0;
> 
> @@ -196,6 +202,9 @@ int cap_inode_killpriv(struct dentry *de
>  {
>  	struct inode *inode = dentry->d_inode;
> 
> +	if (!file_caps_enabled)
> +		return 0;
> +
>  	if (!inode->i_op || !inode->i_op->removexattr)
>  	       return 0;
> 
> @@ -279,6 +288,11 @@ static int get_file_caps(struct linux_bi
>  	struct vfs_cap_data vcaps;
>  	struct inode *inode;
> 
> +	if (!file_caps_enabled) {
> +		bprm_clear_caps(bprm);
> +		return 0;
> +	}
> +
>  	if (bprm->file->f_vfsmnt->mnt_flags & MNT_NOSUID) {
>  		bprm_clear_caps(bprm);
>  		return 0;
> @@ -312,24 +326,6 @@ out:
>  	return rc;
>  }
> 
> -#else
> -int cap_inode_need_killpriv(struct dentry *dentry)
> -{
> -	return 0;
> -}
> -
> -int cap_inode_killpriv(struct dentry *dentry)
> -{
> -	return 0;
> -}
> -
> -static inline int get_file_caps(struct linux_binprm *bprm)
> -{
> -	bprm_clear_caps(bprm);
> -	return 0;
> -}
> -#endif
> -
>  int cap_bprm_set_security (struct linux_binprm *bprm)
>  {
>  	int ret;
> @@ -530,7 +526,6 @@ int cap_task_post_setuid (uid_t old_ruid
>  	return 0;
>  }
> 
> -#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
>  /*
>   * Rationale: code calling task_setscheduler, task_setioprio, and
>   * task_setnice, assumes that
> @@ -552,19 +547,30 @@ static inline int cap_safe_nice(struct t
>  int cap_task_setscheduler (struct task_struct *p, int policy,
>  			   struct sched_param *lp)
>  {
> +	if (!file_caps_enabled)
> +		return 0;
> +
>  	return cap_safe_nice(p);
>  }
> 
>  int cap_task_setioprio (struct task_struct *p, int ioprio)
>  {
> +	if (!file_caps_enabled)
> +		return 0;
> +
>  	return cap_safe_nice(p);
>  }
> 
>  int cap_task_setnice (struct task_struct *p, int nice)
>  {
> +	if (!file_caps_enabled)
> +		return 0;
> +
>  	return cap_safe_nice(p);
>  }
> 
> +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> +
>  /*
>   * called from kernel/sys.c for prctl(PR_CABSET_DROP)
>   * done without task_capability_lock() because it introduces
> @@ -582,20 +588,6 @@ static long cap_prctl_drop(unsigned long
>  	return 0;
>  }
> 
> -#else
> -int cap_task_setscheduler (struct task_struct *p, int policy,
> -			   struct sched_param *lp)
> -{
> -	return 0;
> -}
> -int cap_task_setioprio (struct task_struct *p, int ioprio)
> -{
> -	return 0;
> -}
> -int cap_task_setnice (struct task_struct *p, int nice)
> -{
> -	return 0;
> -}
>  #endif
> 
>  int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> @@ -612,6 +604,9 @@ int cap_task_prctl(int option, unsigned 
>  		break;
>  #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
>  	case PR_CAPBSET_DROP:
> +		if (!file_caps_enabled)
> +			return 0;
> +
>  		error = cap_prctl_drop(arg2);
>  		break;
> 
> @@ -635,6 +630,9 @@ int cap_task_prctl(int option, unsigned 
>  	 * capability-based-privilege environment.
>  	 */
>  	case PR_SET_SECUREBITS:
> +		if (!file_caps_enabled)
> +			return 0;
> +
>  		if ((((current->securebits & SECURE_ALL_LOCKS) >> 1)
>  		     & (current->securebits ^ arg2))                  /*[1]*/
>  		    || ((current->securebits & SECURE_ALL_LOCKS
> @@ -654,6 +652,9 @@ int cap_task_prctl(int option, unsigned 
>  		}
>  		break;
>  	case PR_GET_SECUREBITS:
> +		if (!file_caps_enabled)
> +			return 0;
> +
>  		error = current->securebits;
>  		break;
