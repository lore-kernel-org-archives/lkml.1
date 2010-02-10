Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0BJRXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:23:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233Ab0BJRXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/40] KVM: x86: raise TSS exception for NULL CS and SS segments
Date: Wed, 10 Feb 2010 19:22:31 +0200
Message-Id: <1265822589-11155-3-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Windows 2003 uses task switch to triple fault and reboot (the other
exception being reserved pdptrs bits).

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/x86.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b503614..47fab87 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4411,6 +4411,15 @@ static int is_vm86_segment(struct kvm_vcpu *vcpu, int seg)
 		(kvm_get_rflags(vcpu) & X86_EFLAGS_VM);
 }
 
+static void kvm_check_segment_descriptor(struct kvm_vcpu *vcpu, int seg,
+					 u16 selector)
+{
+	/* NULL selector is not valid for CS and SS */
+	if (seg == VCPU_SREG_CS || seg == VCPU_SREG_SS)
+		if (!selector)
+			kvm_queue_exception_e(vcpu, TS_VECTOR, selector >> 3);
+}
+
 int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 				int type_bits, int seg)
 {
@@ -4420,6 +4429,8 @@ int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 		return kvm_load_realmode_segment(vcpu, selector, seg);
 	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
 		return 1;
+
+	kvm_check_segment_descriptor(vcpu, seg, selector);
 	kvm_seg.type |= type_bits;
 
 	if (seg != VCPU_SREG_SS && seg != VCPU_SREG_CS &&
-- 
1.6.5.3

