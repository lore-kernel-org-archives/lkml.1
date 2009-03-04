Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZCDC6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZCDC6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:58:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZCDC6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:58:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:57697 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbZCDC6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:58:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,298,1233561600"; 
   d="asc'?scan'208";a="435950136"
Subject: EFI x86_64: Back efi_ioremap with init_memory_mapping instead of
	FIX_MAP
From: Huang Ying <ying.huang@intel.com>
To: Brian Maly <bmaly@redhat.com>, mingo@redhat.com,
       Yinghai Lu <yinghai@kernel.org>, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fLMRxTIeYCx7EK/z3FQf"
Date: Wed, 04 Mar 2009 10:58:33 +0800
Message-Id: <1236135513.6204.306.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fLMRxTIeYCx7EK/z3FQf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Impact: Fix boot failing on EFI system with large runtime memory range

Brian Maly reported that some EFI system with large runtime memory
range can not boot. Because the FIX_MAP used to map runtime memory
range is smaller than run time memory range.

This patch fixes this issue by re-implement efi_ioremp with
init_memory_mapping.

Reported-and-tested-by: Brian Maly <bmaly@redhat.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/include/asm/efi.h       |    2 --
 arch/x86/include/asm/fixmap_64.h |    4 ----
 arch/x86/kernel/efi.c            |    7 +++++--
 arch/x86/kernel/efi_64.c         |   21 ++++-----------------
 4 files changed, 9 insertions(+), 25 deletions(-)

--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -467,7 +467,7 @@ void __init efi_enter_virtual_mode(void)
 	efi_memory_desc_t *md;
 	efi_status_t status;
 	unsigned long size;
-	u64 end, systab, addr, npages;
+	u64 end, systab, addr, npages, end_pfn;
 	void *p, *va;
=20
 	efi.systab =3D NULL;
@@ -479,7 +479,10 @@ void __init efi_enter_virtual_mode(void)
 		size =3D md->num_pages << EFI_PAGE_SHIFT;
 		end =3D md->phys_addr + size;
=20
-		if (PFN_UP(end) <=3D max_low_pfn_mapped)
+		end_pfn =3D PFN_UP(end);
+		if (end_pfn <=3D max_low_pfn_mapped
+		    || (end_pfn > (1UL << (32 - PAGE_SHIFT))
+			&& end_pfn <=3D max_pfn_mapped))
 			va =3D __va(md->phys_addr);
 		else
 			va =3D efi_ioremap(md->phys_addr, size);
--- a/arch/x86/kernel/efi_64.c
+++ b/arch/x86/kernel/efi_64.c
@@ -99,24 +99,11 @@ void __init efi_call_phys_epilog(void)
=20
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long si=
ze)
 {
-	static unsigned pages_mapped __initdata;
-	unsigned i, pages;
-	unsigned long offset;
+	unsigned long last_map_pfn;
=20
-	pages =3D PFN_UP(phys_addr + size) - PFN_DOWN(phys_addr);
-	offset =3D phys_addr & ~PAGE_MASK;
-	phys_addr &=3D PAGE_MASK;
-
-	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
+	last_map_pfn =3D init_memory_mapping(phys_addr, phys_addr + size);
+	if ((last_map_pfn << PAGE_SHIFT) < phys_addr + size)
 		return NULL;
=20
-	for (i =3D 0; i < pages; i++) {
-		__set_fixmap(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
-			     phys_addr, PAGE_KERNEL);
-		phys_addr +=3D PAGE_SIZE;
-		pages_mapped++;
-	}
-
-	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
-					     (pages_mapped - pages)) + offset;
+	return (void __iomem *)__va(phys_addr);
 }
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -37,8 +37,6 @@ extern unsigned long asmlinkage efi_call
=20
 #else /* !CONFIG_X86_32 */
=20
-#define MAX_EFI_IO_PAGES	100
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -16,7 +16,6 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
-#include <asm/efi.h>
=20
 /*
  * Here we define all the compile-time 'special' virtual
@@ -43,9 +42,6 @@ enum fixed_addresses {
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END =3D FIX_IO_APIC_BASE_0 + MAX_IO_APICS - 1,
-	FIX_EFI_IO_MAP_LAST_PAGE,
-	FIX_EFI_IO_MAP_FIRST_PAGE =3D FIX_EFI_IO_MAP_LAST_PAGE
-				  + MAX_EFI_IO_PAGES - 1,
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif


--=-fLMRxTIeYCx7EK/z3FQf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmt7lYACgkQKhFGF+eHlpgaygCfbiSB3ipP8tZPxZWRaC+bY61q
ogAAoJxgSsj5lFI+Srau5xeSAILPmJq8
=JmtH
-----END PGP SIGNATURE-----

--=-fLMRxTIeYCx7EK/z3FQf--

