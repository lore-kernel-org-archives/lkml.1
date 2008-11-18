Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbYKRIPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbYKRIPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYKRIPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:15:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYKRIPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:15:39 -0500
Date: Tue, 18 Nov 2008 09:15:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eduardo Habkost <ehabkost@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] x86: disable virt on kdump and emergency_restart
	(v4)
Message-ID: <20081118081501.GF17838@elte.hu>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eduardo Habkost <ehabkost@redhat.com> wrote:

> Hi, Ingo,
> 
> This is yet another spin of the series to disable vmx on kdump and 
> on emergency_restart, after some feedback from Avi.

this is going to interact with the KVM tree, wont it?

i think the best way forward would be to keep your changes in the KVM 
tree.

Lets try a Git trick for that. Avi could do that by pulling your other 
x86 changes from the x86 topic tree into the kvm tree. They are 
reviewed, acked and well-tested now, and kept in a separate tree so no 
other x86 change will be pulled in via them.

We can do this if Avi can guarantee that these commits wont ever be 
rebased within KVM - then the two trees will merge up just fine in 
linux-next (and later in v2.6.29 as well), without any awkward merge 
dependencies or merge conflicts.

See the pull request below.

	Ingo

------------>
Please pull the latest x86/crashdump git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/crashdump


out-of-topic modifications in x86/crashdump:
--------------------------------------------
include/linux/kexec.h              # 92be3d6: kexec/i386: allocate page table p

 Thanks,

	Ingo

------------------>
Eduardo Habkost (8):
      x86 kdump: extract kdump-specific code from crash_nmi_callback()
      x86 kdump: move crashing_cpu assignment to nmi_shootdown_cpus()
      x86 kdump: create kdump_nmi_shootdown_cpus()
      x86 kdump: make kdump_nmi_callback() a function ptr on crash_nmi_callback()
      x86 kdump: make nmi_shootdown_cpus() non-static
      x86: move nmi_shootdown_cpus() to reboot.c
      x86: make nmi_shootdown_cpus() available on !SMP and !X86_LOCAL_APIC
      x86: disable IRQs before doing anything on nmi_shootdown_cpus()

Huang Ying (3):
      kexec/i386: remove PAGE_SIZE alignment from relocate_kernel
      kexec/i386: allocate page table pages dynamically
      kexec/i386: setup kexec page table in C


 arch/x86/include/asm/kexec.h         |   31 +++++-----
 arch/x86/include/asm/reboot.h        |    5 ++
 arch/x86/kernel/crash.c              |   70 +++------------------
 arch/x86/kernel/machine_kexec_32.c   |  104 ++++++++++++++++++++++++-------
 arch/x86/kernel/reboot.c             |   95 ++++++++++++++++++++++++++++
 arch/x86/kernel/relocate_kernel_32.S |  115 ----------------------------------
 include/linux/kexec.h                |    4 +
 7 files changed, 210 insertions(+), 214 deletions(-)

diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index a1f2277..c61d8b2 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -5,21 +5,8 @@
 # define PA_CONTROL_PAGE	0
 # define VA_CONTROL_PAGE	1
 # define PA_PGD			2
-# define VA_PGD			3
-# define PA_PTE_0		4
-# define VA_PTE_0		5
-# define PA_PTE_1		6
-# define VA_PTE_1		7
-# define PA_SWAP_PAGE		8
-# ifdef CONFIG_X86_PAE
-#  define PA_PMD_0		9
-#  define VA_PMD_0		10
-#  define PA_PMD_1		11
-#  define VA_PMD_1		12
-#  define PAGES_NR		13
-# else
-#  define PAGES_NR		9
-# endif
+# define PA_SWAP_PAGE		3
+# define PAGES_NR		4
 #else
 # define PA_CONTROL_PAGE	0
 # define VA_CONTROL_PAGE	1
@@ -170,6 +157,20 @@ relocate_kernel(unsigned long indirection_page,
 		unsigned long start_address) ATTRIB_NORET;
 #endif
 
+#ifdef CONFIG_X86_32
+#define ARCH_HAS_KIMAGE_ARCH
+
+struct kimage_arch {
+	pgd_t *pgd;
+#ifdef CONFIG_X86_PAE
+	pmd_t *pmd0;
+	pmd_t *pmd1;
+#endif
+	pte_t *pte0;
+	pte_t *pte1;
+};
+#endif
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_KEXEC_H */
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index df77103..562d4fd 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_REBOOT_H
 #define _ASM_X86_REBOOT_H
 
+#include <linux/kdebug.h>
+
 struct pt_regs;
 
 struct machine_ops {
@@ -18,4 +20,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs);
 void native_machine_shutdown(void);
 void machine_real_restart(const unsigned char *code, int length);
 
