Return-Path: <linux-kernel-owner+w=401wt.eu-S1763980AbZFMQkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763980AbZFMQkr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933145AbZFMQjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:39:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:34633 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165AbZFMQju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:39:50 -0400
Subject: [RFC][PATCH 8/10 -tip] x86: cpu_debug display PCI configuration
 registers for AMD
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1244910798.11733.22.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
	 <1244910618.11733.18.camel@ht.satnam> <1244910655.11733.19.camel@ht.satnam>
	 <1244910701.11733.20.camel@ht.satnam> <1244910755.11733.21.camel@ht.satnam>
	 <1244910798.11733.22.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:04:21 +0530
Message-Id: <1244910861.11733.23.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


PCI-defined configuration space PCIX_YYY:

  X specifies the function number
  YYY specifies the byte address of the configuration register in hex

  e.g., PCI3_040 specifies the register at function 3, address 0x40.

AMD processor supports five functions, 0 through 4.

Also updated MAX_CPU_FILES to 768 to handle pci files.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |   11 ++-
 arch/x86/kernel/cpu/cpu_debug.c  |  280 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 288 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index fd20da7..dc24338 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -41,10 +41,17 @@ enum cpu_debug_bit {
 	CPU_IBS,				/* IBS			*/
 	CPU_SVM,				/*Secure Virtual Machine*/
 	CPU_OSVM,				/* OS-Visible Workaround*/
+	CPU_NB,					/* North Bridge		*/
+	CPU_DRAM,				/* DRAM			*/
+	CPU_MMIO,				/* Memory based IO	*/
+	CPU_DISPLAY,				/* Display/VGA		*/
+	CPU_LINK,				/* HyperTransport	*/
+	CPU_CPUID,				/* CPUID		*/
 /* Standard Registers							*/
 	CPU_TSS,				/* Task Stack Segment	*/
 	CPU_CR,					/* Control Registers	*/
 	CPU_DT,					/* Descriptor Table	*/
+	CPU_PCI,				/* PCI configuration	*/
 /* End of Registers flags						*/
 	CPU_REG_MAX,				/* Max Registers flags	*/
 };
@@ -62,9 +69,11 @@ enum cpu_cat_bit {
 	CPU_REG_STD,				/* Standard registers	*/
 	CPU_REG_MSR,				/* MSRs			*/
 	CPU_REG_APIC,				/* APIC registers	*/
+	CPU_REG_PCI,				/* PCI conf registers	*/
 };
 
-#define MAX_CPU_FILES		512
+#define MAX_CPU_FILES		768		/* Max CPU debug files	*/
+#define MAX_CPU_PCI		5		/* AMD supports func 0-4*/
 
 struct cpu_private {
 	unsigned		cpu;
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index fcfd22f..b4dfddd 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/slab.h>
+#include <linux/pci.h>
 #include <linux/smp.h>
 
 #include <asm/cpu_debug.h>
@@ -27,6 +28,7 @@
 
 static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_MAX]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
+static DEFINE_PER_CPU(struct pci_dev *, pci_arr[MAX_CPU_PCI]);
 static DEFINE_PER_CPU(int, cpu_priv_count);
 
 static DEFINE_MUTEX(cpu_debug_lock);
@@ -65,9 +67,16 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "ibs",	CPU_IBS,	0	},
 	{ "svm",	CPU_SVM,	0	},
 	{ "osvm",	CPU_OSVM,	0	},
+	{ "nbridge",	CPU_NB,		0	},
+	{ "dram",	CPU_DRAM,	0	},
+	{ "mmio",	CPU_MMIO,	0	},
+	{ "display",	CPU_DISPLAY,	0	},
+	{ "link",	CPU_LINK,	0	},
+	{ "cpuid",	CPU_CPUID,	0	},
 	{ "tss",	CPU_TSS,	0	},
 	{ "cr",		CPU_CR,		0	},
 	{ "dt",		CPU_DT,		0	},
