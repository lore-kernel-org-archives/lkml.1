Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZBROK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZBROK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 09:10:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZBROKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 09:10:46 -0500
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:33718
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751910AbZBROKp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 09:10:45 -0500
X-BigFish: VPS-25(zz1432R98dR1805M936fKzzzzz32i6bh43j66h)
X-Spam-TCS-SCL: 5:0
X-FB-SS: 5,
X-WSS-ID: 0KF9M1K-04-G9F-01
Date: Wed, 18 Feb 2009 15:10:17 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kvm mmu: alloc shadow pages with __GFP_ZERO
Message-ID: <20090218141017.GG8751@amd.com>
References: <1234962540-7131-1-git-send-email-joerg.roedel@amd.com> <1234962540-7131-4-git-send-email-joerg.roedel@amd.com> <499C1158.7020401@redhat.com> <20090218135436.GF8751@amd.com> <499C1536.30302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <499C1536.30302@redhat.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Feb 2009 14:10:17.0395 (UTC) FILETIME=[A037F030:01C991D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 18, 2009 at 02:03:34PM +0000, Avi Kivity wrote:
> Joerg Roedel wrote:
> >The assertion which the attached patch removes fails sometimes. Removing
> >this assertion is the alternative solution to this problem ;-)
> >
> >From ca45f3a2e45cd7e76ca624bb1098329db8ff83ab Mon Sep 17 00:00:00 2001
> >From: Joerg Roedel <joerg.roedel@amd.com>
> >Date: Wed, 18 Feb 2009 14:51:13 +0100
> >Subject: [PATCH] kvm mmu: remove assertion in kvm_mmu_alloc_page
> >
> >Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >---
> > arch/x86/kvm/mmu.c |    1 -
> > 1 files changed, 0 insertions(+), 1 deletions(-)
> >
> >diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >index d93ecec..b226973 100644
> >--- a/arch/x86/kvm/mmu.c
> >+++ b/arch/x86/kvm/mmu.c
> >@@ -802,7 +802,6 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
> > 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > 	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> > 	INIT_LIST_HEAD(&sp->oos_link);
> >-	ASSERT(is_empty_shadow_page(sp->spt));
> > 	bitmap_zero(sp->slot_bitmap, KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS);
> > 	sp->multimapped = 0;
> > 	sp->parent_pte = parent_pte;
> >  
> 
> sp->spt is allocated using mmu_memory_cache_alloc(), which zeros the page.  How can the assertion fail?

In the code I see (current kvm-git) mmu_memory_cache_alloc() does zero
nothing. It takes the page from the preallocated pool and returns it.
The pool itself is filled with mmu_topup_memory_caches() which calls
mmu_topup_memory_cache_page() to fill the mmu_page_cache (from which the
sp->spt page is allocated later). And the mmu_topup_memory_cache_page()
function calls alloc_page() and does not zero the result. This let the
assertion trigger.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

