Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab0BMIJr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:09:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 14/39] KVM: PPC: Pass program interrupt flags to the guest
Date: Sat, 13 Feb 2010 10:01:34 +0200
Message-Id: <1266048119-14325-15-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

When we need to reinject a program interrupt into the guest, we also need to
reinject the corresponding flags into the guest.

Signed-off-by: Alexander Graf <agraf@suse.de>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/book3s.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 66b5924..02861fd 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -633,6 +633,9 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 	case BOOK3S_INTERRUPT_PROGRAM:
 	{
 		enum emulation_result er;
+		ulong flags;
+
+		flags = (vcpu->arch.shadow_msr & 0x1f0000ull);
 
 		if (vcpu->arch.msr & MSR_PR) {
 #ifdef EXIT_DEBUG
@@ -640,7 +643,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 #endif
 			if ((vcpu->arch.last_inst & 0xff0007ff) !=
 			    (INS_DCBZ & 0xfffffff7)) {
-				kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
+				kvmppc_core_queue_program(vcpu, flags);
 				r = RESUME_GUEST;
 				break;
 			}
@@ -655,7 +658,7 @@ int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
 		case EMULATE_FAIL:
 			printk(KERN_CRIT "%s: emulation at %lx failed (%08x)\n",
 			       __func__, vcpu->arch.pc, vcpu->arch.last_inst);
-			kvmppc_book3s_queue_irqprio(vcpu, exit_nr);
+			kvmppc_core_queue_program(vcpu, flags);
 			r = RESUME_GUEST;
 			break;
 		default:
-- 
1.6.5.3

