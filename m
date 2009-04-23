Return-Path: <linux-kernel-owner+w=401wt.eu-S1759521AbZDWHug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759521AbZDWHug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757225AbZDWHd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:29 -0400
Received: from sous-sol.org ([216.99.217.87]:50920 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757224AbZDWHd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:28 -0400
Message-Id: <20090423072944.703184870@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:42 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 082/100] KVM: Fix missing smp tlb flush in invlpg
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-fix-missing-smp-tlb-flush-in-invlpg.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Andrea Arcangeli <aarcange@redhat.com>

upstream commit: 4539b35881ae9664b0e2953438dd83f5ee02c0b4

When kvm emulates an invlpg instruction, it can drop a shadow pte, but
leaves the guest tlbs intact.  This can cause memory corruption when
swapping out.

Without this the other cpu can still write to a freed host physical page.
tlb smp flush must happen if rmap_remove is called always before mmu_lock
is released because the VM will take the mmu_lock before it can finally add
the page to the freelist after swapout. mmu notifier makes it safe to flush
the tlb after freeing the page (otherwise it would never be safe) so we can do
a single flush for multiple sptes invalidated.

Cc: stable@kernel.org
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
[mtosatti: backport to 2.6.29]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/kvm/paging_tmpl.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -476,16 +476,20 @@ static int FNAME(shadow_invlpg_entry)(st
 	if (level == PT_PAGE_TABLE_LEVEL ||
 	    ((level == PT_DIRECTORY_LEVEL) && is_large_pte(*sptep))) {
 		struct kvm_mmu_page *sp = page_header(__pa(sptep));
+		int need_flush = 0;
 
 		sw->pte_gpa = (sp->gfn << PAGE_SHIFT);
 		sw->pte_gpa += (sptep - sp->spt) * sizeof(pt_element_t);
 
 		if (is_shadow_present_pte(*sptep)) {
+			need_flush = 1;
 			rmap_remove(vcpu->kvm, sptep);
 			if (is_large_pte(*sptep))
 				--vcpu->kvm->stat.lpages;
 		}
 		set_shadow_pte(sptep, shadow_trap_nonpresent_pte);
+		if (need_flush)
+			kvm_flush_remote_tlbs(vcpu->kvm);
 		return 1;
 	}
 	if (!is_shadow_present_pte(*sptep))

