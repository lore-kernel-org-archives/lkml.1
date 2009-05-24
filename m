Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZEXQAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZEXQAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756401AbZEXPyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41834 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 15/45] KVM: SVM: Fix cross vendor migration issue in segment segment descriptor
Date: Sun, 24 May 2009 18:50:00 +0300
Message-Id: <1243180230-2480-16-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

On AMD CPUs sometimes the DB bit in the stack segment
descriptor is left as 1, although the whole segment has
been made unusable. Clear it here to pass an Intel VMX
entry check when cross vendor migrating.

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 6350378..e3ea982 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -803,6 +803,15 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 		if (!var->unusable)
 			var->type |= 0x1;
 		break;
+	case VCPU_SREG_SS:
+		/* On AMD CPUs sometimes the DB bit in the segment
+		 * descriptor is left as 1, although the whole segment has
+		 * been made unusable. Clear it here to pass an Intel VMX
+		 * entry check when cross vendor migrating.
+		 */
+		if (var->unusable)
+			var->db = 0;
+		break;
 	}
 }
 
-- 
1.6.0.6

