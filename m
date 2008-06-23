Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYFWKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYFWKyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbYFWKyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:54:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbYFWKyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:54:12 -0400
Date: Mon, 23 Jun 2008 12:53:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/5] x86: use BOOTMEM_EXCLUSIVE on 32-bit
Message-ID: <20080623105358.GB28192@elte.hu>
References: <20080622185327.348377223@mini.kroah.org> <20080622190131.GB20141@suse.de> <87prq9dxst.fsf@skyscraper.fehenstaub.lan> <20080622203047.GC20800@suse.de> <alpine.LFD.1.10.0806221336010.2926@woody.linux-foundation.org> <20080623080940.GA23313@elte.hu> <20080623123344.0c16ed69@kopernikus.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623123344.0c16ed69@kopernikus.site>
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


* Bernhard Walle <bwalle@suse.de> wrote:

> * Ingo Molnar <mingo@elte.hu> [2008-06-23 10:09]:
> 
> > 
> > | commit 91d48fc80f22817332170082e10de60a75851640
> > | Author: Bernhard Walle <bwalle@suse.de>
> > | Date:   Sun Jun 8 15:46:29 2008 +0200
> > | CommitDate: Tue Jun 10 14:41:56 2008 +0200
> > |
> > |    bootmem: add return value to reserve_bootmem_node()
> > |
> > |    This patch changes the function reserve_bootmem_node() from void to
> > |    int, returning -ENOMEM if the allocation fails.
> > |
> > |    Signed-off-by: Bernhard Walle <bwalle@suse.de>
> > |    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > so it is a -stable candidate just as much as the kexec fix. (These are 
> > all fixes for long-standing problems so i guess it can go all the way 
> > back to all stable kernels that are being maintained.)
> 
> Ingo, 
> 
> shouldn't we add the reserve_bootmem_generic() fix [1] to 2.6.26-* at
> least?
> 
> 
> Bernhard
> 
> [1] 62b5ebe062c2801f6d40480ae3b91a64c8c8e6cb

but note that this too has dependencies, it relies on:

 # tip/x86/numa: ddeb8ef: x86: add flags parameter to reserve_bootmem_generic()
 # tip/x86/numa: 62b5ebe: x86: use reserve_bootmem_generic() to reserve crashkernel memory on x86_64

so i've initially delayed the whole topic to v2.6.27.

I've attached both patches below - are they really urgent enough to be 
propagated to tip/x86/urgent and be sent to Linus? AFAICS these are 
ancient issues with kernel crashdumping.

	Ingo

---------------------->
commit ddeb8ef812cbe41739ea3d836681005e9646f922
Author: Bernhard Walle <bwalle@suse.de>
Date:   Sun Jun 8 15:46:30 2008 +0200

    x86: add flags parameter to reserve_bootmem_generic()
    
    This patch adds a 'flags' parameter to reserve_bootmem_generic() like it
    already has been added in reserve_bootmem() with commit
    72a7fe3967dbf86cb34e24fbf1d957fe24d2f246.
    
    It also changes all users to use BOOTMEM_DEFAULT, which doesn't effectively
    change the behaviour. Since the change is x86-specific, I don't think it's
    necessary to add a new API for migration. There are only 4 users of that
    function.
    
    The change is necessary for the next patch, using reserve_bootmem_generic()
    for crashkernel reservation.
    
    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 404683b..4901ae3 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -729,10 +729,11 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 			if (!reserve)
 				return 1;
 
-			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE);
+			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
+				BOOTMEM_DEFAULT);
 			if (mpf->mpf_physptr)
 				reserve_bootmem_generic(mpf->mpf_physptr,
-							PAGE_SIZE);
+					PAGE_SIZE, BOOTMEM_DEFAULT);
 #endif
 		return 1;
 		}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 32ba13b..747c351 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -798,12 +798,13 @@ void free_initrd_mem(unsigned long start, unsigned long end)
 }
 #endif
 
