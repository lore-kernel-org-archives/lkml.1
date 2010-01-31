Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871Ab0AaRUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0AaRUI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 12:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752904Ab0AaRUH
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 12:20:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49071 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab0AaRUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 12:20:05 -0500
Date: Sun, 31 Jan 2010 18:19:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100131171952.GA30042@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/char/agp/amd64-agp.c       # 61684ce: x86/agp: Fix agp_amd64_init regre
drivers/char/uv_mmtimer.c          # aca3bb5: x86, UV: Fix RTC latency bug by r
lib/dma-debug.c                    # aeb583d: lib/dma-debug.c: mark file-local 

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      oprofile/x86: add Xeon 7500 series support

David Härdeman (1):
      x86: Add quirk for Intel DG45FC board to avoid low memory corruption

Dimitri Sivanich (1):
      x86, UV: Fix RTC latency bug by reading replicated cachelines

FUJITA Tomonori (1):
      x86/agp: Fix agp_amd64_init regression

Joerg Roedel (4):
      x86/amd-iommu: Fix possible integer overflow
      x86/amd-iommu: Fix NULL pointer dereference in __detach_device()
      x86/amd-iommu: Fix IOMMU-API initialization for iommu=pt
      x86/amd-iommu: Fix deassignment of a device from the pt_domain

Leann Ogasawara (1):
      x86: Add Dell OptiPlex 760 reboot quirk

Suravee Suthikulpanit (1):
      oprofile/x86: fix crash when profiling more than 28 events

Thiago Farina (1):
      lib/dma-debug.c: mark file-local struct symbol static.


 arch/x86/include/asm/amd_iommu_proto.h |    1 +
 arch/x86/kernel/amd_iommu.c            |   23 ++++++++++++++++-------
 arch/x86/kernel/amd_iommu_init.c       |    3 +++
 arch/x86/kernel/reboot.c               |    9 +++++++++
 arch/x86/kernel/setup.c                |   14 +++++++++++---
 arch/x86/kernel/uv_time.c              |   13 ++++++++++++-
 arch/x86/oprofile/nmi_int.c            |    3 ++-
 drivers/char/agp/amd64-agp.c           |   13 +++++++++----
 drivers/char/uv_mmtimer.c              |   18 +++++++++++-------
 lib/dma-debug.c                        |    2 +-
 10 files changed, 75 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_proto.h b/arch/x86/include/asm/amd_iommu_proto.h
index 4d817f9..d2544f1 100644
--- a/arch/x86/include/asm/amd_iommu_proto.h
+++ b/arch/x86/include/asm/amd_iommu_proto.h
@@ -31,6 +31,7 @@ extern void amd_iommu_reset_cmd_buffer(struct amd_iommu *iommu);
 extern int amd_iommu_init_devices(void);
 extern void amd_iommu_uninit_devices(void);
 extern void amd_iommu_init_notifier(void);
+extern void amd_iommu_init_api(void);
 #ifndef CONFIG_AMD_IOMMU_STATS
 
 static inline void amd_iommu_stats_init(void) { }
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 23824fe..adb0ba0 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -980,7 +980,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 {
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
 	struct amd_iommu *iommu;
-	int i;
+	unsigned long i;
 
 #ifdef CONFIG_IOMMU_STRESS
 	populate = false;
@@ -1489,11 +1489,14 @@ static void __detach_device(struct device *dev)
 {
 	struct iommu_dev_data *dev_data = get_dev_data(dev);
 	struct iommu_dev_data *alias_data;
+	struct protection_domain *domain;
 	unsigned long flags;
 
 	BUG_ON(!dev_data->domain);
 
-	spin_lock_irqsave(&dev_data->domain->lock, flags);
+	domain = dev_data->domain;
+
+	spin_lock_irqsave(&domain->lock, flags);
 
 	if (dev_data->alias != dev) {
 		alias_data = get_dev_data(dev_data->alias);
@@ -1504,13 +1507,15 @@ static void __detach_device(struct device *dev)
 	if (atomic_dec_and_test(&dev_data->bind))
 		do_detach(dev);
 
-	spin_unlock_irqrestore(&dev_data->domain->lock, flags);
+	spin_unlock_irqrestore(&domain->lock, flags);
 
 	/*
 	 * If we run in passthrough mode the device must be assigned to the
-	 * passthrough domain if it is detached from any other domain
+	 * passthrough domain if it is detached from any other domain.
+	 * Make sure we can deassign from the pt_domain itself.
 	 */
-	if (iommu_pass_through && dev_data->domain == NULL)
+	if (iommu_pass_through &&
+	    (dev_data->domain == NULL && domain != pt_domain))
 		__attach_device(dev, pt_domain);
 }
 
@@ -2218,6 +2223,12 @@ static struct dma_map_ops amd_iommu_dma_ops = {
 /*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
+
+void __init amd_iommu_init_api(void)
+{
+	register_iommu(&amd_iommu_ops);
+}
+
 int __init amd_iommu_init_dma_ops(void)
 {
 	struct amd_iommu *iommu;
@@ -2253,8 +2264,6 @@ int __init amd_iommu_init_dma_ops(void)
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
 
-	register_iommu(&amd_iommu_ops);
-
 	amd_iommu_stats_init();
 
 	return 0;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index fb490ce..9dc91b4 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1292,9 +1292,12 @@ static int __init amd_iommu_init(void)
 		ret = amd_iommu_init_passthrough();
 	else
 		ret = amd_iommu_init_dma_ops();
+
 	if (ret)
 		goto free;
 
+	amd_iommu_init_api();
+
 	amd_iommu_init_notifier();
 
 	enable_iommus();
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 1545bc0..704bddc 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -203,6 +203,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0T656F"),
 		},
 	},
+	{	/* Handle problems with rebooting on Dell OptiPlex 760 with 0G919G*/
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 760",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 760"),
+			DMI_MATCH(DMI_BOARD_NAME, "0G919G"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7b8b98..5d9e40c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -642,19 +642,27 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix/MSC"),
 		},
 	},
-	{
 	/*
-	 * AMI BIOS with low memory corruption was found on Intel DG45ID board.
-	 * It hase different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
+	 * AMI BIOS with low memory corruption was found on Intel DG45ID and
+	 * DG45FC boards.
+	 * It has a different DMI_BIOS_VENDOR = "Intel Corp.", for now we will
 	 * match only DMI_BOARD_NAME and see if there is more bad products
 	 * with this vendor.
 	 */
+	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "DG45ID"),
 		},
 	},
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "AMI BIOS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
+		},
+	},
 #endif
 	{}
 };
