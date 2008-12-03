Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYLCVV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYLCVV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYLCVVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:21:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:23952 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYLCVVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:21:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="367758568"
Message-Id: <200812032121.mB3LL13L021817@agluck-lia64.sc.intel.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Richard Henderson <rth@twiddle.net>, Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Date: Wed, 3 Dec 2008 10:37:25 -0800
Subject: RE: [RFC 5/8] param: arch_get_boot_command_line() (take II)
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA35C6C96C3@orsmsx505.amr.corp.intel.com>
References: <200812012326.03151.rusty@rustcorp.com.au>
 <200812031350.46794.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I pulled your git tree.  All my test configs build cleanly
> for ia64 ... but sadly the first kernel I tested (generic_defconfig)
> doesn't boot (no console output at all).
> 
> I'll see if I can figure out what is going on.

Aha.  You are now calling machvec_init_from_cmdline() too early (before
efi_init() and io_port_init()) ... so we croak accessing things
that have not been set up.  Naive fix is to just move them from
setup_arch() to arch_get_boot_command_line().  I can't see how to
handle this more cleanly given that you do the rest of the
command line parsing before calling setup_arch().

With the addition of this patch ia64 bits are

Acked-by: Tony Luck <tony.luck@intel.com>

diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index 12ee0a1..0951971 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -534,6 +534,9 @@ void __init arch_get_boot_command_line(void)
 	strlcpy(boot_command_line, __va(ia64_boot_param->command_line),
 		COMMAND_LINE_SIZE);
 
+	efi_init();
+	io_port_init();
+
 #ifdef CONFIG_IA64_GENERIC
 	/* machvec needs to be parsed from the command line
 	 * before parse_early_param() is called to ensure
@@ -552,9 +555,6 @@ void __init setup_arch(void)
 
 	ia64_patch_vtop((u64) __start___vtop_patchlist, (u64) __end___vtop_patchlist);
 
-	efi_init();
-	io_port_init();
-
 	if (early_console_setup(boot_command_line) == 0)
 		mark_bsp_online();
 
This exacerbates a long standing `problem' that linux_banner
isn't the first thing printed ... with the above patch it
gets moved down even further to the sixth line:

$ dmesg
EFI v1.10 by INTEL: SALsystab=0x7fe0cce0 ACPI=0x7ff0d000 ACPI 2.0=0x7ff0c000 MPS=0x7ff0b000 SMBIOS=0xf0000
booting generic kernel on platform dig
Early serial console at I/O port 0x2f8 (options '115200')
console [uart0] enabled
Initializing cgroup subsys cpuset
Linux version 2.6.28-rc7-generic-smp (aegl@linux-hwb01.sc.intel.com) (gcc version 4.3.1 (GCC) ) #2 SMP Wed Dec 3 11:27:26 PST 2008
 ...

Perhaps we also need to consider this patch to move it back
to a place of prominence?

diff --git a/init/main.c b/init/main.c
index 92ad2fe..38fcd41 100644
--- a/init/main.c
+++ b/init/main.c
@@ -538,6 +538,8 @@ asmlinkage void __init start_kernel(void)
 {
 	char *static_command_line;
 
+	printk(KERN_NOTICE);
+	printk(linux_banner);
 	arch_get_boot_command_line();
 	parse_args("Core params", boot_command_line, __start___core_param,
 		   __stop___core_param - __start___core_param,
@@ -569,8 +571,6 @@ asmlinkage void __init start_kernel(void)
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE);
-	printk(linux_banner);
 	setup_arch();
 	mm_init_owner(&init_mm, &init_task);
 
