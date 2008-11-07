Return-Path: <linux-kernel-owner+w=401wt.eu-S1752353AbYKGVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbYKGVQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYKGVQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:16:33 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:33615 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016AbYKGVQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:16:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcEAA48FElMQWxa/2dsb2JhbACBdshpg1Y
Date: Fri, 7 Nov 2008 16:16:29 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-ID: <20081107211629.GB4847@Krystal>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com> <20081107191833.GA31809@Krystal> <1226086322.31966.67.camel@lappy.programming.kicks-ass.net> <20081107200243.GB32761@Krystal> <20081107204546.GA3324@Krystal> <20081107205411.GG6917@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081107205411.GG6917@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:14:07 up 156 days,  1:54,  7 users,  load average: 0.42, 0.64,
	0.80
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Fri, Nov 07, 2008 at 03:45:46PM -0500, Mathieu Desnoyers wrote:
> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > > * Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> > > > On Fri, 2008-11-07 at 14:18 -0500, Mathieu Desnoyers wrote:
> > > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > > 
> > > > > > On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:
> > > > > > > 
> > > > > > >   __m_cnt_hi
> > > > > > >  is read before
> > > > > > >   mmio cnt_lo read
> > > > > > > 
> > > > > > > for the detailed reasons explained in my previous discussion with
> > > > > > > Nicolas here :
> > > > > > > http://lkml.org/lkml/2008/10/21/1
> > > > > > > 
> > > > > > > I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
> > > > > > > be required so it works also on UP systems safely wrt interrupts).
> > > > > > 
> > > > > > smp_rmb turns into a compiler barrier on UP and should prevent the below
> > > > > > description.
> > > > > > 
> > > > > 
> > > > > Ah, right, preserving program order on UP should be enough. smp_rmb()
> > > > > then.
> > > > 
> > > > 
> > > > I'm not quite sure I'm following here. Is this a global hardware clock
> > > > you're reading from multiple cpus, if so, are you sure smp_rmb() will
> > > > indeed be enough to sync the read?
> > > > 
> > > > (In which case the smp_wmb() is provided by the hardware increasing the
> > > > clock?)
> > > > 
> > > > If these are per-cpu clocks then even in the smp case we'd be good with
> > > > a plain barrier() because you'd only ever want to read your own cpu's
> > > > clock (and have a separate __m_cnt_hi per cpu).
> > > > 
> > > > Or am I totally missing out on something?
> > > > 
> > > 
> > > This is the global hardware clock scenario.
> > > 
> > > We have to order an uncached mmio read wrt a cached variable read/write.
> > > The uncached mmio read vs smp_rmb() barrier (e.g. lfence instruction)
> > > should be insured by program order because the read will skip the cache
> > > and go directly to the bus. Luckily we only do a mmio read and no mmio
> > > write, so mmiowb() is not required.
> > > 
> > > You might be right in that it could require more barriers.
> > > 
> > > Given adequate program order, we can assume the the mmio read will
> > > happen "on the spot", but that the cached read may be delayed.
> > > 
> > > What we want is :
> > > 
> > > readl(io_addr)
> > > read __m_cnt_hi
> > > write __m_cnt_hi
> > > 
> > > With the two reads in the correct order. If we consider two consecutive
> > > executions on the same CPU :
> > > 
> > > readl(io_addr)
> > > read __m_cnt_hi
> > > write __m_cnt_hi
> > > 
> > > readl(io_addr)
> > > read __m_cnt_hi
> > > write __m_cnt_hi
> > > 
> > > We might have to order the read/write pair wrt the following readl, such
> > > as :
> > > 
> > > smp_rmb();  /* Waits for every cached memory reads to complete */
> > > readl(io_addr);
> > > barrier();  /* Make sure the compiler leaves mmio read before cached read */
> > > read __m_cnt_hi
> > > write __m_cnt_hi
> > > 
> > > smp_rmb();  /* Waits for every cached memory reads to complete */
> > > readl(io_addr)
> > > barrier();  /* Make sure the compiler leaves mmio read before cached read */
> > > read __m_cnt_hi
> > > write __m_cnt_hi
> > > 
> > > Would that make more sense ?
> > > 
> > 
> > Oh, actually, I got things reversed in this email : the readl(io_addr)
> > must be done _after_ the __m_cnt_hi read.
> > 
> > Therefore, two consecutive executions would look like :
> > 
> > barrier();  /* Make sure the compiler does not reorder __m_cnt_hi and
> >                previous mmio read. */
> > read __m_cnt_hi
> > smp_rmb();  /* Waits for every cached memory reads to complete */
> 
> If these are MMIO reads, then you need rmb() rather than smp_rmb(),
> at least on architectures that can reorder writes (Power, Itanium,
> and I believe also ARM, ...).
> 
> 						Thanx, Paul
> 


I just dug into the barrier() question at the beginning of the code. I
think it's not necessary after all, because the worse a compiler could
do is probably the following :

Read nr | code

1  read a
1  rmb()
2  read a   <------ ugh. Compiler could decide to prefetch the a value 
                    and only update it if the test is true :(
1  read b
1  if (test b) {
1     write a
2     read a
   }

2  rmb()
2  read b
2  if (test b)
2     write a

But it would not mix the order of a/b reads. So I think just the rmb()
would be enough.

Mathieu


> > readl(io_addr);
> > write __m_cnt_hi
> > 
> > 
> > barrier();  /* Make sure the compiler does not reorder __m_cnt_hi and
> >                previous mmio read. */
> > read __m_cnt_hi
> > smp_rmb();  /* Waits for every cached memory reads to complete */
> > readl(io_addr);
> > write __m_cnt_hi
> > 
> > Mathieu
> > 
> > > Mathieu
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
