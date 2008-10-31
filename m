Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYJaBtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYJaBtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYJaBsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:48:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:45832 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbYJaBsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:48:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,519,1220252400"; 
   d="asc'?scan'208";a="68087896"
Subject: [PATCH 2/3 -v4] kexec/i386: allocate page table pages dynamically
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RZSS+w6s8Fer1IqmyMhS"
Date: Fri, 31 Oct 2008 09:48:08 +0800
Message-Id: <1225417688.24095.137.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RZSS+w6s8Fer1IqmyMhS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patch adds an architecture specific struct kimage_arch into
struct kimage. The pointers to page table pages used by kexec are
added to struct kimage_arch. The page tables pages are dynamically
allocated in machine_kexec_prepare instead of statically from BSS
segment. This will save up to 20k memory when kexec image is not
loaded.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/kexec.h       |   14 +++++++
 arch/x86/kernel/machine_kexec_32.c |   69 +++++++++++++++++++++++++-------=
-----
 include/linux/kexec.h              |    4 ++
 3 files changed, 65 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -13,6 +13,7 @@
 #include <linux/numa.h>
 #include <linux/ftrace.h>
 #include <linux/suspend.h>
+#include <linux/gfp.h>
=20
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -25,15 +26,6 @@
 #include <asm/system.h>
 #include <asm/cacheflush.h>
=20
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
@@ -76,6 +68,37 @@ static void load_segments(void)
 #undef __STR
 }
=20
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
+	image->arch.pgd =3D (pgd_t *)get_zeroed_page(GFP_KERNEL);
+#ifdef CONFIG_X86_PAE
+	image->arch.pmd0 =3D (pmd_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pmd1 =3D (pmd_t *)get_zeroed_page(GFP_KERNEL);
+#endif
+	image->arch.pte0 =3D (pte_t *)get_zeroed_page(GFP_KERNEL);
+	image->arch.pte1 =3D (pte_t *)get_zeroed_page(GFP_KERNEL);
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
 /*
  * A architecture hook called to validate the
  * proposed image and prepare the control pages
@@ -87,13 +110,14 @@ static void load_segments(void)
  * reboot code buffer to allow us to avoid allocations
  * later.
  *
- * Make control page executable.
+ * - Make control page executable.
+ * - Allocate page tables
  */
 int machine_kexec_prepare(struct kimage *image)
 {
 	if (nx_enabled)
 		set_pages_x(image->control_code_page, 1);
-	return 0;
+	return machine_kexec_alloc_page_tables(image);
 }
=20
 /*
@@ -104,6 +128,7 @@ void machine_kexec_cleanup(struct kimage
 {
 	if (nx_enabled)
 		set_pages_nx(image->control_code_page, 1);
+	machine_kexec_free_page_tables(image);
 }
=20
 /*
@@ -150,18 +175,18 @@ void machine_kexec(struct kimage *image)
 	relocate_kernel_ptr =3D control_page;
 	page_list[PA_CONTROL_PAGE] =3D __pa(control_page);
 	page_list[VA_CONTROL_PAGE] =3D (unsigned long)control_page;
-	page_list[PA_PGD] =3D __pa(kexec_pgd);
-	page_list[VA_PGD] =3D (unsigned long)kexec_pgd;
+	page_list[PA_PGD] =3D __pa(image->arch.pgd);
+	page_list[VA_PGD] =3D (unsigned long)image->arch.pgd;
 #ifdef CONFIG_X86_PAE
-	page_list[PA_PMD_0] =3D __pa(kexec_pmd0);
-	page_list[VA_PMD_0] =3D (unsigned long)kexec_pmd0;
-	page_list[PA_PMD_1] =3D __pa(kexec_pmd1);
-	page_list[VA_PMD_1] =3D (unsigned long)kexec_pmd1;
-#endif
-	page_list[PA_PTE_0] =3D __pa(kexec_pte0);
-	page_list[VA_PTE_0] =3D (unsigned long)kexec_pte0;
-	page_list[PA_PTE_1] =3D __pa(kexec_pte1);
-	page_list[VA_PTE_1] =3D (unsigned long)kexec_pte1;
+	page_list[PA_PMD_0] =3D __pa(image->arch.pmd0);
+	page_list[VA_PMD_0] =3D (unsigned long)image->arch.pmd0;
+	page_list[PA_PMD_1] =3D __pa(image->arch.pmd1);
+	page_list[VA_PMD_1] =3D (unsigned long)image->arch.pmd1;
+#endif
+	page_list[PA_PTE_0] =3D __pa(image->arch.pte0);
+	page_list[VA_PTE_0] =3D (unsigned long)image->arch.pte0;
+	page_list[PA_PTE_1] =3D __pa(image->arch.pte1);
+	page_list[VA_PTE_1] =3D (unsigned long)image->arch.pte1;
=20
 	if (image->type =3D=3D KEXEC_TYPE_DEFAULT)
 		page_list[PA_SWAP_PAGE] =3D (page_to_pfn(image->swap_page)
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
=20
=20
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -170,6 +170,20 @@ relocate_kernel(unsigned long indirectio
 		unsigned long start_address) ATTRIB_NORET;
 #endif
=20
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
=20
 #endif /* _ASM_X86_KEXEC_H */


--=-RZSS+w6s8Fer1IqmyMhS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkKY9UACgkQKhFGF+eHlpj2kwCgqfqO7HzoOfVAqOvvNp+u/WVs
oFMAoJby8y7LHDJmHZ9Z9bDWKJBvaKzj
=yUXw
-----END PGP SIGNATURE-----

--=-RZSS+w6s8Fer1IqmyMhS--

