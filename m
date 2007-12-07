Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXLGGJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXLGGJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 01:09:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXLGGJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 01:09:40 -0500
Received: from ozlabs.org ([203.10.76.45]:40990 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXLGGJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 01:09:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18264.58263.818005.757831@cargo.ozlabs.ibm.com>
Date: Fri, 7 Dec 2007 17:09:27 +1100
From: Paul Mackerras <paulus@samba.org>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC][POWERPC] Provide a way to protect 4k subpages when
   using 64k pages
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using 64k pages on 64-bit PowerPC systems makes life difficult for
emulators that are trying to emulate an ISA, such as x86, which use a
smaller page size, since the emulator can no longer use the MMU and
the normal system calls for controlling page protections.  Of course,
the emulator can emulate the MMU by checking and possibly remapping
the address for each memory access in software, but that is pretty
slow.

This patch provides a facility for such programs to control the access
permissions on individual 4k sub-pages of a 64k page.  The idea is
that the emulator supplies an array of protection masks to apply to a
specified range of virtual addresses.  These masks are applied at the
level where hardware PTEs are inserted into the hardware page table
based on the Linux PTEs, so the Linux PTEs are not affected.  Note
that this new mechanism does not allow any access that would otherwise
be prohibited; it can only prohibit accesses that would otherwise be
allowed.  This new facility is only available on 64-bit PowerPC and
only when the kernel is configured for 64k pages.

The masks are supplied using a new subpage_prot system call, which
takes a starting virtual address and length, and a pointer to an array
of protection masks in memory.  The array has a 32-bit word per 64k
page to be protected; each 32-bit word consists of 16 2-bit fields,
for which 0 allows any access (that is otherwise allowed), 1 prevents
write accesses, and 2 or 3 prevent any access.

Implicit in this is that the regions of the address space that are
protected are switched to use 4k hardware pages rather than 64k
hardware pages (on machines with hardware 64k page support).  In fact
the whole process is switched to use 4k hardware pages when the
subpage_prot system call is used, but this could be improved in future
to switch only the affected segments.

I have re-purposed the ioperm system call for this.  The old ioperm
system call never did anything (except return an ENOSYS error) and in
fact never could have actually been useful for anything on the PowerPC
architecture, so nothing ever used it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 232c298..0f5b968 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -340,6 +340,14 @@ config PPC_64K_PAGES
 	  while on hardware with such support, it will be used to map
 	  normal application pages.
 
+config PPC_SUBPAGE_PROT
+	bool "Support setting protections for 4k subpages"
+	depends on PPC_64K_PAGES
+	help
+	  This option adds support for a system call to allow user programs
+	  to set access permissions (read/write, readonly, or no access)
+	  on the 4k subpages of each 64k page.
+
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"
 	depends on PPC64 && SMP
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index c349868..11b4f6d 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -903,6 +903,7 @@ handle_page_fault:
  * the PTE insertion
  */
 12:	bl	.save_nvgprs
+	mr	r5,r3
 	addi	r3,r1,STACK_FRAME_OVERHEAD
 	ld	r4,_DAR(r1)
 	bl	.low_hash_fault
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index 3b1d5dd..5aabf48 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -36,12 +36,14 @@
 #include <linux/file.h>
 #include <linux/init.h>
 #include <linux/personality.h>
+#include <linux/hugetlb.h>
 
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 #include <asm/syscalls.h>
 #include <asm/time.h>
 #include <asm/unistd.h>
