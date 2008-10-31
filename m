Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbYJaBta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbYJaBta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755431AbYJaBsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:48:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:34856 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483AbYJaBsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:48:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,519,1220252400"; 
   d="asc'?scan'208";a="633642088"
Subject: [PATCH 3/3 -v4] kexec/i386: setup kexec page table in C
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QyMdk2pS9MvxQveb15AA"
Date: Fri, 31 Oct 2008 09:48:15 +0800
Message-Id: <1225417695.24095.138.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QyMdk2pS9MvxQveb15AA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch transforms the kexec page tables setup code from assembler
code to C code in machine_kexec_prepare. This improves readability and
reduces code line number.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/kexec.h         |   17 -----
 arch/x86/kernel/machine_kexec_32.c   |   59 ++++++++++++++----
 arch/x86/kernel/relocate_kernel_32.S |  114 ------------------------------=
-----
 3 files changed, 49 insertions(+), 141 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -99,6 +99,45 @@ static int machine_kexec_alloc_page_tabl
 	return 0;
 }
=20
+static void machine_kexec_page_table_set_one(
+	pgd_t *pgd, pmd_t *pmd, pte_t *pte,
+	unsigned long vaddr, unsigned long paddr)
+{
+	pud_t *pud;
+
+	pgd +=3D pgd_index(vaddr);
+#ifdef CONFIG_X86_PAE
+	if (!(pgd_val(*pgd) & _PAGE_PRESENT))
+		set_pgd(pgd, __pgd(__pa(pmd) | _PAGE_PRESENT));
+#endif
+	pud =3D pud_offset(pgd, vaddr);
+	pmd =3D pmd_offset(pud, vaddr);
+	if (!(pmd_val(*pmd) & _PAGE_PRESENT))
+		set_pmd(pmd, __pmd(__pa(pte) | _PAGE_TABLE));
+	pte =3D pte_offset_kernel(pmd, vaddr);
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+}
+
+static void machine_kexec_prepare_page_tables(struct kimage *image)
+{
+	void *control_page;
+	pmd_t *pmd =3D 0;
+
+	control_page =3D page_address(image->control_code_page);
+#ifdef CONFIG_X86_PAE
+	pmd =3D image->arch.pmd0;
+#endif
+	machine_kexec_page_table_set_one(
+		image->arch.pgd, pmd, image->arch.pte0,
+		(unsigned long)control_page, __pa(control_page));
+#ifdef CONFIG_X86_PAE
+	pmd =3D image->arch.pmd1;
+#endif
+	machine_kexec_page_table_set_one(
+		image->arch.pgd, pmd, image->arch.pte1,
+		__pa(control_page), __pa(control_page));
+}
+
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -112,12 +151,19 @@ static int machine_kexec_alloc_page_tabl
  *
  * - Make control page executable.
  * - Allocate page tables
+ * - Setup page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
+	int error;
+
 	if (nx_enabled)
 		set_pages_x(image->control_code_page, 1);
-	return machine_kexec_alloc_page_tables(image);
+	error =3D machine_kexec_alloc_page_tables(image);
+	if (error)
+		return error;
+	machine_kexec_prepare_page_tables(image);
+	return 0;
 }
=20
 /*
@@ -176,17 +222,6 @@ void machine_kexec(struct kimage *image)
 	page_list[PA_CONTROL_PAGE] =3D __pa(control_page);
 	page_list[VA_CONTROL_PAGE] =3D (unsigned long)control_page;
 	page_list[PA_PGD] =3D __pa(image->arch.pgd);
-	page_list[VA_PGD] =3D (unsigned long)image->arch.pgd;
-#ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] =3D __pa(image->arch.pmd0);
-	page_list[VA_PMD_0] =3D (unsigned long)image->arch.pmd0;
-	page_list[PA_PMD_1] =3D __pa(image->arch.pmd1);
-	page_list[VA_PMD_1] =3D (unsigned long)image->arch.pmd1;
-#endif
-	page_list[PA_PTE_0] =3D __pa(image->arch.pte0);
-	page_list[VA_PTE_0] =3D (unsigned long)image->arch.pte0;
-	page_list[PA_PTE_1] =3D __pa(image->arch.pte1);
-	page_list[VA_PTE_1] =3D (unsigned long)image->arch.pte1;
=20
 	if (image->type =3D=3D KEXEC_TYPE_DEFAULT)
 		page_list[PA_SWAP_PAGE] =3D (page_to_pfn(image->swap_page)
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -10,15 +10,12 @@
 #include <asm/page.h>
 #include <asm/kexec.h>
 #include <asm/processor-flags.h>
-#include <asm/pgtable.h>
=20
 /*
  * Must be relocatable PIC code callable as a C function
  */
=20
 #define PTR(x) (x << 2)
-#define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY=
)
-#define PAE_PGD_ATTR (_PAGE_PRESENT)
=20
 /* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
  * ~ control_page + PAGE_SIZE are used as data storage and stack for
@@ -59,117 +56,6 @@ relocate_kernel:
 	movl	%cr4, %eax
 	movl	%eax, CR4(%edi)
=20
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


--=-QyMdk2pS9MvxQveb15AA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkKY9sACgkQKhFGF+eHlpikCwCfV0DEsrmpznhnPGoPDxERWrGM
OHAAoJt53vY0cSbJYb7asJTfT6OAy5Wd
=GMle
-----END PGP SIGNATURE-----

--=-QyMdk2pS9MvxQveb15AA--

