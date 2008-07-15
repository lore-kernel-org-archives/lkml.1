Return-Path: <linux-kernel-owner+w=401wt.eu-S1761893AbYGOMSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761893AbYGOMSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756793AbYGOMNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:13:04 -0400
Received: from il.qumranet.com ([212.179.150.194]:30363 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbYGOMMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/19] KVM: Apply the kernel sigmask to vcpus blocked due to being uninitialized
Date: Tue, 15 Jul 2008 15:12:31 +0300
Message-Id: <1216123958-10717-13-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ef53d88..e3d146d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2958,15 +2958,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu_load(vcpu);
 
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
+
 	if (unlikely(vcpu->arch.mp_state == KVM_MP_STATE_UNINITIALIZED)) {
 		kvm_vcpu_block(vcpu);
-		vcpu_put(vcpu);
-		return -EAGAIN;
+		r = -EAGAIN;
+		goto out;
 	}
 
-	if (vcpu->sigset_active)
-		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
-
 	/* re-sync apic's tpr */
 	if (!irqchip_in_kernel(vcpu->kvm))
 		kvm_set_cr8(vcpu, kvm_run->cr8);
-- 
1.5.6.1

