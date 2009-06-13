Return-Path: <linux-kernel-owner+w=401wt.eu-S933128AbZFMQj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128AbZFMQj5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932870AbZFMQjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:39:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:34591 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbZFMQjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:39:14 -0400
Subject: [RFC][PATCH 6/10 -tip] x86: cpu_debug make room for more cpu
 registers
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
In-Reply-To: <1244910701.11733.20.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
	 <1244910618.11733.18.camel@ht.satnam> <1244910655.11733.19.camel@ht.satnam>
	 <1244910701.11733.20.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:02:35 +0530
Message-Id: <1244910755.11733.21.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added Register category flags and define MSR_ for MSRs so that
we can add more cpu registers and distguish between them.

using name "state" do describe the state

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |    7 ++++
 arch/x86/kernel/cpu/cpu_debug.c  |   59 ++++++++++++++++++++++----------------
 2 files changed, 41 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index f2adad3..79710f2 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -57,6 +57,12 @@ enum cpu_file_bit {
 	CPU_VALUE,				/* value		*/
 };
 
+/* Register category flags */
+enum cpu_cat_bit {
+	CPU_REG_STD,				/* Standard registers	*/
+	CPU_REG_MSR,				/* MSRs			*/
+};
+
 #define MAX_CPU_FILES		512
 
 struct cpu_private {
@@ -64,6 +70,7 @@ struct cpu_private {
 	unsigned		type;
 	unsigned		reg;
 	unsigned		file;
+	unsigned		cat;
 };
 
 struct cpu_debug_base {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 9435da4..b03245e 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -72,12 +72,12 @@ static struct cpu_debug_base cpu_base[] = {
 };
 
 static struct cpu_file_base cpu_file[] = {
-	{ "index",	CPU_REG_ALL,	0	},
+	{ "state",	CPU_REG_ALL,	0	},
 	{ "value",	CPU_REG_ALL,	1	},
 };
 
 /* CPU Registers Range */
-static struct cpu_debug_range cpu_reg_range[] = {
+static struct cpu_debug_range cpu_msr_range[] = {
 	{ 0x00000000, 0x00000001, CPU_MC,	},
 	{ 0x00000006, 0x00000007, CPU_MONITOR,	},
 	{ 0x00000010, 0x00000010, CPU_TIME,	},
@@ -176,6 +176,7 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0xC0011030, 0xC001103A, CPU_IBS,	},
 };
 
+/* Check validity of cpu debug flag */
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
 	int i;
@@ -184,8 +185,9 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 	if (flag >= CPU_TSS)
 		return 1;
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (cpu_reg_range[i].flag == flag)
+	/* check MSR range */
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (cpu_msr_range[i].flag == flag)
 			return 1;
 	}
 
@@ -193,12 +195,13 @@ static int is_typeflag_valid(unsigned cpu, unsigned flag)
 	return 0;
 }
 
-static unsigned get_cpu_range(unsigned cpu, unsigned *min, unsigned *max,
+/* get MSR range */
+static unsigned get_msr_range(unsigned cpu, unsigned *min, unsigned *max,
 			      int index, unsigned flag)
 {
-	if (cpu_reg_range[index].flag == flag) {
-		*min = cpu_reg_range[index].min;
-		*max = cpu_reg_range[index].max;
+	if (cpu_msr_range[index].flag == flag) {
+		*min = cpu_msr_range[index].min;
+		*max = cpu_msr_range[index].max;
 	} else
 		*max = 0;
 
@@ -239,11 +242,12 @@ static void print_msr(struct seq_file *seq, unsigned cpu, unsigned flag)
 					       &low, &high))
 				print_cpu_data(seq, priv->reg, low, high);
 			return;
-		}
+		} else
+			seq_printf(seq, " MSR\t:\n");
 	}
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &msr_min, &msr_max, i, flag))
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (!get_msr_range(cpu, &msr_min, &msr_max, i, flag))
 			continue;
 
 		for (msr = msr_min; msr <= msr_max; msr++) {
@@ -352,7 +356,7 @@ static void print_dr(void *arg)
 		seq_printf(seq, " dr%d\t: %016lx\n", i, dr);
 	}
 
-	seq_printf(seq, "\n MSR\t:\n");
+	seq_printf(seq, "\n");
 }
 
 static void print_apic(void *arg)
@@ -395,8 +399,8 @@ static void print_apic(void *arg)
 			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
 		}
 	}
+	seq_printf(seq, "\n");
 #endif /* CONFIG_X86_LOCAL_APIC */
-	seq_printf(seq, "\n MSR\t:\n");
 }
 
 static int cpu_seq_show(struct seq_file *seq, void *v)
@@ -419,16 +423,19 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 	case CPU_DEBUG:
 		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_dr, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	case CPU_APIC:
 		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 
 	default:
-		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		if (priv->cat == CPU_REG_MSR)
+			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	}
 	seq_printf(seq, "\n");
@@ -538,7 +545,7 @@ static const struct file_operations cpu_fops = {
 };
 
 static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
-			   unsigned file, struct dentry *dentry)
+			   unsigned file, unsigned cat, struct dentry *dentry)
 {
 	struct cpu_private *priv = NULL;
 
@@ -555,6 +562,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 	priv->type = type;
 	priv->reg = reg;
 	priv->file = file;
+	priv->cat = cat;
 	mutex_lock(&cpu_debug_lock);
 	per_cpu(priv_arr[type], cpu) = priv;
 	per_cpu(cpu_priv_count, cpu)++;
@@ -564,7 +572,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 		debugfs_create_file(cpu_file[file].name, S_IRUGO,
 				    dentry, (void *)priv, &cpu_fops);
 	else {
-		debugfs_create_file(cpu_base[type].name, S_IRUGO,
+		debugfs_create_file(cpu_file[file].name, S_IRUGO,
 				    per_cpu(cpu_arr[type].dentry, cpu),
 				    (void *)priv, &cpu_fops);
 		mutex_lock(&cpu_debug_lock);
@@ -576,13 +584,13 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 }
 
 static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
-			     struct dentry *dentry)
+			     unsigned cat, struct dentry *dentry)
 {
 	unsigned file;
 	int err = 0;
 
 	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
-		err = cpu_create_file(cpu, type, reg, file, dentry);
+		err = cpu_create_file(cpu, type, reg, file, cat, dentry);
 		if (err)
 			return err;
 	}
@@ -598,8 +606,8 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 	char reg_dir[12];
 	u32 low, high;
 
-	for (i = 0; i < ARRAY_SIZE(cpu_reg_range); i++) {
-		if (!get_cpu_range(cpu, &reg_min, &reg_max, i,
+	for (i = 0; i < ARRAY_SIZE(cpu_msr_range); i++) {
+		if (!get_msr_range(cpu, &reg_min, &reg_max, i,
 				   cpu_base[type].flag))
 			continue;
 
@@ -607,9 +615,10 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 			if (rdmsr_safe_on_cpu(cpu, reg, &low, &high))
 				continue;
 
-			sprintf(reg_dir, "0x%x", reg);
+			sprintf(reg_dir, "MSR_%x", reg);
 			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
-			err = cpu_init_regfiles(cpu, type, reg, cpu_dentry);
+			err = cpu_init_regfiles(cpu, type, reg, CPU_REG_MSR,
+						cpu_dentry);
 			if (err)
 				return err;
 		}
@@ -634,7 +643,7 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
 			err = cpu_create_file(cpu, type, 0, CPU_INDEX,
-					      cpu_dentry);
+					      CPU_REG_STD, cpu_dentry);
 		if (err)
 			return err;
 	}
-- 
1.6.0.6



