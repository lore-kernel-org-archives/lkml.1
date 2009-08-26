Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZHZKeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZHZKeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbZHZKds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbZHZKaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:13 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/47] KVM: SVM: handle errors in vmrun emulation path appropriatly
Date: Wed, 26 Aug 2009 13:29:49 +0300
Message-Id: <1251282609-12835-28-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

If nested svm fails to load the msrpm the vmrun succeeds with the old
msrpm which is not correct. This patch changes the logic to roll back
to host mode in case the msrpm cannot be loaded.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/svm.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 42b8b67..2edf2dd 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1877,6 +1877,7 @@ static int vmsave_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
 {
 	nsvm_printk("VMrun\n");
+
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
@@ -1887,7 +1888,18 @@ static int vmrun_interception(struct vcpu_svm *svm, struct kvm_run *kvm_run)
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
1.6.4.1

