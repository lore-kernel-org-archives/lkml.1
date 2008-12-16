Return-Path: <linux-kernel-owner+w=401wt.eu-S1757870AbYLPQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870AbYLPQZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 11:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbYLPQZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 11:25:35 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:53389 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754826AbYLPQZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 11:25:35 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EAPNgR0lMROB9/2dsb2JhbACBbLxPV4UACIwTgW4IgQk
Date: Tue, 16 Dec 2008 11:25:32 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <christoph@lameter.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: local_add_return
Message-ID: <20081216162532.GA7575@Krystal>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com> <200812161703.00697.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200812161703.00697.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:14:05 up 29 days, 16:54,  3 users,  load average: 0.85, 1.08,
	1.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Tuesday 16 December 2008 00:17:35 Steven Rostedt wrote:
> > Shouldn't local_add_return be a way for archs that can increment a memory 
> > location atomically against interrupts to use that infrastructure? It can 
> > simply fall back to atomic_add_return for those archs that do not have 
> > a lesser equivalent of atomic_add_return.
> 
> local_t was originally introduced (but actually never used for) the
> SNMP counters.  They use two counters to avoid atomics, but as the ancient
> comment says:
> 
> /* 
>  * FIXME: On x86 and some other CPUs the split into user and softirq parts
>  * is not needed because addl $1,memory is atomic against interrupts (but 
>  * atomic_inc would be overkill because of the lock cycles). Wants new 
>  * nonlocked_atomic_inc() primitives -AK
>  */ 
> #define DEFINE_SNMP_STAT(type, name)	\
> 	__typeof__(type) *name[2]
> 
> Then last year Mathieu sent (and Andrew accepted) a "rich set of atomic
> operations", including excellent documentation "local_ops.txt".  Except
> he thought they were atomics, so treated them accordingly.  Also, there
> were no users (you're now the only one).
> 
> But if these new operations are to become the norm, it changes how archs
> should implement local_t.  eg. trivalue becomes less attractive, atomic_long
> more.  x86 has its own implementation so doesn't have these issues.
> 
> Now, I posted a benchmark patch before for archs to test.  I'm interested
> in Sparc64.  Does any arch win from using multiple counters?  PowerPC has
> soft interrupt disable, so that solution wins over atomic_long_t for them.
>

Hi Rusty,

I'd like to comment on your test case found at
http://groups.google.com/group/linux.kernel/msg/98c512fceda26351

Specifically on this comment :

+/* There are three obvious ways to implement local_t on an arch which
+ * can't do single-instruction inc/dec etc.
+ * 1) atomic_long
+ * 2) irq_save/irq_restore
+ * 3) multiple counters.
+ *
+ * This does a very rough benchmark on each one.
+ */ 

Option 3) is not workable for tracers, because it's not safe against
some exceptions (e.g. some hardware errors) nor NMIs. Also, local_t
operations must have preemption disabled before playing on per-cpu data,
which I don't see in your test. This has to be taken into account in the
runtime cost. The "multiple counters" options should also disable
preemption, because a thread being moved to another CPU could corrupt
some other thread's data when being rescheduled.

Only two alternatives does not have this preempt_disable() requirement : 
atomic_long_t and the CPU_OPS work done by Christoph Lameter which use
segments to address the per-cpu data, which effectively removes the need
for disabling preemption around local_t operations because the CPU ID
becomes encoded in a cpu register.

Otherwise, you can be moved to a different CPU between the moment you
read the CPU ID and the moment you access the local data, which can lead
to corruption with local_t and multiple counters options.

Cheers,

Mathieu

> Cheers,
> Rusty.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
