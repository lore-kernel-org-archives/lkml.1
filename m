Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYLHLtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYLHLtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbYLHLif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48240 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 30/45] KVM: SVM: Set the 'g' bit of the cs selector for cross-vendor migration
Date: Mon,  8 Dec 2008 13:36:41 +0200
Message-Id: <1228736216-15787-31-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@redhat.com>

The hardware does not set the 'g' bit of the cs selector and this breaks
migration from amd hosts to intel hosts. Set this bit if the segment
limit is beyond 1 MB.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 05efc4e..665008d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -772,6 +772,15 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	var->l = (s->attrib >> SVM_SELECTOR_L_SHIFT) & 1;
 	var->db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
 	var->g = (s->attrib >> SVM_SELECTOR_G_SHIFT) & 1;
+
+	/*
+	 * SVM always stores 0 for the 'G' bit in the CS selector in
+	 * the VMCB on a VMEXIT. This hurts cross-vendor migration:
+	 * Intel's VMENTRY has a check on the 'G' bit.
+	 */
+	if (seg == VCPU_SREG_CS)
+		var->g = s->limit > 0xfffff;
+
 	var->unusable = !var->present;
 }
 
-- 
1.6.0.3

