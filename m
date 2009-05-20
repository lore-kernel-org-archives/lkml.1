Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZETLUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZETLUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbZETLS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:18:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55258 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbZETLSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:47 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 06/46] KVM: MMU: Use different shadows when EFER.NXE changes
Date: Wed, 20 May 2009 14:18:03 +0300
Message-Id: <1242818323-10413-7-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pte that is shadowed when the guest EFER.NXE=1 is not valid when
EFER.NXE=0; if bit 63 is set, the pte should cause a fault, and since the
shadow EFER always has NX enabled, this won't happen.

Fix by using a different shadow page table for different EFER.NXE bits.  This
allows vcpus to run correctly with different values of EFER.NXE, and for
transitions on this bit to be handled correctly without requiring a full
flush.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    3 +++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 548b97d..3fc4623 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -185,6 +185,7 @@ union kvm_mmu_page_role {
 		unsigned access:3;
 		unsigned invalid:1;
 		unsigned cr4_pge:1;
+		unsigned nxe:1;
 	};
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 12ada0e..637bb80 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -519,6 +519,9 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 	efer |= vcpu->arch.shadow_efer & EFER_LMA;
 
 	vcpu->arch.shadow_efer = efer;
+
+	vcpu->arch.mmu.base_role.nxe = (efer & EFER_NX) && !tdp_enabled;
+	kvm_mmu_reset_context(vcpu);
 }
 
 void kvm_enable_efer_bits(u64 mask)
-- 
1.6.0.6

