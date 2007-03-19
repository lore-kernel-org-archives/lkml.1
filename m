Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXCSVm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXCSVm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXCSVm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:42:26 -0400
Received: from ns.suse.de ([195.135.220.2]:55915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030624AbXCSVmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:42:14 -0400
Date: Mon, 19 Mar 2007 14:40:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 23/31] Fix page allocation debugging on sparc64
Message-ID: <20070319214025.GY9261@kroah.com>
References: <20070319213047.710101653@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-page-allocation-debugging-on-sparc64.patch"
In-Reply-To: <20070319213647.GB9261@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Miller <davem@davemloft.net>

[SPARC64]: Get DEBUG_PAGEALLOC working again.

We have to make sure to use base-pagesize TLB entries even during the
early transition period where we need TLB miss handling but don't have
the kernel page tables setup yet for the linear region.

Also, it is necessary therefore to not use the 4MB TSB for these
translations, and instead use the normal kernel TSB.  This allows us
to also get rid of the 4MB tsb for debug builds which shrinks the
kernel a little bit.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/ktlb.S |    8 +++++++-
 arch/sparc64/mm/init.c     |   30 ++++++++++++++++++++++++++++--
 include/asm-sparc64/tsb.h  |    2 ++
 3 files changed, 37 insertions(+), 3 deletions(-)

--- a/arch/sparc64/kernel/ktlb.S
+++ b/arch/sparc64/kernel/ktlb.S
@@ -138,9 +138,15 @@ kvmap_dtlb_4v:
 	brgez,pn	%g4, kvmap_dtlb_nonlinear
 	 nop
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	/* Index through the base page size TSB even for linear
+	 * mappings when using page allocation debugging.
+	 */
+	KERN_TSB_LOOKUP_TL1(%g4, %g6, %g5, %g1, %g2, %g3, kvmap_dtlb_load)
+#else
 	/* Correct TAG_TARGET is already in %g6, check 4mb TSB.  */
 	KERN_TSB4M_LOOKUP_TL1(%g6, %g5, %g1, %g2, %g3, kvmap_dtlb_load)
-
+#endif
 	/* TSB entry address left in %g1, lookup linear PTE.
 	 * Must preserve %g1 and %g6 (TAG).
 	 */
--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -59,8 +59,10 @@ unsigned long kern_linear_pte_xor[2] __r
  */
 unsigned long kpte_linear_bitmap[KPTE_BITMAP_BYTES / sizeof(unsigned long)];
 
+#ifndef CONFIG_DEBUG_PAGEALLOC
 /* A special kernel TSB for 4MB and 256MB linear mappings.  */
 struct tsb swapper_4m_tsb[KERNEL_TSB4M_NENTRIES];
+#endif
 
 #define MAX_BANKS	32
 
@@ -1301,7 +1303,12 @@ static void __init tsb_phys_patch(void)
 }
 
 /* Don't mark as init, we give this to the Hypervisor.  */
-static struct hv_tsb_descr ktsb_descr[2];
+#ifndef CONFIG_DEBUG_PAGEALLOC
+#define NUM_KTSB_DESCR	2
+#else
+#define NUM_KTSB_DESCR	1
+#endif
+static struct hv_tsb_descr ktsb_descr[NUM_KTSB_DESCR];
 extern struct tsb swapper_tsb[KERNEL_TSB_NENTRIES];
 
 static void __init sun4v_ktsb_init(void)
@@ -1340,6 +1347,7 @@ static void __init sun4v_ktsb_init(void)
 	ktsb_descr[0].tsb_base = ktsb_pa;
 	ktsb_descr[0].resv = 0;
 
+#ifndef CONFIG_DEBUG_PAGEALLOC
 	/* Second KTSB for 4MB/256MB mappings.  */
 	ktsb_pa = (kern_base +
 		   ((unsigned long)&swapper_4m_tsb[0] - KERNBASE));