+#include <asm/tlbflush.h>
 
 /*
  * sys_ipc() is the de-multiplexer for the SysV IPC calls..
@@ -328,3 +330,174 @@ void do_show_syscall_exit(unsigned long r3)
 {
 	printk(" -> %lx, current=%p cpu=%d\n", r3, current, smp_processor_id());
 }
+
+#ifdef CONFIG_PPC_SUBPAGE_PROT
+/*
+ * Clear the subpage protection map for an address range, allowing
+ * all accesses that are allowed by the pte permissions.
+ */
+static void subpage_prot_clear(unsigned long addr, unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd, *spm;
+	pte_t *pte;
+	u32 *spp;
+	spinlock_t *ptl;
+	int i, nw;
+	unsigned long next, limit;
+
+	down_write(&mm->mmap_sem);
+	for (limit = addr + len; addr < limit; addr = next) {
+		next = pmd_addr_end(addr, limit);
+		pgd = pgd_offset(mm, addr);
+		if (pgd_none(*pgd))
+			continue;	/* can't happen with 3-level tables */
+		pud = pud_offset(pgd, addr);
+		if (pud_none(*pud))
+			continue;
+		pmd = pmd_offset(pud, addr);
+		if (!pmd)
+			continue;
+		for (; addr < next; ++pmd) {
+			spm = pmd + PTRS_PER_PMD;
+			spp = (u32 *) pmd_val(*spm);
+			i = (addr >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+			nw = PTRS_PER_PTE - i;
+			if (addr + (nw << PAGE_SHIFT) > next)
+				nw = (next - addr) >> PAGE_SHIFT;
+			if (!spp) {
+				addr += nw * PAGE_SIZE;
+				continue;
+			}
+
+			/* See if we can dispose of the whole array here */
+			if (nw == PTRS_PER_PTE) {
+				spin_lock(&mm->page_table_lock);
+				pmd_val(*spm) = 0;
+				spin_unlock(&mm->page_table_lock);
+				kfree(spp);
+			} else
+				memset(spp + i, 0, nw * sizeof(u32));
+
+			/* now flush any existing HPTEs for the range */
+			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			arch_enter_lazy_mmu_mode();
+			for (; nw > 0; --nw) {
+				pte_update(mm, addr, pte, 0, 0);
+				addr += PAGE_SIZE;
+				++pte;
+			}
+			arch_leave_lazy_mmu_mode();
+			pte_unmap_unlock(pte - 1, ptl);
+		}
+	}
+	up_write(&mm->mmap_sem);
+}
+
+/*
+ * Copy in a subpage protection map for an address range.
+ * The map has 2 bits per 4k subpage, so 32 bits per 64k page.
+ * Each 2-bit field is 0 to allow any access, 1 to prevent writes,
+ * 2 or 3 to prevent all accesses.
+ * Note that the normal page protections also apply; the subpage
+ * protection mechanism is an additional constraint, so putting 0
+ * in a 2-bit field won't allow writes to a page that is otherwise
+ * write-protected.
+ */
+long sys_subpage_prot(unsigned long addr, unsigned long len, u32 __user *map)
+{
+	struct mm_struct *mm = current->mm;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd, *spm;
+	pte_t *pte;
+	u32 *spp;
+	spinlock_t *ptl;
+	int i, nw;
+	unsigned long next, limit;
+	int err;
+
+	/* Check parameters */
+	if ((addr & ~PAGE_MASK) || (len & ~PAGE_MASK) ||
+	    addr >= TASK_SIZE || len >= TASK_SIZE || addr + len > TASK_SIZE)
+		return -EINVAL;
+
+	if (is_hugepage_only_range(mm, addr, len))
+		return -EINVAL;
+
+	if (!map) {
+		/* Clear out the protection map for the address range */
+		subpage_prot_clear(addr, len);
+		return 0;
+	}
+
+	if (!access_ok(VERIFY_READ, map, (len >> PAGE_SHIFT) * sizeof(u32)))
+		return -EFAULT;
+
+	down_write(&mm->mmap_sem);
+	for (limit = addr + len; addr < limit; ) {
+		pgd = pgd_offset(mm, addr);
+		pud = pud_alloc(mm, pgd, addr);
+		err = -ENOMEM;
+		if (!pud)
+			goto out;	/* can't happen with 3-level tables */
+		pmd = pmd_alloc(mm, pud, addr);
+		if (!pmd)
+			goto out;
+		next = pmd_addr_end(addr, limit);
+		while (addr < next) {
+			local_irq_disable();
+			demote_segment_4k(mm, addr);
+			slb_flush_and_rebolt();
+			local_irq_enable();
+
+			spm = pmd + PTRS_PER_PMD;
+			spp = (u32 *) pmd_val(*spm);
+			if (!spp) {
+				spp = kzalloc(PTRS_PER_PTE * sizeof(u32),
+					      GFP_KERNEL);
+				err = -ENOMEM;
+				if (!spp)
+					goto out;
+				spin_lock(&mm->page_table_lock);
+				if (!pmd_val(*spm))
+					pmd_val(*spm) = (unsigned long) spp;
+				else {
+					kfree(spp);
+					spp = (u32 *) pmd_val(*spm);
+				}
+				spin_unlock(&mm->page_table_lock);
+			}
+			i = (addr >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
+			spp += i;
+			nw = PTRS_PER_PTE - i;
+			if (addr + (nw << PAGE_SHIFT) > next)
+				nw = (next - addr) >> PAGE_SHIFT;
+			err = -EFAULT;
+			if (__copy_from_user(spp, map, nw * sizeof(u32)))
+				goto out;
+			map += nw;
+
+			/* now flush any existing HPTEs for the range */
+			pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+			arch_enter_lazy_mmu_mode();
+			for (; nw > 0; --nw) {
+				pte_update(mm, addr, pte, 0, 0);
+				addr += PAGE_SIZE;
+				++pte;
+			}
+			arch_leave_lazy_mmu_mode();
+			pte_unmap_unlock(pte - 1, ptl);
+			++pmd;
+		}
+	}
+	err = 0;
+ out:
+	up_write(&mm->mmap_sem);
+	return err;
+}
+#else
+cond_syscall(subpage_prot);
+#endif
diff --git a/arch/powerpc/mm/hash_low_64.S b/arch/powerpc/mm/hash_low_64.S
index e935edd..21d2484 100644
--- a/arch/powerpc/mm/hash_low_64.S
+++ b/arch/powerpc/mm/hash_low_64.S
@@ -331,7 +331,8 @@ htab_pte_insert_failure:
  *****************************************************************************/
 
 /* _hash_page_4K(unsigned long ea, unsigned long access, unsigned long vsid,
- *		 pte_t *ptep, unsigned long trap, int local, int ssize)
+ *		 pte_t *ptep, unsigned long trap, int local, int ssize,
+ *		 int subpg_prot)
  */
 
 /*
@@ -429,12 +430,19 @@ END_FTR_SECTION_IFSET(CPU_FTR_1T_SEGMENT)
 	xor	r28,r28,r0		/* hash */
 
 	/* Convert linux PTE bits into HW equivalents */
-4:	andi.	r3,r30,0x1fe		/* Get basic set of flags */
-	xori	r3,r3,HPTE_R_N		/* _PAGE_EXEC -> NOEXEC */
+4:
+#ifdef CONFIG_PPC_SUBPAGE_PROT
+	andc	r10,r30,r10
+	andi.	r3,r10,0x1fe		/* Get basic set of flags */
+	rlwinm	r0,r10,32-9+1,30,30	/* _PAGE_RW -> _PAGE_USER (r0) */
+#else
+	andi.	r3,r30,0x1fe		/* Get basic set of flags */
 	rlwinm	r0,r30,32-9+1,30,30	/* _PAGE_RW -> _PAGE_USER (r0) */
+#endif
+	xori	r3,r3,HPTE_R_N		/* _PAGE_EXEC -> NOEXEC */
 	rlwinm	r4,r30,32-7+1,30,30	/* _PAGE_DIRTY -> _PAGE_USER (r4) */
 	and	r0,r0,r4		/* _PAGE_RW & _PAGE_DIRTY ->r0 bit 30*/
-	andc	r0,r30,r0		/* r0 = pte & ~r0 */
+	andc	r0,r3,r0		/* r0 = pte & ~r0 */
 	rlwimi	r3,r0,32-1,31,31	/* Insert result into PP lsb */
 	ori	r3,r3,HPTE_R_C		/* Always add "C" bit for perf. */
 
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index f09730b..7b62359 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -643,7 +643,7 @@ unsigned int hash_page_do_lazy_icache(unsigned int pp, pte_t pte, int trap)
  * For now this makes the whole process use 4k pages.
  */
 #ifdef CONFIG_PPC_64K_PAGES
-static void demote_segment_4k(struct mm_struct *mm, unsigned long addr)
+void demote_segment_4k(struct mm_struct *mm, unsigned long addr)
 {
 	if (mm->context.user_psize == MMU_PAGE_4K)
 		return;
@@ -654,10 +654,59 @@ static void demote_segment_4k(struct mm_struct *mm, unsigned long addr)
 }
 #endif /* CONFIG_PPC_64K_PAGES */
 
+#ifdef CONFIG_PPC_SUBPAGE_PROT
+/*
+ * This looks up a 2-bit protection code for a 4k subpage of a 64k page.
+ * Userspace sets the subpage permissions using the subpage_prot system call.
+ *
+ * Result is 0: full permissions, _PAGE_RW: read-only,
+ * _PAGE_USER or _PAGE_USER|_PAGE_RW: no access.
+ */
+static int subpage_protection(pgd_t *pgdir, unsigned long ea)
+{
+	u32 spp = 0;
+	pgd_t *pg;
+	pud_t *pu;
+	pmd_t *pm;
+	u32 *p;
+
+	if (is_kernel_addr(ea))
+		return 0;
+	pg = pgdir + pgd_index(ea);
+	if (pgd_none(*pg))
+		return 0;	/* can't happen with 3-level tables */
+	pu = pud_offset(pg, ea);
+	if (pud_none(*pu))
+		return 0;
+	pm = pmd_offset(pu, ea);
+	pm += PTRS_PER_PMD;
+	if (!pmd_val(*pm))
+		return 0;
+
+	/* pick up 32 bits of permissions for this 64k page */
+	p = ((u32 *)pmd_val(*pm)) + ((ea >> PAGE_SHIFT) & (PTRS_PER_PTE - 1));
+	spp = *p;
+
+	/* extract 2-bit bitfield for this 4k subpage */
+	spp >>= 30 - 2 * ((ea >> 12) & 0xf);
+
+	/* turn 0,1,2,3 into combination of _PAGE_USER and _PAGE_RW */
+	spp = ((spp & 2) ? _PAGE_USER : 0) | ((spp & 1) ? _PAGE_RW : 0);
+	return spp;
+}
+
+#else /* CONFIG_PPC_SUBPAGE_PROT */
+static inline int subpage_protection(pgd_t *pgdir, unsigned long ea)
+{
+	return 0;
+}
+#endif
+
 /* Result code is:
  *  0 - handled
  *  1 - normal page fault
  * -1 - critical hash insertion error
+ * -2 - access not permitted by subpage protection mechanism
  */
 int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 {
@@ -808,7 +857,14 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
 		rc = __hash_page_64K(ea, access, vsid, ptep, trap, local, ssize);
 	else
 #endif /* CONFIG_PPC_HAS_HASH_64K */
-		rc = __hash_page_4K(ea, access, vsid, ptep, trap, local, ssize);
+	{
+		int spp = subpage_protection(pgdir, ea);
+		if (access & spp)
+			rc = -2;
+		else
+			rc = __hash_page_4K(ea, access, vsid, ptep, trap,
+					    local, ssize, spp);
+	}
 
 #ifndef CONFIG_PPC_64K_PAGES
 	DBG_LOW(" o-pte: %016lx\n", pte_val(*ptep));
@@ -880,7 +936,8 @@ void hash_preload(struct mm_struct *mm, unsigned long ea,
 		__hash_page_64K(ea, access, vsid, ptep, trap, local, ssize);
 	else
 #endif /* CONFIG_PPC_HAS_HASH_64K */
-		__hash_page_4K(ea, access, vsid, ptep, trap, local, ssize);
+		__hash_page_4K(ea, access, vsid, ptep, trap, local, ssize,
+			       subpage_protection(pgdir, ea));
 
 	local_irq_restore(flags);
 }
@@ -925,19 +982,17 @@ void flush_hash_range(unsigned long number, int local)
  * low_hash_fault is called when we the low level hash code failed
  * to instert a PTE due to an hypervisor error
  */
-void low_hash_fault(struct pt_regs *regs, unsigned long address)
+void low_hash_fault(struct pt_regs *regs, unsigned long address, int rc)
 {
 	if (user_mode(regs)) {
-		siginfo_t info;
-
-		info.si_signo = SIGBUS;
-		info.si_errno = 0;
-		info.si_code = BUS_ADRERR;
-		info.si_addr = (void __user *)address;
-		force_sig_info(SIGBUS, &info, current);
-		return;
-	}
-	bad_page_fault(regs, address, SIGBUS);
+#ifdef CONFIG_PPC_SUBPAGE_PROT
+		if (rc == -2)
+			_exception(SIGSEGV, regs, SEGV_ACCERR, address);
+		else
+#endif
+			_exception(SIGBUS, regs, BUS_ADRERR, address);
+	} else
+		bad_page_fault(regs, address, SIGBUS);
 }
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index 3ef0ad2..88940a3 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -232,3 +232,14 @@ EXPORT_SYMBOL(__ioremap_at);
 EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(__iounmap);
 EXPORT_SYMBOL(__iounmap_at);
+
+#ifdef CONFIG_PPC_SUBPAGE_PROT
+void pmd_clear(pmd_t *pmd)
+{
+	pmd_val(*pmd) = 0;
+	if (pmd_val(pmd[PTRS_PER_PMD])) {
+		kfree((void *)pmd_val(pmd[PTRS_PER_PMD]));
+		pmd_val(pmd[PTRS_PER_PMD]) = 0;
+	}
+}
+#endif /* CONFIG_PPC_SUBPAGE_PROT */
diff --git a/include/asm-powerpc/mmu-hash64.h b/include/asm-powerpc/mmu-hash64.h
index 82328de..351e6e8 100644
--- a/include/asm-powerpc/mmu-hash64.h
+++ b/include/asm-powerpc/mmu-hash64.h
@@ -264,7 +264,7 @@ static inline unsigned long hpt_hash(unsigned long va, unsigned int shift,
 
 extern int __hash_page_4K(unsigned long ea, unsigned long access,
 			  unsigned long vsid, pte_t *ptep, unsigned long trap,
-			  unsigned int local, int ssize);
+			  unsigned int local, int ssize, int subpage_prot);
 extern int __hash_page_64K(unsigned long ea, unsigned long access,
 			   unsigned long vsid, pte_t *ptep, unsigned long trap,
 			   unsigned int local, int ssize);
@@ -277,6 +277,7 @@ extern int hash_huge_page(struct mm_struct *mm, unsigned long access,
 extern int htab_bolt_mapping(unsigned long vstart, unsigned long vend,
 			     unsigned long pstart, unsigned long mode,
 			     int psize, int ssize);
+extern void demote_segment_4k(struct mm_struct *mm, unsigned long addr);
 
 extern void htab_initialize(void);
 extern void htab_initialize_secondary(void);
diff --git a/include/asm-powerpc/pgtable-64k.h b/include/asm-powerpc/pgtable-64k.h
index bd54b77..57430da 100644
--- a/include/asm-powerpc/pgtable-64k.h
+++ b/include/asm-powerpc/pgtable-64k.h
@@ -11,7 +11,11 @@
 
 #ifndef __ASSEMBLY__
 #define PTE_TABLE_SIZE	(sizeof(real_pte_t) << PTE_INDEX_SIZE)
-#define PMD_TABLE_SIZE	(sizeof(pmd_t) << PMD_INDEX_SIZE)
+#ifndef CONFIG_PPC_SUBPAGE_PROT
+# define PMD_TABLE_SIZE	(sizeof(pmd_t) << PMD_INDEX_SIZE)
+#else
+# define PMD_TABLE_SIZE	((sizeof(pmd_t) << PMD_INDEX_SIZE) * 2)
+#endif
 #define PGD_TABLE_SIZE	(sizeof(pgd_t) << PGD_INDEX_SIZE)
 #endif	/* __ASSEMBLY__ */
 
diff --git a/include/asm-powerpc/pgtable-ppc64.h b/include/asm-powerpc/pgtable-ppc64.h
index dd4c26d..a5546e8 100644
--- a/include/asm-powerpc/pgtable-ppc64.h
+++ b/include/asm-powerpc/pgtable-ppc64.h
@@ -192,7 +192,11 @@ static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
 #define	pmd_bad(pmd)		(!is_kernel_addr(pmd_val(pmd)) \
 				 || (pmd_val(pmd) & PMD_BAD_BITS))
 #define	pmd_present(pmd)	(pmd_val(pmd) != 0)
-#define	pmd_clear(pmdp)		(pmd_val(*(pmdp)) = 0)
+#ifndef CONFIG_PPC_SUBPAGE_PROT
+# define pmd_clear(pmdp)	(pmd_val(*(pmdp)) = 0)
+#else
+extern void pmd_clear(pmd_t *pmdp);
+#endif
 #define pmd_page_vaddr(pmd)	(pmd_val(pmd) & ~PMD_MASKED_BITS)
 #define pmd_page(pmd)		virt_to_page(pmd_page_vaddr(pmd))
 
diff --git a/include/asm-powerpc/systbl.h b/include/asm-powerpc/systbl.h
index 11d5383..73f9ab5 100644
--- a/include/asm-powerpc/systbl.h
+++ b/include/asm-powerpc/systbl.h
@@ -104,7 +104,7 @@ COMPAT_SYS_SPU(setpriority)
 SYSCALL(ni_syscall)
 COMPAT_SYS(statfs)
 COMPAT_SYS(fstatfs)
-SYSCALL(ni_syscall)
+SYSCALL(subpage_prot)
 COMPAT_SYS_SPU(socketcall)
 COMPAT_SYS_SPU(syslog)
 COMPAT_SYS_SPU(setitimer)
diff --git a/include/asm-powerpc/unistd.h b/include/asm-powerpc/unistd.h
index 97d82b6..bc7eebc 100644
--- a/include/asm-powerpc/unistd.h
+++ b/include/asm-powerpc/unistd.h
@@ -111,7 +111,7 @@
 #define __NR_profil		 98
 #define __NR_statfs		 99
 #define __NR_fstatfs		100
-#define __NR_ioperm		101
+#define __NR_subpage_prot	101
 #define __NR_socketcall		102
 #define __NR_syslog		103
 #define __NR_setitimer		104
