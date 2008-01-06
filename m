Return-Path: <linux-kernel-owner+w=401wt.eu-S1758216AbYAFOjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758216AbYAFOjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:39:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYAFOjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:41 -0500
Received: from il.qumranet.com ([82.166.9.18]:46584 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbYAFOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:41 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/33] KVM: SVM: support writing 0 to K8 performance counter control registers
Date: Sun,  6 Jan 2008 16:39:07 +0200
Message-Id: <1199630379-28638-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This lets SVM ignore writes of the value 0 to the performance counter control
registers.  Thus enabling them will still fail in the guest, but a write of 0
which keeps them disabled is accepted.  This is required to boot Windows
Vista 64bit.

[avi: avoid fall-thru in switch statement]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Markus Rechberger <markus.rechberger@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 9f8564a..839a75f 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1155,7 +1155,20 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	case MSR_IA32_SYSENTER_ESP:
 		svm->vmcb->save.sysenter_esp = data;
 		break;
+	case MSR_K7_EVNTSEL0:
+	case MSR_K7_EVNTSEL1:
+	case MSR_K7_EVNTSEL2:
+	case MSR_K7_EVNTSEL3:
+		/*
+		 * only support writing 0 to the performance counters for now
+		 * to make Windows happy. Should be replaced by a real
+		 * performance counter emulation later.
+		 */
+		if (data != 0)
+			goto unhandled;
+		break;
 	default:
+	unhandled:
 		return kvm_set_msr_common(vcpu, ecx, data);
 	}
 	return 0;
-- 
1.5.3.7

