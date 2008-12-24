Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYLXP51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYLXP51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbYLXP5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:57:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:51173 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYLXP5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:57:18 -0500
Date: Wed, 24 Dec 2008 16:55:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 7/7][v4] SI_TKILL: Masquerade si_pid when crossing
	pid ns boundary
Message-ID: <20081224155529.GB11593@redhat.com>
References: <20081224114414.GA7879@us.ibm.com> <20081224115331.GG8020@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224115331.GG8020@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24, Sukadev Bhattiprolu wrote:
>
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2385,17 +2385,22 @@ static int do_tkill(pid_t tgid, pid_t pid, int sig)
>  	struct siginfo info;
>  	struct task_struct *p;
>  	unsigned long flags;
> +	struct pid_namespace *ns;
>
>  	error = -ESRCH;
>  	info.si_signo = sig;
>  	info.si_errno = 0;
>  	info.si_code = SI_TKILL;
> -	info.si_pid = task_tgid_vnr(current);
>  	info.si_uid = current_uid();
>
>  	rcu_read_lock();
>  	p = find_task_by_vpid(pid);
>  	if (p && (tgid <= 0 || task_tgid_vnr(p) == tgid)) {
> +		ns = task_active_pid_ns(p);
> +		if (ns)
> +			info.si_pid = task_tgid_nr_ns(current, ns);
> +		else
> +			info.si_pid = task_tgid_vnr(current);

if ns == 0, "p" won't see the signal anyway, so all we need is

	-	info.si_pid = task_tgid_vnr(current);
	+	info.si_pid = task_tgid_nr_ns(current, task_active_ns(p));

like we do in __do_notify().


But. this of course doesn't work for sys_kill(). Can't we change the helpers
which send SI_FROMUSER() signals so that they do not fill .si_pid at all?
Then send_signal() can do:

	default:
		copy_siginfo(&q->info, info);
		info.si_pid = 0;
		if (!from_ancestot_ns)
			info.si_pid = task_tgid_nr_ns(current, ...);

?

Yes, we use "current". But we already used it in siginfo_from_ancestor_ns().

Oleg.