@@ -1352,6 +1360,7 @@ static void __init sun4v_ktsb_init(void)
 	ktsb_descr[1].ctx_idx = 0;
 	ktsb_descr[1].tsb_base = ktsb_pa;
 	ktsb_descr[1].resv = 0;
+#endif
 }
 
 void __cpuinit sun4v_ktsb_register(void)
@@ -1364,7 +1373,7 @@ void __cpuinit sun4v_ktsb_register(void)
 	pa = kern_base + ((unsigned long)&ktsb_descr[0] - KERNBASE);
 
 	func = HV_FAST_MMU_TSB_CTX0;
-	arg0 = 2;
+	arg0 = NUM_KTSB_DESCR;
 	arg1 = pa;
 	__asm__ __volatile__("ta	%6"
 			     : "=&r" (func), "=&r" (arg0), "=&r" (arg1)
@@ -1393,7 +1402,9 @@ void __init paging_init(void)
 
 	/* Invalidate both kernel TSBs.  */
 	memset(swapper_tsb, 0x40, sizeof(swapper_tsb));
+#ifndef CONFIG_DEBUG_PAGEALLOC
 	memset(swapper_4m_tsb, 0x40, sizeof(swapper_4m_tsb));
+#endif
 
 	if (tlb_type == hypervisor)
 		sun4v_pgprot_init();
@@ -1725,8 +1736,13 @@ static void __init sun4u_pgprot_init(voi
 	pg_iobits = (_PAGE_VALID | _PAGE_PRESENT_4U | __DIRTY_BITS_4U |
 		     __ACCESS_BITS_4U | _PAGE_E_4U);
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZBITS_4U) ^
+		0xfffff80000000000;
+#else
 	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZ4MB_4U) ^
 		0xfffff80000000000;
+#endif
 	kern_linear_pte_xor[0] |= (_PAGE_CP_4U | _PAGE_CV_4U |
 				   _PAGE_P_4U | _PAGE_W_4U);
 
@@ -1769,13 +1785,23 @@ static void __init sun4v_pgprot_init(voi
 	_PAGE_E = _PAGE_E_4V;
 	_PAGE_CACHE = _PAGE_CACHE_4V;
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZBITS_4V) ^
+		0xfffff80000000000;
+#else
 	kern_linear_pte_xor[0] = (_PAGE_VALID | _PAGE_SZ4MB_4V) ^
 		0xfffff80000000000;
+#endif
 	kern_linear_pte_xor[0] |= (_PAGE_CP_4V | _PAGE_CV_4V |
 				   _PAGE_P_4V | _PAGE_W_4V);
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	kern_linear_pte_xor[1] = (_PAGE_VALID | _PAGE_SZBITS_4V) ^
+		0xfffff80000000000;
+#else
 	kern_linear_pte_xor[1] = (_PAGE_VALID | _PAGE_SZ256MB_4V) ^
 		0xfffff80000000000;
+#endif
 	kern_linear_pte_xor[1] |= (_PAGE_CP_4V | _PAGE_CV_4V |
 				   _PAGE_P_4V | _PAGE_W_4V);
 
--- a/include/asm-sparc64/tsb.h
+++ b/include/asm-sparc64/tsb.h
@@ -264,6 +264,7 @@ extern struct tsb_phys_patch_entry __tsb
 	be,a,pt		%xcc, OK_LABEL; \
 	 mov		REG4, REG1;
 
+#ifndef CONFIG_DEBUG_PAGEALLOC
 	/* This version uses a trick, the TAG is already (VADDR >> 22) so
 	 * we can make use of that for the index computation.
 	 */
@@ -277,5 +278,6 @@ extern struct tsb_phys_patch_entry __tsb
 	cmp		REG3, TAG; \
 	be,a,pt		%xcc, OK_LABEL; \
 	 mov		REG4, REG1;
+#endif
 
 #endif /* !(_SPARC64_TSB_H) */

-- 
