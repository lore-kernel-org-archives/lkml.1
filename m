Return-Path: <linux-kernel-owner+w=401wt.eu-S932199AbZJNTOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbZJNTOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZJNTOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:14:53 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:42217 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbZJNTOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:14:51 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Wed, 14 Oct 2009 21:14:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Robert Hancock" <hancockrwd@gmail.com>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Tejun Heo" <tj@kernel.org>, x86@kernel.org,
       "Yinghai Lu" <yinghai@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       dri-devel@lists.sourceforge.net, "Ingo Molnar" <mingo@redhat.com>,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       "Thomas Hellstrom" <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <4AD449A702000078000197EE@vpn.id2.novell.com> <200910132329.05152.thomas.schlichter@web.de> <4AD5A4540200007800019CE9@vpn.id2.novell.com>
In-Reply-To: <4AD5A4540200007800019CE9@vpn.id2.novell.com>
MIME-Version: 1.0
X-Length: 10094
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EMi1KkRl1kTToNS"
Message-Id: <200910142114.12433.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX19Pi2jR/5Jr0XRprhQYZ7CAEviEmkBvo4UlunmV
	4IiZSCcV9RW2HctFS1iIvHwN5bAnL11sVFtJ7QxYy4GJ70+1oO
	n1wG7lbqZOqXtclWac4w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_EMi1KkRl1kTToNS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Jan Beulich wrote:
> >>> Thomas Schlichter <thomas.schlichter@web.de> 13.10.09 23:29 >>>
> >No, at least the comments in mtrr_add and mtrr_check state that it is just
> >required that phys_addr and size are multiple of PAGE_SIZE. And I'm not
> > sure if it is always safe to round these up/down to the next PAGE
> > boundary. If it is not, maybe it is better to fail...
> 
> That function isn't the limiting factor, generic_validate_add_page() is
> what you need to look at (plus the spec on how the MTRR ranges are
> calculated by the CPU from the base/mask register pairs).

Yes, you are right. Sorry for not looking into generic_validate_add_page() 
before. Thank you for showing!

I added a function mtrr_add_unaligned() that tries to create as many MTRR 
entries as necessary, beginning with the biggest regions. It does not check 
the return values of each mtrr_add(), nor does it return the indexes of the 
created MTRR entries. So it seems to be only useful with increment=false. Or 
do you have a better idea?

Kind regards,
  Thomas

--Boundary-00=_EMi1KkRl1kTToNS
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0001-Add-new-mtrr_add_unaligned-function.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-Add-new-mtrr_add_unaligned-function.patch"

>From 3708f0f4c729de32445ba13ab16b6268920af0bb Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Wed, 14 Oct 2009 19:25:33 +0200
Subject: [PATCH 1/2] Add new mtrr_add_unaligned function

This function creates multiple MTRR entries for unaligned memory regions.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/include/asm/mtrr.h     |    6 ++++++
 arch/x86/kernel/cpu/mtrr/main.c |   25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mtrr.h b/arch/x86/include/asm/mtrr.h
index 4365ffd..0ad8e68 100644
--- a/arch/x86/include/asm/mtrr.h
+++ b/arch/x86/include/asm/mtrr.h
@@ -116,6 +116,8 @@ extern int mtrr_add(unsigned long base, unsigned long size,
 		    unsigned int type, bool increment);
 extern int mtrr_add_page(unsigned long base, unsigned long size,
 			 unsigned int type, bool increment);
+extern void mtrr_add_unaligned(unsigned long base, unsigned long size,
+			       unsigned int type, bool increment);
 extern int mtrr_del(int reg, unsigned long base, unsigned long size);
 extern int mtrr_del_page(int reg, unsigned long base, unsigned long size);
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
@@ -146,6 +148,10 @@ static inline int mtrr_add_page(unsigned long base, unsigned long size,
 {
     return -ENODEV;
 }
+static inline void mtrr_add_unaligned(unsigned long base, unsigned long size,
+				      unsigned int type, bool increment)
+{
+}
 static inline int mtrr_del(int reg, unsigned long base, unsigned long size)
 {
     return -ENODEV;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..7417ebb 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -487,6 +487,31 @@ int mtrr_add(unsigned long base, unsigned long size, unsigned int type,
 }
 EXPORT_SYMBOL(mtrr_add);
 
+void mtrr_add_unaligned(unsigned long base, unsigned long size,
+			unsigned int type, bool increment)
+{
+	unsigned long ptr1, ptr2, end = base + size;
+
+	// round down size to next power ot two
+	size = __rounddown_pow_of_two(size);
+
+	// accordingly align pointers
+	ptr1 = ptr2 = (base + size - 1) & ~(size - 1);
+
+	while (size >= PAGE_SIZE) {
+		if (ptr1 + size <= end) {
+			mtrr_add(ptr1, size, type, increment);
+			ptr1 += size;
+		}
+		if (base + size <= ptr2) {
+			ptr2 -= size;
+			mtrr_add(ptr2, size, type, increment);
+		}
+		size >>= 1;
+	}
+}
+EXPORT_SYMBOL(mtrr_add_unaligned);
+
 /**
  * mtrr_del_page - delete a memory type region
  * @reg: Register returned by mtrr_add
-- 
1.6.5


--Boundary-00=_EMi1KkRl1kTToNS
Content-Type: text/x-patch;
  charset="iso-8859-1";
  name="0002-Use-MTRR-for-write-combining-mmap-ioremap-if-PAT-is-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0002-Use-MTRR-for-write-combining-mmap-ioremap-if-PAT-is-.patch"

>From 3533b9e66c5144844a0b0864d0f57f43d57aea1a Mon Sep 17 00:00:00 2001
From: Thomas Schlichter <thomas.schlichter@web.de>
Date: Thu, 8 Oct 2009 21:24:07 +0200
Subject: [PATCH 2/2] Use MTRR for write combining mmap/ioremap if PAT is not available

X.org uses libpciaccess which tries to mmap with write combining enabled via
/sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, we
fall back to uncached mmap. Then libpciaccess thinks it succeeded mapping
with write combining anabled and does not set up suited MTRR entries. ;-(

So when falling back to uncached mapping, we better try to set up MTRR
entries automatically. To match this modified PCI mmap behavior, also
ioremap_wc and set_memory_wc are adjusted.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
---
 arch/x86/mm/ioremap.c  |   15 ++++++++++-----
 arch/x86/mm/pageattr.c |   10 ++++++++--
 arch/x86/pci/i386.c    |    6 ++++++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..abe40fa 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -21,6 +21,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
+#include <asm/mtrr.h>
 
 #include "physaddr.h"
 
@@ -268,11 +269,15 @@ EXPORT_SYMBOL(ioremap_nocache);
  */
 void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
-	if (pat_enabled)
-		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
-					__builtin_return_address(0));
-	else
-		return ioremap_nocache(phys_addr, size);
+	if (!pat_enabled) {
+		void __iomem *ret = ioremap_nocache(phys_addr, size);
+		if (ret)
+			mtrr_add_unaligned(phys_addr, size,
+					   MTRR_TYPE_WRCOMB, false);
+		return ret;
+	}
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_wc);
 
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..c25f697 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -23,6 +23,7 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pat.h>
+#include <asm/mtrr.h>
 
 /*
  * The current flushing context - we pass it instead of 5 arguments:
@@ -1010,8 +1011,13 @@ int set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
 
-	if (!pat_enabled)
-		return set_memory_uc(addr, numpages);
+	if (!pat_enabled) {
+		ret = set_memory_uc(addr, numpages);
+		if (!ret)
+			mtrr_add_unaligned(__pa(addr), numpages * PAGE_SIZE,
+					   MTRR_TYPE_WRCOMB, false);
+		return ret;
+	}
 
 	ret = reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..8379e9b 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 
 #include <asm/pat.h>
+#include <asm/mtrr.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 #include <asm/io_apic.h>
@@ -301,5 +302,10 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 
 	vma->vm_ops = &pci_mmap_ops;
 
+	if (!pat_enabled && write_combine)
+		mtrr_add_unaligned(vma->vm_pgoff << PAGE_SHIFT,
+				   vma->vm_end - vma->vm_start,
+				   MTRR_TYPE_WRCOMB, false);
+
 	return 0;
 }
-- 
1.6.5


--Boundary-00=_EMi1KkRl1kTToNS--
