Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYEKOWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYEKOWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbYEKOWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:22:25 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43473 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbYEKOWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:22:24 -0400
Date: Sun, 11 May 2008 08:22:23 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511142222.GU19219@parisc-linux.org>
References: <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511135414.GA2328@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511135414.GA2328@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 03:54:14PM +0200, Ingo Molnar wrote:
> the gain is rather obvious: two parallel up()s (or just up()s which come 
> close enough after each other) will wake up two tasks in parallel. With 
> your patch, the first guy wakes up and then it wakes up the second guy. 
> I.e. your patch serializes the wakeup chain, mine keeps it parallel.

Yup.  I explained why that's actually beneficial in an earlier email.

> the cache line dirtying is rather secondary to any solution - the first 
> goal for any locking primitive is to get scheduling precise: to not wake 
> up more tasks than optimal and to not wake up less tasks than optimal.

That's a laudable goal, but ultimately it's secondary to performance (or
this thread wouldn't exist).

> i.e. can you see any conceptual hole in the patch below?

No conceptual holes, just a performance one.

Either we want your patch below or mine; definitely not both.

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 5e41217..e520ad4 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -229,6 +229,11 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 	}
 
 	list_del(&waiter.list);
+
+	/* It's possible we need to wake up the next task on the list too */
+	if (unlikely(sem->count > 1) && !list_empty(&sem->wait_list))
+		__up(sem);
+
 	return ret;
 }
 

> 	Ingo
> 
> ---
>  kernel/semaphore.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux/kernel/semaphore.c
> ===================================================================
> --- linux.orig/kernel/semaphore.c
> +++ linux/kernel/semaphore.c
> @@ -258,5 +258,11 @@ static noinline void __sched __up(struct
>  {
>  	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
>  						struct semaphore_waiter, list);
> +	/*
> +	 * Rotate sleepers - to make sure all of them get woken in case
> +	 * of parallel up()s:
> +	 */
> +	list_move_tail(&waiter->list, &sem->wait_list);
> +
>  	wake_up_process(waiter->task);
>  }

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
