Return-Path: <linux-kernel-owner+w=401wt.eu-S934435AbXGRQe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435AbXGRQe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 12:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933313AbXGRQeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 12:34:19 -0400
Received: from mail.screens.ru ([213.234.233.54]:39711 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933199AbXGRQeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 12:34:17 -0400
Date: Wed, 18 Jul 2007 20:35:59 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: Q: a bogus task_running() check in try_to_wake_up() ?
Message-ID: <20070718163559.GA837@tv-sign.ru>
References: <20070715153914.GA441@tv-sign.ru> <20070717190548.GB26283@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717190548.GB26283@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > try_to_wake_up:
> > 	
> > 	if (p->se.on_rq)
> > 		goto out_running;
> > 
> > 	...
> > 
> > 	if (unlikely(task_running(rq, p)))
> > 		goto out_activate;
> > 
> > How it possible that rq->curr has on_rq == 0 ?
> > 
> > AFAICS, this can only happen if this task is rq->idle. But idle 
> > threads should not sleep, we have a special "scheduling from the idle 
> > thread!" check in schedule().
> 
> it's also possible if an arch uses __ARCH_WANT_INTERRUPTS_ON_CTXSW, 
> right?

Ah, got it. I guess you meant __ARCH_WANT_UNLOCKED_CTXSW though.

In that case schedule() drops rq->lock before the context switch, but doesn't
clear ->oncpu. So, task_running(p) means we must not activate "p" on another
CPU, otherwise it could be scheduled before the switch-in-progress completes.

Thanks a lot!

Oleg.

