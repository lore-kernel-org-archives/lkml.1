Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0BITid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:38:33 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54598 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:16 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/35] x86/pci: use u64 instead of size_t in amd_bus.c
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to enable it for 32bit

-v2: remove not needed cast

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/amd_bus.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e467071..e8bb553 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -82,8 +82,8 @@ static int __init early_fill_mp_bus_info(void)
 	struct pci_root_info *info;
 	u32 reg;
 	struct resource *res;
-	size_t start;
-	size_t end;
+	u64 start;
+	u64 end;
 	struct range range[RANGE_NUM];
 	u64 val;
 	u32 address;
@@ -173,7 +173,7 @@ static int __init early_fill_mp_bus_info(void)
 
 		info = &pci_root_info[j];
 		printk(KERN_DEBUG "node %d link %d: io port [%llx, %llx]\n",
-		       node, link, (u64)start, (u64)end);
+		       node, link, start, end);
 
 		/* kernel only handle 16 bit only */
 		if (end > 0xffff)
@@ -207,7 +207,7 @@ static int __init early_fill_mp_bus_info(void)
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
 	end = (val & 0xffffff800000ULL);
-	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
+	printk(KERN_INFO "TOM: %016llx aka %lldM\n", end, end>>20);
 	if (end < (1ULL<<32))
 		subtract_range(range, RANGE_NUM, 0, end - 1);
 
@@ -246,7 +246,7 @@ static int __init early_fill_mp_bus_info(void)
 		info = &pci_root_info[j];
 
 		printk(KERN_DEBUG "node %d link %d: mmio [%llx, %llx]",
-		       node, link, (u64)start, (u64)end);
+		       node, link, start, end);
 		/*
 		 * some sick allocation would have range overlap with fam10h
 		 * mmconf range, so need to update start and end.
@@ -272,13 +272,13 @@ static int __init early_fill_mp_bus_info(void)
 				endx = fam10h_mmconf_start - 1;
 				update_res(info, start, endx, IORESOURCE_MEM, 0);
 				subtract_range(range, RANGE_NUM, start, endx);
-				printk(KERN_CONT " ==> [%llx, %llx]", (u64)start, endx);
+				printk(KERN_CONT " ==> [%llx, %llx]", start, endx);
 				start = fam10h_mmconf_end + 1;
 				changed = 1;
 			}
 			if (changed) {
 				if (start <= end) {
-					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", (u64)start, (u64)end);
+					printk(KERN_CONT " %s [%llx, %llx]", endx?"and":"==>", start, end);
 				} else {
 					printk(KERN_CONT "%s\n", endx?"":" ==> none");
 					continue;
@@ -301,7 +301,7 @@ static int __init early_fill_mp_bus_info(void)
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
-		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
+		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", end, end>>20);
 		subtract_range(range, RANGE_NUM, 1ULL<<32, end - 1);
 	}
 
-- 
1.6.4.2

