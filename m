Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZALS3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZALS3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZALS3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:29:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZALS3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:29:11 -0500
Date: Mon, 12 Jan 2009 19:28:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090112182858.GA11915@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

[ Note that this tree excludes the PAT fixes which have a pending 
  regression reported agains. It's being debugged but no resolution yet -
  the crash looked very weird. ]

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86: avoid theoretical vmalloc fault loop

Ingo Molnar (1):
      Revert "cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write"

Jaswinder Singh Rajput (2):
      x86: fix mpparse.c build error on latest git
      x86: fix apic.c build error on latest git

Kyle McMartin (1):
      x86, mtrr: fix types used in userspace exported header


 arch/x86/include/asm/mach-default/mach_wakecpu.h |    6 +++++
 arch/x86/include/asm/mtrr.h                      |   10 ++++----
 arch/x86/kernel/apic.c                           |    1 +
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   25 ++++++++++-----------
 arch/x86/kernel/mpparse.c                        |    1 +
 arch/x86/mm/fault.c                              |    2 +-
 6 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/mach-default/mach_wakecpu.h b/arch/x86/include/asm/mach-default/mach_wakecpu.h
index ceb0136..89897a6 100644
--- a/arch/x86/include/asm/mach-default/mach_wakecpu.h
+++ b/arch/x86/include/asm/mach-default/mach_wakecpu.h
@@ -24,7 +24,13 @@ static inline void restore_NMI_vector(unsigned short *high, unsigned short *low)
 {
 }
 
+#ifdef CONFIG_SMP
 extern void __inquire_remote_apic(int apicid);
+#else /* CONFIG_SMP */
+static inline void __inquire_remote_apic(int apicid)
+{
+}
+#endif /* CONFIG_SMP */
 
 static inline void inquire_remote_apic(int apicid)
 {
diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index cb988aa..14080d2 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -58,15 +58,15 @@ struct mtrr_gentry {
 #endif /* !__i386__ */
 
 struct mtrr_var_range {
-	u32 base_lo;
-	u32 base_hi;
-	u32 mask_lo;
-	u32 mask_hi;
+	__u32 base_lo;
+	__u32 base_hi;
+	__u32 mask_lo;
+	__u32 mask_hi;
 };
 
 /* In the Intel processor's MTRR interface, the MTRR type is always held in
    an 8 bit field: */
-typedef u8 mtrr_type;
+typedef __u8 mtrr_type;
 
 #define MTRR_NUM_FIXED_RANGES 88
 #define MTRR_MAX_VAR_RANGES 256
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 566a084..0f830e4 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -47,6 +47,7 @@
 #include <asm/proto.h>
 #include <asm/apic.h>
 #include <asm/i8259.h>
+#include <asm/smp.h>
 
 #include <mach_apic.h>
 #include <mach_apicdef.h>
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 06fcd8f..6f11e02 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -150,9 +150,8 @@ struct drv_cmd {
 	u32 val;
 };
 
-static long do_drv_read(void *_cmd)
+static void do_drv_read(struct drv_cmd *cmd)
 {
-	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -167,12 +166,10 @@ static long do_drv_read(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
-static long do_drv_write(void *_cmd)
+static void do_drv_write(struct drv_cmd *cmd)
 {
-	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -189,23 +186,30 @@ static long do_drv_write(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
+	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
+	set_cpus_allowed_ptr(current, cmd->mask);
+	do_drv_read(cmd);
+	set_cpus_allowed_ptr(current, &saved_mask);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
+	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
 	for_each_cpu(i, cmd->mask) {
-		work_on_cpu(i, do_drv_write, cmd);
+		set_cpus_allowed_ptr(current, cpumask_of(i));
+		do_drv_write(cmd);
 	}
+
+	set_cpus_allowed_ptr(current, &saved_mask);
+	return;
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -231,15 +235,10 @@ static u32 get_cur_val(const struct cpumask *mask)
 		return 0;
 	}
 
-	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
-		return 0;
-
 	cpumask_copy(cmd.mask, mask);
 
 	drv_read(&cmd);
 
-	free_cpumask_var(cmd.mask);
-
 	dprintk("get_cur_val = %u\n", cmd.val);
 
 	return cmd.val;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index c0601c2..a649a4c 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -27,6 +27,7 @@
 #include <asm/e820.h>
 #include <asm/trampoline.h>
 #include <asm/setup.h>
+#include <asm/smp.h>
 
 #include <mach_apic.h>
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 9e268b6..90dfae5 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -534,7 +534,7 @@ static int vmalloc_fault(unsigned long address)
 	   happen within a race in page table update. In the later
 	   case just flush. */
 
-	pgd = pgd_offset(current->mm ?: &init_mm, address);
+	pgd = pgd_offset(current->active_mm, address);
 	pgd_ref = pgd_offset_k(address);
 	if (pgd_none(*pgd_ref))
 		return -1;
