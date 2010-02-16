Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932938Ab0BPKi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:38:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab0BPKfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:41 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/38] KVM: PPC E500: Add register l1csr0 emulation
Date: Tue, 16 Feb 2010 12:35:20 +0200
Message-Id: <1266316536-28936-23-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yu <yu.liu@freescale.com>

Latest kernel start to access l1csr0 to contron L1.
We just tell guest no operation is on going.

Signed-off-by: Liu Yu <yu.liu@freescale.com>
Acked-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/powerpc/include/asm/kvm_e500.h |    1 +
 arch/powerpc/kvm/e500_emulate.c     |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_e500.h b/arch/powerpc/include/asm/kvm_e500.h
index 9d497ce..569dfd3 100644
--- a/arch/powerpc/include/asm/kvm_e500.h
+++ b/arch/powerpc/include/asm/kvm_e500.h
@@ -52,6 +52,7 @@ struct kvmppc_vcpu_e500 {
 	u32 mas5;
 	u32 mas6;
 	u32 mas7;
+	u32 l1csr0;
 	u32 l1csr1;
 	u32 hid0;
 	u32 hid1;
diff --git a/arch/powerpc/kvm/e500_emulate.c b/arch/powerpc/kvm/e500_emulate.c
index 7644f7a..95f8ec8 100644
--- a/arch/powerpc/kvm/e500_emulate.c
+++ b/arch/powerpc/kvm/e500_emulate.c
@@ -99,6 +99,10 @@ int kvmppc_core_emulate_mtspr(struct kvm_vcpu *vcpu, int sprn, int rs)
 		vcpu_e500->mas6 = spr_val; break;
 	case SPRN_MAS7:
 		vcpu_e500->mas7 = spr_val; break;
+	case SPRN_L1CSR0:
+		vcpu_e500->l1csr0 = spr_val;
+		vcpu_e500->l1csr0 &= ~(L1CSR0_DCFI | L1CSR0_CLFC);
+		break;
 	case SPRN_L1CSR1:
 		vcpu_e500->l1csr1 = spr_val; break;
 	case SPRN_HID0:
@@ -179,6 +183,8 @@ int kvmppc_core_emulate_mfspr(struct kvm_vcpu *vcpu, int sprn, int rt)
 		break;
 	}
 
+	case SPRN_L1CSR0:
+		kvmppc_set_gpr(vcpu, rt, vcpu_e500->l1csr0); break;
 	case SPRN_L1CSR1:
 		kvmppc_set_gpr(vcpu, rt, vcpu_e500->l1csr1); break;
 	case SPRN_HID0:
-- 
1.6.5.3

