Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab0BJJcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:32:07 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:60022 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0BJJVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:47 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/35] x86: keep chip_data in create_irq_nr and destroy_irq
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Brandon Phiilps <bphilips@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       stable@kernel.org
Message-id: <1265793639-15071-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brandon Phiilps <bphilips@suse.de>

When two drivers are setting up MSI-X at the same time via
pci_enable_msix() there is a race.  See this dmesg excerpt:

[   85.170610] ixgbe 0000:02:00.1: irq 97 for MSI/MSI-X
[   85.170611]   alloc irq_desc for 99 on node -1
[   85.170613] igb 0000:08:00.1: irq 98 for MSI/MSI-X
[   85.170614]   alloc kstat_irqs on node -1
[   85.170616] alloc irq_2_iommu on node -1
[   85.170617]   alloc irq_desc for 100 on node -1
[   85.170619]   alloc kstat_irqs on node -1
[   85.170621] alloc irq_2_iommu on node -1
[   85.170625] ixgbe 0000:02:00.1: irq 99 for MSI/MSI-X
[   85.170626]   alloc irq_desc for 101 on node -1
[   85.170628] igb 0000:08:00.1: irq 100 for MSI/MSI-X
[   85.170630]   alloc kstat_irqs on node -1
[   85.170631] alloc irq_2_iommu on node -1
[   85.170635]   alloc irq_desc for 102 on node -1
[   85.170636]   alloc kstat_irqs on node -1
[   85.170639] alloc irq_2_iommu on node -1
[   85.170646] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000088

As you can see igb and ixgbe are both alternating on create_irq_nr()
via pci_enable_msix() in their probe function.

ixgbe: While looping through irq_desc_ptrs[] via create_irq_nr() ixgbe
choses irq_desc_ptrs[102] and exits the loop, drops vector_lock and
calls dynamic_irq_init. Then it sets irq_desc_ptrs[102]->chip_data =
NULL via dynamic_irq_init().

igb: Grabs the vector_lock now and starts looping over irq_desc_ptrs[]
via create_irq_nr(). It gets to irq_desc_ptrs[102] and does this:

	cfg_new = irq_desc_ptrs[102]->chip_data;
	if (cfg_new->vector != 0)
		continue;

This hits the NULL deref.

Another possible race exists via pci_disable_msix() in a driver or in
the number of error paths that call free_msi_irqs():

destroy_irq()
dynamic_irq_cleanup() which sets desc->chip_data = NULL
...race window...
desc->chip_data = cfg;

Remove the save and restore code for cfg in create_irq_nr() and
destroy_irq() and take the desc->lock when checking the irq_cfg.

Reported-and-analyzed-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Brandon Phiilps <bphilips@suse.de>
Cc: stable@kernel.org
---
 arch/x86/kernel/apic/io_apic.c |   18 ++++----------
 include/linux/irq.h            |    2 +
 kernel/irq/chip.c              |   52 +++++++++++++++++++++++++++++++++-------
 3 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ee2fba1..bd93444 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3280,12 +3280,9 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
 	}
 	spin_unlock_irqrestore(&vector_lock, flags);
 
-	if (irq > 0) {
-		dynamic_irq_init(irq);
-		/* restore it, in case dynamic_irq_init clear it */
-		if (desc_new)
-			desc_new->chip_data = cfg_new;
-	}
+	if (irq > 0)
+		dynamic_irq_init_keep_chip_data(irq);
+
 	return irq;
 }
 
@@ -3308,17 +3305,12 @@ void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 
-	/* store it, in case dynamic_irq_cleanup clear it */
-	desc = irq_to_desc(irq);
-	cfg = desc->chip_data;
-	dynamic_irq_cleanup(irq);
-	/* connect back irq_cfg */
-	desc->chip_data = cfg;
+	dynamic_irq_cleanup_keep_chip_data(irq);
 
 	free_irte(irq);
 	spin_lock_irqsave(&vector_lock, flags);
+	cfg = irq_to_desc(irq)->chip_data;
 	__clear_irq_vector(irq, cfg);
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
diff --git a/include/linux/irq.h b/include/linux/irq.h
index d13492d..707ab12 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -400,7 +400,9 @@ static inline int irq_has_action(unsigned int irq)
 
 /* Dynamic irq helper functions */
 extern void dynamic_irq_init(unsigned int irq);
+void dynamic_irq_init_keep_chip_data(unsigned int irq);
 extern void dynamic_irq_cleanup(unsigned int irq);
+void dynamic_irq_cleanup_keep_chip_data(unsigned int irq);
 
 /* Set/get chip/data for an IRQ: */
 extern int set_irq_chip(unsigned int irq, struct irq_chip *chip);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index ecc3fa2..2fc42d3 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -18,11 +18,7 @@
 
 #include "internals.h"
 
-/**
- *	dynamic_irq_init - initialize a dynamically allocated irq
- *	@irq:	irq number to initialize
- */
-void dynamic_irq_init(unsigned int irq)
+static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -41,7 +37,8 @@ void dynamic_irq_init(unsigned int irq)
 	desc->depth = 1;
 	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
-	desc->chip_data = NULL;
+	if (!keep_chip_data)
+		desc->chip_data = NULL;
 	desc->action = NULL;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
@@ -55,10 +52,26 @@ void dynamic_irq_init(unsigned int irq)
 }
 
 /**
- *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
+ *	dynamic_irq_init - initialize a dynamically allocated irq
  *	@irq:	irq number to initialize
  */
-void dynamic_irq_cleanup(unsigned int irq)
+void dynamic_irq_init(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, false);
+}
+
+/**
+ *	dynamic_irq_init_keep_chip_data - initialize a dynamically allocated irq
+ *	@irq:	irq number to initialize
+ *
+ * 	does not set irq_to_desc(irq)->chip_data to NULL
+ */
+void dynamic_irq_init_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, true);
+}
+
+static void dynamic_irq_cleanup_x(unsigned int irq, bool keep_chip_data)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	unsigned long flags;
@@ -77,7 +90,8 @@ void dynamic_irq_cleanup(unsigned int irq)
 	}
 	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
-	desc->chip_data = NULL;
+	if (!keep_chip_data)
+		desc->chip_data = NULL;
 	desc->handle_irq = handle_bad_irq;
 	desc->chip = &no_irq_chip;
 	desc->name = NULL;
@@ -85,6 +99,26 @@ void dynamic_irq_cleanup(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+/**
+ *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
+ *	@irq:	irq number to initialize
+ */
+void dynamic_irq_cleanup(unsigned int irq)
+{
+	dynamic_irq_cleanup_x(irq, false);
+}
+
+/**
+ *	dynamic_irq_cleanup_keep_chip_data - cleanup a dynamically allocated irq
+ *	@irq:	irq number to initialize
+ *
+ * 	does not set irq_to_desc(irq)->chip_data to NULL
+ */
+void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_cleanup_x(irq, true);
+}
+
 
 /**
  *	set_irq_chip - set the irq chip for an irq
-- 
1.6.4.2

