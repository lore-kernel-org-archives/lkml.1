Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbZIPN1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbZIPN1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZIPN1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:27:12 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:25852 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZIPNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:51 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KQ2FX9-01-3NO-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] KVM: SVM: Handle tsc in svm_get_msr/svm_set_msr correctly
Date: Wed, 16 Sep 2009 15:24:18 +0200
Message-ID: <1253107459-8967-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:24:23.0421 (UTC) FILETIME=[01785AD0:01CA36D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running nested we need to touch the l1 guests
tsc_offset. Otherwise changes will be lost or a wrong value
be read.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   23 +++++++++++++++++------
 1 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 84c2c78..e193cf9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2059,10 +2059,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 
 	switch (ecx) {
 	case MSR_IA32_TSC: {
-		u64 tsc;
+		u64 tsc_offset;
 
-		rdtscll(tsc);
-		*data = svm->vmcb->control.tsc_offset + tsc;
+		if (is_nested(svm))
+			tsc_offset = svm->nested.hsave->control.tsc_offset;
+		else
+			tsc_offset = svm->vmcb->control.tsc_offset;
+
+		*data = tsc_offset + native_read_tsc();
 		break;
 	}
 	case MSR_K6_STAR:
@@ -2148,10 +2152,17 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 
 	switch (ecx) {
 	case MSR_IA32_TSC: {
-		u64 tsc;
+		u64 tsc_offset = data - native_read_tsc();
+		u64 g_tsc_offset = 0;
+
+		if (is_nested(svm)) {
+			g_tsc_offset = svm->vmcb->control.tsc_offset -
+				       svm->nested.hsave->control.tsc_offset;
+			svm->nested.hsave->control.tsc_offset = tsc_offset;
+		}
+
+		svm->vmcb->control.tsc_offset = tsc_offset + g_tsc_offset;
 
-		rdtscll(tsc);
-		svm->vmcb->control.tsc_offset = data - tsc;
 		break;
 	}
 	case MSR_K6_STAR:
-- 
1.6.3.3


