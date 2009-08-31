Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZHaTIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZHaTIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 15:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbZHaTIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 15:08:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753853AbZHaTIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 15:08:12 -0400
Subject: Re: [PATCH 2/6] SECURITY: add task_struct to setrlimit
From: Eric Paris <eparis@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: akpm@linux-foundation.org, mingo@redhat.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       eparis@redhat.com, sds@tycho.nsa.gov
In-Reply-To: <1251744974-29398-2-git-send-email-jirislaby@gmail.com>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com>
	 <1251744974-29398-2-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 15:07:33 -0400
Message-Id: <1251745653.2158.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-31 at 20:56 +0200, Jiri Slaby wrote:
> Add task_struct to task_setrlimit of security_operations to be able to set
> rlimit of different task than current.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Eric Paris <eparis@parisplace.org>

It looks ok to me.  We still seem to have complete SELinux control and I
don't see that you missed anything elsewhere in the security subsystem.

Acked-by: Eric Paris <eparis@redhat.com>


> ---
>  include/linux/security.h |    9 ++++++---
>  kernel/sys.c             |    2 +-
>  security/capability.c    |    3 ++-
>  security/security.c      |    5 +++--
>  security/selinux/hooks.c |    7 ++++---
>  5 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 0f81525..880a21c 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -1520,7 +1520,8 @@ struct security_operations {
>  	int (*task_setnice) (struct task_struct *p, int nice);
>  	int (*task_setioprio) (struct task_struct *p, int ioprio);
>  	int (*task_getioprio) (struct task_struct *p);
> -	int (*task_setrlimit) (unsigned int resource, struct rlimit *new_rlim);
> +	int (*task_setrlimit) (struct task_struct *p, unsigned int resource,
> +			struct rlimit *new_rlim);
>  	int (*task_setscheduler) (struct task_struct *p, int policy,
>  				  struct sched_param *lp);
>  	int (*task_getscheduler) (struct task_struct *p);
> @@ -1775,7 +1776,8 @@ int security_task_setgroups(struct group_info *group_info);
>  int security_task_setnice(struct task_struct *p, int nice);
>  int security_task_setioprio(struct task_struct *p, int ioprio);
>  int security_task_getioprio(struct task_struct *p);
> -int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim);
> +int security_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim);
>  int security_task_setscheduler(struct task_struct *p,
>  				int policy, struct sched_param *lp);
>  int security_task_getscheduler(struct task_struct *p);
> @@ -2385,7 +2387,8 @@ static inline int security_task_getioprio(struct task_struct *p)
>  	return 0;
>  }
>  
> -static inline int security_task_setrlimit(unsigned int resource,
> +static inline int security_task_setrlimit(struct task_struct *p,
> +					  unsigned int resource,
>  					  struct rlimit *new_rlim)
>  {
>  	return 0;
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a7e36b6..ae7be2e 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1254,7 +1254,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
>  	if (resource == RLIMIT_NOFILE && new_rlim.rlim_max > sysctl_nr_open)
>  		return -EPERM;
>  
> -	retval = security_task_setrlimit(resource, &new_rlim);
> +	retval = security_task_setrlimit(current, resource, &new_rlim);
>  	if (retval)
>  		return retval;
>  
> diff --git a/security/capability.c b/security/capability.c
> index 6c38f4d..90d6daf 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -447,7 +447,8 @@ static int cap_task_getioprio(struct task_struct *p)
>  	return 0;
>  }
>  
> -static int cap_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
> +static int cap_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim)
>  {
>  	return 0;
>  }
> diff --git a/security/security.c b/security/security.c
> index 0b7f9eb..b2c21dc 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -779,9 +779,10 @@ int security_task_getioprio(struct task_struct *p)
>  	return security_ops->task_getioprio(p);
>  }
>  
> -int security_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
> +int security_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim)
>  {
> -	return security_ops->task_setrlimit(resource, new_rlim);
> +	return security_ops->task_setrlimit(p, resource, new_rlim);
>  }
>  
>  int security_task_setscheduler(struct task_struct *p,
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 496e626..839622a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3355,16 +3355,17 @@ static int selinux_task_getioprio(struct task_struct *p)
>  	return current_has_perm(p, PROCESS__GETSCHED);
>  }
>  
> -static int selinux_task_setrlimit(unsigned int resource, struct rlimit *new_rlim)
> +static int selinux_task_setrlimit(struct task_struct *p, unsigned int resource,
> +		struct rlimit *new_rlim)
>  {
> -	struct rlimit *old_rlim = current->signal->rlim + resource;
> +	struct rlimit *old_rlim = p->signal->rlim + resource;
>  
>  	/* Control the ability to change the hard limit (whether
>  	   lowering or raising it), so that the hard limit can
>  	   later be used as a safe reset point for the soft limit
>  	   upon context transitions.  See selinux_bprm_committing_creds. */
>  	if (old_rlim->rlim_max != new_rlim->rlim_max)
> -		return current_has_perm(current, PROCESS__SETRLIMIT);
> +		return current_has_perm(p, PROCESS__SETRLIMIT);
>  
>  	return 0;
>  }


