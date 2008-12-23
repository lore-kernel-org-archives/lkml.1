Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYLWDFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYLWDFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 22:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752310AbYLWDFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 22:05:24 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:33187 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbYLWDFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 22:05:22 -0500
Date: Tue, 23 Dec 2008 03:06:09 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: linux-next: parsing mem=700M broken
Message-ID: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I find that bootparam "mem=700M" isn't working in linux-next or mmotm,
and have bisected it down to your patch below; but now I'm off to bed
without working out just what goes wrong (I'll bet it's the "=").

Hugh

commit 5c886584a758edba7e25ad9df974cf15a4a1f59d
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Wed Dec 3 13:34:34 2008 +1030

    Call early_param earlier.
    
    We delete all the arch calls: we call it from start_kernel earlier
    now.  We also no longer take a temporary copy, but parse in place.
    
    Note: IA64 needs to parse "machvec=" before other commandline options
    but machvec_init_from_cmdline() needs efi_init() and io_port_init(),
    so they are all moved into arch_get_boot_command_line().
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Acked-by: Tony Luck <tony.luck@intel.com>

diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index fd27063..7b4c0eb 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -580,8 +580,6 @@ void __init setup_arch(void)
 		       ((cpu_hz + 500) / 1000) % 1000);
 	}
 
-	parse_early_param();
-
 	setup_bootmem();
 
 #ifdef CONFIG_VT
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 74868fa..0951971 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -533,15 +533,6 @@ void __init arch_get_boot_command_line(void)
 {
 	strlcpy(boot_command_line, __va(ia64_boot_param->command_line),
 		COMMAND_LINE_SIZE);
-}
-
-void __init setup_arch(void)
-{
-	unw_init();
-
-	paravirt_arch_setup_early();
-
-	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
 
 	efi_init();
 	io_port_init();
@@ -554,8 +545,15 @@ void __init setup_arch(void)
 	 */
 	machvec_init_from_cmdline(boot_command_line);
 #endif
+}
+
+void __init setup_arch(void)
+{
+	unw_init();
+
+	paravirt_arch_setup_early();
 
-	parse_early_param();
+	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
 
 	if (early_console_setup(boot_command_line) == 0)
 		mark_bsp_online();
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index ebb870b..d78e3c9 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -268,8 +268,6 @@ void __init setup_arch(void)
 	init_mm.end_data = (unsigned long) &_edata;
 	init_mm.brk = (unsigned long) &_end;
 
-	parse_early_param();
-
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
 #endif
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 2d9d479..7c02f39 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -482,8 +482,6 @@ static void __init arch_mem_init(void)
 	pr_info("Determined physical RAM map:\n");
 	print_memory_map();
 
-	parse_early_param();
-
 	if (usermem) {
 		pr_info("User-defined physical RAM map:\n");
 		print_memory_map();
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 3a2dc7e..d36cbd0 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -1188,7 +1188,6 @@ void __init early_init_devtree(void *params)
 
 	/* Save command line for /proc/cmdline and then parse parameters */
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
-	parse_early_param();
 
 	/* Reserve LMB regions used by kernel, initrd, dt, etc... */
 	lmb_reserve(PHYSICAL_START, __pa(klimit) - PHYSICAL_START);
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f736c68..7cb2868 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -785,8 +785,6 @@ setup_arch(void)
 	else
 		memcpy(&uaccess, &uaccess_std, sizeof(uaccess));
 
-	parse_early_param();
-
 	setup_ipl();
 	setup_memory_end();
 	setup_addressing_mode();
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index 58089b3..2fe5992 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -382,8 +382,6 @@ void __init setup_arch(void)
 	if (!memory_end)
 		memory_end = memory_start + __MEMORY_SIZE;
 
-	parse_early_param();
-
 	sh_mv_setup();
 
 	/*
diff --git a/arch/sparc/kernel/setup.c b/arch/sparc/kernel/setup.c
index 883bade..dac4a9e 100644
--- a/arch/sparc/kernel/setup.c
+++ b/arch/sparc/kernel/setup.c
@@ -215,9 +215,6 @@ void __init setup_arch(void)
 
 	sparc_ttable = (struct tt_entry *) &start;
 
-	/* Initialize PROM console. */
-	parse_early_param();
-
 	/* Set sparc_cpu_model */
 	sparc_cpu_model = sun_unknown;
 	if (!strcmp(&cputypval,"sun4 "))
diff --git a/arch/sparc64/kernel/setup.c b/arch/sparc64/kernel/setup.c
index 8827c2a..431cb97 100644
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -283,9 +283,6 @@ void __init arch_get_boot_command_line(void)
 
 void __init setup_arch(void)
 {
-	/* Initialize PROM console. */
-	parse_early_param();
-
 	boot_flags_init(boot_command_line);
 	register_console(&prom_early_console);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1669ce2..13fec0e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -876,8 +876,6 @@ void __init setup_arch(void)
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
-	parse_early_param();
-
 #ifdef CONFIG_X86_64
 	check_efer();
 #endif
@@ -915,7 +913,6 @@ void __init setup_arch(void)
 	probe_roms();
 #endif
 
-	/* after parse_early_param, so could debug it */
 	insert_resource(&iomem_resource, &code_resource);
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
diff --git a/include/linux/init.h b/include/linux/init.h
index 9b57a61..8cd1a93 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -246,8 +246,6 @@ struct obs_kernel_param {
 #define early_param(str, fn)					\
 	__setup_param(str, fn, fn, 1)
 
-/* Relies on boot_command_line being set */
-void __init parse_early_param(void);
 #endif /* __ASSEMBLY__ */
 
 /**
diff --git a/init/main.c b/init/main.c
index 718027b..145579d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -206,7 +206,7 @@ static int __init obsolete_checksetup(char *line)
 		int n = strlen(p->str);
 		if (!strncmp(line, p->str, n)) {
 			if (p->early) {
-				/* Already done in parse_early_param?
+				/* Already done in do_early_param?
 				 * (Needs exact match on param part).
 				 * Keep iterating, as we can have early
 				 * params and __setups of same names 8( */
@@ -523,21 +523,6 @@ static int __init do_early_param(char *param, char *val)
 	return 0;
 }
 
-/* Arch code calls this early on, or if not, just before other parsing. */
-void __init parse_early_param(void)
-{
-	static __initdata int done = 0;
-	static __initdata char tmp_cmdline[COMMAND_LINE_SIZE];
-
-	if (done)
-		return;
-
-	/* All fall through to do_early_param. */
-	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-	parse_args("early options", tmp_cmdline, NULL, 0, do_early_param, true);
-	done = 1;
-}
-
 /*
  *	Activate the first processor.
  */
@@ -566,6 +551,9 @@ asmlinkage void __init start_kernel(void)
 	parse_args("Core params", boot_command_line, __start___core_param,
 		   __stop___core_param - __start___core_param,
 		   unknown_core_ok, true);
+	/* All fall through to do_early_param. */
+	parse_args("early options", boot_command_line, NULL, 0, do_early_param,
+		   true);
 
 	smp_setup_processor_id();
 
@@ -615,7 +603,6 @@ asmlinkage void __init start_kernel(void)
 	build_all_zonelists();
 	page_alloc_init();
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
-	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption, false);
