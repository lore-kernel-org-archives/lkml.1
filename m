Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbZB1Boo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbZB1Boo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZB1BmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:42:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbZB1Bl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:41:57 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/30] KVM: s390: Fix SIGP set prefix ioctl
Date: Sat, 28 Feb 2009 03:41:25 +0200
Message-Id: <1235785309-12835-7-git-send-email-avi@redhat.com>
In-Reply-To: <1235785309-12835-1-git-send-email-avi@redhat.com>
References: <1235785309-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch fixes the SET PREFIX interrupt if triggered by userspace.
Until now, it was not necessary, but life migration will need it. In
addition, it helped me creating SMP support for my kvm_crashme tool
(lets kvm execute random guest memory content).

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/s390/kvm/interrupt.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f4fe28a..0189356 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -555,9 +555,14 @@ int kvm_s390_inject_vcpu(struct kvm_vcpu *vcpu,
 		VCPU_EVENT(vcpu, 3, "inject: program check %d (from user)",
 			   s390int->parm);
 		break;
+	case KVM_S390_SIGP_SET_PREFIX:
+		inti->prefix.address = s390int->parm;
+		inti->type = s390int->type;
+		VCPU_EVENT(vcpu, 3, "inject: set prefix to %x (from user)",
+			   s390int->parm);
+		break;
 	case KVM_S390_SIGP_STOP:
 	case KVM_S390_RESTART:
-	case KVM_S390_SIGP_SET_PREFIX:
 	case KVM_S390_INT_EMERGENCY:
 		VCPU_EVENT(vcpu, 3, "inject: type %x", s390int->type);
 		inti->type = s390int->type;
-- 
1.6.0.6

