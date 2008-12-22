Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbYLVXA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbYLVXA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 18:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbYLVXAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 18:00:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46118 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYLVXAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 18:00:14 -0500
Date: Mon, 22 Dec 2008 23:58:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, sukadev@us.ibm.com
Subject: Re: [RFC][PATCH 6/6][v3] Protect cinit from blocked fatal signals
Message-ID: <20081222225825.GC1536@redhat.com>
References: <20081221005106.GA4912@us.ibm.com> <20081221005529.GF5025@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081221005529.GF5025@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Sukadev Bhattiprolu wrote:
> 
> +static int sig_unkillable(struct signal_struct *signal, int sig)
> +{
> +	if (signal->flags & SIGNAL_UNKILLABLE_FROM_NS)
> +		return !sig_kernel_only(sig);
> +
> +	/*
> +	 * We must have dropped SIGKILL/SIGSTOP in sig_ignored()
> +	 * TODO: Remove BUG_ON().
> +	 */
> +	BUG_ON(signal->flags & SIGNAL_UNKILLABLE && sig_kernel_only(sig));
> +
> +	return (signal->flags & SIGNAL_UNKILLABLE);
> +}
> +
>  int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
>  			  struct pt_regs *regs, void *cookie)
>  {
> @@ -1907,9 +1943,10 @@ relock:
>
>  		/*
>  		 * Global init gets no signals it doesn't want.
> +		 * Container-init gets no signals it doesn't want from same
> +		 * container.
>  		 */
> -		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
> -		    !signal_group_exit(signal))
> +		if (sig_unkillable(signal, signr) && !signal_group_exit(signal))
>  			continue;

Again, I do not understand why do we need SIGNAL_UNKILLABLE_FROM_NS.

I thought about the change in get_signal_to_deliver() during the
previous discussion, and I think what we need is:

		if (unlikely(signal->flags & SIGNAL_UNKILLABLE) &&
		    !sig_kernel_only(sig))
			continue;

and this was yet another reason for "protect init from unwanted signals more".

Because, if we see SIGKILL/SIGSTOP here, this means that the signal
was sent from the parent ns, or it was generated "internally", for
example by sys_exit_group().

Oleg.

