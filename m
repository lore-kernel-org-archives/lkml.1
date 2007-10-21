Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbXJULJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbXJULJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbXJULH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:07:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:58442 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXJULHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:54 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Eddie Dong <eddie.dong@intel.com>,
       Qing He <qing.he@intel.com>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 05/11] KVM: VMX: Reset mmu context when entering real mode
Date: Sun, 21 Oct 2007 13:08:06 +0200
Message-Id: <11929648922970-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eddie Dong <eddie.dong@intel.com>

Resetting an SMP guest will force AP enter real mode (RESET) with
paging enabled in protected mode. While current enter_rmode() can
only handle mode switch from nonpaging mode to real mode which leads
to SMP reboot failure.

Fix by reloading the mmu context on entering real mode.

Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Signed-off-by: Qing He <qing.he@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c |    1 +
 drivers/kvm/vmx.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 7171618..feb5ac9 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1049,6 +1049,7 @@ int kvm_mmu_reset_context(struct kvm_vcpu *vcpu)
 	destroy_kvm_mmu(vcpu);
 	return init_kvm_mmu(vcpu);
 }
+EXPORT_SYMBOL_GPL(kvm_mmu_reset_context);
 
 int kvm_mmu_load(struct kvm_vcpu *vcpu)
 {
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index bcc1e39..f130c01 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1128,6 +1128,7 @@ static void enter_rmode(struct kvm_vcpu *vcpu)
 	fix_rmode_seg(VCPU_SREG_GS, &vcpu->rmode.gs);
 	fix_rmode_seg(VCPU_SREG_FS, &vcpu->rmode.fs);
 
+	kvm_mmu_reset_context(vcpu);
 	init_rmode_tss(vcpu->kvm);
 }
 
-- 
1.5.3

