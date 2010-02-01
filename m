Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0BAOS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:18:27 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:8329 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753860Ab0BAOSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:18:25 -0500
X-SpamScore: -13
X-BigFish: VPS-13(z1857rz146fKab9bh1432R98dN936eMzz1202hzzz32i6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KX62E4-01-9V3-02
X-M-MSG: 
Date: Mon, 1 Feb 2010 15:18:04 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Joerg Roedel <joro@8bytes.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large
 pages
Message-ID: <20100201141804.GD16236@amd.com>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
 <20100128222455.GA26274@amt.cnet>
 <20100129093233.GU17809@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100129093233.GU17809@8bytes.org>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 01 Feb 2010 14:18:04.0872 (UTC) FILETIME=[5E9C4480:01CAA349]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 10:32:33AM +0100, Joerg Roedel wrote:
> On Thu, Jan 28, 2010 at 08:24:55PM -0200, Marcelo Tosatti wrote:
> > On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
> > > +static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> > > +			   gfn_t gfn, unsigned long size)
> > > +{
> > > +	gfn_t end_gfn;
> > > +	pfn_t pfn;
> > > +
> > > +	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
> > 
> > If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
> > large iommu translation for it?
> 
> Right. But that was broken even before this patch. Anyway, I will fix
> it.
> 
> > > +		/* Map into IO address space */
> > > +		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
> > > +			      get_order(page_size), flags);
> > > +
> > > +		gfn += page_size >> PAGE_SHIFT;
> > 
> > Should increase gfn after checking for failure, otherwise wrong
> > npages is passed to kvm_iommu_put_pages.
> 
> True. Will fix that too.

Here is the updated patch (also updated in the iommu/largepage branch of
my tree). Does it look ok?

>From fa921fe46a92dadf7f66391b519cb9ca92e2ee83 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 11 Jan 2010 16:38:18 +0100
Subject: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages

This patch changes the implementation of of
kvm_iommu_map_pages to map the pages with the host page size
into the io virtual address space.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 virt/kvm/iommu.c |  113 +++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 91 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 65a5143..f78286e 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -32,12 +32,30 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
+static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn, unsigned long size)
+{
+	gfn_t end_gfn;
+	pfn_t pfn;
+
+	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
+	end_gfn = gfn + (size >> PAGE_SHIFT);
+	gfn    += 1;
+
+	if (is_error_pfn(pfn))
+		return pfn;
+
+	while (gfn < end_gfn)
+		gfn_to_pfn_memslot(kvm, slot, gfn++);
+
+	return pfn;
+}
+
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	gfn_t gfn = slot->base_gfn;
-	unsigned long npages = slot->npages;
+	gfn_t gfn, end_gfn;
 	pfn_t pfn;
-	int i, r = 0;
+	int r = 0;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int flags;
 
@@ -45,31 +63,62 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 	if (!domain)
 		return 0;
 
+	gfn     = slot->base_gfn;
+	end_gfn = gfn + slot->npages;
+
 	flags = IOMMU_READ | IOMMU_WRITE;
 	if (kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY)
 		flags |= IOMMU_CACHE;
 
-	for (i = 0; i < npages; i++) {
-		/* check if already mapped */
-		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn)))
+
+	while (gfn < end_gfn) {
+		unsigned long page_size;
+
+		/* Check if already mapped */
+		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn))) {
+			gfn += 1;
+			continue;
+		}
+
+		/* Get the page size we could use to map */
+		page_size = kvm_host_page_size(kvm, gfn);
+
+		/* Make sure the page_size does not exceed the memslot */
+		while ((gfn + (page_size >> PAGE_SHIFT)) > end_gfn)
+			page_size >>= 1;
+
+		/* Make sure gfn is aligned to the page size we want to map */
+		while ((gfn << PAGE_SHIFT) & (page_size - 1))
+			page_size >>= 1;
+
+		/*
+		 * Pin all pages we are about to map in memory. This is
+		 * important because we unmap and unpin in 4kb steps later.
+		 */
+		pfn = kvm_pin_pages(kvm, slot, gfn, page_size);
+		if (is_error_pfn(pfn)) {
+			gfn += 1;
 			continue;
+		}
 
-		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
-		r = iommu_map_range(domain,
-				    gfn_to_gpa(gfn),
-				    pfn_to_hpa(pfn),
-				    PAGE_SIZE, flags);
+		/* Map into IO address space */
+		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
+			      get_order(page_size), flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%lx\n", pfn);
 			goto unmap_pages;
 		}
-		gfn++;
+
+		gfn += page_size >> PAGE_SHIFT;
+
+
 	}
+
 	return 0;
 
 unmap_pages:
-	kvm_iommu_put_pages(kvm, slot->base_gfn, i);
+	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn);
 	return r;
 }
 
@@ -186,27 +235,47 @@ out_unmap:
 	return r;
 }
 
+static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npages)
+{
+	unsigned long i;
+
+	for (i = 0; i < npages; ++i)
+		kvm_release_pfn_clean(pfn + i);
+}
+
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages)
 {
-	gfn_t gfn = base_gfn;
+	struct iommu_domain *domain;
+	gfn_t end_gfn, gfn;
 	pfn_t pfn;
-	struct iommu_domain *domain = kvm->arch.iommu_domain;
-	unsigned long i;
 	u64 phys;
 
+	domain  = kvm->arch.iommu_domain;
+	end_gfn = base_gfn + npages;
+	gfn     = base_gfn;
+
 	/* check if iommu exists and in use */
 	if (!domain)
 		return;
 
-	for (i = 0; i < npages; i++) {
+	while (gfn < end_gfn) {
+		unsigned long unmap_pages;
+		int order;
+
+		/* Get physical address */
 		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
-		pfn = phys >> PAGE_SHIFT;
-		kvm_release_pfn_clean(pfn);
-		gfn++;
-	}
+		pfn  = phys >> PAGE_SHIFT;
+
+		/* Unmap address from IO address space */
+		order       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
+		unmap_pages = 1ULL << order;
 
-	iommu_unmap_range(domain, gfn_to_gpa(base_gfn), PAGE_SIZE * npages);
+		/* Unpin all pages we just unmapped to not leak any memory */
+		kvm_unpin_pages(kvm, pfn, unmap_pages);
+
+		gfn += unmap_pages;
+	}
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
-- 
1.6.6


