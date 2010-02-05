Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0BEIrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 03:47:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:53836 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab0BEIrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 03:47:13 -0500
Message-ID: <4B6BDAC0.3090900@kernel.org>
Date: Fri, 05 Feb 2010 00:45:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Brandon Philips <bphilips@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: keep chip_data in create_irq_nr
References: <20100203033109.GA17985@jenkins.home.ifup.org> <4B694DEF.70301@kernel.org> <20100203174216.GB17985@jenkins.home.ifup.org>
In-Reply-To: <20100203174216.GB17985@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Brodon found:
race happened when two drivers were setting up MSI-X at the same
time via pci_enable_msix(). See this dmesg excerpt:

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

so let remove the save and restore code.

just don't clear it in that path

Reported-and-analyzed-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/kernel/apic/io_apic.c |    9 +++------
 include/linux/irq.h            |    1 +
 kernel/irq/chip.c              |   15 +++++++++++++--
 3 files changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -3280,12 +3280,9 @@ unsigned int create_irq_nr(unsigned int
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
 
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -400,6 +400,7 @@ static inline int irq_has_action(unsigne
 
 /* Dynamic irq helper functions */
 extern void dynamic_irq_init(unsigned int irq);
+void dynamic_irq_init_keep_chip_data(unsigned int irq);
 extern void dynamic_irq_cleanup(unsigned int irq);
 
 /* Set/get chip/data for an IRQ: */
Index: linux-2.6/kernel/irq/chip.c
===================================================================
--- linux-2.6.orig/kernel/irq/chip.c
+++ linux-2.6/kernel/irq/chip.c
@@ -22,7 +22,7 @@
  *	dynamic_irq_init - initialize a dynamically allocated irq
  *	@irq:	irq number to initialize
  */
-void dynamic_irq_init(unsigned int irq)
+static void dynamic_irq_init_x(unsigned int irq, bool keep_chip_data)
 {
 	struct irq_desc *desc;
 	unsigned long flags;
@@ -41,7 +41,8 @@ void dynamic_irq_init(unsigned int irq)
 	desc->depth = 1;
 	desc->msi_desc = NULL;
 	desc->handler_data = NULL;
-	desc->chip_data = NULL;
+	if (!keep_chip_data)
+		desc->chip_data = NULL;
 	desc->action = NULL;
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
@@ -54,6 +55,16 @@ void dynamic_irq_init(unsigned int irq)
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 }
 
+void dynamic_irq_init(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, false);
+}
+
+void dynamic_irq_init_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_init_x(irq, true);
+}
+
 /**
  *	dynamic_irq_cleanup - cleanup a dynamically allocated irq
  *	@irq:	irq number to initialize