-void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
+int __init reserve_bootmem_generic(unsigned long phys, unsigned len, int flags)
 {
 #ifdef CONFIG_NUMA
 	int nid, next_nid;
 #endif
 	unsigned long pfn = phys >> PAGE_SHIFT;
+	int ret;
 
 	if (pfn >= end_pfn) {
 		/*
@@ -811,11 +812,11 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 		 * firmware tables:
 		 */
 		if (pfn < max_pfn_mapped)
-			return;
+			return -EFAULT;
 
 		printk(KERN_ERR "reserve_bootmem: illegal reserve %lx %u\n",
 				phys, len);
-		return;
+		return -EFAULT;
 	}
 
 	/* Should check here against the e820 map to avoid double free */
@@ -823,9 +824,13 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 	nid = phys_to_nid(phys);
 	next_nid = phys_to_nid(phys + len - 1);
 	if (nid == next_nid)
-		reserve_bootmem_node(NODE_DATA(nid), phys, len, BOOTMEM_DEFAULT);
+		ret = reserve_bootmem_node(NODE_DATA(nid), phys, len, flags);
 	else
-		reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
+		ret = reserve_bootmem(phys, len, flags);
+
+	if (ret != 0)
+		return ret;
+
 #else
 	reserve_bootmem(phys, len, BOOTMEM_DEFAULT);
 #endif
@@ -834,6 +839,8 @@ void __init reserve_bootmem_generic(unsigned long phys, unsigned len)
 		dma_reserve += len / PAGE_SIZE;
 		set_dma_reserve(dma_reserve);
 	}
+
+	return 0;
 }
 
 int kern_addr_valid(unsigned long addr)
diff --git a/include/asm-x86/proto.h b/include/asm-x86/proto.h
index 6c8b41b..a9f5147 100644
--- a/include/asm-x86/proto.h
+++ b/include/asm-x86/proto.h
@@ -14,7 +14,7 @@ extern void ia32_syscall(void);
 extern void ia32_cstar_target(void);
 extern void ia32_sysenter_target(void);
 
-extern void reserve_bootmem_generic(unsigned long phys, unsigned len);
+extern int reserve_bootmem_generic(unsigned long phys, unsigned len, int flags);
 
 extern void syscall32_cpu_init(void);
 

--------------->
commit 62b5ebe062c2801f6d40480ae3b91a64c8c8e6cb
Author: Bernhard Walle <bwalle@suse.de>
Date:   Sun Jun 8 15:46:31 2008 +0200

    x86: use reserve_bootmem_generic() to reserve crashkernel memory on x86_64
    
    This patch uses reserve_bootmem_generic() instead of reserve_bootmem()
    to reserve the crashkernel memory on x86_64. That's necessary for NUMA
    machines, see 00212fef814612245ed0261cbac8426d0c9a31a5:
    
      [PATCH] Fix kdump Crash Kernel boot memory reservation for NUMA machines
    
      This patch will fix a boot memory reservation bug that trashes memory on
      the ES7000 when loading the kdump crash kernel.
    
      The code in arch/x86_64/kernel/setup.c to reserve boot memory for the crash
      kernel uses the non-numa aware "reserve_bootmem" function instead of the
      NUMA aware "reserve_bootmem_generic".  I checked to make sure that no other
      function was using "reserve_bootmem" and found none, except the ones that
      had NUMA ifdef'ed out.
    
      I have tested this patch only on an ES7000 with NUMA on and off (numa=off)
      in a single (non-NUMA) and multi-cell (NUMA) configurations.
    
      Signed-off-by: Amul Shah <amul.shah@unisys.com>
      Looks-good-to: Vivek Goyal <vgoyal@in.ibm.com>
      Cc: Andi Kleen <ak@muc.de>
      Signed-off-by: Andrew Morton <akpm@osdl.org>
      Signed-off-by: Linus Torvalds <torvalds@osdl.org>
    
    The switch-back to reserve_bootmem() was accidentally introduced in
    5c3391f9f749023a49c64d607da4fb49263690eb when adding the BOOTMEM_EXCLUSIVE
    parameter.
    
    Signed-off-by: Bernhard Walle <bwalle@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index e8df64f..4a666cd 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -243,7 +243,7 @@ static void __init reserve_crashkernel(void)
 			return;
 		}
 
-		if (reserve_bootmem(crash_base, crash_size,
+		if (reserve_bootmem_generic(crash_base, crash_size,
 					BOOTMEM_EXCLUSIVE) < 0) {
 			printk(KERN_INFO "crashkernel reservation failed - "
 					"memory is in use\n");
