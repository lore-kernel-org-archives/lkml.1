Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0BMIE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:04:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0BMICH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:07 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/39] KVM: PPC: Fix initial GPR settings
Date: Sat, 13 Feb 2010 10:01:52 +0200
Message-Id: <1266048119-14325-33-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

Commit 7d01b4c3ed2bb33ceaf2d270cb4831a67a76b51b introduced PACA backed vcpu
values. With this patch, when a userspace app was setting GPRs before it was
actually first loaded, the set values get discarded.

This is because vcpu_load loads them from the vcpu backing store that we use
whenever we're not owning the PACA.

That behavior is not really a major problem, because we don't need it for
qemu. Other users (like kvmctl) do have problems with it though, so let's
better do it right.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |    1 -
 arch/powerpc/include/asm/kvm_ppc.h    |   10 ++++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index e1b441c..db7db0a 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -22,7 +22,6 @@
 
 #include <linux/types.h>
 #include <linux/kvm_host.h>
-#include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s_64_asm.h>
 
 struct kvmppc_slb {
diff --git a/arch/powerpc/include/asm/kvm_ppc.h b/arch/powerpc/include/asm/kvm_ppc.h
index 09816da..e264282 100644
--- a/arch/powerpc/include/asm/kvm_ppc.h
+++ b/arch/powerpc/include/asm/kvm_ppc.h
@@ -28,6 +28,9 @@
 #include <linux/types.h>
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
+#ifdef CONFIG_PPC_BOOK3S
+#include <asm/kvm_book3s.h>
+#endif
 
 enum emulation_result {
 	EMULATE_DONE,         /* no further processing */
@@ -102,9 +105,10 @@ extern void kvmppc_core_destroy_mmu(struct kvm_vcpu *vcpu);
 
 static inline void kvmppc_set_gpr(struct kvm_vcpu *vcpu, int num, ulong val)
 {
-	if ( num < 14 )
+	if ( num < 14 ) {
 		get_paca()->shadow_vcpu.gpr[num] = val;
-	else
+		to_book3s(vcpu)->shadow_vcpu.gpr[num] = val;
+	} else
 		vcpu->arch.gpr[num] = val;
 }
 
@@ -119,6 +123,7 @@ static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
 static inline void kvmppc_set_cr(struct kvm_vcpu *vcpu, u32 val)
 {
 	get_paca()->shadow_vcpu.cr = val;
+	to_book3s(vcpu)->shadow_vcpu.cr = val;
 }
 
 static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
@@ -129,6 +134,7 @@ static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
 static inline void kvmppc_set_xer(struct kvm_vcpu *vcpu, u32 val)
 {
 	get_paca()->shadow_vcpu.xer = val;
+	to_book3s(vcpu)->shadow_vcpu.xer = val;
 }
 
 static inline u32 kvmppc_get_xer(struct kvm_vcpu *vcpu)
-- 
1.6.5.3

