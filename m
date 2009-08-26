Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbZHZKk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbZHZKk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbZHZKky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:40:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbZHZKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/47] KVM: VMX: Optimize vmx_get_cpl()
Date: Wed, 26 Aug 2009 13:29:27 +0300
Message-Id: <1251282609-12835-6-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling vmx_get_segment() (which reads a whole bunch of
vmcs fields), read only the cs selector which contains the cpl.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 32e6d20..0ba706e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1773,16 +1773,13 @@ static void vmx_get_segment(struct kvm_vcpu *vcpu,
 
 static int vmx_get_cpl(struct kvm_vcpu *vcpu)
 {
-	struct kvm_segment kvm_seg;
-
 	if (!(vcpu->arch.cr0 & X86_CR0_PE)) /* if real mode */
 		return 0;
 
 	if (vmx_get_rflags(vcpu) & X86_EFLAGS_VM) /* if virtual 8086 */
 		return 3;
 
-	vmx_get_segment(vcpu, &kvm_seg, VCPU_SREG_CS);
-	return kvm_seg.selector & 3;
+	return vmcs_read16(GUEST_CS_SELECTOR) & 3;
 }
 
 static u32 vmx_segment_access_rights(struct kvm_segment *var)
-- 
1.6.4.1

