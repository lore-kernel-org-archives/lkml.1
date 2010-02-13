Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0BMIEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:04:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633Ab0BMICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:05 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/39] KVM: Implement NotifyLongSpinWait HYPER-V hypercall
Date: Sat, 13 Feb 2010 10:01:58 +0200
Message-Id: <1266048119-14325-39-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Windows issues this hypercall after guest was spinning on a spinlock
for too many iterations.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Vadim Rozenfeld <vrozenfe@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c  |   10 +++++++++-
 include/linux/kvm.h |    1 +
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 552be51..9f72a44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1564,6 +1564,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_VCPU_EVENTS:
 	case KVM_CAP_HYPERV:
 	case KVM_CAP_HYPERV_VAPIC:
+	case KVM_CAP_HYPERV_SPIN:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -3827,7 +3828,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 
 	trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
 
-	res = HV_STATUS_INVALID_HYPERCALL_CODE;
+	switch (code) {
+	case HV_X64_HV_NOTIFY_LONG_SPIN_WAIT:
+		kvm_vcpu_on_spin(vcpu);
+		break;
+	default:
+		res = HV_STATUS_INVALID_HYPERCALL_CODE;
+		break;
+	}
 
 	ret = res | (((u64)rep_done & 0xfff) << 32);
 	if (longmode) {
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5ce6173..4c4937e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -499,6 +499,7 @@ struct kvm_ioeventfd {
 #define KVM_CAP_PPC_SEGSTATE 43
 #define KVM_CAP_HYPERV 44
 #define KVM_CAP_HYPERV_VAPIC 45
+#define KVM_CAP_HYPERV_SPIN 46
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
1.6.5.3

