Return-Path: <linux-kernel-owner+w=401wt.eu-S1758203AbYFKDbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbYFKDbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 23:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbYFKDbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 23:31:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:59566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbYFKDbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 23:31:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,621,1204531200"; 
   d="scan'208";a="575206445"
Subject: [PATCH] x86 boot: Pass E820 memory map entries more than 128 via
	linked list of setup data
From: "Huang, Ying" <ying.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jun 2008 11:33:39 +0800
Message-Id: <1213155219.13392.2.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 11 Jun 2008 03:31:07.0710 (UTC) FILETIME=[95ED65E0:01C8CB73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the size limits of struct boot_params (zero page), the
maximum number of E820 memory map entries can be passed to kernel is
128. As pointed by Paul Jackson, there is some machine produced by SGI
with so many nodes that the number of E820 memory map entries is more
than 128. To enabling Linux kernel on these system, a new setup data
type named SETUP_E820_EXT is defined to pass additional memory map
entries to Linux kernel.

This patch is based on x86/auto-latest branch of git-x86 tree and has
been tested on x86_64 and i386 platform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/e820.c      |   59 ++++++++++++++++++++++++++++++++++----------
 arch/x86/kernel/setup.c     |    3 ++
 include/asm-x86/bootparam.h |    1 
 include/asm-x86/e820.h      |    2 +
 4 files changed, 52 insertions(+), 13 deletions(-)

--- a/include/asm-x86/bootparam.h
+++ b/include/asm-x86/bootparam.h
@@ -11,6 +11,7 @@
 
 /* setup data types */
 #define SETUP_NONE			0
+#define SETUP_E820_EXT			1
 
 /* extensible setup data list node */
 struct setup_data {
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -359,6 +359,26 @@ static struct e820entry new_bios[E820_X_
 	return 0;
 }
 
+static int __init __copy_e820_map(struct e820entry *biosmap, int nr_map)
+{
+	while (nr_map) {
+		u64 start = biosmap->addr;
+		u64 size = biosmap->size;
+		u64 end = start + size;
+		u32 type = biosmap->type;
+
+		/* Overflow in 64 bits? Ignore the memory map. */
+		if (start > end)
+			return -1;
+
+		add_memory_region(start, size, type);
+
+		biosmap++;
+		nr_map--;
+	}
+	return 0;
+}
+
 /*
  * Copy the BIOS e820 map into a safe place.
  *
@@ -374,19 +394,7 @@ int __init copy_e820_map(struct e820entr
 	if (nr_map < 2)
 		return -1;
 
-	do {
-		u64 start = biosmap->addr;
-		u64 size = biosmap->size;
-		u64 end = start + size;
-		u32 type = biosmap->type;
-
-		/* Overflow in 64 bits? Ignore the memory map. */
-		if (start > end)
-			return -1;
-
-		add_memory_region(start, size, type);
-	} while (biosmap++, --nr_map);
-	return 0;
+	return __copy_e820_map(biosmap, nr_map);
 }
 
 u64 __init update_memory_range(u64 start, u64 size, unsigned old_type,
@@ -496,6 +504,31 @@ __init void e820_setup_gap(void)
 	       pci_mem_start, gapstart, gapsize);
 }
 
+/**
+ * Because of the size limitation of struct boot_params, only first
+ * 128 E820 memory entries are passed to kernel via
+ * boot_params.e820_map, others are passed via SETUP_E820_EXT node of
+ * linked list of struct setup_data, which is parsed here.
+ */
+void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
+{
+	u32 map_len;
+	int entries;
+	struct e820entry *extmap;
+
+	entries = sdata->len / sizeof(struct e820entry);
+	map_len = sdata->len + sizeof(struct setup_data);
+	if (map_len > PAGE_SIZE)
+		sdata = early_ioremap(pa_data, map_len);
+	extmap = (struct e820entry *)(sdata->data);
+	__copy_e820_map(extmap, entries);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	if (map_len > PAGE_SIZE)
+		early_iounmap(sdata, map_len);
+	printk(KERN_INFO "extended physical RAM map:\n");
+	e820_print_map("extended");
+}
+
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
 /**
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -231,6 +231,9 @@ void __init parse_setup_data(void)
 	while (pa_data) {
 		data = early_ioremap(pa_data, PAGE_SIZE);
 		switch (data->type) {
+		case SETUP_E820_EXT:
+			parse_e820_ext(data, pa_data);
+			break;
 		default:
 			break;
 		}
--- a/include/asm-x86/e820.h
+++ b/include/asm-x86/e820.h
@@ -69,6 +69,8 @@ extern u64 update_memory_range(u64 start
 			       unsigned new_type);
 extern void update_e820(void);
 extern void e820_setup_gap(void);
+struct setup_data;
+extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))

