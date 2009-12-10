Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbZLJCnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbZLJCnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 21:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757842AbZLJCnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 21:43:22 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53738 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754962AbZLJCnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 21:43:19 -0500
Date: Wed, 9 Dec 2009 18:43:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred()
	access
Message-ID: <20091210024324.GH6938@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210004703.029784964@linutronix.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 12:52:51AM -0000, Thomas Gleixner wrote:
> commit c69e8d9 (CRED: Use RCU to access another task's creds and to
> release a task's own creds) added non rcu_read_lock() protected access
> to task creds of the target task in set_prio_one().
> 
> The comment above the function says:
>  * - the caller must hold the RCU read lock
> 
> The calling code in sys_setpriority does read_lock(&tasklist_lock) but
> not rcu_read_lock(). This works only when CONFIG_TREE_PREEMPT_RCU=n.
> With CONFIG_TREE_PREEMPT_RCU=y the rcu_callbacks can run in the tick
> interrupt when they see no read side critical section.
> 
> There is another instance of __task_cred() in sys_setpriority() itself
> which is equally unprotected.
> 
> Wrap the whole code section into a rcu read side critical section to
> fix this quick and dirty.
> 
> Will be revisited in course of the read_lock(&tasklist_lock) -> rcu
> crusade.

OK, I will bite...  Don't the corresponding updates write-hold
tasklist_lock?  If so, then the fact that the code below is read-holding
tasklist_lock would prevent any of the data from changing, which would
remove the need to do the rcu_read_lock().

Or are there updates that are carried out without write-holding
tasklist_lock that I am missing?

							Thanx, Paul

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: David Howells <dhowells@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: linux-security-module@vger.kernel.org
> ---
>  kernel/sys.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6-tip/kernel/sys.c
> ===================================================================
> --- linux-2.6-tip.orig/kernel/sys.c
> +++ linux-2.6-tip/kernel/sys.c
> @@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
>  	if (niceval > 19)
>  		niceval = 19;
> 
> +	rcu_read_lock();
>  	read_lock(&tasklist_lock);
>  	switch (which) {
>  		case PRIO_PROCESS:
> @@ -200,6 +201,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
>  	}
>  out_unlock:
>  	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();
>  out:
>  	return error;
>  }
> 
> 
