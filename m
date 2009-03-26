Return-Path: <linux-kernel-owner+w=401wt.eu-S1761875AbZCZXw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875AbZCZXw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762169AbZCZXwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:52:12 -0400
Received: from ozlabs.org ([203.10.76.45]:60041 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761768AbZCZXwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:52:10 -0400
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       jeremy@xensource.com, virtualization@lists.osdl.org, stable@kernel.org
To: lguest@ozlabs.org
Cc: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 27 Mar 2009 10:22:02 +1030
Subject: [PATCH 2/5] lguest: wire up pte_update/pte_update_defer
Cc: jeremy@xensource.com
Cc: virtualization@lists.osdl.org
Cc: stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271022.03020.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: intermittent guest segv/crash fix

I've been seeing random guest bad address crashes and segmentation faults:
bisect led to 4f98a2fee8 (vmscan: split LRU lists into anon & file sets),
but that's a red herring.

It turns out that lguest never hooked up the pte_update/pte_update_defer
calls, so our ptes were not always in sync.  After the vmscan commit, the
bug became reproducible; now a fsck in a 64MB guest causes reproducible
pagetable corruption.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: jeremy@xensource.com
Cc: virtualization@lists.osdl.org
Cc: stable@kernel.org
---
 arch/x86/lguest/boot.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index 65f0b8a..c3bdf0b 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -475,11 +480,17 @@ static void lguest_write_cr4(unsigned long val)
  * into a process' address space.  We set the entry then tell the Host the
  * toplevel and address this corresponds to.  The Guest uses one pagetable per
  * process, so we need to tell the Host which one we're changing (mm->pgd). */
+static void lguest_pte_update(struct mm_struct *mm, unsigned long addr,
+			       pte_t *ptep)
+{
+	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, ptep->pte_low);
+}
+
 static void lguest_set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pteval)
 {
 	*ptep = pteval;
-	lazy_hcall(LHCALL_SET_PTE, __pa(mm->pgd), addr, pteval.pte_low);
+	lguest_pte_update(mm, addr, ptep);
 }
 
 /* The Guest calls this to set a top-level entry.  Again, we set the entry then
@@ -1018,6 +1046,8 @@ __init void lguest_init(void)
 	pv_mmu_ops.read_cr3 = lguest_read_cr3;
 	pv_mmu_ops.lazy_mode.enter = paravirt_enter_lazy_mmu;
 	pv_mmu_ops.lazy_mode.leave = lguest_leave_lazy_mode;
+	pv_mmu_ops.pte_update = lguest_pte_update;
+	pv_mmu_ops.pte_update_defer = lguest_pte_update;
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* apic read/write intercepts */

