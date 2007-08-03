Return-Path: <linux-kernel-owner+w=401wt.eu-S1763546AbXHCUOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763546AbXHCUOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760986AbXHCUOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:14:42 -0400
Received: from mail.screens.ru ([213.234.233.54]:40456 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944AbXHCUOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:14:42 -0400
Date: Sat, 4 Aug 2007 00:14:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       richard kennedy <richard@rsk.demon.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-ID: <20070803201458.GA181@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
>
> Looks like the same problem with spinlock unfairness we've seen
> elsewhere: it seems to be looping here? Or is everyone stuck
> just waiting for writeout?
> 
> lock_timer_base():
>         for (;;) {
>                 tvec_base_t *prelock_base = timer->base;
>                 base = tbase_get_base(prelock_base);
>                 if (likely(base != NULL)) {
>                         spin_lock_irqsave(&base->lock, *flags);
>                         if (likely(prelock_base == timer->base))
>                                 return base;
>                         /* The timer has migrated to another CPU */
>                         spin_unlock_irqrestore(&base->lock, *flags);
>                 }
>                 cpu_relax();
>         }

I don't think there is an unfairness problem. We are looping only
if timer->base changes in between. IOW, there is no "lock + unlock
+ lock(same_lock)" here, we take another lock on each iteration.

And:

>  [<c0407208>] do_IRQ+0xbd/0xd1
>  [<c042ffcb>] lock_timer_base+0x19/0x35
>  [<c04300df>] __mod_timer+0x9a/0xa4
>  [<c060bb55>] schedule_timeout+0x70/0x8f
>
> ...
>
>  [<c0407208>] do_IRQ+0xbd/0xd1
>  [<c042ffcb>] lock_timer_base+0x19/0x35
>  [<c04300df>] __mod_timer+0x9a/0xa4
>  [<c060bb55>] schedule_timeout+0x70/0x8f
>
> ...
>
>  [<c042ffcb>] lock_timer_base+0x19/0x35
>  [<c04300df>] __mod_timer+0x9a/0xa4
>  [<c060bb55>] schedule_timeout+0x70/0x8f

All traces start from schedule_timeout()->mod_timer(). This timer
is local, nobody can see it, its ->base can't be NULL or changed.

This means that lock_timer_base() can't loop, but can't take the
tvec_t_base_s.lock. But in that case the trace should different,
strange.

Oleg.

