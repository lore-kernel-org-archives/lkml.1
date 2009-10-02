Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZJBBck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZJBBck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZJBBcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:39 -0400
Received: from kroah.org ([198.145.64.141]:32927 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbZJBBch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:08 2009
Message-Id: <20091002012408.283494031@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>, Dave Airlie <airlied@linux.ie>
Subject: [017/136] alpha: AGP update (fixes compile failure)
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=alpha-agp-update.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

commit d68721eb339e9237c11c1fea5f73f86211d14918 upstream.

This brings Alpha AGP platforms in sync with the change to struct
agp_memory (unsigned long *memory => struct page **pages).

Only compile tested (I don't have titan/marvel hardware), but this change
looks pretty straightforward, so hopefully it's ok.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/alpha/kernel/core_marvel.c |    2 +-
 arch/alpha/kernel/core_titan.c  |    2 +-
 arch/alpha/kernel/pci_impl.h    |    2 +-
 arch/alpha/kernel/pci_iommu.c   |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -1016,7 +1016,7 @@ marvel_agp_bind_memory(alpha_agp_info *a
 {
 	struct marvel_agp_aperture *aper = agp->aperture.sysdata;
 	return iommu_bind(aper->arena, aper->pg_start + pg_start, 
-			  mem->page_count, mem->memory);
+			  mem->page_count, mem->pages);
 }
 
 static int 
--- a/arch/alpha/kernel/core_titan.c
+++ b/arch/alpha/kernel/core_titan.c
@@ -680,7 +680,7 @@ titan_agp_bind_memory(alpha_agp_info *ag
 {
 	struct titan_agp_aperture *aper = agp->aperture.sysdata;
 	return iommu_bind(aper->arena, aper->pg_start + pg_start, 
-			  mem->page_count, mem->memory);
+			  mem->page_count, mem->pages);
 }
 
 static int 
--- a/arch/alpha/kernel/pci_impl.h
+++ b/arch/alpha/kernel/pci_impl.h
@@ -198,7 +198,7 @@ extern unsigned long size_for_memory(uns
 
 extern int iommu_reserve(struct pci_iommu_arena *, long, long);
 extern int iommu_release(struct pci_iommu_arena *, long, long);
-extern int iommu_bind(struct pci_iommu_arena *, long, long, unsigned long *);
+extern int iommu_bind(struct pci_iommu_arena *, long, long, struct page **);
 extern int iommu_unbind(struct pci_iommu_arena *, long, long);
 
 
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -880,7 +880,7 @@ iommu_release(struct pci_iommu_arena *ar
 
 int
 iommu_bind(struct pci_iommu_arena *arena, long pg_start, long pg_count, 
-	   unsigned long *physaddrs)
+	   struct page **pages)
 {
 	unsigned long flags;
 	unsigned long *ptes;
@@ -900,7 +900,7 @@ iommu_bind(struct pci_iommu_arena *arena
 	}
 		
 	for(i = 0, j = pg_start; i < pg_count; i++, j++)
-		ptes[j] = mk_iommu_pte(physaddrs[i]);
+		ptes[j] = mk_iommu_pte(page_to_phys(pages[i]));
 
 	spin_unlock_irqrestore(&arena->lock, flags);
 


