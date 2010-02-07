Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab0BGTWW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 14:22:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab0BGTWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 14:22:20 -0500
Date: Sun, 7 Feb 2010 16:41:33 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, David Woodhouse <dwmw2@infradead.org>,
       kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] kvm: Change kvm_iommu_map_pages to map large pages
Message-ID: <20100207184133.GA3387@amt.cnet>
References: <1264678682-30655-1-git-send-email-joerg.roedel@amd.com>
 <1264678682-30655-7-git-send-email-joerg.roedel@amd.com>
 <20100128222455.GA26274@amt.cnet>
 <4B6EAF8B.9090707@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B6EAF8B.9090707@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 07, 2010 at 02:18:19PM +0200, Avi Kivity wrote:
> On 01/29/2010 12:24 AM, Marcelo Tosatti wrote:
> >On Thu, Jan 28, 2010 at 12:37:57PM +0100, Joerg Roedel wrote:
> >>This patch changes the implementation of of
> >>kvm_iommu_map_pages to map the pages with the host page size
> >>into the io virtual address space.
> >>
> >>Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >>---
> >>  virt/kvm/iommu.c |  106 ++++++++++++++++++++++++++++++++++++++++++-----------
> >>  1 files changed, 84 insertions(+), 22 deletions(-)
> >>
> >>diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> >>index 65a5143..92a434d 100644
> >>--- a/virt/kvm/iommu.c
> >>+++ b/virt/kvm/iommu.c
> >>@@ -32,12 +32,27 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
> >>  static void kvm_iommu_put_pages(struct kvm *kvm,
> >>  				gfn_t base_gfn, unsigned long npages);
> >>
> >>+static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
> >>+			   gfn_t gfn, unsigned long size)
> >>+{
> >>+	gfn_t end_gfn;
> >>+	pfn_t pfn;
> >>+
> >>+	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
> >If gfn_to_pfn_memslot returns pfn of bad_page, you might create a
> >large iommu translation for it?
> 
> How could it return a bad_page?  The whole thing is called for a valid slot.

Userspace can pass a valid slot with a read-only vma, for example.
