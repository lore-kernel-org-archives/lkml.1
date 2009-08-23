Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbZHWL7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbZHWL7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933512AbZHWL6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933525AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 31/46] KVM: x86: use get_desc_base() and get_desc_limit()
Date: Sun, 23 Aug 2009 14:56:30 +0300
Message-Id: <1251028605-31977-32-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

Use get_desc_base() and get_desc_limit() to get the base address and
limit in desc_struct.

Cc: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 48567fa..0ebd684 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -142,8 +142,7 @@ unsigned long segment_base(u16 selector)
 		table_base = segment_base(ldt_selector);
 	}
 	d = (struct desc_struct *)(table_base + (selector & ~7));
-	v = d->base0 | ((unsigned long)d->base1 << 16) |
-		((unsigned long)d->base2 << 24);
+	v = get_desc_base(d);
 #ifdef CONFIG_X86_64
 	if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
 		v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
@@ -3943,11 +3942,8 @@ static void kvm_set_segment(struct kvm_vcpu *vcpu,
 static void seg_desct_to_kvm_desct(struct desc_struct *seg_desc, u16 selector,
 				   struct kvm_segment *kvm_desct)
 {
-	kvm_desct->base = seg_desc->base0;
-	kvm_desct->base |= seg_desc->base1 << 16;
-	kvm_desct->base |= seg_desc->base2 << 24;
-	kvm_desct->limit = seg_desc->limit0;
-	kvm_desct->limit |= seg_desc->limit << 16;
+	kvm_desct->base = get_desc_base(seg_desc);
+	kvm_desct->limit = get_desc_limit(seg_desc);
 	if (seg_desc->g) {
 		kvm_desct->limit <<= 12;
 		kvm_desct->limit |= 0xfff;
@@ -4026,11 +4022,7 @@ static int save_guest_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 static u32 get_tss_base_addr(struct kvm_vcpu *vcpu,
 			     struct desc_struct *seg_desc)
 {
-	u32 base_addr;
-
-	base_addr = seg_desc->base0;
-	base_addr |= (seg_desc->base1 << 16);
-	base_addr |= (seg_desc->base2 << 24);
+	u32 base_addr = get_desc_base(seg_desc);
 
 	return vcpu->arch.mmu.gva_to_gpa(vcpu, base_addr);
 }
@@ -4319,7 +4311,7 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int reason)
 		}
 	}
 
-	if (!nseg_desc.p || (nseg_desc.limit0 | nseg_desc.limit << 16) < 0x67) {
+	if (!nseg_desc.p || get_desc_limit(&nseg_desc) < 0x67) {
 		kvm_queue_exception_e(vcpu, TS_VECTOR, tss_selector & 0xfffc);
 		return 1;
 	}
-- 
1.6.4.1

