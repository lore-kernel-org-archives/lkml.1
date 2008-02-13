Return-Path: <linux-kernel-owner+w=401wt.eu-S1764705AbYBMP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764705AbYBMP6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932691AbYBMP5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:57:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39478 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932671AbYBMP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:57:44 -0500
Date: Wed, 13 Feb 2008 16:57:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 updates
Message-ID: <20080213155725.GA19523@elte.hu>
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

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Shortlog and diffstat attached below.

low-key fixes and updates. 2.6.25-rc1 looks pretty solid so far in terms 
of arch/x86 with no major regression reported against the 1000+ x86.git 
commits. (no native kernel boot problem or runtime failure/crash - there 
was one paravirt boot crash report)

The gcc sigcontext.h header fixes, the Xen-guest boot fixes and the EFI 
fixes stand out. [there are more CPA cleanups still brewing but none of 
that is urgent.]

	Ingo

------------------>
Andi Kleen (1):
      x86: CPA: fix gbpages support in try_preserve_large_page

Harvey Harrison (1):
      x86: pit_clockevent can be static

Huang, Ying (1):
      x86: EFI runtime code mapping enhancement

Ingo Molnar (1):
      x86: fix sigcontext.h user export

Jeremy Fitzhardinge (2):
      x86/early_ioremap: don't assume we're using swapper_pg_dir
      xen: unpin initial Xen pagetable once we're finished with it

Jody Belka (1):
      x86: fixup machine_ops reboot_{32|64}.c unification fallout

Thomas Gleixner (1):
      x86: EFI: fix use of unitialized variable and the cache logic

 arch/x86/kernel/efi.c        |   12 +++----
 arch/x86/kernel/efi_64.c     |   32 ++++++++------------
 arch/x86/kernel/i8253.c      |    2 +-
 arch/x86/kernel/reboot.c     |   46 +++++++++++++++++++++++------
 arch/x86/mm/ioremap.c        |    4 ++-
 arch/x86/mm/pageattr.c       |    4 +-
 arch/x86/xen/enlighten.c     |    4 ++
 include/asm-x86/sigcontext.h |   66 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 130 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 32dd62b..cbdf9ba 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -384,9 +384,6 @@ static void __init runtime_code_page_mkexec(void)
 	efi_memory_desc_t *md;
 	void *p;
 
-	if (!(__supported_pte_mask & _PAGE_NX))
-		return;
-
 	/* Make EFI runtime service code area executable */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -428,9 +425,6 @@ void __init efi_enter_virtual_mode(void)
 		else
 			va = efi_ioremap(md->phys_addr, size);
 
-		if (md->attribute & EFI_MEMORY_WB)
-			set_memory_uc(md->virt_addr, size);
-
 		md->virt_addr = (u64) (unsigned long) va;
 
 		if (!va) {
@@ -439,6 +433,9 @@ void __init efi_enter_virtual_mode(void)
 			continue;
 		}
 
+		if (!(md->attribute & EFI_MEMORY_WB))
+			set_memory_uc(md->virt_addr, size);
+
 		systab = (u64) (unsigned long) efi_phys.systab;
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
@@ -476,7 +473,8 @@ void __init efi_enter_virtual_mode(void)
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
-	runtime_code_page_mkexec();
+	if (__supported_pte_mask & _PAGE_NX)
+		runtime_code_page_mkexec();
 	early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 	memmap.map = NULL;
 }
diff --git a/arch/x86/kernel/efi_64.c b/arch/x86/kernel/efi_64.c
index 09d5c23..d143a1e 100644
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -35,6 +35,7 @@
 #include <asm/tlbflush.h>
 #include <asm/proto.h>
 #include <asm/efi.h>
