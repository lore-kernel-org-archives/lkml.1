Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZLKI4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZLKI4s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbZLKI4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:56:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:52628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbZLKI4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:56:41 -0500
Date: Fri, 11 Dec 2009 08:55:45 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, randy.dunlap@oracle.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, randy.dunlap@oracle.com, jens.axboe@oracle.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B21630A.6000308@kernel.org>
References: <4B21630A.6000308@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Use find_e820() instead of hard coded trampoline address
Message-ID: <tip-893f38d144a4d96d2483cd7c3801d26e1b2c23e9@git.kernel.org>
Git-Commit-ID: 893f38d144a4d96d2483cd7c3801d26e1b2c23e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  893f38d144a4d96d2483cd7c3801d26e1b2c23e9
Gitweb:     http://git.kernel.org/tip/893f38d144a4d96d2483cd7c3801d26e1b2c23e9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 10 Dec 2009 13:07:22 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Dec 2009 09:28:22 +0100

x86: Use find_e820() instead of hard coded trampoline address

Jens found the following crash/regression:

[    0.000000] found SMP MP-table at [ffff8800000fdd80] fdd80
[    0.000000] Kernel panic - not syncing: Overlapping early reservations 12-f011 MP-table mpc to 0-fff BIOS data page

and

[    0.000000] Kernel panic - not syncing: Overlapping early reservations 12-f011 MP-table mpc to 6000-7fff TRAMPOLINE

and bisected it to b24c2a9 ("x86: Move find_smp_config()
earlier and avoid bootmem usage").

It turns out the BIOS is using the first 64k for mptable,
without reserving it.

So try to find good range for the real-mode trampoline instead of
hard coding it, in case some bios tries to use that range for sth.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Jens Axboe <jens.axboe@oracle.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
LKML-Reference: <4B21630A.6000308@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/trampoline.h |    1 -
 arch/x86/kernel/e820.c            |   11 ++++++++++-
 arch/x86/kernel/head32.c          |    2 --
 arch/x86/kernel/head64.c          |    2 --
 arch/x86/kernel/mpparse.c         |    3 ---
 arch/x86/kernel/setup.c           |   13 ++++++++-----
 arch/x86/kernel/trampoline.c      |   20 +++++++++-----------
 7 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/trampoline.h b/arch/x86/include/asm/trampoline.h
index 90f06c2..cb507bb 100644
--- a/arch/x86/include/asm/trampoline.h
+++ b/arch/x86/include/asm/trampoline.h
@@ -16,7 +16,6 @@ extern unsigned long initial_code;
 extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
-#define TRAMPOLINE_BASE 0x6000
 
 extern unsigned long setup_trampoline(void);
 extern void __init reserve_trampoline_memory(void);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d17d482..f50447d 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -732,7 +732,16 @@ struct early_res {
 	char overlap_ok;
 };
 static struct early_res early_res[MAX_EARLY_RES] __initdata = {
-	{ 0, PAGE_SIZE, "BIOS data page" },	/* BIOS data page */
+	{ 0, PAGE_SIZE, "BIOS data page", 1 },	/* BIOS data page */
+#ifdef CONFIG_X86_32
+	/*
+	 * But first pinch a few for the stack/trampoline stuff
+	 * FIXME: Don't need the extra page at 4K, but need to fix
+	 * trampoline before removing it. (see the GDT stuff)
+	 */
+	{ PAGE_SIZE, PAGE_SIZE, "EX TRAMPOLINE", 1 },
+#endif
+
 	{}
 };
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 4f8e250..5051b94 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -29,8 +29,6 @@ static void __init i386_default_early_setup(void)
 
 void __init i386_start_kernel(void)
 {
-	reserve_trampoline_memory();
-
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 0b06cd7..b5a9896 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -98,8 +98,6 @@ void __init x86_64_start_reservations(char *real_mode_data)
 {
 	copy_bootdata(__va(real_mode_data));
 
-	reserve_trampoline_memory();
-
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 35a57c9..40b54ce 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -945,9 +945,6 @@ void __init early_reserve_e820_mpc_new(void)
 {
 	if (enable_update_mptable && alloc_mptable) {
 		u64 startt = 0;
-#ifdef CONFIG_X86_TRAMPOLINE
-		startt = TRAMPOLINE_BASE;
-#endif
 		mpc_new_phys = early_reserve_e820(startt, mpc_new_length, 4);
 	}
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 946a311..f7b8b98 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -73,6 +73,7 @@
 
 #include <asm/mtrr.h>
 #include <asm/apic.h>
+#include <asm/trampoline.h>
 #include <asm/e820.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
@@ -875,6 +876,13 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_brk();
 
+	/*
+	 * Find and reserve possible boot-time SMP configuration:
+	 */
+	find_smp_config();
+
+	reserve_trampoline_memory();
+
 #ifdef CONFIG_ACPI_SLEEP
 	/*
 	 * Reserve low memory region for sleep support.
@@ -921,11 +929,6 @@ void __init setup_arch(char **cmdline_p)
 
 	early_acpi_boot_init();
 
-	/*
-	 * Find and reserve possible boot-time SMP configuration:
-	 */
-	find_smp_config();
-
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * Parse SRAT to discover nodes.
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index cd02212..c652ef6 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -12,21 +12,19 @@
 #endif
 
 /* ready for x86_64 and x86 */
-unsigned char *__trampinitdata trampoline_base = __va(TRAMPOLINE_BASE);
+unsigned char *__trampinitdata trampoline_base;
 
 void __init reserve_trampoline_memory(void)
 {
-#ifdef CONFIG_X86_32
-	/*
-	 * But first pinch a few for the stack/trampoline stuff
-	 * FIXME: Don't need the extra page at 4K, but need to fix
-	 * trampoline before removing it. (see the GDT stuff)
-	 */
-	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
-#endif
+	unsigned long mem;
+
 	/* Has to be in very low memory so we can execute real-mode AP code. */
-	reserve_early(TRAMPOLINE_BASE, TRAMPOLINE_BASE + TRAMPOLINE_SIZE,
-			"TRAMPOLINE");
+	mem = find_e820_area(0, 1<<20, TRAMPOLINE_SIZE, PAGE_SIZE);
+	if (mem == -1L)
+		panic("Cannot allocate trampoline\n");
+
+	trampoline_base = __va(mem);
+	reserve_early(mem, mem + TRAMPOLINE_SIZE, "TRAMPOLINE");
 }
 
 /*
