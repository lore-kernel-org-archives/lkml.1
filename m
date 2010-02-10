Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab0BJSJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:09:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55811 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295Ab0BJSJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:09:06 -0500
Date: Wed, 10 Feb 2010 10:06:56 -0800
Message-Id: <201002101806.o1AI6u1g016934@voreg.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for 2.6.33-rc8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Shaohui Zheng <shaohui.zheng@intel.com>,
       Yinghai Lu <yinghai@kernel.org>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Marin Mitov <mitov@issp.bas.bg>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
       Andrew Morton <akpm@linux-foundation.org>, stable@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Four patches for mainline.  Two are trivial, one is straightforward;
the fourth one (Suresh' apic patch) is a bit larger than we would
like, although most of the patch is code movement.  This patch
addresses a regression for systems which start out with <= 8 CPUs and
then hotadd above the 8-CPU mark... those systems need to be in
physflat APIC mode in order to handle the larger configuration.
Unfortunately, for that information to be available the sequencing had
to be changed on 32 bits, since it was gratuitously different in the
32- and 64-bit cases.

The patch has survived Ingo's collection of eclectic systems,
including some with known APIC weirdness, so we have reasonably high
confidence it it, but it is definitely more complex than we'd like.

That is the last patch in the pull, so if you think it is too risky
you can pull the rest without that one, and then we'll take it for
.34.

	-hpa


The following changes since commit 1a45dcfe2525e9432cb4aba461d4994fc2befe42:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Andy Shevchenko (1):
      x86, doc: Fix minor spelling error in arch/x86/mm/gup.c

FUJITA Tomonori (1):
      x86/agp: Fix amd64-agp module initialization regression

Serge E. Hallyn (1):
      x86-32: Make AT_VECTOR_SIZE_ARCH=2

Suresh Siddha (1):
      x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs

 arch/x86/include/asm/system.h   |    4 ++--
 arch/x86/kernel/acpi/boot.c     |    5 -----
 arch/x86/kernel/apic/apic.c     |   17 -----------------
 arch/x86/kernel/apic/probe_32.c |   29 +++++++++++++++++++++++++++--
 arch/x86/kernel/apic/probe_64.c |    2 +-
 arch/x86/kernel/mpparse.c       |    7 -------
 arch/x86/kernel/smpboot.c       |    2 --
 arch/x86/mm/gup.c               |    2 +-
 drivers/char/agp/amd64-agp.c    |    5 ++++-
 9 files changed, 35 insertions(+), 38 deletions(-)

commit 681ee44d40d7c93b42118320e4620d07d8704fd6
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Tue Feb 9 18:01:44 2010 -0800

    x86, apic: Don't use logical-flat mode when CPU hotplug may exceed 8 CPUs
    
    We need to fall back from logical-flat APIC mode to physical-flat mode
    when we have more than 8 CPUs.  However, in the presence of CPU
    hotplug(with bios listing not enabled but possible cpus as disabled cpus in
    MADT), we have to consider the number of possible CPUs rather than
    the number of current CPUs; otherwise we may cross the 8-CPU boundary
    when CPUs are added later.
    
    32bit apic code can use more cleanups (like the removal of vendor checks in
    32bit default_setup_apic_routing()) and more unifications with 64bit code.
    Yinghai has some patches in works already. This patch addresses the boot issue
    that is reported in the virtualization guest context.
    
    [ hpa: incorporated function annotation feedback from Yinghai Lu ]
    
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    LKML-Reference: <1265767304.2833.19.camel@sbs-t61.sc.intel.com>
    Acked-by: Shaohui Zheng <shaohui.zheng@intel.com>
    Reviewed-by: Yinghai Lu <yinghai@kernel.org>
    Cc: <stable@kernel.org>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 036d28a..0acbcdf 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1185,9 +1185,6 @@ static void __init acpi_process_madt(void)
 		if (!error) {
 			acpi_lapic = 1;
 
-#ifdef CONFIG_X86_BIGSMP
-			generic_bigsmp_probe();
-#endif
 			/*
 			 * Parse MADT IO-APIC entries
 			 */
@@ -1197,8 +1194,6 @@ static void __init acpi_process_madt(void)
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
-				if (apic->setup_apic_routing)
-					apic->setup_apic_routing();
 			}
 		}
 		if (error == -EINVAL) {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 3987e44..dfca210 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1641,9 +1641,7 @@ int __init APIC_init_uniprocessor(void)
 #endif
 
 	enable_IR_x2apic();
-#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
-#endif
 
 	verify_local_APIC();
 	connect_bsp_APIC();
@@ -1891,21 +1889,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	if (apicid > max_physical_apicid)
 		max_physical_apicid = apicid;
 
-#ifdef CONFIG_X86_32
-	if (num_processors > 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-#endif
-
 #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
 	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
 	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 1a6559f..99d2fe0 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -52,7 +52,32 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-void default_setup_apic_routing(void)
+void __init default_setup_apic_routing(void)
+{
+	int version = apic_version[boot_cpu_physical_apicid];
+
+	if (num_possible_cpus() > 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+
+#ifdef CONFIG_X86_BIGSMP
+	generic_bigsmp_probe();
+#endif
+
+	if (apic->setup_apic_routing)
+		apic->setup_apic_routing();
+}
+
+static void setup_apic_flat_routing(void)
 {
 #ifdef CONFIG_X86_IO_APIC
 	printk(KERN_INFO
@@ -103,7 +128,7 @@ struct apic apic_default = {
 	.init_apic_ldr			= default_init_apic_ldr,
 
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
-	.setup_apic_routing		= default_setup_apic_routing,
+	.setup_apic_routing		= setup_apic_flat_routing,
 	.multi_timer_check		= NULL,
 	.apicid_to_node			= default_apicid_to_node,
 	.cpu_to_logical_apicid		= default_cpu_to_logical_apicid,
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index 450fe20..83e9be4 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -67,7 +67,7 @@ void __init default_setup_apic_routing(void)
 	}
 #endif
 
-	if (apic == &apic_flat && num_processors > 8)
+	if (apic == &apic_flat && num_possible_cpus() > 8)
 			apic = &apic_physflat;
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 40b54ce..a2c1edd 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -359,13 +359,6 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		x86_init.mpparse.mpc_record(1);
 	}
 
-#ifdef CONFIG_X86_BIGSMP
-	generic_bigsmp_probe();
-#endif
-
-	if (apic->setup_apic_routing)
-		apic->setup_apic_routing();
-
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..b4e870c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1083,9 +1083,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	set_cpu_sibling_map(0);
 
 	enable_IR_x2apic();
-#ifdef CONFIG_X86_64
 	default_setup_apic_routing();
-#endif
 
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");

commit cf9db6c41f739a294286847aab1e85f39aef1781
Author: Serge E. Hallyn <serue@us.ibm.com>
Date:   Mon Feb 8 20:35:02 2010 -0600

    x86-32: Make AT_VECTOR_SIZE_ARCH=2
    
    Both x86-32 and x86-64 with 32-bit compat use ARCH_DLINFO_IA32,
    which defines two saved_auxv entries.  But system.h only defines
    AT_VECTOR_SIZE_ARCH as 2 for CONFIG_IA32_EMULATION, not for
    CONFIG_X86_32.  Fix that.
    
    Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
    LKML-Reference: <20100209023502.GA15408@us.ibm.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index ecb544e..e04740f 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -11,9 +11,9 @@
 #include <linux/irqflags.h>
 
 /* entries in ARCH_DLINFO: */
-#ifdef CONFIG_IA32_EMULATION
+#if defined(CONFIG_IA32_EMULATION) || !defined(CONFIG_X86_64)
 # define AT_VECTOR_SIZE_ARCH 2
-#else
+#else /* else it's non-compat x86-64 */
 # define AT_VECTOR_SIZE_ARCH 1
 #endif
 

commit 06df6dafb5d9e3cfa3588c6ce79328b91582b6af
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Thu Feb 4 14:43:38 2010 +0900

    x86/agp: Fix amd64-agp module initialization regression
    
    This fixes the regression introduced by commit
    42590a75019a50012f25a962246498dead428433 ("x86/agp: Fix
    agp_amd64_init and agp_amd64_cleanup").
    
    The commit 61684ceaad4f65d1a9832c722f7bd5e7fc714de9 fixed the
    above regression but it's not enough. When amd64-agp is built as
    a module, AGP isn't initialized, iommu is initialized, all the
    aperture is owned by the iommu.
    
    Reported-by: Marin Mitov <mitov@issp.bas.bg>
    Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
    Tested-by: Marin Mitov <mitov@issp.bas.bg>
    LKML-Reference: <20100204090802S.fujita.tomonori@lab.ntt.co.jp>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 34cf04e..fd50ead 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -767,16 +767,19 @@ int __init agp_amd64_init(void)
 
 static int __init agp_amd64_mod_init(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return agp_bridges_found ? 0 : -ENODEV;
-
+#endif
 	return agp_amd64_init();
 }
 
 static void __exit agp_amd64_cleanup(void)
 {
+#ifndef MODULE
 	if (gart_iommu_aperture)
 		return;
+#endif
 	if (aperture_resource)
 		release_resource(aperture_resource);
 	pci_unregister_driver(&agp_amd64_pci_driver);

commit ab09809f2eee1dc2d8f8bea636e77d176ba6c648
Author: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Date:   Tue Feb 2 14:38:12 2010 -0800

    x86, doc: Fix minor spelling error in arch/x86/mm/gup.c
    
    Fix minor spelling error in comment.  No code change.
    
    Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
    LKML-Reference: <201002022238.o12McDiF018720@imap1.linux-foundation.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 71da1bc..738e659 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -18,7 +18,7 @@ static inline pte_t gup_get_pte(pte_t *ptep)
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
-	 * any locks.  For this we would like to load the pointers atoimcally,
+	 * any locks.  For this we would like to load the pointers atomically,
 	 * but that is not possible (without expensive cmpxchg8b) on PAE.  What
 	 * we do have is the guarantee that a pte will only either go from not
 	 * present to present, or present to not present or both -- it will not
