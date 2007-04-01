Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXDAOnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXDAOnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXDAOm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:42:56 -0400
Received: from il.qumranet.com ([82.166.9.18]:47549 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933227AbXDAOfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:44 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 25/41] KVM: Modify guest segments after potentially switching modes
Date: Sun,  1 Apr 2007 17:35:22 +0300
Message-Id: <1175438139816-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139960-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The SET_SREGS ioctl modifies both cr0.pe (real mode/protected mode) and
guest segment registers.  Since segment handling is modified by the mode on
Intel procesors, update the segment registers after the mode switch has taken
place.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5ada7aa..12c3388 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1895,16 +1895,6 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 
 	vcpu_load(vcpu);
 
-	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
-	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
-	set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
-	set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
-	set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
-	set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
-
-	set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
-	set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
-
 	dt.limit = sregs->idt.limit;
 	dt.base = sregs->idt.base;
 	kvm_arch_ops->set_idt(vcpu, &dt);
@@ -1944,6 +1934,16 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 		if (vcpu->irq_pending[i])
 			__set_bit(i, &vcpu->irq_summary);
 
+	set_segment(vcpu, &sregs->cs, VCPU_SREG_CS);
+	set_segment(vcpu, &sregs->ds, VCPU_SREG_DS);
+	set_segment(vcpu, &sregs->es, VCPU_SREG_ES);
+	set_segment(vcpu, &sregs->fs, VCPU_SREG_FS);
+	set_segment(vcpu, &sregs->gs, VCPU_SREG_GS);
+	set_segment(vcpu, &sregs->ss, VCPU_SREG_SS);
+
+	set_segment(vcpu, &sregs->tr, VCPU_SREG_TR);
+	set_segment(vcpu, &sregs->ldt, VCPU_SREG_LDTR);
+
 	vcpu_put(vcpu);
 
 	return 0;
-- 
1.5.0.5