diff --git a/arch/x86/kernel/uv_time.c b/arch/x86/kernel/uv_time.c
index 3c84aa0..2b75ef6 100644
--- a/arch/x86/kernel/uv_time.c
+++ b/arch/x86/kernel/uv_time.c
@@ -282,10 +282,21 @@ static int uv_rtc_unset_timer(int cpu, int force)
 
 /*
  * Read the RTC.
+ *
+ * Starting with HUB rev 2.0, the UV RTC register is replicated across all
+ * cachelines of it's own page.  This allows faster simultaneous reads
+ * from a given socket.
  */
 static cycle_t uv_read_rtc(struct clocksource *cs)
 {
-	return (cycle_t)uv_read_local_mmr(UVH_RTC);
+	unsigned long offset;
+
+	if (uv_get_min_hub_revision_id() == 1)
+		offset = 0;
+	else
+		offset = (uv_blade_processor_id() * L1_CACHE_BYTES) % PAGE_SIZE;
+
+	return (cycle_t)uv_read_local_mmr(UVH_RTC | offset);
 }
 
 /*
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cb88b1a..3347f69 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -222,7 +222,7 @@ static void nmi_cpu_switch(void *dummy)
 
 	/* move to next set */
 	si += model->num_counters;
-	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+	if ((si >= model->num_virt_counters) || (counter_config[si].count == 0))
 		per_cpu(switch_index, cpu) = 0;
 	else
 		per_cpu(switch_index, cpu) = si;
@@ -598,6 +598,7 @@ static int __init ppro_init(char **cpu_type)
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 0x2e:
 	case 26:
 		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 1afb896..34cf04e 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -729,9 +729,6 @@ int __init agp_amd64_init(void)
 	if (agp_off)
 		return -EINVAL;
 
-	if (gart_iommu_aperture)
-		return agp_bridges_found ? 0 : -ENODEV;
-
 	err = pci_register_driver(&agp_amd64_pci_driver);
 	if (err < 0)
 		return err;
@@ -768,6 +765,14 @@ int __init agp_amd64_init(void)
 	return err;
 }
 
+static int __init agp_amd64_mod_init(void)
+{
+	if (gart_iommu_aperture)
+		return agp_bridges_found ? 0 : -ENODEV;
+
+	return agp_amd64_init();
+}
+
 static void __exit agp_amd64_cleanup(void)
 {
 	if (gart_iommu_aperture)
@@ -777,7 +782,7 @@ static void __exit agp_amd64_cleanup(void)
 	pci_unregister_driver(&agp_amd64_pci_driver);
 }
 
-module_init(agp_amd64_init);
+module_init(agp_amd64_mod_init);
 module_exit(agp_amd64_cleanup);
 
 MODULE_AUTHOR("Dave Jones <davej@redhat.com>, Andi Kleen");
diff --git a/drivers/char/uv_mmtimer.c b/drivers/char/uv_mmtimer.c
index 867b67b..c7072ba 100644
--- a/drivers/char/uv_mmtimer.c
+++ b/drivers/char/uv_mmtimer.c
@@ -89,13 +89,17 @@ static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
 	switch (cmd) {
 	case MMTIMER_GETOFFSET:	/* offset of the counter */
 		/*
-		 * UV RTC register is on its own page
+		 * Starting with HUB rev 2.0, the UV RTC register is
+		 * replicated across all cachelines of it's own page.
+		 * This allows faster simultaneous reads from a given socket.
+		 *
+		 * The offset returned is in 64 bit units.
 		 */
-		if (PAGE_SIZE <= (1 << 16))
-			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
-				/ 8;
+		if (uv_get_min_hub_revision_id() == 1)
+			ret = 0;
 		else
-			ret = -ENOSYS;
+			ret = ((uv_blade_processor_id() * L1_CACHE_BYTES) %
+					PAGE_SIZE) / 8;
 		break;
 
 	case MMTIMER_GETRES: /* resolution of the clock in 10^-15 s */
@@ -115,8 +119,8 @@ static long uv_mmtimer_ioctl(struct file *file, unsigned int cmd,
 		ret = hweight64(UVH_RTC_REAL_TIME_CLOCK_MASK);
 		break;
 
-	case MMTIMER_MMAPAVAIL: /* can we mmap the clock into userspace? */
-		ret = (PAGE_SIZE <= (1 << 16)) ? 1 : 0;
+	case MMTIMER_MMAPAVAIL:
+		ret = 1;
 		break;
 
 	case MMTIMER_GETCOUNTER:
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index 7d2f0b3..ba8b670 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -587,7 +587,7 @@ out_unlock:
 	return count;
 }
 
-const struct file_operations filter_fops = {
+static const struct file_operations filter_fops = {
 	.read  = filter_read,
 	.write = filter_write,
 };
