Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab0BYKLT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:11:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:47760 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab0BYKLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:11:12 -0500
Date: Thu, 25 Feb 2010 10:10:51 GMT
From: tip-bot for Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ian.campbell@citrix.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, tglx@linutronix.de
In-Reply-To: <1266403090-20162-1-git-send-email-ian.campbell@citrix.com>
References: <1266403090-20162-1-git-send-email-ian.campbell@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Allow highmem user page tables to be disabled at boot time
Message-ID: <tip-14315592009c17035cac81f4954d5a1f4d71e489@git.kernel.org>
Git-Commit-ID: 14315592009c17035cac81f4954d5a1f4d71e489
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:10:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14315592009c17035cac81f4954d5a1f4d71e489
Gitweb:     http://git.kernel.org/tip/14315592009c17035cac81f4954d5a1f4d71e489
Author:     Ian Campbell <ian.campbell@citrix.com>
AuthorDate: Wed, 17 Feb 2010 10:38:10 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:28:19 +0100

x86, mm: Allow highmem user page tables to be disabled at boot time

Distros generally (I looked at Debian, RHEL5 and SLES11) seem to
enable CONFIG_HIGHPTE for any x86 configuration which has highmem
enabled. This means that the overhead applies even to machines which
have a fairly modest amount of high memory and which therefore do not
really benefit from allocating PTEs in high memory but still pay the
price of the additional mapping operations.

Running kernbench on a 4G box I found that with CONFIG_HIGHPTE=y but
no actual highptes being allocated there was a reduction in system
time used from 59.737s to 55.9s.

With CONFIG_HIGHPTE=y and highmem PTEs being allocated:
  Average Optimal load -j 4 Run (std deviation):
  Elapsed Time 175.396 (0.238914)
  User Time 515.983 (5.85019)
  System Time 59.737 (1.26727)
  Percent CPU 263.8 (71.6796)
  Context Switches 39989.7 (4672.64)
  Sleeps 42617.7 (246.307)

With CONFIG_HIGHPTE=y but with no highmem PTEs being allocated:
  Average Optimal load -j 4 Run (std deviation):
  Elapsed Time 174.278 (0.831968)
  User Time 515.659 (6.07012)
  System Time 55.9 (1.07799)
  Percent CPU 263.8 (71.266)
  Context Switches 39929.6 (4485.13)
  Sleeps 42583.7 (373.039)

This patch allows the user to control the allocation of PTEs in
highmem from the command line ("userpte=nohigh") but retains the
status-quo as the default.

It is possible that some simple heuristic could be developed which
allows auto-tuning of this option however I don't have a sufficiently
large machine available to me to perform any particularly meaningful
experiments. We could probably handwave up an argument for a threshold
at 16G of total RAM.

Assuming 768M of lowmem we have 196608 potential lowmem PTE
pages. Each page can map 2M of RAM in a PAE-enabled configuration,
meaning a maximum of 384G of RAM could potentially be mapped using
lowmem PTEs.

Even allowing generous factor of 10 to account for other required
lowmem allocations, generous slop to account for page sharing (which
reduces the total amount of RAM mappable by a given number of PT
pages) and other innacuracies in the estimations it would seem that
even a 32G machine would not have a particularly pressing need for
highmem PTEs. I think 32G could be considered to be at the upper bound
of what might be sensible on a 32 bit machine (although I think in
practice 64G is still supported).

It's seems questionable if HIGHPTE is even a win for any amount of RAM
you would sensibly run a 32 bit kernel on rather than going 64 bit.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
LKML-Reference: <1266403090-20162-1-git-send-email-ian.campbell@citrix.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/kernel-parameters.txt |    7 +++++++
 arch/x86/include/asm/pgalloc.h      |    5 +++++
 arch/x86/mm/pgtable.c               |   31 ++++++++++++++++++++++++++-----
 3 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 736d456..67c69ff 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2694,6 +2694,13 @@ and is between 256 and 4096 characters. It is defined in the file
 					medium is write-protected).
 			Example: quirks=0419:aaf5:rl,0421:0433:rc
 
+	userpte=
+			[X86] Flags controlling user PTE allocations.
+
+				nohigh = do not allocate PTE pages in
+					HIGHMEM regardless of setting
+					of CONFIG_HIGHPTE.
+
 	vdso=		[X86,SH]
 			vdso=2: enable compat VDSO (default with COMPAT_VDSO)
 			vdso=1: enable VDSO (default)
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index 0e8c2a0..271de94 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -23,6 +23,11 @@ static inline void paravirt_release_pud(unsigned long pfn) {}
 #endif
 
 /*
+ * Flags to use when allocating a user page table page.
+ */
+extern gfp_t __userpte_alloc_gfp;
+
+/*
  * Allocate and free page tables.
  */
 extern pgd_t *pgd_alloc(struct mm_struct *);
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index ed34f5e..c9ba9de 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -6,6 +6,14 @@
 
 #define PGALLOC_GFP GFP_KERNEL | __GFP_NOTRACK | __GFP_REPEAT | __GFP_ZERO
 
+#ifdef CONFIG_HIGHPTE
+#define PGALLOC_USER_GFP __GFP_HIGHMEM
+#else
+#define PGALLOC_USER_GFP 0
+#endif
+
+gfp_t __userpte_alloc_gfp = PGALLOC_GFP | PGALLOC_USER_GFP;
+
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
 {
 	return (pte_t *)__get_free_page(PGALLOC_GFP);
@@ -15,16 +23,29 @@ pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
 	struct page *pte;
 
-#ifdef CONFIG_HIGHPTE
-	pte = alloc_pages(PGALLOC_GFP | __GFP_HIGHMEM, 0);
-#else
-	pte = alloc_pages(PGALLOC_GFP, 0);
-#endif
+	pte = alloc_pages(__userpte_alloc_gfp, 0);
 	if (pte)
 		pgtable_page_ctor(pte);
 	return pte;
 }
 
+static int __init setup_userpte(char *arg)
+{
+	if (!arg)
+		return -EINVAL;
+
+	/*
+	 * "userpte=nohigh" disables allocation of user pagetables in
+	 * high memory.
+	 */
+	if (strcmp(arg, "nohigh") == 0)
+		__userpte_alloc_gfp &= ~__GFP_HIGHMEM;
+	else
+		return -EINVAL;
+	return 0;
+}
+early_param("userpte", setup_userpte);
+
 void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 {
 	pgtable_page_dtor(pte);
