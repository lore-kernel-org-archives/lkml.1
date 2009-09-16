Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbZIPNYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbZIPNYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZIPNYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:24:45 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:23298
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382AbZIPNYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:24:44 -0400
X-SpamScore: 26
X-BigFish: VPS26(z41cfr329epba6l6cekzzz1202hzzz32i203h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KQ2FX2-01-3NC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Graf <agraf@suse.de>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] KVM: SVM: Remove remaining occurences of rdtscll
Date: Wed, 16 Sep 2009 15:24:19 +0200
Message-ID: <1253107459-8967-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
References: <1253107459-8967-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Sep 2009 13:24:23.0156 (UTC) FILETIME=[014FEB40:01CA36D1]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces them with native_read_tsc() which can
also be used in expressions and saves a variable on the
stack in this case.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e193cf9..12cef2c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -758,14 +758,13 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int i;
 
 	if (unlikely(cpu != vcpu->cpu)) {
-		u64 tsc_this, delta;
+		u64 delta;
 
 		/*
 		 * Make sure that the guest sees a monotonically
 		 * increasing TSC.
 		 */
-		rdtscll(tsc_this);
-		delta = vcpu->arch.host_tsc - tsc_this;
+		delta = vcpu->arch.host_tsc - native_read_tsc();
 		svm->vmcb->control.tsc_offset += delta;
 		if (is_nested(svm))
 			svm->nested.hsave->control.tsc_offset += delta;
@@ -787,7 +786,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
-	rdtscll(vcpu->arch.host_tsc);
+	vcpu->arch.host_tsc = native_read_tsc();
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
-- 
1.6.3.3