+typedef void (*nmi_shootdown_cb)(int, struct die_args*);
+void nmi_shootdown_cpus(nmi_shootdown_cb callback);
+
 #endif /* _ASM_X86_REBOOT_H */
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 2685538..d84a852 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -29,34 +29,17 @@
 
 #include <mach_ipi.h>
 
-/* This keeps a track of which one is crashing cpu. */
-static int crashing_cpu;
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
-static atomic_t waiting_for_crash_ipi;
 
-static int crash_nmi_callback(struct notifier_block *self,
-			unsigned long val, void *data)
+static void kdump_nmi_callback(int cpu, struct die_args *args)
 {
 	struct pt_regs *regs;
 #ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
 #endif
-	int cpu;
 
-	if (val != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	regs = ((struct die_args *)data)->regs;
-	cpu = raw_smp_processor_id();
-
-	/* Don't do anything if this handler is invoked on crashing cpu.
-	 * Otherwise, system will completely hang. Crashing cpu can get
-	 * an NMI if system was initially booted with nmi_watchdog parameter.
-	 */
-	if (cpu == crashing_cpu)
-		return NOTIFY_STOP;
-	local_irq_disable();
+	regs = args->regs;
 
 #ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
@@ -65,54 +48,19 @@ static int crash_nmi_callback(struct notifier_block *self,
 	}
 #endif
 	crash_save_cpu(regs, cpu);
-	disable_local_APIC();
-	atomic_dec(&waiting_for_crash_ipi);
-	/* Assume hlt works */
-	halt();
-	for (;;)
-		cpu_relax();
-
-	return 1;
-}
 
-static void smp_send_nmi_allbutself(void)
-{
-	cpumask_t mask = cpu_online_map;
-	cpu_clear(safe_smp_processor_id(), mask);
-	if (!cpus_empty(mask))
-		send_IPI_mask(mask, NMI_VECTOR);
+	disable_local_APIC();
 }
 
-static struct notifier_block crash_nmi_nb = {
-	.notifier_call = crash_nmi_callback,
-};
-
-static void nmi_shootdown_cpus(void)
+static void kdump_nmi_shootdown_cpus(void)
 {
-	unsigned long msecs;
-
-	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
-	/* Would it be better to replace the trap vector here? */
-	if (register_die_notifier(&crash_nmi_nb))
-		return;		/* return what? */
-	/* Ensure the new callback function is set before sending
-	 * out the NMI
-	 */
-	wmb();
+	nmi_shootdown_cpus(kdump_nmi_callback);
 
-	smp_send_nmi_allbutself();
-
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
-	}
-
-	/* Leave the nmi callback set */
 	disable_local_APIC();
 }
+
 #else
-static void nmi_shootdown_cpus(void)
+static void kdump_nmi_shootdown_cpus(void)
 {
 	/* There are no cpus to shootdown */
 }
@@ -131,9 +79,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	/* The kernel is broken so disable interrupts */
 	local_irq_disable();
 
-	/* Make a note of crashing cpu. Will be used in NMI callback.*/
-	crashing_cpu = safe_smp_processor_id();
-	nmi_shootdown_cpus();
+	kdump_nmi_shootdown_cpus();
 	lapic_shutdown();
 #if defined(CONFIG_X86_IO_APIC)
 	disable_IO_APIC();
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index 7a38574..37f4200 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -13,6 +13,7 @@
 #include <linux/numa.h>
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
+#include <linux/gfp.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -25,15 +26,6 @@
 #include <asm/system.h>
 #include <asm/cacheflush.h>
 
-#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
-static u32 kexec_pgd[1024] PAGE_ALIGNED;
-#ifdef CONFIG_X86_PAE
-static u32 kexec_pmd0[1024] PAGE_ALIGNED;
-static u32 kexec_pmd1[1024] PAGE_ALIGNED;
-#endif
-static u32 kexec_pte0[1024] PAGE_ALIGNED;
-static u32 kexec_pte1[1024] PAGE_ALIGNED;
-
 static void set_idt(void *newidt, __u16 limit)
 {
 	struct desc_ptr curidt;
@@ -76,6 +68,76 @@ static void load_segments(void)
 #undef __STR
 }
 
