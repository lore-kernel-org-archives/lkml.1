Return-Path: <linux-kernel-owner+w=401wt.eu-S1765965AbXLMUHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765965AbXLMUHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 15:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXLMUHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 15:07:08 -0500
Received: from [194.117.236.238] ([194.117.236.238]:58686 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXLMUHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 15:07:06 -0500
Date: Fri, 14 Dec 2007 00:47:10 +0200
From: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071214004710.03f37774@linux360.ro>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some multiprocessor 64-bit AMD systems don't allow the user to disable
the C1E C-state. The kernel detects C1E and marks the LAPIC as
broken, thereby disabling dynticks. This patch adds an option to
disable C1E when detected. It also allows the user to enable this
processor feature even if that means disabling dynticks, which is
useful in case C1E might provide better power savings (e.g.: C-states
beyond C1 don't work). Tested on a Turion X2 TL-56 laptop. Thanks to
Mikhail Kshevetskiy and FreeBSD for pointing out the relevant AMD docs.

Signed-off-by: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 arch/x86/Kconfig                    |   16 ++++++++++++++++
 arch/x86/kernel/setup_64.c          |   27 +++++++++++++++++++++++++--
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 33121d6..0deee7a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -643,6 +643,12 @@ and is between 256 and 4096 characters. It is defined in the file
 	floppy=		[HW]
 			See Documentation/floppy.txt.
 
+	force_amd_c1e	[KNL,SMP,HW,BUGS=X86-64]
+			Don't disable C1E on AMD systems even if this means
+			disabling nohz. This is _not_ automatically implied by
+			any other parameters, such as "nohz=off".
+			Depends on CONFIG_X86_AMD_C1E_WORKAROUND.
+	
 	gamecon.map[2|3]=
 			[HW,JOY] Multisystem joystick and NES/SNES/PSX pad
 			support via parallel port (up to 5 devices per port)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 368864d..8b9bb49 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -198,6 +198,22 @@ config SMP
 
 	  If you don't know what to do here, say N.
 
+config X86_AMD_C1E_WORKAROUND
+	bool "Disable C1E on AMD systems to make dynticks work"
+	default y
+	depends on X86_64 && SMP && NO_HZ
+	---help---
+	  On some systems, the C1E C-state is enabled by default and cannot be
+	  disabled from the CMOS setup. Local APICs don't behave as they should
+	  in this case. If you say Y here, C1E will be disabled to allow
+	  dynamic ticks to work. It's safe to enable this option even if
+	  your system doesn't have an AMD CPU (there are no side-effects if
+	  such a CPU isn't detected).
+
+	  You can pass the "force_amd_c1e" boot parameter to the kernel to
+	  disable this workaround without recompiling.
+	  See Documentation/kernel-parameters.txt for more details.
+
 choice
 	prompt "Subarchitecture Type"
 	default X86_PC
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 30d94d1..15556a0 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -583,6 +583,17 @@ static void __init amd_detect_cmp(struct cpuinfo_x86 *c)
 #endif
 }
 
+#ifdef CONFIG_X86_AMD_C1E_WORKAROUND
+static int __cpuinit disable_amd_c1e = 1;
+
+static int __cpuinit force_amd_c1e(char *str) {
+	disable_amd_c1e = 0;
+	return 1;
+}
+
+__setup("force_amd_c1e", force_amd_c1e);
+#endif /* CONFIG_X86_AMD_C1E_WORKAROUND */
+
 #define ENABLE_C1E_MASK		0x18000000
 #define CPUID_PROCESSOR_SIGNATURE	1
 #define CPUID_XFAM		0x0ff00000
@@ -597,6 +608,7 @@ static __cpuinit int amd_apic_timer_broken(void)
 {
 	u32 lo, hi;
 	u32 eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
+
 	switch (eax & CPUID_XFAM) {
 	case CPUID_XFAM_K8:
 		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
@@ -604,8 +616,19 @@ static __cpuinit int amd_apic_timer_broken(void)
 	case CPUID_XFAM_10H:
 	case CPUID_XFAM_11H:
 		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
-		if (lo & ENABLE_C1E_MASK)
-			return 1;
+#ifdef CONFIG_X86_AMD_C1E_WORKAROUND
+		if ((lo & ENABLE_C1E_MASK) && disable_amd_c1e) {
+			printk(KERN_INFO "Disabling AMD C1E on CPU %d\n",
+			       smp_processor_id());
+			/* 
+			 * See AMD's "BIOS and Kernel Developer's Guide for AMD
+			 * NPT Family 0Fh Processors", publication #32559,
+			 * for details.
+			 */
+			wrmsr(MSR_K8_ENABLE_C1E, lo & ~ENABLE_C1E_MASK, hi); 
+		} else 
+#endif /* CONFIG_X86_AMD_C1E_WORKAROUND */
+		if (lo & ENABLE_C1E_MASK) return 1;
 		break;
 	default:
 		/* err on the side of caution */
