Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbZB0Kim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbZB0Kim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZB0K20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:28:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53576 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbZB0K1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:27:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/37] KVM: Properly lock PIT creation
Date: Fri, 27 Feb 2009 12:26:41 +0200
Message-Id: <1235730420-7929-19-git-send-email-avi@redhat.com>
In-Reply-To: <1235730420-7929-1-git-send-email-avi@redhat.com>
References: <1235730420-7929-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, two threads can create a PIT in parallel and cause a memory leak.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8254.c |    2 --
 arch/x86/kvm/x86.c   |    6 ++++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 528daad..69d1bbf 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -548,9 +548,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm)
 	if (!pit)
 		return NULL;
 
-	mutex_lock(&kvm->lock);
 	pit->irq_source_id = kvm_request_irq_source_id(kvm);
-	mutex_unlock(&kvm->lock);
 	if (pit->irq_source_id < 0) {
 		kfree(pit);
 		return NULL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1f1461..6fbc346 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1837,10 +1837,16 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto out;
 		break;
 	case KVM_CREATE_PIT:
+		mutex_lock(&kvm->lock);
+		r = -EEXIST;
+		if (kvm->arch.vpit)
+			goto create_pit_unlock;
 		r = -ENOMEM;
 		kvm->arch.vpit = kvm_create_pit(kvm);
 		if (kvm->arch.vpit)
 			r = 0;
+	create_pit_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_IRQ_LINE: {
 		struct kvm_irq_level irq_event;
-- 
1.6.0.6

