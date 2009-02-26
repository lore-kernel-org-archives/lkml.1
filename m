Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbZBZO3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbZBZO3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZBZORg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:17:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43071 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754554AbZBZOPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Izik Eidus <ieidus@redhat.com>
Subject: [PATCH 32/40] KVM: remove the vmap usage
Date: Thu, 26 Feb 2009 16:15:22 +0200
Message-Id: <1235657730-27683-33-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <ieidus@redhat.com>

vmap() on guest pages hides those pages from the Linux mm for an extended
(userspace determined) amount of time.  Get rid of it.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c        |   62 +++++++++-----------------------------------
 include/linux/kvm_types.h |    3 +-
 2 files changed, 14 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 67f9176..2a4f3a6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2371,40 +2371,19 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 }
 EXPORT_SYMBOL_GPL(emulate_instruction);
 
-static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(vcpu->arch.pio.guest_pages); ++i)
-		if (vcpu->arch.pio.guest_pages[i]) {
-			kvm_release_page_dirty(vcpu->arch.pio.guest_pages[i]);
-			vcpu->arch.pio.guest_pages[i] = NULL;
-		}
-}
-
 static int pio_copy_data(struct kvm_vcpu *vcpu)
 {
 	void *p = vcpu->arch.pio_data;
-	void *q;
+	gva_t q = vcpu->arch.pio.guest_gva;
 	unsigned bytes;
-	int nr_pages = vcpu->arch.pio.guest_pages[1] ? 2 : 1;
+	int ret;
 
-	q = vmap(vcpu->arch.pio.guest_pages, nr_pages, VM_READ|VM_WRITE,
-		 PAGE_KERNEL);
-	if (!q) {
-		free_pio_guest_pages(vcpu);
-		return -ENOMEM;
-	}
-	q += vcpu->arch.pio.guest_page_offset;
 	bytes = vcpu->arch.pio.size * vcpu->arch.pio.cur_count;
 	if (vcpu->arch.pio.in)
-		memcpy(q, p, bytes);
+		ret = kvm_write_guest_virt(q, p, bytes, vcpu);
 	else
-		memcpy(p, q, bytes);
-	q -= vcpu->arch.pio.guest_page_offset;
-	vunmap(q);
-	free_pio_guest_pages(vcpu);
-	return 0;
+		ret = kvm_read_guest_virt(q, p, bytes, vcpu);
+	return ret;
 }
 
 int complete_pio(struct kvm_vcpu *vcpu)
@@ -2515,7 +2494,6 @@ int kvm_emulate_pio(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.string = 0;
 	vcpu->arch.pio.down = 0;
-	vcpu->arch.pio.guest_page_offset = 0;
 	vcpu->arch.pio.rep = 0;
 
 	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
@@ -2543,9 +2521,7 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 		  gva_t address, int rep, unsigned port)
 {
 	unsigned now, in_page;
-	int i, ret = 0;
-	int nr_pages = 1;
-	struct page *page;
+	int ret = 0;
 	struct kvm_io_device *pio_dev;
 
 	vcpu->run->exit_reason = KVM_EXIT_IO;
@@ -2557,7 +2533,6 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	vcpu->arch.pio.in = in;
 	vcpu->arch.pio.string = 1;
 	vcpu->arch.pio.down = down;
-	vcpu->arch.pio.guest_page_offset = offset_in_page(address);
 	vcpu->arch.pio.rep = rep;
 
 	if (vcpu->run->io.direction == KVM_EXIT_IO_IN)
@@ -2577,15 +2552,8 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	else
 		in_page = offset_in_page(address) + size;
 	now = min(count, (unsigned long)in_page / size);
-	if (!now) {
-		/*
-		 * String I/O straddles page boundary.  Pin two guest pages
-		 * so that we satisfy atomicity constraints.  Do just one
-		 * transaction to avoid complexity.
-		 */
-		nr_pages = 2;
+	if (!now)
 		now = 1;
-	}
 	if (down) {
 		/*
 		 * String I/O in reverse.  Yuck.  Kill the guest, fix later.
@@ -2600,15 +2568,7 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	if (vcpu->arch.pio.cur_count == vcpu->arch.pio.count)
 		kvm_x86_ops->skip_emulated_instruction(vcpu);
 
-	for (i = 0; i < nr_pages; ++i) {
-		page = gva_to_page(vcpu, address + i * PAGE_SIZE);
-		vcpu->arch.pio.guest_pages[i] = page;
-		if (!page) {
-			kvm_inject_gp(vcpu, 0);
-			free_pio_guest_pages(vcpu);
-			return 1;
-		}
-	}
+	vcpu->arch.pio.guest_gva = address;
 
 	pio_dev = vcpu_find_pio_dev(vcpu, port,
 				    vcpu->arch.pio.cur_count,
@@ -2616,7 +2576,11 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 	if (!vcpu->arch.pio.in) {
 		/* string PIO write */
 		ret = pio_copy_data(vcpu);
-		if (ret >= 0 && pio_dev) {
+		if (ret == X86EMUL_PROPAGATE_FAULT) {
+			kvm_inject_gp(vcpu, 0);
+			return 1;
+		}
+		if (ret == 0 && pio_dev) {
 			pio_string_write(pio_dev, vcpu);
 			complete_pio(vcpu);
 			if (vcpu->arch.pio.count == 0)
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index 9b6f395..5f4a18c 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -43,8 +43,7 @@ typedef hfn_t pfn_t;
 struct kvm_pio_request {
 	unsigned long count;
 	int cur_count;
-	struct page *guest_pages[2];
-	unsigned guest_page_offset;
+	gva_t guest_gva;
 	int in;
 	int port;
 	int size;
-- 
1.6.0.6

