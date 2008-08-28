Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYH1Tk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYH1Tk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbYH1TkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:40:05 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:1626 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbYH1TkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:40:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l3n2dO4rAyVxhI6eJDYMVn/y1wmnzg+W30ytrFx4qydbQzJD4WfofkWRCWEMMLa+om
         M6b7rq+ULDIWLCypRN9nJp6nhzqqMFrBbYY0Qq0R2RxFTFWxsFEmQoxfEbJi3xTZA8Oo
         MENrqXsSUg41d2q+lO/YaODSg2DJUAQGkUB2U=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: split e820 reserved entries record to late
Date: Thu, 28 Aug 2008 12:39:05 -0700
Message-Id: <1219952345-13574-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could let BAR res register at first, or even pnp?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   20 ++++++++++++++++++--
 arch/x86/pci/i386.c    |    3 +++
 include/asm-x86/e820.h |    1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1271,13 +1271,15 @@ static inline const char *e820_type_to_s
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
+struct resource __initdata *e820_res;
 void __init e820_reserve_resources(void)
 {
 	int i;
-	struct resource *res;
 	u64 end;
+	struct resource *res;
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
@@ -1291,7 +1293,8 @@ void __init e820_reserve_resources(void)
 		res->end = end;
 
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
+		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
+			insert_resource(&iomem_resource, res);
 		res++;
 	}
 
@@ -1303,6 +1306,19 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+void __init e820_reserve_resources_late(void)
+{
+	int i;
+	struct resource *res;
+
+	res = e820_res;
+	for (i = 0; i < e820.nr_map; i++) {
+		if (e820.map[i].type == E820_RESERVED && res->start >= (1ULL<<20))
+			insert_resource(&iomem_resource, res);
+		res++;
+	}
+}
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -36,6 +36,7 @@
 #include <asm/pat.h>
 #include <asm/hpet.h>
 #include <asm/io_apic.h>
+#include <asm/e820.h>
 
 #include "pci.h"
 
@@ -297,6 +298,8 @@ static int __init pcibios_assign_resourc
 		}
 	}
 
+	e820_reserve_resources_late();
+
 	pci_assign_unassigned_resources();
 
 	return 0;
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -122,6 +122,7 @@ extern void e820_register_active_regions
 extern u64 e820_hole_size(u64 start, u64 end);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
+extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
