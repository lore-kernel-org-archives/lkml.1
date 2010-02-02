Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab0BBBBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:01:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:51427 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab0BBBBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:01:45 -0500
Date: Tue, 2 Feb 2010 01:01:20 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       fengguang.wu@intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org, tglx@linutronix.de,
       fengguang.wu@intel.com
In-Reply-To: <20100122033004.335813103@intel.com>
References: <20100122033004.335813103@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Remove BIOS data range from e820
Message-ID: <tip-1b5576e69a5fe168c08a159685ac366316ac9bbc@git.kernel.org>
Git-Commit-ID: 1b5576e69a5fe168c08a159685ac366316ac9bbc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Feb 2010 01:01:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b5576e69a5fe168c08a159685ac366316ac9bbc
Gitweb:     http://git.kernel.org/tip/1b5576e69a5fe168c08a159685ac366316ac9bbc
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 22 Jan 2010 11:21:04 +0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Feb 2010 16:58:17 -0800

x86: Remove BIOS data range from e820

In preparation for moving to the generic page_is_ram(), make explicit
what we expect to be reserved and not reserved.

Tested-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20100122033004.335813103@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/e820.c  |    8 ++++++++
 arch/x86/kernel/setup.c |   19 ++++++++++++++++++-
 arch/x86/mm/ioremap.c   |   16 ----------------
 3 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d17d482..230687b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -517,11 +517,19 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
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
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cdb6a8a..f9b1f4e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -650,6 +650,23 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 	{}
 };
 
+static void __init trim_bios_range(void)
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
@@ -813,7 +830,7 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-
+	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..30e068d 100644
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
