Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZB1BsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZB1BsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:48:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbZB1Bmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754710AbZB1Bl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:58 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/30] KVM: SVM: set accessed bit for VMCB segment selectors
Date: Sat, 28 Feb 2009 03:41:38 +0200
Message-Id: <1235785309-12835-20-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

In the segment descriptor _cache_ the accessed bit is always set
(although it can be cleared in the descriptor itself). Since Intel
checks for this condition on a VMENTRY, set this bit in the AMD path
to enable cross vendor migration.

Cc: stable@kernel.org
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Acked-By: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 22e88a4..1821c20 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -796,20 +796,37 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
 	var->g = (s->attrib >> SVM_SELECTOR_G_SHIFT) & 1;
 
-	/*
-	 * SVM always stores 0 for the 'G' bit in the CS selector in
-	 * the VMCB on a VMEXIT. This hurts cross-vendor migration:
-	 * Intel's VMENTRY has a check on the 'G' bit.
-	 */
-	if (seg == VCPU_SREG_CS)
+	switch (seg) {
+	case VCPU_SREG_CS:
+		/*
+		 * SVM always stores 0 for the 'G' bit in the CS selector in
+		 * the VMCB on a VMEXIT. This hurts cross-vendor migration:
+		 * Intel's VMENTRY has a check on the 'G' bit.
+		 */
 		var->g = s->limit > 0xfffff;
-
-	/*
-	 * Work around a bug where the busy flag in the tr selector
-	 * isn't exposed
-	 */
-	if (seg == VCPU_SREG_TR)
+		break;
+	case VCPU_SREG_TR:
+		/*
+		 * Work around a bug where the busy flag in the tr selector
+		 * isn't exposed
+		 */
 		var->type |= 0x2;
+		break;
+	case VCPU_SREG_DS:
+	case VCPU_SREG_ES:
+	case VCPU_SREG_FS:
+	case VCPU_SREG_GS:
+		/*
+		 * The accessed bit must always be set in the segment
+		 * descriptor cache, although it can be cleared in the
+		 * descriptor, the cached bit always remains at 1. Since
+		 * Intel has a check on this, set it here to support
+		 * cross-vendor migration.
+		 */
+		if (!var->unusable)
+			var->type |= 0x1;
+		break;
+	}
 
 	var->unusable = !var->present;
 }
-- 
1.6.0.6

