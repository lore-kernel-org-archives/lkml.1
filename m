Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYLIUXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYLIUXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYLIUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34835 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbYLIUXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 02/44] KVM: ppc: fix set regs to take care of msr change
Date: Tue,  9 Dec 2008 22:22:17 +0200
Message-Id: <1228854179-23002-3-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

When changing some msr bits e.g. problem state we need to take special
care of that. We call the function in our mtmsr emulation (not needed for
wrtee[i]), but we don't call kvmppc_set_msr if we change msr via set_regs
ioctl.
It's a corner case we never hit so far, but I assume it should be
kvmppc_set_msr in our arch set regs function (I found it because it is also
a corner case when using pv support which would miss the update otherwise).

Signed-off-by: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/booke.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kvm/booke.c b/arch/powerpc/kvm/booke.c
index b23cd54..dec3f50 100644
--- a/arch/powerpc/kvm/booke.c
+++ b/arch/powerpc/kvm/booke.c
@@ -528,7 +528,7 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	vcpu->arch.ctr = regs->ctr;
 	vcpu->arch.lr = regs->lr;
 	vcpu->arch.xer = regs->xer;
-	vcpu->arch.msr = regs->msr;
+	kvmppc_set_msr(vcpu, regs->msr);
 	vcpu->arch.srr0 = regs->srr0;
 	vcpu->arch.srr1 = regs->srr1;
 	vcpu->arch.sprg0 = regs->sprg0;
-- 
1.6.0.3