+#include <asm/cacheflush.h>
 
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
@@ -43,22 +44,15 @@ static void __init early_mapping_set_exec(unsigned long start,
 					  unsigned long end,
 					  int executable)
 {
-	pte_t *kpte;
-	unsigned int level;
-
-	while (start < end) {
-		kpte = lookup_address((unsigned long)__va(start), &level);
-		BUG_ON(!kpte);
-		if (executable)
-			set_pte(kpte, pte_mkexec(*kpte));
-		else
-			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
-					    __supported_pte_mask));
-		if (level == PG_LEVEL_4K)
-			start = (start + PAGE_SIZE) & PAGE_MASK;
-		else
-			start = (start + PMD_SIZE) & PMD_MASK;
-	}
+	unsigned long num_pages;
+
+	start &= PMD_MASK;
+	end = (end + PMD_SIZE - 1) & PMD_MASK;
+	num_pages = (end - start) >> PAGE_SHIFT;
+	if (executable)
+		set_memory_x((unsigned long)__va(start), num_pages);
+	else
+		set_memory_nx((unsigned long)__va(start), num_pages);
 }
 
 static void __init early_runtime_code_mapping_set_exec(int executable)
@@ -74,7 +68,7 @@ static void __init early_runtime_code_mapping_set_exec(int executable)
 		md = p;
 		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
 			unsigned long end;
-			end = md->phys_addr + (md->num_pages << PAGE_SHIFT);
+			end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 			early_mapping_set_exec(md->phys_addr, end, executable);
 		}
 	}
@@ -84,8 +78,8 @@ void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
-	local_irq_save(efi_flags);
 	early_runtime_code_mapping_set_exec(1);
+	local_irq_save(efi_flags);
 	vaddress = (unsigned long)__va(0x0UL);
 	save_pgd = *pgd_offset_k(0x0UL);
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
@@ -98,9 +92,9 @@ void __init efi_call_phys_epilog(void)
 	 * After the lock is released, the original page table is restored.
 	 */
 	set_pgd(pgd_offset_k(0x0UL), save_pgd);
-	early_runtime_code_mapping_set_exec(0);
 	__flush_tlb_all();
 	local_irq_restore(efi_flags);
+	early_runtime_code_mapping_set_exec(0);
 }
 
 void __init efi_reserve_bootmem(void)
diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index ef62b07..8540abe 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -95,7 +95,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
-struct clock_event_device pit_clockevent = {
+static struct clock_event_device pit_clockevent = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5818dc2..7fd6ac4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -326,7 +326,7 @@ static inline void kb_wait(void)
 	}
 }
 
-void machine_emergency_restart(void)
+static void native_machine_emergency_restart(void)
 {
 	int i;
 
@@ -376,7 +376,7 @@ void machine_emergency_restart(void)
 	}
 }
 
-void machine_shutdown(void)
+static void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
@@ -420,7 +420,7 @@ void machine_shutdown(void)
 #endif
 }
 
-void machine_restart(char *__unused)
+static void native_machine_restart(char *__unused)
 {
 	printk("machine restart\n");
 
@@ -429,11 +429,11 @@ void machine_restart(char *__unused)
 	machine_emergency_restart();
 }
 
-void machine_halt(void)
+static void native_machine_halt(void)
 {
 }
 
