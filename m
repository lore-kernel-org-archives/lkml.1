Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612AbYKLQxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbYKLQxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYKLQxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:53:23 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:34513 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYKLQxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:53:22 -0500
Date: Wed, 12 Nov 2008 10:53:19 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: sukadev@linux.vnet.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, daniel@hozac.com,
       Nadia Derbey <Nadia.Derbey@bull.net>, clg@fr.ibm.com,
       Containers <containers@lists.osdl.org>, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: Signals to cinit
Message-ID: <20081112165319.GC14572@us.ibm.com>
References: <20081101180505.GA24268@us.ibm.com> <20081110173839.GA11121@redhat.com> <20081110193228.GA15519@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081110193228.GA15519@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> --- K-IS/kernel/signal.c~T	2008-11-10 19:21:17.000000000 +0100
> +++ K-IS/kernel/signal.c	2008-11-10 20:31:24.000000000 +0100
> @@ -798,11 +798,19 @@ static inline int legacy_queue(struct si
>  	return (sig < SIGRTMIN) && sigismember(&signals->signal, sig);
>  }
> 
> +#define SIG_FROM_USER	INT_MIN		/* MSB */
> +
>  static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  			int group)
>  {
>  	struct sigpending *pending;
>  	struct sigqueue *q;
> +	int from_ancestor_ns;
> +
> +	from_ancestor_ns = !is_si_special(info) &&
> +		(info->si_signo | SIG_FROM_USER) &&

I assume you mean '&'?

> +		/* if t can't see us we are from parent ns */
> +		task_pid_nr_ns(current, t->current->nsproxy->pid_ns) <= 0;

This doesn't look so bad...  (but still looking through followup emails)

-serge
