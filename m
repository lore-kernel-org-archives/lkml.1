Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbYCKQNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbYCKQNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCKQNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:13:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42166 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbYCKQM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:12:59 -0400
Date: Tue, 11 Mar 2008 17:12:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080311161238.GA28277@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

the inclusion of the quicklist removal patch was a hard decision but we 
tend to think that it's best way forward: re-tuning the quicklist 
freeing thresholds would probably solve the regression too but has risks 
of its own as the rules are not simple at all. (64-bit x86 does not use 
quicklists either)

Note: the ia32 syscall restart fix from Roland has an impact on the ABI. 
(it's a good fix IMO, but still it's a change.)

	Ingo

------------------>
Ingo Molnar (1):
      x86: ioremap, remove WARN_ON()

Roland McGrath (1):
      x86: ia32 syscall restart fix

Thomas Gleixner (1):
      x86: remove quicklists

 arch/x86/Kconfig             |    3 ---
 arch/x86/kernel/ptrace.c     |    9 ++++++++-
 arch/x86/kernel/signal_64.c  |   38 +++++++++++++++++++++++++++++++++-----
 arch/x86/mm/ioremap.c        |    2 --
 arch/x86/mm/pgtable_32.c     |   18 +++++++++---------
 include/asm-x86/pgtable_32.h |    5 ++---
 6 files changed, 52 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f41c953..237fc12 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -66,9 +66,6 @@ config MMU
 config ZONE_DMA
 	def_bool y
 
-config QUICKLIST
-	def_bool X86_32
-
 config SBUS
 	bool
 
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 8f64abe..d5904ee 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -1055,10 +1055,17 @@ static int putreg32(struct task_struct *child, unsigned regno, u32 value)
 	R32(esi, si);
 	R32(ebp, bp);
 	R32(eax, ax);
-	R32(orig_eax, orig_ax);
 	R32(eip, ip);
 	R32(esp, sp);
 
+	case offsetof(struct user32, regs.orig_eax):
+		/*
+		 * Sign-extend the value so that orig_eax = -1
+		 * causes (long)orig_ax < 0 tests to fire correctly.
+		 */
+		regs->orig_ax = (long) (s32) value;
+		break;
+
 	case offsetof(struct user32, regs.eflags):
 		return set_flags(child, value);
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 56b72fb..1c83e51 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -311,6 +311,35 @@ give_sigsegv:
 }
 
 /*
+ * Return -1L or the syscall number that @regs is executing.
+ */
+static long current_syscall(struct pt_regs *regs)
+{
+	/*
+	 * We always sign-extend a -1 value being set here,
+	 * so this is always either -1L or a syscall number.
+	 */
+	return regs->orig_ax;
+}
+
+/*
+ * Return a value that is -EFOO if the system call in @regs->orig_ax
+ * returned an error.  This only works for @regs from @current.
+ */
+static long current_syscall_ret(struct pt_regs *regs)
+{
+#ifdef CONFIG_IA32_EMULATION
+	if (test_thread_flag(TIF_IA32))
+		/*
+		 * Sign-extend the value so (int)-EFOO becomes (long)-EFOO
+		 * and will match correctly in comparisons.
+		 */
+		return (int) regs->ax;
+#endif
+	return regs->ax;
+}
+
+/*
  * OK, we're invoking a handler
  */	
 
@@ -327,9 +356,9 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 #endif
 
 	/* Are we from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (current_syscall(regs) >= 0) {
 		/* If so, check system call restarting.. */
-		switch (regs->ax) {
+		switch (current_syscall_ret(regs)) {
 		        case -ERESTART_RESTARTBLOCK:
 			case -ERESTARTNOHAND:
 				regs->ax = -EINTR;
@@ -426,10 +455,9 @@ static void do_signal(struct pt_regs *regs)
 	}
 
 	/* Did we come from a system call? */
-	if ((long)regs->orig_ax >= 0) {
+	if (current_syscall(regs) >= 0) {
 		/* Restart the system call - no handlers present */
-		long res = regs->ax;
-		switch (res) {
+		switch (current_syscall_ret(regs)) {
 		case -ERESTARTNOHAND:
 		case -ERESTARTSYS:
 		case -ERESTARTNOINTR:
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index ac3c959..8fe576b 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -134,8 +134,6 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 			return NULL;
 	}
 
-	WARN_ON_ONCE(page_is_ram(pfn));
-
 	switch (mode) {
 	case IOR_MODE_UNCACHED:
 	default:
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index 73aba71..2f9e9af 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -342,12 +342,16 @@ static void pgd_mop_up_pmds(struct mm_struct *mm, pgd_t *pgdp)
 
 pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	pgd_t *pgd = quicklist_alloc(0, GFP_KERNEL, pgd_ctor);
+	pgd_t *pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
 
-	mm->pgd = pgd;		/* so that alloc_pd can use it */
+	/* so that alloc_pd can use it */
+	mm->pgd = pgd;
+	if (pgd)
+		pgd_ctor(pgd);
 
 	if (pgd && !pgd_prepopulate_pmd(mm, pgd)) {
-		quicklist_free(0, pgd_dtor, pgd);
+		pgd_dtor(pgd);
+		free_page((unsigned long)pgd);
 		pgd = NULL;
 	}
 
@@ -357,12 +361,8 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
 	pgd_mop_up_pmds(mm, pgd);
-	quicklist_free(0, pgd_dtor, pgd);
-}
-
-void check_pgt_cache(void)
-{
-	quicklist_trim(0, pgd_dtor, 25, 16);
+	pgd_dtor(pgd);
+	free_page((unsigned long)pgd);
 }
 
 void __pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index a842c72..4e6a0fc 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -26,10 +26,9 @@ struct mm_struct;
 struct vm_area_struct;
 
 extern pgd_t swapper_pg_dir[1024];
-extern struct kmem_cache *pmd_cache;
-void check_pgt_cache(void);
 
-static inline void pgtable_cache_init(void) {}
+static inline void pgtable_cache_init(void) { }
+static inline void check_pgt_cache(void) { }
 void paging_init(void);
 
 
