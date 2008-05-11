Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbYEKLDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbYEKLDS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbYEKLDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:03:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:45480 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYEKLDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:03:08 -0400
Date: Sun, 11 May 2008 05:03:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>, Sven Wegener <sven.wegener@stealer.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511110306.GP19219@parisc-linux.org>
References: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu> <20080508122802.GA4880@elte.hu> <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508151028.GA12109@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 05:10:28PM +0200, Ingo Molnar wrote:
> @@ -258,7 +256,5 @@ static noinline void __sched __up(struct semaphore *sem)
>  {
>  	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
>  						struct semaphore_waiter, list);
> -	list_del(&waiter->list);
> -	waiter->up = 1;
>  	wake_up_process(waiter->task);
>  }

This might be the problem that causes the missing wakeups.  If you have a
semaphore with n=2, and four processes calling down(), tasks A and B
acquire the semaphore and tasks C and D go to sleep.  Task A calls up()
and wakes up C.  Then task B calls up() and doesn't wake up anyone
because C hasn't run yet.  I think we need another wakeup when task C
finishes in __down_common, like this (on top of your patch):

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
 
Sven, can you try this with your workload?  I suspect this might be it
because XFS does use semaphores with n>1.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
