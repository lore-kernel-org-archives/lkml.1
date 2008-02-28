Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbYB1Wqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbYB1Wqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYB1Wqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:46:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:47842 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750729AbYB1Wqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:46:42 -0500
Date: Thu, 28 Feb 2008 16:46:37 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, maxk@qualcomm.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Message-Id: <20080228164637.114fb19d.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com>
References: <20080227222103.673194000@chello.nl>
	<20080228075010.GA28781@elte.hu>
	<20080228020808.3fd22f77.pj@sgi.com>
	<20080228090847.GA1133@elte.hu>
	<20080228031710.3405e405.pj@sgi.com>
	<alpine.DEB.1.00.0802280129580.15900@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802280212070.23040@chino.kir.corp.google.com>
	<20080228113728.7b8e5811.pj@sgi.com>
	<alpine.DEB.1.00.0802281309480.24402@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> How about moving watchdog/0 to a cpuset with exclusive access to only cpu 
> 1?

I don't understand your question here.

> >     +	if (unlikely((p->flags & PF_CPU_BOUND) && p != current &&
> >     +	    	     !cpus_subset(p->cpus_allowed, new_mask))) {
> >     +		ret = -EINVAL;
> > 
> 
> That's a convenient way for a kthread to temporarily expand its set of 
> cpus_allowed and then never be able to remove the added cpus again.  Do 
> you have any examples in the tree where a kthread does this?

Good question.  Actually, we -normally- have pinned tasks in the top cpuset,
where the top cpuset allows all CPUs, but the pinned task has a cpus_allowed
(in its task struct) of just one or a few CPUs (for node pinning.)

So ... could we allow moving pinned threads to any cpuset that allowed
the CPUs to which it was pinned (my cpus_subset() test, above), but
-not- change the pinned tasks cpus_allowed in its task struct, keeping
it pinned to just the same one or few CPUs?

> That's why the check in set_cpus_allowed() is
> 
> 	cpus_equal(p->cpus_allowed, newmask)
> 
> since it prevents PF_CPU_BOUND tasks from being moved out of the root 
> cpuset.

I don't think that the cpus_equal() check prevents that (shrinking a
pinned tasks cpuset out from under it.)  Try the following on a freshly
booted system with your proposed patch:

  mkdir /dev/cpuset
  mount -t cpuset cpuset /dev/cpuset
  cd /dev/cpuset
  mkdir a
  cp ???s a
  < tasks sed -un -e p -e 10q > a/tasks

I'll wager you just moved a few pinned tasks into cpuset 'a'.  This
would be allowed, as 'a' has the same cpus as the top cpuset.  But then
one could shrink a (if it had more than 1 CPU in the first place), leaving
some pinned tasks in a cpuset they weren't allowed to run in, essentially
unpinning them.

> PF_CPU_BOUND follows the nomenclature of kthread_bind() really well, but 
> it could probably be confused with a processor-bound task.  So perhaps 
> PF_BOUND_CPU is even better?

Good point - "BOUND" as the past tense of "BIND".  How about
PF_THREAD_BIND ;)?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
