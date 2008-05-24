Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYEXREQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYEXREQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYEXREF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:04:05 -0400
Received: from www.tglx.de ([62.245.132.106]:55047 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbYEXREE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:04:04 -0400
Date: Sat, 24 May 2008 19:03:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
In-Reply-To: <1211643165.18130.166.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805241852490.3295@apollo.tec.linutronix.de>
References: <20080523042923.594531457@mvista.com>  <20080523042923.916202203@mvista.com>  <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de> <1211643165.18130.166.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Daniel Walker wrote:
> On Sat, 2008-05-24 at 10:55 +0200, Thomas Gleixner wrote:
> 
> > Normal futexes have no ordering guarantees at all. There is no
> > mechanism to prevent lock stealing from lower priority tasks. So why
> > should we care about the once a year case, where a sleepers priority
> > is modified ?
> 
> Lock stealing?

Do you have the faintest idea how the futex code works at all ? There
is no guarantee that the task which is woken up first gets the futex.

A) A task on another CPU can get it independent of its priority
B) In case of multiple waiters wakeup there is no guarantee either

> The usage of sched_setscheduler is fairly pervasive in
> userspace, if a task becomes SCHED_FIFO it did so via
> sched_setscheduler.

Sigh. 

sched_setscheduler is usually done during the startup and not in the
middle of some operation.

> So I don't think this is at all "once a year". Tasks
> shouldn't be forced to determine if a task is sleeping or not before it
> calls sched_setscheduler. 

A sane written program which uses RT priorities does none of this and
I don't care about abstruse use cases at all.

> > If you need ordering guarantees then use PI futexes.
> 
> There are degree's of overhead with each step.. Someone may not need or
> want priority inheritance.

Then there is no need to add this artifical "correctness" at all.

> > There are more issues vs. pi futexes as well. The simple case of
> > futex_wait() vs. futex_adjust_waiters will just upset lockdep, but
> > there are real dealocks vs. unqueue_me_pi waiting.
> 
> You mean the lock ordering would cause the deadlock vs. unqueue_me_pi ,
> or are you talking about something else?

Do I write Chinese or what ?

Thanks,
	tglx
