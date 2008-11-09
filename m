Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYKIF2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYKIF2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 00:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYKIF2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 00:28:00 -0500
Received: from relais.videotron.ca ([24.201.245.36]:49534 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbYKIF2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 00:28:00 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Sun, 09 Nov 2008 00:27:53 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       lkml <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>,
       benh@kernel.crashing.org, paulus@samba.org,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, linux-arch@vger.kernel.org
Subject: [PATCH v2] clarify usage expectations for cnt32_to_63()
In-reply-to: <alpine.LFD.2.00.0811082356090.13034@xanadu.home>
Message-id: <alpine.LFD.2.00.0811090015570.13034@xanadu.home>
References: <20081106220530.5b0e3a96.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0811070256450.13034@xanadu.home>
 <25363.1226056819@redhat.com> <20081107164758.GB22134@Krystal>
 <20081107201118.GB28600@flint.arm.linux.org.uk>
 <20081107213610.GC2654@Krystal> <9405.1226101315@redhat.com>
 <20081108001555.GE18378@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.0811080939180.13034@xanadu.home>
 <alpine.LFD.2.00.0811081746060.13034@xanadu.home>
 <20081109022549.GA18508@Krystal>
 <alpine.LFD.2.00.0811082143320.13034@xanadu.home>
 <alpine.LFD.2.00.0811082356090.13034@xanadu.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all existing users of cnt32_to_63() are fine since the CPU
architectures where it is used don't do read access reordering, and user
mode preemption is disabled already.  It is nevertheless a good idea to
better elaborate usage requirements wrt preemption, and use an explicit
memory barrier on SMP to avoid different CPUs accessing the counter
value in the wrong order.  On UP a simple compiler barrier is 
sufficient.

Signed-off-by: Nicolas Pitre <nico@marvell.com>
---

On Sun, 9 Nov 2008, Nicolas Pitre wrote:

> On Sat, 8 Nov 2008, Nicolas Pitre wrote:
> 
> > On Sat, 8 Nov 2008, Mathieu Desnoyers wrote:
> > 
> > > I *think* that smp_rmb() would be enough, supposing the access to memory
> > > is done in program order wrt local interrupts in UP. This is basically
> > > Steven's question, which has not received any clear answer yet. I'd like
> > > to know what others think about it.
> > 
> > In the mean time a pure rmb() is the safest thing to do now.  Once we 
> > can convince ourselves that out-of-order reads are always rolled back 
> > upon the arrival of an interrupt then this could be relaxed.
> 
> After thinking about it some more, a smp_rmb() must be correct.
> 
> On UP, that would be completely  insane if an exception didn't resume 
> the whole sequence since the CPU cannot presume anything when returning 
> from it.
> 
> If the instruction flows says:
> 
> 	READ A
> 	READ B
> 
> And speculative execution makes for B to be read before A, and you get 
> an interrupt after B was read but before A was read, then the program 
> counter may only point at READ A upon returning from the exception and B 
> will be read again.  Doing otherwise would require the CPU to remember 
> any reordering that it might have performed upon every exceptions which 
> is completely insane.
> 
> So smp_rmb() it shall be.

diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
index 8c0f950..7605fdd 100644
--- a/include/linux/cnt32_to_63.h
+++ b/include/linux/cnt32_to_63.h
@@ -16,6 +16,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
+#include <asm/system.h>
 
 /* this is used only to give gcc a clue about good code generation */
 union cnt32_to_63 {
@@ -53,11 +54,19 @@ union cnt32_to_63 {
  * needed increment.  And any race in updating the value in memory is harmless
  * as the same value would simply be stored more than once.
  *
- * The only restriction for the algorithm to work properly is that this
- * code must be executed at least once per each half period of the 32-bit
- * counter to properly update the state bit in memory. This is usually not a
- * problem in practice, but if it is then a kernel timer could be scheduled
- * to manage for this code to be executed often enough.
+ * The restrictions for the algorithm to work properly are:
+ *
+ * 1) this code must be called at least once per each half period of the
+ *    32-bit counter;
+ *
+ * 2) this code must not be preempted for a duration longer than the
+ *    32-bit counter half period minus the longest period between two
+ *    calls to this code.
+ *
+ * Those requirements ensure proper update to the state bit in memory.
+ * This is usually not a problem in practice, but if it is then a kernel
+ * timer should be scheduled to manage for this code to be executed often
+ * enough.
  *
  * Note that the top bit (bit 63) in the returned value should be considered
  * as garbage.  It is not cleared here because callers are likely to use a
@@ -68,9 +77,10 @@ union cnt32_to_63 {
  */
 #define cnt32_to_63(cnt_lo) \
 ({ \
-	static volatile u32 __m_cnt_hi; \
+	static u32 __m_cnt_hi; \
 	union cnt32_to_63 __x; \
 	__x.hi = __m_cnt_hi; \
+ 	smp_rmb(); \
 	__x.lo = (cnt_lo); \
 	if (unlikely((s32)(__x.hi ^ __x.lo) < 0)) \
 		__m_cnt_hi = __x.hi = (__x.hi ^ 0x80000000) + (__x.hi >> 31); \
