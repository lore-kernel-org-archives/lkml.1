Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533AbYFYT4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbYFYT4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:56:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYFYT4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:56:30 -0400
Received: from ns2.suse.de ([195.135.220.15]:38929 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYFYT43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:56:29 -0400
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com, Bernhard Walle <bwalle@suse.de>
Subject: [PATCH 2/2] Use FIRMWARE_MEMMAP on x86/E820
Date: Wed, 25 Jun 2008 21:57:06 +0200
Message-Id: <1214423826-12628-3-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1214423826-12628-1-git-send-email-bwalle@suse.de>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the /sys/firmware/memmap interface provided in the last patch
on the x86 architecture when E820 is used. The patch copies the E820
memory map very early, and registers the E820 map afterwards via
firmware_map_add_early().


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/x86/kernel/e820.c |   36 ++++++++++++++++++++++++++++++++++++
 include/asm-x86/e820.h |    2 ++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 3771386..14f5a83 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/pfn.h>
 #include <linux/suspend.h>
+#include <linux/firmware-map.h>
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
@@ -27,7 +28,22 @@
 #include <asm/setup.h>
 #include <asm/trampoline.h>
 
+/*
+ * The e820 map is the map that gets modified e.g. with command line parameters
+ * and that is also registered with modifications in the kernel resource tree
+ * with the iomem_resource as parent.
+ *
+ * The e820_saved is directly saved after the BIOS-provided memory map is
+ * copied. It doesn't get modified afterwards. It's registered for the
+ * /sys/firmware/memmap interface.
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
@@ -1056,6 +1072,17 @@ void __init finish_e820_parsing(void)
 	}
 }
 
+static inline enum firmware_map_type firmware_map_type_from_e820(int e820_type)
+{
+	switch (e820_type) {
+	case E820_RAM:		return MAP_RAM;
+	case E820_ACPI:		return MAP_ACPI;
+	case E820_RESERVED:	return MAP_RESERVED;
+	case E820_NVS:		return MAP_NVS;
+	default:		return MAP_RESERVED;
+	}
+}
+
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
@@ -1084,6 +1111,13 @@ void __init e820_reserve_resources(void)
 		insert_resource(&iomem_resource, res);
 		res++;
 	}
+
+	for (i = 0; i < e820_saved.nr_map; i++) {
+		struct e820entry *entry = &e820_saved.map[i];
+		firmware_map_add_early(entry->addr,
+			entry->addr + entry->size - 1,
+			firmware_map_type_from_e820(entry->type));
+	}
 }
 
 char *__init default_machine_specific_memory_setup(void)
@@ -1119,6 +1153,8 @@ char *__init default_machine_specific_memory_setup(void)
 		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
 	}
 
+	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+
 	/* In case someone cares... */
 	return who;
 }
diff --git a/include/asm-x86/e820.h b/include/asm-x86/e820.h
index 13a0a5f..607f940 100644
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

