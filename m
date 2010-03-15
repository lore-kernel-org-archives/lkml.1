Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936005Ab0COJMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 05:12:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935894Ab0COJMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 05:12:24 -0400
Date: Mon, 15 Mar 2010 10:09:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Miao Xie <miaox@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] sched/cpusets fixes, more changes are needed
Message-ID: <20100315090958.GA9116@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter.

Unless I missed something, with or without these patches the TASK_WAKING
logic in do_fork() is very broken.

	- do_fork() clears PF_STARTING and then calls wake_up_new_task()
	  which finally does s/WAKING/RUNNING.

	  But. Nobody can take rq->lock in between. This means a signal
	  from irq (quite possible with CLONE_THREAD) or another rt
	  thread which preempts us can lockup.

	- the comment in wake_up_new_task says:
	
		We still have TASK_WAKING but PF_STARTING is gone now, meaning
		->cpus_allowed is stable

	  this is not true. Yes, nobody can take rq->lock _after_ we cleared
	  PF_STARTING, but it is possible that another thread took this lock
	  before and still holds it doing, say, sched_setaffinity().

No?

If yes. I can make a patch, but the question is: what is the point to use
TASK_WAKING in fork pathes? Can't sched_fork() set TASK_RUNNING instead?
Afaics, TASK_RUNNING can equally protect from premature wakeups but doesn't
these PF_STARTING complications.

As for this series. Please review. I don't understand how it is possible
to really test these changes.

Dear cpuset developers! Please review ;) If you don't like 6/6, please make
a better fix. I tried to make as "simple" patch as possible because I hardly
understand cpuset.c, last time I quickly read it a long ago.

Oleg.

