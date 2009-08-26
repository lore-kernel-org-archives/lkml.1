Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZHZKdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZHZKdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbZHZKdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/47] KVM: VMX: Adjust rflags if in real mode emulation
Date: Wed, 26 Aug 2009 13:29:58 +0300
Message-Id: <1251282609-12835-37-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We set rflags.vm86 when virtualizing real mode to do through vm8086 mode;
so we need to take it out again when reading rflags.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 31c3a87..2b7e7bd 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -781,7 +781,12 @@ static void vmx_fpu_deactivate(struct kvm_vcpu *vcpu)
 
 static unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 {
-	return vmcs_readl(GUEST_RFLAGS);
+	unsigned long rflags;
+
+	rflags = vmcs_readl(GUEST_RFLAGS);
+	if (to_vmx(vcpu)->rmode.vm86_active)
+		rflags &= ~(unsigned long)(X86_EFLAGS_IOPL | X86_EFLAGS_VM);
+	return rflags;
 }
 
 static void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
-- 
1.6.4.1

