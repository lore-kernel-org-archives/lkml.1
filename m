Return-Path: <linux-kernel-owner+w=401wt.eu-S1756021AbYLIU2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbYLIU2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYLIUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34864 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYLIUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 14/44] KVM: ppc: use prefetchable mappings for guest memory
Date: Tue,  9 Dec 2008 22:22:29 +0200
Message-Id: <1228854179-23002-15-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Bare metal Linux on 440 can "overmap" RAM in the kernel linear map, so that it
can use large (256MB) mappings even if memory isn't a multiple of 256MB. To
prevent the hardware prefetcher from loading from an invalid physical address
through that mapping, it's marked Guarded.

However, KVM must ensure that all guest mappings are backed by real physical
RAM (since a deliberate access through a guarded mapping could still cause a
machine check). Accordingly, we don't need to make our mappings guarded, so
let's allow prefetching as the designers intended.

Curiously this patch didn't affect performance at all on the quick test I
tried, but it's clearly the right thing to do anyways and may improve other
workloads.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/kvm/44x_tlb.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
index 260fa8b..6fadbd6 100644
--- a/arch/powerpc/kvm/44x_tlb.c
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -28,6 +28,8 @@
 
 #include "44x_tlb.h"
 
+#define PPC44x_TLB_UATTR_MASK \
+	(PPC44x_TLB_U0|PPC44x_TLB_U1|PPC44x_TLB_U2|PPC44x_TLB_U3)
 #define PPC44x_TLB_USER_PERM_MASK (PPC44x_TLB_UX|PPC44x_TLB_UR|PPC44x_TLB_UW)
 #define PPC44x_TLB_SUPER_PERM_MASK (PPC44x_TLB_SX|PPC44x_TLB_SR|PPC44x_TLB_SW)
 
@@ -63,8 +65,8 @@ void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
 
 static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
 {
-	/* Mask off reserved bits. */
-	attrib &= PPC44x_TLB_PERM_MASK|PPC44x_TLB_ATTR_MASK;
+	/* We only care about the guest's permission and user bits. */
+	attrib &= PPC44x_TLB_PERM_MASK|PPC44x_TLB_UATTR_MASK;
 
 	if (!usermode) {
 		/* Guest is in supervisor mode, so we need to translate guest
@@ -76,6 +78,9 @@ static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
 	/* Make sure host can always access this memory. */
 	attrib |= PPC44x_TLB_SX|PPC44x_TLB_SR|PPC44x_TLB_SW;
 
+	/* WIMGE = 0b00100 */
+	attrib |= PPC44x_TLB_M;
+
 	return attrib;
 }
 
-- 
1.6.0.3

