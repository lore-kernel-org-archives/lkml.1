Return-Path: <linux-kernel-owner+w=401wt.eu-S965556AbXA3OzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965556AbXA3OzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965558AbXA3OzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:55:20 -0500
Received: from il.qumranet.com ([62.219.232.206]:51162 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965556AbXA3OzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:55:18 -0500
Subject: [PATCH 3/5] KVM: VMX: add vcpu_clear()
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:55:16 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF5B96.1070007@qumranet.com>
In-Reply-To: <45BF5B96.1070007@qumranet.com>
Message-Id: <20070130145516.E8BEDA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Like the inline code it replaces, this function decaches the vmcs from the cpu
it last executed on.  in addition:

 - vcpu_clear() works if the last cpu is also the cpu we're running on
 - it is faster on larger smps by virtue of using smp_call_function_single()

Includes fix from Ingo Molnar.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -125,6 +125,15 @@ static void __vcpu_clear(void *arg)
 		per_cpu(current_vmcs, cpu) = NULL;
 }
 
+static void vcpu_clear(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->cpu != raw_smp_processor_id() && vcpu->cpu != -1)
+		smp_call_function_single(vcpu->cpu, __vcpu_clear, vcpu, 0, 1);
+	else
+		__vcpu_clear(vcpu);
+	vcpu->launched = 0;
+}
+
 static unsigned long vmcs_readl(unsigned long field)
 {
 	unsigned long value;
@@ -202,10 +211,8 @@ static struct kvm_vcpu *vmx_vcpu_load(st
 
 	cpu = get_cpu();
 
-	if (vcpu->cpu != cpu) {
-		smp_call_function(__vcpu_clear, vcpu, 0, 1);
-		vcpu->launched = 0;
-	}
+	if (vcpu->cpu != cpu)
+		vcpu_clear(vcpu);
 
 	if (per_cpu(current_vmcs, cpu) != vcpu->vmcs) {
 		u8 error;
