Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbZLJVI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbZLJVI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:08:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759392AbZLJVI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:08:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:40933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758856AbZLJVIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:08:25 -0500
Message-ID: <4B21630A.6000308@kernel.org>
Date: Thu, 10 Dec 2009 13:07:22 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Bisected regression (Was Re: current -git fails to boot on	nehalem-ex)
References: <20091210091040.GG8742@kernel.dk> <20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu> <67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org> <20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org> <4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk> <20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org> <20091210192659.GV8742@kernel.dk>
In-Reply-To: <20091210192659.GV8742@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
 
> I can test other patches if you have good ideas, otherwise I suggest we
> revert the commit.

we should go further.

please check, esp should fix that  from kernel acpi=off to kexec second kernel with  acpi=off for your system.

[PATCH] x86: use find_e820 instead of hard code trampoline addr

Jens found

after
|commit b24c2a925a9837cccf54d50aeac22ba0cbc15455
| Author: Yinghai Lu <yinghai@kernel.org>
| Date:   Tue Nov 24 02:48:18 2009 -0800
|
|   x86: Move find_smp_config() earlier and avoid bootmem usage

[    0.000000] found SMP MP-table at [ffff8800000fdd80] fdd80
[    0.000000] Kernel panic - not syncing: Overlapping early reservations 12-f011 MP-table mpc to 0-fff BIOS data page
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32 #35
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff813c9eeb>] panic+0xa0/0x16a
[    0.000000]  [<ffffffff8167d280>] ? reserve_early_overlap_ok+0x2e/0x39
[    0.000000]  [<ffffffff8167d234>] ? drop_overlaps_that_are_ok+0x101/0x11f
[    0.000000]  [<ffffffff8167d133>] drop_overlaps_that_are_ok+0x0/0x11f
[    0.000000]  [<ffffffff8167d2c6>] reserve_early+0x3b/0x3d
[    0.000000]  [<ffffffff81683248>] smp_scan_config+0xe7/0x10e
[    0.000000]  [<ffffffff816832a9>] default_find_smp_config+0x3a/0x60
[    0.000000]  [<ffffffff8167b0be>] setup_arch+0x6ae/0xa88
[    0.000000]  [<ffffffff816789ff>] start_kernel+0x82/0x412
[    0.000000]  [<ffffffff81678289>] x86_64_start_reservations+0x99/0xb9
[    0.000000]  [<ffffffff81678389>] x86_64_start_kernel+0xe0/0xf2

and

[    0.000000] Kernel panic - not syncing: Overlapping early reservations 12-f011 MP-table mpc to 6000-7fff TRAMPOLINE
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32 #51
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff813c709b>] panic+0xa0/0x16a
[    0.000000]  [<ffffffff8167d280>] ?  reserve_early_overlap_ok+0x2e/0x39
[    0.000000]  [<ffffffff8167d24a>] ?  drop_overlaps_that_are_ok+0x117/0x11f
[    0.000000]  [<ffffffff8167d133>] drop_overlaps_that_are_ok+0x0/0x11f
[    0.000000]  [<ffffffff8167d2c6>] reserve_early+0x3b/0x3d
[    0.000000]  [<ffffffff81683248>] smp_scan_config+0xe7/0x10e
[    0.000000]  [<ffffffff816832a9>] default_find_smp_config+0x3a/0x60
[    0.000000]  [<ffffffff8167b0be>] setup_arch+0x6ae/0xa88
[    0.000000]  [<ffffffff816789ff>] start_kernel+0x82/0x412
[    0.000000]  [<ffffffff81678289>] x86_64_start_reservations+0x99/0xb9
[    0.000000]  [<ffffffff81678389>] x86_64_start_kernel+0xe0/0xf2

it turns out BIOS is using first 64k for mptable without reserve it.

so try to find good range for it instead of hard code it.
in case some bios try to use that range for sth.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/trampoline.h |    1 -
 arch/x86/kernel/e820.c            |   11 ++++++++++-
 arch/x86/kernel/head32.c          |    2 --
 arch/x86/kernel/head64.c          |    2 --
 arch/x86/kernel/mpparse.c         |    3 ---
 arch/x86/kernel/setup.c           |   13 ++++++++-----
 arch/x86/kernel/trampoline.c      |   20 +++++++++-----------
 7 files changed, 27 insertions(+), 25 deletions(-)

Index: linux-2.6/arch/x86/include/asm/trampoline.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/trampoline.h
+++ linux-2.6/arch/x86/include/asm/trampoline.h
@@ -16,7 +16,6 @@ extern unsigned long initial_code;
 extern unsigned long initial_gs;
 
 #define TRAMPOLINE_SIZE roundup(trampoline_end - trampoline_data, PAGE_SIZE)
-#define TRAMPOLINE_BASE 0x6000
 
 extern unsigned long setup_trampoline(void);
 extern void __init reserve_trampoline_memory(void);
Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
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
 
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -29,8 +29,6 @@ static void __init i386_default_early_se
 
 void __init i386_start_kernel(void)
 {
-	reserve_trampoline_memory();
-
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -98,8 +98,6 @@ void __init x86_64_start_reservations(ch
 {
 	copy_bootdata(__va(real_mode_data));
 
-	reserve_trampoline_memory();
-
 	reserve_early(__pa_symbol(&_text), __pa_symbol(&__bss_stop), "TEXT DATA BSS");
 
 #ifdef CONFIG_BLK_DEV_INITRD
Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -945,9 +945,6 @@ void __init early_reserve_e820_mpc_new(v
 {
 	if (enable_update_mptable && alloc_mptable) {
 		u64 startt = 0;
-#ifdef CONFIG_X86_TRAMPOLINE
-		startt = TRAMPOLINE_BASE;
-#endif
 		mpc_new_phys = early_reserve_e820(startt, mpc_new_length, 4);
 	}
 }
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
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
Index: linux-2.6/arch/x86/kernel/trampoline.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/trampoline.c
+++ linux-2.6/arch/x86/kernel/trampoline.c
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
