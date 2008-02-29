Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbYB2SIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbYB2SIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYB2SIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:08:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58975 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbYB2SIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:08:39 -0500
Date: Fri, 29 Feb 2008 19:08:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20080229180824.GA31188@elte.hu>
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


Linus, please pull the latest x86 fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

[ Sidenote: i believe "x86: fix pmd_bad and pud_bad to support huge 
  pages" might be solvable in mm/memory.c as well - but this is the 
  minimal (and tested) fix that solves it within the scope of arch/x86. ]

Thanks,

	Ingo

------------------>
Dave Anderson (1):
      x86 ptrace: fix ptrace_bts_config structure declaration

Hans Rosenfeld (1):
      x86: fix pmd_bad and pud_bad to support huge pages

Ingo Molnar (3):
      x86: fix leak un ioremap_page_range() failure
      x86: delay the export removal of init_mm
      x86: disable BTS ptrace extensions for now

Jeremy Fitzhardinge (1):
      xen: mask out SEP from CPUID

Roland McGrath (2):
      x86: tls prevent_tail_call
      x86 vdso: fix build locale dependency

Thomas Gleixner (2):
      x86: restore vsyscall64 prochandler
      x86: CPA: avoid split of alias mappings

 Documentation/feature-removal-schedule.txt |   12 ++++++++++++
 arch/x86/kernel/init_task.c                |    1 +
 arch/x86/kernel/process_32.c               |    2 ++
 arch/x86/kernel/process_64.c               |    2 ++
 arch/x86/kernel/ptrace.c                   |   12 ++++++++++++
 arch/x86/kernel/tls.c                      |    8 ++++++--
 arch/x86/kernel/vsyscall_64.c              |   11 ++++++++++-
 arch/x86/mm/ioremap.c                      |    2 +-
 arch/x86/mm/pageattr.c                     |   21 +++++++++++----------
 arch/x86/vdso/Makefile                     |    6 ++++--
 arch/x86/xen/enlighten.c                   |    1 +
 include/asm-x86/pgtable_32.h               |    4 +++-
 include/asm-x86/pgtable_64.h               |    6 ++++--
 include/asm-x86/ptrace-abi.h               |    8 ++++----
 14 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index ba899ff..c1d1fd0 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -316,3 +316,15 @@ Why:	Largely unmaintained and almost entirely unused.  File system
 	is largely pointless as without a lot of work only the most
 	trivial of Solaris binaries can work with the emulation code.
 Who:	David S. Miller <davem@davemloft.net>
+
+---------------------------
+
+What:	init_mm export
+When:	2.6.26
+Why:	Not used in-tree. The current out-of-tree users used it to
+	work around problems in the CPA code which should be resolved
+	by now. One usecase was described to provide verification code
+	of the CPA operation. That's a good idea in general, but such
+	code / infrastructure should be in the kernel and not in some
+	out-of-tree driver.
+Who:	Thomas Gleixner <tglx@linutronix.de>
diff --git a/arch/x86/kernel/init_task.c b/arch/x86/kernel/init_task.c
index 5b3ce79..3d01e47 100644
--- a/arch/x86/kernel/init_task.c
+++ b/arch/x86/kernel/init_task.c
@@ -15,6 +15,7 @@ static struct files_struct init_files = INIT_FILES;
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
+EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
 
 /*
  * Initial thread structure.
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index a7d50a5..be3c7a2 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -603,11 +603,13 @@ __switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
 	}
 #endif
 
+#ifdef X86_BTS
 	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
 
 	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
+#endif
 
 
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 43f2877..3baf9b9 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -604,11 +604,13 @@ static inline void __switch_to_xtra(struct task_struct *prev_p,
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
 
+#ifdef X86_BTS
 	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
 
 	if (test_tsk_thread_flag(next_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(next_p, BTS_TASK_ARRIVES);
+#endif
 }
 
 /*
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d862e39..f41fdc9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -544,6 +544,8 @@ static int ptrace_set_debugreg(struct task_struct *child,
 	return 0;
 }
 
+#ifdef X86_BTS
+
 static int ptrace_bts_get_size(struct task_struct *child)
 {
 	if (!child->thread.ds_area_msr)
@@ -826,6 +828,7 @@ void ptrace_bts_take_timestamp(struct task_struct *tsk,
 
 	ptrace_bts_write_record(tsk, &rec);
 }
+#endif /* X86_BTS */
 
 /*
  * Called by kernel/ptrace.c when detaching..
@@ -839,7 +842,9 @@ void ptrace_disable(struct task_struct *child)
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 #endif
 	if (child->thread.ds_area_msr) {
+#ifdef X86_BTS
 		ptrace_bts_realloc(child, 0, 0);
+#endif
 		child->thread.debugctlmsr &= ~ds_debugctl_mask();
 		if (!child->thread.debugctlmsr)
 			clear_tsk_thread_flag(child, TIF_DEBUGCTLMSR);
@@ -961,6 +966,10 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 #endif
 
+	/*
+	 * These bits need more cooking - not enabled yet:
+	 */
+#ifdef X86_BTS
 	case PTRACE_BTS_CONFIG:
 		ret = ptrace_bts_config
 			(child, data, (struct ptrace_bts_config __user *)addr);
