Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab0BMIHs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:07:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/39] KVM: PPC: Add helper functions to call real mode loaders
Date: Sat, 13 Feb 2010 10:01:50 +0200
Message-Id: <1266048119-14325-31-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Linux contains quite some bits of code to load FPU, Altivec and VSX lazily for
a task. It calls those bits in real mode, coming from an interrupt handler.

For KVM we better reuse those, so let's wrap a bit of trampoline magic around
them and then we can call them from normal module code.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_book3s.h   |    3 ++
 arch/powerpc/kvm/book3s_64_exports.c    |    7 ++++++
 arch/powerpc/kvm/book3s_64_rmhandlers.S |   34 +++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index c7db69f..e1b441c 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -124,6 +124,9 @@ extern void kvmppc_set_bat(struct kvm_vcpu *vcpu, struct kvmppc_bat *bat,
 extern u32 kvmppc_trampoline_lowmem;
 extern u32 kvmppc_trampoline_enter;
 extern void kvmppc_rmcall(ulong srr0, ulong srr1);
+extern void kvmppc_load_up_fpu(void);
+extern void kvmppc_load_up_altivec(void);
+extern void kvmppc_load_up_vsx(void);
 
 static inline struct kvmppc_vcpu_book3s *to_book3s(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/powerpc/kvm/book3s_64_exports.c b/arch/powerpc/kvm/book3s_64_exports.c
index 99b0712..1dd5a1d 100644
--- a/arch/powerpc/kvm/book3s_64_exports.c
+++ b/arch/powerpc/kvm/book3s_64_exports.c
@@ -23,3 +23,10 @@
 EXPORT_SYMBOL_GPL(kvmppc_trampoline_enter);
 EXPORT_SYMBOL_GPL(kvmppc_trampoline_lowmem);
 EXPORT_SYMBOL_GPL(kvmppc_rmcall);
+EXPORT_SYMBOL_GPL(kvmppc_load_up_fpu);
+#ifdef CONFIG_ALTIVEC
+EXPORT_SYMBOL_GPL(kvmppc_load_up_altivec);
+#endif
+#ifdef CONFIG_VSX
+EXPORT_SYMBOL_GPL(kvmppc_load_up_vsx);
+#endif
diff --git a/arch/powerpc/kvm/book3s_64_rmhandlers.S b/arch/powerpc/kvm/book3s_64_rmhandlers.S
index e7091c9..c83c60a 100644
--- a/arch/powerpc/kvm/book3s_64_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_64_rmhandlers.S
@@ -158,6 +158,40 @@ _GLOBAL(kvmppc_rmcall)
 	mtsrr1	r4
 	RFI
 
+/*
+ * Activate current's external feature (FPU/Altivec/VSX)
+ */
+#define define_load_up(what) 				\
+							\
+_GLOBAL(kvmppc_load_up_ ## what);			\
+	subi	r1, r1, INT_FRAME_SIZE;			\
+	mflr	r3;					\
+	std	r3, _LINK(r1);				\
+	mfmsr	r4;					\
+	std	r31, GPR3(r1);				\
+	mr	r31, r4;				\
+	li	r5, MSR_DR;				\
+	oris	r5, r5, MSR_EE@h;			\
+	andc	r4, r4, r5;				\
+	mtmsr	r4;					\
+							\
+	bl	.load_up_ ## what;			\
+							\
+	mtmsr	r31;					\
+	ld	r3, _LINK(r1);				\
+	ld	r31, GPR3(r1);				\
+	addi	r1, r1, INT_FRAME_SIZE;			\
+	mtlr	r3;					\
+	blr
+
+define_load_up(fpu)
+#ifdef CONFIG_ALTIVEC
+define_load_up(altivec)
+#endif
+#ifdef CONFIG_VSX
+define_load_up(vsx)
+#endif
+
 .global kvmppc_trampoline_lowmem
 kvmppc_trampoline_lowmem:
 	.long kvmppc_handler_lowmem_trampoline - _stext
-- 
1.6.5.3

