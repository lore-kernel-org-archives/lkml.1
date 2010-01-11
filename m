Return-Path: <linux-kernel-owner+w=401wt.eu-S1752494Ab0AKIHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab0AKIHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 03:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269Ab0AKIHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 03:07:51 -0500
Received: from ozlabs.org ([203.10.76.45]:39871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab0AKIHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 03:07:50 -0500
Date: Mon, 11 Jan 2010 19:07:49 +1100
From: Stephen Rothwell <Stephen@Rothwell.id.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>
Subject: linux-next: kvm tree build failure
Message-Id: <20100111190749.0a74d445.Stephen@Rothwell.id.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

arch/powerpc/kvm/booke_emulate.c: In function 'kvmppc_booke_emulate_mfspr':
arch/powerpc/kvm/booke_emulate.c:201: error: expected ')' before ';' token
arch/powerpc/kvm/booke_emulate.c:203: error: expected ')' before ';' token
arch/powerpc/kvm/booke_emulate.c:205: error: expected ')' before ';' token
arch/powerpc/kvm/booke_emulate.c:207: error: expected ')' before ';' token
arch/powerpc/kvm/booke_emulate.c:209: error: expected ')' before ';' token
arch/powerpc/kvm/booke_emulate.c:211: error: expected ')' before ';' token
arch/powerpc/kvm/44x_emulate.c: In function 'kvmppc_core_emulate_mfspr':
arch/powerpc/kvm/44x_emulate.c:171: error: lvalue required as left operand of assignment
arch/powerpc/kvm/44x_emulate.c:173: error: lvalue required as left operand of assignment
arch/powerpc/kvm/44x_emulate.c:175: error: lvalue required as left operand of assignment
arch/powerpc/kvm/44x_emulate.c:177: error: lvalue required as left operand of assignment

Caused by commit 7f31fad9aad3bb9df95793d72e037bb4d587ee83 ("KVM: PPC: Use
accessor functions for GPR access").  I couldn't easily revert that
commit, so I applied the following fixup patch instead.

More care is required ... please at least build test.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Jan 2010 18:50:23 +1100
Subject: [PATCH] kvm: fixup for botched PPC update

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/kvm/44x_emulate.c   |    8 ++++----
 arch/powerpc/kvm/booke_emulate.c |   12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kvm/44x_emulate.c b/arch/powerpc/kvm/44x_emulate.c
index 0ff0d40..65ea083 100644
--- a/arch/powerpc/kvm/44x_emulate.c
+++ b/arch/powerpc/kvm/44x_emulate.c
@@ -168,13 +168,13 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 
 	switch (sprn) {
 	case SPRN_PID:
-		kvmppc_get_gpr(vcpu, rt) = vcpu->arch.pid; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.pid); break;
 	case SPRN_MMUCR:
-		kvmppc_get_gpr(vcpu, rt) = vcpu->arch.mmucr; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.mmucr); break;
 	case SPRN_CCR0:
-		kvmppc_get_gpr(vcpu, rt) = vcpu->arch.ccr0; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ccr0); break;
 	case SPRN_CCR1:
-		kvmppc_get_gpr(vcpu, rt) = vcpu->arch.ccr1; break;
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ccr1); break;
 	default:
 		emulated = kvmppc_booke_emulate_mfspr(vcpu, sprn, rt);
 	}
diff --git a/arch/powerpc/kvm/booke_emulate.c b/arch/powerpc/kvm/booke_emulate.c
index ab1786c..cbc790e 100644
--- a/arch/powerpc/kvm/booke_emulate.c
+++ b/arch/powerpc/kvm/booke_emulate.c
@@ -198,17 +198,17 @@ int kvmppc_booke_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 
 	switch (sprn) {
 	case SPRN_IVPR:
-		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivpr; break);
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivpr); break;
 	case SPRN_DEAR:
-		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dear; break);
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dear); break;
 	case SPRN_ESR:
-		kvmppc_set_gpr(vcpu, rt, vcpu->arch.esr; break);
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.esr); break;
 	case SPRN_DBCR0:
-		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbcr0; break);
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbcr0); break;
 	case SPRN_DBCR1:
-		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbcr1; break);
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbcr1); break;
 	case SPRN_DBSR:
-		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbsr; break);
+		kvmppc_set_gpr(vcpu, rt, vcpu->arch.dbsr); break;
 
 	case SPRN_IVOR0:
 		kvmppc_set_gpr(vcpu, rt, vcpu->arch.ivor[BOOKE_IRQPRIO_CRITICAL]);
-- 
1.6.5.7


-- 
Cheers,
Stephen Rothwell                    Stephen@Rothwell.id.au
