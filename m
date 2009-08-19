Return-Path: <linux-kernel-owner+w=401wt.eu-S1752095AbZHSNCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbZHSNCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZHSNCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:02:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50545 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751864AbZHSNCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:45 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/47] KVM: MMU audit: update count_writable_mappings / count_rmaps
Date: Wed, 19 Aug 2009 16:01:59 +0300
Message-Id: <1250686963-8357-4-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Under testing, count_writable_mappings returns a value that is 2 integers
larger than what count_rmaps returns.

Suspicion is that either of the two functions is counting a duplicate (either
positively or negatively).

Modifying check_writable_mappings_rmap to check for rmap existance on
all present MMU pages fails to trigger an error, which should keep Avi
happy.

Also introduce mmu_spte_walk to invoke a callback on all present sptes visible
to the current vcpu, might be useful in the future.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/mmu.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 94 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index f85d995..fd5579c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3045,6 +3045,55 @@ static gva_t canonicalize(gva_t gva)
 	return gva;
 }
 
+
+typedef void (*inspect_spte_fn) (struct kvm *kvm, struct kvm_mmu_page *sp,
+				 u64 *sptep);
+
+static void __mmu_spte_walk(struct kvm *kvm, struct kvm_mmu_page *sp,
+			    inspect_spte_fn fn)
+{
+	int i;
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		u64 ent = sp->spt[i];
+
+		if (is_shadow_present_pte(ent)) {
+			if (sp->role.level > 1 && !is_large_pte(ent)) {
+				struct kvm_mmu_page *child;
+				child = page_header(ent & PT64_BASE_ADDR_MASK);
+				__mmu_spte_walk(kvm, child, fn);
+			}
+			if (sp->role.level == 1)
+				fn(kvm, sp, &sp->spt[i]);
+		}
+	}
+}
+
+static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
+{
+	int i;
+	struct kvm_mmu_page *sp;
+
+	if (!VALID_PAGE(vcpu->arch.mmu.root_hpa))
+		return;
+	if (vcpu->arch.mmu.shadow_root_level == PT64_ROOT_LEVEL) {
+		hpa_t root = vcpu->arch.mmu.root_hpa;
+		sp = page_header(root);
+		__mmu_spte_walk(vcpu->kvm, sp, fn);
+		return;
+	}
+	for (i = 0; i < 4; ++i) {
+		hpa_t root = vcpu->arch.mmu.pae_root[i];
+
+		if (root && VALID_PAGE(root)) {
+			root &= PT64_BASE_ADDR_MASK;
+			sp = page_header(root);
+			__mmu_spte_walk(vcpu->kvm, sp, fn);
+		}
+	}
+	return;
+}
+
 static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				gva_t va, int level)
 {
@@ -3137,9 +3186,47 @@ static int count_rmaps(struct kvm_vcpu *vcpu)
 	return nmaps;
 }
 
-static int count_writable_mappings(struct kvm_vcpu *vcpu)
+void inspect_spte_has_rmap(struct kvm *kvm, struct kvm_mmu_page *sp, u64 *sptep)
+{
+	unsigned long *rmapp;
+	struct kvm_mmu_page *rev_sp;
+	gfn_t gfn;
+
+	if (*sptep & PT_WRITABLE_MASK) {
+		rev_sp = page_header(__pa(sptep));
+		gfn = rev_sp->gfns[sptep - rev_sp->spt];
+
+		if (!gfn_to_memslot(kvm, gfn)) {
+			if (!printk_ratelimit())
+				return;
+			printk(KERN_ERR "%s: no memslot for gfn %ld\n",
+					 audit_msg, gfn);
+			printk(KERN_ERR "%s: index %ld of sp (gfn=%lx)\n",
+					audit_msg, sptep - rev_sp->spt,
+					rev_sp->gfn);
+			dump_stack();
+			return;
+		}
+
+		rmapp = gfn_to_rmap(kvm, rev_sp->gfns[sptep - rev_sp->spt], 0);
+		if (!*rmapp) {
+			if (!printk_ratelimit())
+				return;
+			printk(KERN_ERR "%s: no rmap for writable spte %llx\n",
+					 audit_msg, *sptep);
+			dump_stack();
+		}
+	}
+
+}
+
+void audit_writable_sptes_have_rmaps(struct kvm_vcpu *vcpu)
+{
+	mmu_spte_walk(vcpu, inspect_spte_has_rmap);
+}
+
+static void check_writable_mappings_rmap(struct kvm_vcpu *vcpu)
 {
-	int nmaps = 0;
 	struct kvm_mmu_page *sp;
 	int i;
 
@@ -3156,20 +3243,16 @@ static int count_writable_mappings(struct kvm_vcpu *vcpu)
 				continue;
 			if (!(ent & PT_WRITABLE_MASK))
 				continue;
-			++nmaps;
+			inspect_spte_has_rmap(vcpu->kvm, sp, &pt[i]);
 		}
 	}
-	return nmaps;
+	return;
 }
 
 static void audit_rmap(struct kvm_vcpu *vcpu)
 {
-	int n_rmap = count_rmaps(vcpu);
-	int n_actual = count_writable_mappings(vcpu);
-
-	if (n_rmap != n_actual)
-		printk(KERN_ERR "%s: (%s) rmap %d actual %d\n",
-		       __func__, audit_msg, n_rmap, n_actual);
+	check_writable_mappings_rmap(vcpu);
+	count_rmaps(vcpu);
 }
 
 static void audit_write_protection(struct kvm_vcpu *vcpu)
@@ -3203,6 +3286,7 @@ static void kvm_mmu_audit(struct kvm_vcpu *vcpu, const char *msg)
 	audit_rmap(vcpu);
 	audit_write_protection(vcpu);
 	audit_mappings(vcpu);
+	audit_writable_sptes_have_rmaps(vcpu);
 	dbg = olddbg;
 }
 
-- 
1.6.3.3

