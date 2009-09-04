Return-Path: <linux-kernel-owner+w=401wt.eu-S934215AbZIDUVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934215AbZIDUVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934026AbZIDUUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:20:49 -0400
Received: from kroah.org ([198.145.64.141]:36158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933978AbZIDUOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:24 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:52 2009
Message-Id: <20090904200852.821221381@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 17/48] KVM: Reduce stack usage in kvm_pv_mmu_op()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=kvm-reduce-stack-usage-in-kvm_pv_mmu_op.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dave Hansen <dave@linux.vnet.ibm.com>

(cherry picked from commit 6ad18fba05228fb1d47cdbc0339fe8b3fca1ca26)

We're in a hot path.  We can't use kmalloc() because
it might impact performance.  So, we just stick the buffer that
we need into the kvm_vcpu_arch structure.  This is used very
often, so it is not really a waste.

We also have to move the buffer structure's definition to the
arch-specific x86 kvm header.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/mmu.c         |   23 ++++++++---------------
 include/asm-x86/kvm_host.h |   10 ++++++++++
 2 files changed, 18 insertions(+), 15 deletions(-)

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
@@ -2294,18 +2287,18 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu,
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
@@ -2314,7 +2307,7 @@ int kvm_pv_mmu_op(struct kvm_vcpu *vcpu,
 
 	r = 1;
 out:
-	*ret = buffer.processed;
+	*ret = buffer->processed;
 	return r;
 }
 
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


