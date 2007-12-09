Return-Path: <linux-kernel-owner+w=401wt.eu-S1751759AbXLIQma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbXLIQma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 11:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbXLIQmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 11:42:22 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:58565 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767AbXLIQmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 11:42:21 -0500
Date: Sun, 9 Dec 2007 19:43:11 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] will_become_orphaned_pgrp: we have threads
Message-ID: <20071209164311.GA416@tv-sign.ru>
References: <20071208183800.GA9940@tv-sign.ru> <m11w9wpx03.fsf@ebiederm.dsl.xmission.com> <20071209142116.GB131@tv-sign.ru> <m14perooqx.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m14perooqx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09, Eric W. Biederman wrote:
>
> Equally messed up is a our status in /proc at that point.  Which
> says our sleeping process is a zombie.

Yes, this is annoying.

> I'm thinking we need to do at least some of the thread group leadership
> transfer in do_exit, instead of de_thread.  Then p->group_leader->exit_state
> would be sufficient to see if the entire thread group was alive,
> as the group_leader would be whoever was left alive.  The original
> group_leader might still need to be kept around for it's pid...
>
> I think that would solve most of the problems you have with a dead
> thread group leader and sending SIG_STOP as well.

Yes I was thinking about that too, but I am not brave enough to even
try to to think to the end ;)

As a minimal change, I tried to add "task_struct *leader_proxy" to
signal_struct, which points to the next live thread, and changed by
exit_notify(). eligible_child() checks it instead of ->exit_signal.
But this is so messy...

And in fact, if we are talking about group stop, it is a group operation,
why do_wait() uses per-thread ->exit_code but not ->group_exit_code ?

But yes, [PATCH 3/3] adds a visible difference, and I don't know if
this difference is good or bad.

	$ sleep 1000

	[1]+  Stopped                 sleep 1000
	$ strace -p `pidof sleep`
	Process 432 attached - interrupt to quit

Now strace "hangs" in do_wait() because ->exit_code was eaten by the
shell. We need SIGCONT.

With the "[PATCH 3/3]" strace proceeds happily.

Oleg.

