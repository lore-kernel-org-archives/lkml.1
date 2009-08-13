Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZHMSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZHMSta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbZHMSt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:49:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51726 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761AbZHMSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:49:29 -0400
Date: Thu, 13 Aug 2009 20:49:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090813184914.GA16877@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
Dmitry Torokhov (1):
      x86, mce: therm_throt - change when we print messages

Kevin Winchester (1):
      x86: Clear incorrectly forced X86_FEATURE_LAHF_LM flag

Ondrej Zary (1):
      x86: Fix oops in identify_cpu() on CPUs without CPUID

Shunichi Fuji (1):
      x86: Add reboot quirk for every 5 series MacBook/Pro


 arch/x86/kernel/cpu/amd.c                |    7 ++++
 arch/x86/kernel/cpu/common.c             |   48 +++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   18 +++++++----
 arch/x86/kernel/reboot.c                 |   12 ++++----
 4 files changed, 48 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index e2485b0..63fddcd 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -400,6 +400,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		level = cpuid_eax(1);
 		if((level >= 0x0f48 && level < 0x0f50) || level >= 0x0f58)
 			set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+
+		/*
+		 * Some BIOSes incorrectly force this feature, but only K8
+		 * revision D (model = 0x14) and later actually support it.
+		 */
+		if (c->x86_model < 0x14)
+			clear_cpu_cap(c, X86_FEATURE_LAHF_LM);
 	}
 	if (c->x86 == 0x10 || c->x86 == 0x11)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f1961c0..5ce60a8 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -59,7 +59,30 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
-static const struct cpu_dev *this_cpu __cpuinitdata;
+static void __cpuinit default_init(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_X86_64
+	display_cacheinfo(c);
+#else
+	/* Not much we can do here... */
+	/* Check if at least it has cpuid */
+	if (c->cpuid_level == -1) {
+		/* No cpuid. It must be an ancient CPU */
+		if (c->x86 == 4)
+			strcpy(c->x86_model_id, "486");
+		else if (c->x86 == 3)
+			strcpy(c->x86_model_id, "386");
+	}
+#endif
+}
+
+static const struct cpu_dev __cpuinitconst default_cpu = {
+	.c_init		= default_init,
+	.c_vendor	= "Unknown",
+	.c_x86_vendor	= X86_VENDOR_UNKNOWN,
+};
+
+static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
@@ -332,29 +355,6 @@ void switch_to_new_gdt(int cpu)
 
 static const struct cpu_dev *__cpuinitdata cpu_devs[X86_VENDOR_NUM] = {};
 
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
-{
-#ifdef CONFIG_X86_64
-	display_cacheinfo(c);
-#else
-	/* Not much we can do here... */
-	/* Check if at least it has cpuid */
-	if (c->cpuid_level == -1) {
-		/* No cpuid. It must be an ancient CPU */
-		if (c->x86 == 4)
-			strcpy(c->x86_model_id, "486");
-		else if (c->x86 == 3)
-			strcpy(c->x86_model_id, "386");
-	}
-#endif
-}
-
-static const struct cpu_dev __cpuinitconst default_cpu = {
-	.c_init	= default_init,
-	.c_vendor = "Unknown",
-	.c_x86_vendor = X86_VENDOR_UNKNOWN,
-};
-
 static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index bff8dd1..8bc64cf 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -36,6 +36,7 @@
 
 static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
 static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
+static DEFINE_PER_CPU(bool, thermal_throttle_active);
 
 static atomic_t therm_throt_en		= ATOMIC_INIT(0);
 
@@ -96,24 +97,27 @@ static int therm_throt_process(int curr)
 {
 	unsigned int cpu = smp_processor_id();
 	__u64 tmp_jiffs = get_jiffies_64();
+	bool was_throttled = __get_cpu_var(thermal_throttle_active);
+	bool is_throttled = __get_cpu_var(thermal_throttle_active) = curr;
 
-	if (curr)
+	if (is_throttled)
 		__get_cpu_var(thermal_throttle_count)++;
 
-	if (time_before64(tmp_jiffs, __get_cpu_var(next_check)))
+	if (!(was_throttled ^ is_throttled) &&
+	    time_before64(tmp_jiffs, __get_cpu_var(next_check)))
 		return 0;
 
 	__get_cpu_var(next_check) = tmp_jiffs + CHECK_INTERVAL;
 
 	/* if we just entered the thermal event */
-	if (curr) {
+	if (is_throttled) {
 		printk(KERN_CRIT "CPU%d: Temperature above threshold, "
-		       "cpu clock throttled (total events = %lu)\n", cpu,
-		       __get_cpu_var(thermal_throttle_count));
+		       "cpu clock throttled (total events = %lu)\n",
+		       cpu, __get_cpu_var(thermal_throttle_count));
 
 		add_taint(TAINT_MACHINE_CHECK);
-	} else {
-		printk(KERN_CRIT "CPU%d: Temperature/speed normal\n", cpu);
+	} else if (was_throttled) {
+		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
 	}
 
 	return 1;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 9eb8976..a06e8d1 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -418,20 +418,20 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 }
 
 static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
-	{	/* Handle problems with rebooting on Apple MacBook5,2 */
+	{	/* Handle problems with rebooting on Apple MacBook5 */
 		.callback = set_pci_reboot,
-		.ident = "Apple MacBook",
+		.ident = "Apple MacBook5",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5,2"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
 		},
 	},
-	{	/* Handle problems with rebooting on Apple MacBookPro5,1 */
+	{	/* Handle problems with rebooting on Apple MacBookPro5 */
 		.callback = set_pci_reboot,
-		.ident = "Apple MacBookPro5,1",
+		.ident = "Apple MacBookPro5",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,1"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5"),
 		},
 	},
 	{ }
