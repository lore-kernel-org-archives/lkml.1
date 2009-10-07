Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZJGOcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZJGOcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759343AbZJGOcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:32:35 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:31212
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759342AbZJGOce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:32:34 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KR5F0U-01-FED-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 02/10] KVM: X86: Add KVM_REQ_VMEXIT to trigger a nested #vmexit
Date: Wed, 7 Oct 2009 16:31:20 +0200
Message-ID: <1254925888-13743-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
References: <1254925888-13743-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Oct 2009 14:31:35.0108 (UTC) FILETIME=[DF37B840:01CA475A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the vcpu_run path the kernel may notice that a #vmexit is
necessary when preemption is already disabled. In the SVM
code an emulation of #vmexit may sleep and can't be executed
with preemtion disabled. This patch begins to solve this
problem by defining a KVM_REQ_VMEXIT bit. When this bit is
set the vcpu_run loop is restarted and a #vmexit is
emulated.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   17 +++++++++++++++++
 include/linux/kvm_host.h        |    1 +
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 179a919..50e5aa4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -524,6 +524,7 @@ struct kvm_x86_ops {
 	int (*get_tdp_level)(void);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	bool (*gb_page_enable)(void);
+	void (*emulate_vmexit)(struct kvm_vcpu *vcpu);
 
 	const struct trace_print_flags *exit_reasons_str;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 11a6f2f..97e1d9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3610,6 +3610,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = 0;
 			goto out;
 		}
+		if (test_and_clear_bit(KVM_REQ_VMEXIT, &vcpu->requests))
+			 kvm_x86_ops->emulate_vmexit(vcpu);
 	}
 
 	preempt_disable();
@@ -3638,6 +3640,21 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	else if (kvm_cpu_has_interrupt(vcpu) || req_int_win)
 		kvm_x86_ops->enable_irq_window(vcpu);
 
+	/*
+	 * With nested KVM the enable_irq_window() function may cause an
+	 * #vmexit if the vcpu is running in guest mode. A #vmexit may sleep
+	 * and can't be executed at this stage. So we use the request field to
+	 * tell KVM that a #vmexit has to be done before we can enter the guest
+	 * again. The code below checks for this request.
+	 */
+	if (vcpu->requests) {
+		local_irq_enable();
+		preempt_enable();
+		r = 1;
+		goto out;
+	}
+
+
 	if (kvm_lapic_enabled(vcpu)) {
 		update_cr8_intercept(vcpu);
 		kvm_lapic_sync_to_vapic(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index b985a29..245463f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -38,6 +38,7 @@
 #define KVM_REQ_MMU_SYNC           7
 #define KVM_REQ_KVMCLOCK_UPDATE    8
 #define KVM_REQ_KICK               9
+#define KVM_REQ_VMEXIT             10
 
 #define KVM_USERSPACE_IRQ_SOURCE_ID	0
 
-- 
1.6.4.3


