Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYDUUPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYDUUPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 16:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760699AbYDUUOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 16:14:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33353 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYDUUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:14:52 -0400
Date: Mon, 21 Apr 2008 22:14:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, tglx@linutronix.de,
       hpa@zytor.com, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080421201434.GN8770@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <20080421132705.GG6011@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421132705.GG6011@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Adrian Bunk <bunk@kernel.org> wrote:

> > +#ifndef CONFIG_X86_VOYAGER
> >  /* Bitmask of physically existing CPUs */
> >  physid_mask_t phys_cpu_present_map;
> > +#endif
> >...
> 
> Alexey noted that phys_cpu_present_map for Voyager and !Voyager also 
> have different types and suggested to make the Voyager one static 
> instead (additional renaming of the Voyager one also makes sense).

yep, done by the patch below.

	Ingo

------------>
Subject: x86: make phys_cpu_present_map static in Voyager
From: Alexey Starikovskiy <astarikovskiy@suse.de>
Date: Tue, 22 Apr 2008 00:03:14 +0400

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mach-voyager/voyager_smp.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
===================================================================
--- linux-x86.q.orig/arch/x86/mach-voyager/voyager_smp.c
+++ linux-x86.q/arch/x86/mach-voyager/voyager_smp.c
@@ -74,7 +74,7 @@ EXPORT_SYMBOL(cpu_online_map);
 
 /* Bitmask of CPUs present in the system - exported by i386_syms.c, used
  * by scheduler but indexed physically */
-cpumask_t phys_cpu_present_map = CPU_MASK_NONE;
+static cpumask_t voyager_phys_cpu_present_map = CPU_MASK_NONE;
 
 /* The internal functions */
 static void send_CPI(__u32 cpuset, __u8 cpi);
@@ -378,19 +378,19 @@ void __init find_smp_config(void)
 	/* set up everything for just this CPU, we can alter
 	 * this as we start the other CPUs later */
 	/* now get the CPU disposition from the extended CMOS */
-	cpus_addr(phys_cpu_present_map)[0] =
+	cpus_addr(voyager_phys_cpu_present_map)[0] =
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK);
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK + 1) << 8;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       2) << 16;
-	cpus_addr(phys_cpu_present_map)[0] |=
+	cpus_addr(voyager_phys_cpu_present_map)[0] |=
 	    voyager_extended_cmos_read(VOYAGER_PROCESSOR_PRESENT_MASK +
 				       3) << 24;
-	cpu_possible_map = phys_cpu_present_map;
-	printk("VOYAGER SMP: phys_cpu_present_map = 0x%lx\n",
-	       cpus_addr(phys_cpu_present_map)[0]);
+	cpu_possible_map = voyager_phys_cpu_present_map;
+	printk("VOYAGER SMP: voyager_phys_cpu_present_map = 0x%lx\n",
+	       cpus_addr(voyager_phys_cpu_present_map)[0]);
 	/* Here we set up the VIC to enable SMP */
 	/* enable the CPIs by writing the base vector to their register */
 	outb(VIC_DEFAULT_CPI_BASE, VIC_CPI_BASE_REGISTER);
@@ -649,15 +649,15 @@ void __init smp_boot_cpus(void)
 		/* now that the cat has probed the Voyager System Bus, sanity
 		 * check the cpu map */
 		if (((voyager_quad_processors | voyager_extended_vic_processors)
-		     & cpus_addr(phys_cpu_present_map)[0]) !=
-		    cpus_addr(phys_cpu_present_map)[0]) {
+		     & cpus_addr(voyager_phys_cpu_present_map)[0]) !=
+		    cpus_addr(voyager_phys_cpu_present_map)[0]) {
 			/* should panic */
 			printk("\n\n***WARNING*** "
 			       "Sanity check of CPU present map FAILED\n");
 		}
 	} else if (voyager_level == 4)
 		voyager_extended_vic_processors =
-		    cpus_addr(phys_cpu_present_map)[0];
+		    cpus_addr(voyager_phys_cpu_present_map)[0];
 
 	/* this sets up the idle task to run on the current cpu */
 	voyager_extended_cpus = 1;
@@ -689,7 +689,7 @@ void __init smp_boot_cpus(void)
 	/* loop over all the extended VIC CPUs and boot them.  The
 	 * Quad CPUs must be bootstrapped by their extended VIC cpu */
 	for (i = 0; i < NR_CPUS; i++) {
-		if (i == boot_cpu_id || !cpu_isset(i, phys_cpu_present_map))
+		if (i == boot_cpu_id || !cpu_isset(i, voyager_phys_cpu_present_map))
 			continue;
 		do_boot_cpu(i);
 		/* This udelay seems to be needed for the Quad boots
