Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbYJWUWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbYJWUWy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYJWUWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:22:46 -0400
Received: from home.keithp.com ([63.227.221.253]:60090 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbYJWUWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:22:45 -0400
Subject: Adding kmap_atomic_prot_pfn  (was: [git pull] drm patches for
	2.6.27-rc1)
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: keithp@keithp.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Dave Airlie <airlied@linux.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, dri-devel@lists.sf.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <20081022093615.GF12453@elte.hu>
References: <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org>
	 <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com>
	 <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com>
	 <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu>
	 <1224450291.5303.23.camel@koto.keithp.com> <20081020115810.GC10594@elte.hu>
	 <1224517744.5195.1.camel@koto.keithp.com>  <20081022093615.GF12453@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zGH5/ji6oyTViakLC458"
Date: Thu, 23 Oct 2008 13:22:12 -0700
Message-Id: <1224793332.22877.8.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zGH5/ji6oyTViakLC458
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

We just ran some numbers on a box with PAT enabled and broken MTRRs.
Finally we have a test platform for the difference between kmap_atomic
and kmap_atomic_prot. Using regular kmap_atomic on this platform, we get
UC access to the graphics device; sending data from the CPU is a bit
slow. Adding kmap_atomic_prot_pfn and specifying WC access raises that
by a fairly significant factor, taking our CPU utilization for
copy_from_user from 40% to 2%.

Here's a patch which adds kmap_atomic_prot_pfn to the kernel for this
usage. When we add native io-mapping support instead of sitting on top
of kmap, we can remove this function.

I've reworked the io_mapping patches to use this function as well, along
with cleaning up the i915 code along the lines of Linus' current
version. I'll post those if this patch looks acceptable.

=46rom e3f633dcb36889fa85ea06cca339072df3c44ae0 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Thu, 23 Oct 2008 11:53:45 -0700
Subject: [PATCH] Add kmap_atomic_prot_pfn

kmap_atomic_prot_pfn is a mixture of kmap_atomic_prot and kmap_atomic_pfn,
accepting both a pfn instead of a page and an explicit protection value.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 arch/x86/mm/highmem_32.c  |   19 +++++++++++++++++++
 include/asm-x86/highmem.h |    1 +
 include/linux/highmem.h   |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index bcc079c..91ae5e8 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -139,6 +139,25 @@ void *kmap_atomic_pfn(unsigned long pfn, enum km_type =
type)
 }
 EXPORT_SYMBOL_GPL(kmap_atomic_pfn); /* temporarily in use by i915 GEM unti=
l vmap */
=20
+/* This is the same as kmap_atomic_prot() but can map memory that doesn't
+ * have a struct page associated with it.
+ */
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t =
prot)
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
+EXPORT_SYMBOL_GPL(kmap_atomic_prot_pfn); /* temporarily in use by i915 GEM=
 until vmap */
+
 struct page *kmap_atomic_to_page(void *ptr)
 {
 	unsigned long idx, vaddr =3D (unsigned long)ptr;
diff --git a/include/asm-x86/highmem.h b/include/asm-x86/highmem.h
index bc3f6a2..a1f8f8c 100644
--- a/include/asm-x86/highmem.h
+++ b/include/asm-x86/highmem.h
@@ -66,6 +66,7 @@ void *kmap_atomic_prot(struct page *page, enum km_type ty=
pe, pgprot_t prot);
 void *kmap_atomic(struct page *page, enum km_type type);
 void kunmap_atomic(void *kvaddr, enum km_type type);
 void *kmap_atomic_pfn(unsigned long pfn, enum km_type type);
+void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t =
prot);
 struct page *kmap_atomic_to_page(void *ptr);
=20
 #ifndef CONFIG_PARAVIRT
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 7dcbc82..7fbee2c 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -55,6 +55,7 @@ static inline void *kmap_atomic(struct page *page, enum k=
m_type idx)
=20
 #define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
+#define kmap_atomic_prot_pfn(pfn, idx, prot) kmap_atomic_prot(pfn_to_page(=
pfn), (idx), (prot))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)
=20
 #define kmap_flush_unused()	do {} while(0)
--=20
1.5.6.5



--=20
keith.packard@intel.com

--=-zGH5/ji6oyTViakLC458
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJANz0Qp8BWwlsTdMRAnhRAKCW6p46FLj+vmzCpA6M2MapGZscVwCgrcgS
TEe8NmDGi0Xg4cghLLzxC1k=
=tkkb
-----END PGP SIGNATURE-----

--=-zGH5/ji6oyTViakLC458--

