Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZLJOjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZLJOjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbZLJOjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:39:42 -0500
Received: from www.tglx.de ([62.245.132.106]:40523 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041AbZLJOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:39:41 -0500
Date: Thu, 10 Dec 2009 15:38:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20091210142036.GA8226@redhat.com>
Message-ID: <alpine.LFD.2.00.0912101535560.3089@localhost.localdomain>
References: <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210142036.GA8226@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, Oleg Nesterov wrote:
> On 12/10, Thomas Gleixner wrote:
> >
> > commit c69e8d9 (CRED: Use RCU to access another task's creds and to
> > release a task's own creds) added non rcu_read_lock() protected access
> > to task creds of the target task in set_prio_one().
> >
> > The comment above the function says:
> >  * - the caller must hold the RCU read lock
> >
> > The calling code in sys_setpriority does read_lock(&tasklist_lock) but
> > not rcu_read_lock(). This works only when CONFIG_TREE_PREEMPT_RCU=n.
> > With CONFIG_TREE_PREEMPT_RCU=y the rcu_callbacks can run in the tick
> > interrupt when they see no read side critical section.
> > ...
> > --- linux-2.6-tip.orig/kernel/sys.c
> > +++ linux-2.6-tip/kernel/sys.c
> > @@ -163,6 +163,7 @@ SYSCALL_DEFINE3(setpriority, int, which,
> >  	if (niceval > 19)
> >  		niceval = 19;
> >
> > +	rcu_read_lock();
> >  	read_lock(&tasklist_lock);
> 
> Off-topic, but can't resist...
> 
> This also fixes another bug here. find_task_by_vpid() is not safe
> without rcu_read_lock(). I do not mean it is not safe to use the
> result, just find_pid_ns() by itself is not safe.
> 
> Usually tasklist gives enough protection, but if copy_process() fails
> it calls free_pid() lockless and does call_rcu(delayed_put_pid().
> This means, without rcu lock find_pid_ns() can't scan the hash table
> safely.

I guess we have whole bunch of auditing to do all over the place. And
we definitely need some debugging aid (preferrably a lockdep
extension) which allows us to detect such nasty details.

Thanks,

	tglx
