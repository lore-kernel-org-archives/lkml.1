Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXKHKgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXKHKgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 05:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbXKHKfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 05:35:09 -0500
Received: from il.qumranet.com ([82.166.9.18]:52465 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbXKHKfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:35:01 -0500
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 3/5] KVM: SVM: Defer nmi processing until switch to host state is complete
Date: Thu,  8 Nov 2007 12:35:28 +0200
Message-Id: <11945181301164-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11945181301744-git-send-email-avi@qumranet.com>
References: <11945181301744-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we stgi() too soon, nmis can reach the processor even though interrupts
are disabled, catching it in a half-switched state.  Delay the stgi() until
we're done switching.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 3910358..7376805 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1585,10 +1585,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 #endif
 		: "cc", "memory" );
 
-	local_irq_disable();
-
-	stgi();
-
 	if ((svm->vmcb->save.dr7 & 0xff))
 		load_db_regs(svm->host_db_regs);
 
@@ -1605,6 +1601,10 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	reload_tss(vcpu);
 
+	local_irq_disable();
+
+	stgi();
+
 	svm->next_rip = 0;
 }
 
-- 
1.5.3

