Return-Path: <linux-kernel-owner+w=401wt.eu-S965714AbXDEJq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965714AbXDEJq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 05:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965927AbXDEJq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 05:46:58 -0400
Received: from mail.screens.ru ([213.234.233.54]:57491 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965714AbXDEJq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 05:46:57 -0400
Date: Thu, 5 Apr 2007 13:46:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070405094633.GA609@tv-sign.ru>
References: <20070402053457.GA9076@in.ibm.com> <20070402053705.GA12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053705.GA12962@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Gautham R Shenoy wrote:
>
> +/*
> + * Exempt the current process from being frozen for a certain event
> + */
> +static inline void freezer_exempt(unsigned long exempt_freeze_event)
> +{
> +	if (exempt_freeze_event == FE_NONE)
> +		current->flags &= ~PF_FE_ALL;
> +	else
> +		current->flags |= exempt_freeze_event;
> +}

So, a kernel_thread should call freezer_exempt(FE_XXX) somewhere at the
beginning if it doesn't want to be considered as freezeable. But what if
the freezing is already in progress? In that case freezer_exempt() should
somehow clear TIF_FREEZE (if exempt_freeze_event doesn't match freeze_event
parameter of freeze_processes()), otherwise we may hit a nasty bug, much
worse than a freezing failure (which could be restarted).

try_to_freeze_tasks() succeeds because the task is !freezeable(), the
task goes to refrigerator (while it should not), thaw_tasks() ignores
process and it stays frozen.

Alternatively, we can do a re-check in refrigerator() to fix this race.
In any case, it looks like freeze_event should be stored in a global var.

> --- linux-2.6.21-rc5.orig/kernel/sched.c
> +++ linux-2.6.21-rc5/kernel/sched.c
> @@ -5057,6 +5057,7 @@ static int migration_thread(void *data)
>  	BUG_ON(rq->migration_thread != current);
>
>  	set_current_state(TASK_INTERRUPTIBLE);
> +	freezer_exempt(FE_ALL);

This is a real nitpick, but it was hard to me to understand this change.
Because it looks as if we have a subtle reason to set TASK_INTERRUPTIBLE
before freezer_exempt(). Unless I missed something, I'd suggest to move
freezer_exempt() up, before set_current_state().

The same for apm_mainloop().

Oleg.

