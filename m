Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYK0UGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYK0UGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 15:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYK0UGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 15:06:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60102 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYK0UGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 15:06:35 -0500
Date: Thu, 27 Nov 2008 21:04:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ying Han <yinghan@google.com>
Cc: Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       Matthew Wilcox <matthew@wil.cx>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + make-get_user_pages-interruptible.patch added to -mm tree
Message-ID: <20081127200459.GA25799@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ying Han wrote:
>
> -static int sigkill_pending(struct task_struct *tsk)
> +int sigkill_pending(struct task_struct *tsk)
>  {
>  	return	sigismember(&tsk->pending.signal, SIGKILL) ||
>  		sigismember(&tsk->signal->shared_pending.signal, SIGKILL);
> diff -puN mm/memory.c~make-get_user_pages-interruptible mm/memory.c
> --- a/mm/memory.c~make-get_user_pages-interruptible
> +++ a/mm/memory.c
> @@ -1219,12 +1219,12 @@ int __get_user_pages(struct task_struct 
>  			struct page *page;
>
>  			/*
> -			 * If tsk is ooming, cut off its access to large memory
> -			 * allocations. It has a pending SIGKILL, but it can't
> -			 * be processed until returning to user space.
> +			 * If we have a pending SIGKILL, don't keep
> +			 * allocating memory.
>  			 */
> -			if (unlikely(test_tsk_thread_flag(tsk, TIF_MEMDIE)))
> -				return i ? i : -ENOMEM;
> +			if (unlikely(sigkill_pending(current) ||
> +					sigkill_pending(tsk)))

Please do not export/use sigkill_pending(). It is "private" for ptrace_stop()
(and actually should die imho).

We have fatal_signal_pending() for that.

Oleg.

