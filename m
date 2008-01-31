Return-Path: <linux-kernel-owner+w=401wt.eu-S1765255AbYAaJ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765255AbYAaJ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbYAaJ3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:29:30 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34758 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574AbYAaJ32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:29:28 -0500
Date: Thu, 31 Jan 2008 12:31:50 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
Message-ID: <20080131093150.GB82@tv-sign.ru>
References: <20080129164019.GA2060@tv-sign.ru> <m1ir1cgfmm.fsf@ebiederm.dsl.xmission.com> <20080130093018.GA88@tv-sign.ru> <m11w7zgocj.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11w7zgocj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
> > On 01/29, Eric W. Biederman wrote:
> >>
> >> Ok. I believe I see what problem you are trying to fix.  That
> >> a pid returned from find_pid might disappear if we are not rcu
> >> protected.
> >
> > Not only.
> >
> > Any find_pid() is unsafe under tasklist, even the find_pid(1).
> > Because free_pid() mangles the pid_hash[hash] while find_pid()
> > scans the same list.
> 
> But we do it the rcu way.
> 
> So it isn't the mangling that is a problem.  Just walking off into
> freed memory.  That is fundamentally the principle that the rcu
> accessors work on.

Yes, this is what I meant.

> >> We currently appear to have two options.
> >> 1) Force all pid hash table access and pid accesses that
> >>    do not get a count to be covered under rcu_read_lock.
> >
> > I agree, we can (and should) convert most of these read_lock(tasklist)'s
> > to rcu_read_lock(). But we have a lot of them.
> 
> We have to touch and recheck all of that code anyway to ensure
> the pid namespace stuff is correct and working well.

Sure.

> >> 2) To modify the locking requirements for free_pid to require
> >>    the tasklist_lock.
> >>
> >>    However this second approach is horribly brittle, as it
> >>    will break if we ever have intermediate entries in the
> >>    hash table protected by pidmap_lock.
> >>
> >> Using the tasklist_lock to still guarantee we see the list, the entire
> >> list, and exactly the list for proper implementation of kill to
> >> process groups and sessions still seems sane.
> >
> > And this means that attach_pid() and detach_pid() need write_lock(tasklist)
> > anyway.
> >
> > So copy_process()->free_pid() is the only case when we modify the pid_hash[]
> > list without tasklist.
> 
> Nope.  alloc_pid does also.

Doesn't matter, inserts are safe. hlist_add_head_rcu() does wmb()
after the full init, and find_pid() has rmb(). We don't really
need rcu_read_lock() to traverse the rcu-protected list as long as
we know the node can't go away.

> The pid_hash table is fundamentally not
> protected by task_lock, but by pidmap_lock.

Until this patch.

> task_list only protects detach (by fluke) and going from struct pid 
> to a task.  It doesn't prevent additions to the hash chains at all.

see above.

> >> - * look up a PID in the hash table. Must be called with the tasklist_lock
> >> - * or rcu_read_lock() held.
> >> + * look up a PID in the hash table. Must be called with the rcu_read_lock()
> > held.
> >
> > Imho, we should first fix all users of read_lock(tasklist)+find_..._pid().
> >
> > So I still think this patch makes sense as a trivial fix for now, until
> > we add the necessary rcu_read_lock()s. However this race is very unlikely,
> > perhaps we can live with it.
> 
> The patch is horrible because it works for all of the wrong reasons,
> and obscures what is really going on.  That can't be good.

Eric, perhaps you misunderstood me. I do agree, the patch is horrible,
I added this awful #ifdef's exactly because this must look as "FIXME!".

Let me explain. Until now, find_pid() under tasklist was legal and documented.
It was actually broken, but happened to work because read_lock() implied
rcu_read_lock(). This patch fixes tasklist+find_pid(), and since PREEMPT_RCU
was merged, imho it could go into 2.6.25.

Now we can change the rules, fix all users, and then revert this hack.

OK. please feel free to do what you think right, but unless you prove
I'm technically wrong I don't understand you. But I won't insist any
longer.

Oleg.

