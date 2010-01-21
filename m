Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512Ab0AUQRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab0AUQRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:17:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120Ab0AUQRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:17:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0AUQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:17:51 -0500
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v5)
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
In-Reply-To: <20100121160729.GB12842@Krystal>
References: <1263460096.4244.282.camel@laptop>
	 <20100114162609.GC3487@Krystal> <1263488625.4244.333.camel@laptop>
	 <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal>
	 <1263495132.28171.3861.camel@gandalf.stny.rr.com>
	 <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop>
	 <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop>
	 <20100121160729.GB12842@Krystal>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 17:17:17 +0100
Message-ID: <1264090637.4283.1178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 11:07 -0500, Mathieu Desnoyers wrote:
> 
> One efficient way to fit the requirement of sys_membarrier() would be to
> create spin_lock_mb()/spin_unlock_mb(), which would have full memory
> barriers rather than the acquire/release semantic. These could be used
> within schedule() execution. On UP, they would turn into preempt off/on
> and a compiler barrier, just like normal spin locks.
> 
> On architectures like x86, the atomic instructions already imply a full
> memory barrier, so we have a direct mapping and no overhead. On
> architecture where the spin lock only provides acquire semantic (e.g.
> powerpc using lwsync and isync), then we would have to create an
> alternate implementation with "sync". 

There's also clear_tsk_need_resched() which is an atomic op.

The thing I'm worrying about is not making schedule() more expensive for
a relatively rare operation like sys_membarrier(), while at the same
time trying to not make while (1) sys_membarrier() ruin your system.

On x86 there is plenty that implies a full mb before rq->curr = next,
the thing to figure out is what is generally the cheapest place to force
one for other architectures.

Not sure where that leaves us, since I'm not too familiar with !x86.

