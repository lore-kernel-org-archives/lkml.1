Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbYLIU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbYLIU3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbYLIUXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:48 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34909 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064AbYLIUXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:16 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 15/44] KVM: ppc: fix userspace mapping invalidation on context switch
Date: Tue,  9 Dec 2008 22:22:30 +0200
Message-Id: <1228854179-23002-16-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

We used to defer invalidating userspace TLB entries until jumping out of the
kernel. This was causing MMU weirdness most easily triggered by using a pipe in
the guest, e.g. "dmesg | tail". I believe the problem was that after the guest
kernel changed the PID (part of context switch), the old process's mappings
were still present, and so copy_to_user() on the "return to new process" path
ended up using stale mappings.

Testing with large pages (64K) exposed the problem, probably because with 4K
pages, pressure on the TLB faulted all process A's mappings out before the
guest kernel could insert any for process B.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_44x.h |    2 ++
 arch/powerpc/kvm/44x_emulate.c     |    9 +--------
 arch/powerpc/kvm/44x_tlb.c         |   31 +++++++++++++++++--------------
 3 files changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_44x.h b/arch/powerpc/include/asm/kvm_44x.h
index dece093..72e5939 100644
--- a/arch/powerpc/include/asm/kvm_44x.h
+++ b/arch/powerpc/include/asm/kvm_44x.h
@@ -44,4 +44,6 @@ static inline struct kvmppc_vcpu_44x *to_44x(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct kvmppc_vcpu_44x, vcpu);
 }
 
+void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid);
+
 #endif /* __ASM_44X_H__ */
diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index 9bc50ce..9ef79c7 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -21,6 +21,7 @@
 #include <asm/dcr.h>
 #include <asm/dcr-regs.h>
 #include <asm/disassemble.h>
+#include <asm/kvm_44x.h>
 
 #include "booke.h"
 #include "44x_tlb.h"
@@ -38,14 +39,6 @@
 #define XOP_ICCCI   966
 #define XOP_TLBWE   978
 
-static inline void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid)
-{
-	if (vcpu->arch.pid != new_pid) {
-		vcpu->arch.pid = new_pid;
-		vcpu->arch.swap_pid = 1;
-	}
-}
-
 static void kvmppc_emul_rfi(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.pc = vcpu->arch.srr0;
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 6fadbd6..ee24618 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -268,31 +268,34 @@ static void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	}
 }
 
-/* Invalidate all mappings on the privilege switch after PID has been changed.
- * The guest always runs with PID=1, so we must clear the entire TLB when
- * switching address spaces. */
 void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 {
+	vcpu->arch.shadow_pid = !usermode;
+}
+
+void kvmppc_set_pid(struct kvm_vcpu *vcpu, u32 new_pid)
+{
 	struct kvmppc_vcpu_44x *vcpu_44x = to_44x(vcpu);
 	int i;
 
-	if (vcpu->arch.swap_pid) {
-		/* XXX Replace loop with fancy data structures. */
-		for (i = 0; i <= tlb_44x_hwater; i++) {
-			struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
+	if (unlikely(vcpu->arch.pid == new_pid))
+		return;
+
+	vcpu->arch.pid = new_pid;
+
+	/* Guest userspace runs with TID=0 mappings and PID=0, to make sure it
+	 * can't access guest kernel mappings (TID=1). When we switch to a new
+	 * guest PID, which will also use host PID=0, we must discard the old guest
+	 * userspace mappings. */
+	for (i = 0; i < ARRAY_SIZE(vcpu_44x->shadow_tlb); i++) {
+		struct kvmppc_44x_tlbe *stlbe = &vcpu_44x->shadow_tlb[i];
 
-			/* Future optimization: clear only userspace mappings. */
+		if (get_tlb_tid(stlbe) == 0) {
 			kvmppc_44x_shadow_release(vcpu, i);
 			stlbe->word0 = 0;
 			kvmppc_tlbe_set_modified(vcpu, i);
-			KVMTRACE_5D(STLB_INVAL, vcpu, i,
-			            stlbe->tid, stlbe->word0, stlbe->word1,
-			            stlbe->word2, handler);
 		}
-		vcpu->arch.swap_pid = 0;
 	}
-
-	vcpu->arch.shadow_pid = !usermode;
 }
 
 static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
-- 
1.6.0.3

