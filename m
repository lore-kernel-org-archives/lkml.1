Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbYFSPOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbYFSPOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYFSPOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:14:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54522 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbYFSPOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:14:04 -0400
Date: Thu, 19 Jun 2008 17:13:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: [git pull] x86 fixes
Message-ID: <20080619151333.GA8952@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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


Linus,

please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Bernhard Walle (1):
      x86: use BOOTMEM_EXCLUSIVE on 32-bit

Jeremy Fitzhardinge (1):
      x86: set PAE PHYSICAL_MASK_SHIFT to 44 bits.

Jordan Crouse (1):
      x86, geode: add a VSA2 ID for General Software

Mikael Pettersson (1):
      x86, 32-bit: fix boot failure on TSC-less processors

Suresh Siddha (1):
      x86: fix NULL pointer deref in __switch_to

 arch/x86/kernel/geode_32.c   |    5 ++++-
 arch/x86/kernel/process_32.c |    1 +
 arch/x86/kernel/process_64.c |    1 +
 arch/x86/kernel/setup_32.c   |   10 ++++++++--
 arch/x86/kernel/tsc_32.c     |   18 ++++++++----------
 include/asm-x86/geode.h      |    4 ++--
 include/asm-x86/page_32.h    |    3 ++-
 7 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/geode_32.c b/arch/x86/kernel/geode_32.c
index e8edd63..9b08e85 100644
--- a/arch/x86/kernel/geode_32.c
+++ b/arch/x86/kernel/geode_32.c
@@ -166,6 +166,8 @@ int geode_has_vsa2(void)
 	static int has_vsa2 = -1;
 
 	if (has_vsa2 == -1) {
+		u16 val;
+
 		/*
 		 * The VSA has virtual registers that we can query for a
 		 * signature.
@@ -173,7 +175,8 @@ int geode_has_vsa2(void)
 		outw(VSA_VR_UNLOCK, VSA_VRC_INDEX);
 		outw(VSA_VR_SIGNATURE, VSA_VRC_INDEX);
 
-		has_vsa2 = (inw(VSA_VRC_DATA) == VSA_SIG);
+		val = inw(VSA_VRC_DATA);
+		has_vsa2 = (val == AMD_VSA_SIG || val == GSW_VSA_SIG);
 	}
 
 	return has_vsa2;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 6d54833..e2db9ac 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -333,6 +333,7 @@ void flush_thread(void)
 	/*
 	 * Forget coprocessor state..
 	 */
+	tsk->fpu_counter = 0;
 	clear_fpu(tsk);
 	clear_used_math();
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ac54ff5..c6eb5c9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -294,6 +294,7 @@ void flush_thread(void)
 	/*
 	 * Forget coprocessor state..
 	 */
+	tsk->fpu_counter = 0;
 	clear_fpu(tsk);
 	clear_used_math();
 }
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 2c5f8b2..5a2f8e0 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -532,10 +532,16 @@ static void __init reserve_crashkernel(void)
 					(unsigned long)(crash_size >> 20),
 					(unsigned long)(crash_base >> 20),
 					(unsigned long)(total_mem >> 20));
+
+			if (reserve_bootmem(crash_base, crash_size,
+					BOOTMEM_EXCLUSIVE) < 0) {
+				printk(KERN_INFO "crashkernel reservation "
+					"failed - memory is in use\n");
+				return;
+			}
+
 			crashk_res.start = crash_base;
 			crashk_res.end   = crash_base + crash_size - 1;
-			reserve_bootmem(crash_base, crash_size,
-					BOOTMEM_DEFAULT);
 		} else
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"you have to specify a base address\n");
diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index 068759d..65b7063 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -14,7 +14,10 @@
 
 #include "mach_timer.h"
 
-static int tsc_disabled;
+/* native_sched_clock() is called before tsc_init(), so
+   we must start with the TSC soft disabled to prevent
+   erroneous rdtsc usage on !cpu_has_tsc processors */
+static int tsc_disabled = -1;
 
 /*
  * On some systems the TSC frequency does not
@@ -402,25 +405,20 @@ void __init tsc_init(void)
 {
 	int cpu;
 
-	if (!cpu_has_tsc || tsc_disabled) {
-		/* Disable the TSC in case of !cpu_has_tsc */
-		tsc_disabled = 1;
+	if (!cpu_has_tsc || tsc_disabled > 0)
 		return;
-	}
 
 	cpu_khz = calculate_cpu_khz();
 	tsc_khz = cpu_khz;
 
 	if (!cpu_khz) {
 		mark_tsc_unstable("could not calculate TSC khz");
-		/*
-		 * We need to disable the TSC completely in this case
-		 * to prevent sched_clock() from using it.
-		 */
-		tsc_disabled = 1;
 		return;
 	}
 
+	/* now allow native_sched_clock() to use rdtsc */
+	tsc_disabled = 0;
+
 	printk("Detected %lu.%03lu MHz processor.\n",
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
diff --git a/include/asm-x86/geode.h b/include/asm-x86/geode.h
index 6e64588..bb06027 100644
--- a/include/asm-x86/geode.h
+++ b/include/asm-x86/geode.h
@@ -112,8 +112,8 @@ extern int geode_get_dev_base(unsigned int dev);
 #define VSA_VR_UNLOCK		0xFC53	/* unlock virtual register */
 #define VSA_VR_SIGNATURE	0x0003
 #define VSA_VR_MEM_SIZE		0x0200
-#define VSA_SIG			0x4132	/* signature is ascii 'VSA2' */
-
+#define AMD_VSA_SIG		0x4132	/* signature is ascii 'VSA2' */
+#define GSW_VSA_SIG		0x534d  /* General Software signature */
 /* GPIO */
 
 #define GPIO_OUTPUT_VAL		0x00
diff --git a/include/asm-x86/page_32.h b/include/asm-x86/page_32.h
index 424e82f..ccf0ba3 100644
--- a/include/asm-x86/page_32.h
+++ b/include/asm-x86/page_32.h
@@ -14,7 +14,8 @@
 #define __PAGE_OFFSET		_AC(CONFIG_PAGE_OFFSET, UL)
 
 #ifdef CONFIG_X86_PAE
-#define __PHYSICAL_MASK_SHIFT	36
+/* 44=32+12, the limit we can fit into an unsigned long pfn */
+#define __PHYSICAL_MASK_SHIFT	44
 #define __VIRTUAL_MASK_SHIFT	32
 #define PAGETABLE_LEVELS	3
 
