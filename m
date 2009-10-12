Return-Path: <linux-kernel-owner+w=401wt.eu-S1757769AbZJLT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769AbZJLT4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZJLT4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:56:44 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:43538 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbZJLT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:56:43 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Thomas Hellstrom <thellstrom@vmware.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Mon, 12 Oct 2009 21:45:37 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Jan Beulich <jbeulich@novell.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@jbarnes-g45>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Robert Hancock <hancockrwd@gmail.com>
References: <200910122032.52168.thomas.schlichter@web.de> <4AD380A2.2030101@vmware.com>
In-Reply-To: <4AD380A2.2030101@vmware.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_id40Ka4co7AzpuC"
Message-Id: <200910122145.38067.thomas.schlichter@web.de>
X-Provags-ID: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_id40Ka4co7AzpuC
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Thomas Hellstrom wrote:
> Hi!
> 
> One problem with this patch is that it conflicts with the way graphics
> drivers traditionally handles
> the situation, namely
> 
> 1) Set up mtrr
> 2) Map. If fallback to uncached minus we will still have write-combined
> access.
> 
> I think mtrr-add used in this fashion will typically fail due to the
> alignment constraints. In particular,
> for set_memory_wc() the typical usage pattern is a large number of pages
> in a fragmented physical address space.

Yes, maybe this patch tries to change current behavior too less. Indeed, if 
setting up MTRR entries it simply behaves as today, and userspace does not see 
that write combining is not correctly enabled.

> So if we were to fix the problem with libpciaccess in the kernel, I
> think the best option would be to fail the user-space mapping when we
> can't make it write-combined.

One idea to do this would be the attached patch. It simply returns an error if 
PAT is not available. It does not even try to use MTRR on its own. But maybe 
even better would be to combine both patches to something like this:
 1. try to use PAT
 2. if this fails try to set up MTRR
 3. if this also fails, return error

Kind regards,
  Thomas

--Boundary-00=_id40Ka4co7AzpuC
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-Do-not-mmap-ioremap-uncached-when-WC-is-requested.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Do-not-mmap-ioremap-uncached-when-WC-is-requested.patch"

=46rom afb48e1a1ef035c4580a5ce59a956b54a56a5c18 Mon Sep 17 00:00:00 2001
=46rom: Thomas Schlichter <thomas.schlichter@web.de>
Date: Thu, 8 Oct 2009 00:42:47 +0200
Subject: [PATCH] Do not mmap/ioremap uncached when WC is requested

X.org uses libpciaccess which tries to mmap with write combining enabled via
/sys/bus/pci/devices/*/resource0_wc. Currently, when PAT is not enabled, we
fall back to uncached mmap. Then libpciaccess thinks it succeeded mapping
with write combining anabled and does not set up suited MTRR entries. ;-(

So instead of silently falling back to uncached mapping, we better fail. In
this case libpciaccess mmaps via /sys/bus/pci/devices/*/resource0 and corre=
ctly
sets up MTRR entries.

Aditionally modify ioremap_wc and set_memory_wc to match this behavior.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
=2D--
 arch/x86/mm/ioremap.c  |   10 +++++-----
 arch/x86/mm/pageattr.c |    2 +-
 arch/x86/pci/i386.c    |    6 ++++++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 334e63c..293581e 100644
=2D-- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -268,11 +268,11 @@ EXPORT_SYMBOL(ioremap_nocache);
  */
 void __iomem *ioremap_wc(resource_size_t phys_addr, unsigned long size)
 {
=2D	if (pat_enabled)
=2D		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
=2D					__builtin_return_address(0));
=2D	else
=2D		return ioremap_nocache(phys_addr, size);
+	if (!pat_enabled)
+		return NULL;
+
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_wc);
=20
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index dd38bfb..b1287a9 100644
=2D-- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1011,7 +1011,7 @@ int set_memory_wc(unsigned long addr, int numpages)
 	int ret;
=20
 	if (!pat_enabled)
=2D		return set_memory_uc(addr, numpages);
+		return -EINVAL;
=20
 	ret =3D reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL);
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index b22d13b..cf63f9c 100644
=2D-- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -281,6 +281,12 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm=
_area_struct *vma,
 	if (mmap_state =3D=3D pci_mmap_io)
 		return -EINVAL;
=20
+	/* We cannot mmap write combining (WC) without PAT enabled.
+	 * So better fail and let the user map without WC and use MTRR.
+	 */
+	if (!pat_enabled && write_combine)
+		return -EINVAL;
+
 	prot =3D pgprot_val(vma->vm_page_prot);
 	if (pat_enabled && write_combine)
 		prot |=3D _PAGE_CACHE_WC;
=2D-=20
1.6.4.4


--Boundary-00=_id40Ka4co7AzpuC--
