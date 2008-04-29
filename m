Return-Path: <linux-kernel-owner+w=401wt.eu-S1763407AbYD2QAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763407AbYD2QAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYD2QAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:00:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365AbYD2QAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:00:37 -0400
Date: Tue, 29 Apr 2008 18:00:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 updates
Message-ID: <20080429160022.GA7687@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-fixes.git for-linus

Thanks!

	Ingo

------------------>
Alexander van Heukelum (1):
      x86: fix warning in "x86: clean up vSMP detection"

Harvey Harrison (1):
      x86: !x & y typo in mtrr code

Hugh Dickins (1):
      x86: vget_cycles() __always_inline

Ian Campbell (1):
      x86: add more boot protocol documentation

Ingo Molnar (1):
      bootprotocol: cleanup

Jesse Barnes (1):
      x86: fix PCI MSI breaks when booting with nosmp

 Documentation/i386/boot.txt        |   12 ++++++++++--
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 arch/x86/kernel/e820_64.c          |    2 +-
 arch/x86/kernel/smpboot.c          |   10 +++-------
 arch/x86/kernel/vsmp_64.c          |    2 +-
 include/asm-x86/tsc.h              |    2 +-
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/Documentation/i386/boot.txt b/Documentation/i386/boot.txt
index 0fac346..95ad15c 100644
--- a/Documentation/i386/boot.txt
+++ b/Documentation/i386/boot.txt
@@ -40,9 +40,17 @@ Protocol 2.05:	(Kernel 2.6.20) Make protected mode kernel relocatable.
 		Introduce relocatable_kernel and kernel_alignment fields.
 
 Protocol 2.06:	(Kernel 2.6.22) Added a field that contains the size of
-		the boot command line
+		the boot command line.
 
-Protocol 2.09:	(kernel 2.6.26) Added a field of 64-bit physical
+Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised boot protocol.
+		Introduced hardware_subarch and hardware_subarch_data
+		and KEEP_SEGMENTS flag in load_flags.
+
+Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
+		payload. Introduced payload_offset and payload length
+		fields to aid in locating the payload.
+
+Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
 		pointer to single linked list of struct	setup_data.
 
 **** MEMORY LAYOUT
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 353efe4..5d241ce 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -90,7 +90,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 	 * Look of multiple ranges matching this address and pick type
 	 * as per MTRR precedence
 	 */
-	if (!mtrr_state.enabled & 2) {
+	if (!(mtrr_state.enabled & 2)) {
 		return mtrr_state.def_type;
 	}
 
diff --git a/arch/x86/kernel/e820_64.c b/arch/x86/kernel/e820_64.c
index 645ee5e..124480c 100644
--- a/arch/x86/kernel/e820_64.c
+++ b/arch/x86/kernel/e820_64.c
@@ -100,7 +100,7 @@ void __init free_early(unsigned long start, unsigned long end)
 	for (j = i + 1; j < MAX_EARLY_RES && early_res[j].end; j++)
 		;
 
-	memcpy(&early_res[i], &early_res[i + 1],
+	memmove(&early_res[i], &early_res[i + 1],
 	       (j - 1 - i) * sizeof(struct early_res));
 
 	early_res[j - 1].end = 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 04c662b..84241a2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1149,14 +1149,10 @@ static int __init smp_sanity_check(unsigned max_cpus)
 				 "forcing use of dummy APIC emulation.\n");
 		smpboot_clear_io_apic();
 #ifdef CONFIG_X86_32
-		if (nmi_watchdog == NMI_LOCAL_APIC) {
-			printk(KERN_INFO "activating minimal APIC for"
-					 "NMI watchdog use.\n");
-			connect_bsp_APIC();
-			setup_local_APIC();
-			end_local_APIC_setup();
-		}
+		connect_bsp_APIC();
 #endif
+		setup_local_APIC();
+		end_local_APIC_setup();
 		return -1;
 	}
 
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index caf2a26..ba8c0b7 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -133,7 +133,7 @@ int is_vsmp_box(void)
 	}
 }
 #else
-static int __init detect_vsmp_box(void)
+static void __init detect_vsmp_box(void)
 {
 }
 int is_vsmp_box(void)
diff --git a/include/asm-x86/tsc.h b/include/asm-x86/tsc.h
index d2d8eb5..548873a 100644
--- a/include/asm-x86/tsc.h
+++ b/include/asm-x86/tsc.h
@@ -32,7 +32,7 @@ static inline cycles_t get_cycles(void)
 	return ret;
 }
 
-static inline cycles_t vget_cycles(void)
+static __always_inline cycles_t vget_cycles(void)
 {
 	/*
 	 * We only do VDSOs on TSC capable CPUs, so this shouldnt
