Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbZKKUcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbZKKUcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZKKUcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:32:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:48566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZKKUcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:32:45 -0500
Date: Wed, 11 Nov 2009 20:30:55 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       hpa@zytor.com, mingo@redhat.com, yinghai@kernel.org,
       torvalds@linux-foundation.org, lenb@kernel.org, tglx@linutronix.de,
       rjw@sisk.pl, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, lenb@kernel.org, yinghai@kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, rjw@sisk.pl,
       mingo@elte.hu
In-Reply-To: <4AFA210B.3020207@kernel.org>
References: <4AFA210B.3020207@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Make sure wakeup trampoline code is below 1MB
Message-ID: <tip-196cf0d67acad70ebb2572da489d5cc7066cdd05@git.kernel.org>
Git-Commit-ID: 196cf0d67acad70ebb2572da489d5cc7066cdd05
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  196cf0d67acad70ebb2572da489d5cc7066cdd05
Gitweb:     http://git.kernel.org/tip/196cf0d67acad70ebb2572da489d5cc7066cdd05
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 10 Nov 2009 18:27:23 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 11 Nov 2009 20:14:32 +0100

x86: Make sure wakeup trampoline code is below 1MB

Instead of using bootmem, try find_e820_area()/reserve_early(),
and call acpi_reserve_memory() early, to allocate the wakeup
trampoline code area below 1M.

This is more reliable, and it also removes a dependency on
bootmem.

-v2: change function name to acpi_reserve_wakeup_memory(),
     as suggested by Rafael.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <4AFA210B.3020207@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/acpi.h  |    2 +-
 arch/x86/kernel/acpi/sleep.c |   15 +++++++++------
 arch/x86/kernel/setup.c      |   13 +++++++------
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index e3d4a0d..60d2b2d 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -118,7 +118,7 @@ extern void acpi_restore_state_mem(void);
 extern unsigned long acpi_wakeup_address;
 
 /* early initialization routine */
-extern void acpi_reserve_bootmem(void);
+extern void acpi_reserve_wakeup_memory(void);
 
 /*
  * Check if the CPU can handle C2 and deeper
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index ca93638..4a41145 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -119,29 +119,32 @@ void acpi_restore_state_mem(void)
 
 
 /**
- * acpi_reserve_bootmem - do _very_ early ACPI initialisation
+ * acpi_reserve_wakeup_memory - do _very_ early ACPI initialisation
  *
  * We allocate a page from the first 1MB of memory for the wakeup
  * routine for when we come back from a sleep state. The
  * runtime allocator allows specification of <16MB pages, but not
  * <1MB pages.
  */
-void __init acpi_reserve_bootmem(void)
+void __init acpi_reserve_wakeup_memory(void)
 {
+	unsigned long mem;
+
 	if ((&wakeup_code_end - &wakeup_code_start) > WAKEUP_SIZE) {
 		printk(KERN_ERR
 		       "ACPI: Wakeup code way too big, S3 disabled.\n");
 		return;
 	}
 
-	acpi_realmode = (unsigned long)alloc_bootmem_low(WAKEUP_SIZE);
+	mem = find_e820_area(0, 1<<20, WAKEUP_SIZE, PAGE_SIZE);
 
-	if (!acpi_realmode) {
+	if (mem == -1L) {
 		printk(KERN_ERR "ACPI: Cannot allocate lowmem, S3 disabled.\n");
 		return;
 	}
-
-	acpi_wakeup_address = virt_to_phys((void *)acpi_realmode);
+	acpi_realmode = (unsigned long) phys_to_virt(mem);
+	acpi_wakeup_address = mem;
+	reserve_early(mem, mem + WAKEUP_SIZE, "ACPI WAKEUP");
 }
 
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f891419..0a6e94a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -897,6 +897,13 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+#ifdef CONFIG_ACPI_SLEEP
+	/*
+	 * Reserve low memory region for sleep support.
+	 * even before init_memory_mapping
+	 */
+	acpi_reserve_wakeup_memory();
+#endif
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
@@ -948,12 +955,6 @@ void __init setup_arch(char **cmdline_p)
 
 	initmem_init(0, max_pfn, acpi, k8);
 
-#ifdef CONFIG_ACPI_SLEEP
-	/*
-	 * Reserve low memory region for sleep support.
-	 */
-	acpi_reserve_bootmem();
-#endif
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
