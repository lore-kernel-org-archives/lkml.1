Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYIWN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYIWN6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbYIWNrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52405 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYIWNri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:38 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 24/40] KVM: VMX: Avoid vmwrite(HOST_RSP) when possible
Date: Tue, 23 Sep 2008 16:46:38 +0300
Message-Id: <1222177614-26669-25-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Usually HOST_RSP retains its value across guest entries.  Take advantage
of this and avoid a vmwrite() when this is so.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index fc8996b..ddb49e3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -58,6 +58,7 @@ struct vmcs {
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
 	struct list_head      local_vcpus_link;
+	unsigned long         host_rsp;
 	int                   launched;
 	u8                    fail;
 	u32                   idt_vectoring_info;
@@ -2982,7 +2983,11 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		/* Store host registers */
 		"push %%"R"dx; push %%"R"bp;"
 		"push %%"R"cx \n\t"
+		"cmp %%"R"sp, %c[host_rsp](%0) \n\t"
+		"je 1f \n\t"
+		"mov %%"R"sp, %c[host_rsp](%0) \n\t"
 		__ex(ASM_VMX_VMWRITE_RSP_RDX) "\n\t"
+		"1: \n\t"
 		/* Check if vmlaunch of vmresume is needed */
 		"cmpl $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
@@ -3039,6 +3044,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	      : : "c"(vmx), "d"((unsigned long)HOST_RSP),
 		[launched]"i"(offsetof(struct vcpu_vmx, launched)),
 		[fail]"i"(offsetof(struct vcpu_vmx, fail)),
+		[host_rsp]"i"(offsetof(struct vcpu_vmx, host_rsp)),
 		[rax]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RAX])),
 		[rbx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RBX])),
 		[rcx]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_RCX])),
-- 
1.6.0.1

