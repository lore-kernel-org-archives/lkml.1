Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbYIWN54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbYIWN54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYIWNsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbYIWNsL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:48:11 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 40/40] KVM: Reduce stack usage in kvm_pv_mmu_op()
Date: Tue, 23 Sep 2008 16:46:54 +0300
Message-Id: <1222177614-26669-41-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

We're in a hot path.  We can't use kmalloc() because
it might impact performance.  So, we just stick the buffer that
we need into the kvm_vcpu_arch structure.  This is used very
often, so it is not really a waste.

We also have to move the buffer structure's definition to the
arch-specific x86 kvm header.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/mmu.c         |   23 ++++++++---------------
 include/asm-x86/kvm_host.h |   10 ++++++++++
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c3afbfe..171bcea 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -135,13 +135,6 @@ module_param(dbg, bool, 0644);
 #define ACC_USER_MASK    PT_USER_MASK
 #define ACC_ALL          (ACC_EXEC_MASK | ACC_WRITE_MASK | ACC_USER_MASK)
 
-struct kvm_pv_mmu_op_buffer {
-	void *ptr;
-	unsigned len;
-	unsigned processed;
-	char buf[512] __aligned(sizeof(long));
-};
-
 struct kvm_rmap_desc {
 	u64 *shadow_ptes[RMAP_EXT];
 	struct kvm_rmap_desc *more;
@@ -2292,18 +2285,18 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret)
 {
 	int r;
-	struct kvm_pv_mmu_op_buffer buffer;
+	struct kvm_pv_mmu_op_buffer *buffer = &vcpu->arch.mmu_op_buffer;
 
-	buffer.ptr = buffer.buf;
-	buffer.len = min_t(unsigned long, bytes, sizeof buffer.buf);
-	buffer.processed = 0;
+	buffer->ptr = buffer->buf;
+	buffer->len = min_t(unsigned long, bytes, sizeof buffer->buf);
+	buffer->processed = 0;
 
-	r = kvm_read_guest(vcpu->kvm, addr, buffer.buf, buffer.len);
+	r = kvm_read_guest(vcpu->kvm, addr, buffer->buf, buffer->len);
 	if (r)
 		goto out;
 
-	while (buffer.len) {
-		r = kvm_pv_mmu_op_one(vcpu, &buffer);
+	while (buffer->len) {
+		r = kvm_pv_mmu_op_one(vcpu, buffer);
 		if (r < 0)
 			goto out;
 		if (r == 0)
@@ -2312,7 +2305,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 
 	r = 1;
 out:
-	*ret = buffer.processed;
+	*ret = buffer->processed;
 	return r;
 }
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 54e92a0..fb7d7b7 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -201,6 +201,13 @@ struct kvm_mmu_page {
 	};
 };
 
+struct kvm_pv_mmu_op_buffer {
+	void *ptr;
+	unsigned len;
+	unsigned processed;
+	char buf[512] __aligned(sizeof(long));
+};
+
 /*
  * x86 supports 3 paging modes (4-level 64-bit, 3-level 64-bit, and 2-level
  * 32-bit).  The kvm_mmu structure abstracts the details of the current mmu
@@ -248,6 +255,9 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	struct kvm_mmu mmu;
+	/* only needed in kvm_pv_mmu_op() path, but it's hot so
+	 * put it here to avoid allocation */
+	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
 
 	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
 	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
-- 
1.6.0.1

