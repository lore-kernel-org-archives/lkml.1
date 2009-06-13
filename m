Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZFMS0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZFMS0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 14:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZFMS0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 14:26:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47269 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926AbZFMS0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 14:26:46 -0400
Subject: Re: [RFC][PATCH 9/10 -tip] x86: cpu_debug display cpuid functions
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: lkml@morethan.org
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <200906131253.59412.lkml@morethan.org>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910861.11733.23.camel@ht.satnam> <1244910900.11733.24.camel@ht.satnam>
	 <200906131253.59412.lkml@morethan.org>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 23:55:26 +0530
Message-Id: <1244917526.11733.28.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 12:53 -0500, Michael S. Zick wrote:
> On Sat June 13 2009, Jaswinder Singh Rajput wrote:
> > 
> > Add support for cpuid standard and extended functions
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/include/asm/cpu_debug.h |    4 ++-
> >  arch/x86/kernel/cpu/cpu_debug.c  |   64 ++++++++++++++++++++++++++++++++++++--
> >  2 files changed, 64 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
> > index dc24338..377f658 100644
> > --- a/arch/x86/include/asm/cpu_debug.h
> > +++ b/arch/x86/include/asm/cpu_debug.h
> > @@ -46,11 +46,11 @@ enum cpu_debug_bit {
> >  	CPU_MMIO,				/* Memory based IO	*/
> >  	CPU_DISPLAY,				/* Display/VGA		*/
> >  	CPU_LINK,				/* HyperTransport	*/
> > -	CPU_CPUID,				/* CPUID		*/
> >  /* Standard Registers							*/
> >  	CPU_TSS,				/* Task Stack Segment	*/
> >  	CPU_CR,					/* Control Registers	*/
> >  	CPU_DT,					/* Descriptor Table	*/
> > +	CPU_CPUID,				/* CPUID		*/
> >  	CPU_PCI,				/* PCI configuration	*/
> >  /* End of Registers flags						*/
> >  	CPU_REG_MAX,				/* Max Registers flags	*/
> > @@ -75,6 +75,8 @@ enum cpu_cat_bit {
> >  #define MAX_CPU_FILES		768		/* Max CPU debug files	*/
> >  #define MAX_CPU_PCI		5		/* AMD supports func 0-4*/
> >  
> > +#define CPUID_MASK		0xffff0000
> > +
> >  struct cpu_private {
> >  	unsigned		cpu;
> >  	unsigned		type;
> > diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> > index b4dfddd..f7f702e 100644
> > --- a/arch/x86/kernel/cpu/cpu_debug.c
> > +++ b/arch/x86/kernel/cpu/cpu_debug.c
> > @@ -72,10 +72,10 @@ static struct cpu_debug_base cpu_base[] = {
> >  	{ "mmio",	CPU_MMIO,	0	},
> >  	{ "display",	CPU_DISPLAY,	0	},
> >  	{ "link",	CPU_LINK,	0	},
> > -	{ "cpuid",	CPU_CPUID,	0	},
> >  	{ "tss",	CPU_TSS,	0	},
> >  	{ "cr",		CPU_CR,		0	},
> >  	{ "dt",		CPU_DT,		0	},
> > +	{ "cpuid",	CPU_CPUID,	0	},
> >  	{ "pci",	CPU_PCI,	0	},
> >  	{ "registers",	CPU_REG_ALL,	0	},
> >  };
> > @@ -303,6 +303,13 @@ static struct cpu_debug_range cpu_amd_pci4[] = {
> >  	{ 0x1E0,	0x1F0,	CPU_POWER	},
> >  };
> >  
> > +/* Extended CPUID base address			*/
> > +static u32 cpu_ext_cpuid[] = {
> > +	0x80000000,		/* Intel, AMD	*/
> > +	0x80860000,		/* Transmeta	*/
> > +	0xC0000000,		/* Centaur	*/
> >
> 
> VIA/Centaur has both 0xC0000000 and 0x8000000
> 

hmm, then this patch will work for multiple extended cpuid levels :

[PATCH 9/10 -tip] x86: cpu_debug display cpuid functions

Add support for cpuid standard and extended functions

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |    4 ++-
 arch/x86/kernel/cpu/cpu_debug.c  |   52 +++++++++++++++++++++++++++++++++++--
 2 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index dc24338..377f658 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -46,11 +46,11 @@ enum cpu_debug_bit {
 	CPU_MMIO,				/* Memory based IO	*/
 	CPU_DISPLAY,				/* Display/VGA		*/
 	CPU_LINK,				/* HyperTransport	*/
-	CPU_CPUID,				/* CPUID		*/
 /* Standard Registers							*/
 	CPU_TSS,				/* Task Stack Segment	*/
 	CPU_CR,					/* Control Registers	*/
 	CPU_DT,					/* Descriptor Table	*/
+	CPU_CPUID,				/* CPUID		*/
 	CPU_PCI,				/* PCI configuration	*/
 /* End of Registers flags						*/
 	CPU_REG_MAX,				/* Max Registers flags	*/
@@ -75,6 +75,8 @@ enum cpu_cat_bit {
 #define MAX_CPU_FILES		768		/* Max CPU debug files	*/
 #define MAX_CPU_PCI		5		/* AMD supports func 0-4*/
 
+#define CPUID_MASK		0xffff0000
+
 struct cpu_private {
 	unsigned		cpu;
 	unsigned		type;
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index b4dfddd..4d881a3 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -72,10 +72,10 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "mmio",	CPU_MMIO,	0	},
 	{ "display",	CPU_DISPLAY,	0	},
 	{ "link",	CPU_LINK,	0	},
-	{ "cpuid",	CPU_CPUID,	0	},
 	{ "tss",	CPU_TSS,	0	},
 	{ "cr",		CPU_CR,		0	},
 	{ "dt",		CPU_DT,		0	},
+	{ "cpuid",	CPU_CPUID,	0	},
 	{ "pci",	CPU_PCI,	0	},
 	{ "registers",	CPU_REG_ALL,	0	},
 };
@@ -303,6 +303,13 @@ static struct cpu_debug_range cpu_amd_pci4[] = {
 	{ 0x1E0,	0x1F0,	CPU_POWER	},
 };
 
+/* Extended CPUID base address			*/
+static u32 cpu_ext_cpuid[] = {
+	0x80000000,		/* Intel, AMD	*/
+	0x80860000,		/* Transmeta	*/
+	0xC0000000,		/* Centaur	*/
+};
+
 /* Check validity of cpu debug flag */
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
 {
@@ -518,6 +525,37 @@ static void print_apic(void *arg)
 #endif
 }
 
+static void print_cpuidabcd(struct seq_file *seq, u32 min, u32 max)
+{
+	u32 i, eax, ebx, ecx, edx;
+
+	for (i = min; i <= max; i++) {
+		cpuid(i, &eax, &ebx, &ecx, &edx);
+		seq_printf(seq, " %08x  %08x  %08x  %08x  %08x\n",
+			   i, eax, ebx, ecx, edx);
+	}
+}
+
+static void print_cpuid(void *arg)
+{
+	struct seq_file *seq = arg;
+	u32 i, level;
+
+	seq_printf(seq, " CPUID\t:\n");
+	seq_printf(seq, "              eax       ebx       ecx       edx\n");
+
+	/* Standard CPUID functions */
+	level = cpuid_eax(0);
+	print_cpuidabcd(seq, 0, level);
+
+	/* Extended CPUID functions */
+	for (i = 0; i < ARRAY_SIZE(cpu_ext_cpuid); i++) {
+		level = cpuid_eax(cpu_ext_cpuid[i]);
+		if ((level & CPUID_MASK) == cpu_ext_cpuid[i])
+			print_cpuidabcd(seq, cpu_ext_cpuid[i], level);
+	}
+}
+
 static void print_apicval(void *arg)
 {
 	struct seq_file *seq = arg;
@@ -632,6 +670,14 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 	case CPU_DT:
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
+	case CPU_CPUID:
+		if (priv->file == CPU_INDEX)
+			smp_call_function_single(priv->cpu, print_cpuid,
+						 seq, 1);
+		else
+			smp_call_function_single(priv->cpu, print_pcival,
+						 seq, 1);
+		break;
 	case CPU_PCI:
 		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_pci, seq, 1);
@@ -814,7 +860,7 @@ static int cpu_init_regfiles(unsigned cpu, unsigned int type, unsigned reg,
 	unsigned file;
 	int err = 0;
 
-	for (file = 0; file <  ARRAY_SIZE(cpu_file); file++) {
+	for (file = 0; file < ARRAY_SIZE(cpu_file); file++) {
 		err = cpu_create_file(cpu, type, reg, file, cat, dentry);
 		if (err)
 			return err;
@@ -973,7 +1019,7 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 	unsigned type;
 	int err = 0;
 
-	for (type = 0; type <  ARRAY_SIZE(cpu_base) - 1; type++) {
+	for (type = 0; type < ARRAY_SIZE(cpu_base) - 1; type++) {
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
-- 
1.6.0.6



