Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbZFPUTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbZFPUTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761853AbZFPUQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:21 -0400
Received: from claw.goop.org ([74.207.240.146]:40602 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760125AbZFPUQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:09 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 08/16] x86/ioapic.c: remove #ifdef for 82093AA workaround
Date: Tue, 16 Jun 2009 13:15:47 -0700
Message-Id: <1245183355-25808-9-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

While no 64-bit hardware will have a version 0x11 I/O APIC which needs
the level/edge bug workaround, that's not a particular reason to use
CONFIG_X86_32 to #ifdef the code out.  Most 32-bit machines will no
longer need the workaround either, so the test to see whether it is
necessary should be more fine-grained than "32-bit=yes, 64-bit=no".

(Also fix formatting of block comment.)

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/apic/io_apic.c |   47 ++++++++++++++++-----------------------
 1 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e767bcb..54ec66d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -593,7 +593,6 @@ static void __mask_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~0, IO_APIC_REDIR_MASKED, &io_apic_sync);
 }
 
-#ifdef CONFIG_X86_32
 static void __mask_and_edge_IO_APIC_irq(struct irq_cfg *cfg)
 {
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_LEVEL_TRIGGER,
@@ -605,7 +604,6 @@ static void __unmask_and_level_IO_APIC_irq(struct irq_cfg *cfg)
 	io_apic_modify_irq(cfg, ~IO_APIC_REDIR_MASKED,
 			IO_APIC_REDIR_LEVEL_TRIGGER, NULL);
 }
-#endif /* CONFIG_X86_32 */
 
 static void mask_IO_APIC_irq_desc(struct irq_desc *desc)
 {
@@ -2508,11 +2506,8 @@ atomic_t irq_mis_count;
 static void ack_apic_level(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-
-#ifdef CONFIG_X86_32
 	unsigned long v;
 	int i;
-#endif
 	struct irq_cfg *cfg;
 	int do_unmask_irq = 0;
 
@@ -2525,31 +2520,28 @@ static void ack_apic_level(unsigned int irq)
 	}
 #endif
 
-#ifdef CONFIG_X86_32
 	/*
-	* It appears there is an erratum which affects at least version 0x11
-	* of I/O APIC (that's the 82093AA and cores integrated into various
-	* chipsets).  Under certain conditions a level-triggered interrupt is
-	* erroneously delivered as edge-triggered one but the respective IRR
-	* bit gets set nevertheless.  As a result the I/O unit expects an EOI
-	* message but it will never arrive and further interrupts are blocked
-	* from the source.  The exact reason is so far unknown, but the
-	* phenomenon was observed when two consecutive interrupt requests
-	* from a given source get delivered to the same CPU and the source is
-	* temporarily disabled in between.
-	*
-	* A workaround is to simulate an EOI message manually.  We achieve it
-	* by setting the trigger mode to edge and then to level when the edge
-	* trigger mode gets detected in the TMR of a local APIC for a
-	* level-triggered interrupt.  We mask the source for the time of the
-	* operation to prevent an edge-triggered interrupt escaping meanwhile.
-	* The idea is from Manfred Spraul.  --macro
-	*/
+	 * It appears there is an erratum which affects at least version 0x11
+	 * of I/O APIC (that's the 82093AA and cores integrated into various
+	 * chipsets).  Under certain conditions a level-triggered interrupt is
+	 * erroneously delivered as edge-triggered one but the respective IRR
+	 * bit gets set nevertheless.  As a result the I/O unit expects an EOI
+	 * message but it will never arrive and further interrupts are blocked
+	 * from the source.  The exact reason is so far unknown, but the
+	 * phenomenon was observed when two consecutive interrupt requests
+	 * from a given source get delivered to the same CPU and the source is
+	 * temporarily disabled in between.
+	 *
+	 * A workaround is to simulate an EOI message manually.  We achieve it
+	 * by setting the trigger mode to edge and then to level when the edge
+	 * trigger mode gets detected in the TMR of a local APIC for a
+	 * level-triggered interrupt.  We mask the source for the time of the
+	 * operation to prevent an edge-triggered interrupt escaping meanwhile.
+	 * The idea is from Manfred Spraul.  --macro
+	 */
 	cfg = desc->chip_data;
 	i = cfg->vector;
-
 	v = apic_read(APIC_TMR + ((i & ~0x1f) >> 1));
-#endif
 
 	/*
 	 * We must acknowledge the irq before we move it or the acknowledge will
@@ -2591,7 +2583,7 @@ static void ack_apic_level(unsigned int irq)
 		unmask_IO_APIC_irq_desc(desc);
 	}
 
-#ifdef CONFIG_X86_32
+	/* Tail end of version 0x11 I/O APIC bug workaround */
 	if (!(v & (1 << (i & 0x1f)))) {
 		atomic_inc(&irq_mis_count);
 		spin_lock(&ioapic_lock);
@@ -2599,7 +2591,6 @@ static void ack_apic_level(unsigned int irq)
 		__unmask_and_level_IO_APIC_irq(cfg);
 		spin_unlock(&ioapic_lock);
 	}
-#endif
 }
 
 #ifdef CONFIG_INTR_REMAP
-- 
1.6.2.2

