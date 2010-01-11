Return-Path: <linux-kernel-owner+w=401wt.eu-S1752296Ab0AKWV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab0AKWV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 17:21:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134Ab0AKWV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 17:21:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:40544 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0AKWVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 17:21:25 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v3a)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20100111220446.GA14937@Krystal>
References: <20100110052508.GG9044@linux.vnet.ibm.com>
	 <1263124209.28171.3798.camel@gandalf.stny.rr.com>
	 <20100110174512.GH9044@linux.vnet.ibm.com> <20100110182423.GA22821@Krystal>
	 <20100111011705.GJ9044@linux.vnet.ibm.com> <20100111042521.GB32213@Krystal>
	 <20100111042903.GC32213@Krystal> <1263232240.4244.70.camel@laptop>
	 <20100111205250.GA6866@Krystal> <1263244757.4244.75.camel@laptop>
	 <20100111220446.GA14937@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 23:20:16 +0100
Message-ID: <1263248416.4244.97.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-11 at 17:04 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > On Mon, 2010-01-11 at 15:52 -0500, Mathieu Desnoyers wrote:
> > > 
> > > So the clear bit can occur far, far away in the future, we don't care.
> > > We'll just send extra IPIs when unneeded in this time-frame.
> > 
> > I think we should try harder not to disturb CPUs, particularly in the
> > face of RT tasks and DoS scenarios. Therefore I don't think we should
> > just wildly send to mm_cpumask(), but verify (although speculatively)
> > that the remote tasks' mm matches ours.
> > 
> 
> Well, my point of view is that if IPI TLB shootdown does not care about
> disturbing CPUs running other processes in the time window of the lazy
> removal, why should we ?

while (1)
 sys_membarrier();

is a very good reason, TLB shootdown doesn't have that problem.

>  We're adding an overhead very close to that of
> an unrequired IPI shootdown which returns immediately without doing
> anything.

Except we don't clear the mask.

> The tradeoff here seems to be:
> - more overhead within switch_mm() for more precise mm_cpumask.
> vs
> - lazy removal of the cpumask, which implies that some processors
>   running a different process can receive the IPI for nothing.
> 
> I really doubt we could create an IPI DoS based on such a small
> time window.

What small window? When there's less runnable tasks than available mm
contexts some architectures can go quite a long while without
invalidating TLBs.

So what again is wrong with:

 int cpu, this_cpu = get_cpu();

 smp_mb(); 

 for_each_cpu(cpu, mm_cpumask(current->mm)) {
   if (cpu == this_cpu)
     continue;
   if (cpu_curr(cpu)->mm != current->mm)
     continue;
   smp_send_call_function_single(cpu, do_mb, NULL, 1);
 }

 put_cpu();

?

