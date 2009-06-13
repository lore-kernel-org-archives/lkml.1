Return-Path: <linux-kernel-owner+w=401wt.eu-S933250AbZFMQl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250AbZFMQl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933255AbZFMQkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:40:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:34658 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbZFMQkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:40:12 -0400
Subject: [RFC][PATCH 10/10 -tip] x86: cpu_debug display basic cpuinfo
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
In-Reply-To: <1244910900.11733.24.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
	 <1244910618.11733.18.camel@ht.satnam> <1244910655.11733.19.camel@ht.satnam>
	 <1244910701.11733.20.camel@ht.satnam> <1244910755.11733.21.camel@ht.satnam>
	 <1244910798.11733.22.camel@ht.satnam> <1244910861.11733.23.camel@ht.satnam>
	 <1244910900.11733.24.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:05:41 +0530
Message-Id: <1244910941.11733.25.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for display struct cpuinfo_x86

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |    1 +
 arch/x86/kernel/cpu/cpu_debug.c  |   89 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index 377f658..b75758e 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -51,6 +51,7 @@ enum cpu_debug_bit {
 	CPU_CR,					/* Control Registers	*/
 	CPU_DT,					/* Descriptor Table	*/
 	CPU_CPUID,				/* CPUID		*/
+	CPU_CPUINFO,				/* struct cpuinfo_x86	*/
 	CPU_PCI,				/* PCI configuration	*/
 /* End of Registers flags						*/
 	CPU_REG_MAX,				/* Max Registers flags	*/
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index f7f702e..993a5bc 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -26,6 +26,11 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
+#ifdef MODULE
+#include "capflags.c"
+#include "powerflags.c"
+#endif
+
 static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_MAX]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(struct pci_dev *, pci_arr[MAX_CPU_PCI]);
@@ -76,6 +81,7 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "cr",		CPU_CR,		0	},
 	{ "dt",		CPU_DT,		0	},
 	{ "cpuid",	CPU_CPUID,	0	},
+	{ "cpuinfo",	CPU_CPUINFO,	0	},
 	{ "pci",	CPU_PCI,	0	},
 	{ "registers",	CPU_REG_ALL,	0	},
 };
@@ -568,6 +574,86 @@ static void print_cpuid(void *arg)
 		print_cpuidabcd(seq, (level & CPUID_MASK), level);
 }
 
+/* dump struct cpuinfo_x86 */
+static void print_cpuinfo(void *arg)
+{
+	struct seq_file *seq = arg;
+	struct cpu_private *priv = seq->private;
+	struct cpuinfo_x86 *cpui;
+	unsigned int i;
+
+	cpui = &cpu_data(priv->cpu);
+	seq_printf(seq, " CPUINFO\t:\n");
+	seq_printf(seq, " processor\t\t: %u\n", priv->cpu);
+
+	seq_printf(seq, " family\t\t\t: %u\n", cpui->x86);
+	seq_printf(seq, " vendor\t\t\t: %u\n", cpui->x86_vendor);
+	seq_printf(seq, " model\t\t\t: %u\n", cpui->x86_model);
+	seq_printf(seq, " mask\t\t\t: %u\n", cpui->x86_mask);
+#ifdef CONFIG_X86_32
+	seq_printf(seq, " wp_works_ok\t\t: %u\n", cpui->wp_works_ok);
+	seq_printf(seq, " halt_works_ok\t\t: %u\n", cpui->hlt_works_ok);
+	seq_printf(seq, " hard_math\t\t: %u\n", cpui->hard_math);
+	seq_printf(seq, " rfu\t\t\t: %u\n", cpui->rfu);
+	seq_printf(seq, " fdiv_bug\t\t: %u\n", cpui->fdiv_bug);
+	seq_printf(seq, " f00f_bug\t\t: %u\n", cpui->f00f_bug);
+	seq_printf(seq, " coma_bug\t\t: %u\n", cpui->coma_bug);
+#else
+	seq_printf(seq, " TLB size\t\t: %d 4K pages\n", cpui->x86_tlbsize);
+#endif
+	seq_printf(seq, " virtual bits\t\t: %u\n", cpui->x86_virt_bits);
+	seq_printf(seq, " physical bits\t\t: %u\n", cpui->x86_phys_bits);
+
+	seq_printf(seq, " extended cpuid level\t: %08x (%08x)\n",
+		   cpui->extended_cpuid_level, get_extended_cpuid());
+	seq_printf(seq, " cpuid level\t\t: %d\n", cpui->cpuid_level);
+
+	seq_printf(seq, " flags\t\t\t:");
+	for (i = 0; i < 32 * NCAPINTS; i++)
+		if (cpu_has(cpui, i) && x86_cap_flags[i] != NULL)
+			seq_printf(seq, " %s", x86_cap_flags[i]);
+
+	seq_printf(seq, "\n vendor id\t\t: %s\n",
+		   cpui->x86_vendor_id[0] ? cpui->x86_vendor_id : "unknown");
+	seq_printf(seq, " model id\t\t: %s\n",
+		   cpui->x86_model_id[0] ? cpui->x86_model_id : "unknown");
+
+	seq_printf(seq, " cache size\t\t: %d KB\n", cpui->x86_cache_size);
+	seq_printf(seq, " cache alignment\t: %d\n", cpui->x86_cache_alignment);
+
+	seq_printf(seq, " power management\t:");
+	for (i = 0; i < 32; i++) {
+		if (cpui->x86_power & (1 << i)) {
+			if (i < ARRAY_SIZE(x86_power_flags) &&
+			    x86_power_flags[i])
+				seq_printf(seq, "%s%s",
+					   x86_power_flags[i][0] ? " " : "",
+					   x86_power_flags[i]);
+			else
+				seq_printf(seq, " [%d]", i);
+		}
+	}
+
+	seq_printf(seq, "\n loops per jiffy\t: %lu\n", cpui->loops_per_jiffy);
+	seq_printf(seq, " bogomips\t\t: %lu.%02lu\n",
+		   cpui->loops_per_jiffy/(500000/HZ),
+		   (cpui->loops_per_jiffy/(5000/HZ)) % 100);
+
+	seq_printf(seq, " max cores\t\t: %d\n", cpui->x86_max_cores);
+	seq_printf(seq, " apic id\t\t: %d\n", cpui->apicid);
+	seq_printf(seq, " intial apic id\t\t: %d\n", cpui->initial_apicid);
+	seq_printf(seq, " clflush size\t\t: %u\n", cpui->x86_clflush_size);
+
+#ifdef CONFIG_SMP
+	seq_printf(seq, " cpu cores\t\t: %d\n", cpui->booted_cores);
+	seq_printf(seq, " physical id\t\t: %d\n", cpui->phys_proc_id);
+	seq_printf(seq, " core id\t\t: %d\n", cpui->cpu_core_id);
+	seq_printf(seq, " cpu index\t\t: %d\n", cpui->cpu_index);
+#endif
+
+	seq_printf(seq, " hyper vendor\t\t: %d\n", cpui->x86_hyper_vendor);
+}
+
 static void print_apicval(void *arg)
 {
 	struct seq_file *seq = arg;
@@ -690,6 +776,9 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 			smp_call_function_single(priv->cpu, print_pcival,
 						 seq, 1);
 		break;
+	case CPU_CPUINFO:
+		smp_call_function_single(priv->cpu, print_cpuinfo, seq, 1);
+		break;
 	case CPU_PCI:
 		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_pci, seq, 1);
-- 
1.6.0.6