+static void machine_kexec_free_page_tables(struct kimage *image)
+{
+	free_page((unsigned long)image->arch.pgd);
+#ifdef CONFIG_X86_PAE
+	free_page((unsigned long)image->arch.pmd0);
+	free_page((unsigned long)image->arch.pmd1);
+#endif
+	free_page((unsigned long)image->arch.pte0);
+	free_page((unsigned long)image->arch.pte1);
+}
+
+static int machine_kexec_alloc_page_tables(struct kimage *image)
+{
+	image->arch.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
+#ifdef CONFIG_X86_PAE
+	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+#endif
+	image->arch.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
+	if (!image->arch.pgd ||
+#ifdef CONFIG_X86_PAE
+	    !image->arch.pmd0 || !image->arch.pmd1 ||
+#endif
+	    !image->arch.pte0 || !image->arch.pte1) {
+		machine_kexec_free_page_tables(image);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void machine_kexec_page_table_set_one(
+	pgd_t *pgd, pmd_t *pmd, pte_t *pte,
+	unsigned long vaddr, unsigned long paddr)
+{
+	pud_t *pud;
+
+	pgd += pgd_index(vaddr);
+#ifdef CONFIG_X86_PAE
+	if (!(pgd_val(*pgd) & _PAGE_PRESENT))
+		set_pgd(pgd, __pgd(__pa(pmd) | _PAGE_PRESENT));
+#endif
+	pud = pud_offset(pgd, vaddr);
+	pmd = pmd_offset(pud, vaddr);
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT))
+		set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+	pte = pte_offset_kernel(pmd, vaddr);
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+}
+
+static void machine_kexec_prepare_page_tables(struct kimage *image)
+{
+	void *control_page;
+	pmd_t *pmd = 0;
+
+	control_page = page_address(image->control_code_page);
+#ifdef CONFIG_X86_PAE
+	pmd = image->arch.pmd0;
+#endif
+	machine_kexec_page_table_set_one(
+		image->arch.pgd, pmd, image->arch.pte0,
+		(unsigned long)control_page, __pa(control_page));
+#ifdef CONFIG_X86_PAE
+	pmd = image->arch.pmd1;
+#endif
+	machine_kexec_page_table_set_one(
+		image->arch.pgd, pmd, image->arch.pte1,
+		__pa(control_page), __pa(control_page));
+}
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -87,12 +149,20 @@ static void load_segments(void)
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Make control page executable.
+ * - Make control page executable.
+ * - Allocate page tables
+ * - Setup page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	int error;
+
 	if (nx_enabled)
 		set_pages_x(image->control_code_page, 1);
+	error = machine_kexec_alloc_page_tables(image);
+	if (error)
+		return error;
+	machine_kexec_prepare_page_tables(image);
 	return 0;
 }
 
@@ -104,6 +174,7 @@ void machine_kexec_cleanup(struct kimage *image)
 {
 	if (nx_enabled)
 		set_pages_nx(image->control_code_page, 1);
+	machine_kexec_free_page_tables(image);
 }
 
 /*
@@ -150,18 +221,7 @@ void machine_kexec(struct kimage *image)
 	relocate_kernel_ptr = control_page;
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
 	page_list[VA_CONTROL_PAGE] = (unsigned long)control_page;
-	page_list[PA_PGD] = __pa(kexec_pgd);
-	page_list[VA_PGD] = (unsigned long)kexec_pgd;
-#ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] = __pa(kexec_pmd0);
-	page_list[VA_PMD_0] = (unsigned long)kexec_pmd0;
-	page_list[PA_PMD_1] = __pa(kexec_pmd1);
-	page_list[VA_PMD_1] = (unsigned long)kexec_pmd1;
-#endif
-	page_list[PA_PTE_0] = __pa(kexec_pte0);
-	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
-	page_list[PA_PTE_1] = __pa(kexec_pte1);
-	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
+	page_list[PA_PGD] = __pa(image->arch.pgd);
 
 	if (image->type == KEXEC_TYPE_DEFAULT)
 		page_list[PA_SWAP_PAGE] = (page_to_pfn(image->swap_page)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 724adfc..c3cd512 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -21,6 +21,9 @@
 # include <asm/iommu.h>
 #endif
 
+#include <mach_ipi.h>
+
+
 /*
  * Power off function, if any
  */
@@ -514,3 +517,95 @@ void machine_crash_shutdown(struct pt_regs *regs)
 	machine_ops.crash_shutdown(regs);
 }
 #endif
