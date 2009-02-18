Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZBROKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZBROKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbZBROJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:09:50 -0500
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:32453
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751242AbZBROJt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:09:49 -0500
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Feb 2009 09:09:49 EST
X-BigFish: VPS-25(zz1432R98dR1805M936fKzzzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KF9LAX-02-21G-01
Date: Wed, 18 Feb 2009 14:54:37 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
Message-ID: <20090218135436.GF8751@amd.com>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-4-git-send-email-joerg.roedel@amd.com> <499C1158.7020401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <499C1158.7020401@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Feb 2009 13:54:36.0922 (UTC) FILETIME=[6FA725A0:01C991D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 01:47:04PM +0000, Avi Kivity wrote:
> Joerg Roedel wrote:
> >Not using __GFP_ZERO when allocating shadow pages triggers the
> >assertion in the kvm_mmu_alloc_page() when MMU debugging is enabled.
> >
> >Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >---
> > arch/x86/kvm/mmu.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >index c90b4b2..d93ecec 100644
> >--- a/arch/x86/kvm/mmu.c
> >+++ b/arch/x86/kvm/mmu.c
> >@@ -301,7 +301,7 @@ static int mmu_topup_memory_cache_page(struct kvm_mmu_memory_cache *cache,
> > 	if (cache->nobjs >= min)
> > 		return 0;
> > 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> >-		page = alloc_page(GFP_KERNEL);
> >+		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > 		if (!page)
> > 			return -ENOMEM;
> > 		set_page_private(page, 0);
> >  
> 
> What is the warning?
> 
> Adding __GFP_ZERO here will cause us to clear the page twice, which is wasteful.

The assertion which the attached patch removes fails sometimes. Removing
this assertion is the alternative solution to this problem ;-)

>From ca45f3a2e45cd7e76ca624bb1098329db8ff83ab Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Wed, 18 Feb 2009 14:51:13 +0100
Subject: [PATCH] kvm mmu: remove assertion in kvm_mmu_alloc_page

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/mmu.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index d93ecec..b226973 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -802,7 +802,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
 	INIT_LIST_HEAD(&sp->oos_link);
-	ASSERT(is_empty_shadow_page(sp->spt));
 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
 	sp->multimapped = 0;
 	sp->parent_pte = parent_pte;
-- 
1.5.6.4

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

