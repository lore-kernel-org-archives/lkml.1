Return-Path: <linux-kernel-owner+w=401wt.eu-S1761547AbZB1Bqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761547AbZB1Bqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbZB1BmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41763 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbZB1Bl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:56 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/30] KVM: ia64: vTLB change for enabling windows 2008 boot
Date: Sat, 28 Feb 2009 03:41:20 +0200
Message-Id: <1235785309-12835-2-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Simply the logic of hash vTLB, and export kvm_gpa_to_mpa.

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/kvm/vcpu.h |    4 ++--
 arch/ia64/kvm/vtlb.c |   39 +++++++++++++++++----------------------
 2 files changed, 19 insertions(+), 24 deletions(-)

diff --git a/arch/ia64/kvm/vcpu.h b/arch/ia64/kvm/vcpu.h
index b2f12a5..042af92 100644
--- a/arch/ia64/kvm/vcpu.h
+++ b/arch/ia64/kvm/vcpu.h
@@ -703,7 +703,7 @@ extern u64 guest_vhpt_lookup(u64 iha, u64 *pte);
 extern void thash_purge_entries(struct kvm_vcpu *v, u64 va, u64 ps);
 extern void thash_purge_entries_remote(struct kvm_vcpu *v, u64 va, u64 ps);
 extern u64 translate_phy_pte(u64 *pte, u64 itir, u64 va);
-extern int thash_purge_and_insert(struct kvm_vcpu *v, u64 pte,
+extern void thash_purge_and_insert(struct kvm_vcpu *v, u64 pte,
 		u64 itir, u64 ifa, int type);
 extern void thash_purge_all(struct kvm_vcpu *v);
 extern struct thash_data *vtlb_lookup(struct kvm_vcpu *v,
@@ -738,7 +738,7 @@ void kvm_init_vhpt(struct kvm_vcpu *v);
 void thash_init(struct thash_cb *hcb, u64 sz);
 
 void panic_vm(struct kvm_vcpu *v, const char *fmt, ...);
-
+u64 kvm_gpa_to_mpa(u64 gpa);
 extern u64 ia64_call_vsa(u64 proc, u64 arg1, u64 arg2, u64 arg3,
 		u64 arg4, u64 arg5, u64 arg6, u64 arg7);
 
diff --git a/arch/ia64/kvm/vtlb.c b/arch/ia64/kvm/vtlb.c
index ac94867..38232b3 100644
--- a/arch/ia64/kvm/vtlb.c
+++ b/arch/ia64/kvm/vtlb.c
@@ -164,11 +164,11 @@ static void vhpt_insert(u64 pte, u64 itir, u64 ifa, u64 gpte)
 	unsigned long ps, gpaddr;
 
 	ps = itir_ps(itir);
+	rr.val = ia64_get_rr(ifa);
 
-	gpaddr = ((gpte & _PAGE_PPN_MASK) >> ps << ps) |
-		(ifa & ((1UL << ps) - 1));
+	 gpaddr = ((gpte & _PAGE_PPN_MASK) >> ps << ps) |
+					(ifa & ((1UL << ps) - 1));
 
-	rr.val = ia64_get_rr(ifa);
 	head = (struct thash_data *)ia64_thash(ifa);
 	head->etag = INVALID_TI_TAG;
 	ia64_mf();
@@ -412,16 +412,14 @@ u64 translate_phy_pte(u64 *pte, u64 itir, u64 va)
 
 /*
  * Purge overlap TCs and then insert the new entry to emulate itc ops.
- *    Notes: Only TC entry can purge and insert.
- *    1 indicates this is MMIO
+ * Notes: Only TC entry can purge and insert.
  */
-int thash_purge_and_insert(struct kvm_vcpu *v, u64 pte, u64 itir,
+void  thash_purge_and_insert(struct kvm_vcpu *v, u64 pte, u64 itir,
 						u64 ifa, int type)
 {
 	u64 ps;
 	u64 phy_pte, io_mask, index;
 	union ia64_rr vrr, mrr;
-	int ret = 0;
 
 	ps = itir_ps(itir);
 	vrr.val = vcpu_get_rr(v, ifa);
@@ -441,25 +439,19 @@ int thash_purge_and_insert(struct kvm_vcpu *v, u64 pte, u64 itir,
 		phy_pte &= ~_PAGE_MA_MASK;
 	}
 
-	if (pte & VTLB_PTE_IO)
-		ret = 1;
-
 	vtlb_purge(v, ifa, ps);
 	vhpt_purge(v, ifa, ps);
 
-	if (ps == mrr.ps) {
-		if (!(pte&VTLB_PTE_IO)) {
-			vhpt_insert(phy_pte, itir, ifa, pte);
-		} else {
-			vtlb_insert(v, pte, itir, ifa);
-			vcpu_quick_region_set(VMX(v, tc_regions), ifa);
-		}
-	} else if (ps > mrr.ps) {
+	if ((ps != mrr.ps) || (pte & VTLB_PTE_IO)) {
 		vtlb_insert(v, pte, itir, ifa);
 		vcpu_quick_region_set(VMX(v, tc_regions), ifa);
-		if (!(pte&VTLB_PTE_IO))
-			vhpt_insert(phy_pte, itir, ifa, pte);
-	} else {
+	}
+	if (pte & VTLB_PTE_IO)
+		return;
+
+	if (ps >= mrr.ps)
+		vhpt_insert(phy_pte, itir, ifa, pte);
+	else {
 		u64 psr;
 		phy_pte  &= ~PAGE_FLAGS_RV_MASK;
 		psr = ia64_clear_ic();
@@ -469,7 +461,6 @@ int thash_purge_and_insert(struct kvm_vcpu *v, u64 pte, u64 itir,
 	if (!(pte&VTLB_PTE_IO))
 		mark_pages_dirty(v, pte, ps);
 
-	return ret;
 }
 
 /*
@@ -570,6 +561,10 @@ void thash_init(struct thash_cb *hcb, u64 sz)
 u64 kvm_get_mpt_entry(u64 gpfn)
 {
 	u64 *base = (u64 *) KVM_P2M_BASE;
+
+	if (gpfn >= (KVM_P2M_SIZE >> 3))
+		panic_vm(current_vcpu, "Invalid gpfn =%lx\n", gpfn);
+
 	return *(base + gpfn);
 }
 
-- 
1.6.0.6

