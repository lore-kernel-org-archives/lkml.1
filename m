Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYGDQs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYGDQs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 12:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYGDQsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 12:48:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55484 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725AbYGDQsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 12:48:50 -0400
Date: Fri, 4 Jul 2008 18:48:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080704164829.GA21917@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Linus,

Please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Thanks,

	Ingo

------------------>
Andrew Morton (1):
      arch/x86/mm/init_64.c: early_memtest(): fix types

Hugh Dickins (1):
      x86: fix Intel Mac booting with EFI

Jeremy Fitzhardinge (1):
      xen: fix address truncation in pte mfn<->pfn conversion

 arch/x86/kernel/efi_32.c |    8 ++++----
 arch/x86/mm/init_64.c    |    7 ++++---
 arch/x86/xen/mmu.c       |    4 ++--
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index 5d23d85..4b63c8e 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -49,13 +49,13 @@ void efi_call_phys_prelog(void)
 	local_irq_save(efi_rt_eflags);
 
 	/*
-	 * If I don't have PSE, I should just duplicate two entries in page
-	 * directory. If I have PSE, I just need to duplicate one entry in
+	 * If I don't have PAE, I should just duplicate two entries in page
+	 * directory. If I have PAE, I just need to duplicate one entry in
 	 * page directory.
 	 */
 	cr4 = read_cr4();
 
-	if (cr4 & X86_CR4_PSE) {
+	if (cr4 & X86_CR4_PAE) {
 		efi_bak_pg_dir_pointer[0].pgd =
 		    swapper_pg_dir[pgd_index(0)].pgd;
 		swapper_pg_dir[0].pgd =
@@ -93,7 +93,7 @@ void efi_call_phys_epilog(void)
 
 	cr4 = read_cr4();
 
-	if (cr4 & X86_CR4_PSE) {
+	if (cr4 & X86_CR4_PAE) {
 		swapper_pg_dir[pgd_index(0)].pgd =
 		    efi_bak_pg_dir_pointer[0].pgd;
 	} else {
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index f6d20be..819dad9 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -506,7 +506,7 @@ early_param("memtest", parse_memtest);
 
 static void __init early_memtest(unsigned long start, unsigned long end)
 {
-	unsigned long t_start, t_size;
+	u64 t_start, t_size;
 	unsigned pattern;
 
 	if (!memtest_pattern)
@@ -525,8 +525,9 @@ static void __init early_memtest(unsigned long start, unsigned long end)
 			if (t_start + t_size > end)
 				t_size = end - t_start;
 
-			printk(KERN_CONT "\n  %016lx - %016lx pattern %d",
-				t_start, t_start + t_size, pattern);
+			printk(KERN_CONT "\n  %016llx - %016llx pattern %d",
+				(unsigned long long)t_start,
+				(unsigned long long)t_start + t_size, pattern);
 
 			memtest(t_start, t_size, pattern);
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index df40bf7..4e527e7 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -185,7 +185,7 @@ static pteval_t pte_mfn_to_pfn(pteval_t val)
 	if (val & _PAGE_PRESENT) {
 		unsigned long mfn = (val & PTE_MASK) >> PAGE_SHIFT;
 		pteval_t flags = val & ~PTE_MASK;
-		val = (mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
+		val = ((pteval_t)mfn_to_pfn(mfn) << PAGE_SHIFT) | flags;
 	}
 
 	return val;
@@ -196,7 +196,7 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
 	if (val & _PAGE_PRESENT) {
 		unsigned long pfn = (val & PTE_MASK) >> PAGE_SHIFT;
 		pteval_t flags = val & ~PTE_MASK;
-		val = (pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
+		val = ((pteval_t)pfn_to_mfn(pfn) << PAGE_SHIFT) | flags;
 	}
 
 	return val;