-void machine_power_off(void)
+static void native_machine_power_off(void)
 {
 	if (pm_power_off) {
 		if (!reboot_force)
@@ -443,9 +443,35 @@ void machine_power_off(void)
 }
 
 struct machine_ops machine_ops = {
-	.power_off = machine_power_off,
-	.shutdown = machine_shutdown,
-	.emergency_restart = machine_emergency_restart,
-	.restart = machine_restart,
-	.halt = machine_halt
+	.power_off = native_machine_power_off,
+	.shutdown = native_machine_shutdown,
+	.emergency_restart = native_machine_emergency_restart,
+	.restart = native_machine_restart,
+	.halt = native_machine_halt
 };
+
+void machine_power_off(void)
+{
+	machine_ops.power_off();
+}
+
+void machine_shutdown(void)
+{
+	machine_ops.shutdown();
+}
+
+void machine_emergency_restart(void)
+{
+	machine_ops.emergency_restart();
+}
+
+void machine_restart(char *cmd)
+{
+	machine_ops.restart(cmd);
+}
+
+void machine_halt(void)
+{
+	machine_ops.halt();
+}
+
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index a4897a8..9f42d7e 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -265,7 +265,9 @@ static __initdata pte_t bm_pte[PAGE_SIZE/sizeof(pte_t)]
 
 static inline pmd_t * __init early_ioremap_pmd(unsigned long addr)
 {
-	pgd_t *pgd = &swapper_pg_dir[pgd_index(addr)];
+	/* Don't assume we're using swapper_pg_dir at this point */
+	pgd_t *base = __va(read_cr3());
+	pgd_t *pgd = &base[pgd_index(addr)];
 	pud_t *pud = pud_offset(pgd, addr);
 	pmd_t *pmd = pmd_offset(pud, addr);
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 440210a..bd61ed1 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -275,8 +275,8 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 		break;
 #ifdef CONFIG_X86_64
 	case PG_LEVEL_1G:
-		psize = PMD_PAGE_SIZE;
-		pmask = PMD_PAGE_MASK;
+		psize = PUD_PAGE_SIZE;
+		pmask = PUD_PAGE_MASK;
 		break;
 #endif
 	default:
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index de647bc..49e5358 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -798,6 +798,10 @@ static __init void xen_pagetable_setup_start(pgd_t *base)
 	 * added to the table can be prepared properly for Xen.
 	 */
 	xen_write_cr3(__pa(base));
+
+	/* Unpin initial Xen pagetable */
+	pin_pagetable_pfn(MMUEXT_UNPIN_TABLE,
+			  PFN_DOWN(__pa(xen_start_info->pt_base)));
 }
 
 static __init void xen_pagetable_setup_done(pgd_t *base)
diff --git a/include/asm-x86/sigcontext.h b/include/asm-x86/sigcontext.h
index 681dead..d743947 100644
--- a/include/asm-x86/sigcontext.h
+++ b/include/asm-x86/sigcontext.h
@@ -58,6 +58,7 @@ struct _fpstate {
 
 #define X86_FXSR_MAGIC		0x0000
 
+#ifdef __KERNEL__
 struct sigcontext {
 	unsigned short gs, __gsh;
 	unsigned short fs, __fsh;
@@ -82,6 +83,35 @@ struct sigcontext {
 	unsigned long oldmask;
 	unsigned long cr2;
 };
+#else /* __KERNEL__ */
+/*
+ * User-space might still rely on the old definition:
+ */
+struct sigcontext {
+	unsigned short gs, __gsh;
+	unsigned short fs, __fsh;
+	unsigned short es, __esh;
+	unsigned short ds, __dsh;
+	unsigned long edi;
+	unsigned long esi;
+	unsigned long ebp;
+	unsigned long esp;
+	unsigned long ebx;
+	unsigned long edx;
+	unsigned long ecx;
+	unsigned long eax;
+	unsigned long trapno;
+	unsigned long err;
+	unsigned long eip;
+	unsigned short cs, __csh;
+	unsigned long eflags;
+	unsigned long esp_at_signal;
+	unsigned short ss, __ssh;
+	struct _fpstate __user * fpstate;
+	unsigned long oldmask;
+	unsigned long cr2;
+};
+#endif /* !__KERNEL__ */
 
 #else /* __i386__ */
 
@@ -102,6 +132,7 @@ struct _fpstate {
 	__u32	reserved2[24];
 };
 
+#ifdef __KERNEL__
 struct sigcontext {
 	unsigned long r8;
 	unsigned long r9;
@@ -132,6 +163,41 @@ struct sigcontext {
 	struct _fpstate __user *fpstate;	/* zero when no FPU context */
 	unsigned long reserved1[8];
 };
+#else /* __KERNEL__ */
+/*
+ * User-space might still rely on the old definition:
+ */
+struct sigcontext {
+	unsigned long r8;
+	unsigned long r9;
+	unsigned long r10;
+	unsigned long r11;
+	unsigned long r12;
+	unsigned long r13;
+	unsigned long r14;
+	unsigned long r15;
+	unsigned long rdi;
+	unsigned long rsi;
+	unsigned long rbp;
+	unsigned long rbx;
+	unsigned long rdx;
+	unsigned long rax;
+	unsigned long rcx;
+	unsigned long rsp;
+	unsigned long rip;
+	unsigned long eflags;		/* RFLAGS */
+	unsigned short cs;
+	unsigned short gs;
+	unsigned short fs;
+	unsigned short __pad0;
+	unsigned long err;
+	unsigned long trapno;
+	unsigned long oldmask;
+	unsigned long cr2;
+	struct _fpstate __user *fpstate;	/* zero when no FPU context */
+	unsigned long reserved1[8];
+};
+#endif /* !__KERNEL__ */
 
 #endif /* !__i386__ */
 
