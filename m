Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218Ab0AKWtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab0AKWtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529Ab0AKWs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:48:59 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:46940 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751179Ab0AKWs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:48:58 -0500
Date: Mon, 11 Jan 2010 17:48:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v3a)
Message-ID: <20100111224856.GA18116@Krystal>
References: <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal> <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal> <20100111042903.GC32213@Krystal> <1263232240.4244.70.camel@laptop> <20100111205250.GA6866@Krystal> <1263244757.4244.75.camel@laptop> <20100111220446.GA14937@Krystal> <1263248416.4244.97.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263248416.4244.97.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:29:17 up 26 days,  6:47,  4 users,  load average: 0.33, 0.15,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Mon, 2010-01-11 at 17:04 -0500, Mathieu Desnoyers wrote:
> > * Peter Zijlstra (peterz@infradead.org) wrote:
> > > On Mon, 2010-01-11 at 15:52 -0500, Mathieu Desnoyers wrote:
> > > > 
> > > > So the clear bit can occur far, far away in the future, we don't care.
> > > > We'll just send extra IPIs when unneeded in this time-frame.
> > > 
> > > I think we should try harder not to disturb CPUs, particularly in the
> > > face of RT tasks and DoS scenarios. Therefore I don't think we should
> > > just wildly send to mm_cpumask(), but verify (although speculatively)
> > > that the remote tasks' mm matches ours.
> > > 
> > 
> > Well, my point of view is that if IPI TLB shootdown does not care about
> > disturbing CPUs running other processes in the time window of the lazy
> > removal, why should we ?
> 
> while (1)
>  sys_membarrier();
> 
> is a very good reason, TLB shootdown doesn't have that problem.
> 
> >  We're adding an overhead very close to that of
> > an unrequired IPI shootdown which returns immediately without doing
> > anything.
> 
> Except we don't clear the mask.
> 

Good point. And I'm not so confident that clearing it ourself would be
safe in any way.

> > The tradeoff here seems to be:
> > - more overhead within switch_mm() for more precise mm_cpumask.
> > vs
> > - lazy removal of the cpumask, which implies that some processors
> >   running a different process can receive the IPI for nothing.
> > 
> > I really doubt we could create an IPI DoS based on such a small
> > time window.
> 
> What small window? When there's less runnable tasks than available mm
> contexts some architectures can go quite a long while without
> invalidating TLBs.

OK.

> 
> So what again is wrong with:
> 
>  int cpu, this_cpu = get_cpu();
> 
>  smp_mb(); 
> 
>  for_each_cpu(cpu, mm_cpumask(current->mm)) {
>    if (cpu == this_cpu)
>      continue;
>    if (cpu_curr(cpu)->mm != current->mm)
>      continue;
>    smp_send_call_function_single(cpu, do_mb, NULL, 1);
>  }
> 
>  put_cpu();
> 
> ?
> 

Almost. Missing smp_mb() at the end. We also have to specify that the
smp_mb() we plan to require in switch_mm() should now surround:

- clear mask
- set mask
- ->mm update

Or, for a simpler way to protect ->mm read, we can go with the runqueue
spinlock.

Also, I'd like to use a send-to-many IPI rather than sending to single
CPUs one by one, because the former has a much better scalability for
architectures supporting IPI broadcast. This, however, implies
allocating a temporary cpumask.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
