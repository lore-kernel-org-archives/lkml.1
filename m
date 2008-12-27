Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbYL0LZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbYL0LZc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 06:25:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYL0LZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 06:25:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYL0LZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 06:25:22 -0500
Date: Sat, 27 Dec 2008 12:24:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: Re: [BUG] next-20081216 - WARNING: at kernel/smp.c:333
	smp_call_function_mask
Message-ID: <20081227112450.GA24150@elte.hu>
References: <20081226102716.GA31450@uranus.ravnborg.org> <20081226152804.GB5100@linux.vnet.ibm.com> <20081226153318.GA4514@elte.hu> <20081226170452.GC5100@linux.vnet.ibm.com> <20081226181733.GA24439@elte.hu> <20081227071138.GA4530@linux.vnet.ibm.com> <4955DBBC.4070508@kernel.org> <20081227083758.GA12138@elte.hu> <20081227083936.GA12609@elte.hu> <20081227112125.GB4530@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227112125.GB4530@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2008-12-27 09:39:36]:
> 
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Yinghai Lu <yinghai@kernel.org> wrote:
> > > 
> > > > +extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
> > > 
> > > when you change a function declaration's return type, you _must_ double 
> > > check whether you properly updated all instances of that function. In 
> > > this case you forgot about the io_apic.c instance.
> > 
> > the corrected patch is below.
> > 
> > 	Ingo
> >
> 
> > --------------->
> > From d353c528bbb29be434f7688cba9b59781e9151e3 Mon Sep 17 00:00:00 2001
> > From: Yinghai Lu <yinghai@kernel.org>
> > Date: Fri, 26 Dec 2008 02:05:47 -0800
> > Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions
> > 
> > Impact: fix panic on null pointer with sparseirq
> > 
> > Some GCC versions seem to inline the weak global function,
> > when that function is empty.
> > 
> > Work it around, by making the functions return a (dummy) integer.
> > 
> > Signed-off-by: Yinghai <yinghai@kernel.org>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  arch/x86/kernel/io_apic.c |    6 ++++--
> >  include/linux/irq.h       |    6 +++---
> >  init/main.c               |    7 ++++---
> >  kernel/irq/handle.c       |    7 ++++---
> >  4 files changed, 15 insertions(+), 11 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
> > index 2fe543f..e4d4d19 100644
> > --- a/arch/x86/kernel/io_apic.c
> > +++ b/arch/x86/kernel/io_apic.c
> > @@ -170,7 +170,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
> >  	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
> >  };
> > 
> > -void __init arch_early_irq_init(void)
> > +int __init arch_early_irq_init(void)
> >  {
> >  	struct irq_cfg *cfg;
> >  	struct irq_desc *desc;
> > @@ -184,6 +184,8 @@ void __init arch_early_irq_init(void)
> >  		desc = irq_to_desc(i);
> >  		desc->chip_data = &cfg[i];
> >  	}
> > +
> > +	return 0;
> >  }
> > 
> >  #ifdef CONFIG_SPARSE_IRQ
> > @@ -212,7 +214,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
> >  	return cfg;
> >  }
> > 
> > -void arch_init_chip_data(struct irq_desc *desc, int cpu)
> > +int arch_init_chip_data(struct irq_desc *desc, int cpu)
> >  {
> >  	struct irq_cfg *cfg;
> 
> the return statement is missing in the patch.

yes, indeed - updated patch below.

	Ingo

--------------->
>From 03f20b9c3b659c191684cb93de66a20386711df4 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Fri, 26 Dec 2008 02:05:47 -0800
Subject: [PATCH] sparseirq: work around compiler optimizing away __weak functions

Impact: fix panic on null pointer with sparseirq

Some GCC versions seem to inline the weak global function,
when that function is empty.

Work it around, by making the functions return a (dummy) integer.

Signed-off-by: Yinghai <yinghai@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic.c |    8 ++++++--
 include/linux/irq.h       |    6 +++---
 init/main.c               |    7 ++++---
 kernel/irq/handle.c       |    7 ++++---
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 2fe543f..9760393 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -170,7 +170,7 @@ static struct irq_cfg irq_cfgx[NR_IRQS] = {
 	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
-void __init arch_early_irq_init(void)
+int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
 	struct irq_desc *desc;
@@ -184,6 +184,8 @@ void __init arch_early_irq_init(void)
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_SPARSE_IRQ
@@ -212,7 +214,7 @@ static struct irq_cfg *get_one_free_irq_cfg(int cpu)
 	return cfg;
 }
 
-void arch_init_chip_data(struct irq_desc *desc, int cpu)
+int arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
 	struct irq_cfg *cfg;
 
@@ -224,6 +226,8 @@ void arch_init_chip_data(struct irq_desc *desc, int cpu)
 			BUG_ON(1);
 		}
 	}
+
+	return 0;
 }
 
 #ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 69da275..0e40af4 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -193,9 +193,9 @@ struct irq_desc {
 	const char		*name;
 } ____cacheline_internodealigned_in_smp;
 
-extern void early_irq_init(void);
-extern void arch_early_irq_init(void);
-extern void arch_init_chip_data(struct irq_desc *desc, int cpu);
+extern int early_irq_init(void);
+extern int arch_early_irq_init(void);
+extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
 extern void arch_init_copy_chip_data(struct irq_desc *old_desc,
 					struct irq_desc *desc, int cpu);
 extern void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc);
diff --git a/init/main.c b/init/main.c
index c1f999a..b541c9a 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,13 +539,14 @@ void __init __weak thread_info_cache_init(void)
 {
 }
 
-void __init __weak arch_early_irq_init(void)
+int __init __weak arch_early_irq_init(void)
 {
+	return 0;
 }
 
-void __init __weak early_irq_init(void)
+int __init __weak early_irq_init(void)
 {
-	arch_early_irq_init();
+	return 0;
 }
 
 asmlinkage void __init start_kernel(void)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 893da67..0bef3ec 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -86,8 +86,9 @@ void init_kstat_irqs(struct irq_desc *desc, int cpu, int nr)
 		desc->kstat_irqs = (unsigned int *)ptr;
 }
 
-void __attribute__((weak)) arch_init_chip_data(struct irq_desc *desc, int cpu)
+int __weak arch_init_chip_data(struct irq_desc *desc, int cpu)
 {
+	return 0;
 }
 
 static void init_one_irq_desc(int irq, struct irq_desc *desc, int cpu)
@@ -132,7 +133,7 @@ static struct irq_desc irq_desc_legacy[NR_IRQS_LEGACY] __cacheline_aligned_in_sm
 /* FIXME: use bootmem alloc ...*/
 static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
 
-void __init early_irq_init(void)
+int __init early_irq_init(void)
 {
 	struct irq_desc *desc;
 	int legacy_count;
@@ -151,7 +152,7 @@ void __init early_irq_init(void)
 	for (i = legacy_count; i < NR_IRQS; i++)
 		irq_desc_ptrs[i] = NULL;
 
-	arch_early_irq_init();
+	return arch_early_irq_init();
 }
 
 struct irq_desc *irq_to_desc(unsigned int irq)
