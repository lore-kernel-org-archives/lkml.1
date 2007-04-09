Return-Path: <linux-kernel-owner+w=401wt.eu-S1750755AbXDIK3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbXDIK3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 06:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752661AbXDIK3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 06:29:44 -0400
Received: from mail.screens.ru ([213.234.233.54]:37248 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbXDIK3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 06:29:43 -0400
Date: Mon, 9 Apr 2007 14:29:22 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] scheduler: first timeslice of the exiting thread
Message-ID: <20070409102922.GA216@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satoru Takeuchi wrote:
>
>   a) On sched_fork, the creator share its timeslice with new process.
>   b) On sched_exit, if the exiting process didn't exhaust its first
>      timeslice yet, it gives its timeslice to the parent.
>
> It has no problem on the process model since the creator is the parent.
> However, on the thread model, the creator is not the parent, it is same
> as the creator's parent. Hence, on this kind of program, the creator
> can't retrieve shared timeslice and exausts its timeslice at a rate of
> knots. In addition, somehow, the parent (typically shell?) gets extra
> timeslice.

Yes, this is an old oddity.

> I believe it's a bug and the exiting process should give its timeslice
> to the creator. Now I have some patch plan to fix this problem as follow:
>
>  a) Add the field for the creator to task_struct. It needs extra memory.

... and locking/complications. The creator may already exited at this time.

>  b) Doesn't add extra field and have thread's parent the creater, which is
>     same as process creation. However it has many side effects, for example,
>     we also need to change sys_getppid() implementation.

can't understand this, sorry.

Ingo, I think sched_exit() has another buglet,

	if (unlikely(p->parent->time_slice > task_timeslice(p)))
		p->parent->time_slice = task_timeslice(p);

should be

	if (unlikely(parent->time_slice > task_timeslice(parent)))
		parent->time_slice = task_timeslice(parent);

The

	[PATCH 1/2] sched_exit: fix parent->time_slice calculation
	http://marc.info/?l=linux-kernel&m=115101842505365

was dropped because "[PATCH 2/2]" was very wrong.

Could you look at it?

Oleg.

