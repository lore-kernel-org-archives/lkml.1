Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab0BJJ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 04:28:18 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39119 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab0BJJVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 04:21:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 10 Feb 2010 01:20:11 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/35] x86/pci: add cap_resource
In-reply-to: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265793639-15071-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare for 32bit pci root bus

-v2: hpa said we should compare with (resource_size_t)~0
-v3: according to Linus to use MAX_RESOURCE instead.
     also need need to put related patches together
-v4: according to Andrew, use min in cap_resource()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/amd_bus.c  |    8 +++++---
 arch/x86/pci/bus_numa.c |    4 ++++
 include/linux/range.h   |    8 ++++++++
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index f06bb1b..f7e13b6 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -201,7 +201,7 @@ static int __init early_fill_mp_bus_info(void)
 
 	memset(range, 0, sizeof(range));
 	/* 0xfd00000000-0xffffffffff for HT */
-	range[0].end = (0xfdULL<<32) - 1;
+	range[0].end = cap_resource((0xfdULL<<32) - 1);
 
 	/* need to take out [0, TOM) for RAM*/
 	address = MSR_K8_TOP_MEM1;
@@ -286,7 +286,8 @@ static int __init early_fill_mp_bus_info(void)
 			}
 		}
 
-		update_res(info, start, end, IORESOURCE_MEM, 1);
+		update_res(info, cap_resource(start), cap_resource(end),
+				 IORESOURCE_MEM, 1);
 		subtract_range(range, RANGE_NUM, start, end);
 		printk(KERN_CONT "\n");
 	}
@@ -321,7 +322,8 @@ static int __init early_fill_mp_bus_info(void)
 			if (!range[i].end)
 				continue;
 
-			update_res(info, range[i].start, range[i].end,
+			update_res(info, cap_resource(range[i].start),
+				   cap_resource(range[i].end),
 				   IORESOURCE_MEM, 1);
 		}
 	}
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 3411687..3510778 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -1,5 +1,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
+#include <linux/range.h>
 
 #include "bus_numa.h"
 
@@ -55,6 +56,9 @@ void __devinit update_res(struct pci_root_info *info, resource_size_t start,
 	if (start > end)
 		return;
 
+	if (start == MAX_RESOURCE)
+		return;
+
 	if (!merge)
 		goto addit;
 
diff --git a/include/linux/range.h b/include/linux/range.h
index 0789f14..bd184a5 100644
--- a/include/linux/range.h
+++ b/include/linux/range.h
@@ -19,4 +19,12 @@ int clean_sort_range(struct range *range, int az);
 
 void sort_range(struct range *range, int nr_range);
 
+#define MAX_RESOURCE ((resource_size_t)~0)
+static inline resource_size_t cap_resource(u64 val)
+{
+	if (val > MAX_RESOURCE)
+		return MAX_RESOURCE;
+
+	return val;
+}
 #endif
-- 
1.6.4.2

