Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbYC1Qmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbYC1Qmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 12:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYC1Qlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 12:41:53 -0400
Received: from mail00.svc.cra.dublin.eircom.net ([159.134.118.16]:34752 "HELO
	mail00.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750963AbYC1Qlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 12:41:52 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, xen-devel@lists.xensource.com,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 2/3] xen: Do not pin/unpin PMD pages
Date: Fri, 28 Mar 2008 16:38:16 +0000
Message-Id: <1206722297-11763-3-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1206722297-11763-2-git-send-email-markmc@redhat.com>
References: <1206722297-11763-1-git-send-email-markmc@redhat.com>
 <1206722297-11763-2-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During process startup, in xen_pgd_pin(), we pin PTE pages
but not PMD pages. If we then later map and unmap using an
otherwise unused PMD page, the unpin in release_pmd() fails
because it wasn't previously pinned.

i.e. with this simple test case:

    int fd = open("/dev/zero", O_RDONLY);
    munmap(mmap((void *)0x40000000, 0x1000_LEN, PROT_READ, MAP_PRIVATE, fd, 0), 0x1000);
    close(fd);

we currently get:

   kernel BUG at arch/x86/xen/enlighten.c:678!
   ...
   EIP is at xen_release_pt+0x79/0xa9
   ...
   Call Trace:
    [<c041da25>] ? __pmd_free_tlb+0x1a/0x75
    [<c047a192>] ? free_pgd_range+0x1d2/0x2b5
    [<c047a2f3>] ? free_pgtables+0x7e/0x93
    [<c047b272>] ? unmap_region+0xb9/0xf5
    [<c047c1bd>] ? do_munmap+0x193/0x1f5
    [<c047c24f>] ? sys_munmap+0x30/0x3f
    [<c0408cce>] ? syscall_call+0x7/0xb
    =======================

and xen complains:

  (XEN) mm.c:2241:d4 Mfn 1cc37 not pinned

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 arch/x86/xen/enlighten.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a6a1b40..0ce225f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -691,8 +691,6 @@ static void xen_alloc_ptpage(struct mm_struct *mm, u32 pfn, unsigned level)
 			make_lowmem_page_readonly(__va(PFN_PHYS(pfn)));
 			if (level == PT_PTE)
 				pin_pagetable_pfn(MMUEXT_PIN_L1_TABLE, pfn);
-			else if (level == PT_PMD)
-				pin_pagetable_pfn(MMUEXT_PIN_L2_TABLE, pfn);
 		} else
 			/* make sure there are no stray mappings of
 			   this page */
@@ -717,7 +715,8 @@ static void xen_release_ptpage(u32 pfn, unsigned level)
 
 	if (PagePinned(page)) {
 		if (!PageHighMem(page)) {
-			pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
+			if (level == PT_PTE)
+				pin_pagetable_pfn(MMUEXT_UNPIN_TABLE, pfn);
 			make_lowmem_page_readwrite(__va(PFN_PHYS(pfn)));
 		}
 	}
-- 
1.5.4.1

