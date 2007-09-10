Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbXIJOOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbXIJOOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbXIJONU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:13:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45425 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758408AbXIJONS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:13:18 -0400
Message-ID: <46E550EF.5080209@bull.net>
Date: Mon, 10 Sep 2007 16:13:03 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RESEND 2][PATCH 4/4] Modify KVM to update guest time accounting.
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:57,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 10/09/2007 16:18:58,
	Serialize complete at 10/09/2007 16:18:58
Content-Type: multipart/mixed;
 boundary="------------060103030303050202030603"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060103030303050202030603
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1

[PATCH 4/4] Modify KVM to update guest time accounting.

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
-- 
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth



--------------060103030303050202030603
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="kvm_account_guest"
Content-Disposition: inline;
 filename="kvm_account_guest"

Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h	2007-09-10 14:56:52.000000000 +0200
+++ linux-2.6/drivers/kvm/kvm.h	2007-09-10 15:08:42.000000000 +0200
@@ -625,6 +625,19 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
 
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
+#ifndef PF_VCPU
+#define PF_VCPU	0
+#endif
+
+static inline void kvm_guest_enter(void)
+{
+	current->flags |= PF_VCPU;
+}
+
+static inline void kvm_guest_exit(void)
+{
+}
+
 static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 				     u32 error_code)
 {
Index: linux-2.6/drivers/kvm/svm.c
===================================================================
--- linux-2.6.orig/drivers/kvm/svm.c	2007-09-10 14:56:52.000000000 +0200
+++ linux-2.6/drivers/kvm/svm.c	2007-09-10 15:08:42.000000000 +0200
@@ -1494,6 +1494,7 @@ again:
 	clgi();
 
 	vcpu->guest_mode = 1;
+	kvm_guest_enter();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
@@ -1629,6 +1630,7 @@ again:
 #endif
 		: "cc", "memory" );
 
+	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 
 	if (vcpu->fpu_active) {
Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c	2007-09-10 14:56:52.000000000 +0200
+++ linux-2.6/drivers/kvm/vmx.c	2007-09-10 15:08:42.000000000 +0200
@@ -2018,6 +2018,7 @@ again:
 	local_irq_disable();
 
 	vcpu->guest_mode = 1;
+	kvm_guest_enter();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    vmx_flush_tlb(vcpu);
@@ -2138,6 +2139,7 @@ again:
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
 
+	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 

--------------060103030303050202030603--
