Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYIYL7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYIYL7X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbYIYLzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48547 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798AbYIYLzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:39 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Mohammed Gamal <m.gamal005@gmail.com>
Subject: [PATCH 11/39] KVM: VMX: Add invalid guest state handler
Date: Thu, 25 Sep 2008 14:54:43 +0300
Message-Id: <1222343711-12508-12-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mohammed Gamal <m.gamal005@gmail.com>

This adds the invalid guest state handler function which invokes the x86
emulator until getting the guest to a VMX-friendly state.

[avi: leave atomic context if scheduling]
[guillaume: return to atomic context correctly]

Signed-off-by: Laurent Vivier <laurent.vivier@bull.net>
Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/vmx.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 7c5f611..eae1f2c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2892,6 +2892,43 @@ static int handle_nmi_window(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 	return 1;
 }
 
+static void handle_invalid_guest_state(struct kvm_vcpu *vcpu,
+				struct kvm_run *kvm_run)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int err;
+
+	preempt_enable();
+	local_irq_enable();
+
+	while (!guest_state_valid(vcpu)) {
+		err = emulate_instruction(vcpu, kvm_run, 0, 0, 0);
+
+		switch (err) {
+			case EMULATE_DONE:
+				break;
+			case EMULATE_DO_MMIO:
+				kvm_report_emulation_failure(vcpu, "mmio");
+				/* TODO: Handle MMIO */
+				return;
+			default:
+				kvm_report_emulation_failure(vcpu, "emulation failure");
+				return;
+		}
+
+		if (signal_pending(current))
+			break;
+		if (need_resched())
+			schedule();
+	}
+
+	local_irq_disable();
+	preempt_disable();
+
+	/* Guest state should be valid now, no more emulation should be needed */
+	vmx->emulation_required = 0;
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
-- 
1.6.0.1

