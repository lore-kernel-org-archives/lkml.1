Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891Ab0AUGcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0AUGcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:32:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871Ab0AUGc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:32:29 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:36113 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0AUG3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:29:25 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 20 Jan 2010 22:28:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 26/36] x86: remove bios data range from e820
In-reply-to: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264055303-15123-27-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

to prepare move page_is_ram as generic one

Signed-off-by: Yinghai Lu <yinghai@kernel.org.
---
 arch/x86/kernel/e820.c   |    8 ++++++++
 arch/x86/kernel/head32.c |    2 --
 arch/x86/kernel/head64.c |    2 --
 arch/x86/kernel/setup.c  |   19 ++++++++++++++++++-
 arch/x86/mm/ioremap.c    |   16 ----------------
 5 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 62235e7..09ca6e8 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -509,11 +509,19 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 			     int checktype)
 {
 	int i;
+	u64 end;
 	u64 real_removed_size = 0;
 
 	if (size > (ULLONG_MAX - start))
 		size = ULLONG_MAX - start;
 
+	end = start + size;
+	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
+		       (unsigned long long) start,
+		       (unsigned long long) end);
+	e820_print_type(old_type);
+	printk(KERN_CONT "\n");
+
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		u64 final_start, final_end;
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 2e13544..adedeef 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,8 +29,6 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	reserve_early_overlap_ok(0, PAGE_SIZE, "BIOS data page");
-
 #ifdef CONFIG_X86_TRAMPOLINE
 	/*
 	 * But first pinch a few for the stack/trampoline stuff
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 452b7c4..b5a9896 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,8 +98,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
-	reserve_early_overlap_ok(0, PAGE_SIZE, "BIOS data page");
-
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 824fef7..8b27c6c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -659,6 +659,23 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 	{}
 };
 
+static void __init e820_trim_bios_range(void)
+{
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 */
+	e820_update_range(0, PAGE_SIZE, E820_RAM, E820_RESERVED);
+	/*
+	 * special case: Some BIOSen report the PC BIOS
+	 * area (640->1Mb) as ram even though it is not.
+	 * take them out.
+	 */
+	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures
@@ -822,7 +839,7 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-
+	e820_trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 03c75ff..3c739b7 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -29,22 +29,6 @@ int page_is_ram(unsigned long pagenr)
 	resource_size_t addr, end;
 	int i;
 
-	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 */
-	if (pagenr == 0)
-		return 0;
-
-	/*
-	 * Second special case: Some BIOSen report the PC BIOS
-	 * area (640->1Mb) as ram even though it is not.
-	 */
-	if (pagenr >= (BIOS_BEGIN >> PAGE_SHIFT) &&
-		    pagenr < (BIOS_END >> PAGE_SHIFT))
-		return 0;
-
 	for (i = 0; i < e820.nr_map; i++) {
 		/*
 		 * Not usable memory:
-- 
1.6.4.2

