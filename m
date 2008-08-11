Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYHKRCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYHKRCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 13:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbYHKRB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 13:01:56 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:54296 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbYHKRBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 13:01:52 -0400
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH 4/4] kvm: reduce stack usage in kvm_pv_mmu_op()
Date: Mon, 11 Aug 2008 10:01:49 -0700
Message-Id: <1218474109-14772-1-git-send-email-dave@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.rc1.34.g0fe8c1
In-Reply-To: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
References: <1218474105-14678-1-git-send-email-dave@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time, we're in a hot path.  We can't use kmalloc() because
it might impact performance.  So, we just stick the buffer that
we need into the kvm_vcpu_arch structure.  This is used very
often, so it is not really a waste.

We also have to move the buffer structure's definition to the
arch-specific x86 kvm header.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c         |   23 ++++++++---------------
 include/asm-x86/kvm_host.h |   10 ++++++++++
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 0bfe2bd..c2ce32c 100644
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
@@ -2287,18 +2280,18 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
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
@@ -2307,7 +2300,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 
 	r = 1;
 out:
-	*ret = buffer.processed;
+	*ret = buffer->processed;
 	return r;
 }
 
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 0f3c531..ab0b351 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -195,6 +195,13 @@ struct kvm_mmu_page {
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
@@ -237,6 +244,9 @@ struct kvm_vcpu_arch {
 	bool tpr_access_reporting;
 
 	struct kvm_mmu mmu;
+	/* only needed in kvm_pv_mmu_op() path, but it's hot so
+	 * put it here to avoid allocation */
+	struct kvm_pv_mmu_op_buffer mmu_op_buffer;
 
 	struct kvm_mmu_memory_cache mmu_pte_chain_cache;
 	struct kvm_mmu_memory_cache mmu_rmap_desc_cache;
-- 
1.5.4.3

