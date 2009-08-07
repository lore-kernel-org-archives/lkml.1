Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbZHGJxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbZHGJxE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 05:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbZHGJui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 05:50:38 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:18838 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913AbZHGJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 05:50:10 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KO03BD-04-L8K-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>
CC: Alexander Graf <agraf@suse.de>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/21] kvm/svm: handle errors in vmrun emulation path appropriatly
Date: Fri, 7 Aug 2009 11:49:43 +0200
Message-ID: <1249638588-10982-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
References: <1249638588-10982-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 07 Aug 2009 09:49:51.0202 (UTC) FILETIME=[68819C20:01CA1744]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If nested svm fails to load the msrpm the vmrun succeeds with the old
msrpm which is not correct. This patch changes the logic to roll back
to host mode in case the msrpm cannot be loaded.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 63d2f63..cad7582 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1880,6 +1880,7 @@ static int vmsave_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	nsvm_printk("VMrun\n");
+
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
@@ -1890,7 +1891,18 @@ static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 		return 1;
 
 	if (!nested_svm_vmrun_msrpm(svm))
-		return 1;
+		goto failed;
+
+	return 1;
+
+failed:
+
+	svm->vmcb->control.exit_code    = SVM_EXIT_ERR;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1  = 0;
+	svm->vmcb->control.exit_info_2  = 0;
+
+	nested_svm_vmexit(svm);
 
 	return 1;
 }
-- 
1.6.3.3


