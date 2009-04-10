Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZDJMNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZDJMNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755847AbZDJMMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:12:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38311 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZDJMMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:12:48 -0400
Date: Fri, 10 Apr 2009 14:12:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] lockdep: warn about lockdep disabling after kernel
	taint
Message-ID: <20090410121243.GO21506@elte.hu>
References: <1239312460-13396-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239312460-13396-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: provide useful missing info for developers
> 
> Kernel taint can occur in several situations such as warnings,
> load of prorietary or staging modules, bad page, etc...
> 
> But when such taint happens, a developer might still be working on
> the kernel, expecting that lockdep is still enabled. But a taint
> disables lockdep without ever warning about it.
> Such a kernel behaviour doesn't really help for kernel development.
> 
> This patch adds this missing warning.
> 
> Since the taint is done most of the time after the main message that
> explain the real source issue, it seems safe to warn about it inside
> add_taint() so that it appears at last, without hurting the main
> information.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 3fd8c5b..9e7420a 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -213,8 +213,14 @@ unsigned long get_taint(void)
>  
>  void add_taint(unsigned flag)
>  {
> -	/* can't trust the integrity of the kernel anymore: */
> -	debug_locks = 0;
> +	/*
> +	 * Can't trust the integrity of the kernel anymore.
> +	 * We don't call directly debug_locks_off() because the issue
> +	 * is not necessarily serious enough to set oops_in_progress to 1
> +	 */
> +	if (xchg(&debug_locks, 0))
> +		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
> +

nice idea - but please use the proper debug_locks_off() construct 
instead of an open-coded xchg(). Something like:

	if (debug_locks_off())
		printk(...);

should do the trick.

	Ingo
