Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZLJO0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZLJO0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZLJO0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:26:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbZLJO0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:26:49 -0500
Date: Thu, 10 Dec 2009 15:20:36 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred()
	access
Message-ID: <20091210142036.GA8226@redhat.com>
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210004703.029784964@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Thomas Gleixner wrote:
>
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
> ...
> --- linux-2.6-tip.orig/kernel/sys.c
> +++ linux-2.6-tip/kernel/sys.c
> @@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
>  	if (niceval > 19)
>  		niceval = 19;
>
> +	rcu_read_lock();
>  	read_lock(&tasklist_lock);

Off-topic, but can't resist...

This also fixes another bug here. find_task_by_vpid() is not safe
without rcu_read_lock(). I do not mean it is not safe to use the
result, just find_pid_ns() by itself is not safe.

Usually tasklist gives enough protection, but if copy_process() fails
it calls free_pid() lockless and does call_rcu(delayed_put_pid().
This means, without rcu lock find_pid_ns() can't scan the hash table
safely.

Oleg.

