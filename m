Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425Ab0ANRyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab0ANRyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 12:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338Ab0ANRyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 12:54:52 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:59001 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756962Ab0ANRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 12:54:51 -0500
Date: Thu, 14 Jan 2010 12:54:49 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100114175449.GA15387@Krystal>
References: <20100113013757.GA29314@Krystal> <1263400738.4244.242.camel@laptop> <20100113193603.GA27327@Krystal> <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal> <1263488625.4244.333.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1263488625.4244.333.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:39:40 up 29 days,  1:58,  5 users,  load average: 0.26, 0.16,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2010-01-14 at 11:26 -0500, Mathieu Desnoyers wrote:
> 
> > It's this scenario that is causing problem. Let's consider this
> > execution:
> > 

(slightly augmented)

       CPU 0 (membarrier)                  CPU 1 (another mm -> our mm)
       <user-space>
                                           <kernel-space>
                                           switch_mm()
                                             smp_mb()
                                             clear_mm_cpumask()
                                             set_mm_cpumask()
                                             smp_mb() (by load_cr3() on x86)
                                           switch_to()
       memory access before membarrier
       <call sys_membarrier()>
       smp_mb()
       mm_cpumask includes CPU 1
       rcu_read_lock()
       if (CPU 1 mm != our mm)
         skip CPU 1.
       rcu_read_unlock()
       smp_mb()
       <return to user-space>
                                             current = next (1)
                                           <switch back to user-space>
                                           urcu read lock()
                                             read gp
                                             store local gp (2)
                                             barrier()
                                             access critical section data (3)
       memory access after membarrier

So if we don't have any memory barrier between (1) and (3), the memory
operations can be reordered in such a way that CPU 0 will not send IPI
to a CPU that would need to have it's barrier() promoted into a
smp_mb().

> 
> I'm still not getting it, sure we don't send an IPI, but it will have
> done an mb() in switch_mm() to become our mm, so even without the IPI it
> will have executed that mb we were after.

The augmented race window above shows that it would be possible for (2)
and (3) to be reordered across the barrier(), and therefore the critical
section access could spill over a rcu-unlocked state.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
