Return-Path: <linux-kernel-owner+w=401wt.eu-S1753786AbYKRUg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786AbYKRUg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYKRUgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:36:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbYKRUgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:36:19 -0500
Date: Tue, 18 Nov 2008 21:35:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081118203559.GA4561@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: move iomap.h to the new include location

Ingo Molnar (1):
      x86, PEBS/DS: fix code flow in ds_request()

James Bottomley (1):
      x86, voyager: fix smp generic helper voyager breakage

Jeremy Fitzhardinge (1):
      xen: fix scrub_page()

Joerg Roedel (4):
      AMD IOMMU: add parameter to disable device isolation
      AMD IOMMU: enable device isolation per default
      AMD IOMMU: fix fullflush comparison length
      AMD IOMMU: check for next_bit also in unmapped area

Markus Metzger (1):
      x86, bts: fix unlock problem in ds.c

Philipp Kohlbecher (1):
      x86: more general identifier for Phoenix BIOS

Venki Pallipadi (1):
      x86: add rdtsc barrier to TSC sync check

Yinghai Lu (1):
      x86: fix es7000 compiling


 Documentation/kernel-parameters.txt               |    4 ++-
 arch/x86/Kconfig                                  |    5 +++-
 {include/asm-x86 => arch/x86/include/asm}/iomap.h |    0
 arch/x86/kernel/amd_iommu.c                       |    2 +-
 arch/x86/kernel/amd_iommu_init.c                  |    6 +++-
 arch/x86/kernel/ds.c                              |   25 +++++++++++++++++---
 arch/x86/kernel/es7000_32.c                       |    9 +------
 arch/x86/kernel/setup.c                           |    2 +-
 arch/x86/kernel/tsc_sync.c                        |    4 +++
 arch/x86/mach-voyager/voyager_smp.c               |   16 +++++++++++-
 drivers/xen/balloon.c                             |    9 +------
 11 files changed, 54 insertions(+), 28 deletions(-)
 rename {include/asm-x86 => arch/x86/include/asm}/iomap.h (100%)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9fa6508..f2e1e7f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -294,7 +294,9 @@ and is between 256 and 4096 characters. It is defined in the file
 			Possible values are:
 			isolate - enable device isolation (each device, as far
 			          as possible, will get its own protection
-			          domain)
+			          domain) [default]
+			share - put every device behind one IOMMU into the
+				same protection domain
 			fullflush - enable flushing of IO/TLB entries when
 				    they are unmapped. Otherwise they are
 				    flushed before they will be reused, which
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 93224b5..fd2de70 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -167,9 +167,12 @@ config GENERIC_PENDING_IRQ
 config X86_SMP
 	bool
 	depends on SMP && ((X86_32 && !X86_VOYAGER) || X86_64)
-	select USE_GENERIC_SMP_HELPERS
 	default y
 
+config USE_GENERIC_SMP_HELPERS
+	def_bool y
+	depends on SMP
+
 config X86_32_SMP
 	def_bool y
 	depends on X86_32 && SMP
diff --git a/include/asm-x86/iomap.h b/arch/x86/include/asm/iomap.h
similarity index 100%
rename from include/asm-x86/iomap.h
rename to arch/x86/include/asm/iomap.h
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 331b318..e4899e0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -537,7 +537,7 @@ static void dma_ops_free_addresses(struct dma_ops_domain *dom,
 	address >>= PAGE_SHIFT;
 	iommu_area_free(dom->bitmap, address, pages);
 
-	if (address + pages >= dom->next_bit)
+	if (address >= dom->next_bit)
 		dom->need_flush = true;
 }
 
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 0cdcda3..30ae270 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -121,7 +121,7 @@ u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 LIST_HEAD(amd_iommu_unity_map);		/* a list of required unity mappings
 					   we find in ACPI */
 unsigned amd_iommu_aperture_order = 26; /* size of aperture in power of 2 */
