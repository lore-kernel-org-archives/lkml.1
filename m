Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbZEXPxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbZEXPxF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757268AbZEXPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:51:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41861 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176AbZEXPuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:35 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 43/45] KVM: Do not migrate pending software interrupts.
Date: Sun, 24 May 2009 18:50:28 +0300
Message-Id: <1243180230-2480-44-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

INTn will be re-executed after migration. If we wanted to migrate
pending software interrupt we would need to migrate interrupt type
and instruction length too, but we do not have all required info on
SVM, so SVM->VMX migration would need to re-execute INTn anyway. To
make it simple never migrate pending soft interrupt.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index efba9bc..7037afa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3575,7 +3575,7 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 
 	memset(sregs->interrupt_bitmap, 0, sizeof sregs->interrupt_bitmap);
 
-	if (vcpu->arch.interrupt.pending)
+	if (vcpu->arch.interrupt.pending && !vcpu->arch.interrupt.soft)
 		set_bit(vcpu->arch.interrupt.nr,
 			(unsigned long *)sregs->interrupt_bitmap);
 
-- 
1.6.0.6

