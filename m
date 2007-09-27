Return-Path: <linux-kernel-owner+w=401wt.eu-S1756629AbXI0Mbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbXI0Mbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXI0Mbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:31:39 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34373 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbXI0Mbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:31:38 -0400
Message-ID: <46FBA2A4.2040909@fr.ibm.com>
Date: Thu, 27 Sep 2007 14:31:32 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@openvz.org>
CC: Andrew Morton <akpm@osdl.org>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] Move the user namespace under the option
References: <46FA7D4D.8040808@openvz.org> <46FA8087.6060307@openvz.org>
In-Reply-To: <46FA8087.6060307@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov wrote:
> We currently have a CONFIG_USER_NS option. Just rename it 
> into CONFIG_NAMESPACES_EXPERIMANTAL and move the init_user_ns
> into user.c file to make the kernel compile and work without 
> the namespaces support.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>


Acked-by: Cedric Le Goater <clg@fr.ibm.com>

Thanks !

C. 

> ---
> 
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index b5f41d4..dda160c 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -17,7 +17,7 @@ struct user_namespace {
> 
>  extern struct user_namespace init_user_ns;
> 
> -#ifdef CONFIG_USER_NS
> +#ifdef CONFIG_NAMESPACES_EXPERIMENTAL
> 
>  static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
>  {
> diff --git a/init/Kconfig b/init/Kconfig
> index 684ccfb..0db1c3b 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -206,15 +206,6 @@ config TASK_IO_ACCOUNTING
> 
>  	  Say N if unsure.
> 
> -config USER_NS
> -	bool "User Namespaces (EXPERIMENTAL)"
> -	default n
> -	depends on EXPERIMENTAL
> -	help
> -	  Support user namespaces.  This allows containers, i.e.
> -	  vservers, to use user namespaces to provide different
> -	  user info for different servers.  If unsure, say N.
> -
>  config AUDIT
>  	bool "Auditing support"
>  	depends on NET
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 76f782f..5817bfe 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -4,7 +4,7 @@
> 
>  obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
>  	    exit.o itimer.o time.o softirq.o resource.o \
> -	    sysctl.o capability.o ptrace.o timer.o user.o user_namespace.o \
> +	    sysctl.o capability.o ptrace.o timer.o user.o \
>  	    signal.o sys.o kmod.o workqueue.o pid.o \
>  	    rcupdate.o extable.o params.o posix-timers.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
> @@ -50,6 +49,7 @@ obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
>  obj-$(CONFIG_KPROBES) += kprobes.o
>  obj-$(CONFIG_KGDB) += kgdb.o
>  obj-$(CONFIG_NAMESPACES) += utsname.o
> +obj-$(CONFIG_NAMESPACES_EXPERIMENTAL) += user_namespace.o
>  obj-$(CONFIG_SYSFS) += ksysfs.o
>  obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
>  obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
> diff --git a/kernel/user.c b/kernel/user.c
> index b45f55f..d7c0831 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -17,6 +17,15 @@
>  #include <linux/module.h>
>  #include <linux/user_namespace.h>
> 
> +struct user_namespace init_user_ns = {
> +	.kref = {
> +		.refcount	= ATOMIC_INIT(2),
> +	},
> +	.root_user = &root_user,
> +};
> +
> +EXPORT_SYMBOL_GPL(init_user_ns);
> +
>  /*
>   * UID task count cache, to get fast user lookup in "alloc_uid"
>   * when changing user ID's (ie setuid() and friends).
> @@ -199,6 +208,7 @@ void switch_uid(struct user_struct *new_
>  	suid_keys(current);
>  }
> 
> +#ifdef CONFIG_NAMESPACES_EXPERIMENTAL
>  void release_uids(struct user_namespace *ns)
>  {
>  	int i;
> @@ -223,6 +233,7 @@ void release_uids(struct user_namespace 
> 
>  	free_uid(ns->root_user);
>  }
> +#endif
> 
>  static int __init uid_cache_init(void)
>  {
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 7af90fc..4c90062 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -10,17 +10,6 @@
>  #include <linux/nsproxy.h>
>  #include <linux/user_namespace.h>
> 
> -struct user_namespace init_user_ns = {
> -	.kref = {
> -		.refcount	= ATOMIC_INIT(2),
> -	},
> -	.root_user = &root_user,
> -};
> -
> -EXPORT_SYMBOL_GPL(init_user_ns);
> -
> -#ifdef CONFIG_USER_NS
> -
>  /*
>   * Clone a new ns copying an original user ns, setting refcount to 1
>   * @old_ns: namespace to clone
> @@ -84,5 +73,3 @@ void free_user_ns(struct kref *kref)
>  	release_uids(ns);
>  	kfree(ns);
>  }
> -
> -#endif /* CONFIG_USER_NS */
> 
> 

