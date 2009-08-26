Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbZHZKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbZHZKdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757226AbZHZKdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/47] KVM: Update cr8 intercept when APIC TPR is changed by userspace
Date: Wed, 26 Aug 2009 13:29:55 +0300
Message-Id: <1251282609-12835-34-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Since on vcpu entry we do it only if apic is enabled we should do
it when TPR is changed while apic is disabled. This happens when windows
resets HW without setting TPR to zero.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 132c510..31bf984 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -77,6 +77,7 @@ static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
 
+static void update_cr8_intercept(struct kvm_vcpu *vcpu);
 static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 				    struct kvm_cpuid_entry2 __user *entries);
 
@@ -1629,6 +1630,7 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 	vcpu_load(vcpu);
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof *s);
 	kvm_apic_post_state_restore(vcpu);
+	update_cr8_intercept(vcpu);
 	vcpu_put(vcpu);
 
 	return 0;
-- 
1.6.4.1

