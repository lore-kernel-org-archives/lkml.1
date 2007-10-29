Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbXJ2Hq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbXJ2Hq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 03:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbXJ2Hqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 03:46:51 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:46400 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbXJ2Hqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 03:46:50 -0400
Message-ID: <472590FC.8070502@openvz.org>
Date: Mon, 29 Oct 2007 10:51:24 +0300
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] pidns: Place under CONFIG_EXPERIMENTAL (take 2)
References: <m1640t3has.fsf@ebiederm.dsl.xmission.com>	<alpine.LFD.0.999.0710261053030.30120@woody.linux-foundation.org> <m1y7dpzn1s.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1y7dpzn1s.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please send namespace related patches to containers@ ML first
before sending them to Linus/Andrew?

Thanks,
Kirill


Eric W. Biederman wrote:
> This is my trivial patch to swat innumerable little bugs
> with a single blow.
> 
> After some intensive review (my apologies for not having
> gotten to this sooner) what we have looks like a good
> base to build on with the current pid namespace code but
> it is not complete, and it is still much to simple to find
> issues where the kernel does the wrong thing outside of
> the initial pid namespace.
> 
> Until the dust settles and we are certain we have the ABI and
> the implementation is as correct as humanly possible let's keep
> process ID namespaces behind CONFIG_EXPERIMENTAL. 
> 
> Allowing us the option of fixing any ABI or other bugs
> we find as long as they are minor.
> 
> Allowing users of the kernel to avoid those bugs simply
> by ensuring their kernel does not have support for multiple
> pid namespaces.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  include/linux/pid_namespace.h |   22 ++++++++++++++++++++++
>  init/Kconfig                  |   12 ++++++++++++
>  kernel/pid.c                  |    2 ++
>  3 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
> index 0135c76..0227e68 100644
> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -29,6 +29,7 @@ struct pid_namespace {
>  
>  extern struct pid_namespace init_pid_ns;
>  
> +#ifdef CONFIG_PID_NS
>  static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
>  {
>  	if (ns != &init_pid_ns)
> @@ -45,6 +46,27 @@ static inline void put_pid_ns(struct pid_namespace *ns)
>  		kref_put(&ns->kref, free_pid_ns);
>  }
>  
> +#else /* !CONFIG_PID_NS */
> +#include <linux/err.h>
> +
> +static inline struct pid_namespace *get_pid_ns(struct pid_namespace *ns)
> +{
> +	return ns;
> +}
> +
> +static inline struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *ns)
> +{
> +	if (flags & CLONE_NEWPID)
> +		ns = ERR_PTR(-EINVAL);
> +	return ns;
> +}
> +
> +static inline void put_pid_ns(struct pid_namespace *ns)
> +{
> +}
> +
> +#endif /* CONFIG_PID_NS */
> +
>  static inline struct pid_namespace *task_active_pid_ns(struct task_struct *tsk)
>  {
>  	return tsk->nsproxy->pid_ns;
> diff --git a/init/Kconfig b/init/Kconfig
> index 8b88d0b..72e37c0 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -215,6 +215,18 @@ config USER_NS
>  	  vservers, to use user namespaces to provide different
>  	  user info for different servers.  If unsure, say N.
>  
> +config PID_NS
> +	bool "PID Namespaces (EXPERIMENTAL)"
> +	default n
> +	depends on EXPERIMENTAL
> +	help
> +	  Suport process id namespaces.  This allows having multiple
> +	  process with the same pid as long as they are in different
> +	  pid namespaces.  This is a building block of containers.
> +
> +	  Unless you want to work with an experimental feature
> +	  say N here.
> +
>  config AUDIT
>  	bool "Auditing support"
>  	depends on NET
> diff --git a/kernel/pid.c b/kernel/pid.c
> index d1db36b..f815455 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -537,6 +537,7 @@ err_alloc:
>  	return NULL;
>  }
>  
> +#ifdef CONFIG_PID_NS
>  static struct pid_namespace *create_pid_namespace(int level)
>  {
>  	struct pid_namespace *ns;
> @@ -621,6 +622,7 @@ void free_pid_ns(struct kref *kref)
>  	if (parent != NULL)
>  		put_pid_ns(parent);
>  }
> +#endif /* CONFIG_PID_NS */
>  
>  void zap_pid_ns_processes(struct pid_namespace *pid_ns)
>  {

