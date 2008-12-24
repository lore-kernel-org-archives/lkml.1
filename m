Return-Path: <linux-kernel-owner+w=401wt.eu-S1752075AbYLXQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbYLXQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 11:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYLXQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 11:30:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYLXQaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 11:30:12 -0500
Date: Wed, 24 Dec 2008 17:28:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 3/7][v4] Define siginfo_from_ancestor_ns()
Message-ID: <20081224162823.GE11593@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115124.GC8020@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224115124.GC8020@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Sukadev Bhattiprolu wrote:
>
> +#ifdef CONFIG_PID_NS
> +static inline int siginfo_from_user(siginfo_t *info)
> +{
> +	if (!is_si_special(info) && SI_FROMUSER(info) &&
> +				info->si_code != SI_ASYNCIO)
> +		return 1;
> +
> +	return 0;
> +}
> +#else
> +static inline int siginfo_from_user(siginfo_t *info)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static inline int siginfo_from_ancestor_ns(struct task_struct *t,
> +                       siginfo_t *info)
> +{
> +	struct pid_namespace *ns;
> +
> +	/*
> +	 * Ensure signal is from user-space before checking pid namespace
> +	 */
> +	if (siginfo_from_user(info)) {
> +		/*
> +		 * If we do not have a pid in the receiver's namespace,
> +		 * we must be an ancestor of the receiver. 
> +		 *
> +		 * CHECK:
> +		 * 	If receiver is exiting, ns == NULL, signal will be
> +		 * 	queued but ignored (wants_signal() is FALSES). For
> +		 * 	compatibility with current behavior, assume it is
> +		 * 	from ancestor and queue the signal anyway ?
> +		 */
> +		ns = task_active_pid_ns(t);
> +		if (!ns || task_pid_nr_ns(current, ns) <= 0)
> +			return 1;
> +	}
> +
> +	return 0;
> +}

Small nit... siginfo_from_user() is only called by siginfo_from_ancestor_ns().
The first helper depends on CONFIG_PID_NS, the second is not. A bit strange.

Isn't it cleaner to do

	#ifdef CONFIG_PID_NS
	static inline int siginfo_from_user(siginfo_t *info)
	{
		...
	}
	static inline int siginfo_from_ancestor_ns(...)
	{
		...
	}
	#else
	static inline int siginfo_from_ancestor_ns(...)
	{
		return 0;
	}
	#endif

?

> +#ifdef CONFIG_PID_NS
> +/*
> + * siginfo_from_user() assumes that si_code SI_ASYNCIO comes only from
> + * within the kernel. If an application is passing in SI_ASYNCIO we 
> + * want to know about it.
> + */
> +static void warn_on_asyncio(siginfo_t *info)
> +{
> +	WARN_ON_ONCE(info->si_code == SI_ASYNCIO);
> +}
> +#else
> +#define warn_on_asyncio(info)	{}
> +#endif
> +
>  asmlinkage long
>  sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
>  {
> @@ -2324,6 +2388,9 @@ sys_rt_sigqueueinfo(pid_t pid, int sig, siginfo_t __user *uinfo)
>  	   Nor can they impersonate a kill(), which adds source info.  */
>  	if (info.si_code >= 0)
>  		return -EPERM;
> +
> +	warn_on_asyncio(&info);

Hmm... why do you want this? The user-space can use any si_code >= 0,
why should we uglify the code?

And, SI_ASYNCIO only matters when we send the signal to the subnamespace,
and in that case we will probably mangle .si_pid. So why don't we warn
when .si_code == SI_USER?

Oleg.

