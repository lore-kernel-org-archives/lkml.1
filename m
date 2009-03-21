Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbZCUSVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbZCUSVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZCUSV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:21:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:53272 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602AbZCUSV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:21:26 -0400
Subject: Re: [PATCH -tip] x86: apic/io_apic fix compilation warning
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090321163642.GI11183@elte.hu>
References: <1237630967.2409.1.camel@ht.satnam>
	 <20090321163642.GI11183@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Mar 2009 23:50:53 +0530
Message-Id: <1237659653.12448.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-21 at 17:36 +0100, Ingo Molnar wrote:

> hm, i think it would be cleaner to remove the CONFIG_INTR_REMAP 
> define altogether and define msi_ir_chip all the time. (and make 
> sure this build fine even in the !INTR_REMAP case)
> 

Is this looks OK to you and can you please check this in your
magic .config files:

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sat, 21 Mar 2009 23:40:00 +0530
Subject: [PATCH] x86: apic/io_apic.c define msi_ir_chip and ir_ioapic_chip all the time

move out msi_ir_chip and ir_ioapic_chip from CONFIG_INTR_REMAP shadow

Fix:
 arch/x86/kernel/apic/io_apic.c:1431: warning: ‘msi_ir_chip’ defined but not used

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/io_apic.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index d882c03..1aea1c2 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1428,7 +1428,6 @@ void __setup_vector_irq(int cpu)
 
 static struct irq_chip ioapic_chip;
 static struct irq_chip ir_ioapic_chip;
-static struct irq_chip msi_ir_chip;
 
 #define IOAPIC_AUTO     -1
 #define IOAPIC_EDGE     0
@@ -2663,20 +2662,20 @@ static struct irq_chip ioapic_chip __read_mostly = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-#ifdef CONFIG_INTR_REMAP
 static struct irq_chip ir_ioapic_chip __read_mostly = {
 	.name		= "IR-IO-APIC",
 	.startup	= startup_ioapic_irq,
 	.mask		= mask_IO_APIC_irq,
 	.unmask		= unmask_IO_APIC_irq,
+#ifdef CONFIG_INTR_REMAP
 	.ack		= ack_x2apic_edge,
 	.eoi		= ack_x2apic_level,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_ir_ioapic_affinity_irq,
 #endif
+#endif
 	.retrigger	= ioapic_retrigger_irq,
 };
-#endif
 
 static inline void init_IO_APIC_traps(void)
 {
@@ -3391,18 +3390,18 @@ static struct irq_chip msi_chip = {
 	.retrigger	= ioapic_retrigger_irq,
 };
 
-#ifdef CONFIG_INTR_REMAP
 static struct irq_chip msi_ir_chip = {
 	.name		= "IR-PCI-MSI",
 	.unmask		= unmask_msi_irq,
 	.mask		= mask_msi_irq,
+#ifdef CONFIG_INTR_REMAP
 	.ack		= ack_x2apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= ir_set_msi_irq_affinity,
 #endif
+#endif
 	.retrigger	= ioapic_retrigger_irq,
 };
-#endif
 
 /*
  * Map the PCI dev to the corresponding remapping hardware unit
-- 
1.6.0.6



