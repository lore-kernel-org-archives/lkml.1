Return-Path: <linux-kernel-owner+w=401wt.eu-S932482AbYDCTns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482AbYDCTns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760597AbYDCTda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:30 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53033
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 23/35] x86: KVM guest: hypercall batching
Date: Thu,  3 Apr 2008 22:32:38 +0300
Message-Id: <1207251170-5013-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Batch pte updates and tlb flushes in lazy MMU mode.

[avi:
 - adjust to mmu_op
 - helper for getting para_state without debug warnings]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/kvm.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1bb6e97..d9121f9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -26,6 +26,22 @@
 #include <linux/cpu.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/hardirq.h>
+
+#define MMU_QUEUE_SIZE 1024
+
+struct kvm_para_state {
+	u8 mmu_queue[MMU_QUEUE_SIZE];
+	int mmu_queue_len;
+	enum paravirt_lazy_mode mode;
+};
+
+static DEFINE_PER_CPU(struct kvm_para_state, para_state);
+
+static struct kvm_para_state *kvm_para_state(void)
+{
+	return &per_cpu(para_state, raw_smp_processor_id());
+}
 
 /*
  * No need for any "IO delay" on KVM
@@ -48,6 +64,28 @@ static void kvm_mmu_op(void *buffer, unsigned len)
 	} while (len);
 }
 
+static void mmu_queue_flush(struct kvm_para_state *state)
+{
+	if (state->mmu_queue_len) {
+		kvm_mmu_op(state->mmu_queue, state->mmu_queue_len);
+		state->mmu_queue_len = 0;
+	}
+}
+
+static void kvm_deferred_mmu_op(void *buffer, int len)
+{
+	struct kvm_para_state *state = kvm_para_state();
+
+	if (state->mode != PARAVIRT_LAZY_MMU) {
+		kvm_mmu_op(buffer, len);
+		return;
+	}
+	if (state->mmu_queue_len + len > sizeof state->mmu_queue)
+		mmu_queue_flush(state);
+	memcpy(state->mmu_queue + state->mmu_queue_len, buffer, len);
+	state->mmu_queue_len += len;
+}
+
 static void kvm_mmu_write(void *dest, u64 val)
 {
 	__u64 pte_phys;
@@ -68,7 +106,7 @@ static void kvm_mmu_write(void *dest, u64 val)
 	wpte.pte_val = val;
 	wpte.pte_phys = pte_phys;
 
-	kvm_mmu_op(&wpte, sizeof wpte);
+	kvm_deferred_mmu_op(&wpte, sizeof wpte);
 }
 
 /*
@@ -137,7 +175,7 @@ static void kvm_flush_tlb(void)
 		.header.op = KVM_MMU_OP_FLUSH_TLB,
 	};
 
-	kvm_mmu_op(&ftlb, sizeof ftlb);
+	kvm_deferred_mmu_op(&ftlb, sizeof ftlb);
 }
 
 static void kvm_release_pt(u32 pfn)
@@ -150,6 +188,23 @@ static void kvm_release_pt(u32 pfn)
 	kvm_mmu_op(&rpt, sizeof rpt);
 }
 
+static void kvm_enter_lazy_mmu(void)
+{
+	struct kvm_para_state *state = kvm_para_state();
+
+	paravirt_enter_lazy_mmu();
+	state->mode = paravirt_get_lazy_mode();
+}
+
+static void kvm_leave_lazy_mmu(void)
+{
+	struct kvm_para_state *state = kvm_para_state();
+
+	mmu_queue_flush(state);
+	paravirt_leave_lazy(paravirt_get_lazy_mode());
+	state->mode = paravirt_get_lazy_mode();
+}
+
 static void paravirt_ops_setup(void)
 {
 	pv_info.name = "KVM";
@@ -177,6 +232,9 @@ static void paravirt_ops_setup(void)
 		pv_mmu_ops.flush_tlb_user = kvm_flush_tlb;
 		pv_mmu_ops.release_pt = kvm_release_pt;
 		pv_mmu_ops.release_pd = kvm_release_pt;
+
+		pv_mmu_ops.lazy_mode.enter = kvm_enter_lazy_mmu;
+		pv_mmu_ops.lazy_mode.leave = kvm_leave_lazy_mmu;
 	}
 }
 
-- 
1.5.4.5

