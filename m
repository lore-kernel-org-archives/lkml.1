Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab0BARNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:13:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:53483 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0BARNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:13:14 -0500
X-Authority-Analysis: v=1.0 c=1 a=db5xdBbprZYA:10 a=7U3hwN5JcxgA:10 a=2udKsfR5-ZkyO9_TTlcA:9 a=WzlONiqCAfxIVp4I5J4z4vw9gXgA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
 switch at runqueue lock/unlock
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <20100201164856.GA3486@Krystal>
References: <20100131205254.407214951@polymtl.ca>
	 <20100131210013.446503342@polymtl.ca>
	 <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain>
	 <20100201160929.GA3032@Krystal>
	 <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
	 <20100201164856.GA3486@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Feb 2010 12:13:12 -0500
Message-ID: <1265044392.29013.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-01 at 11:48 -0500, Mathieu Desnoyers wrote:

> What we have to be careful about here is that it's not enough to just
> rely on switch_mm() containing a memory barrier. What we really need to
> enforce is that switch_mm() issues memory barriers both _before_ and
> _after_ mm_cpumask modification. The "after" part is usually dealt with
> by the TLB context switch, but the "before" part usually isn't.

Then we add a smp_mb__before_clear_bit() in the switch_mm() on all archs
that do not have clear_bit imply a smp_mb().

> 
> > 
> > Btw, one reason to strongly prefer "switch_mm()" over any random context 
> > switch is that at least it won't affect inter-thread (kernel or user-land) 
> > switching, including switching to/from the idle thread.
> > 
> > So I'd be _much_ more open to a "let's guarantee that 'switch_mm()' always 
> > implies a memory barrier" model than to playing clever games with 
> > spinlocks.
> 
> If we really want to make this patch less intrusive, we can consider
> iterating on each online cpu in sys_membarrier() rather than on the
> mm_cpumask. But it comes at the cost of useless cache-line bouncing on
> large machines with few threads running in the process, as we would grab
> the rq locks one by one for all cpus.

I still think modifying the switch_mm() is better than the full
iteration.

-- Steve


