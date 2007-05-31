Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbXEaQnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbXEaQnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbXEaQmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:42:52 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46834 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXEaQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:42:51 -0400
Date: Thu, 31 May 2007 22:21:02 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       Nathan Lynch <nathanl@austin.ibm.com>,
       Joel Schopp <jschopp@austin.ibm.com>, Ashok Raj <ashok.raj@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, akpm@linux-foundation.org,
       Dipankar <dipankar@in.ibm.com>
Subject: Re: CPU hotplug: system hang on CPU hot remove during `pfmon --system-wide'
Message-ID: <20070531165102.GB31469@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <87bqg5emqk.wl%takeuchi_satoru@jp.fujitsu.com> <20070528065550.GL6157@in.ibm.com> <alpine.LFD.0.98.0705291347320.26602@woody.linux-foundation.org> <20070530165557.GB1626@in.ibm.com> <alpine.LFD.0.98.0705301000350.26602@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0705301000350.26602@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:03:01AM -0700, Linus Torvalds wrote:
> > and that's where all the problems started - sleepers needing to take that mutex 
> > recursively (which we did/do not support).
> > 
> > 	foo() takes cpu_bitmask_lock and calls
> > 	  foo_bar() which also needs cpu_bitmask_lock
> > 
> > What is a solution to that?
> 
> The solution is to not have crap locking in the first place.

I wish it was that simple wrt cpu hotplug lock :)

It was not just cpufreq which tripped on this locking mess. There was
flush_workqueue and also more recently preempt version of rcu.

	flush_workqueue()
		mutex_lock(&hotplug_lock);	/* we can sleep below */
		for_each_online_cpu()
			flush_cpu_workqueue();
		mutex_unlock(&hotplug_lock);

First problem with this snippet was that a workqueue function for which
we are waiting to be flushed may want to take the same hotplug_lock,
which can deadlock (see http://lkml.org/lkml/2006/12/6/352 for
description of this).

Second problem was : keventd is running flush_workqueue() and one of the
work functions calls flush_workqueue() again which is an attempt to take
hotplug_lock() recursively.

Partly the situation is complex because of the intertwining of
so many subsystem around this one lock. In all cases, encoding two version of
a function, one which takes the hotplug_lock and the other which doesnt take,
is probably an option. IMHO that would just make the source too ugly and
difficult to audit for cpu hotplug safety.

Best would be to go for a lock which supports recursion (and which
avoids other problems inherent with the old mutex based lock) or as
Andrew insisted with the freezer.

> Or, if you absolutely have to, support recursive locking. But the bassic 
> rule should always really be that the need for recursive locking is really 
> a sign of a locking bug in the first place.
> 
> So what's so wrong with just admitting that the locking was crap, and 
> doing it properly? The _proper_ locking doesn't need recursive locks, it 
> just takes the lock at the outer layers, and then does *not* take it 
> internally, because the called routines are called with the lock held and 
> know they are safe.
> 
> We have been able to do that in _every_ single kernel subsystem. What's so 
> special about cpufreq? NOTHING. Except that the code is sometimes horribly 
> bad.

-- 
Regards,
vatsa
