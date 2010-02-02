Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab0BBGPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:15:14 -0500
Received: from smtp110.prem.mail.sp1.yahoo.com ([98.136.44.55]:26838 "HELO
	smtp110.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753404Ab0BBGPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:15:10 -0500
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: kUCE6j4VM1nlUFsTFR7qirEKFtu8oJP73niqSTKhyqeo.fFi7YPh_7CwCflHJMYZdLtnPe5VV3ZDKem92epe2E1jHZDE6O0EpnubQ2lnW2moEvSRI1Kf6w4Ek_vxZHdem7AiTRMo2IMgVvwP15AcYx40e7CgXPr9gLIwNyqqjnTRrPMFxVH374OLwjhb6_caOx8O_2F5jIBpmQ.s2AHPnNIErHY2WoW_YZlL.OoduCNYFWDh76IDAqvwUUG5yzqTzks5mcuC6LV1XAb2UmJrjX3aYpUTqcRD6eEDypLoRZCxCRpys_Y6QLK.zw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B67C2EA.705@schaufler-ca.com>
Date: Mon, 01 Feb 2010 22:15:06 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Robin Getz <rgetz@analog.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Paul Moore <paul.moore@hp.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Etienne Basset <etienne.basset@numericable.fr>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       LKLM <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] syslog: distinguish between /proc/kmsg and syscalls
References: <20100202055354.GV19355@outflux.net>
In-Reply-To: <20100202055354.GV19355@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> This allows the LSM to distinguish between syslog functions originating
> from /proc/kmsg access and direct syscalls.  By default, the commoncaps
> will now no longer require CAP_SYS_ADMIN to read an opened /proc/kmsg
> file descriptor.  For example the kernel syslog reader can now drop
> privileges after opening /proc/kmsg, instead of staying privileged with
> CAP_SYS_ADMIN.  MAC systems that implement security_syslog have unchanged
> behavior.
>   

Might I suggest that you use a term other than "context" in this patch?
I recognize that it is the proper word, but the term has significant and
specific meaning in SELinux, and some of that has spilled over into the
LSM in general. I expect that there might be confusion if it is used to
denote something other than an SELinux "context". Perhaps "method", "type",
or "scheme".

Aside from that, I see no problems.

> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  fs/proc/kmsg.c             |   14 +++++++-------
>  include/linux/security.h   |   11 ++++++-----
>  include/linux/syslog.h     |   29 +++++++++++++++++++++++++++++
>  kernel/printk.c            |    7 ++++---
>  security/commoncap.c       |    7 ++++++-
>  security/security.c        |    4 ++--
>  security/selinux/hooks.c   |    4 ++--
>  security/smack/smack_lsm.c |    4 ++--
>  8 files changed, 58 insertions(+), 22 deletions(-)
>  create mode 100644 include/linux/syslog.h
>
> diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
> index 7ca7834..4f52b68 100644
> --- a/fs/proc/kmsg.c
> +++ b/fs/proc/kmsg.c
> @@ -12,37 +12,37 @@
>  #include <linux/poll.h>
>  #include <linux/proc_fs.h>
>  #include <linux/fs.h>
> +#include <linux/syslog.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/io.h>
>  
>  extern wait_queue_head_t log_wait;
>  
> -extern int do_syslog(int type, char __user *bug, int count);
> -
>  static int kmsg_open(struct inode * inode, struct file * file)
>  {
> -	return do_syslog(1,NULL,0);
> +	return do_syslog(1, NULL, 0, SYSLOG_CONTEXT_PROC);
>  }
>  
>  static int kmsg_release(struct inode * inode, struct file * file)
>  {
> -	(void) do_syslog(0,NULL,0);
> +	(void) do_syslog(0, NULL, 0, SYSLOG_CONTEXT_PROC);
>  	return 0;
>  }
>  
>  static ssize_t kmsg_read(struct file *file, char __user *buf,
>  			 size_t count, loff_t *ppos)
>  {
> -	if ((file->f_flags & O_NONBLOCK) && !do_syslog(9, NULL, 0))
> +	if ((file->f_flags & O_NONBLOCK) &&
> +	    !do_syslog(9, NULL, 0, SYSLOG_CONTEXT_PROC))
>  		return -EAGAIN;
> -	return do_syslog(2, buf, count);
> +	return do_syslog(2, buf, count, SYSLOG_CONTEXT_PROC);
>  }
>  
>  static unsigned int kmsg_poll(struct file *file, poll_table *wait)
>  {
>  	poll_wait(file, &log_wait, wait);
> -	if (do_syslog(9, NULL, 0))
> +	if (do_syslog(9, NULL, 0, SYSLOG_CONTEXT_PROC))
>  		return POLLIN | POLLRDNORM;
>  	return 0;
>  }
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 2c627d3..174f834 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -76,7 +76,7 @@ extern int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
>  extern int cap_task_setscheduler(struct task_struct *p, int policy, struct sched_param *lp);
>  extern int cap_task_setioprio(struct task_struct *p, int ioprio);
>  extern int cap_task_setnice(struct task_struct *p, int nice);
> -extern int cap_syslog(int type);
> +extern int cap_syslog(int type, int context);
>  extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
>  
>  struct msghdr;
> @@ -1348,6 +1348,7 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
>   *	logging to the console.
>   *	See the syslog(2) manual page for an explanation of the @type values.
>   *	@type contains the type of action.
> + *	@context contains the context of action (/proc or syscall).
>   *	Return 0 if permission is granted.
>   * @settime:
>   *	Check permission to change the system time.
> @@ -1462,7 +1463,7 @@ struct security_operations {
>  	int (*sysctl) (struct ctl_table *table, int op);
>  	int (*quotactl) (int cmds, int type, int id, struct super_block *sb);
>  	int (*quota_on) (struct dentry *dentry);
> -	int (*syslog) (int type);
> +	int (*syslog) (int type, int context);
>  	int (*settime) (struct timespec *ts, struct timezone *tz);
>  	int (*vm_enough_memory) (struct mm_struct *mm, long pages);
>  
> @@ -1761,7 +1762,7 @@ int security_acct(struct file *file);
>  int security_sysctl(struct ctl_table *table, int op);
>  int security_quotactl(int cmds, int type, int id, struct super_block *sb);
>  int security_quota_on(struct dentry *dentry);
> -int security_syslog(int type);
> +int security_syslog(int type, int context);
>  int security_settime(struct timespec *ts, struct timezone *tz);
>  int security_vm_enough_memory(long pages);
>  int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
> @@ -2007,9 +2008,9 @@ static inline int security_quota_on(struct dentry *dentry)
>  	return 0;
>  }
>  
> -static inline int security_syslog(int type)
> +static inline int security_syslog(int type, int context)
>  {
> -	return cap_syslog(type);
> +	return cap_syslog(type, context);
>  }
>  
>  static inline int security_settime(struct timespec *ts, struct timezone *tz)
> diff --git a/include/linux/syslog.h b/include/linux/syslog.h
> new file mode 100644
> index 0000000..563c2a9
> --- /dev/null
> +++ b/include/linux/syslog.h
> @@ -0,0 +1,29 @@
> +/*  Syslog internals
> + *
> + *  Copyright 2010 Canonical, Ltd.
> + *  Author: Kees Cook <kees.cook@canonical.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2, or (at your option)
> + *  any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + *
> + *  You should have received a copy of the GNU General Public License
> + *  along with this program; see the file COPYING.  If not, write to
> + *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef _LINUX_SYSLOG_H
> +#define _LINUX_SYSLOG_H
> +
> +#define SYSLOG_CONTEXT_SYSCALL 0
> +#define SYSLOG_CONTEXT_PROC    1
> +
> +int do_syslog(int type, char __user *buf, int count, int context);
> +
> +#endif /* _LINUX_SYSLOG_H */
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 1751c45..a131ad6 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -35,6 +35,7 @@
>  #include <linux/kexec.h>
>  #include <linux/ratelimit.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/syslog.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -273,14 +274,14 @@ static inline void boot_delay_msec(void)
>   *	9 -- Return number of unread characters in the log buffer
>   *     10 -- Return size of the log buffer
>   */
> -int do_syslog(int type, char __user *buf, int len)
> +int do_syslog(int type, char __user *buf, int len, int context)
>  {
>  	unsigned i, j, limit, count;
>  	int do_clear = 0;
>  	char c;
>  	int error = 0;
>  
> -	error = security_syslog(type);
> +	error = security_syslog(type, context);
>  	if (error)
>  		return error;
>  
> @@ -417,7 +418,7 @@ out:
>  
>  SYSCALL_DEFINE3(syslog, int, type, char __user *, buf, int, len)
>  {
> -	return do_syslog(type, buf, len);
> +	return do_syslog(type, buf, len, SYSLOG_CONTEXT_SYSCALL);
>  }
>  
>  /*
> diff --git a/security/commoncap.c b/security/commoncap.c
> index f800fdb..9c965dc 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -27,6 +27,7 @@
>  #include <linux/sched.h>
>  #include <linux/prctl.h>
>  #include <linux/securebits.h>
> +#include <linux/syslog.h>
>  
>  /*
>   * If a non-root user executes a setuid-root binary in
> @@ -888,12 +889,16 @@ error:
>  /**
>   * cap_syslog - Determine whether syslog function is permitted
>   * @type: Function requested
> + * @context: What context this request came from (/proc or syscall)
>   *
>   * Determine whether the current process is permitted to use a particular
>   * syslog function, returning 0 if permission is granted, -ve if not.
>   */
> -int cap_syslog(int type)
> +int cap_syslog(int type, int context)
>  {
> +	/* /proc/kmsg can open be opened by CAP_SYS_ADMIN */
> +	if (type != 1 && context == SYSLOG_CONTEXT_PROC)
> +		return 0;
>  	if ((type != 3 && type != 10) && !capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  	return 0;
> diff --git a/security/security.c b/security/security.c
> index 24e060b..38a8994 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -203,9 +203,9 @@ int security_quota_on(struct dentry *dentry)
>  	return security_ops->quota_on(dentry);
>  }
>  
> -int security_syslog(int type)
> +int security_syslog(int type, int context)
>  {
> -	return security_ops->syslog(type);
> +	return security_ops->syslog(type, context);
>  }
>  
>  int security_settime(struct timespec *ts, struct timezone *tz)
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 9a2ee84..f476afa 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2049,11 +2049,11 @@ static int selinux_quota_on(struct dentry *dentry)
>  	return dentry_has_perm(cred, NULL, dentry, FILE__QUOTAON);
>  }
>  
> -static int selinux_syslog(int type)
> +static int selinux_syslog(int type, int context)
>  {
>  	int rc;
>  
> -	rc = cap_syslog(type);
> +	rc = cap_syslog(type, context);
>  	if (rc)
>  		return rc;
>  
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 529c9ca..a56ab5c 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -157,12 +157,12 @@ static int smack_ptrace_traceme(struct task_struct *ptp)
>   *
>   * Returns 0 on success, error code otherwise.
>   */
> -static int smack_syslog(int type)
> +static int smack_syslog(int type, int context)
>  {
>  	int rc;
>  	char *sp = current_security();
>  
> -	rc = cap_syslog(type);
> +	rc = cap_syslog(type, context);
>  	if (rc != 0)
>  		return rc;
>  
>   

