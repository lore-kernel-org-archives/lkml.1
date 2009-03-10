Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbZCJC5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbZCJC5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZCJC5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:57:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:5571 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbZCJC5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:57:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,333,1233561600"; 
   d="asc'?scan'208";a="437552772"
Subject: [PATCH -v2 2/3] kexec x86_64: Add identidy map for pages at
	image->start
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-udUuPW9qBnic0uPlM/z3"
Date: Tue, 10 Mar 2009 10:57:04 +0800
Message-Id: <1236653824.24215.132.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-udUuPW9qBnic0uPlM/z3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

kexec x86_64: Add identidy map for pages at image->start

image->start may be outside of 0 ~ max_pfn, for example when jumping
back to original kernel from kexeced kenrel. This patch add identity
map for pages at image->start.

v2:

- fix coding style

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_64.c |   42 ++++++++++++++++++++++++++++++++=
+++++
 1 file changed, 42 insertions(+)

--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -18,6 +18,41 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
=20
+static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
+				unsigned long addr)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	struct page *page;
+	int result =3D -ENOMEM;
+
+	addr &=3D PMD_MASK;
+	pgd +=3D pgd_index(addr);
+	if (!pgd_present(*pgd)) {
+		page =3D kimage_alloc_control_pages(image, 0);
+		if (!page)
+			goto out;
+		pud =3D (pud_t *)page_address(page);
+		memset(pud, 0, PAGE_SIZE);
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+	pud =3D pud_offset(pgd, addr);
+	if (!pud_present(*pud)) {
+		page =3D kimage_alloc_control_pages(image, 0);
+		if (!page)
+			goto out;
+		pmd =3D (pmd_t *)page_address(page);
+		memset(pmd, 0, PAGE_SIZE);
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+	pmd =3D pmd_offset(pud, addr);
+	if (!pmd_present(*pmd))
+		set_pmd(pmd, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
+	result =3D 0;
+out:
+	return result;
+}
+
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
 	unsigned long end_addr;
@@ -155,6 +190,13 @@ static int init_pgtable(struct kimage *i
 	result =3D init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
+	/*
+	 * image->start may be outside 0 ~ max_pfn, for example when
+	 * jump back to original kernel from kexeced kernel
+	 */
+	result =3D init_one_level2_page(image, level4p, image->start);
+	if (result)
+		return result;
 	return init_transition_pgtable(image, level4p);
 }
=20


--=-udUuPW9qBnic0uPlM/z3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm11v0ACgkQKhFGF+eHlpjpKACfeOBEyK1guRDyuS2u+bglT29R
8VwAoJTvs4C1xuAwXByWgQzI0vDoysZH
=4LjU
-----END PGP SIGNATURE-----

--=-udUuPW9qBnic0uPlM/z3--

