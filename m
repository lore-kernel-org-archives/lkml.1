Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYJXGXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYJXGXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYJXGWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:22:55 -0400
Received: from home.keithp.com ([63.227.221.253]:46861 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbYJXGWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:22:54 -0400
Subject: Re: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keithp@keithp.com, nickpiggin@yahoo.com.au, airlied@linux.ie,
       Peter Anvin <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net,
       Andrew Morton <akpm@linux-foundation.org>, yinghai@kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com> <20081022093615.GF12453@elte.hu>
	 <1224793332.22877.8.camel@koto.keithp.com>
	 <20081023133840.d4eef579.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0810231424220.3287@nehalem.linux-foundation.org>
	 <1224813015.22877.51.camel@koto.keithp.com>
	 <alpine.LFD.2.00.0810231934590.3287@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ji54KZO4Mj2SbnOjReyV"
Date: Thu, 23 Oct 2008 23:22:39 -0700
Message-Id: <1224829359.22877.86.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ji54KZO4Mj2SbnOjReyV
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 19:48 -0700, Linus Torvalds wrote:

> So I would suspect that if you guys actually write a patch, and make sure=
=20
> that it works on x86-32 even _without_ CONFIG_HIGHMEM, and send it to=20
> Ingo, good things will happen.

Something like the following (yes, I know, this is missing the
include/asm-x86 rename)?

=46rom e7921809c72f940295311cfa6c300d5234ac96c1 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Thu, 23 Oct 2008 23:17:40 -0700
Subject: [PATCH] [x86_32] Add io_map_atomic using fixmaps

This steals the code used for CONFIG_HIGHMEM memory mappings except that
it's designed for dynamic io resource mapping. These fixmaps are available
even with CONFIG_HIGHMEM turned off.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 arch/x86/mm/Makefile        |    2 +-
 arch/x86/mm/init_32.c       |    3 +-
 arch/x86/mm/iomap_32.c      |   59 +++++++++++++++++++++++++++++++++++++++=
++++
 include/asm-x86/fixmap.h    |    4 +++
 include/asm-x86/fixmap_32.h |    4 ---
 include/asm-x86/highmem.h   |    8 +++---
 include/asm-x86/iomap.h     |   30 ++++++++++++++++++++++
 include/linux/io-mapping.h  |   15 +++-------
 8 files changed, 104 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/mm/iomap_32.c
 create mode 100644 include/asm-x86/iomap.h

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 59f89b4..fea4565 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,7 +1,7 @@
 obj-y	:=3D  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o gup.o
=20
-obj-$(CONFIG_X86_32)		+=3D pgtable_32.o
+obj-$(CONFIG_X86_32)		+=3D pgtable_32.o iomap_32.o
=20
 obj-$(CONFIG_HUGETLB_PAGE)	+=3D hugetlbpage.o
 obj-$(CONFIG_X86_PTDUMP)	+=3D dump_pagetables.o
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8396868..c483f42 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -334,7 +334,6 @@ int devmem_is_allowed(unsigned long pagenr)
 	return 0;
 }
=20
-#ifdef CONFIG_HIGHMEM
 pte_t *kmap_pte;
 pgprot_t kmap_prot;
=20
@@ -357,6 +356,7 @@ static void __init kmap_init(void)
 	kmap_prot =3D PAGE_KERNEL;
 }
