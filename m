Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZLNLlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZLNLlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbZLNLlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:41:37 -0500
Received: from mail-va3.bigfish.com ([216.32.180.111]:43826 "EHLO
	mail10-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756922AbZLNLlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:41:36 -0500
X-Greylist: delayed 1138 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Dec 2009 06:41:35 EST
X-SpamScore: 3
X-BigFish: VPS3(zzab9bhzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0KUN3LB-02-03F-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] KVM: SVM: Adjust tsc_offset only if tsc_unstable
Date: Mon, 14 Dec 2009 12:22:20 +0100
Message-ID: <1260789740-14847-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5.4
X-OriginalArrivalTime: 14 Dec 2009 11:22:23.0829 (UTC) FILETIME=[B56B0050:01CA7CAF]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tsc_offset adjustment in svm_vcpu_load is executed
unconditionally even if Linux considers the host tsc as
stable. This causes a Linux guest detecting an unstable tsc
in any case.
This patch removes the tsc_offset adjustment if the host tsc
is stable. The guest will now get the benefit of a stable
tsc too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3de0b37..cb04378 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -767,14 +767,16 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (unlikely(cpu != vcpu->cpu)) {
 		u64 delta;
 
-		/*
-		 * Make sure that the guest sees a monotonically
-		 * increasing TSC.
-		 */
-		delta = vcpu->arch.host_tsc - native_read_tsc();
-		svm->vmcb->control.tsc_offset += delta;
-		if (is_nested(svm))
-			svm->nested.hsave->control.tsc_offset += delta;
+		if (check_tsc_unstable()) {
+			/*
+			 * Make sure that the guest sees a monotonically
+			 * increasing TSC.
+			 */
+			delta = vcpu->arch.host_tsc - native_read_tsc();
+			svm->vmcb->control.tsc_offset += delta;
+			if (is_nested(svm))
+				svm->nested.hsave->control.tsc_offset += delta;
+		}
 		vcpu->cpu = cpu;
 		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
-- 
1.6.5.4


