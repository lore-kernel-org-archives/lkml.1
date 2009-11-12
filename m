Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZKLG2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZKLG2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 01:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZKLG2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 01:28:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:34922 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399AbZKLG2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 01:28:43 -0500
Message-ID: <4AFBAADC.4070801@kernel.org>
Date: Wed, 11 Nov 2009 22:27:40 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] x86/pci: seperate x86_pci_rootbus_res_quirks from amd_bus.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


those functions are used by intel_bus.c

so seperate them to another file. and make amd_bus some smaller.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/Makefile   |    2 
 arch/x86/pci/amd_bus.c  |   99 -----------------------------------------------
 arch/x86/pci/bus_numa.c |  101 ++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/pci/bus_numa.h |    1 
 4 files changed, 103 insertions(+), 100 deletions(-)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -6,8 +6,6 @@
 
 #ifdef CONFIG_X86_64
 #include <asm/pci-direct.h>
-#include <asm/mpspec.h>
-#include <linux/cpumask.h>
 #endif
 
 #include "bus_numa.h"
@@ -19,54 +17,6 @@
 
 #ifdef CONFIG_X86_64
 
-int pci_root_num;
-struct pci_root_info pci_root_info[PCI_ROOT_NR];
-static int found_all_numa_early;
-
-void x86_pci_root_bus_res_quirks(struct pci_bus *b)
-{
-	int i;
-	int j;
-	struct pci_root_info *info;
-
-	/* don't go for it if _CRS is used already */
-	if (b->resource[0] != &ioport_resource ||
-	    b->resource[1] != &iomem_resource)
-		return;
-
-	if (!pci_root_num)
-		return;
-
-	/* for amd, if only one root bus, don't need to do anything */
-	if (pci_root_num < 2 && found_all_numa_early)
-		return;
-
-	for (i = 0; i < pci_root_num; i++) {
-		if (pci_root_info[i].bus_min == b->number)
-			break;
-	}
-
-	if (i == pci_root_num)
-		return;
-
-	printk(KERN_DEBUG "PCI: peer root bus %02x res updated from pci conf\n",
-			b->number);
-
-	info = &pci_root_info[i];
-	for (j = 0; j < info->res_num; j++) {
-		struct resource *res;
-		struct resource *root;
-
-		res = &info->res[j];
-		b->resource[j] = res;
-		if (res->flags & IORESOURCE_IO)
-			root = &ioport_resource;
-		else
-			root = &iomem_resource;
-		insert_resource(root, res);
-	}
-}
-
 #define RANGE_NUM 16
 
 struct res_range {
@@ -119,55 +69,6 @@ static void __init update_range(struct r
 	}
 }
 
-void __init update_res(struct pci_root_info *info, size_t start,
-			      size_t end, unsigned long flags, int merge)
-{
-	int i;
-	struct resource *res;
-
-	if (start > end)
-		return;
-
-	if (!merge)
-		goto addit;
-
-	/* try to merge it with old one */
-	for (i = 0; i < info->res_num; i++) {
-		size_t final_start, final_end;
-		size_t common_start, common_end;
-
-		res = &info->res[i];
-		if (res->flags != flags)
-			continue;
-
-		common_start = max((size_t)res->start, start);
-		common_end = min((size_t)res->end, end);
-		if (common_start > common_end + 1)
-			continue;
-
-		final_start = min((size_t)res->start, start);
-		final_end = max((size_t)res->end, end);
-
-		res->start = final_start;
-		res->end = final_end;
-		return;
-	}
-
-addit:
-
-	/* need to add that */
-	if (info->res_num >= RES_NUM)
-		return;
-
-	res = &info->res[info->res_num];
-	res->name = info->name;
-	res->flags = flags;
-	res->start = start;
-	res->end = end;
-	res->child = NULL;
-	info->res_num++;
-}
-
 struct pci_hostbridge_probe {
 	u32 bus;
 	u32 slot;
Index: linux-2.6/arch/x86/pci/bus_numa.c
===================================================================
--- /dev/null
+++ linux-2.6/arch/x86/pci/bus_numa.c
@@ -0,0 +1,101 @@
+#include <linux/init.h>
+#include <linux/pci.h>
+
+#include "bus_numa.h"
+
+int pci_root_num;
+struct pci_root_info pci_root_info[PCI_ROOT_NR];
+int found_all_numa_early;
+
+void x86_pci_root_bus_res_quirks(struct pci_bus *b)
+{
+	int i;
+	int j;
+	struct pci_root_info *info;
+
+	/* don't go for it if _CRS is used already */
+	if (b->resource[0] != &ioport_resource ||
+	    b->resource[1] != &iomem_resource)
+		return;
+
+	if (!pci_root_num)
+		return;
+
+	/* for amd, if only one root bus, don't need to do anything */
+	if (pci_root_num < 2 && found_all_numa_early)
+		return;
+
+	for (i = 0; i < pci_root_num; i++) {
+		if (pci_root_info[i].bus_min == b->number)
+			break;
+	}
+
+	if (i == pci_root_num)
+		return;
+
+	printk(KERN_DEBUG "PCI: peer root bus %02x res updated from pci conf\n",
+			b->number);
+
+	info = &pci_root_info[i];
+	for (j = 0; j < info->res_num; j++) {
+		struct resource *res;
+		struct resource *root;
+
+		res = &info->res[j];
+		b->resource[j] = res;
+		if (res->flags & IORESOURCE_IO)
+			root = &ioport_resource;
+		else
+			root = &iomem_resource;
+		insert_resource(root, res);
+	}
+}
+
+void __init update_res(struct pci_root_info *info, size_t start,
+			      size_t end, unsigned long flags, int merge)
+{
+	int i;
+	struct resource *res;
+
+	if (start > end)
+		return;
+
+	if (!merge)
+		goto addit;
+
+	/* try to merge it with old one */
+	for (i = 0; i < info->res_num; i++) {
+		size_t final_start, final_end;
+		size_t common_start, common_end;
+
+		res = &info->res[i];
+		if (res->flags != flags)
+			continue;
+
+		common_start = max((size_t)res->start, start);
+		common_end = min((size_t)res->end, end);
+		if (common_start > common_end + 1)
+			continue;
+
+		final_start = min((size_t)res->start, start);
+		final_end = max((size_t)res->end, end);
+
+		res->start = final_start;
+		res->end = final_end;
+		return;
+	}
+
+addit:
+
+	/* need to add that */
+	if (info->res_num >= RES_NUM)
+		return;
+
+	res = &info->res[info->res_num];
+	res->name = info->name;
+	res->flags = flags;
+	res->start = start;
+	res->end = end;
+	res->child = NULL;
+	info->res_num++;
+}
Index: linux-2.6/arch/x86/pci/bus_numa.h
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.h
+++ linux-2.6/arch/x86/pci/bus_numa.h
@@ -20,6 +20,7 @@ struct pci_root_info {
 #define PCI_ROOT_NR 4
 extern int pci_root_num;
 extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
+extern int found_all_numa_early;
 
 extern void update_res(struct pci_root_info *info, size_t start,
 			      size_t end, unsigned long flags, int merge);
Index: linux-2.6/arch/x86/pci/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/pci/Makefile
+++ linux-2.6/arch/x86/pci/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
-obj-$(CONFIG_X86_64)		+= intel_bus.o
+obj-$(CONFIG_X86_64)		+= bus_numa.o intel_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
