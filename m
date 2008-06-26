Return-Path: <linux-kernel-owner+w=401wt.eu-S1760754AbYFZMq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760754AbYFZMq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbYFZMaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:30:00 -0400
Received: from il.qumranet.com ([212.179.150.194]:32363 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbYFZM2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:36 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Lalancette <clalance@redhat.com>
Subject: [PATCH 11/50] KVM: SVM: Fake MSR_K7 performance counters
Date: Thu, 26 Jun 2008 15:27:53 +0300
Message-Id: <1214483312-9265-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Lalancette <clalance@redhat.com>

Attached is a patch that fixes a guest crash when booting older Linux kernels.
The problem stems from the fact that we are currently emulating
MSR_K7_EVNTSEL[0-3], but not emulating MSR_K7_PERFCTR[0-3].  Because of this,
setup_k7_watchdog() in the Linux kernel receives a GPF when it attempts to
write into MSR_K7_PERFCTR, which causes an OOPs.

The patch fixes it by just "fake" emulating the appropriate MSRs, throwing
away the data in the process.  This causes the NMI watchdog to not actually
work, but it's not such a big deal in a virtualized environment.

When we get a write to one of these counters, we printk_ratelimit() a warning.
I decided to print it out for all writes, even if the data is 0; it doesn't
seem to make sense to me to special case when data == 0.

Tested by myself on a RHEL-4 guest, and Joerg Roedel on a Windows XP 64-bit
guest.

Signed-off-by: Chris Lalancette <clalance@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 218949c..992ab71 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1312,16 +1312,19 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	case MSR_K7_EVNTSEL1:
 	case MSR_K7_EVNTSEL2:
 	case MSR_K7_EVNTSEL3:
+	case MSR_K7_PERFCTR0:
+	case MSR_K7_PERFCTR1:
+	case MSR_K7_PERFCTR2:
+	case MSR_K7_PERFCTR3:
 		/*
-		 * only support writing 0 to the performance counters for now
-		 * to make Windows happy. Should be replaced by a real
-		 * performance counter emulation later.
+		 * Just discard all writes to the performance counters; this
+		 * should keep both older linux and windows 64-bit guests
+		 * happy
 		 */
-		if (data != 0)
-			goto unhandled;
+		pr_unimpl(vcpu, "unimplemented perfctr wrmsr: 0x%x data 0x%llx\n", ecx, data);
+
 		break;
 	default:
-	unhandled:
 		return kvm_set_msr_common(vcpu, ecx, data);
 	}
 	return 0;
-- 
1.5.6

