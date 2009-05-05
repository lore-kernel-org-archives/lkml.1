Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZEEJ1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZEEJ1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 05:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZEEJ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 05:27:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37327 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208AbZEEJ1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 05:27:09 -0400
Date: Tue, 5 May 2009 11:26:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090505092658.GA32066@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86: show number of core_siblings instead of thread_siblings in /proc/cpuinfo

Joerg Roedel (1):
      amd-iommu: fix iommu flag masks

John Wright (1):
      x86: gettimeofday() vDSO: fix segfault when tv == NULL

Thomas Gleixner (1):
      x86: initialize io_bitmap_base on 32bit


 arch/x86/kernel/amd_iommu_init.c |   16 ++++++++--------
 arch/x86/kernel/cpu/common.c     |    2 ++
 arch/x86/kernel/cpu/proc.c       |    2 +-
 arch/x86/vdso/vclock_gettime.c   |   12 +++++++-----
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 42c33ce..8c0be09 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -49,10 +49,10 @@
 #define IVHD_DEV_EXT_SELECT             0x46
 #define IVHD_DEV_EXT_SELECT_RANGE       0x47
 
-#define IVHD_FLAG_HT_TUN_EN             0x00
-#define IVHD_FLAG_PASSPW_EN             0x01
-#define IVHD_FLAG_RESPASSPW_EN          0x02
-#define IVHD_FLAG_ISOC_EN               0x03
+#define IVHD_FLAG_HT_TUN_EN_MASK        0x01
+#define IVHD_FLAG_PASSPW_EN_MASK        0x02
+#define IVHD_FLAG_RESPASSPW_EN_MASK     0x04
+#define IVHD_FLAG_ISOC_EN_MASK          0x08
 
 #define IVMD_FLAG_EXCL_RANGE            0x08
 #define IVMD_FLAG_UNITY_MAP             0x01
@@ -569,19 +569,19 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	 * First set the recommended feature enable bits from ACPI
 	 * into the IOMMU control registers
 	 */
-	h->flags & IVHD_FLAG_HT_TUN_EN ?
+	h->flags & IVHD_FLAG_HT_TUN_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
 		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
 
-	h->flags & IVHD_FLAG_PASSPW_EN ?
+	h->flags & IVHD_FLAG_PASSPW_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
 		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
 
-	h->flags & IVHD_FLAG_RESPASSPW_EN ?
+	h->flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
 		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
 
-	h->flags & IVHD_FLAG_ISOC_EN ?
+	h->flags & IVHD_FLAG_ISOC_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
 		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c4f6678..c1caefc 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1203,6 +1203,8 @@ void __cpuinit cpu_init(void)
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
+	t->x86_tss.io_bitmap_base = offsetof(struct tss_struct, io_bitmap);
+
 #ifdef CONFIG_DOUBLEFAULT
 	/* Set up doublefault TSS pointer in the GDT */
 	__set_tss_desc(cpu, GDT_ENTRY_DOUBLEFAULT_TSS, &doublefault_tss);
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index f93047f..d5e3039 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -14,7 +14,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 	if (c->x86_max_cores * smp_num_siblings > 1) {
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
-			   cpumask_weight(cpu_sibling_mask(cpu)));
+			   cpumask_weight(cpu_core_mask(cpu)));
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index d9d3582..6a40b78 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -104,11 +104,13 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
-		BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
-			     offsetof(struct timespec, tv_nsec) ||
-			     sizeof(*tv) != sizeof(struct timespec));
-		do_realtime((struct timespec *)tv);
-		tv->tv_usec /= 1000;
+		if (likely(tv != NULL)) {
+			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
+				     offsetof(struct timespec, tv_nsec) ||
+				     sizeof(*tv) != sizeof(struct timespec));
+			do_realtime((struct timespec *)tv);
+			tv->tv_usec /= 1000;
+		}
 		if (unlikely(tz != NULL)) {
 			/* Avoid memcpy. Some old compilers fail to inline it */
 			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
