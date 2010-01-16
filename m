Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442Ab0APDMr (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 22:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849Ab0APDIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 22:08:23 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:33866 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab0APDIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 22:08:18 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 15 Jan 2010 19:06:35 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/37] x86/pci: add cap_resource
In-reply-to: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Message-id: <1263611228-6751-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263611228-6751-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare for 32bit pci root bus

-v2: hpa said we should compare with (resource_size_t)~0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/amd_bus.c   |    8 +++++---
 arch/x86/pci/bus_numa.c  |    3 +++
 arch/x86/pci/intel_bus.c |    5 ++++-
 include/linux/range.h    |    8 ++++++++
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 467dcac..66a5d5a 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -200,7 +200,7 @@ static int __init early_fill_mp_bus_info(void)
 
 	memset(range, 0, sizeof(range));
 	/* 0xfd00000000-0xffffffffff for HT */
-	range[0].end = (0xfdULL<<32) - 1;
+	range[0].end = cap_resource((0xfdULL<<32) - 1);
 
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
@@ -285,7 +285,8 @@ static int __init early_fill_mp_bus_info(void)
 			}
 		}
 
-		update_res(info, start, end, IORESOURCE_MEM, 1);
+		update_res(info, cap_resource(start), cap_resource(end),
+				 IORESOURCE_MEM, 1);
 		subtract_range(range, RANGE_NUM, start, end);
 		printk(KERN_CONT "\n");
 	}
@@ -320,7 +321,8 @@ static int __init early_fill_mp_bus_info(void)
 			if (!range[i].end)
 				continue;
 
-			update_res(info, range[i].start, range[i].end,
+			update_res(info, cap_resource(range[i].start),
+				   cap_resource(range[i].end),
 				   IORESOURCE_MEM, 1);
 		}
 	}
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index f939d60..b267919 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -60,6 +60,9 @@ void __devinit update_res(struct pci_root_info *info, size_t start,
 	if (start > end)
 		return;
 
+	if (start == (resource_size_t)~0)
+		return;
+
 	if (!merge)
 		goto addit;
 
diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
index f81a2fa..145e0dd 100644
--- a/arch/x86/pci/intel_bus.c
+++ b/arch/x86/pci/intel_bus.c
@@ -6,6 +6,8 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/range.h>
+
 #include <asm/pci_x86.h>
 
 #include "bus_numa.h"
@@ -85,7 +87,8 @@ static void __devinit pci_root_bus_res(struct pci_dev *dev)
 	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
 	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
 	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
+	update_res(info, cap_resource(mmioh_base), cap_resource(mmioh_end),
+			 IORESOURCE_MEM, 0);
 
 	print_ioh_resources(info);
 }
diff --git a/include/linux/range.h b/include/linux/range.h
index 0789f14..17a23d2 100644
--- a/include/linux/range.h
+++ b/include/linux/range.h
@@ -19,4 +19,12 @@ int clean_sort_range(struct range *range, int az);
 
 void sort_range(struct range *range, int nr_range);
 
+
+static inline resource_size_t cap_resource(u64 val)
+{
+	if (val > (resource_size_t)~0)
+		return (resource_size_t)~0;
+	else
+		return val;
+}
 #endif
-- 
1.6.4.2

