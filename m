Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYG2M72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYG2M72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 08:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYG2M7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 08:59:20 -0400
Received: from www.tglx.de ([62.245.132.106]:40873 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbYG2M7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 08:59:19 -0400
Date: Tue, 29 Jul 2008 14:57:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Wolfgang Grandegger <wg@grandegger.com>, Carsten Emde <ce@ceag.ch>
Subject: Re: 2.6.24.7-rt16
In-Reply-To: <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
Message-ID: <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807271719130.574@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt17 tree, which can be
downloaded from the location:
  
   http://rt.et.redhat.com/download/
 
Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page
 
This is a bugfix update:
 
	- use the correct version of the ppc64 percpu patch
	  pointed out by Chirag Jog

to build a 2.6.24.7-rt17 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt17.bz2
 
And like always, Steven's RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3

As usual the broken out patches are also available.

Thanks,

	tglx

---

--- patches/series	2008-07-27 11:20:44.000000000 +0200
+++ patches/series	2008-07-29 14:28:39.000000000 +0200
@@ -1105,7 +1105,7 @@
 ftrace-preempt-trace-check.patch
 fix_SCHED_FIFO_spec_violation.patch
 
-ppc64-fix_preempt_unsafe_access_to_per_cpu_variables.patch
+ppc64-fix-preempt-unsafe-paths-accessing-per_cpu-variables.patch
 bz235099-idle-load-fix.patch
 
 raw-spinlocks-for-nmi-print.patch


Index: linux-2.6.24.7/arch/powerpc/mm/tlb_64.c
===================================================================
--- linux-2.6.24.7.orig/arch/powerpc/mm/tlb_64.c
+++ linux-2.6.24.7/arch/powerpc/mm/tlb_64.c
@@ -99,7 +99,6 @@ void pgtable_free_tlb(struct mmu_gather 
 	    cpus_equal(tlb->mm->cpu_vm_mask, local_cpumask)) {
 		pgtable_free(pgf);
 		goto cleanup;
-		return;
 	}
 
 	if (*batchp == NULL) {
@@ -107,7 +106,6 @@ void pgtable_free_tlb(struct mmu_gather 
 		if (*batchp == NULL) {
 			pgtable_free_now(pgf);
 			goto cleanup;
-			return;
 		}
 		(*batchp)->index = 0;
 	}
@@ -261,6 +259,7 @@ void pte_free_finish(void)
 		pte_free_submit(*batchp);
 		*batchp = NULL;
 	}
+
 	put_cpu_var_locked(pte_freelist_cur, cpu);
 }
 
Index: linux-2.6.24.7/arch/powerpc/platforms/pseries/iommu.c
===================================================================
--- linux-2.6.24.7.orig/arch/powerpc/platforms/pseries/iommu.c
+++ linux-2.6.24.7/arch/powerpc/platforms/pseries/iommu.c
@@ -155,7 +155,7 @@ static void tce_buildmulti_pSeriesLP(str
 						   uaddr, direction);
 		}
 
-		per_cpu_var_locked(tce_page, &cpu) = tcep;
+		per_cpu_var_locked(tce_page, cpu) = tcep;
 	}
 
 	rpn = (virt_to_abs(uaddr)) >> TCE_SHIFT;

