Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYLXPpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYLXPpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLXPpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:45:08 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbYLXPpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:45:05 -0500
Date: Wed, 24 Dec 2008 16:43:10 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7][v4] SI_USER: Masquerade si_pid when crossing
	pid ns boundary
Message-ID: <20081224154310.GA11593@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115301.GF8020@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224115301.GF8020@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Sukadev Bhattiprolu wrote:
>
> +static void masquerade_si_pid(struct task_struct *t, siginfo_t *info)
> +{
> +	if (is_si_special(info) || SI_FROMKERNEL(info))
> +		return;
> +
> +	/*
> +	 * When crossing pid namespace boundary, SI_USER signal can only
> +	 * go from ancestor to descendant ns but not the other way. So,
> +	 * just ->si_pid to 0 since, the sender will not have a pid in
> +	 * the receiver's namespace.
> +	 */
> +	if (info->si_code == SI_USER)
> +		info->si_pid = 0;
> +}
> +
>  static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group)
>  {
> @@ -946,6 +974,8 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			break;
>  		default:
>  			copy_siginfo(&q->info, info);
> +			if (from_ancestor_ns)
> +				masquerade_si_pid(t, &q->info);
>  			break;
>  		}
>  	} else if (!is_si_special(info)) {
> @@ -2343,7 +2373,7 @@ sys_kill(pid_t pid, int sig)
>  	info.si_signo = sig;
>  	info.si_errno = 0;
>  	info.si_code = SI_USER;
> -	info.si_pid = task_tgid_vnr(current);
> +	info.si_pid = 0;	/* masquerade in send_signal() */
>  	info.si_uid = current_uid();

Can't understand this patch. First of all, it looks wrong. Looks like
we never set .si_pid != 0 when the signal is set by sys_kill() ?

But more importantly, unless I missed something, this patch is unnecessary
complication.

We call masquerade_si_pid() only when from_ancestor_ns == T, this is correct.
But this means that (!is_si_special(info) && SI_FROMUSER(info)) == T, why
do we re-check in masquerade_si_pid() ?

And why can't we just do

	 default:
	 	copy_siginfo(&q->info, info);
	 	if (from_ancestor_ns)
	 		info->si_pid = 0;

? Why should we check SI_USER and change sys_kill() ?

see also the comment for the next 7/7 patch.

Oleg.

