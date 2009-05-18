Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZERKF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZERKF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 06:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbZERKEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 06:04:12 -0400
Received: from mail.windriver.com ([147.11.1.11]:50623 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672AbZERKEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 06:04:07 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: benh@kernel.crashing.org, bluesmoke-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [v1 PATCH 1/4] EDAC: MPIC Hypertransport IRQ support
Date: Mon, 18 May 2009 18:04:57 +0800
Message-Id: <1242641100-15324-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1242641100-15324-1-git-send-email-qingtao.cao@windriver.com>
References: <1242641100-15324-1-git-send-email-qingtao.cao@windriver.com>
X-OriginalArrivalTime: 18 May 2009 10:03:52.0059 (UTC) FILETIME=[F23C74B0:01C9D79F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Collect the machine specific code that creates the hwirq2virq mapping 
for the possible multiple EDAC modules on the same machine that supports
MPIC.

Multiple calling of irq_create_of_mapping() for the same hwirq will
always return the same virq, since the mapping won't be refcounted so
we just don't call irq_dispose_mapping() against it. This won't occupy
unnecessary resource since irq_map[] is of fixed size(==512).

The edac_mpic_irq.c is inert for EDAC drivers where related hardware
is not connecting to MPIC, so it should be controlled by CONFIG_MPIC.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
---
 drivers/edac/Makefile        |    4 ++
 drivers/edac/edac_mpic_irq.c |   86 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/edac.h         |   20 ++++++++++
 3 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/edac_mpic_irq.c

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 07a31cf..62778ee 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -17,6 +17,10 @@ ifdef CONFIG_PCI
 edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
 endif
 
+ifdef CONFIG_MPIC
+edac_core-objs += edac_mpic_irq.o
+endif
+
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
 obj-$(CONFIG_EDAC_I5000)		+= i5000_edac.o
diff --git a/drivers/edac/edac_mpic_irq.c b/drivers/edac/edac_mpic_irq.c
new file mode 100644
index 0000000..7486b15
--- /dev/null
+++ b/drivers/edac/edac_mpic_irq.c
@@ -0,0 +1,86 @@
+/*
+ * edac_mpic_irq.c -
+ * 	Collect the machine specific code that creates the hwirq2virq
+ * 	mapping for the possible multiple EDAC modules on the same
+ * 	machine that supports MPIC.
+ *
+ * Copyright (c) 2009 Wind River Systems, Inc.
+ *
+ * Authors:	Cao Qingtao <qingtao.cao@windriver.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/of.h>
+#include <linux/edac.h>
+
+#ifdef CONFIG_PPC_MAPLE
+static int edac_maple_get_irq(int hwirq)
+{
+	struct device_node *np, *mpic_node = NULL;
+	int irq = NO_IRQ;
+
+	/*
+	 * Locate MPIC in the device-tree. Note that there is a bug
+	 * in Maple device-tree where the type of the controller is
+	 * open-pic and not interrupt-controller
+	 */
+	for_each_node_by_type(np, "interrupt-controller") {
+		if (of_device_is_compatible(np, "open-pic")) {
+			mpic_node = np;
+			break;
+		}
+	}
+
+	if (mpic_node == NULL) {
+		for_each_node_by_type(np, "open-pic") {
+			mpic_node = np;
+			break;
+		}
+	}
+
+	if (mpic_node) {
+		irq = irq_create_of_mapping(mpic_node, &hwirq, 1);
+		of_node_put(mpic_node);
+	} else
+		printk(KERN_ERR "Failed to locate the MPIC DTB node\n");
+
+	return irq;
+}
+#endif
+
+/*
+ * NOTE:
+ * The EDAC driver should implement and register its machine-specific
+ * method to get a virtual IRQ here.
+ */
+int edac_get_mpic_irq(int hwirq)
+{
+	int virq = NO_IRQ;
+
+	if ((hwirq != MPIC_HWIRQ_HT_NMI) &&
+	    (hwirq != MPIC_HWIRQ_INTERNAL_ERROR))
+		return NO_IRQ;
+
+#ifdef CONFIG_PPC_MAPLE
+	virq = edac_maple_get_irq(hwirq);
+#endif
+
+	return virq;
+
+}
+EXPORT_SYMBOL_GPL(edac_get_mpic_irq);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index 7cf92e8..c122d22 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -38,4 +38,24 @@ static inline void opstate_init(void)
 	return;
 }
 
+#ifdef CONFIG_MPIC
+enum {
+	/*
+	 * Vector carried in southbridge NMI Request Messages
+	 * posted through Hypertransport Channel
+	 */
+	MPIC_HWIRQ_HT_NMI = 0,
+
+	/*
+	 * Vector for MPIC Internal Error
+	 */
+	MPIC_HWIRQ_INTERNAL_ERROR = 2,
+
+	MPIC_HWIRQS,	/* must be the very last */
+};
+
+/* Create a hwirq2virq mapping for the specified hwirq */
+extern int edac_get_mpic_irq(int hwirq);
+#endif
+
 #endif
-- 
1.5.6.2