@@ -988,6 +997,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = ptrace_bts_drain
 			(child, data, (struct bts_struct __user *) addr);
 		break;
+#endif
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
@@ -1226,12 +1236,14 @@ asmlinkage long sys32_ptrace(long request, u32 pid, u32 addr, u32 data)
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
+#ifdef X86_BTS
 	case PTRACE_BTS_CONFIG:
 	case PTRACE_BTS_STATUS:
 	case PTRACE_BTS_SIZE:
 	case PTRACE_BTS_GET:
 	case PTRACE_BTS_CLEAR:
 	case PTRACE_BTS_DRAIN:
+#endif
 		return sys_ptrace(request, pid, addr, data);
 
 	default:
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6dfd4e7..022bcaa 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -91,7 +91,9 @@ int do_set_thread_area(struct task_struct *p, int idx,
 
 asmlinkage int sys_set_thread_area(struct user_desc __user *u_info)
 {
-	return do_set_thread_area(current, -1, u_info, 1);
+	int ret = do_set_thread_area(current, -1, u_info, 1);
+	prevent_tail_call(ret);
+	return ret;
 }
 
 
@@ -139,7 +141,9 @@ int do_get_thread_area(struct task_struct *p, int idx,
 
 asmlinkage int sys_get_thread_area(struct user_desc __user *u_info)
 {
-	return do_get_thread_area(current, -1, u_info);
+	int ret = do_get_thread_area(current, -1, u_info);
+	prevent_tail_call(ret);
+	return ret;
 }
 
 int regset_tls_active(struct task_struct *target,
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index b6be812..edff4c9 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -222,10 +222,19 @@ long __vsyscall(3) venosys_1(void)
 }
 
 #ifdef CONFIG_SYSCTL
+
+static int
+vsyscall_sysctl_change(ctl_table *ctl, int write, struct file * filp,
+		       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	return proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
+}
+
 static ctl_table kernel_table2[] = {
 	{ .procname = "vsyscall64",
 	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
-	  .mode = 0644 },
+	  .mode = 0644,
+	  .proc_handler = vsyscall_sysctl_change },
 	{}
 };
 
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 882328e..ac3c959 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -162,7 +162,7 @@ static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
 	area->phys_addr = phys_addr;
 	vaddr = (unsigned long) area->addr;
 	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
-		remove_vm_area((void *)(vaddr & PAGE_MASK));
+		free_vm_area(area);
 		return NULL;
 	}
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 14e48b5..7049294 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -26,6 +26,7 @@ struct cpa_data {
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
+	int		processed;
 	int		flushtlb;
 	unsigned long	pfn;
 };
@@ -290,8 +291,8 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 */
 	nextpage_addr = (address + psize) & pmask;
 	numpages = (nextpage_addr - address) >> PAGE_SHIFT;
-	if (numpages < cpa->numpages)
-		cpa->numpages = numpages;
+	if (numpages < cpa->processed)
+		cpa->processed = numpages;
 
 	/*
 	 * We are safe now. Check whether the new pgprot is the same:
@@ -318,7 +319,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 */
 	addr = address + PAGE_SIZE;
 	pfn++;
