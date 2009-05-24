Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZEXPxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZEXPxx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbZEXPvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41854 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 34/45] KVM: s390: Sanity check on validity intercept
Date: Sun, 24 May 2009 18:50:19 +0300
Message-Id: <1243180230-2480-35-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch adds a sanity check for the content of the guest
prefix register content before faulting in the cpu lowcore
that it refers to. The guest might end up in an endless loop
where SIE complains about missing lowcore with incorrect
content of the prefix register without this fix.

Reported-by: Mijo Safradin <mijo@linux.vnet.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Ehrhardt <ehrhardt@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/intercept.c |   28 ++++++++++++++++++----------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 9d19803..98997cc 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -154,17 +154,25 @@ static int handle_stop(struct kvm_vcpu *vcpu)
 static int handle_validity(struct kvm_vcpu *vcpu)
 {
 	int viwhy = vcpu->arch.sie_block->ipb >> 16;
+	int rc;
+
 	vcpu->stat.exit_validity++;
-	if (viwhy == 0x37) {
-		fault_in_pages_writeable((char __user *)
-					 vcpu->kvm->arch.guest_origin +
-					 vcpu->arch.sie_block->prefix,
-					 PAGE_SIZE);
-		return 0;
-	}
-	VCPU_EVENT(vcpu, 2, "unhandled validity intercept code %d",
-		   viwhy);
-	return -ENOTSUPP;
+	if ((viwhy == 0x37) && (vcpu->arch.sie_block->prefix
+		<= vcpu->kvm->arch.guest_memsize - 2*PAGE_SIZE)){
+		rc = fault_in_pages_writeable((char __user *)
+			 vcpu->kvm->arch.guest_origin +
+			 vcpu->arch.sie_block->prefix,
+			 2*PAGE_SIZE);
+		if (rc)
+			/* user will receive sigsegv, exit to user */
+			rc = -ENOTSUPP;
+	} else
+		rc = -ENOTSUPP;
+
+	if (rc)
+		VCPU_EVENT(vcpu, 2, "unhandled validity intercept code %d",
+			   viwhy);
+	return rc;
 }
 
 static int handle_instruction(struct kvm_vcpu *vcpu)
-- 
1.6.0.6

