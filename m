Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYJAOel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYJAOel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 10:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbYJAOec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 10:34:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbYJAOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 10:34:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0809282123100.3635@xanadu.home>
References: <alpine.LFD.2.00.0809282123100.3635@xanadu.home> <20080924164826.14867.63020.stgit@warthog.procyon.org.uk> <1222426580.16700.258.camel@lappy.programming.kicks-ass.net> <alpine.LFD.2.00.0809260802310.3635@xanadu.home> <1222431635.16700.278.camel@lappy.programming.kicks-ass.net>
To: Nicolas Pitre <nico@cam.org>
Cc: dhowells@redhat.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
Date: Wed, 01 Oct 2008 15:34:10 +0100
Message-ID: <29968.1222871650@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nico@cam.org> wrote:

> Disabling preemption is unneeded.

I think you may be wrong on that.  MEI came up with the following point:

	I think either disable preemption or disable interrupt is really
	necessary for cnt32_to_63 macro, because there seems to be assumption
	that the series of the code (1)-(4) must be executed within a half
	period of the 32-bit counter.

	-------------------------------------------------
	#define cnt32_to_63(cnt_lo) 
	({ 
	       static volatile u32 __m_cnt_hi = 0; 
	       cnt32_to_63_t __x; 
	(1)    __x.hi = __m_cnt_hi; 
	(2)    __x.lo = (cnt_lo); 
	(3)    if (unlikely((s32)(__x.hi ^ __x.lo) < 0))
	(4)            __m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); 
	       __x.val; 
	})
	-------------------------------------------------

	If a task is preempted while executing the series of the code and
	scheduled again after the half period of the 32-bit counter, the task
	may destroy __m_cnt_hi.

Their suggested remedy is:

	So I think it's better to disable interrupt the cnt32_to_63 and to
	ensure that the series of the code are executed within a short period.

I think this is excessive...  If we're sat there with interrupts disabled for
more than a half period (65s) then we've got other troubles.  I think
disabling preemption for the duration ought to be enough.  What do you think?

Now, I'm happy to put these in sched_clock() rather then cnt32_to_63() for my
purposes (see attached patch).

David
---
MN10300: Prevent cnt32_to_63() from being preempted in sched_clock()

From: David Howells <dhowells@redhat.com>

Prevent cnt32_to_63() from being preempted in sched_clock() because it may
read its internal counter, get preempted, get delayed for more than the half
period of the 'TSC' and then write the internal counter, thus corrupting it.

Whilst some callers of sched_clock() have interrupts disabled or hold
spinlocks, not all do, and so preemption must be held here.

Note that sched_clock() is called from lockdep, but that shouldn't be a problem
because although preempt_disable() calls into lockdep, lockdep has a recursion
counter to deal with this.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/time.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index e460658..38f88bb 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -55,6 +55,9 @@ unsigned long long sched_clock(void)
 	unsigned long tsc, tmp;
 	unsigned product[3]; /* 96-bit intermediate value */
 
+	/* cnt32_to_63() is not safe with preemption */
+	preempt_disable();
+
 	/* read the TSC value
 	 */
 	tsc = 0 - get_cycles(); /* get_cycles() counts down */
@@ -65,6 +68,8 @@ unsigned long long sched_clock(void)
 	 */
 	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
 
+	preempt_enable();
+
 	/* scale the 64-bit TSC value to a nanosecond value via a 96-bit
 	 * intermediate
 	 */
