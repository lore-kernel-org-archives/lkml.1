Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab0BSGHQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:07:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:41403 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647Ab0BSGHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:07:12 -0500
Date: Fri, 19 Feb 2010 06:06:40 GMT
From: tip-bot for Brandon Philips <bphilips@suse.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, bphilips@suse.de, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, bphilips@suse.de, tglx@linutronix.de
In-Reply-To: <20100207210250.GB8256@jenkins.home.ifup.org>
References: <20100207210250.GB8256@jenkins.home.ifup.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, irq: Keep chip_data in create_irq_nr and destroy_irq
Message-ID: <tip-eb5b3794062824ba12d883901eea49ea89d0a678@git.kernel.org>
Git-Commit-ID: eb5b3794062824ba12d883901eea49ea89d0a678
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 19 Feb 2010 06:06:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb5b3794062824ba12d883901eea49ea89d0a678
Gitweb:     http://git.kernel.org/tip/eb5b3794062824ba12d883901eea49ea89d0a678
Author:     Brandon Philips <bphilips@suse.de>
AuthorDate: Sun, 7 Feb 2010 13:02:50 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 18 Feb 2010 21:53:15 -0800

x86, irq: Keep chip_data in create_irq_nr and destroy_irq

Version 4: use get_irq_chip_data() in destroy_irq() to get rid of some
local vars.

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
LKML-Reference: <20100207210250.GB8256@jenkins.home.ifup.org>
Signed-off-by: Brandon Phiilps <bphilips@suse.de>
Cc: stable@kernel.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/io_apic.c |   20 ++++-----------
 include/linux/irq.h            |    2 +
 kernel/irq/chip.c              |   52 +++++++++++++++++++++++++++++++++-------
 3 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5e4cce2..e93a76b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3278,12 +3278,9 @@ unsigned int create_irq_nr(unsigned int irq_want, int node)
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
 
@@ -3305,19 +3302,12 @@ int create_irq(void)
 void destroy_irq(unsigned int irq)
 {
 	unsigned long flags;
-	struct irq_cfg *cfg;
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
-	__clear_irq_vector(irq, cfg);
+	__clear_irq_vector(irq, get_irq_chip_data(irq));
 	spin_unlock_irqrestore(&vector_lock, flags);
 }
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 451481c..4d9b26e 100644
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
index ecc3fa2..d70394f 100644
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
+ *	does not set irq_to_desc(irq)->chip_data to NULL
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
+ *	does not set irq_to_desc(irq)->chip_data to NULL
+ */
+void dynamic_irq_cleanup_keep_chip_data(unsigned int irq)
+{
+	dynamic_irq_cleanup_x(irq, true);
+}
+
 
 /**
  *	set_irq_chip - set the irq chip for an irq
