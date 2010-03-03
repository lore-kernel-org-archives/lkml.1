Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab0CCTNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:13:50 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9689 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab0CCTNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:13:12 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh2a8h87h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYQ01C-01-LMG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/18] KVM: MMU: Implement nested gva_to_gpa functions
Date: Wed, 3 Mar 2010 20:12:15 +0100
Message-ID: <1267643541-451-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 03 Mar 2010 19:12:42.0751 (UTC) FILETIME=[7FD708F0:01CABB05]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the functions to do a nested l2_gva to
l1_gpa page table walk.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/mmu.c              |    8 ++++++++
 arch/x86/kvm/paging_tmpl.h      |   31 +++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 76c8b5f..20dd1ce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -295,6 +295,9 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	struct kvm_mmu mmu;
+
+	struct kvm_mmu nested_mmu;
+
 	/* only needed in kvm_pv_mmu_op() path, but it's hot so
 	 * put it here to avoid allocation */
 	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ec3830c..c831955 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2162,6 +2162,14 @@ static gpa_t nonpaging_gva_to_gpa(struct kvm_vcpu *vcpu, gva_t vaddr,
 	return vaddr;
 }
 
+static gpa_t nonpaging_gva_to_gpa_nested(struct kvm_vcpu *vcpu, gva_t vaddr,
+					 u32 access, u32 *error)
+{
+	if (error)
+		*error = 0;
+	return vcpu->arch.nested_mmu.translate_gpa(vcpu, vaddr, error);
+}
+
 static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				u32 error_code)
 {
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a72d5ea..c0158d8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -282,6 +282,16 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 				        write_fault, user_fault, fetch_fault);
 }
 
+static int FNAME(walk_addr_nested)(struct guest_walker *walker,
+				   struct kvm_vcpu *vcpu, gva_t addr,
+				   int write_fault, int user_fault,
+				   int fetch_fault)
+{
+	return FNAME(walk_addr_generic)(walker, vcpu, &vcpu->arch.nested_mmu,
+					addr, write_fault, user_fault,
+					fetch_fault);
+}
+
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
 			      u64 *spte, const void *pte)
 {
@@ -541,6 +551,27 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr, u32 access,
 	return gpa;
 }
 
+static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gva_t vaddr,
+				      u32 access, u32 *error)
+{
+	struct guest_walker walker;
+	gpa_t gpa = UNMAPPED_GVA;
+	int r;
+
+	r = FNAME(walk_addr_nested)(&walker, vcpu, vaddr,
+				    !!(access & PFERR_WRITE_MASK),
+				    !!(access & PFERR_USER_MASK),
+				    !!(access & PFERR_FETCH_MASK));
+
+	if (r) {
+		gpa = gfn_to_gpa(walker.gfn);
+		gpa |= vaddr & ~PAGE_MASK;
+	} else if (error)
+		*error = walker.error_code;
+
+	return gpa;
+}
+
 static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp)
 {
-- 
1.7.0