+	{ "pci",	CPU_PCI,	0	},
 	{ "registers",	CPU_REG_ALL,	0	},
 };
 
@@ -207,6 +216,93 @@ static struct cpu_debug_range cpu_msr_range[] = {
 	{ 0xC0011030, 0xC001103A, CPU_IBS,	},
 };
 
+/* PCI-defined configurations registers		*/
+
+/* Function 0 Link Configuration Registers	*/
+static struct cpu_debug_range cpu_amd_pci0[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x06C,	CPU_LINK	},
+	{ 0x080,	0x098,	CPU_LINK	},
+	{ 0x0A0,	0x0B8,	CPU_LINK	},
+	{ 0x0C0,	0x0D8,	CPU_LINK	},
+	{ 0x0E0,	0x0F8,	CPU_LINK	},
+	{ 0x110,	0x150,	CPU_LINK	},
+	{ 0x164,	0x18C,	CPU_LINK	},
+	{ 0x1A0,	0x1A0,	CPU_LINK	},
+	{ 0x1A4,	0x1A4,	CPU_DISPLAY	},
+	{ 0x1D0,	0x1D4,	CPU_DISPLAY	},
+};
+
+/* Function 1 Address Map Registers		*/
+static struct cpu_debug_range cpu_amd_pci1[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x07C,	CPU_DRAM	},
+	{ 0x080,	0x0BC,	CPU_MMIO	},
+	{ 0x0C0,	0x0DC,	CPU_PCI		},
+	{ 0x0E0,	0x0EC,	CPU_CONF	},
+	{ 0x0F0,	0x0F0,	CPU_DRAM	},
+	{ 0x0F4,	0x0F4,	CPU_DISPLAY	},
+	{ 0x110,	0x114,	CPU_MMIO	},
+	{ 0x120,	0x124,	CPU_DRAM	},
+	{ 0x140,	0x17C,	CPU_DRAM	},
+	{ 0x180,	0x184,	CPU_NB		},
+};
+
+/* Function 2 DRAM Controller Registers		*/
+static struct cpu_debug_range cpu_amd_pci2[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x0A4,	CPU_DRAM	},
+	{ 0x10C,	0x11C,	CPU_DRAM	},
+	{ 0x140,	0x16C,	CPU_DRAM	},
+	{ 0x178,	0x1A0,	CPU_DRAM	},
+	{ 0x1B0,	0x1B0,	CPU_DRAM	},
+};
+
+/* Function 3 Misc. Configuration Registers	*/
+static struct cpu_debug_range cpu_amd_pci3[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x040,	0x054,	CPU_NB		},
+	{ 0x058,	0x060,	CPU_DRAM	},
+	{ 0x064,	0x068,	CPU_THERM	},
+	{ 0x06C,	0x06C,	CPU_POWER	},
+	{ 0x070,	0x07C,	CPU_DISPLAY	},
+	{ 0x080,	0x084,	CPU_POWER	},
+	{ 0x088,	0x08C,	CPU_NB		},
+	{ 0x090,	0x09C,	CPU_DISPLAY	},
+	{ 0x0A0,	0x0A0,	CPU_POWER	},
+	{ 0x0A4,	0x0A4,	CPU_THERM	},
+	{ 0x0B0,	0x0B0,	CPU_DISPLAY	},
+	{ 0x0D4,	0x0DC,	CPU_POWER	},
+	{ 0x0E4,	0x0E4,	CPU_THERM	},
+	{ 0x0E8,	0x0E8,	CPU_NB		},
+	{ 0x0F0,	0x0F0,	CPU_PCI		},
+	{ 0x0F4,	0x0F8,	CPU_PCI		},
+	{ 0x0FC,	0x0FC,	CPU_CPUID	},
+	{ 0x140,	0x180,	CPU_NB		},
+	{ 0x188,	0x188,	CPU_NB		},
+	{ 0x190,	0x190,	CPU_CONTROL	},
+	{ 0x1A0,	0x1A0,	CPU_CACHE	},
+	{ 0x1CC,	0x1CC,	CPU_IBS		},
+	{ 0x1E4,	0x1EC,	CPU_THERM	},
+	{ 0x1F0,	0x1F0,	CPU_CPUID	},
+	{ 0x1FC,	0x1FC,	CPU_NB		},
+};
+
+/* Function 4 Link Configuration Registers	*/
+static struct cpu_debug_range cpu_amd_pci4[] = {
+	{ 0x000,	0x00C,	CPU_PCI		},
+	{ 0x034,	0x034,	CPU_PCI		},
+	{ 0x080,	0x0F8,	CPU_LINK	},
+	{ 0x170,	0x174,	CPU_POWER	},
+	{ 0x180,	0x19C,	CPU_LINK	},
+	{ 0x1C4,	0x1C4,	CPU_POWER	},
+	{ 0x1E0,	0x1F0,	CPU_POWER	},
+};
+
 /* Check validity of cpu debug flag */
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
@@ -433,6 +529,92 @@ static void print_apicval(void *arg)
 #endif
 }
 
