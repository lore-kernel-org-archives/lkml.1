Return-Path: <linux-kernel-owner+w=401wt.eu-S968292AbXFHHbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968292AbXFHHbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966891AbXFHHTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:19:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56431 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967546AbXFHHTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:19:44 -0400
Date: Fri, 8 Jun 2007 09:18:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 2/4] rt-mutex: Fix chain walk early wakeup bug
Message-ID: <20070608071841.GC30226@elte.hu>
References: <20070607235106.387346000@linutronix.de> <20070607235801.494414000@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070607235801.494414000@linutronix.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> +++ linux-2.6.22-rc4/kernel/rtmutex.c	2007-06-08 01:39:38.000000000 +0200
> @@ -189,6 +189,19 @@ int rt_mutex_adjust_prio_chain(struct ta
>  	if (!waiter || !waiter->task)
>  		goto out_unlock_pi;
>  
> +	/*
> +	 * Check the orig_waiter state. After we dropped the locks,
> +	 * the previous owner of the lock might have released the lock
> +	 * and made us the pending owner:
> +	 */
> +	if (orig_waiter && !orig_waiter->task)
> +		goto out_unlock_pi;
> +
> +	/*
> +	 * Drop out, when the task has no waiters. Note,
> +	 * top_waiter can be NULL, when we are in the deboosting
> +	 * mode!
> +	 */
>  	if (top_waiter && (!task_has_pi_waiters(task) ||
>  			   top_waiter != task_top_pi_waiter(task)))
>  		goto out_unlock_pi;

nice fix! I'm wondering why we never triggered this case with in-kernel 
locks in -rt?

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
