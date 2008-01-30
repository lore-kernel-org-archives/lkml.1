Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYA3D3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYA3D3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 22:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbYA3D2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 22:28:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42521 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbYA3DZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 22:25:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
References: <20080129164019.GA2060@tv-sign.ru>
Date: Tue, 29 Jan 2008 20:24:17 -0700
In-Reply-To: <20080129164019.GA2060@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 29 Jan 2008 19:40:19 +0300")
Message-ID: <m1ir1cgfmm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> With CONFIG_PREEMPT_RCU read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
> but find_pid_ns()->hlist_for_each_entry_rcu() should be safe under tasklist.
>
> Usually it is, detach_pid() is always called under write_lock(tasklist_lock),
> but copy_process() calls free_pid() lockless.
>
> "#ifdef CONFIG_PREEMPT_RCU" is added mostly as documentation, perhaps it is
> too ugly and should be removed.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
>
> --- MM/kernel/fork.c~PR_RCU	2008-01-27 17:09:47.000000000 +0300
> +++ MM/kernel/fork.c	2008-01-29 19:23:44.000000000 +0300
> @@ -1335,8 +1335,19 @@ static struct task_struct *copy_process(
>  	return p;
>  
>  bad_fork_free_pid:
> -	if (pid != &init_struct_pid)
> +	if (pid != &init_struct_pid) {
> +#ifdef CONFIG_PREEMPT_RCU
> +		/*
> +		 * read_lock(tasklist_lock) doesn't imply rcu_read_lock(),
> +		 * make sure find_pid() is safe under read_lock(tasklist).
> +		 */
> +		write_lock_irq(&tasklist_lock);
> +#endif
>  		free_pid(pid);
> +#ifdef CONFIG_PREEMPT_RCU
> +		write_unlock_irq(&tasklist_lock);
> +#endif
> +	}
>  bad_fork_cleanup_namespaces:
>  	exit_task_namespaces(p);
>  bad_fork_cleanup_keys:

Ok. I believe I see what problem you are trying to fix.  That
a pid returned from find_pid might disappear if we are not rcu
protected.

This patch in the simplest form is wrong because it is confusing.

We currently appear to have two options.
1) Force all pid hash table access and pid accesses that
   do not get a count to be covered under rcu_read_lock.
2) To modify the locking requirements for free_pid to require
   the tasklist_lock.

   However this second approach is horribly brittle, as it
   will break if we ever have intermediate entries in the
   hash table protected by pidmap_lock.

Using the tasklist_lock to still guarantee we see the list, the entire
list, and exactly the list for proper implementation of kill to
process groups and sessions still seems sane.

So let's just remove the guarantee of find_pid being usable with
just the tasklist_lock held.

Eric

diff --git a/include/linux/pid.h b/include/linux/pid.h
index e29a900..0ffb8cc 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -100,8 +100,7 @@ struct pid_namespace;
 extern struct pid_namespace init_pid_ns;
 
 /*
- * look up a PID in the hash table. Must be called with the tasklist_lock
- * or rcu_read_lock() held.
+ * look up a PID in the hash table. Must be called with the rcu_read_lock() held.
  *
  * find_pid_ns() finds the pid in the namespace specified
  * find_pid() find the pid by its global id, i.e. in the init namespace
