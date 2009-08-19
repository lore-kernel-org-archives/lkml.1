Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbZHSNI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbZHSNI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZHSNEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:04:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50587 "EHLO mx2.redhat.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752024AbZHSNCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:02:49 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/47] KVM: switch pit creation to slots_lock
Date: Wed, 19 Aug 2009 16:02:39 +0300
Message-Id: <1250686963-8357-44-git-send-email-avi@redhat.com>
In-Reply-To: <1250686963-8357-1-git-send-email-avi@redhat.com>
References: <1250686963-8357-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

switch pit creation to slots_lock. slots_lock is already taken for read
everywhere, so we only need to take it for write when creating pit.
This is in preparation to removing in_range and kvm->lock around it.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0be75d5..7ce6367 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2188,7 +2188,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 				   sizeof(struct kvm_pit_config)))
 			goto out;
 	create_pit:
-		mutex_lock(&kvm->lock);
+		down_write(&kvm->slots_lock);
 		r = -EEXIST;
 		if (kvm->arch.vpit)
 			goto create_pit_unlock;
@@ -2197,7 +2197,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		if (kvm->arch.vpit)
 			r = 0;
 	create_pit_unlock:
-		mutex_unlock(&kvm->lock);
+		up_write(&kvm->slots_lock);
 		break;
 	case KVM_IRQ_LINE_STATUS:
 	case KVM_IRQ_LINE: {
-- 
1.6.3.3

