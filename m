Return-Path: <linux-kernel-owner+w=401wt.eu-S1760692AbXJOJiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760692AbXJOJiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757750AbXJOJiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:38:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35743 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbXJOJiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:38:12 -0400
Date: Mon, 15 Oct 2007 11:38:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Avi Kivity <avi@qumranet.com>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time
	accounting.
Message-ID: <20071015093800.GA22818@elte.hu>
References: <46E550EF.5080209@bull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E550EF.5080209@bull.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Laurent Vivier <Laurent.Vivier@bull.net> wrote:

> [PATCH 4/4] Modify KVM to update guest time accounting.

FYI, KVM abstracted its guest-mode entry code recently so this did not 
apply - find below the reworked patch.

	Ingo

------------------->
Subject: sched: guest CPU accounting: maintain guest state in KVM
From: Laurent Vivier <Laurent.Vivier@bull.net>

Modify KVM to update guest time accounting.

[ mingo@elte.hu: ported to 2.6.24 KVM. ]

Signed-off-by: Laurent Vivier <Laurent.Vivier@bull.net>
Acked-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/kvm/kvm.h      |   16 ++++++++++++++++
 drivers/kvm/kvm_main.c |    2 ++
 2 files changed, 18 insertions(+)

Index: linux/drivers/kvm/kvm.h
===================================================================
--- linux.orig/drivers/kvm/kvm.h
+++ linux/drivers/kvm/kvm.h
@@ -624,6 +624,22 @@ void kvm_mmu_unload(struct kvm_vcpu *vcp
 
 int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run);
 
+/*
+ * Compatibility define - PF_VCPU is only available in v2.6.24+ kernels:
+ */
+#ifndef PF_VCPU
+# define PF_VCPU	0
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
Index: linux/drivers/kvm/kvm_main.c
===================================================================
--- linux.orig/drivers/kvm/kvm_main.c
+++ linux/drivers/kvm/kvm_main.c
@@ -2046,6 +2046,7 @@ again:
 		kvm_x86_ops->inject_pending_vectors(vcpu, kvm_run);
 
 	vcpu->guest_mode = 1;
+	kvm_guest_enter();
 
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
@@ -2053,6 +2054,7 @@ again:
 
 	kvm_x86_ops->run(vcpu, kvm_run);
 
+	kvm_guest_exit();
 	vcpu->guest_mode = 0;
 	local_irq_enable();
 
