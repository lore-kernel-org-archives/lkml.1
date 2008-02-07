Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYBGNv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYBGNv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 08:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYBGNvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 08:51:22 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3235 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752874AbYBGNvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 08:51:21 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.11;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Thu, 7 Feb 2008 14:50:48 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Izik Eidus" <izike@qumranet.com>
cc: "Avi Kivity" <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [PATCH 7/8] MMU: add TDP support to the KVM MMU
Message-ID: <20080207135048.GF6960@amd.com>
References: <1202388465-8657-1-git-send-email-joerg.roedel@amd.com>
 <1202388465-8657-8-git-send-email-joerg.roedel@amd.com>
 <47AB0737.2000206@qumranet.com>
MIME-Version: 1.0
In-Reply-To: <47AB0737.2000206@qumranet.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 07 Feb 2008 13:50:49.0050 (UTC)
 FILETIME=[7218E3A0:01C86990]
X-WSS-ID: 6BB5D3472IW10735031-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 03:27:19PM +0200, Izik Eidus wrote:
> Joerg Roedel wrote:
> >This patch contains the changes to the KVM MMU necessary for support of the
> >Nested Paging feature in AMD Barcelona and Phenom Processors.
> >  
> 
> good patch, it look like things will be very fixable with it
> 
> >Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> >---
> > arch/x86/kvm/mmu.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++--
> > arch/x86/kvm/mmu.h |    6 ++++
> > 2 files changed, 82 insertions(+), 3 deletions(-)
> >
> >diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> >index 5e76963..5304d55 100644
> >--- a/arch/x86/kvm/mmu.c
> >+++ b/arch/x86/kvm/mmu.c
> >@@ -1081,6 +1081,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
> > 	int i;
> > 	gfn_t root_gfn;
> > 	struct kvm_mmu_page *sp;
> >+	int metaphysical = 0;
> >  	root_gfn = vcpu->arch.cr3 >> PAGE_SHIFT;
> > @@ -1089,14 +1090,20 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
> > 		hpa_t root = vcpu->arch.mmu.root_hpa;
> >  		ASSERT(!VALID_PAGE(root));
> >+		if (tdp_enabled)
> >+			metaphysical = 1;
> > 		sp = kvm_mmu_get_page(vcpu, root_gfn, 0,
> >-				      PT64_ROOT_LEVEL, 0, ACC_ALL, NULL, NULL);
> >+				      PT64_ROOT_LEVEL, metaphysical,
> >+				      ACC_ALL, NULL, NULL);
> > 		root = __pa(sp->spt);
> > 		++sp->root_count;
> > 		vcpu->arch.mmu.root_hpa = root;
> > 		return;
> > 	}
> > #endif
> >+	metaphysical = !is_paging(vcpu);
> >+	if (tdp_enabled)
> >+		metaphysical = 1;
> > 	for (i = 0; i < 4; ++i) {
> > 		hpa_t root = vcpu->arch.mmu.pae_root[i];
> > @@ -1110,7 +1117,7 @@ static void mmu_alloc_roots(struct kvm_vcpu *vcpu)
> > 		} else if (vcpu->arch.mmu.root_level == 0)
> > 			root_gfn = 0;
> > 		sp = kvm_mmu_get_page(vcpu, root_gfn, i << 30,
> >-				      PT32_ROOT_LEVEL, !is_paging(vcpu),
> >+				      PT32_ROOT_LEVEL, metaphysical,
> > 				      ACC_ALL, NULL, NULL);
> > 		root = __pa(sp->spt);
> > 		++sp->root_count;
> >@@ -1144,6 +1151,36 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
> > 			     error_code & PFERR_WRITE_MASK, gfn);
> > }
> > +static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
> >+				u32 error_code)
> >  
> 
> you probably mean gpa_t ?

Yes. But the function is assigned to a function pointer. And the type of
that pointer expects gva_t there. So I named the parameter gpa to
describe that a guest physical address is meant there.

> >+{
> >+	struct page *page;
> >+	int r;
> >+
> >+	ASSERT(vcpu);
> >+	ASSERT(VALID_PAGE(vcpu->arch.mmu.root_hpa));
> >+
> >+	r = mmu_topup_memory_caches(vcpu);
> >+	if (r)
> >+		return r;
> >+
> >+	down_read(&current->mm->mmap_sem);
> >+	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> >+	if (is_error_page(page)) {
> >+		kvm_release_page_clean(page);
> >+		up_read(&current->mm->mmap_sem);
> >+		return 1;
> >+	}
> >  
> 
> i dont know if it worth checking it here,
> in the worth case we will map the error page and the host will be safe

Looking at the nonpaging_map function it is the right place to check for
the error page.

Joerg Roedel

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy


