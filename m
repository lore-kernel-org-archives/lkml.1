Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbZB1Bs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbZB1Bs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbZB1Bmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41784 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbZB1Bl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:59 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/30] ia64: Move the macro definitions related to MSI to one header file.
Date: Sat, 28 Feb 2009 03:41:44 +0200
Message-Id: <1235785309-12835-26-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

For kvm's MSI support, it needs these macros defined in ia64_msi.c, and
to avoid duplicate them, move them to one header file and share with
kvm.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/msidef.h |   42 ++++++++++++++++++++++++++++++
 arch/ia64/kernel/msi_ia64.c    |   55 ++++++---------------------------------
 2 files changed, 51 insertions(+), 46 deletions(-)
 create mode 100644 arch/ia64/include/asm/msidef.h

diff --git a/arch/ia64/include/asm/msidef.h b/arch/ia64/include/asm/msidef.h
new file mode 100644
index 0000000..592c104
--- /dev/null
+++ b/arch/ia64/include/asm/msidef.h
@@ -0,0 +1,42 @@
+#ifndef _IA64_MSI_DEF_H
+#define _IA64_MSI_DEF_H
+
+/*
+ * Shifts for APIC-based data
+ */
+
+#define     MSI_DATA_VECTOR_SHIFT	0
+#define	    MSI_DATA_VECTOR(v)		(((u8)v) << MSI_DATA_VECTOR_SHIFT)
+#define     MSI_DATA_VECTOR_MASK	0xffffff00
+
+#define     MSI_DATA_DELIVERY_MODE_SHIFT	8
+#define     MSI_DATA_DELIVERY_FIXED	(0 << MSI_DATA_DELIVERY_MODE_SHIFT)
+#define     MSI_DATA_DELIVERY_LOWPRI	(1 << MSI_DATA_DELIVERY_MODE_SHIFT)
+
+#define     MSI_DATA_LEVEL_SHIFT	14
+#define     MSI_DATA_LEVEL_DEASSERT	(0 << MSI_DATA_LEVEL_SHIFT)
+#define     MSI_DATA_LEVEL_ASSERT	(1 << MSI_DATA_LEVEL_SHIFT)
+
+#define     MSI_DATA_TRIGGER_SHIFT	15
+#define     MSI_DATA_TRIGGER_EDGE	(0 << MSI_DATA_TRIGGER_SHIFT)
+#define     MSI_DATA_TRIGGER_LEVEL	(1 << MSI_DATA_TRIGGER_SHIFT)
+
+/*
+ * Shift/mask fields for APIC-based bus address
+ */
+
+#define     MSI_ADDR_DEST_ID_SHIFT	4
+#define     MSI_ADDR_HEADER		0xfee00000
+
+#define     MSI_ADDR_DEST_ID_MASK	0xfff0000f
+#define     MSI_ADDR_DEST_ID_CPU(cpu)	((cpu) << MSI_ADDR_DEST_ID_SHIFT)
+
+#define     MSI_ADDR_DEST_MODE_SHIFT	2
+#define     MSI_ADDR_DEST_MODE_PHYS	(0 << MSI_ADDR_DEST_MODE_SHIFT)
+#define	    MSI_ADDR_DEST_MODE_LOGIC	(1 << MSI_ADDR_DEST_MODE_SHIFT)
+
+#define     MSI_ADDR_REDIRECTION_SHIFT	3
+#define     MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT)
+#define     MSI_ADDR_REDIRECTION_LOWPRI	(1 << MSI_ADDR_REDIRECTION_SHIFT)
+
+#endif/* _IA64_MSI_DEF_H */
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 8903393..368ee4e 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -7,44 +7,7 @@
 #include <linux/msi.h>
 #include <linux/dmar.h>
 #include <asm/smp.h>
