Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbYKGVFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbYKGVFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 16:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYKGVEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 16:04:53 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47228 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYKGVEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 16:04:51 -0500
Date: Fri, 7 Nov 2008 16:04:48 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Howells <dhowells@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
In-Reply-To: <20081107205411.GG6917@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0811071602160.3711@gandalf.stny.rr.com>
References: <20081107053349.861709786@polymtl.ca> <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com> <20081107170902.GD22134@Krystal> <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com> <20081107191833.GA31809@Krystal>
 <1226086322.31966.67.camel@lappy.programming.kicks-ass.net> <20081107200243.GB32761@Krystal> <20081107204546.GA3324@Krystal> <20081107205411.GG6917@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 7 Nov 2008, Paul E. McKenney wrote:
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

The read is from a clock source. The only writes that are happening is 
by the clock itself.

On a UP system, is a rmb still needed? That is, can you have two reads on 
the same CPU from the clock source that will produce a backwards clock? 
That to me sounds like the clock interface is broken.

-- Steve
