Return-Path: <linux-kernel-owner+w=401wt.eu-S932700AbZLRUMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700AbZLRUMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZLRUL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:11:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:55346 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932640AbZLRULJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:11:09 -0500
Message-ID: <4B2BE18D.1040108@kernel.org>
Date: Fri, 18 Dec 2009 12:09:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 5/7] x86/pci: add cap_resource -v2
References: <4B2BE063.4040704@kernel.org>
In-Reply-To: <4B2BE063.4040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



prepare for 32bit pci root bus

-v2: hpa said we should compare with (resource_size_t)~0

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/amd_bus.c   |    8 +++++---
 arch/x86/pci/bus_numa.c  |    3 +++
 arch/x86/pci/intel_bus.c |    5 ++++-
 include/linux/range.h    |    8 ++++++++
 4 files changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -201,7 +201,7 @@ static int __init early_fill_mp_bus_info
 
 	memset(range, 0, sizeof(range));
 	/* 0xfd00000000-0xffffffffff for HT */
-	range[0].end = (0xfdULL<<32) - 1;
+	range[0].end = cap_resource((0xfdULL<<32) - 1);
 
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
@@ -286,7 +286,8 @@ static int __init early_fill_mp_bus_info
 			}
 		}
 
-		update_res(info, start, end, IORESOURCE_MEM, 1);
+		update_res(info, cap_resource(start), cap_resource(end),
+				 IORESOURCE_MEM, 1);
 		subtract_range(range, RANGE_NUM, start, end);
 		printk(KERN_CONT "\n");
 	}
@@ -321,7 +322,8 @@ static int __init early_fill_mp_bus_info
 			if (!range[i].end)
 				continue;
 
-			update_res(info, range[i].start, range[i].end,
+			update_res(info, cap_resource(range[i].start),
+				   cap_resource(range[i].end),
 				   IORESOURCE_MEM, 1);
 		}
 	}
Index: linux-2.6/arch/x86/pci/bus_numa.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.c
+++ linux-2.6/arch/x86/pci/bus_numa.c
@@ -55,6 +55,9 @@ void __init update_res(struct pci_root_i
 	if (start > end)
 		return;
 
+	if (start == (resource_size_t)~0)
+		return;
+
 	if (!merge)
 		goto addit;
 
Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -6,6 +6,8 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/range.h>
+
 #include <asm/pci_x86.h>
 
 #include "bus_numa.h"
@@ -85,7 +87,8 @@ static void __devinit pci_root_bus_res(s
 	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
 	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
 	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
+	update_res(info, cap_resource(mmioh_base), cap_resource(mmioh_end),
+			 IORESOURCE_MEM, 0);
 
 	print_ioh_resources(info);
 }
Index: linux-2.6/include/linux/range.h
===================================================================
--- linux-2.6.orig/include/linux/range.h
+++ linux-2.6/include/linux/range.h
@@ -19,4 +19,12 @@ int clean_sort_range(struct range *range
 
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