-
-/*
- * Shifts for APIC-based data
- */
-
-#define MSI_DATA_VECTOR_SHIFT		0
-#define	    MSI_DATA_VECTOR(v)		(((u8)v) << MSI_DATA_VECTOR_SHIFT)
-#define MSI_DATA_VECTOR_MASK		0xffffff00
-
-#define MSI_DATA_DELIVERY_SHIFT		8
-#define     MSI_DATA_DELIVERY_FIXED	(0 << MSI_DATA_DELIVERY_SHIFT)
-#define     MSI_DATA_DELIVERY_LOWPRI	(1 << MSI_DATA_DELIVERY_SHIFT)
-
-#define MSI_DATA_LEVEL_SHIFT		14
-#define     MSI_DATA_LEVEL_DEASSERT	(0 << MSI_DATA_LEVEL_SHIFT)
-#define     MSI_DATA_LEVEL_ASSERT	(1 << MSI_DATA_LEVEL_SHIFT)
-
-#define MSI_DATA_TRIGGER_SHIFT		15
-#define     MSI_DATA_TRIGGER_EDGE	(0 << MSI_DATA_TRIGGER_SHIFT)
-#define     MSI_DATA_TRIGGER_LEVEL	(1 << MSI_DATA_TRIGGER_SHIFT)
-
-/*
- * Shift/mask fields for APIC-based bus address
- */
-
-#define MSI_TARGET_CPU_SHIFT		4
-#define MSI_ADDR_HEADER			0xfee00000
-
-#define MSI_ADDR_DESTID_MASK		0xfff0000f
-#define     MSI_ADDR_DESTID_CPU(cpu)	((cpu) << MSI_TARGET_CPU_SHIFT)
-
-#define MSI_ADDR_DESTMODE_SHIFT		2
-#define     MSI_ADDR_DESTMODE_PHYS	(0 << MSI_ADDR_DESTMODE_SHIFT)
-#define	    MSI_ADDR_DESTMODE_LOGIC	(1 << MSI_ADDR_DESTMODE_SHIFT)
-
-#define MSI_ADDR_REDIRECTION_SHIFT	3
-#define     MSI_ADDR_REDIRECTION_CPU	(0 << MSI_ADDR_REDIRECTION_SHIFT)
-#define     MSI_ADDR_REDIRECTION_LOWPRI	(1 << MSI_ADDR_REDIRECTION_SHIFT)
+#include <asm/msidef.h>
 
 static struct irq_chip	ia64_msi_chip;
 
@@ -65,8 +28,8 @@ static void ia64_set_msi_irq_affinity(unsigned int irq,
 	read_msi_msg(irq, &msg);
 
 	addr = msg.address_lo;
-	addr &= MSI_ADDR_DESTID_MASK;
-	addr |= MSI_ADDR_DESTID_CPU(cpu_physical_id(cpu));
+	addr &= MSI_ADDR_DEST_ID_MASK;
+	addr |= MSI_ADDR_DEST_ID_CPU(cpu_physical_id(cpu));
 	msg.address_lo = addr;
 
 	data = msg.data;
@@ -98,9 +61,9 @@ int ia64_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
 	msg.address_hi = 0;
 	msg.address_lo =
 		MSI_ADDR_HEADER |
-		MSI_ADDR_DESTMODE_PHYS |
+		MSI_ADDR_DEST_MODE_PHYS |
 		MSI_ADDR_REDIRECTION_CPU |
-		MSI_ADDR_DESTID_CPU(dest_phys_id);
+		MSI_ADDR_DEST_ID_CPU(dest_phys_id);
 
 	msg.data =
 		MSI_DATA_TRIGGER_EDGE |
@@ -183,8 +146,8 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
-	msg.address_lo &= ~MSI_ADDR_DESTID_MASK;
-	msg.address_lo |= MSI_ADDR_DESTID_CPU(cpu_physical_id(cpu));
+	msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
+	msg.address_lo |= MSI_ADDR_DEST_ID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
 	irq_desc[irq].affinity = *mask;
@@ -215,9 +178,9 @@ msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 	msg->address_hi = 0;
 	msg->address_lo =
 		MSI_ADDR_HEADER |
-		MSI_ADDR_DESTMODE_PHYS |
+		MSI_ADDR_DEST_MODE_PHYS |
 		MSI_ADDR_REDIRECTION_CPU |
-		MSI_ADDR_DESTID_CPU(dest);
+		MSI_ADDR_DEST_ID_CPU(dest);
 
 	msg->data =
 		MSI_DATA_TRIGGER_EDGE |
-- 
1.6.0.6

