Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbXHSUKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbXHSUKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 16:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240AbXHSUKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 16:10:05 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:58892 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbXHSUKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 16:10:03 -0400
Date: Mon, 20 Aug 2007 00:10:12 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 5/5] exec: RT sub-thread can livelock and monopolize CPU on exec
Message-ID: <20070819201012.GA113@tv-sign.ru>
References: <20070819083827.GA83@tv-sign.ru> <20070819194552.B9A5E4D058C@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070819194552.B9A5E4D058C@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19, Roland McGrath wrote:
>
> > The group_leader can sleep before it enters exit_notify(). In that case
> > wait_task_inactive() returns, and we still need some polling to wait for
> > EXIT_ZOMBIE.
> 
> It could be a loop as now with yield.  It's still polling, but only one
> poll per wakeup of the target.

I guess I misunderstand you. Do you mean

	de_thread:

		/*
		 * Wait for the thread group leader to be a zombie.
		 * It should already be zombie at this point, most
		 * of the time.
		 */
		while (leader->exit_state != EXIT_ZOMBIE)
			wait_task_inactive(leader);

? This becomes a busy-wait loop if the leader sleeps, wait_task_inactive()
doesn't sleep/yield in this case. Not good.

> > Yes sure. But in any case I think we should avoid polling, we need some
> > notification from exit_notify().
>
> Indeed.

This means we should put something in exit_notify(), like this patch does.
It could be simplified a bit, we don't in fact need a negative ->notify_count,
we can tolerate a false wakeup. We can even skip the "thread_group_leader()"
check for the same reason.

(Of course, we can also add wait_queue_head_t to ->signal, but I don't think
 you have this in mind).

Oleg.

