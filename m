Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbZLLCNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbZLLCNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 21:13:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbZLLCM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 21:12:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:47225 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761399AbZLLCM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 21:12:57 -0500
Message-ID: <4B22FBEB.7040204@kernel.org>
Date: Fri, 11 Dec 2009 18:11:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 61/7] x86/pci: add cap_4g
References: <4B22D4DA.2000104@kernel.org> <4B22D74D.4020201@kernel.org>
In-Reply-To: <4B22D74D.4020201@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare for 32bit pci root bus

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/amd_bus.c   |    7 ++++---
 arch/x86/pci/bus_numa.c  |    4 ++++
 arch/x86/pci/intel_bus.c |    5 ++++-
 include/linux/range.h    |   10 ++++++++++
 4 files changed, 22 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -201,7 +201,7 @@ static int __init early_fill_mp_bus_info
 
 	memset(range, 0, sizeof(range));
 	/* 0xfd00000000-0xffffffffff for HT */
-	range[0].end = (0xfdULL<<32) - 1;
+	range[0].end = cap_4g((0xfdULL<<32) - 1);
 
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
@@ -286,7 +286,7 @@ static int __init early_fill_mp_bus_info
 			}
 		}
 
-		update_res(info, start, end, IORESOURCE_MEM, 1);
+		update_res(info, cap_4g(start), cap_4g(end), IORESOURCE_MEM, 1);
 		subtract_range(range, RANGE_NUM, start, end);
 		printk(KERN_CONT "\n");
 	}
@@ -321,7 +321,8 @@ static int __init early_fill_mp_bus_info
 			if (!range[i].end)
 				continue;
 
-			update_res(info, range[i].start, range[i].end,
+			update_res(info, cap_4g(range[i].start),
+				   cap_4g(range[i].end),
 				   IORESOURCE_MEM, 1);
 		}
 	}
Index: linux-2.6/arch/x86/pci/bus_numa.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.c
+++ linux-2.6/arch/x86/pci/bus_numa.c
@@ -55,6 +55,10 @@ void __init update_res(struct pci_root_i
 	if (start > end)
 		return;
 
+	if (sizeof(resource_size_t) < sizeof(u64) &&
+	    start == 0xffffffff)
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
@@ -81,7 +83,8 @@ static void __devinit pci_root_bus_res(s
 	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
 	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
 	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
-	update_res(info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
+	update_res(info, cap_4g(mmioh_base), cap_4g(mmioh_end),
+			 IORESOURCE_MEM, 0);
 
 	print_ioh_resources(info);
 }
Index: linux-2.6/include/linux/range.h
===================================================================
--- linux-2.6.orig/include/linux/range.h
+++ linux-2.6/include/linux/range.h
@@ -19,4 +19,14 @@ int clean_sort_range(struct range *range
 
 void sort_range(struct range *range, int nr_range);
 
+static inline u64 cap_4g(u64 val)
+{
+	if (sizeof(resource_size_t) >= sizeof(u64))
+		return val;
+
+	if (val < 1ULL)
+		return val;
+
+	return 0xffffffff;
+}
 #endif
