Return-Path: <linux-kernel-owner+w=401wt.eu-S933228AbXDAOoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228AbXDAOoH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933245AbXDAOmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:42:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:47553 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 27/41] KVM: Don't allow the guest to turn off the cpu cache
Date: Sun,  1 Apr 2007 17:35:24 +0300
Message-Id: <11754381391993-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139141-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The cpu cache is a host resource; the guest should not be able to turn
it off (even for itself).

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index d3cc115..191bc45 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -737,8 +737,10 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 #endif
 	vcpu->svm->cr0 = cr0;
-	vcpu->svm->vmcb->save.cr0 = cr0 | CR0_PG_MASK | CR0_WP_MASK;
 	vcpu->cr0 = cr0;
+	cr0 |= CR0_PG_MASK | CR0_WP_MASK;
+	cr0 &= ~(CR0_CD_MASK | CR0_NW_MASK);
+	vcpu->svm->vmcb->save.cr0 = cr0;
 }
 
 static void svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-- 
1.5.0.5

