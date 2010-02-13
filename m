Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab0BMIIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:08:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61458 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436Ab0BMICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/39] KVM: PPC: Make large pages work
Date: Sat, 13 Feb 2010 10:01:36 +0200
Message-Id: <1266048119-14325-17-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Graf <agraf@suse.de>

An SLB entry contains two pieces of information related to size:

  1) PTE size
  2) SLB size

The L bit defines the PTE be "large" (usually means 16MB),
SLB_VSID_B_1T defines that the SLB should span 1 GB instead of the
default 256MB.

Apparently I messed things up and just put those two in one box,
shaked it heavily and came up with the current code which handles
large pages incorrectly, because it also treats large page SLB entries
as "1TB" segment entries.

This patch splits those two features apart, making Linux guests boot
even when they have > 256MB.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/powerpc/include/asm/kvm_book3s.h |    3 ++-
 arch/powerpc/kvm/book3s_64_mmu.c      |   10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 79ab8fa..c7db69f 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -34,7 +34,8 @@ struct kvmppc_slb {
 	bool Ks;
 	bool Kp;
 	bool nx;
-	bool large;
+	bool large;	/* PTEs are 16MB */
+	bool tb;	/* 1TB segment */
 	bool class;
 };
 
diff --git a/arch/powerpc/kvm/book3s_64_mmu.c b/arch/powerpc/kvm/book3s_64_mmu.c
index e4beeb3..512dcff 100644
--- a/arch/powerpc/kvm/book3s_64_mmu.c
+++ b/arch/powerpc/kvm/book3s_64_mmu.c
@@ -54,7 +54,7 @@ static struct kvmppc_slb *kvmppc_mmu_book3s_64_find_slbe(
 		if (!vcpu_book3s->slb[i].valid)
 			continue;
 
-		if (vcpu_book3s->slb[i].large)
+		if (vcpu_book3s->slb[i].tb)
 			cmp_esid = esid_1t;
 
 		if (vcpu_book3s->slb[i].esid == cmp_esid)
@@ -65,9 +65,10 @@ static struct kvmppc_slb *kvmppc_mmu_book3s_64_find_slbe(
 		eaddr, esid, esid_1t);
 	for (i = 0; i < vcpu_book3s->slb_nr; i++) {
 	    if (vcpu_book3s->slb[i].vsid)
-		dprintk("  %d: %c%c %llx %llx\n", i,
+		dprintk("  %d: %c%c%c %llx %llx\n", i,
 			vcpu_book3s->slb[i].valid ? 'v' : ' ',
 			vcpu_book3s->slb[i].large ? 'l' : ' ',
+			vcpu_book3s->slb[i].tb    ? 't' : ' ',
 			vcpu_book3s->slb[i].esid,
 			vcpu_book3s->slb[i].vsid);
 	}
@@ -84,7 +85,7 @@ static u64 kvmppc_mmu_book3s_64_ea_to_vp(struct kvm_vcpu *vcpu, gva_t eaddr,
 	if (!slb)
 		return 0;
 
-	if (slb->large)
+	if (slb->tb)
 		return (((u64)eaddr >> 12) & 0xfffffff) |
 		       (((u64)slb->vsid) << 28);
 
@@ -309,7 +310,8 @@ static void kvmppc_mmu_book3s_64_slbmte(struct kvm_vcpu *vcpu, u64 rs, u64 rb)
 	slbe = &vcpu_book3s->slb[slb_nr];
 
 	slbe->large = (rs & SLB_VSID_L) ? 1 : 0;
-	slbe->esid  = slbe->large ? esid_1t : esid;
+	slbe->tb    = (rs & SLB_VSID_B_1T) ? 1 : 0;
+	slbe->esid  = slbe->tb ? esid_1t : esid;
 	slbe->vsid  = rs >> 12;
 	slbe->valid = (rb & SLB_ESID_V) ? 1 : 0;
 	slbe->Ks    = (rs & SLB_VSID_KS) ? 1 : 0;
-- 
1.6.5.3

