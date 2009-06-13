Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbZFMQkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbZFMQkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763745AbZFMQjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:39:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34605 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932973AbZFMQjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:39:24 -0400
Subject: [RFC][PATCH 7/10 -tip] x86: cpu_debug support APIC_register_name
 with directory structure
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
In-Reply-To: <1244910755.11733.21.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
	 <1244910618.11733.18.camel@ht.satnam> <1244910655.11733.19.camel@ht.satnam>
	 <1244910701.11733.20.camel@ht.satnam> <1244910755.11733.21.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:03:18 +0530
Message-Id: <1244910798.11733.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added Register category flags and define APIC_ for APIC registers
so that we can distguish between them.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |    1 +
 arch/x86/kernel/cpu/cpu_debug.c  |  132 +++++++++++++++++++++++++++++---------
 2 files changed, 102 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 79710f2..fd20da7 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -61,6 +61,7 @@ enum cpu_file_bit {
 enum cpu_cat_bit {
 	CPU_REG_STD,				/* Standard registers	*/
 	CPU_REG_MSR,				/* MSRs			*/
+	CPU_REG_APIC,				/* APIC registers	*/
 };
 
 #define MAX_CPU_FILES		512
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index b03245e..fcfd22f 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -71,6 +71,37 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "registers",	CPU_REG_ALL,	0	},
 };
 
+#ifdef CONFIG_X86_LOCAL_APIC
+static struct cpu_debug_base cpu_apic[] = {
+	{ "ID",		APIC_ID,	0	},
+	{ "LVR",	APIC_LVR,	0	},
+	{ "TASKPRI",	APIC_TASKPRI,	0	},
+	{ "ARBPRI",	APIC_ARBPRI,	0	},
+	{ "PROCPRI",	APIC_PROCPRI,	0	},
+	{ "LDR",	APIC_LDR,	0	},
+	{ "DFR",	APIC_DFR,	0	},
+	{ "SPIV",	APIC_SPIV,	0	},
+	{ "ISR",	APIC_ISR,	0	},
+	{ "ESR",	APIC_ESR,	0	},
+	{ "ICR",	APIC_ICR,	0	},
+	{ "ICR2",	APIC_ICR2,	0	},
+	{ "LVTT",	APIC_LVTT,	0	},
+	{ "LVTTHMR",	APIC_LVTTHMR,	0	},
+	{ "LVTPC",	APIC_LVTPC,	0	},
+	{ "LVT0",	APIC_LVT0,	0	},
+	{ "LVT1",	APIC_LVT1,	0	},
+	{ "LVTERR",	APIC_LVTERR,	0	},
+	{ "TMICT",	APIC_TMICT,	0	},
+	{ "TMCCT",	APIC_TMCCT,	0	},
+	{ "TDCR",	APIC_TDCR,	0	},
+};
+
+static struct cpu_debug_base cpu_xapic[] = {
+	{ "EFEAT",	APIC_EFEAT,	0	},
+	{ "ECTRL",	APIC_ECTRL,	0	},
+};
+#endif
+
 static struct cpu_file_base cpu_file[] = {
 	{ "state",	CPU_REG_ALL,	0	},
 	{ "value",	CPU_REG_ALL,	1	},
@@ -364,43 +395,42 @@ static void print_apic(void *arg)
 	struct seq_file *seq = arg;
 
 #ifdef CONFIG_X86_LOCAL_APIC
+	unsigned int i;
+
 	seq_printf(seq, " LAPIC\t:\n");
-	seq_printf(seq, " ID\t\t: %08x\n",  apic_read(APIC_ID) >> 24);
-	seq_printf(seq, " LVR\t\t: %08x\n",  apic_read(APIC_LVR));
-	seq_printf(seq, " TASKPRI\t: %08x\n",  apic_read(APIC_TASKPRI));
-	seq_printf(seq, " ARBPRI\t\t: %08x\n",  apic_read(APIC_ARBPRI));
-	seq_printf(seq, " PROCPRI\t: %08x\n",  apic_read(APIC_PROCPRI));
-	seq_printf(seq, " LDR\t\t: %08x\n",  apic_read(APIC_LDR));
-	seq_printf(seq, " DFR\t\t: %08x\n",  apic_read(APIC_DFR));
-	seq_printf(seq, " SPIV\t\t: %08x\n",  apic_read(APIC_SPIV));
-	seq_printf(seq, " ISR\t\t: %08x\n",  apic_read(APIC_ISR));
-	seq_printf(seq, " ESR\t\t: %08x\n",  apic_read(APIC_ESR));
-	seq_printf(seq, " ICR\t\t: %08x\n",  apic_read(APIC_ICR));
-	seq_printf(seq, " ICR2\t\t: %08x\n",  apic_read(APIC_ICR2));
-	seq_printf(seq, " LVTT\t\t: %08x\n",  apic_read(APIC_LVTT));
-	seq_printf(seq, " LVTTHMR\t: %08x\n",  apic_read(APIC_LVTTHMR));
-	seq_printf(seq, " LVTPC\t\t: %08x\n",  apic_read(APIC_LVTPC));
-	seq_printf(seq, " LVT0\t\t: %08x\n",  apic_read(APIC_LVT0));
-	seq_printf(seq, " LVT1\t\t: %08x\n",  apic_read(APIC_LVT1));
-	seq_printf(seq, " LVTERR\t\t: %08x\n",  apic_read(APIC_LVTERR));
-	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
-	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
-	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
+	for (i = 0; i < ARRAY_SIZE(cpu_apic); i++) {
+		if (strlen(cpu_apic[i].name) < 7)
+			seq_printf(seq, " %s\t\t: %08x\n",  cpu_apic[i].name,
+				   apic_read(cpu_apic[i].flag));
+		else
+			seq_printf(seq, " %s\t: %08x\n",  cpu_apic[i].name,
+				   apic_read(cpu_apic[i].flag));
+	}
 	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
-		unsigned int i, v, maxeilvt;
+		unsigned int maxeilvt;
 
-		v = apic_read(APIC_EFEAT);
-		maxeilvt = (v >> 16) & 0xff;
-		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
-		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
+		for (i = 0; i < ARRAY_SIZE(cpu_xapic); i++)
+			seq_printf(seq, " %s\t\t: %08x\n",  cpu_xapic[i].name,
+				   apic_read(cpu_xapic[i].flag));
 
-		for (i = 0; i < maxeilvt; i++) {
-			v = apic_read(APIC_EILVTn(i));
-			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
-		}
+		maxeilvt = (apic_read(APIC_EFEAT) >> 16) & 0xff;
+		for (i = 0; i < maxeilvt; i++)
+			seq_printf(seq, " EILVT%d\t\t: %08x\n",
+				   i, apic_read(APIC_EILVTn(i)));
 	}
 	seq_printf(seq, "\n");
