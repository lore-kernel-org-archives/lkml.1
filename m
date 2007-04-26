Return-Path: <linux-kernel-owner+w=401wt.eu-S933769AbXDZJ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbXDZJ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXDZJ1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:27:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:53032 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933769AbXDZJW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:22:26 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/18] KVM: Handle guest page faults when emulating mmio
Date: Thu, 26 Apr 2007 12:22:08 +0300
Message-Id: <11775793383942-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11775793382353-git-send-email-avi@qumranet.com>
References: <11775793382353-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Usually, guest page faults are detected by the kvm page fault handler,
which detects if they are shadow faults, mmio faults, pagetable faults,
or normal guest page faults.

However, in ceratin circumstances, we can detect a page fault much later.
One of these events is the following combination:

- A two memory operand instruction (e.g. movsb) is executed.
- The first operand is in mmio space (which is the fault reported to kvm)
- The second operand is in an ummaped address (e.g. a guest page fault)

The Windows 2000 installer does such an access, an promptly hangs.  Fix
by adding the missing page fault injection on that path.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index ab4dbd7..03c0ee7 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1071,8 +1071,10 @@ static int emulator_write_emulated(unsigned long addr,
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
 
-	if (gpa == UNMAPPED_GVA)
+	if (gpa == UNMAPPED_GVA) {
+		kvm_arch_ops->inject_page_fault(vcpu, addr, 2);
 		return X86EMUL_PROPAGATE_FAULT;
+	}
 
 	if (emulator_write_phys(vcpu, gpa, val, bytes))
 		return X86EMUL_CONTINUE;
-- 
1.5.0.6

