Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYIWNty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYIWNty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753106AbYIWNrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52359 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587AbYIWNrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:13 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/40] KVM: Clear exception queue before emulating an instruction
Date: Tue, 23 Sep 2008 16:46:23 +0300
Message-Id: <1222177614-26669-10-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

If we're emulating an instruction, either it will succeed, in which case
any previously queued exception will be spurious, or we will requeue the
same exception.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |    2 ++
 arch/x86/kvm/x86.h |   11 +++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/kvm/x86.h

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2f0696b..5620df2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -20,6 +20,7 @@
 #include "i8254.h"
 #include "tss.h"
 #include "kvm_cache_regs.h"
+#include "x86.h"
 
 #include <linux/clocksource.h>
 #include <linux/kvm.h>
@@ -2121,6 +2122,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	int r;
 	struct decode_cache *c;
 
+	kvm_clear_exception_queue(vcpu);
 	vcpu->arch.mmio_fault_cr2 = cr2;
 	/*
 	 * TODO: fix x86_emulate.c to use guest_read/write_register
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
new file mode 100644
index 0000000..c666649
--- /dev/null
+++ b/arch/x86/kvm/x86.h
@@ -0,0 +1,11 @@
+#ifndef ARCH_X86_KVM_X86_H
+#define ARCH_X86_KVM_X86_H
+
+#include <linux/kvm_host.h>
+
+static inline void kvm_clear_exception_queue(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exception.pending = false;
+}
+
+#endif
-- 
1.6.0.1