-	for (i = 1; i < cpa->numpages; i++, addr += PAGE_SIZE, pfn++) {
+	for (i = 1; i < cpa->processed; i++, addr += PAGE_SIZE, pfn++) {
 		pgprot_t chk_prot = static_protections(new_prot, addr, pfn);
 
 		if (pgprot_val(chk_prot) != pgprot_val(new_prot))
@@ -342,7 +343,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * that we limited the number of possible pages already to
 	 * the number of pages in the large page.
 	 */
-	if (address == (nextpage_addr - psize) && cpa->numpages == numpages) {
+	if (address == (nextpage_addr - psize) && cpa->processed == numpages) {
 		/*
 		 * The address is aligned and the number of pages
 		 * covers the full page.
@@ -572,7 +573,7 @@ repeat:
 			set_pte_atomic(kpte, new_pte);
 			cpa->flushtlb = 1;
 		}
-		cpa->numpages = 1;
+		cpa->processed = 1;
 		return 0;
 	}
 
@@ -583,7 +584,7 @@ repeat:
 	do_split = try_preserve_large_page(kpte, address, cpa);
 	/*
 	 * When the range fits into the existing large page,
-	 * return. cp->numpages and cpa->tlbflush have been updated in
+	 * return. cp->processed and cpa->tlbflush have been updated in
 	 * try_large_page:
 	 */
 	if (do_split <= 0)
@@ -662,7 +663,7 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 * Store the remaining nr of pages for the large page
 		 * preservation check.
 		 */
-		cpa->numpages = numpages;
+		cpa->numpages = cpa->processed = numpages;
 
 		ret = __change_page_attr(cpa, checkalias);
 		if (ret)
@@ -679,9 +680,9 @@ static int __change_page_attr_set_clr(struct cpa_data *cpa, int checkalias)
 		 * CPA operation. Either a large page has been
 		 * preserved or a single page update happened.
 		 */
-		BUG_ON(cpa->numpages > numpages);
-		numpages -= cpa->numpages;
-		cpa->vaddr += cpa->numpages * PAGE_SIZE;
+		BUG_ON(cpa->processed > numpages);
+		numpages -= cpa->processed;
+		cpa->vaddr += cpa->processed * PAGE_SIZE;
 	}
 	return 0;
 }
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index b8bd0c4..0a8f474 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -48,9 +48,11 @@ obj-$(VDSO64-y)			+= vdso-syms.lds
 # Match symbols in the DSO that look like VDSO*; produce a file of constants.
 #
 sed-vdsosym := -e 's/^00*/0/' \
-	-e 's/^\([[:xdigit:]]*\) . \(VDSO[[:alnum:]_]*\)$$/\2 = 0x\1;/p'
+	-e 's/^\([0-9a-fA-F]*\) . \(VDSO[a-zA-Z0-9_]*\)$$/\2 = 0x\1;/p'
 quiet_cmd_vdsosym = VDSOSYM $@
-      cmd_vdsosym = $(NM) $< | sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+define cmd_vdsosym
+	$(NM) $< | LC_ALL=C sed -n $(sed-vdsosym) | LC_ALL=C sort > $@
+endef
 
 $(obj)/%-syms.lds: $(obj)/%.so.dbg FORCE
 	$(call if_changed,vdsosym)
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 49e5358..8b9ee27 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -153,6 +153,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 	if (*ax == 1)
 		maskedx = ~((1 << X86_FEATURE_APIC) |  /* disable APIC */
 			    (1 << X86_FEATURE_ACPI) |  /* disable ACPI */
+			    (1 << X86_FEATURE_SEP)  |  /* disable SEP */
 			    (1 << X86_FEATURE_ACC));   /* thermal monitoring */
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
diff --git a/include/asm-x86/pgtable_32.h b/include/asm-x86/pgtable_32.h
index a842c72..b478efa 100644
--- a/include/asm-x86/pgtable_32.h
+++ b/include/asm-x86/pgtable_32.h
@@ -91,7 +91,9 @@ extern unsigned long pg0[];
 /* To avoid harmful races, pmd_none(x) should check only the lower when PAE */
 #define pmd_none(x)	(!(unsigned long)pmd_val(x))
 #define pmd_present(x)	(pmd_val(x) & _PAGE_PRESENT)
-#define	pmd_bad(x)	((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
+#define	pmd_bad(x)	((pmd_val(x) \
+			  & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
+			 != _KERNPG_TABLE)
 
 
 #define pages_to_mb(x) ((x) >> (20-PAGE_SHIFT))
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 0a0b77b..0a92583 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -153,12 +153,14 @@ static inline unsigned long pgd_bad(pgd_t pgd)
 
 static inline unsigned long pud_bad(pud_t pud)
 {
-	return pud_val(pud) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return pud_val(pud) &
+		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
 static inline unsigned long pmd_bad(pmd_t pmd)
 {
-	return pmd_val(pmd) & ~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER);
+	return pmd_val(pmd) &
+		~(PTE_MASK | _KERNPG_TABLE | _PAGE_USER | _PAGE_PSE | _PAGE_NX);
 }
 
 #define pte_none(x)	(!pte_val(x))
diff --git a/include/asm-x86/ptrace-abi.h b/include/asm-x86/ptrace-abi.h
index 81a8ee4..f224eb3 100644
--- a/include/asm-x86/ptrace-abi.h
+++ b/include/asm-x86/ptrace-abi.h
@@ -89,13 +89,13 @@
 */
 struct ptrace_bts_config {
 	/* requested or actual size of BTS buffer in bytes */
-	u32 size;
+	__u32 size;
 	/* bitmask of below flags */
-	u32 flags;
+	__u32 flags;
 	/* buffer overflow signal */
-	u32 signal;
+	__u32 signal;
 	/* actual size of bts_struct in bytes */
-	u32 bts_size;
+	__u32 bts_size;
 };
 #endif
 
