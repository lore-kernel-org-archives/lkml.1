Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYLaX0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYLaX0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 18:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYLaXZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 18:25:52 -0500
Received: from tundra.namei.org ([65.99.196.166]:4862 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbYLaXZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 18:25:51 -0500
Date: Thu, 1 Jan 2009 10:24:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
 sys_faccessat() [ver #2]
In-Reply-To: <21275.1230736542@redhat.com>
Message-ID: <alpine.LRH.1.10.0901011023400.397@tundra.namei.org>
References: <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding lsm list to the cc]

On Wed, 31 Dec 2008, David Howells wrote:

> 
> Here's an improved patch.  It differentiates the use of objective and
> subjective capabilities by making capable() only check current's subjective
> caps, but making has_capability() check only the objective caps of whatever
> process is specified.
> 
> It's a bit more involved, but I think it's the right thing to do.
> 
> David
> 
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] CRED: Fix regression in cap_capable() as shown up by sys_faccessat()
> 
> Fix a regression in cap_capable() due to:
> 
> 	commit 5ff7711e635b32f0a1e558227d030c7e45b4a465
> 	Author: David Howells <dhowells@redhat.com>
> 	Date:   Wed Dec 31 02:52:28 2008 +0000
> 
> 	    CRED: Differentiate objective and effective subjective credentials on a task
> 
> 
> The problem is that the above patch allows a process to have two sets of
> credentials, and for the most part uses the subjective credentials when
> accessing current's creds.
> 
> There is, however, one exception: cap_capable(), and thus capable(), uses the
> real/objective credentials of the target task, whether or not it is the current
> task.
> 
> Ordinarily this doesn't matter, since usually the two cred pointers in current
> point to the same set of creds.  However, sys_faccessat() makes use of this
> facility to override the credentials of the calling process to make its test,
> without affecting the creds as seen from other processes.
> 
> One of the things sys_faccessat() does is to make an adjustment to the
> effective capabilities mask, which cap_capable(), as it stands, then ignores.
> 
> The affected capability check is in generic_permission():
> 
> 	if (!(mask & MAY_EXEC) || execute_ok(inode))
> 		if (capable(CAP_DAC_OVERRIDE))
> 			return 0;
> 
> 
> This change splits capable() from has_capability() down into the commoncap and
> SELinux code.  The capable() security op now only deals with the current
> process, and uses the current process's subjective creds.  A new security op -
> task_capable() - is introduced that can check any task's objective creds.
> 
> strictly the capable() security op is superfluous with the presence of the
> task_capable() op, however it should be faster to call the capable() op since
> two fewer arguments need be passed down through the various layers.
> 
> 
> This can be tested by compiling the following program from the XFS testsuite:
> 
> /*
>  *  t_access_root.c - trivial test program to show permission bug.
>  *
>  *  Written by Michael Kerrisk - copyright ownership not pursued.
>  *  Sourced from: http://linux.derkeiler.com/Mailing-Lists/Kernel/2003-10/6030.html
>  */
> #include <limits.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <fcntl.h>
> #include <sys/stat.h>
> 
> #define UID 500
> #define GID 100
> #define PERM 0
> #define TESTPATH "/tmp/t_access"
> 
> static void
> errExit(char *msg)
> {
>     perror(msg);
>     exit(EXIT_FAILURE);
> } /* errExit */
> 
> static void
> accessTest(char *file, int mask, char *mstr)
> {
>     printf("access(%s, %s) returns %d\n", file, mstr, access(file, mask));
> } /* accessTest */
> 
> int
> main(int argc, char *argv[])
> {
>     int fd, perm, uid, gid;
>     char *testpath;
>     char cmd[PATH_MAX + 20];
> 
>     testpath = (argc > 1) ? argv[1] : TESTPATH;
>     perm = (argc > 2) ? strtoul(argv[2], NULL, 8) : PERM;
>     uid = (argc > 3) ? atoi(argv[3]) : UID;
>     gid = (argc > 4) ? atoi(argv[4]) : GID;
> 
>     unlink(testpath);
> 
>     fd = open(testpath, O_RDWR | O_CREAT, 0);
>     if (fd == -1) errExit("open");
> 
>     if (fchown(fd, uid, gid) == -1) errExit("fchown");
>     if (fchmod(fd, perm) == -1) errExit("fchmod");
>     close(fd);
> 
>     snprintf(cmd, sizeof(cmd), "ls -l %s", testpath);
>     system(cmd);
> 
>     if (seteuid(uid) == -1) errExit("seteuid");
> 
>     accessTest(testpath, 0, "0");
>     accessTest(testpath, R_OK, "R_OK");
>     accessTest(testpath, W_OK, "W_OK");
>     accessTest(testpath, X_OK, "X_OK");
>     accessTest(testpath, R_OK | W_OK, "R_OK | W_OK");
>     accessTest(testpath, R_OK | X_OK, "R_OK | X_OK");
>     accessTest(testpath, W_OK | X_OK, "W_OK | X_OK");
>     accessTest(testpath, R_OK | W_OK | X_OK, "R_OK | W_OK | X_OK");
> 
>     exit(EXIT_SUCCESS);
> } /* main */
> 
> 
> This can be run against an Ext3 filesystem as well as against an XFS
> filesystem.  If successful, it will show:
> 
> 	[root@andromeda src]# ./t_access_root /tmp/xxx 0 4043 4043
> 	---------- 1 dhowells dhowells 0 2008-12-31 03:00 /tmp/xxx
> 	access(/tmp/xxx, 0) returns 0
> 	access(/tmp/xxx, R_OK) returns 0
> 	access(/tmp/xxx, W_OK) returns 0
> 	access(/tmp/xxx, X_OK) returns -1
> 	access(/tmp/xxx, R_OK | W_OK) returns 0
> 	access(/tmp/xxx, R_OK | X_OK) returns -1
> 	access(/tmp/xxx, W_OK | X_OK) returns -1
> 	access(/tmp/xxx, R_OK | W_OK | X_OK) returns -1
> 
> If unsuccessful, it will show:
> 
> 	[root@andromeda src]# ./t_access_root /tmp/xxx 0 4043 4043
> 	---------- 1 dhowells dhowells 0 2008-12-31 02:56 /tmp/xxx
> 	access(/tmp/xxx, 0) returns 0
> 	access(/tmp/xxx, R_OK) returns -1
> 	access(/tmp/xxx, W_OK) returns -1
> 	access(/tmp/xxx, X_OK) returns -1
> 	access(/tmp/xxx, R_OK | W_OK) returns -1
> 	access(/tmp/xxx, R_OK | X_OK) returns -1
> 	access(/tmp/xxx, W_OK | X_OK) returns -1
> 	access(/tmp/xxx, R_OK | W_OK | X_OK) returns -1
> 
> I've also tested the fix with the SELinux and syscalls LTP testsuites.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/capability.h |   17 +++++++++++++--
>  include/linux/security.h   |   49 ++++++++++++++++++++++++++++++++++++--------
>  kernel/capability.c        |    2 +-
>  security/capability.c      |    1 +
>  security/commoncap.c       |   42 ++++++++++++++++++++++++++------------
>  security/root_plug.c       |    1 +
>  security/security.c        |   25 +++++++++++++++++++---
>  security/selinux/hooks.c   |   26 ++++++++++++++++++-----
>  security/smack/smack_lsm.c |    1 +
>  9 files changed, 129 insertions(+), 35 deletions(-)
> 
> 
> diff --git a/include/linux/capability.h b/include/linux/capability.h
> index e22f48c..5b8a132 100644
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@ -529,8 +529,21 @@ extern const kernel_cap_t __cap_init_eff_set;
>   *
>   * Note that this does not set PF_SUPERPRIV on the task.
>   */
> -#define has_capability(t, cap) (security_capable((t), (cap)) == 0)
> -#define has_capability_noaudit(t, cap) (security_capable_noaudit((t), (cap)) == 0)
> +#define has_capability(t, cap) (security_task_capable((t), (cap)) == 0)
> +
> +/**
> + * has_capability_noaudit - Determine if a task has a superior capability available (unaudited)
> + * @t: The task in question
> + * @cap: The capability to be tested for
> + *
> + * Return true if the specified task has the given superior capability
> + * currently in effect, false if not, but don't write an audit message for the
> + * check.
> + *
> + * Note that this does not set PF_SUPERPRIV on the task.
> + */
> +#define has_capability_noaudit(t, cap) \
> +	(security_task_capable_noaudit((t), (cap)) == 0)
>  
>  extern int capable(int cap);
>  
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 3416cb8..76989b8 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -48,7 +48,9 @@ struct audit_krule;
>   * These functions are in security/capability.c and are used
>   * as the default capabilities functions
>   */
> -extern int cap_capable(struct task_struct *tsk, int cap, int audit);
> +extern int cap_capable(int cap, int audit);
> +extern int cap_task_capable(struct task_struct *tsk, const struct cred *cred,
> +			    int cap, int audit);
>  extern int cap_settime(struct timespec *ts, struct timezone *tz);
>  extern int cap_ptrace_may_access(struct task_struct *child, unsigned int mode);
>  extern int cap_ptrace_traceme(struct task_struct *parent);
> @@ -1195,9 +1197,18 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	@permitted contains the permitted capability set.
>   *	Return 0 and update @new if permission is granted.
>   * @capable:
> - *	Check whether the @tsk process has the @cap capability.
> + *	Check whether the current process has the @cap capability in its
> + *      subjective/effective credentials.
> + *	@cap contains the capability <include/linux/capability.h>.
> + *	@audit: Whether to write an audit message or not
> + *	Return 0 if the capability is granted for @tsk.
> + * @task_capable:
> + *	Check whether the @tsk process has the @cap capability in its
> + *      objective/real credentials.
>   *	@tsk contains the task_struct for the process.
> + *	@cred contains the credentials to use.
>   *	@cap contains the capability <include/linux/capability.h>.
> + *	@audit: Whether to write an audit message or not
>   *	Return 0 if the capability is granted for @tsk.
>   * @acct:
>   *	Check permission before enabling or disabling process accounting.  If
> @@ -1290,7 +1301,9 @@ struct security_operations {
>  		       const kernel_cap_t *effective,
>  		       const kernel_cap_t *inheritable,
>  		       const kernel_cap_t *permitted);
> -	int (*capable) (struct task_struct *tsk, int cap, int audit);
> +	int (*capable) (int cap, int audit);
> +	int (*task_capable) (struct task_struct *tsk, const struct cred *cred,
> +			     int cap, int audit);
>  	int (*acct) (struct file *file);
>  	int (*sysctl) (struct ctl_table *table, int op);
>  	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
> @@ -1556,8 +1569,9 @@ int security_capset(struct cred *new, const struct cred *old,
>  		    const kernel_cap_t *effective,
>  		    const kernel_cap_t *inheritable,
>  		    const kernel_cap_t *permitted);
> -int security_capable(struct task_struct *tsk, int cap);
> -int security_capable_noaudit(struct task_struct *tsk, int cap);
> +int security_capable(int cap);
> +int security_task_capable(struct task_struct *tsk, int cap);
> +int security_task_capable_noaudit(struct task_struct *tsk, int cap);
>  int security_acct(struct file *file);
>  int security_sysctl(struct ctl_table *table, int op);
>  int security_quotactl(int cmds, int type, int id, struct super_block *sb);
> @@ -1754,14 +1768,31 @@ static inline int security_capset(struct cred *new,
>  	return cap_capset(new, old, effective, inheritable, permitted);
>  }
>  
> -static inline int security_capable(struct task_struct *tsk, int cap)
> +static inline int security_capable(int cap)
>  {
> -	return cap_capable(tsk, cap, SECURITY_CAP_AUDIT);
> +	return cap_capable(cap, SECURITY_CAP_AUDIT);
>  }
>  
> -static inline int security_capable_noaudit(struct task_struct *tsk, int cap)
> +static inline int security_task_capable(struct task_struct *tsk, int cap)
>  {
> -	return cap_capable(tsk, cap, SECURITY_CAP_NOAUDIT);
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = cap_task_capable(tsk, __task_cred(tsk), cap, SECURITY_CAP_AUDIT);
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +static inline
> +int security_task_capable_noaudit(struct task_struct *tsk, int cap)
> +{
> +	int ret;
> +
> +	rcu_read_lock();
> +	ret = cap_task_capable(tsk, __task_cred(tsk), cap,
> +			       SECURITY_CAP_NOAUDIT);
> +	rcu_read_unlock();
> +	return ret;
>  }
>  
>  static inline int security_acct(struct file *file)
> diff --git a/kernel/capability.c b/kernel/capability.c
> index 36b4b4d..df62f53 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -308,7 +308,7 @@ int capable(int cap)
>  		BUG();
>  	}
>  
> -	if (has_capability(current, cap)) {
> +	if (security_capable(cap) == 0) {
>  		current->flags |= PF_SUPERPRIV;
>  		return 1;
>  	}
> diff --git a/security/capability.c b/security/capability.c
> index 2dce66f..fd1493d 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -826,6 +826,7 @@ void security_fixup_ops(struct security_operations *ops)
>  	set_to_cap_if_null(ops, capset);
>  	set_to_cap_if_null(ops, acct);
>  	set_to_cap_if_null(ops, capable);
> +	set_to_cap_if_null(ops, task_capable);
>  	set_to_cap_if_null(ops, quotactl);
>  	set_to_cap_if_null(ops, quota_on);
>  	set_to_cap_if_null(ops, sysctl);
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 7971354..7f0b2a6 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -43,28 +43,44 @@ int cap_netlink_recv(struct sk_buff *skb, int cap)
>  EXPORT_SYMBOL(cap_netlink_recv);
>  
>  /**
> - * cap_capable - Determine whether a task has a particular effective capability
> - * @tsk: The task to query
> + * cap_capable - Determine whether current has a particular effective capability
>   * @cap: The capability to check for
>   * @audit: Whether to write an audit message or not
>   *
>   * Determine whether the nominated task has the specified capability amongst
> - * its effective set, returning 0 if it does, -ve if it does not.
> + * its effective set, returning 0 if it does, -ve if it does not.  Note that
> + * this uses current's subjective/effective credentials.
>   *
>   * NOTE WELL: cap_capable() cannot be used like the kernel's capable()
>   * function.  That is, it has the reverse semantics: cap_capable() returns 0
>   * when a task has a capability, but the kernel's capable() returns 1 for this
>   * case.
>   */
> -int cap_capable(struct task_struct *tsk, int cap, int audit)
> +int cap_capable(int cap, int audit)
>  {
> -	__u32 cap_raised;
> +	return cap_raised(current_cap(), cap) ? 0 : -EPERM;
> +}
>  
> -	/* Derived from include/linux/sched.h:capable. */
> -	rcu_read_lock();
> -	cap_raised = cap_raised(__task_cred(tsk)->cap_effective, cap);
> -	rcu_read_unlock();
> -	return cap_raised ? 0 : -EPERM;
> +/**
> + * cap_has_capability - Determine whether a task has a particular effective capability
> + * @tsk: The task to query
> + * @cred: The credentials to use
> + * @cap: The capability to check for
> + * @audit: Whether to write an audit message or not
> + *
> + * Determine whether the nominated task has the specified capability amongst
> + * its effective set, returning 0 if it does, -ve if it does not.  Note that
> + * this uses the task's objective/real credentials.
> + *
> + * NOTE WELL: cap_has_capability() cannot be used like the kernel's
> + * has_capability() function.  That is, it has the reverse semantics:
> + * cap_has_capability() returns 0 when a task has a capability, but the
> + * kernel's has_capability() returns 1 for this case.
> + */
> +int cap_task_capable(struct task_struct *tsk, const struct cred *cred, int cap,
> +		     int audit)
> +{
> +	return cap_raised(cred->cap_effective, cap) ? 0 : -EPERM;
>  }
>  
>  /**
> @@ -160,7 +176,7 @@ static inline int cap_inh_is_capped(void)
>  	/* they are so limited unless the current task has the CAP_SETPCAP
>  	 * capability
>  	 */
> -	if (cap_capable(current, CAP_SETPCAP, SECURITY_CAP_AUDIT) == 0)
> +	if (cap_capable(CAP_SETPCAP, SECURITY_CAP_AUDIT) == 0)
>  		return 0;
>  #endif
>  	return 1;
> @@ -869,7 +885,7 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  		     & (new->securebits ^ arg2))			/*[1]*/
>  		    || ((new->securebits & SECURE_ALL_LOCKS & ~arg2))	/*[2]*/
>  		    || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))	/*[3]*/
> -		    || (cap_capable(current, CAP_SETPCAP, SECURITY_CAP_AUDIT) != 0) /*[4]*/
> +		    || (cap_capable(CAP_SETPCAP, SECURITY_CAP_AUDIT) != 0) /*[4]*/
>  			/*
>  			 * [1] no changing of bits that are locked
>  			 * [2] no unlocking of locks
> @@ -950,7 +966,7 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
>  {
>  	int cap_sys_admin = 0;
>  
> -	if (cap_capable(current, CAP_SYS_ADMIN, SECURITY_CAP_NOAUDIT) == 0)
> +	if (cap_capable(CAP_SYS_ADMIN, SECURITY_CAP_NOAUDIT) == 0)
>  		cap_sys_admin = 1;
>  	return __vm_enough_memory(mm, pages, cap_sys_admin);
>  }
> diff --git a/security/root_plug.c b/security/root_plug.c
> index 40fb4f1..559578f 100644
> --- a/security/root_plug.c
> +++ b/security/root_plug.c
> @@ -77,6 +77,7 @@ static struct security_operations rootplug_security_ops = {
>  	.capget =			cap_capget,
>  	.capset =			cap_capset,
>  	.capable =			cap_capable,
> +	.task_capable =			cap_task_capable,
>  
>  	.bprm_set_creds =		cap_bprm_set_creds,
>  
> diff --git a/security/security.c b/security/security.c
> index d85dbb3..9bbc8e5 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -154,14 +154,31 @@ int security_capset(struct cred *new, const struct cred *old,
>  				    effective, inheritable, permitted);
>  }
>  
> -int security_capable(struct task_struct *tsk, int cap)
> +int security_capable(int cap)
>  {
> -	return security_ops->capable(tsk, cap, SECURITY_CAP_AUDIT);
> +	return security_ops->capable(cap, SECURITY_CAP_AUDIT);
>  }
>  
> -int security_capable_noaudit(struct task_struct *tsk, int cap)
> +int security_task_capable(struct task_struct *tsk, int cap)
>  {
> -	return security_ops->capable(tsk, cap, SECURITY_CAP_NOAUDIT);
> +	const struct cred *cred;
> +	int ret;
> +
> +	cred = get_task_cred(tsk);
> +	ret = security_ops->task_capable(tsk, cred, cap, SECURITY_CAP_AUDIT);
> +	put_cred(cred);
> +	return ret;
> +}
> +
> +int security_task_capable_noaudit(struct task_struct *tsk, int cap)
> +{
> +	const struct cred *cred;
> +	int ret;
> +
> +	cred = get_task_cred(tsk);
> +	ret = security_ops->task_capable(tsk, cred, cap, SECURITY_CAP_NOAUDIT);
> +	put_cred(cred);
> +	return ret;
>  }
>  
>  int security_acct(struct file *file)
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index dbeaa78..5a66cd3 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1433,12 +1433,13 @@ static int current_has_perm(const struct task_struct *tsk,
>  
>  /* Check whether a task is allowed to use a capability. */
>  static int task_has_capability(struct task_struct *tsk,
> +			       const struct cred *cred,
>  			       int cap, int audit)
>  {
>  	struct avc_audit_data ad;
>  	struct av_decision avd;
>  	u16 sclass;
> -	u32 sid = task_sid(tsk);
> +	u32 sid = cred_sid(cred);
>  	u32 av = CAP_TO_MASK(cap);
>  	int rc;
>  
> @@ -1865,15 +1866,27 @@ static int selinux_capset(struct cred *new, const struct cred *old,
>  	return cred_has_perm(old, new, PROCESS__SETCAP);
>  }
>  
> -static int selinux_capable(struct task_struct *tsk, int cap, int audit)
> +static int selinux_capable(int cap, int audit)
> +{
> +	int rc;
> +
> +	rc = secondary_ops->capable(cap, audit);
> +	if (rc)
> +		return rc;
> +
> +	return task_has_capability(current, current_cred(), cap, audit);
> +}
> +
> +static int selinux_task_capable(struct task_struct *tsk,
> +				const struct cred *cred, int cap, int audit)
>  {
>  	int rc;
>  
> -	rc = secondary_ops->capable(tsk, cap, audit);
> +	rc = secondary_ops->task_capable(tsk, cred, cap, audit);
>  	if (rc)
>  		return rc;
>  
> -	return task_has_capability(tsk, cap, audit);
> +	return task_has_capability(tsk, cred, cap, audit);
>  }
>  
>  static int selinux_sysctl_get_sid(ctl_table *table, u16 tclass, u32 *sid)
> @@ -2037,7 +2050,7 @@ static int selinux_vm_enough_memory(struct mm_struct *mm, long pages)
>  {
>  	int rc, cap_sys_admin = 0;
>  
> -	rc = selinux_capable(current, CAP_SYS_ADMIN, SECURITY_CAP_NOAUDIT);
> +	rc = selinux_capable(CAP_SYS_ADMIN, SECURITY_CAP_NOAUDIT);
>  	if (rc == 0)
>  		cap_sys_admin = 1;
>  
> @@ -2880,7 +2893,7 @@ static int selinux_inode_getsecurity(const struct inode *inode, const char *name
>  	 * and lack of permission just means that we fall back to the
>  	 * in-core context value, not a denial.
>  	 */
> -	error = selinux_capable(current, CAP_MAC_ADMIN, SECURITY_CAP_NOAUDIT);
> +	error = selinux_capable(CAP_MAC_ADMIN, SECURITY_CAP_NOAUDIT);
>  	if (!error)
>  		error = security_sid_to_context_force(isec->sid, &context,
>  						      &size);
> @@ -5568,6 +5581,7 @@ static struct security_operations selinux_ops = {
>  	.capset =			selinux_capset,
>  	.sysctl =			selinux_sysctl,
>  	.capable =			selinux_capable,
> +	.task_capable =			selinux_task_capable,
>  	.quotactl =			selinux_quotactl,
>  	.quota_on =			selinux_quota_on,
>  	.syslog =			selinux_syslog,
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 1b5551d..8e53d43 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -2628,6 +2628,7 @@ struct security_operations smack_ops = {
>  	.capget = 			cap_capget,
>  	.capset = 			cap_capset,
>  	.capable = 			cap_capable,
> +	.task_capable = 		cap_task_capable,
>  	.syslog = 			smack_syslog,
>  	.settime = 			cap_settime,
>  	.vm_enough_memory = 		cap_vm_enough_memory,
> 

-- 
James Morris
<jmorris@namei.org>
