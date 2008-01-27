Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbYA0GAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbYA0GAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYA0GAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:00:21 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750792AbYA0GAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:00:20 -0500
Date: Sat, 26 Jan 2008 22:00:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Wang Nan" <wn.at.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Can any one tell me why cond_resched in do_select?
Message-Id: <20080126220006.21bf443c.akpm@linux-foundation.org>
In-Reply-To: <14344f930801231101w3906aeaey88034e0fa8fa3f36@mail.gmail.com>
References: <14344f930801231101w3906aeaey88034e0fa8fa3f36@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 24 Jan 2008 03:01:53 +0800 "Wang Nan" <wn.at.lkml@gmail.com> wrote:
> Hi, everyone.
> I have a question regarding to select system call's code. In
> do_select() function, after check each fd in the set, do_select() call
> cond_resched(). That line, according to my view, is to reduce the
> system freeze time when do the busy querying. But before the call,
> when entering into the big loop, do_select call
> set_current_state(TASK_INTERRUPTIBLE). Then, if the reschedule really
> taken up, the current process will not return unless it catch a
> signal, or one of already registered fd send an event.
> I've tried in UML. If I replace the cond_resched() into schedule(),
> when sys_select() called, the process halt just like I've said.
> I don't think there is a bug because this code exist so long time and
> no really bad thing happened. I just want to know that, since no
> schedule() allowed here, can we delete the useless line?

It does look a bit odd.  IIRC, cond_resched() is special, in that if it is
called in state TASK_INTERRUPTIBLE it will _not_ return in state
TASK_RUNNING after having called schedule().

Search for PREEMPT_ACTIVE in kernel/sched.c.  See if you can work out what
this code:


	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
				unlikely(signal_pending(prev)))) {
			prev->state = TASK_RUNNING;
		} else {
			deactivate_task(rq, prev, 1);
		}
		switch_count = &prev->nvcsw;
	}

is doing, then send a patch which adds the missing comment :)