+
+
+#if defined(CONFIG_SMP)
+
+/* This keeps a track of which one is crashing cpu. */
+static int crashing_cpu;
+static nmi_shootdown_cb shootdown_callback;
+
+static atomic_t waiting_for_crash_ipi;
+
+static int crash_nmi_callback(struct notifier_block *self,
+			unsigned long val, void *data)
+{
+	int cpu;
+
+	if (val != DIE_NMI_IPI)
+		return NOTIFY_OK;
+
+	cpu = raw_smp_processor_id();
+
+	/* Don't do anything if this handler is invoked on crashing cpu.
+	 * Otherwise, system will completely hang. Crashing cpu can get
+	 * an NMI if system was initially booted with nmi_watchdog parameter.
+	 */
+	if (cpu == crashing_cpu)
+		return NOTIFY_STOP;
+	local_irq_disable();
+
+	shootdown_callback(cpu, (struct die_args *)data);
+
+	atomic_dec(&waiting_for_crash_ipi);
+	/* Assume hlt works */
+	halt();
+	for (;;)
+		cpu_relax();
+
+	return 1;
+}
+
+static void smp_send_nmi_allbutself(void)
+{
+	cpumask_t mask = cpu_online_map;
+	cpu_clear(safe_smp_processor_id(), mask);
+	if (!cpus_empty(mask))
+		send_IPI_mask(mask, NMI_VECTOR);
+}
+
+static struct notifier_block crash_nmi_nb = {
+	.notifier_call = crash_nmi_callback,
+};
+
+/* Halt all other CPUs, calling the specified function on each of them
+ *
+ * This function can be used to halt all other CPUs on crash
+ * or emergency reboot time. The function passed as parameter
+ * will be called inside a NMI handler on all CPUs.
+ */
+void nmi_shootdown_cpus(nmi_shootdown_cb callback)
+{
+	unsigned long msecs;
+	local_irq_disable();
+
+	/* Make a note of crashing cpu. Will be used in NMI callback.*/
+	crashing_cpu = safe_smp_processor_id();
+
+	shootdown_callback = callback;
+
+	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
+	/* Would it be better to replace the trap vector here? */
+	if (register_die_notifier(&crash_nmi_nb))
+		return;		/* return what? */
+	/* Ensure the new callback function is set before sending
+	 * out the NMI
+	 */
+	wmb();
+
+	smp_send_nmi_allbutself();
+
+	msecs = 1000; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
+		mdelay(1);
+		msecs--;
+	}
+
+	/* Leave the nmi callback set */
+}
+#else /* !CONFIG_SMP */
+void nmi_shootdown_cpus(nmi_shootdown_cb callback)
+{
+	/* No other CPUs to shoot down */
+}
+#endif
diff --git a/arch/x86/kernel/relocate_kernel_32.S b/arch/x86/kernel/relocate_kernel_32.S
index 6f50664..a160f31 100644
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -10,15 +10,12 @@
 #include <asm/page.h>
 #include <asm/kexec.h>
 #include <asm/processor-flags.h>
-#include <asm/pgtable.h>
 
 /*
  * Must be relocatable PIC code callable as a C function
  */
 
 #define PTR(x) (x << 2)
-#define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
-#define PAE_PGD_ATTR (_PAGE_PRESENT)
 
 /* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
  * ~ control_page + PAGE_SIZE are used as data storage and stack for
@@ -39,7 +36,6 @@
 #define CP_PA_BACKUP_PAGES_MAP	DATA(0x1c)
 
 	.text
-	.align PAGE_SIZE
 	.globl relocate_kernel
 relocate_kernel:
 	/* Save the CPU context, used for jumping back */
@@ -60,117 +56,6 @@ relocate_kernel:
 	movl	%cr4, %eax
 	movl	%eax, CR4(%edi)
 
-#ifdef CONFIG_X86_PAE
-	/* map the control page at its virtual address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xc0000000, %eax
-	shrl	$27, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PMD_0)(%ebp), %edx
-	orl	$PAE_PGD_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PMD_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x3fe00000, %eax
-	shrl	$18, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_0)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x001ff000, %eax
-	shrl	$9, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	/* identity map the control page at its physical address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xc0000000, %eax
-	shrl	$27, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PMD_1)(%ebp), %edx
-	orl	$PAE_PGD_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PMD_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x3fe00000, %eax
-	shrl	$18, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_1)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x001ff000, %eax
-	shrl	$9, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-#else
-	/* map the control page at its virtual address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xffc00000, %eax
-	shrl	$20, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_0)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_0)(%ebp), %edi
-	movl	PTR(VA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x003ff000, %eax
-	shrl	$10, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	/* identity map the control page at its physical address */
-
-	movl	PTR(VA_PGD)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0xffc00000, %eax
-	shrl	$20, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_PTE_1)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-
-	movl	PTR(VA_PTE_1)(%ebp), %edi
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %eax
-	andl	$0x003ff000, %eax
-	shrl	$10, %eax
-	addl	%edi, %eax
-
-	movl	PTR(PA_CONTROL_PAGE)(%ebp), %edx
-	orl	$PAGE_ATTR, %edx
-	movl	%edx, (%eax)
-#endif
-
-relocate_new_kernel:
 	/* read the arguments and say goodbye to the stack */
 	movl  20+4(%esp), %ebx /* page_list */
 	movl  20+8(%esp), %ebp /* list of pages */
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 17f76fc..adc34f2 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -100,6 +100,10 @@ struct kimage {
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
 	unsigned int preserve_context : 1;
+
+#ifdef ARCH_HAS_KIMAGE_ARCH
+	struct kimage_arch arch;
+#endif
 };
 
 
