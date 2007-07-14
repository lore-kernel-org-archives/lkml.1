Return-Path: <linux-kernel-owner+w=401wt.eu-S1765526AbXGNUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765526AbXGNUsZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762325AbXGNUsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:48:18 -0400
Received: from mail.screens.ru ([213.234.233.54]:36757 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761595AbXGNUsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:48:18 -0400
Date: Sun, 15 Jul 2007 00:48:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH -rt 2/5] Thread Migration Preemption - v2
Message-ID: <20070714204841.GA179@tv-sign.ru>
References: <20070714175733.194012000@chello.nl> <20070714175839.641246000@chello.nl> <20070714171646.GB746@tv-sign.ru> <1184438694.5284.69.camel@lappy> <1184440051.5284.72.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184440051.5284.72.camel@lappy>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14, Peter Zijlstra wrote:

> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -288,6 +288,7 @@ struct rq {
>  
>  	struct task_struct *migration_thread;
>  	struct list_head migration_queue;
> +	struct list_head delayed_migration_queue;
>  #endif

I think this could be simplified a bit.

delayed_migration_queue can be a local variable in migration_thread(), then

>  #ifdef CONFIG_SCHEDSTATS
> @@ -5623,6 +5624,11 @@ static int migration_thread(void *data)
>  		head = &rq->migration_queue;
>  
>  		if (list_empty(head)) {
> +			/*
> +			 * we got a wakeup, give the delayed list another shot.
> +			 */
> +			if (current->state != TASK_INTERRUPTIBLE)
> +				list_splice(&rq->delayed_migration_queue, head);

No need to check TASK_INTERRUPTIBLE, just do list_splice() unconditionally and
call schedule().

Oleg.

