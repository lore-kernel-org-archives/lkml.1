Return-Path: <linux-kernel-owner+w=401wt.eu-S1762754AbXHDLHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762754AbXHDLHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 07:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbXHDLHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 07:07:08 -0400
Received: from mail.screens.ru ([213.234.233.54]:43224 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbXHDLHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 07:07:06 -0400
Date: Sat, 4 Aug 2007 15:07:21 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       "Agarwal, Lomesh" <lomesh.agarwal@intel.com>
Subject: Re: [PATCH] Use ERESTART_RESTARTBLOCK if poll() is interrupted by a signal (was: Re: [PATCH] Use ERESTARTNOHAND if poll() is interrupted by a signal)
Message-ID: <20070804110721.GA83@tv-sign.ru>
References: <200707291705.l6TH554a003344@colorfullife.mysite.adiungo.com> <20070730163538.67b256da.akpm@linux-foundation.org> <46AF9C2D.70808@colorfullife.com> <20070731210817.GA97@tv-sign.ru> <20070804063947.GQ3672@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070804063947.GQ3672@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03, Chris Wright wrote:
>
> +long do_restart_poll(struct restart_block *restart_block)
> +{
> +	struct pollfd __user *ufds = (struct pollfd __user*)restart_block->arg0;
> +	int nfds = restart_block->arg1;
> +	s64 timeout = ((s64)restart_block->arg3<<32) | (s64)restart_block->arg2;
> +	int ret;
> +
> +	restart_block->fn = do_no_restart_syscall;

(just in case, this is not strictly necessary)

> +	ret = do_sys_poll(ufds, nfds, &timeout);
> +	if (ret == -EINTR) {
> +		restart_block->fn = do_restart_poll;
> +		restart_block->arg2 = timeout & 0xFFFFFFFF;
> +		restart_block->arg3 = timeout >> 32;
> +		ret = -ERESTART_RESTARTBLOCK;
> +	}
> +	return ret;
> +}
> +
>  asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
>  			long timeout_msecs)
>  {
>  	s64 timeout_jiffies;
> +	int ret;
>  
>  	if (timeout_msecs > 0) {
>  #if HZ > 1000
> @@ -754,7 +773,20 @@ asmlinkage long sys_poll(struct pollfd __user *ufds, unsigned int nfds,
>  		timeout_jiffies = timeout_msecs;
>  	}
>  
> -	return do_sys_poll(ufds, nfds, &timeout_jiffies);
> +	ret = do_sys_poll(ufds, nfds, &timeout_jiffies);
> +	if (ret == -EINTR) {
> +		if (timeout_msecs > 0) {

This should be "if (timeout_msecs)", a negative timeout means
"wait indefinitely", so we should restart as well.

> +			struct restart_block *restart_block;
> +			restart_block = &current_thread_info()->restart_block;
> +			restart_block->fn = do_restart_poll;
> +			restart_block->arg0 = (unsigned long)ufds;
> +			restart_block->arg1 = nfds;
> +			restart_block->arg2 = timeout_jiffies & 0xFFFFFFFF;
> +			restart_block->arg3 = timeout_jiffies >> 32;

and, in that case, we should use "(u64)timeout_jiffies >> 32".


Small nit: sys_poll() and do_restart_poll() are not "symmetrical", the latter
doesn't check *timeout at all. Either way is correct, restart with zero timeout
means "try again once but doesn't wait".

There is a subtle (but harmless) difference though. Suppose that *timeout == 0
(either because timeout_msecs == 0 or because timeout expiried) and we have a
"false" signal_pending(). In that case sys_poll() returns EINTR, but do_restart_poll()
returns 0.

I was a bit surprized that sys_poll() return EINTR even if timeout expired, but
preserved this behaviour in do_poll-return-eintr-when-signalled.patch.

Perhaps it is better to just remove "if (timeout_msecs > 0)" check from sys_poll().
Then we can modify do_poll() to return EINTR only when !*timeout, to eliminate
unneeded (but correct) restart.

What do you think?

Oleg.

