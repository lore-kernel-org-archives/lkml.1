Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZLBAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZLBAyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 19:54:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbZLBAyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 19:54:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:45161 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbZLBAyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 19:54:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,324,1257148800"; 
   d="scan'208";a="472049706"
Message-Id: <20091201233335.143970505@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 01 Dec 2009 15:31:17 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>, hpa@zytor.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com, garyhade@us.ibm.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/4] x86, ioapic: document another case when level irq is seen as an edge
References: <20091201233334.975416130@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=fix_comments_io_apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case when cpu goes offline, fixup_irqs() will forward any unhandled
interrupt on the offlined cpu to the new cpu destination that is handling the
corresponding interrupt. This interrupt forwarding is done via IPI's. Hence, in
this case also level-triggered io-apic interrupt will be seen as an edge
interrupt in the cpu's APIC IRR. Document this scenario in the code which
handles this case by doing an explicit EOI to the io-apic to clear remote IRR
of the io-apic RTE.

Requested-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2586,6 +2586,19 @@ static void ack_apic_level(unsigned int 
 	 * level-triggered interrupt.  We mask the source for the time of the
 	 * operation to prevent an edge-triggered interrupt escaping meanwhile.
 	 * The idea is from Manfred Spraul.  --macro
+	 *
+	 * Also in the case when cpu goes offline, fixup_irqs() will forward
+	 * any unhandled interrupt on the offlined cpu to the new cpu
+	 * destination that is handling the corresponding interrupt. This
+	 * interrupt forwarding is done via IPI's. Hence, in this case also
+	 * level-triggered io-apic interrupt will be seen as an edge
+	 * interrupt in the IRR. And we can't rely on the cpu's EOI
+	 * to be broadcasted to the IO-APIC's which will clear the remoteIRR
+	 * corresponding to the level-triggered interrupt. Hence on IO-APIC's
+	 * supporting EOI register, we do an explicit EOI to clear the
+	 * remote IRR and on IO-APIC's which don't have an EOI register,
+	 * we use the above logic (mask+edge followed by unmask+level) from
+	 * Manfred Spraul to clear the remote IRR.
 	 */
 	cfg = desc->chip_data;
 	i = cfg->vector;
@@ -2597,7 +2610,13 @@ static void ack_apic_level(unsigned int 
 	 */
 	ack_APIC_irq();
 
-	/* Tail end of version 0x11 I/O APIC bug workaround */
+	/*
+	 * Tail end of clearing remote IRR bit (either by delivering the EOI
+	 * message via io-apic EOI register write or simulating it using
+	 * mask+edge followed by unnask+level logic) manually when the
+	 * level triggered interrupt is seen as the edge triggered interrupt
+	 * at the cpu.
+	 */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 


