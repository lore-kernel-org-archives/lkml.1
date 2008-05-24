Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbYEXI4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbYEXI4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 04:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbYEXI4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 04:56:09 -0400
Received: from www.tglx.de ([62.245.132.106]:56176 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYEXI4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 04:56:07 -0400
Date: Sat, 24 May 2008 10:55:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
In-Reply-To: <20080523042923.916202203@mvista.com>
Message-ID: <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>
References: <20080523042923.594531457@mvista.com> <20080523042923.916202203@mvista.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Daniel Walker wrote:

> When the plist was added to futexes it added overhead to sort based
> on priority for the futex waiters. If there is a miss order the value of
> this, from my perspective, is lost. Since we don't re-order tasks
> when their priority is changed after they sleep then we get a miss ordered
> scenerio, and tasks aren't woken in priority order.

This is a solution looking for a problem. 

Normal futexes have no ordering guarantees at all. There is no
mechanism to prevent lock stealing from lower priority tasks. So why
should we care about the once a year case, where a sleepers priority
is modified ?

If you need ordering guarantees then use PI futexes.

> This patch corrects this issue, so the tasks are always woken in priority
> order.

The patch corrects a non issue and introduces lock order issues:

> +void futex_adjust_waiters(struct task_struct *p)
> +{
> +	spin_lock(&p->pi_lock);
> +		spin_lock(&hb->lock);
> ...
> +		spin_unlock(&hb->lock);
> +	}
> +	spin_unlock(&p->pi_lock);
> +}

vs.

> @@ -1155,6 +1191,8 @@ static int futex_wait(u32 __user *uaddr,
{
....
        hb = queue_lock(&q);

> +	spin_lock(&current->pi_lock);
> +	current->blocked_on = &blocked_on;
> +	spin_unlock(&current->pi_lock);

There are more issues vs. pi futexes as well. The simple case of
futex_wait() vs. futex_adjust_waiters will just upset lockdep, but
there are real dealocks vs. unqueue_me_pi waiting.

Thanks,
	tglx

