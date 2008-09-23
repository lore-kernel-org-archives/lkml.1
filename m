Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYIWNuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYIWNuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYIWNrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52362 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYIWNrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:15 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 10/40] KVM: VMX: Fix pending exception processing
Date: Tue, 23 Sep 2008 16:46:24 +0300
Message-Id: <1222177614-26669-11-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

The vmx code assumes that IDT-Vectoring can only be set when an exception
is injected due to the exception in question.  That's not true, however:
if the exception is injected correctly, and later another exception occurs
but its delivery is blocked due to a fault, then we will incorrectly assume
the first exception was not delivered.

Fix by unconditionally dequeuing the pending exception, and requeuing it
(or the second exception) if we see it in the IDT-Vectoring field.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ce13b53..ed4fe8e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/moduleparam.h>
 #include "kvm_cache_regs.h"
+#include "x86.h"
 
 #include <asm/io.h>
 #include <asm/desc.h>
@@ -744,9 +745,7 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 
 static bool vmx_exception_injected(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	return !(vmx->idt_vectoring_info & VECTORING_INFO_VALID_MASK);
+	return false;
 }
 
 /*
@@ -2824,6 +2823,7 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 	u8 vector;
 	int type;
 	bool idtv_info_valid;
+	u32 error;
 
 	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if (cpu_has_virtual_nmis()) {
@@ -2855,6 +2855,15 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 		else
 			vmx->vcpu.arch.nmi_injected = false;
 	}
+	kvm_clear_exception_queue(&vmx->vcpu);
+	if (idtv_info_valid && type == INTR_TYPE_EXCEPTION) {
+		if (idt_vectoring_info & VECTORING_INFO_DELIVER_CODE_MASK) {
+			error = vmcs_read32(IDT_VECTORING_ERROR_CODE);
+			kvm_queue_exception_e(&vmx->vcpu, vector, error);
+		} else
+			kvm_queue_exception(&vmx->vcpu, vector);
+		vmx->idt_vectoring_info = 0;
+	}
 }
 
 static void vmx_intr_assist(struct kvm_vcpu *vcpu)
-- 
1.6.0.1