=20
+#ifdef CONFIG_HIGHMEM
 static void __init permanent_kmaps_init(pgd_t *pgd_base)
 {
 	unsigned long vaddr;
@@ -436,7 +436,6 @@ static void __init set_highmem_pages_init(void)
 #endif /* !CONFIG_NUMA */
=20
 #else
-# define kmap_init()				do { } while (0)
 # define permanent_kmaps_init(pgd_base)		do { } while (0)
 # define set_highmem_pages_init()	do { } while (0)
 #endif /* CONFIG_HIGHMEM */
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
new file mode 100644
index 0000000..c559599
--- /dev/null
+++ b/arch/x86/mm/iomap_32.c
@@ -0,0 +1,59 @@
+/*
+ * Copyright =C2=A9 2008 Keith Packard <keithp@keithp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <asm/iomap.h>
+#include <linux/module.h>
+
+/* Map 'pfn' using fixed map 'type' and protections 'prot'
+ */
+void *
+iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
+{
+	enum fixed_addresses idx;
+	unsigned long vaddr;
+
+	pagefault_disable();
+
+	idx =3D type + KM_TYPE_NR*smp_processor_id();
+	vaddr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
+	arch_flush_lazy_mmu_mode();
+
+	return (void*) vaddr;
+}
+EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
+
+void
+iounmap_atomic(void *kvaddr, enum km_type type)
+{
+	unsigned long vaddr =3D (unsigned long) kvaddr & PAGE_MASK;
+	enum fixed_addresses idx =3D type + KM_TYPE_NR*smp_processor_id();
+
+	/*
+	 * Force other mappings to Oops if they'll try to access this pte
+	 * without first remap it.  Keeping stale mappings around is a bad idea
+	 * also, in case the page changes cacheability attributes or becomes
+	 * a protected page in a hypervisor.
+	 */
+	if (vaddr =3D=3D __fix_to_virt(FIX_KMAP_BEGIN+idx))
+		kpte_clear_flush(kmap_pte-idx, vaddr);
+
+	arch_flush_lazy_mmu_mode();
+	pagefault_enable();
+}
+EXPORT_SYMBOL_GPL(iounmap_atomic);
diff --git a/include/asm-x86/fixmap.h b/include/asm-x86/fixmap.h
index 78e33a1..a8b4379 100644
--- a/include/asm-x86/fixmap.h
+++ b/include/asm-x86/fixmap.h
@@ -9,6 +9,10 @@
=20
 extern int fixmaps_set;
=20
+extern pte_t *kmap_pte;
+extern pgprot_t kmap_prot;
+extern pte_t *pkmap_page_table;
+
 void __native_set_fixmap(enum fixed_addresses idx, pte_t pte);
 void native_set_fixmap(enum fixed_addresses idx,
 		       unsigned long phys, pgprot_t flags);
diff --git a/include/asm-x86/fixmap_32.h b/include/asm-x86/fixmap_32.h
index 8844002..97c2976 100644
--- a/include/asm-x86/fixmap_32.h
+++ b/include/asm-x86/fixmap_32.h
@@ -28,10 +28,8 @@ extern unsigned long __FIXADDR_TOP;
 #include <asm/acpi.h>
 #include <asm/apicdef.h>
 #include <asm/page.h>
-#ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
-#endif
=20
 /*
  * Here we define all the compile-time 'special' virtual
@@ -75,10 +73,8 @@ enum fixed_addresses {
 #ifdef CONFIG_X86_CYCLONE_TIMER
 	FIX_CYCLONE_TIMER, /*cyclone timer register*/
 #endif
-#ifdef CONFIG_HIGHMEM
 	FIX_KMAP_BEGIN,	/* reserved pte's for temporary kernel mappings */
 	FIX_KMAP_END =3D FIX_KMAP_BEGIN+(KM_TYPE_NR*NR_CPUS)-1,
-#endif
 #ifdef CONFIG_PCI_MMCONFIG
 	FIX_PCIE_MCFG,
 #endif
diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index a1f8f8c..d728928 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -4,6 +4,9 @@
  * Used in CONFIG_HIGHMEM systems for memory pages which
  * are not addressable by direct kernel virtual addresses.
  *
+ * Used in other 32-bit systems for io pages which are not
+ * in the direct kernel virtual map
+ *
  * Copyright (C) 1999 Gerhard Wichert, Siemens AG
  *		      Gerhard.Wichert@pdb.siemens.de
  *
@@ -25,14 +28,11 @@
 #include <asm/kmap_types.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
+#include <asm/fixmap.h>
=20
 /* declarations for highmem.c */
 extern unsigned long highstart_pfn, highend_pfn;
=20
-extern pte_t *kmap_pte;
-extern pgprot_t kmap_prot;
-extern pte_t *pkmap_page_table;
-
 /*
  * Right now we initialize only a single pte table. It can be extended
  * easily, subsequent pte tables have to be allocated in one physical
diff --git a/include/asm-x86/iomap.h b/include/asm-x86/iomap.h
new file mode 100644
index 0000000..33b8180
--- /dev/null
+++ b/include/asm-x86/iomap.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright =C2=A9 2008 Keith Packard <keithp@keithp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ */
+
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <asm/cacheflush.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+
+void *
+iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)=
;
+
+void
+iounmap_atomic(void *kvaddr, enum km_type type);
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index bd1dc4f..a7e0d98 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -75,6 +75,9 @@ io_mapping_unmap(void *vaddr)
 #endif /* CONFIG_X86_64 */
=20
 #ifdef CONFIG_X86_32
+
+#include <asm/iomap.h>
+
 static inline struct io_mapping *
 io_mapping_create_wc(unsigned long base, unsigned long size)
 {
@@ -91,22 +94,14 @@ static inline void *
 io_mapping_map_atomic_wc(struct io_mapping *mapping, unsigned long offset)
 {
 	offset +=3D (unsigned long) mapping;
-#ifdef CONFIG_HIGHMEM
-	return kmap_atomic_prot_pfn(offset >> PAGE_SHIFT, KM_USER0,
+	return iomap_atomic_prot_pfn(offset >> PAGE_SHIFT, KM_USER0,
 				    __pgprot(__PAGE_KERNEL_WC));
-#else
-	return ioremap_wc(offset, PAGE_SIZE);
-#endif
 }
=20
 static inline void
 io_mapping_unmap_atomic(void *vaddr)
 {
-#ifdef CONFIG_HIGHMEM
-	kunmap_atomic(vaddr, KM_USER0);
-#else
-	iounmap(vaddr);
-#endif
+	iounmap_atomic(vaddr, KM_USER0);
 }
=20
 static inline void *
--=20
1.5.6.5


--=20
keith.packard@intel.com

--=-ji54KZO4Mj2SbnOjReyV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJAWmvQp8BWwlsTdMRAvUfAJ432cIOWsyNwIzqi2FLhLhMpBsDMACeKq2i
diB2DNmiSPRCVdKe8fTYPto=
=PIsU
-----END PGP SIGNATURE-----

--=-ji54KZO4Mj2SbnOjReyV--

