Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXC1ObH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXC1ObH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 10:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXC1ObH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 10:31:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXC1ObF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 10:31:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: Linux 2.6.21-rc5
Date: Wed, 28 Mar 2007 16:30:59 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <46096834.5050508@googlemail.com>
In-Reply-To: <46096834.5050508@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200703281630.59191.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 March 2007 20:53, Michal Piotrowski wrote:
> Linus Torvalds napisał(a):
> > There's various fixes here, ranging from some architecture updates (ia64, 
> > ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
> > 
> > And random one-liners.
> > 
> 
> I found this in mm snapshot
> http://www.ussg.iu.edu/hypermail/linux/kernel/0703.2/1367.html
> it's in mainline too.
> 
> Andi, any progress with this bug?

Can you test this patch please? 

-Andi

i386/x86-64: Convert nmi reservation to be global

It doesn't make much sense to have this per CPU, because all
the services using NMIs run on all CPUs. So make it global.

This also fixes a warning about unprotected use of smp_processor_id
on preemptible kernels.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/nmi.c
===================================================================
--- linux.orig/arch/i386/kernel/nmi.c
+++ linux/arch/i386/kernel/nmi.c
@@ -41,8 +41,8 @@ int nmi_watchdog_enabled;
  *   different subsystems this reservation system just tries to coordinate
  *   things a little
  */
-static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner);
-static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[3]);
+static unsigned long perfctr_nmi_owner;
+static unsigned long evntsel_nmi_owner[3];
 
 static cpumask_t backtrace_mask = CPU_MASK_NONE;
 
@@ -124,7 +124,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsig
 {
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
+	return (!test_bit(counter, &perfctr_nmi_owner));
 }
 
 /* checks the an msr for availability */
@@ -135,7 +135,7 @@ int avail_to_resrv_perfctr_nmi(unsigned 
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
+	return (!test_bit(counter, &perfctr_nmi_owner));
 }
 
 int reserve_perfctr_nmi(unsigned int msr)
@@ -145,7 +145,7 @@ int reserve_perfctr_nmi(unsigned int msr
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &__get_cpu_var(perfctr_nmi_owner)))
+	if (!test_and_set_bit(counter, &perfctr_nmi_owner))
 		return 1;
 	return 0;
 }
@@ -157,7 +157,7 @@ void release_perfctr_nmi(unsigned int ms
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &__get_cpu_var(perfctr_nmi_owner));
+	clear_bit(counter, &perfctr_nmi_owner);
 }
 
 int reserve_evntsel_nmi(unsigned int msr)
@@ -167,7 +167,7 @@ int reserve_evntsel_nmi(unsigned int msr
 	counter = nmi_evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &__get_cpu_var(evntsel_nmi_owner)[0]))
+	if (!test_and_set_bit(counter, &evntsel_nmi_owner[0]))
 		return 1;
 	return 0;
 }
@@ -179,7 +179,7 @@ void release_evntsel_nmi(unsigned int ms
 	counter = nmi_evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &__get_cpu_var(evntsel_nmi_owner)[0]);
+	clear_bit(counter, &evntsel_nmi_owner[0]);
 }
 
 static __cpuinit inline int nmi_known_cpu(void)
Index: linux/arch/x86_64/kernel/nmi.c
===================================================================
--- linux.orig/arch/x86_64/kernel/nmi.c
+++ linux/arch/x86_64/kernel/nmi.c
@@ -39,8 +39,8 @@ int panic_on_unrecovered_nmi;
  *   different subsystems this reservation system just tries to coordinate
  *   things a little
  */
-static DEFINE_PER_CPU(unsigned, perfctr_nmi_owner);
-static DEFINE_PER_CPU(unsigned, evntsel_nmi_owner[2]);
+static unsigned perfctr_nmi_owner;
+static unsigned evntsel_nmi_owner[2];
 
 static cpumask_t backtrace_mask = CPU_MASK_NONE;
 
@@ -110,7 +110,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsig
 {
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
+	return (!test_bit(counter, &perfctr_nmi_owner));
 }
 
 /* checks the an msr for availability */
@@ -121,7 +121,7 @@ int avail_to_resrv_perfctr_nmi(unsigned 
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	return (!test_bit(counter, &__get_cpu_var(perfctr_nmi_owner)));
+	return (!test_bit(counter, &perfctr_nmi_owner));
 }
 
 int reserve_perfctr_nmi(unsigned int msr)
@@ -131,7 +131,7 @@ int reserve_perfctr_nmi(unsigned int msr
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &__get_cpu_var(perfctr_nmi_owner)))
+	if (!test_and_set_bit(counter, &perfctr_nmi_owner))
 		return 1;
 	return 0;
 }
@@ -143,7 +143,7 @@ void release_perfctr_nmi(unsigned int ms
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &__get_cpu_var(perfctr_nmi_owner));
+	clear_bit(counter, &perfctr_nmi_owner);
 }
 
 int reserve_evntsel_nmi(unsigned int msr)
@@ -153,7 +153,7 @@ int reserve_evntsel_nmi(unsigned int msr
 	counter = nmi_evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &__get_cpu_var(evntsel_nmi_owner)))
+	if (!test_and_set_bit(counter, &evntsel_nmi_owner))
 		return 1;
 	return 0;
 }
@@ -165,7 +165,7 @@ void release_evntsel_nmi(unsigned int ms
 	counter = nmi_evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &__get_cpu_var(evntsel_nmi_owner));
+	clear_bit(counter, &evntsel_nmi_owner);
 }
 
 static __cpuinit inline int nmi_known_cpu(void)