-int amd_iommu_isolate;			/* if 1, device isolation is enabled */
+int amd_iommu_isolate = 1;		/* if 1, device isolation is enabled */
 bool amd_iommu_unmap_flush;		/* if true, flush on every unmap */
 
 LIST_HEAD(amd_iommu_list);		/* list of all AMD IOMMUs in the
@@ -1213,7 +1213,9 @@ static int __init parse_amd_iommu_options(char *str)
 	for (; *str; ++str) {
 		if (strncmp(str, "isolate", 7) == 0)
 			amd_iommu_isolate = 1;
-		if (strncmp(str, "fullflush", 11) == 0)
+		if (strncmp(str, "share", 5) == 0)
+			amd_iommu_isolate = 0;
+		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
 	}
 
diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index 2b69994..d1a1214 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -236,17 +236,33 @@ static inline struct ds_context *ds_alloc_context(struct task_struct *task)
 	struct ds_context *context = *p_context;
 
 	if (!context) {
+		spin_unlock(&ds_lock);
+
 		context = kzalloc(sizeof(*context), GFP_KERNEL);
 
-		if (!context)
+		if (!context) {
+			spin_lock(&ds_lock);
 			return NULL;
+		}
 
 		context->ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
 		if (!context->ds) {
 			kfree(context);
+			spin_lock(&ds_lock);
 			return NULL;
 		}
 
+		spin_lock(&ds_lock);
+		/*
+		 * Check for race - another CPU could have allocated
+		 * it meanwhile:
+		 */
+		if (*p_context) {
+			kfree(context->ds);
+			kfree(context);
+			return *p_context;
+		}
+
 		*p_context = context;
 
 		context->this = p_context;
@@ -384,14 +400,15 @@ static int ds_request(struct task_struct *task, void *base, size_t size,
 
 	spin_lock(&ds_lock);
 
-	if (!check_tracer(task))
-		return -EPERM;
-
 	error = -ENOMEM;
 	context = ds_alloc_context(task);
 	if (!context)
 		goto out_unlock;
 
+	error = -EPERM;
+	if (!check_tracer(task))
+		goto out_unlock;
+
 	error = -EALREADY;
 	if (context->owner[qual] == current)
 		goto out_unlock;
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index f454c78..0aa2c44 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -250,31 +250,24 @@ int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
-	acpi_size tbl_size;
 
-	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
+	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
 
 			oem_addrX = t->OEMTableAddr;
 			oem_size = t->OEMTableSize;
-			early_acpi_os_unmap_memory(header, tbl_size);
 
 			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
 								    oem_size);
 			return 0;
 		}
-		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
 
 void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
-	if (!oem_addr)
-		return;
-
-	__acpi_unmap_table((char *)oem_addr, oem_size);
 }
 #endif
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..9d5674f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -764,7 +764,7 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 		.callback = dmi_low_memory_corruption,
 		.ident = "Phoenix BIOS",
 		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
 		},
 	},
 #endif
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 9ffb01c..1c0dfbc 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -46,7 +46,9 @@ static __cpuinit void check_tsc_warp(void)
 	cycles_t start, now, prev, end;
 	int i;
 
+	rdtsc_barrier();
 	start = get_cycles();
+	rdtsc_barrier();
 	/*
 	 * The measurement runs for 20 msecs:
 	 */
@@ -61,7 +63,9 @@ static __cpuinit void check_tsc_warp(void)
 		 */
 		__raw_spin_lock(&sync_lock);
 		prev = last_tsc;
+		rdtsc_barrier();
 		now = get_cycles();
+		rdtsc_barrier();
 		last_tsc = now;
 		__raw_spin_unlock(&sync_lock);
 
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index 0e33165..5214500 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -7,6 +7,7 @@
  * This file provides all the same external entries as smp.c but uses
  * the voyager hal to provide the functionality
  */
+#include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/kernel_stat.h>
@@ -1790,6 +1791,17 @@ void __init smp_setup_processor_id(void)
 	x86_write_percpu(cpu_number, hard_smp_processor_id());
 }
 
+static void voyager_send_call_func(cpumask_t callmask)
+{
+	__u32 mask = cpus_addr(callmask)[0] & ~(1 << smp_processor_id());
+	send_CPI(mask, VIC_CALL_FUNCTION_CPI);
+}
+
+static void voyager_send_call_func_single(int cpu)
+{
+	send_CPI(1 << cpu, VIC_CALL_FUNCTION_SINGLE_CPI);
+}
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu = voyager_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = voyager_smp_prepare_cpus,
@@ -1799,6 +1811,6 @@ struct smp_ops smp_ops = {
 	.smp_send_stop = voyager_smp_send_stop,
 	.smp_send_reschedule = voyager_smp_send_reschedule,
 
-	.send_call_func_ipi = native_send_call_func_ipi,
-	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.send_call_func_ipi = voyager_send_call_func,
+	.send_call_func_single_ipi = voyager_send_call_func_single,
 };
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a0fb5ea..526c191 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -122,14 +122,7 @@ static struct timer_list balloon_timer;
 static void scrub_page(struct page *page)
 {
 #ifdef CONFIG_XEN_SCRUB_PAGES
-	if (PageHighMem(page)) {
-		void *v = kmap(page);
-		clear_page(v);
-		kunmap(v);
-	} else {
-		void *v = page_address(page);
-		clear_page(v);
-	}
+	clear_highpage(page);
 #endif
 }
 
