Return-Path: <linux-kernel-owner+w=401wt.eu-S1757691AbYKMTrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691AbYKMTrh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbYKMTel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:41 -0500
Received: from gw.goop.org ([64.81.55.164]:34452 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbYKMTeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:12 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 34 of 38] xen: remove irq bindcount
X-Mercurial-Node: 281cf0412d4ddaeb34b4b715c82945f04d6089f3
Message-Id: <281cf0412d4ddaeb34b4.1226603432@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:32 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no need for us to maintain our own bind count for
irqs, since the surrounding irq system should keep track of shared
irqs for us.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/events.c |   26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -53,7 +53,7 @@
 
 /* Interrupt types. */
 enum xen_irq_type {
-	IRQT_UNBOUND,
+	IRQT_UNBOUND = 0,
 	IRQT_PIRQ,
 	IRQT_VIRQ,
 	IRQT_IPI,
@@ -94,9 +94,6 @@
 };
 static unsigned long cpu_evtchn_mask[NR_CPUS][NR_EVENT_CHANNELS/BITS_PER_LONG];
 
-/* Reference counts for bindings to IRQs. */
-static int irq_bindcount[NR_IRQS];
-
 /* Xen will never allocate port zero for any purpose. */
 #define VALID_EVTCHN(chn)	((chn) != 0)
 
@@ -320,9 +317,8 @@
 {
 	int irq;
 
-	/* Only allocate from dynirq range */
 	for_each_irq_nr(irq)
-		if (irq_bindcount[irq] == 0)
+		if (irq_info[irq].type == IRQT_UNBOUND)
 			break;
 
 	if (irq == nr_irqs)
@@ -351,8 +347,6 @@
 		irq_info[irq] = mk_evtchn_info(evtchn);
 	}
 
-	irq_bindcount[irq]++;
-
 	spin_unlock(&irq_mapping_update_lock);
 
 	return irq;
@@ -389,8 +383,6 @@
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 
-	irq_bindcount[irq]++;
-
  out:
 	spin_unlock(&irq_mapping_update_lock);
 	return irq;
@@ -427,8 +419,6 @@
 		bind_evtchn_to_cpu(evtchn, cpu);
 	}
 
-	irq_bindcount[irq]++;
-
 	spin_unlock(&irq_mapping_update_lock);
 
 	return irq;
@@ -441,7 +431,7 @@
 
 	spin_lock(&irq_mapping_update_lock);
 
-	if ((--irq_bindcount[irq] == 0) && VALID_EVTCHN(evtchn)) {
+	if (VALID_EVTCHN(evtchn)) {
 		close.port = evtchn;
 		if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
 			BUG();
@@ -667,6 +657,8 @@
 /* Rebind a new event channel to an existing irq. */
 void rebind_evtchn_irq(int evtchn, int irq)
 {
+	struct irq_info *info = info_for_irq(irq);
+
 	/* Make sure the irq is masked, since the new event channel
 	   will also be masked. */
 	disable_irq(irq);
@@ -676,8 +668,8 @@
 	/* After resume the irq<->evtchn mappings are all cleared out */
 	BUG_ON(evtchn_to_irq[evtchn] != -1);
 	/* Expect irq to have been bound before,
-	   so the bindcount should be non-0 */
-	BUG_ON(irq_bindcount[irq] == 0);
+	   so there should be a proper type */
+	BUG_ON(info->type != IRQT_UNBOUND);
 
 	evtchn_to_irq[evtchn] = irq;
 	irq_info[irq] = mk_evtchn_info(evtchn);
@@ -930,9 +922,5 @@
 	for (i = 0; i < NR_EVENT_CHANNELS; i++)
 		mask_evtchn(i);
 
-	/* Dynamic IRQ space is currently unbound. Zero the refcnts. */
-	for_each_irq_nr(i)
-		irq_bindcount[i] = 0;
-
 	irq_ctx_init(smp_processor_id());
 }


