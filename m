Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbZDWHrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbZDWHrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZDWHcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:32:11 -0400
Received: from sous-sol.org ([216.99.217.87]:50699 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756841AbZDWHcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:32:09 -0400
Message-Id: <20090423072733.133332741@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:22 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Suresh Siddha <suresh.b.siddha@intel.com>,
       "hpa@linux.intel.com" <hpa@linux.intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 062/100] x86: fix broken irq migration logic while cleaning up multiple vectors
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=x86-fix-broken-irq-migration-logic-while-cleaning-up-multiple-vectors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

upstream commit: 68a8ca593fac82e336a792226272455901fa83df

Impact: fix spurious IRQs

During irq migration, we send a low priority interrupt to the previous
irq destination. This happens in non interrupt-remapping case after interrupt
starts arriving at new destination and in interrupt-remapping case after
modifying and flushing the interrupt-remapping table entry caches.

This low priority irq cleanup handler can cleanup multiple vectors, as
multiple irq's can be migrated at almost the same time. While
there will be multiple invocations of irq cleanup handler (one cleanup
IPI for each irq migration), first invocation of the cleanup handler
can potentially cleanup more than one vector (as the first invocation can
see the requests for more than vector cleanup). When we cleanup multiple
vectors during the first invocation of the smp_irq_move_cleanup_interrupt(),
other vectors that are to be cleanedup can still be pending in the local
cpu's IRR (as smp_irq_move_cleanup_interrupt() runs with interrupts disabled).

When we are ready to unhook a vector corresponding to an irq, check if that
vector is registered in the local cpu's IRR. If so skip that cleanup and
do a self IPI with the cleanup vector, so that we give a chance to
service the pending vector interrupt and then cleanup that vector
allocation once we execute the lowest priority handler.

This fixes spurious interrupts seen when migrating multiple vectors
at the same time.

[ This is apparently possible even on conventional xapic, although to
  the best of our knowledge it has never been seen.  The stable
  maintainers may wish to consider this one for -stable. ]

[suresh: backport to 2.6.29]
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

---
 arch/x86/kernel/io_apic.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -2475,6 +2475,7 @@ asmlinkage void smp_irq_move_cleanup_int
 	me = smp_processor_id();
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irq;
+		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
 		irq = __get_cpu_var(vector_irq)[vector];
@@ -2494,6 +2495,18 @@ asmlinkage void smp_irq_move_cleanup_int
 		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
 			goto unlock;
 
+		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+		/*
+		 * Check if the vector that needs to be cleanedup is
+		 * registered at the cpu's IRR. If so, then this is not
+		 * the best time to clean it up. Lets clean it up in the
+		 * next attempt by sending another IRQ_MOVE_CLEANUP_VECTOR
+		 * to myself.
+		 */
+		if (irr  & (1 << (vector % 32))) {
+			send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
+			goto unlock;
+		}
 		__get_cpu_var(vector_irq)[vector] = -1;
 		cfg->move_cleanup_count--;
 unlock:

