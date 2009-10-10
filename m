Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbZJJBb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbZJJBb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933097AbZJJBb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:31:29 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:52677 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676AbZJJBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:31:28 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Sat, 10 Oct 2009 03:22:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
       Arjan van de Ven <arjan@linux.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cH+zK/FR6KDSHFE"
Message-Id: <200910100322.36857.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX1/4f1SI6dWcJ16NX+cJpiKftc8r1aUZIm7v/gNC
	xr44Zqud+4nPHOTSr+IJ+/7bxn/Q2CnG5QDZKBnetp82C97DrK
	XDW7qpXuej1K5D9RUA9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_cH+zK/FR6KDSHFE
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I've found a problem with X.org not setting up MTRR for the framebuffer 
memory. After I investigated I think this is not a X.org problem, but a kernel 
issue.

X.org uses libpciaccess to map the framebuffer memory. This library opens 
/sys/bus/pci/devices/*/resource0_wc and mmaps the memory. Unfortunately, the 
kernel only enables write combining if PAT is enabled, if it is not, the 
memory is mmapped uncached. But Xorg (respectively libpciaccess) thinks it was 
successfully mapped with write combining enabled and thus does not 
additionally set up MTRR entries.

The corresponding libpciaccess code can be found here:
  http://cgit.freedesktop.org/xorg/lib/libpciaccess/tree/src/linux_sysfs.c#n501

If the kernel behavior is intentional and X.org should always set up MTRR 
entries, why should it use /sys/.../resource0_wc at all? I think there are 2 
possibilities to make the kernel behavior consistent:

 1. The mmap_wc should fail if PAT is not enabled.
    (libpciaccess will then map the framebuffer uncached and set up
     MTRR entries)
 2. Use MTRR to enable write combining if PAT is not available.

In an earlier thread about ioremap_wc, Arjan van de Ven wrote that option 2 is 
preferred over option 1:

    http://lkml.indiana.edu/hypermail/linux/kernel/0805.3/2925.html

So, I've created the attached patch implementing option 2. For me this solves 
the problem with the slow Video playback due to not correctly set up MTRR 
entries.

Kind regards,
Thomas Schlichter

--Boundary-00=_cH+zK/FR6KDSHFE
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-Use-MTRR-for-write-combining-mmap-ioremap-if-PAT-is-.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Use-MTRR-for-write-combining-mmap-ioremap-if-PAT-is-.patch"

=46rom 19fb39061825a0110d1a4feb3f83dfa3f09fb738 Mon Sep 17 00:00:00 2001
=46rom: Thomas Schlichter <thomas.schlichter@web.de>
Date: Thu, 8 Oct 2009 21:24:07 +0200
Subject: [PATCH] Use MTRR for write combining mmap/ioremap if PAT is not av=
ailable

X.org uses libpciaccess which tries to mmap with write combining enabled via
/sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, we
fall back to uncached mmap. Then libpciaccess thinks it succeeded mapping
with write combining anabled and does not set up suited MTRR entries. ;-(

So when falling back to uncached mapping, we better try to set up MTRR
entries automatically. To match this modified PCI mmap behavior, also
ioremap_wc and set_memory_wc are adjusted.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
=2D--
 arch/x86/mm/ioremap.c  |   14 +++++++++-----
 arch/x86/mm/pageattr.c |   10 ++++++++--
 arch/x86/pci/i386.c    |    6 ++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..1a73bbc 100644
=2D-- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -21,6 +21,7 @@
 #include <asm/tlbflush.h>
 #include <asm/pgalloc.h>
 #include <asm/pat.h>
+#include <asm/mtrr.h>
=20
 #include "physaddr.h"
=20
@@ -268,11 +269,14 @@ EXPORT_SYMBOL(ioremap_nocache);
  */
 void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
=2D	if (pat_enabled)
=2D		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
=2D					__builtin_return_address(0));
=2D	else
=2D		return ioremap_nocache(phys_addr, size);
+	if (!pat_enabled) {
+		void __iomem *ret =3D ioremap_nocache(phys_addr, size);
+		if (ret)
+			mtrr_add(phys_addr, size, MTRR_TYPE_WRCOMB, false);
+		return ret;
+	}
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_wc);
=20
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..7f3a85b 100644
=2D-- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -23,6 +23,7 @@
 #include <asm/pgalloc.h>
 #include <asm/proto.h>
 #include <asm/pat.h>
+#include <asm/mtrr.h>
=20
 /*
  * The current flushing context - we pass it instead of 5 arguments:
@@ -1010,8 +1011,13 @@ int set_memory_wc(unsigned long addr, int numpages)
 {
 	int ret;
=20
=2D	if (!pat_enabled)
=2D		return set_memory_uc(addr, numpages);
+	if (!pat_enabled) {
+		ret =3D set_memory_uc(addr, numpages);
+		if (!ret)
+			mtrr_add(__pa(addr), numpages * PAGE_SIZE,
+				 MTRR_TYPE_WRCOMB, false);
+		return ret;
+	}
=20
 	ret =3D reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..06cf678 100644
=2D-- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
=20
 #include <asm/pat.h>
+#include <asm/mtrr.h>
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 #include <asm/io_apic.h>
@@ -301,5 +302,10 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm=
_area_struct *vma,
=20
 	vma->vm_ops =3D &pci_mmap_ops;
=20
+	if (!pat_enabled && write_combine)
+		mtrr_add_page(vma->vm_pgoff,
+			     (vma->vm_end - vma->vm_start) >> PAGE_SHIFT,
+			      MTRR_TYPE_WRCOMB, false);
+
 	return 0;
 }
=2D-=20
1.6.4.4


--Boundary-00=_cH+zK/FR6KDSHFE--
