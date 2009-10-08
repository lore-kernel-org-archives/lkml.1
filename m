Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbZJHS6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbZJHS6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 14:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbZJHS6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 14:58:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39193 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbZJHS6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:04 -0400
Date: Thu, 8 Oct 2009 20:57:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091008185712.GA21197@elte.hu>
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


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/edac/Kconfig               # 0d18b2e: x86: EDAC: carve out AMD MCE deco
drivers/edac/Makefile              # 0d18b2e: x86: EDAC: carve out AMD MCE deco
                                   # f436f8b: x86: EDAC: MCE: Fix MCE decoding 
drivers/edac/edac_mce_amd.c        # 0d18b2e: x86: EDAC: carve out AMD MCE deco
                                   # f436f8b: x86: EDAC: MCE: Fix MCE decoding 
include/linux/init.h               # 329bd41: initcalls: Add early_initcall() f

( Contains the simplest incarnation of the EDAC/MCE fixes - we plan to 
  do the followup patches for .33. )

 Thanks,

	Ingo

------------------>
Arjan van de Ven (1):
      x86: Simplify bound checks in the MTRR code

Borislav Petkov (2):
      initcalls: Add early_initcall() for modules
      x86: EDAC: carve out AMD MCE decoding logic

Ingo Molnar (1):
      x86: EDAC: MCE: Fix MCE decoding callback logic

Marin Mitov (1):
      x86, pci: Correct spelling in a comment


 arch/x86/include/asm/mce.h       |    2 +
 arch/x86/kernel/cpu/mcheck/mce.c |   58 +++++++++++++++++++++++--------------
 arch/x86/kernel/cpu/mtrr/if.c    |   17 ++++++++---
 arch/x86/kernel/pci-dma.c        |    2 +-
 drivers/edac/Kconfig             |   14 ++++++++-
 drivers/edac/Makefile            |    5 +--
 drivers/edac/edac_mce_amd.c      |   32 ++++++++++++++++++++-
 include/linux/init.h             |    1 +
 8 files changed, 97 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index b608a64..f1363b7 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -133,6 +133,8 @@ static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
 static inline void enable_p5_mce(void) {}
 #endif
 
+extern void (*x86_mce_decode_callback)(struct mce *m);
+
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 183c345..b1598a9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -85,6 +85,18 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
 static DEFINE_PER_CPU(struct mce, mces_seen);
 static int			cpu_missing;
 
+static void default_decode_mce(struct mce *m)
+{
+	pr_emerg("No human readable MCE decoding support on this CPU type.\n");
+	pr_emerg("Run the message through 'mcelog --ascii' to decode.\n");
+}
+
+/*
+ * CPU/chipset specific EDAC code can register a callback here to print
+ * MCE errors in a human-readable form:
+ */
+void (*x86_mce_decode_callback)(struct mce *m) = default_decode_mce;
+EXPORT_SYMBOL(x86_mce_decode_callback);
 
 /* MCA banks polled by the period polling timer for corrected events */
 DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
