Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYFTP5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYFTP5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbYFTP41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:56:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:56872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880AbYFTP4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:56:24 -0400
From: Bernhard Walle <bwalle@suse.de>
To: kexec@lists.infradead.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 2/3] Use /proc/firmware_mem for x86 (e820)
Date: Fri, 20 Jun 2008 17:56:59 +0200
Message-Id: <1213977420-1555-3-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213977420-1555-1-git-send-email-bwalle@suse.de>
References: <1213977420-1555-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch copies the E820 map very early, before the kernel applies various
operations. That copy is used later to register only the BIOS-provided E820
map later in the resource tree for /proc/firmware_mem.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/e820.c |   44 ++++++++++++++++++++++++++++++++++----------
 include/asm-x86/e820.h |    2 ++
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 7b613d2..f5b1736 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -27,7 +27,22 @@
 #include <asm/setup.h>
 #include <asm/trampoline.h>
 
+/*
+ * The e820 map is the map that gets modified e.g. with command line parameters
+ * and that is also registered with modifications in the kernel resource tree
+ * with the iomem_resource as parent.
+ *
+ * The e820_saved is directly saved after the BIOS-provided memory map is
+ * copied. It doesn't get modified afterwards. It's registered in the
+ * resource system of the kernel with firmware_mem_resource as parent.
+ *
+ * That memory map is not modified and is used as base for kexec. The kexec'd
+ * kernel should get the same memory map as the firmware provides. Then the
+ * user can e.g. boot the original kernel with mem=1G while still booting the
+ * next kernel with full memory.
+ */
 struct e820map e820;
+struct e820map e820_saved;
 
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0xaeedbabe;
@@ -999,24 +1014,22 @@ void __init finish_e820_parsing(void)
 	}
 }
 
-/*
- * Mark e820 reserved areas as busy for the resource manager.
- */
-void __init e820_reserve_resources(void)
+static void __init e820_reserve_resources_map(struct e820map  *map,
+					      struct resource *root)
 {
 	int i;
 	struct resource *res;
 
-	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
-	for (i = 0; i < e820.nr_map; i++) {
-		switch (e820.map[i].type) {
+	res = alloc_bootmem_low(sizeof(struct resource) * map->nr_map);
+	for (i = 0; i < map->nr_map; i++) {
+		switch (map->map[i].type) {
 		case E820_RAM:	res->name = "System RAM"; break;
 		case E820_ACPI:	res->name = "ACPI Tables"; break;
 		case E820_NVS:	res->name = "ACPI Non-volatile Storage"; break;
 		default:	res->name = "reserved";
 		}
-		res->start = e820.map[i].addr;
-		res->end = res->start + e820.map[i].size - 1;
+		res->start = map->map[i].addr;
+		res->end = res->start + map->map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
 		if (res->end > 0x100000000ULL) {
 			res++;
@@ -1024,11 +1037,20 @@ void __init e820_reserve_resources(void)
 		}
 #endif
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
+		insert_resource(root, res);
 		res++;
 	}
 }
 
+/*
+ * Mark e820 reserved areas as busy for the resource manager.
+ */
+void __init e820_reserve_resources(void)
+{
+	e820_reserve_resources_map(&e820, &iomem_resource);
+	e820_reserve_resources_map(&e820_saved, &firmware_mem_resource);
+}
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
@@ -1062,6 +1084,8 @@ char *__init default_machine_specific_memory_setup(void)
 		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
 	}
 
+	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+
 	/* In case someone cares... */
 	return who;
 }
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index 668a0d7..48e7181 100644
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -56,7 +56,9 @@ struct e820map {
 	struct e820entry map[E820_X_MAX];
 };
 
+/* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
+extern struct e820map e820_saved;
 
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
-- 
1.5.4.5

