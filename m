Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbYLCDWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbYLCDWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYLCDWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:22:06 -0500
Received: from ozlabs.org ([203.10.76.45]:55516 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYLCDWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:22:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [RFC 7/8] Call early_param earlier (take II)
Date: Wed, 3 Dec 2008 13:51:59 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>
References: <200812012326.50334.rusty@rustcorp.com.au>
In-Reply-To: <200812012326.50334.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031352.00088.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We delete all the arch calls: we call it from start_kernel earlier
now.  We also no longer take a temporary copy, but parse in place.

Note: IA64 has a comment about machvec parsing before general
commandline.  I moved machvec_init_from_cmdline() into
arch_get_boot_command_line(), but that hoists it above various other
init functions in setup_arch().  Please check.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/avr32/kernel/setup.c   |    2 --
 arch/ia64/kernel/setup.c    |    2 --
 arch/m68k/kernel/setup.c    |    2 --
 arch/mips/kernel/setup.c    |    2 --
 arch/powerpc/kernel/prom.c  |    1 -
 arch/s390/kernel/setup.c    |    2 --
 arch/sh/kernel/setup.c      |    2 --
 arch/sparc/kernel/setup.c   |    3 ---
 arch/sparc64/kernel/setup.c |    3 ---
 arch/x86/kernel/setup.c     |    3 ---
 include/linux/init.h        |    2 --
 init/main.c                 |   21 ++++-----------------
 12 files changed, 4 insertions(+), 41 deletions(-)

diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
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
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -533,6 +533,15 @@ void __init arch_get_boot_command_line(v
 {
 	strlcpy(boot_command_line, __va(ia64_boot_param->command_line),
 		COMMAND_LINE_SIZE);
+
+#ifdef CONFIG_IA64_GENERIC
+	/* machvec needs to be parsed from the command line
+	 * before parse_early_param() is called to ensure
+	 * that ia64_mv is initialised before any command line
+	 * settings may cause console setup to occur
+	 */
+	machvec_init_from_cmdline(boot_command_line);
+#endif
 }
 
 void __init setup_arch(void)
@@ -545,17 +554,6 @@ void __init setup_arch(void)
 
 	efi_init();
 	io_port_init();
-
-#ifdef CONFIG_IA64_GENERIC
-	/* machvec needs to be parsed from the command line
-	 * before parse_early_param() is called to ensure
-	 * that ia64_mv is initialised before any command line
-	 * settings may cause console setup to occur
-	 */
-	machvec_init_from_cmdline(boot_command_line);
-#endif
-
-	parse_early_param();
 
 	if (early_console_setup(boot_command_line) == 0)
 		mark_bsp_online();
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
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
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -1188,7 +1188,6 @@ void __init early_init_devtree(void *par
 
 	/* Save command line for /proc/cmdline and then parse parameters */
 	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
-	parse_early_param();
 
 	/* Reserve LMB regions used by kernel, initrd, dt, etc... */
 	lmb_reserve(PHYSICAL_START, __pa(klimit) - PHYSICAL_START);
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
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
--- a/arch/sparc/kernel/setup.c
+++ b/arch/sparc/kernel/setup.c
@@ -214,9 +214,6 @@ void __init setup_arch(void)
 	unsigned long highest_paddr;
 
 	sparc_ttable = (struct tt_entry *) &start;
-
-	/* Initialize PROM console. */
-	parse_early_param();
 
 	/* Set sparc_cpu_model */
 	sparc_cpu_model = sun_unknown;
diff --git a/arch/sparc64/kernel/setup.c b/arch/sparc64/kernel/setup.c
--- a/arch/sparc64/kernel/setup.c
+++ b/arch/sparc64/kernel/setup.c
@@ -283,9 +283,6 @@ void __init arch_get_boot_command_line(v
 
 void __init setup_arch(void)
 {
-	/* Initialize PROM console. */
-	parse_early_param();
-
 	boot_flags_init(boot_command_line);
 	register_console(&prom_early_console);
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
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
--- a/init/main.c
+++ b/init/main.c
@@ -206,7 +206,7 @@ static int __init obsolete_checksetup(ch
 		int n = strlen(p->str);
 		if (!strncmp(line, p->str, n)) {
 			if (p->early) {
-				/* Already done in parse_early_param?
+				/* Already done in do_early_param?
 				 * (Needs exact match on param part).
 				 * Keep iterating, as we can have early
 				 * params and __setups of same names 8( */
@@ -523,21 +523,6 @@ static int __init do_early_param(char *p
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
@@ -571,6 +556,9 @@ asmlinkage void __init start_kernel(void
 	parse_args("Core params", boot_command_line, __start___core_param,
 		   __stop___core_param - __start___core_param,
 		   unknown_core_ok, true);
+	/* All fall through to do_early_param. */
+	parse_args("early options", boot_command_line, NULL, 0, do_early_param,
+		   true);
 
 	smp_setup_processor_id();
 
@@ -620,7 +608,6 @@ asmlinkage void __init start_kernel(void
 	build_all_zonelists();
 	page_alloc_init();
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
-	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
 		   &unknown_bootoption, false);

