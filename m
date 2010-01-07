Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090Ab0AGPIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0AGPIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953Ab0AGPIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:08:04 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:40777 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696Ab0AGPIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:08:00 -0500
Date: Thu, 7 Jan 2010 10:07:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Triplett <josh@joshtriplett.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       tglx@linutronix.de, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier
Message-ID: <20100107150758.GA14259@Krystal>
References: <20100107044007.GA22863@Krystal> <1262842854.28171.3710.camel@gandalf.stny.rr.com> <20100107061955.GC25786@Krystal> <20100107063558.GC12939@feather> <1262853855.4049.86.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1262853855.4049.86.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:05:43 up 21 days, 23:24,  6 users,  load average: 0.33, 0.24,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Wed, 2010-01-06 at 22:35 -0800, Josh Triplett wrote:
> > 
> > The number of threads doesn't matter nearly as much as the number of
> > threads typically running at a time compared to the number of
> > processors.  Of course, we can't measure that as easily, but I don't
> > know that your proposed heuristic would approximate it well.
> 
> Quite agreed, and not disturbing RT tasks is even more important.
> 
> A simple:
> 
>   for_each_cpu(cpu, current->mm->cpu_vm_mask) {
>      if (cpu_curr(cpu)->mm == current->mm)
>         smp_call_function_single(cpu, func, NULL, 1);
>   }
> 
> seems far preferable over anything else, if you really want you can use
> a cpumask to copy cpu_vm_mask in and unset bits and use the mask with
> smp_call_function_any(), but that includes having to allocate the
> cpumask, which might or might not be too expensive for Mathieu.
> 

I like this ! :)

Following some testing, I think I'll go with your scheme, with 2
smp_call_function_single (one function call for the local thread, one
IPI). If we need more than that, then we allocate a cpumask and call
smp_call_function_many() for the other cpus. I provide benchmarks in my
reply to Josh justifying this choice.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