+static void print_pcival(void *arg)
+{
+	struct seq_file *seq = arg;
+	struct cpu_private *priv = seq->private;
+	struct pci_dev *dev;
+	u32 data = (priv->reg & 0xf0000) >> 16;
+
+	if (data >= MAX_CPU_PCI)
+		return;
+
+	dev = per_cpu(pci_arr[data], priv->cpu);
+	if (!pci_read_config_dword(dev, priv->reg & 0x0fff, &data))
+		seq_printf(seq, "0x%x\n", data);
+}
+
+#define PRINT_AMD_PCI(func) \
+static void print_amd_pci##func(struct seq_file *seq, struct pci_dev *dev) \
+{									\
+	unsigned int reg, i;						\
+	u32 data;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(cpu_amd_pci##func); i++) {		\
+		for (reg = cpu_amd_pci##func[i].min; 			\
+		     reg <= cpu_amd_pci##func[i].max; reg++) {		\
+			if (!pci_read_config_dword(dev, reg, &data)) {	\
+				seq_printf(seq, " %03x\t: %08x\n", 	\
+					   reg, data);			\
+			}						\
+		}							\
+	}								\
+	seq_printf(seq, "\n");						\
+}
+
+PRINT_AMD_PCI(0)
+PRINT_AMD_PCI(1)
+PRINT_AMD_PCI(2)
+PRINT_AMD_PCI(3)
+PRINT_AMD_PCI(4)
+
+static void print_amd_pci(struct seq_file *seq)
+{
+	struct cpu_private *priv = seq->private;
+	struct pci_dev *dev;
+	unsigned int func;
+
+	for (func = 0; func < MAX_CPU_PCI; func++) {
+		dev = per_cpu(pci_arr[func], priv->cpu);
+		if (dev == NULL)
+			continue;
+
+		seq_printf(seq, " function : %d\n", func);
+
+		switch (func) {
+		case 0:
+			print_amd_pci0(seq, dev);
+			break;
+		case 1:
+			print_amd_pci1(seq, dev);
+			break;
+		case 2:
+			print_amd_pci2(seq, dev);
+			break;
+		case 3:
+			print_amd_pci3(seq, dev);
+			break;
+		case 4:
+			print_amd_pci4(seq, dev);
+			break;
+		}
+	}
+}
+
+static void print_pci(void *arg)
+{
+	struct seq_file *seq = arg;
+
+	seq_printf(seq, " PCI configuration regsiters :\n");
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		print_amd_pci(seq);
+		break;
+	default:
+		return;
+	}
+}
+
 static int cpu_seq_show(struct seq_file *seq, void *v)
 {
 	struct cpu_private *priv = seq->private;
@@ -450,6 +632,13 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 	case CPU_DT:
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
+	case CPU_PCI:
+		if (priv->file == CPU_INDEX)
+			smp_call_function_single(priv->cpu, print_pci, seq, 1);
+		else
+			smp_call_function_single(priv->cpu, print_pcival,
+						 seq, 1);
+		break;
 	case CPU_DEBUG:
 		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_dr, seq, 1);
