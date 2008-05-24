Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYEXPc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYEXPc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 11:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYEXPcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 11:32:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:1454 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYEXPcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 11:32:48 -0400
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 24 May 2008 08:32:45 -0700
Message-Id: <1211643165.18130.166.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-24 at 10:55 +0200, Thomas Gleixner wrote:

> Normal futexes have no ordering guarantees at all. There is no
> mechanism to prevent lock stealing from lower priority tasks. So why
> should we care about the once a year case, where a sleepers priority
> is modified ?

Lock stealing? The usage of sched_setscheduler is fairly pervasive in
userspace, if a task becomes SCHED_FIFO it did so via
sched_setscheduler. So I don't think this is at all "once a year". Tasks
shouldn't be forced to determine if a task is sleeping or not before it
calls sched_setscheduler. 

> If you need ordering guarantees then use PI futexes.

There are degree's of overhead with each step.. Someone may not need or
want priority inheritance.

> > +void futex_adjust_waiters(struct task_struct *p)
> > +{
> > +	spin_lock(&p->pi_lock);
> > +		spin_lock(&hb->lock);
> > ...
> > +		spin_unlock(&hb->lock);
> > +	}
> > +	spin_unlock(&p->pi_lock);
> > +}
> 
> vs.
> 
> > @@ -1155,6 +1191,8 @@ static int futex_wait(u32 __user *uaddr,
> {
> ....
>         hb = queue_lock(&q);
> 
> > +	spin_lock(&current->pi_lock);
> > +	current->blocked_on = &blocked_on;
> > +	spin_unlock(&current->pi_lock);
> 
> There are more issues vs. pi futexes as well. The simple case of
> futex_wait() vs. futex_adjust_waiters will just upset lockdep, but
> there are real dealocks vs. unqueue_me_pi waiting.

You mean the lock ordering would cause the deadlock vs. unqueue_me_pi ,
or are you talking about something else?

Daniel