-#endif /* CONFIG_X86_LOCAL_APIC */
+#endif
+}
+
+static void print_apicval(void *arg)
+{
+	struct seq_file *seq = arg;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	struct cpu_private *priv = seq->private;
+
+	seq_printf(seq, "0x%x\n", apic_read(priv->reg));
+#endif
 }
 
 static int cpu_seq_show(struct seq_file *seq, void *v)
@@ -431,6 +461,9 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
 		if (priv->cat == CPU_REG_MSR)
 			print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
+		else if (priv->cat == CPU_REG_APIC)
+			smp_call_function_single(priv->cpu, print_apicval,
+						 seq, 1);
 		break;
 
 	default:
@@ -627,6 +660,41 @@ static int cpu_init_msr(unsigned cpu, unsigned type, struct dentry *dentry)
 	return err;
 }
 
+static void cpu_init_apic(unsigned cpu, struct dentry *dentry)
+{
+#ifdef CONFIG_X86_LOCAL_APIC
+	struct dentry *cpu_dentry;
+	char reg_dir[16];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(cpu_apic); i++) {
+		sprintf(reg_dir, "APIC_%s", cpu_apic[i].name);
+		cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+		cpu_create_file(cpu, CPU_APIC, cpu_apic[i].flag, CPU_VALUE,
+				CPU_REG_APIC, cpu_dentry);
+	}
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		unsigned int maxeilvt;
+
+		for (i = 0; i < ARRAY_SIZE(cpu_xapic); i++) {
+			sprintf(reg_dir, "APIC_%s", cpu_xapic[i].name);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			cpu_create_file(cpu, CPU_APIC, cpu_xapic[i].flag,
+					CPU_VALUE, CPU_REG_APIC, cpu_dentry);
+		}
+
+		maxeilvt = (apic_read(APIC_EFEAT) >> 16) & 0xff;
+		for (i = 0; i < maxeilvt; i++) {
+			sprintf(reg_dir, "APIC_EILVT%d", i);
+			cpu_dentry = debugfs_create_dir(reg_dir, dentry);
+			cpu_create_file(cpu, CPU_APIC, APIC_EILVTn(i),
+					CPU_VALUE, CPU_REG_APIC, cpu_dentry);
+		}
+	}
+#endif
+}
+
 static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 {
 	struct dentry *cpu_dentry = NULL;
@@ -639,6 +707,8 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
+		if (type == CPU_APIC)
+			cpu_init_apic(cpu, cpu_dentry);
 		if (type < CPU_TSS)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
-- 
1.6.0.6



