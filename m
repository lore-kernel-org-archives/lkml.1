Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYIWNyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYIWNyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYIWNrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52422 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYIWNrq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:46 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Jerone Young <jyoung5@us.ibm.com>
Subject: [PATCH 22/40] KVM: ppc: adds trace points for ppc tlb activity
Date: Tue, 23 Sep 2008 16:46:36 +0300
Message-Id: <1222177614-26669-23-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jerone Young <jyoung5@us.ibm.com>

This patch adds trace points to track powerpc TLB activities using the
KVM_TRACE infrastructure.

Signed-off-by: Jerone Young <jyoung5@us.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/powerpc/kvm/44x_tlb.c |   15 ++++++++++++++-
 arch/powerpc/kvm/emulate.c |    4 ++++
 include/linux/kvm.h        |    3 +++
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 5a5602d..a207d16 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -19,6 +19,7 @@
 
 #include <linux/types.h>
 #include <linux/string.h>
+#include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/highmem.h>
 #include <asm/mmu-44x.h>
@@ -175,6 +176,10 @@ void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
 	stlbe->word1 = (hpaddr & 0xfffffc00) | ((hpaddr >> 32) & 0xf);
 	stlbe->word2 = kvmppc_44x_tlb_shadow_attrib(flags,
 	                                            vcpu->arch.msr & MSR_PR);
+
+	KVMTRACE_5D(STLB_WRITE, vcpu, victim,
+			stlbe->tid, stlbe->word0, stlbe->word1, stlbe->word2,
+			handler);
 }
 
 void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
@@ -204,6 +209,9 @@ void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, gva_t eaddr,
 
 		kvmppc_44x_shadow_release(vcpu, i);
 		stlbe->word0 = 0;
+		KVMTRACE_5D(STLB_INVAL, vcpu, i,
+				stlbe->tid, stlbe->word0, stlbe->word1,
+				stlbe->word2, handler);
 	}
 	up_write(&current->mm->mmap_sem);
 }
@@ -217,8 +225,13 @@ void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
 	/* XXX Replace loop with fancy data structures. */
 	down_write(&current->mm->mmap_sem);
 	for (i = 0; i <= tlb_44x_hwater; i++) {
+		struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+
 		kvmppc_44x_shadow_release(vcpu, i);
-		vcpu->arch.shadow_tlb[i].word0 = 0;
+		stlbe->word0 = 0;
+		KVMTRACE_5D(STLB_INVAL, vcpu, i,
+				stlbe->tid, stlbe->word0, stlbe->word1,
+				stlbe->word2, handler);
 	}
 	up_write(&current->mm->mmap_sem);
 }
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
index 8c605d0..4a3e274 100644
--- a/arch/powerpc/kvm/emulate.c
+++ b/arch/powerpc/kvm/emulate.c
@@ -170,6 +170,10 @@ static int kvmppc_emul_tlbwe(struct kvm_vcpu *vcpu, u32 inst)
 		kvmppc_mmu_map(vcpu, eaddr, raddr >> PAGE_SHIFT, asid, flags);
 	}
 
+	KVMTRACE_5D(GTLB_WRITE, vcpu, index,
+			tlbe->tid, tlbe->word0, tlbe->word1, tlbe->word2,
+			handler);
+
 	return EMULATE_DONE;
 }
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5d08f11..e21a505 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -471,5 +471,8 @@ struct kvm_trace_rec {
 #define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
 #define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
 #define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
+#define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
+#define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
+#define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
 
 #endif
-- 
1.6.0.1

