Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948Ab0BPKjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:39:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 26/38] KVM: mark segments accessed on HW task switch
Date: Tue, 16 Feb 2010 12:35:24 +0200
Message-Id: <1266316536-28936-27-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

On HW task switch newly loaded segments should me marked as accessed.

Reported-by: Lorenzo Martignoni <martignlo@gmail.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b90298..d47ceda 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4697,18 +4697,6 @@ static u16 get_segment_selector(struct kvm_vcpu *vcpu, int seg)
 	return kvm_seg.selector;
 }
 
-static int load_segment_descriptor_to_kvm_desct(struct kvm_vcpu *vcpu,
-						u16 selector,
-						struct kvm_segment *kvm_seg)
-{
-	struct desc_struct seg_desc;
-
-	if (load_guest_segment_descriptor(vcpu, selector, &seg_desc))
-		return 1;
-	seg_desct_to_kvm_desct(&seg_desc, selector, kvm_seg);
-	return 0;
-}
-
 static int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int seg)
 {
 	struct kvm_segment segvar = {
@@ -4749,11 +4737,14 @@ int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 				int type_bits, int seg)
 {
 	struct kvm_segment kvm_seg;
+	struct desc_struct seg_desc;
 
 	if (is_vm86_segment(vcpu, seg) || !is_protmode(vcpu))
 		return kvm_load_realmode_segment(vcpu, selector, seg);
-	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
+
+	if (load_guest_segment_descriptor(vcpu, selector, &seg_desc))
 		return 1;
+	seg_desct_to_kvm_desct(&seg_desc, selector, &kvm_seg);
 
 	kvm_check_segment_descriptor(vcpu, seg, selector);
 	kvm_seg.type |= type_bits;
@@ -4764,6 +4755,11 @@ int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 			kvm_seg.unusable = 1;
 
 	kvm_set_segment(vcpu, &kvm_seg, seg);
+	if (selector && !kvm_seg.unusable && kvm_seg.s) {
+		/* mark segment as accessed */
+		seg_desc.type |= 1;
+		save_guest_segment_descriptor(vcpu, selector, &seg_desc);
+	}
 	return 0;
 }
 
-- 
1.6.5.3

