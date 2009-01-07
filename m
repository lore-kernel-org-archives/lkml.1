Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbZAGCw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbZAGCw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 21:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZAGCws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 21:52:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:43456 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766AbZAGCwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 21:52:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,223,1231142400"; 
   d="asc'?scan'208";a="479513345"
Subject: [PATCH] kexec/x86_64: Use one page table in x86_64 kexec
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8PEc2P9pLPdR2SEpKHOu"
Date: Wed, 07 Jan 2009 10:52:41 +0800
Message-Id: <1231296761.5937.59.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8PEc2P9pLPdR2SEpKHOu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Two page tables are used in current x86_64 kexec implementation. One
is used to jump from kernel virtual address to identity map address,
the other is used to map all physical memory. In fact, on x86_64,
there is no conflict between kernel virtual address space and physical
memory space, so just one page table is sufficient. The page table
pages used to map control page are dynamically allocated to save
memory if kexec image is not loaded. ASM code used to map control page
is replaced by C code too.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/kexec.h         |   27 ++-----
 arch/x86/kernel/machine_kexec_64.c   |   82 +++++++++++++++-------
 arch/x86/kernel/relocate_kernel_64.S |  125 ------------------------------=
-----
 3 files changed, 67 insertions(+), 167 deletions(-)

--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -9,23 +9,8 @@
 # define PAGES_NR		4
 #else
 # define PA_CONTROL_PAGE	0
-# define VA_CONTROL_PAGE	1
-# define PA_PGD			2
-# define VA_PGD			3
-# define PA_PUD_0		4
-# define VA_PUD_0		5
-# define PA_PMD_0		6
-# define VA_PMD_0		7
-# define PA_PTE_0		8
-# define VA_PTE_0		9
-# define PA_PUD_1		10
-# define VA_PUD_1		11
-# define PA_PMD_1		12
-# define VA_PMD_1		13
-# define PA_PTE_1		14
-# define VA_PTE_1		15
-# define PA_TABLE_PAGE		16
-# define PAGES_NR		17
+# define PA_TABLE_PAGE		1
+# define PAGES_NR		2
 #endif
=20
 #ifdef CONFIG_X86_32
@@ -157,9 +142,9 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address) ATTRIB_NORET;
 #endif
=20
-#ifdef CONFIG_X86_32
 #define ARCH_HAS_KIMAGE_ARCH
=20
+#ifdef CONFIG_X86_32
 struct kimage_arch {
 	pgd_t *pgd;
 #ifdef CONFIG_X86_PAE
@@ -169,6 +154,12 @@ struct kimage_arch {
 	pte_t *pte0;
 	pte_t *pte1;
 };
+#else
+struct kimage_arch {
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+};
 #endif
=20
 #endif /* __ASSEMBLY__ */
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -18,15 +18,6 @@
 #include <asm/mmu_context.h>
 #include <asm/io.h>
=20
-#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
-static u64 kexec_pgd[512] PAGE_ALIGNED;
-static u64 kexec_pud0[512] PAGE_ALIGNED;
-static u64 kexec_pmd0[512] PAGE_ALIGNED;
-static u64 kexec_pte0[512] PAGE_ALIGNED;
-static u64 kexec_pud1[512] PAGE_ALIGNED;
-static u64 kexec_pmd1[512] PAGE_ALIGNED;
-static u64 kexec_pte1[512] PAGE_ALIGNED;
-
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
 	unsigned long end_addr;
@@ -107,12 +98,65 @@ out:
 	return result;
 }
=20
+static void free_transition_pgtable(struct kimage *image)
+{
+	free_page((unsigned long)image->arch.pud);
+	free_page((unsigned long)image->arch.pmd);
+	free_page((unsigned long)image->arch.pte);
+}
+
+static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	unsigned long vaddr, paddr;
+	int result =3D -ENOMEM;
+
+	vaddr =3D (unsigned long)relocate_kernel;
+	paddr =3D __pa(page_address(image->control_code_page)+PAGE_SIZE);
+	pgd +=3D pgd_index(vaddr);
+	if (!pgd_present(*pgd)) {
+		pud =3D (pud_t *)get_zeroed_page(GFP_KERNEL);
+		if (!pud)
+			goto err;
+		image->arch.pud =3D pud;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+	pud =3D pud_offset(pgd, vaddr);
+	if (!pud_present(*pud)) {
+		pmd =3D (pmd_t *)get_zeroed_page(GFP_KERNEL);
+		if (!pmd)
+			goto err;
+		image->arch.pmd =3D pmd;
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+	pmd =3D pmd_offset(pud, vaddr);
+	if (!pmd_present(*pmd)) {
+		pte =3D (pte_t *)get_zeroed_page(GFP_KERNEL);
+		if (!pte)
+			goto err;
+		image->arch.pte =3D pte;
+		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+	}
+	pte =3D pte_offset_kernel(pmd, vaddr);
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+	return 0;
+err:
+	free_transition_pgtable(image);
+	return result;
+}
+
=20
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
 	pgd_t *level4p;
+	int result;
 	level4p =3D (pgd_t *)__va(start_pgtable);
-	return init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	result =3D init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	if (result)
+		return result;
+	return init_transition_pgtable(image, level4p);
 }
