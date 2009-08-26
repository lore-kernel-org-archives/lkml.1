Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZHZKhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZHZKhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932445AbZHZKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/47] KVM: When switching to a vm8086 task, load segments as 16-bit
Date: Wed, 26 Aug 2009 13:29:59 +0300
Message-Id: <1251282609-12835-38-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anthony Liguori <aliguori@us.ibm.com>

According to 16.2.5 in the SDM, eflags.vm in the tss is consulted before loading
and new segments.  If eflags.vm == 1, then the segments are treated as 16-bit
segments.  The LDTR and TR are not normally available in vm86 mode so if they
happen to somehow get loaded, they need to be treated as 32-bit segments.

This fixes an invalid vmentry failure in a custom OS that was happening after
a task switch into vm8086 mode.  Since the segments were being mistakenly
treated as 32-bit, we loaded garbage state.

Signed-off-by: Anthony Liguori <aliguori@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 31bf984..1aa7e6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4101,12 +4101,19 @@ static int kvm_load_realmode_segment(struct kvm_vcpu *vcpu, u16 selector, int se
 	return 0;
 }
 
+static int is_vm86_segment(struct kvm_vcpu *vcpu, int seg)
+{
+	return (seg != VCPU_SREG_LDTR) &&
+		(seg != VCPU_SREG_TR) &&
+		(kvm_x86_ops->get_rflags(vcpu) & X86_EFLAGS_VM);
+}
+
 int kvm_load_segment_descriptor(struct kvm_vcpu *vcpu, u16 selector,
 				int type_bits, int seg)
 {
 	struct kvm_segment kvm_seg;
 
-	if (!(vcpu->arch.cr0 & X86_CR0_PE))
+	if (is_vm86_segment(vcpu, seg) || !(vcpu->arch.cr0 & X86_CR0_PE))
 		return kvm_load_realmode_segment(vcpu, selector, seg);
 	if (load_segment_descriptor_to_kvm_desct(vcpu, selector, &kvm_seg))
 		return 1;
-- 
1.6.4.1

