Return-Path: <linux-kernel-owner+w=401wt.eu-S1753777AbYCRFZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbYCRFZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYCRFYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:24:11 -0400
Received: from gw.goop.org ([64.81.55.164]:37833 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbYCRFYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:24:06 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 29 of 31] xen: short-cut for recursive event handling
X-Mercurial-Node: b7917b003ab2e7b7d3bc20d67cb3b115ab5bed6c
Message-Id: <b7917b003ab2e7b7d3bc.1205797040@localhost>
In-Reply-To: <patchbomb.1205797011@localhost>
Date: Mon, 17 Mar 2008 16:37:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an event comes in while events are currently being processed, then
just increment the counter and have the outer event loop reprocess the
pending events.  This prevents unbounded recursion on heavy event
loads (of course massive event storms will cause infinite loops).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/events.c |   46 ++++++++++++++++++++++++++++++----------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/events.c b/arch/x86/xen/events.c
--- a/arch/x86/xen/events.c
+++ b/arch/x86/xen/events.c
@@ -517,29 +517,43 @@
 	int cpu = get_cpu();
 	struct shared_info *s = HYPERVISOR_shared_info;
 	struct vcpu_info *vcpu_info = __get_cpu_var(xen_vcpu);
-	unsigned long pending_words;
+	static DEFINE_PER_CPU(unsigned, nesting_count);
+ 	unsigned count;
 
-	vcpu_info->evtchn_upcall_pending = 0;
+	do {
+		unsigned long pending_words;
 
-	/* NB. No need for a barrier here -- XCHG is a barrier on x86. */
-	pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
-	while (pending_words != 0) {
-		unsigned long pending_bits;
-		int word_idx = __ffs(pending_words);
-		pending_words &= ~(1UL << word_idx);
+		vcpu_info->evtchn_upcall_pending = 0;
 
-		while ((pending_bits = active_evtchns(cpu, s, word_idx)) != 0) {
-			int bit_idx = __ffs(pending_bits);
-			int port = (word_idx * BITS_PER_LONG) + bit_idx;
-			int irq = evtchn_to_irq[port];
+		if (__get_cpu_var(nesting_count)++)
+			goto out;
 
-			if (irq != -1) {
-				regs->orig_ax = ~irq;
-				do_IRQ(regs);
+		/* NB. No need for a barrier here -- XCHG is a barrier on x86. */
+		pending_words = xchg(&vcpu_info->evtchn_pending_sel, 0);
+		while (pending_words != 0) {
+			unsigned long pending_bits;
+			int word_idx = __ffs(pending_words);
+			pending_words &= ~(1UL << word_idx);
+
+			while ((pending_bits = active_evtchns(cpu, s, word_idx)) != 0) {
+				int bit_idx = __ffs(pending_bits);
+				int port = (word_idx * BITS_PER_LONG) + bit_idx;
+				int irq = evtchn_to_irq[port];
+
+				if (irq != -1) {
+					regs->orig_ax = ~irq;
+					do_IRQ(regs);
+				}
 			}
 		}
-	}
 
+		BUG_ON(!irqs_disabled());
+
+		count = __get_cpu_var(nesting_count);
+		__get_cpu_var(nesting_count) = 0;
+	} while(count != 1);
+
+out:
 	put_cpu();
 }
 


