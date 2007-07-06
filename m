Return-Path: <linux-kernel-owner+w=401wt.eu-S1762069AbXGFOje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762069AbXGFOje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 10:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXGFOjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 10:39:23 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:40827 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbXGFOjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 10:39:22 -0400
Date: Fri, 6 Jul 2007 10:34:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
Message-ID: <20070706143409.GB32754@Krystal>
References: <20070705215152.GA4865@Krystal> <468DDD3A.6010308@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <468DDD3A.6010308@yahoo.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:24:52 up 5 days,  9:07,  3 users,  load average: 1.29, 1.14, 0.96
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Nick Piggin (nickpiggin@yahoo.com.au) wrote:
> Mathieu Desnoyers wrote:
> >Thread Migration Preemption
> >
> >This patch adds the ability to protect critical sections from migration to
> >another CPU without disabling preemption.
> >
> >This will be useful to minimize the amount of preemption disabling for the 
> >-rt
> >patch. It will help leveraging improvements brought by the local_t types in
> >asm/local.h (see Documentation/local_ops.txt). Note that the updates done 
> >to
> >variables protected by migration_disable must be either atomic or 
> >protected from
> >concurrent updates done by other threads.
> >
> >Typical use:
> >
> >migration_disable();
> >local_inc(&__get_cpu_var(&my_local_t_var));
> >migration_enable();
> >
> >Which will increment the variable atomically wrt the local CPU.
> >
> >Comments (such as how to integrate this in the already almost full
> >preempt_count) are welcome.
> 
> This seems like way too much stuff to add just for this type of thing. Why
> not just disable and reenable preempt? Surely local_inc is not going to take
> so long that disabling preemption matters.
> 

Disabling preemption seems to cause some discomfort in the RT community.
Steven already noticed that they could leverage migration disabling to
enhance the way they deal with softirqs. Basically, anything that must
be tied to a CPU for a short time, can deal with concurrency from other
threads running on the same CPU, but where we do not want to add to the
scheduler latency would be a good prospect for the migration_disable().

> The task struct is not something we should just be carefree putting crap
> into because it is seemingly free :(
> 

I agree. I added it knowing that we could either pack this in the
preempt_count (using masks, if there is still room, which does not seem
to be the case) or, if not, people who could make extensive use of this
could justify adding this field to the thread_info struct. I am barely
sending the idea out there so it can be helpful for the RT team.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
