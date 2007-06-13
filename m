Return-Path: <linux-kernel-owner+w=401wt.eu-S1758954AbXFMPP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758954AbXFMPP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbXFMPPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:15:23 -0400
Received: from mail.screens.ru ([213.234.233.54]:59595 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757686AbXFMPPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:15:22 -0400
Date: Wed, 13 Jun 2007 19:15:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel internal errnos
Message-ID: <20070613151530.GA232@tv-sign.ru>
References: <87hcplvdkl.wl%takeuchi_satoru@jp.fujitsu.com> <20070606105900.DE5E94D0592@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070606105900.DE5E94D0592@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for delay, I was completely offline,

On 06/06, Roland McGrath wrote:
> 
> [PATCH] Restrict clearing TIF_SIGPENDING
> 
> This patch should get a few birds.  It prevents sigaction calls from
> clearing TIF_SIGPENDING in other threads, which could leak -ERESTART*.
> It fixes ptrace_stop not to clear it, which done at the syscall exit
> stop could leak -ERESTART*.  It probably removes the harm from
> signalfd, at least assuming it never calls dequeue_signal on kernel
> threads that might have used block_all_signals.
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  kernel/signal.c |   40 ++++++++++++++++++++++++----------------
>  1 files changed, 24 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index acdfc05..dc5797c 100644  
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -105,7 +105,11 @@ static int recalc_sigpending_tsk(struct 
>  		set_tsk_thread_flag(t, TIF_SIGPENDING);
>  		return 1;
>  	}
> -	clear_tsk_thread_flag(t, TIF_SIGPENDING);
> +	/*
> +	 * We must never clear the flag in another thread, or in current
> +	 * when it's possible the current syscall is returning -ERESTART*.
> +	 * So we don't clear it here, and only callers who know they should do.
> +	 */
>  	return 0;
>  }

This breaks cancel_freezing(). Somehow we should clear TIF_SIGPENDING for
kernel threads. Otherwise we may have subtle failures if try_to_freeze_tasks()
fails.

Also, whith this change do_sigaction()->recalc_sigpending_and_wake() doesn't
make sense any longer, yes?

> @@ -385,7 +391,8 @@ int dequeue_signal(struct task_struct *t
>  			}
>  		}
>  	}
> -	recalc_sigpending_tsk(tsk);
> +	if (likely(tsk == current))
> +		recalc_sigpending();

In theory, flush_signals(t) needs a similar change. However, it is always
called with t == current. Perhaps it makes sense to make it flush_signals(void) ?
Do you see any valid usage of flush_signals(t) when t != current ?

(Actually, imho the same is true for dequeue_signal(). Except for signalfd.c
 dequeue_signal() should operate on current. Perhaps it would be a bit cleaner
 to have dequeue_signal_tsk(tsk) and dequeue_signal(void), the latter does
 recalc_sigpending).

Oleg.

