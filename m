Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0BAQtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:49:00 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:36053 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127Ab0BAQs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:48:59 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAPqRZktGHnlj/2dsb2JhbACBM9kmhEUE
Date: Mon, 1 Feb 2010 11:48:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
	switch at runqueue lock/unlock
Message-ID: <20100201164856.GA3486@Krystal>
References: <20100131205254.407214951@polymtl.ca> <20100131210013.446503342@polymtl.ca> <alpine.LFD.2.00.1002010722350.4206@localhost.localdomain> <20100201160929.GA3032@Krystal> <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002010816030.4206@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:42:10 up 47 days,  1:00,  5 users,  load average: 0.20, 0.14,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Mon, 1 Feb 2010, Mathieu Desnoyers wrote:
> > 
> > However, this does not deal with mm_cpumask update, and we cannot use
> > the per-cpu rq lock, as it's a process-wide data structure updated with
> > clear_bit/set_bit in switch_mm(). So at the very least, we would have to
> > add memory barriers in switch_mm() on some architectures to deal with
> > this.
> 
> I'd much rather have a "switch_mm()" is a guaranteed memory barrier logic, 
> because quite frankly, I don't see how it ever couldn't be one anyway. It 
> fundamentally needs to do at least a TLB context switch (which may be just 
> switching an ASI around, not flushing the whole TLB, of course), and I bet 
> that for 99% of all architectures, that is already pretty much guaranteed 
> to be equivalent to a memory barrier.
> 
> It certainly is for x86. "mov to cr0" is serializing (setting any control 
> register except cr8 is serializing). And I strongly suspect other 
> architectures will be too.

What we have to be careful about here is that it's not enough to just
rely on switch_mm() containing a memory barrier. What we really need to
enforce is that switch_mm() issues memory barriers both _before_ and
_after_ mm_cpumask modification. The "after" part is usually dealt with
by the TLB context switch, but the "before" part usually isn't.

> 
> Btw, one reason to strongly prefer "switch_mm()" over any random context 
> switch is that at least it won't affect inter-thread (kernel or user-land) 
> switching, including switching to/from the idle thread.
> 
> So I'd be _much_ more open to a "let's guarantee that 'switch_mm()' always 
> implies a memory barrier" model than to playing clever games with 
> spinlocks.

If we really want to make this patch less intrusive, we can consider
iterating on each online cpu in sys_membarrier() rather than on the
mm_cpumask. But it comes at the cost of useless cache-line bouncing on
large machines with few threads running in the process, as we would grab
the rq locks one by one for all cpus.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
