Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbZBZTSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbZBZTSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 14:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbZBZTSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 14:18:12 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZBZTSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 14:18:12 -0500
Date: Thu, 26 Feb 2009 20:15:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] signals: don't copy siginfo_t on dequeue
Message-ID: <20090226191509.GA6204@redhat.com>
References: <20090226184433.GA15644@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226184433.GA15644@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, Vegard Nossum wrote:
>
> Instead of copying the siginfo_t whenever a signal is dequeued, just
> get the pointer to the struct sigqueue, which can be freed by the
> caller when the signal has been delivered.

Yes, it would bi nice. But it is not that simple,

> -static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
> +static struct sigqueue *collect_signal(int sig, struct sigpending *list)
>  {
>  	struct sigqueue *q, *first = NULL;
>  
> @@ -377,40 +377,29 @@ static void collect_signal(int sig, struct sigpending *list, siginfo_t *info)
>  	if (first) {
>  still_pending:
>  		list_del_init(&first->list);
> -		copy_siginfo(info, &first->info);
> -		__sigqueue_free(first);
> -	} else {
> -		/* Ok, it wasn't in the queue.  This must be
> -		   a fast-pathed signal or we must have been
> -		   out of queue space.  So zero out the info.
> -		 */
> -		info->si_signo = sig;
> -		info->si_errno = 0;
> -		info->si_code = 0;
> -		info->si_pid = 0;
> -		info->si_uid = 0;
>  	}
> +
> +	return first;
>  }
>  
> -static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
> -			siginfo_t *info)
> +static struct sigqueue *__dequeue_signal(struct sigpending *pending,
> +	sigset_t *mask)
>  {
>  	int sig = next_signal(pending, mask);
>  
> -	if (sig) {
> -		if (current->notifier) {
> -			if (sigismember(current->notifier_mask, sig)) {
> -				if (!(current->notifier)(current->notifier_data)) {
> -					clear_thread_flag(TIF_SIGPENDING);
> -					return 0;
> -				}
> +	if (!sig)
> +		return NULL;
> +
> +	if (current->notifier) {
> +		if (sigismember(current->notifier_mask, sig)) {
> +			if (!(current->notifier)(current->notifier_data)) {
> +				clear_thread_flag(TIF_SIGPENDING);
> +				return 0;
>  			}
>  		}
> -
> -		collect_signal(sig, pending, info);
>  	}
>  
> -	return sig;
> +	return collect_signal(sig, pending);

So. dequeue_signal() returns NULL if there is no siginfo queued. In that
case we assume that the signal is not pending.

But this is not right. Think about SEND_SIG_FORCED, or __sigqueue_alloc()
failure when the signal is sent. Or look at zap_other_threads() for example,
it just sets the bit in ->pending but doesn't queue siginfo.

Oleg.

