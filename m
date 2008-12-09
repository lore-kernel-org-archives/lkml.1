Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbYLIUe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbYLIUe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYLIUYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:20 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34884 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbYLIUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:12 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/44] KVM: VMX: Conditionally request interrupt window after injecting irq
Date: Tue,  9 Dec 2008 22:22:48 +0200
Message-Id: <1228854179-23002-34-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're injecting an interrupt, and another one is pending, request
an interrupt window notification so we don't have excess latency on the
second interrupt.

This shouldn't happen in practice since an EOI will be issued, giving a second
chance to request an interrupt window, but...

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f5958a7..7ea4855 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -3304,6 +3304,8 @@ static void vmx_intr_assist(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.interrupt.pending) {
 		vmx_inject_irq(vcpu, vcpu->arch.interrupt.nr);
 		kvm_timer_intr_post(vcpu, vcpu->arch.interrupt.nr);
+		if (kvm_cpu_has_interrupt(vcpu))
+			enable_irq_window(vcpu);
 	}
 }
 
-- 
1.6.0.3

