Return-Path: <linux-kernel-owner+w=401wt.eu-S1755901AbZBZORp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbZBZORp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 09:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZBZOPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 09:15:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43053 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbZBZOPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 09:15:40 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/40] KVM: MMU: Segregate mmu pages created with different cr4.pge settings
Date: Thu, 26 Feb 2009 16:15:11 +0200
Message-Id: <1235657730-27683-22-git-send-email-avi@redhat.com>
In-Reply-To: <1235657730-27683-1-git-send-email-avi@redhat.com>
References: <1235657730-27683-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow a vcpu with cr4.pge cleared to use a shadow page created with
cr4.pge set; this might cause a cr3 switch not to sync ptes that have the
global bit set (the global bit has no effect if !cr4.pge).

This can only occur on smp with different cr4.pge settings for different
vcpus (since a cr4 change will resync the shadow ptes), but there's no
cost to being correct here.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28f875f..c2a01d0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -183,6 +183,7 @@ union kvm_mmu_page_role {
 		unsigned metaphysical:1;
 		unsigned access:3;
 		unsigned invalid:1;
+		unsigned cr4_pge:1;
 	};
 };
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2477e87..873602b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -364,6 +364,7 @@ void kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	}
 	kvm_x86_ops->set_cr4(vcpu, cr4);
 	vcpu->arch.cr4 = cr4;
+	vcpu->arch.mmu.base_role.cr4_pge = !!(cr4 & X86_CR4_PGE);
 	kvm_mmu_sync_global(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
-- 
1.6.0.6

