Return-Path: <linux-kernel-owner+w=401wt.eu-S1750978AbYKGTdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbYKGTdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 14:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYKGTc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 14:32:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:45573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbYKGTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 14:32:57 -0500
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Howells <dhowells@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Ralf Baechle <ralf@linux-mips.org>, benh@kernel.crashing.org,
       paulus@samba.org, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org
In-Reply-To: <20081107191833.GA31809@Krystal>
References: <20081107053349.861709786@polymtl.ca>
	 <20081107052336.652868737@polymtl.ca> <25257.1226055312@redhat.com>
	 <20081107170902.GD22134@Krystal>
	 <alpine.DEB.1.10.0811071229570.28548@gandalf.stny.rr.com>
	 <20081107191833.GA31809@Krystal>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 20:32:02 +0100
Message-Id: <1226086322.31966.67.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-07 at 14:18 -0500, Mathieu Desnoyers wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Fri, 7 Nov 2008, Mathieu Desnoyers wrote:
> > > 
> > >   __m_cnt_hi
> > >  is read before
> > >   mmio cnt_lo read
> > > 
> > > for the detailed reasons explained in my previous discussion with
> > > Nicolas here :
> > > http://lkml.org/lkml/2008/10/21/1
> > > 
> > > I use smp_rmb() to do this on SMP systems (hrm, actually, a rmb() could
> > > be required so it works also on UP systems safely wrt interrupts).
> > 
> > smp_rmb turns into a compiler barrier on UP and should prevent the below
> > description.
> > 
> 
> Ah, right, preserving program order on UP should be enough. smp_rmb()
> then.


I'm not quite sure I'm following here. Is this a global hardware clock
you're reading from multiple cpus, if so, are you sure smp_rmb() will
indeed be enough to sync the read?

(In which case the smp_wmb() is provided by the hardware increasing the
clock?)

If these are per-cpu clocks then even in the smp case we'd be good with
a plain barrier() because you'd only ever want to read your own cpu's
clock (and have a separate __m_cnt_hi per cpu).

Or am I totally missing out on something?

