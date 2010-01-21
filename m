Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368Ab0AUQMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0AUQMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226Ab0AUQMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:12:34 -0500
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:55495 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753205Ab0AUQMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:12:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArEEAEEKWEuuWOiG/2dsb2JhbACBRtduhDwE
Date: Thu, 21 Jan 2010 11:07:29 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, josh@joshtriplett.org, tglx@linutronix.de,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100121160729.GB12842@Krystal>
References: <1263460096.4244.282.camel@laptop> <20100114162609.GC3487@Krystal> <1263488625.4244.333.camel@laptop> <20100114175449.GA15387@Krystal> <20100114183739.GA18435@Krystal> <1263495132.28171.3861.camel@gandalf.stny.rr.com> <20100114193355.GA23436@Krystal> <1263926259.4283.757.camel@laptop> <1263928006.4283.762.camel@laptop> <1264073212.4283.1158.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1264073212.4283.1158.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:54:59 up 36 days, 13 min,  4 users,  load average: 0.08, 0.30,
	0.23
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2010-01-19 at 20:06 +0100, Peter Zijlstra wrote:
> > 
> > We could possibly look at placing that assignment in context_switch()
> > between switch_mm() and switch_to(), which should provide a mb before
> > and after I think, Ingo?
> 
> Right, just found out why we cannot do that, the first thing
> context_switch() does is prepare_context_switch() which includes
> prepare_lock_switch() which on __ARCH_WANT_UNLOCKED_CTXSW machines drops
> the rq->lock, and we have to have rq->curr assigned by then.
> 

OK.

One efficient way to fit the requirement of sys_membarrier() would be to
create spin_lock_mb()/spin_unlock_mb(), which would have full memory
barriers rather than the acquire/release semantic. These could be used
within schedule() execution. On UP, they would turn into preempt off/on
and a compiler barrier, just like normal spin locks.

On architectures like x86, the atomic instructions already imply a full
memory barrier, so we have a direct mapping and no overhead. On
architecture where the spin lock only provides acquire semantic (e.g.
powerpc using lwsync and isync), then we would have to create an
alternate implementation with "sync".

We can even create a generic fallback with the following kind of code in
the meantime:

static inline void spin_lock_mb(spinlock_t *lock)
{
	spin_lock(&lock);
	smp_mb();
}

static inline void spin_unlock_mb(spinlock_t *lock)
{
	smp_mb();
	spin_unlock(&lock);
}

How does that sound ?

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