=20
 static void set_idt(void *newidt, u16 limit)
@@ -174,7 +218,7 @@ int machine_kexec_prepare(struct kimage=20
=20
 void machine_kexec_cleanup(struct kimage *image)
 {
-	return;
+	free_transition_pgtable(image);
 }
=20
 /*
@@ -195,22 +239,6 @@ void machine_kexec(struct kimage *image)
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
=20
 	page_list[PA_CONTROL_PAGE] =3D virt_to_phys(control_page);
-	page_list[VA_CONTROL_PAGE] =3D (unsigned long)relocate_kernel;
-	page_list[PA_PGD] =3D virt_to_phys(&kexec_pgd);
-	page_list[VA_PGD] =3D (unsigned long)kexec_pgd;
-	page_list[PA_PUD_0] =3D virt_to_phys(&kexec_pud0);
-	page_list[VA_PUD_0] =3D (unsigned long)kexec_pud0;
-	page_list[PA_PMD_0] =3D virt_to_phys(&kexec_pmd0);
-	page_list[VA_PMD_0] =3D (unsigned long)kexec_pmd0;
-	page_list[PA_PTE_0] =3D virt_to_phys(&kexec_pte0);
-	page_list[VA_PTE_0] =3D (unsigned long)kexec_pte0;
-	page_list[PA_PUD_1] =3D virt_to_phys(&kexec_pud1);
-	page_list[VA_PUD_1] =3D (unsigned long)kexec_pud1;
-	page_list[PA_PMD_1] =3D virt_to_phys(&kexec_pmd1);
-	page_list[VA_PMD_1] =3D (unsigned long)kexec_pmd1;
-	page_list[PA_PTE_1] =3D virt_to_phys(&kexec_pte1);
-	page_list[VA_PTE_1] =3D (unsigned long)kexec_pte1;
-
 	page_list[PA_TABLE_PAGE] =3D
 	  (unsigned long)__pa(page_address(image->control_code_page));
=20
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -29,122 +29,6 @@ relocate_kernel:
 	 * %rdx start address
 	 */
=20
-	/* map the control page at its virtual address */
-
-	movq	$0x0000ff8000000000, %r10        /* mask */
-	mov	$(39 - 3), %cl                   /* bits to shift */
-	movq	PTR(VA_CONTROL_PAGE)(%rsi), %r11 /* address to map */
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PGD)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PUD_0)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PUD_0)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PMD_0)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PMD_0)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PTE_0)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PTE_0)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	/* identity map the control page at its physical address */
-
-	movq	$0x0000ff8000000000, %r10        /* mask */
-	mov	$(39 - 3), %cl                   /* bits to shift */
-	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r11 /* address to map */
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PGD)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PUD_1)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PUD_1)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PMD_1)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PMD_1)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PTE_1)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PTE_1)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-relocate_new_kernel:
-	/* %rdi indirection_page
-	 * %rsi page_list
-	 * %rdx start address
-	 */
-
 	/* zero out flags, and disable interrupts */
 	pushq $0
 	popfq
@@ -156,9 +40,8 @@ relocate_new_kernel:
 	/* get physical address of page table now too */
 	movq	PTR(PA_TABLE_PAGE)(%rsi), %rcx
=20
-	/* switch to new set of page tables */
-	movq	PTR(PA_PGD)(%rsi), %r9
-	movq	%r9, %cr3
+	/* Switch to the identity mapped page tables */
+	movq	%rcx, %cr3
=20
 	/* setup a new stack at the end of the physical control page */
 	lea	PAGE_SIZE(%r8), %rsp
@@ -194,9 +77,7 @@ identity_mapped:
 	jmp 1f
 1:
=20
-	/* Switch to the identity mapped page tables,
-	 * and flush the TLB.
-	*/
+	/* Flush the TLB (needed?) */
 	movq	%rcx, %cr3
=20
 	/* Do the copies */


--=-8PEc2P9pLPdR2SEpKHOu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklkGPAACgkQKhFGF+eHlpi7CwCfc/l+ZKpK/sAGWXZ3b1cAgO4n
a7gAniXhGQOg6suTX2Tun3xvM37wiI+a
=aAp+
-----END PGP SIGNATURE-----

--=-8PEc2P9pLPdR2SEpKHOu--

