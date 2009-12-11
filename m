Return-Path: <linux-kernel-owner+w=401wt.eu-S934005AbZLKXj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005AbZLKXj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935047AbZLKXjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:39:48 -0500
Received: from hera.kernel.org ([140.211.167.34]:57337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934973AbZLKXhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:37:10 -0500
Message-ID: <4B22D741.4060309@kernel.org>
Date: Fri, 11 Dec 2009 15:35:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 4/7] x86/pci: amd one chain system to use pci read out res
References: <4B22D4DA.2000104@kernel.org>
In-Reply-To: <4B22D4DA.2000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -87,11 +87,12 @@ static int __init early_fill_mp_bus_info
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
@@ -105,12 +106,12 @@ static int __init early_fill_mp_bus_info
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
Index: linux-2.6/arch/x86/pci/bus_numa.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.c
+++ linux-2.6/arch/x86/pci/bus_numa.c
@@ -5,7 +5,6 @@
 
 int pci_root_num;
 struct pci_root_info pci_root_info[PCI_ROOT_NR];
-int found_all_numa_early;
 
 void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 {
@@ -21,10 +20,6 @@ void x86_pci_root_bus_res_quirks(struct
 	if (!pci_root_num)
 		return;
 
-	/* for amd, if only one root bus, don't need to do anything */
-	if (pci_root_num < 2 && found_all_numa_early)
-		return;
-
 	for (i = 0; i < pci_root_num; i++) {
 		if (pci_root_info[i].bus_min == b->number)
 			break;
Index: linux-2.6/arch/x86/pci/bus_numa.h
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.h
+++ linux-2.6/arch/x86/pci/bus_numa.h
@@ -20,7 +20,6 @@ struct pci_root_info {
 #define PCI_ROOT_NR 4
 extern int pci_root_num;
 extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
-extern int found_all_numa_early;
 
 extern void update_res(struct pci_root_info *info, resource_size_t start,
 		      resource_size_t end, unsigned long flags, int merge);