@@ -165,46 +177,46 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
-void __weak decode_mce(struct mce *m)
-{
-	return;
-}
-
 static void print_mce(struct mce *m)
 {
-	printk(KERN_EMERG
-	       "CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
+	pr_emerg("CPU %d: Machine Check Exception: %16Lx Bank %d: %016Lx\n",
 	       m->extcpu, m->mcgstatus, m->bank, m->status);
+
 	if (m->ip) {
-		printk(KERN_EMERG "RIP%s %02x:<%016Lx> ",
-		       !(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
-		       m->cs, m->ip);
+		pr_emerg("RIP%s %02x:<%016Lx> ",
+			!(m->mcgstatus & MCG_STATUS_EIPV) ? " !INEXACT!" : "",
+				m->cs, m->ip);
+
 		if (m->cs == __KERNEL_CS)
 			print_symbol("{%s}", m->ip);
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 	}
-	printk(KERN_EMERG "TSC %llx ", m->tsc);
+
+	pr_emerg("TSC %llx ", m->tsc);
 	if (m->addr)
-		printk(KERN_CONT "ADDR %llx ", m->addr);
+		pr_cont("ADDR %llx ", m->addr);
 	if (m->misc)
-		printk(KERN_CONT "MISC %llx ", m->misc);
-	printk(KERN_CONT "\n");
-	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
-			m->cpuvendor, m->cpuid, m->time, m->socketid,
-			m->apicid);
+		pr_cont("MISC %llx ", m->misc);
+
+	pr_cont("\n");
+	pr_emerg("PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
+		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
 
-	decode_mce(m);
+	/*
+	 * Print out human-readable details about the MCE error,
+	 * (if the CPU has an implementation for that):
+	 */
+	x86_mce_decode_callback(m);
 }
 
 static void print_mce_head(void)
 {
-	printk(KERN_EMERG "\nHARDWARE ERROR\n");
+	pr_emerg("\nHARDWARE ERROR\n");
 }
 
 static void print_mce_tail(void)
 {
-	printk(KERN_EMERG "This is not a software problem!\n"
-	       "Run through mcelog --ascii to decode and contact your hardware vendor\n");
+	pr_emerg("This is not a software problem!\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
@@ -218,6 +230,7 @@ static atomic_t mce_fake_paniced;
 static void wait_for_panic(void)
 {
 	long timeout = PANIC_TIMEOUT*USEC_PER_SEC;
+
 	preempt_disable();
 	local_irq_enable();
 	while (timeout-- > 0)
@@ -285,6 +298,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
 static int msr_to_offset(u32 msr)
 {
 	unsigned bank = __get_cpu_var(injectm.bank);
+
 	if (msr == rip_msr)
 		return offsetof(struct mce, ip);
 	if (msr == MSR_IA32_MCx_STATUS(bank))
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index f04e725..3c1b12d 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -96,17 +96,24 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	unsigned long long base, size;
 	char *ptr;
 	char line[LINE_SIZE];
+	int length;
 	size_t linelen;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (!len)
-		return -EINVAL;
 
 	memset(line, 0, LINE_SIZE);
-	if (len > LINE_SIZE)
-		len = LINE_SIZE;
-	if (copy_from_user(line, buf, len - 1))
+
+	length = len;
+	length--;
+
+	if (length > LINE_SIZE - 1)
+		length = LINE_SIZE - 1;
+
+	if (length < 0)
+		return -EINVAL;
+
+	if (copy_from_user(line, buf, length))
 		return -EFAULT;
 
 	linelen = strlen(line);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 64b838e..d20009b 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -35,7 +35,7 @@ int iommu_detected __read_mostly = 0;
 
 /*
  * This variable becomes 1 if iommu=pt is passed on the kernel command line.
- * If this variable is 1, IOMMU implementations do no DMA ranslation for
+ * If this variable is 1, IOMMU implementations do no DMA translation for
  * devices and allow every device to access to whole physical memory. This is
  * useful if a user want to use an IOMMU only for KVM device assignment to
  * guests and not for driver dma translation.
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 02127e5..55c9c59 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -47,6 +47,18 @@ config EDAC_DEBUG_VERBOSE
 	  Source file name and line number where debugging message
 	  printed will be added to debugging message.
 
+ config EDAC_DECODE_MCE
+	tristate "Decode MCEs in human-readable form (only on AMD for now)"
+	depends on CPU_SUP_AMD && X86_MCE
+	default y
+	---help---
+	  Enable this option if you want to decode Machine Check Exceptions
+	  occuring on your machine in human-readable form.
+
+	  You should definitely say Y here in case you want to decode MCEs
+	  which occur really early upon boot, before the module infrastructure
+	  has been initialized.
+
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
 	help
@@ -59,7 +71,7 @@ config EDAC_MM_EDAC
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && CPU_SUP_AMD
+	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction on the AMD 64
 	  Families of Memory Controllers (K8, F10h and F11h)
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 7a473bb..bc5dc23 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -6,7 +6,6 @@
 # GNU General Public License.
 #
 
-
 obj-$(CONFIG_EDAC)			:= edac_stub.o
 obj-$(CONFIG_EDAC_MM_EDAC)		+= edac_core.o
 
@@ -17,9 +16,7 @@ ifdef CONFIG_PCI
 edac_core-objs	+= edac_pci.o edac_pci_sysfs.o
 endif
 
-ifdef CONFIG_CPU_SUP_AMD
-edac_core-objs  += edac_mce_amd.o
-endif
+obj-$(CONFIG_EDAC_DECODE_MCE)		+= edac_mce_amd.o
 
 obj-$(CONFIG_EDAC_AMD76X)		+= amd76x_edac.o
 obj-$(CONFIG_EDAC_CPC925)		+= cpc925_edac.o
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 0c21c37..713ed7d 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -3,6 +3,7 @@
 
 static bool report_gart_errors;
 static void (*nb_bus_decoder)(int node_id, struct err_regs *regs);
+static void (*orig_mce_callback)(struct mce *m);
 
 void amd_report_gart_errors(bool v)
 {
@@ -362,7 +363,7 @@ static inline void amd_decode_err_code(unsigned int ec)
 		pr_warning("Huh? Unknown MCE error 0x%x\n", ec);
 }
 
-void decode_mce(struct mce *m)
+static void amd_decode_mce(struct mce *m)
 {
 	struct err_regs regs;
 	int node, ecc;
@@ -420,3 +421,32 @@ void decode_mce(struct mce *m)
 
 	amd_decode_err_code(m->status & 0xffff);
 }
+
+static int __init mce_amd_init(void)
+{
+	/*
+	 * We can decode MCEs for Opteron and later CPUs:
+	 */
+	if ((boot_cpu_data.x86_vendor == X86_VENDOR_AMD) &&
+	    (boot_cpu_data.x86 >= 0xf)) {
+		/* safe the default decode mce callback */
+		orig_mce_callback = x86_mce_decode_callback;
+
+		x86_mce_decode_callback = amd_decode_mce;
+	}
+
+	return 0;
+}
+early_initcall(mce_amd_init);
+
+#ifdef MODULE
+static void __exit mce_amd_exit(void)
+{
+	x86_mce_decode_callback = orig_mce_callback;
+}
+
+MODULE_DESCRIPTION("AMD MCE decoder");
+MODULE_ALIAS("edac-mce-amd");
+MODULE_LICENSE("GPL");
+module_exit(mce_amd_exit);
+#endif
diff --git a/include/linux/init.h b/include/linux/init.h
index 400adbb..ff8bde5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -271,6 +271,7 @@ void __init parse_early_options(char *cmdline);
 #else /* MODULE */
 
 /* Don't use these in modules, but some people do... */
+#define early_initcall(fn)		module_init(fn)
 #define core_initcall(fn)		module_init(fn)
 #define postcore_initcall(fn)		module_init(fn)
 #define arch_initcall(fn)		module_init(fn)
