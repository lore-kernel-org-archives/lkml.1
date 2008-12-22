Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbYLVWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbYLVWsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYLVWsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:48:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50814 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbYLVWsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:48:05 -0500
Date: Mon, 22 Dec 2008 23:46:18 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 5/6][v3] Protect cinit from unblocked SIG_DFL
	signals
Message-ID: <20081222224618.GB1536@redhat.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005454.GE5025@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005454.GE5025@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Sukadev Bhattiprolu wrote:
>
> +static int sig_task_unkillable(struct task_struct *t, int same_ns)
> +{
> +	int flags = t->signal->flags;
> +
> +	if (unlikely(flags & SIGNAL_UNKILLABLE) ||
> +			(same_ns && (flags & SIGNAL_UNKILLABLE_FROM_NS)))
> +		return 1;

Hmm. I do not understand the point of the new flag,
SIGNAL_UNKILLABLE_FROM_NS (patch 3/6).

Actually, "same_ns" is a bad name, imho. It actually means "not from
parent ns", and this is not the same as "from the same ns".

Let's suppose we rename it, then the code becomes

	if (unlikely(flags & SIGNAL_UNKILLABLE) ||
		(!parent_ns && (flags & SIGNAL_UNKILLABLE_FROM_NS)))

But, parent_ns == T is not possible for the global init, so why
do we need the extra flag? we can just do

	if (unlikely(flags & SIGNAL_UNKILLABLE) && !parent_ns)
		return 1;

No?

> @@ -867,11 +886,17 @@ static int send_signal(int sig, struct siginfo *info, struct task_struct *t,
>  {
>  	struct sigpending *pending;
>  	struct sigqueue *q;
> +	int same_ns;
>  
>  	trace_sched_signal_send(sig, t);
>  
>  	assert_spin_locked(&t->sighand->siglock);
> -	if (!prepare_signal(sig, t))
> +
> +	same_ns = 1;
> +	if (siginfo_from_ancestor_ns(t, info))
> +		same_ns = 0;

This looks a bit strang, why not

	same_ns = siginfo_from_ancestor_ns(t, info);

?

Oleg.