@@ -469,6 +658,9 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 	default:
 		if (priv->cat == CPU_REG_MSR)
 			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		else if (priv->cat == CPU_REG_PCI)
+			smp_call_function_single(priv->cpu, print_pcival,
+						 seq, 1);
 		break;
 	}
 	seq_printf(seq, "\n");
@@ -695,6 +887,86 @@ static void cpu_init_apic(unsigned cpu, struct dentry *dentry)
 #endif
 }
 
+#define INIT_AMD_PCI(func) \
+static void init_amd_pci##func(unsigned cpu, struct dentry *dentry, 	\
+				struct pci_dev *dev)			\
+{									\
+	struct dentry *cdentry;						\
+	unsigned int reg, i, id;					\
+	char reg_dir[10];						\
+	u32 data;							\
+									\
+	for (i = 0; i < ARRAY_SIZE(cpu_amd_pci##func); i++) {		\
+		for (reg = cpu_amd_pci##func[i].min;			\
+		     reg <= cpu_amd_pci##func[i].max; reg++) {		\
+			if (!pci_read_config_dword(dev, reg, &data)) {	\
+				sprintf(reg_dir, "PCI%d_%03x",		\
+					func, reg);			\
+				id = cpu_amd_pci##func[i].flag;		\
+				cdentry = debugfs_create_dir(reg_dir,	\
+					per_cpu(cpu_arr[id].dentry, cpu)); \
+				cpu_create_file(cpu, 			\
+						cpu_amd_pci##func[i].flag, \
+						(func << 16) | reg,	\
+						CPU_VALUE, CPU_REG_PCI, \
+						cdentry);		\
+			}						\
+		}							\
+	}								\
+}
+
+/* AMD supports five functions, 0 through 4 */
+INIT_AMD_PCI(0)
+INIT_AMD_PCI(1)
+INIT_AMD_PCI(2)
+INIT_AMD_PCI(3)
+INIT_AMD_PCI(4)
+
+static void init_amd_pci(unsigned cpu, struct dentry *dentry)
+{
+	struct pci_dev *dev = NULL;
+	unsigned int func;
+
+	while ((dev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_ANY_ID, dev))
+	       != NULL) {
+		if ((dev->device >= 0x1100) && (dev->device < 0x2000)) {
+			func = dev->device & 0xff;
+			if (func >= MAX_CPU_PCI)
+				continue;
+
+			per_cpu(pci_arr[func], cpu) = dev;
+			switch (func) {
+			case 0:
+				init_amd_pci0(cpu, dentry, dev);
+				break;
+			case 1:
+				init_amd_pci1(cpu, dentry, dev);
+				break;
+			case 2:
+				init_amd_pci2(cpu, dentry, dev);
+				break;
+			case 3:
+				init_amd_pci3(cpu, dentry, dev);
+				break;
+			case 4:
+				init_amd_pci4(cpu, dentry, dev);
+				break;
+			}
+		}
+	}
+}
+
+static void cpu_init_pci(unsigned cpu, struct dentry *dentry)
+{
+	switch (boot_cpu_data.x86_vendor) {
+	case X86_VENDOR_AMD:
+		init_amd_pci(cpu, dentry);
+		break;
+	default:
+		return;
+	}
+}
+
 static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 {
 	struct dentry *cpu_dentry = NULL;
@@ -702,13 +974,17 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 	int err = 0;
 
 	for (type = 0; type <  ARRAY_SIZE(cpu_base) - 1; type++) {
-		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
-			continue;
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
+		/* check before preparing "state" file */
+		if (!is_typeflag_valid(cpu, cpu_base[type].flag))
+			continue;
+
 		if (type == CPU_APIC)
 			cpu_init_apic(cpu, cpu_dentry);
+		if (type == CPU_PCI)
+			cpu_init_pci(cpu, cpu_dentry);
 		if (type < CPU_TSS)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
-- 
1.6.0.6



