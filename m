Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZLVXmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZLVXmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbZLVXmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:42:17 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58175 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbZLVXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:42:05 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:40:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/25] x86/pci: amd one chain system to use pci read out res
In-reply-to: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261525263-13763-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261525263-13763-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

found MSI amd k8 based laptops is hiding [0x70000000, 0x80000000) RAM from
e820.

enable amd one chain even for all.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/amd_bus.c  |    7 ++++---
 arch/x86/pci/bus_numa.c |    5 -----
 arch/x86/pci/bus_numa.h |    1 -
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 2356ea1..e467071 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -87,11 +87,12 @@ static int __init early_fill_mp_bus_info(void)
 	struct range range[RANGE_NUM];
 	u64 val;
 	u32 address;
+	int found;
 
 	if (!early_pci_allowed())
 		return -1;
 
-	found_all_numa_early = 0;
+	found = 0;
 	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
 		u32 id;
 		u16 device;
@@ -105,12 +106,12 @@ static int __init early_fill_mp_bus_info(void)
 		device = (id>>16) & 0xffff;
 		if (pci_probes[i].vendor == vendor &&
 		    pci_probes[i].device == device) {
-			found_all_numa_early = 1;
+			found = 1;
 			break;
 		}
 	}
 
-	if (!found_all_numa_early)
+	if (!found)
 		return 0;
 
 	pci_root_num = 0;
diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 72ea29d..7ef0970 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -5,7 +5,6 @@
 
 int pci_root_num;
 struct pci_root_info pci_root_info[PCI_ROOT_NR];
-int found_all_numa_early;
 
 void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 {
@@ -21,10 +20,6 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	if (!pci_root_num)
 		return;
 
-	/* for amd, if only one root bus, don't need to do anything */
-	if (pci_root_num < 2 && found_all_numa_early)
-		return;
-
 	for (i = 0; i < pci_root_num; i++) {
 		if (pci_root_info[i].bus_min == b->number)
 			break;
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index 374ecc5..f63e802 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -20,7 +20,6 @@ struct pci_root_info {
 #define PCI_ROOT_NR 4
 extern int pci_root_num;
 extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
-extern int found_all_numa_early;
 
 extern void update_res(struct pci_root_info *info, resource_size_t start,
 		      resource_size_t end, unsigned long flags, int merge);
-- 
1.6.0.2

