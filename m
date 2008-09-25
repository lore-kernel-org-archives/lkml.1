Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYIYMBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYIYMBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYIYLz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48569 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYIYLzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:52 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 19/39] KVM: Load real mode segments correctly
Date: Thu, 25 Sep 2008 14:54:51 +0300
Message-Id: <1222343711-12508-20-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Real mode segments to not reference the GDT or LDT; they simply compute
base = selector * 16.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 22edd95..bfc7c33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3588,11 +3588,33 @@ static int load_segment_descriptor_to_kvm_desct(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int seg)
+{
+	struct kvm_segment segvar = {
+		.base = selector << 4,
+		.limit = 0xffff,
+		.selector = selector,
+		.type = 3,
+		.present = 1,
+		.dpl = 3,
+		.db = 0,
+		.s = 1,
+		.l = 0,
+		.g = 0,
+		.avl = 0,
+		.unusable = 0,
+	};
+	kvm_x86_ops->set_segment(vcpu, &segvar, seg);
+	return 0;
+}
+
 int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 				int type_bits, int seg)
 {
 	struct kvm_segment kvm_seg;
 
+	if (!(vcpu->arch.cr0 & X86_CR0_PE))
+		return kvm_load_realmode_segment(vcpu, selector, seg);
 	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
 		return 1;
 	kvm_seg.type |= type_bits;
-- 
1.6.0.1

