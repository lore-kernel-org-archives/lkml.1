Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXIJNBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXIJNBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 09:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759312AbXIJNAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 09:00:54 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:43603
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759817AbXIJNAx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 09:00:53 -0400
Message-Id: <46E55C55.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 10 Sep 2007 14:01:41 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: misc. constifications
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miscellaneous x86 stuff that can live in .rodata.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/alternative.c              |   30 +++---
 arch/i386/kernel/smpboot.c                  |    4 
 arch/i386/kernel/trampoline.S               |    4 
 arch/i386/mach-voyager/voyager_smp.c        |    4 
 arch/x86_64/kernel/setup.c                  |    4 
 arch/x86_64/kernel/smpboot.c                |    4 
 arch/x86_64/kernel/trampoline.S             |    7 +
 7 files changed, 31 insertions(+), 26 deletions(-)

--- linux-2.6.23-rc5/arch/i386/kernel/alternative.c	2007-09-07 16:44:44.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/i386/kernel/alternative.c	2007-09-03 10:33:18.000000000 +0200
@@ -62,11 +62,11 @@ __setup("noreplace-paravirt", setup_nore
 /* Use inline assembly to define this because the nops are defined
    as inline assembly strings in the include files and we cannot
    get them easily into strings. */
-asm("\t.data\nintelnops: "
+asm("\t.section .rodata, \"a\"\nintelnops: "
 	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
 	GENERIC_NOP7 GENERIC_NOP8);
-extern unsigned char intelnops[];
-static unsigned char *intel_nops[ASM_NOP_MAX+1] = {
+extern const unsigned char intelnops[];
+static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	intelnops,
 	intelnops + 1,
@@ -80,11 +80,11 @@ static unsigned char *intel_nops[ASM_NOP
 #endif
 
 #ifdef K8_NOP1
-asm("\t.data\nk8nops: "
+asm("\t.section .rodata, \"a\"\nk8nops: "
 	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
 	K8_NOP7 K8_NOP8);
-extern unsigned char k8nops[];
-static unsigned char *k8_nops[ASM_NOP_MAX+1] = {
+extern const unsigned char k8nops[];
+static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k8nops,
 	k8nops + 1,
@@ -98,11 +98,11 @@ static unsigned char *k8_nops[ASM_NOP_MA
 #endif
 
 #ifdef K7_NOP1
-asm("\t.data\nk7nops: "
+asm("\t.section .rodata, \"a\"\nk7nops: "
 	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
 	K7_NOP7 K7_NOP8);
-extern unsigned char k7nops[];
-static unsigned char *k7_nops[ASM_NOP_MAX+1] = {
+extern const unsigned char k7nops[];
+static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k7nops,
 	k7nops + 1,
@@ -118,25 +118,25 @@ static unsigned char *k7_nops[ASM_NOP_MA
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
-static inline unsigned char** find_nop_table(void)
+static inline const unsigned char*const * find_nop_table(void)
 {
 	return k8_nops;
 }
 
 #else /* CONFIG_X86_64 */
 
-static struct nop {
+static const struct nop {
 	int cpuid;
-	unsigned char **noptable;
+	const unsigned char *const *noptable;
 } noptypes[] = {
 	{ X86_FEATURE_K8, k8_nops },
 	{ X86_FEATURE_K7, k7_nops },
 	{ -1, NULL }
 };
 
-static unsigned char** find_nop_table(void)
+static const unsigned char*const * find_nop_table(void)
 {
-	unsigned char **noptable = intel_nops;
+	const unsigned char *const *noptable = intel_nops;
 	int i;
 
 	for (i = 0; noptypes[i].cpuid >= 0; i++) {
@@ -153,7 +153,7 @@ static unsigned char** find_nop_table(vo
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
 static void add_nops(void *insns, unsigned int len)
 {
-	unsigned char **noptable = find_nop_table();
+	const unsigned char *const *noptable = find_nop_table();
 
 	while (len > 0) {
 		unsigned int noplen = len;
--- linux-2.6.23-rc5/arch/i386/kernel/smpboot.c	2007-09-07 16:44:45.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/i386/kernel/smpboot.c	2007-09-03 10:33:18.000000000 +0200
@@ -102,8 +102,8 @@ u8 apicid_2_node[MAX_APICID];
  * Trampoline 80x86 program as an array.
  */
 
-extern unsigned char trampoline_data [];
-extern unsigned char trampoline_end  [];
+extern const unsigned char trampoline_data [];
+extern const unsigned char trampoline_end  [];
 static unsigned char *trampoline_base;
 static int trampoline_exec;
 
--- linux-2.6.23-rc5/arch/i386/kernel/trampoline.S	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/i386/kernel/trampoline.S	2007-09-03 10:33:18.000000000 +0200
@@ -36,11 +36,11 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 
-.data
-
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
 .section ".init.data","aw",@progbits
+#else
+.section .rodata,"a",@progbits
 #endif
 
 .code16
--- linux-2.6.23-rc5/arch/i386/mach-voyager/voyager_smp.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/i386/mach-voyager/voyager_smp.c	2007-09-03 10:33:18.000000000 +0200
@@ -442,8 +442,8 @@ static __u32 __init
 setup_trampoline(void)
 {
 	/* these two are global symbols in trampoline.S */
-	extern __u8 trampoline_end[];
-	extern __u8 trampoline_data[];
+	extern const __u8 trampoline_end[];
+	extern const __u8 trampoline_data[];
 
 	memcpy((__u8 *)trampoline_base, trampoline_data,
 	       trampoline_end - trampoline_data);
--- linux-2.6.23-rc5/arch/x86_64/kernel/setup.c	2007-09-07 16:45:27.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/x86_64/kernel/setup.c	2007-09-03 10:33:18.000000000 +0200
@@ -936,7 +936,7 @@ static int show_cpuinfo(struct seq_file 
 	 * applications want to get the raw CPUID data, they should access
 	 * /dev/cpu/<cpu_nr>/cpuid instead.
 	 */
-	static char *x86_cap_flags[] = {
+	static const char *const x86_cap_flags[] = {
 		/* Intel-defined */
 	        "fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
 	        "cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
@@ -990,7 +990,7 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
-	static char *x86_power_flags[] = { 
+	static const char *const x86_power_flags[] = {
 		"ts",	/* temperature sensor */
 		"fid",  /* frequency id control */
 		"vid",  /* voltage id control */
--- linux-2.6.23-rc5/arch/x86_64/kernel/smpboot.c	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/x86_64/kernel/smpboot.c	2007-09-03 10:33:18.000000000 +0200
@@ -102,8 +102,8 @@ EXPORT_SYMBOL(cpu_core_map);
  * Trampoline 80x86 program as an array.
  */
 
-extern unsigned char trampoline_data[];
-extern unsigned char trampoline_end[];
+extern const unsigned char trampoline_data[];
+extern const unsigned char trampoline_end[];
 
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
--- linux-2.6.23-rc5/arch/x86_64/kernel/trampoline.S	2007-07-09 01:32:17.000000000 +0200
+++ 2.6.23-rc5-x86-const/arch/x86_64/kernel/trampoline.S	2007-09-03 10:33:18.000000000 +0200
@@ -33,7 +33,12 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 
-.data
+/* We can free up trampoline after bootup if cpu hotplug is not supported. */
+#ifndef CONFIG_HOTPLUG_CPU
+.section .init.data, "aw", @progbits
+#else
+.section .rodata, "a", @progbits
+#endif
 
 .code16
 


