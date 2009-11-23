Return-Path: <linux-kernel-owner+w=401wt.eu-S1756019AbZKWIna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbZKWIna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755831AbZKWIn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:43:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:51697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbZKWIn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:43:28 -0500
Date: Mon, 23 Nov 2009 08:42:45 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       ebiederm@xmission.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, ebiederm@xmission.com,
       mingo@elte.hu
In-Reply-To: <4B09E2F9.7040403@kernel.org>
References: <4B09E2F9.7040403@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Change crash kernel to reserve via reserve_early()
Message-ID: <tip-44280733e71ad15377735b42d8538c109c94d7e3@git.kernel.org>
Git-Commit-ID: 44280733e71ad15377735b42d8538c109c94d7e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44280733e71ad15377735b42d8538c109c94d7e3
Gitweb:     http://git.kernel.org/tip/44280733e71ad15377735b42d8538c109c94d7e3
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 22 Nov 2009 17:18:49 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 09:09:23 +0100

x86: Change crash kernel to reserve via reserve_early()

use find_e820_area()/reserve_early() instead.

-v2: address Eric's request, to restore original semantics.
     will fail, if the provided address can not be used.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
LKML-Reference: <4B09E2F9.7040403@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/setup.c |   57 ++++++++++++----------------------------------
 1 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d2043a0..e3eae59 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -487,42 +487,11 @@ static void __init reserve_early_setup_data(void)
 
 #ifdef CONFIG_KEXEC
 
-/**
- * Reserve @size bytes of crashkernel memory at any suitable offset.
- *
- * @size: Size of the crashkernel memory to reserve.
- * Returns the base address on success, and -1ULL on failure.
- */
-static
-unsigned long long __init find_and_reserve_crashkernel(unsigned long long size)
-{
-	const unsigned long long alignment = 16<<20; 	/* 16M */
-	unsigned long long start = 0LL;
-
-	while (1) {
-		int ret;
-
-		start = find_e820_area(start, ULONG_MAX, size, alignment);
-		if (start == -1ULL)
-			return start;
-
-		/* try to reserve it */
-		ret = reserve_bootmem_generic(start, size, BOOTMEM_EXCLUSIVE);
-		if (ret >= 0)
-			return start;
-
-		start += alignment;
-	}
-}
-
 static inline unsigned long long get_total_mem(void)
 {
 	unsigned long long total;
 
-	total = max_low_pfn - min_low_pfn;
-#ifdef CONFIG_HIGHMEM
-	total += highend_pfn - highstart_pfn;
-#endif
+	total = max_pfn - min_low_pfn;
 
 	return total << PAGE_SHIFT;
 }
@@ -542,21 +511,25 @@ static void __init reserve_crashkernel(void)
 
 	/* 0 means: find the address automatically */
 	if (crash_base <= 0) {
-		crash_base = find_and_reserve_crashkernel(crash_size);
+		const unsigned long long alignment = 16<<20;	/* 16M */
+
+		crash_base = find_e820_area(alignment, ULONG_MAX, crash_size,
+				 alignment);
 		if (crash_base == -1ULL) {
-			pr_info("crashkernel reservation failed. "
-				"No suitable area found.\n");
+			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
 		}
 	} else {
-		ret = reserve_bootmem_generic(crash_base, crash_size,
-					BOOTMEM_EXCLUSIVE);
-		if (ret < 0) {
-			pr_info("crashkernel reservation failed - "
-				"memory is in use\n");
+		unsigned long long start;
+
+		start = find_e820_area(crash_base, ULONG_MAX, crash_size,
+				 1<<20);
+		if (start != crash_base) {
+			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
 		}
 	}
+	reserve_early(crash_base, crash_base + crash_size, "CRASH KERNEL");
 
 	printk(KERN_INFO "Reserving %ldMB of memory at %ldMB "
 			"for crashkernel (System RAM: %ldMB)\n",
@@ -927,6 +900,8 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_initrd();
 
+	reserve_crashkernel();
+
 	vsmp_init();
 
 	io_delay_init();
@@ -957,8 +932,6 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	find_smp_config();
 
-	reserve_crashkernel();
-
 #ifdef CONFIG_X86_64
 	/*
 	 * dma32_reserve_bootmem() allocates bootmem which may conflict
