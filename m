Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbXIQJIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbXIQJIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbXIQIeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:34:19 -0400
Received: from il.qumranet.com ([82.166.9.18]:45265 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbXIQIcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:24 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 014/104] KVM: Set exit_reason to KVM_EXIT_MMIO where run->mmio is initialized.
Date: Mon, 17 Sep 2007 10:30:56 +0200
Message-Id: <11900179473753-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 +-
 drivers/kvm/svm.c      |    1 -
 drivers/kvm/vmx.c      |    1 -
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index fc63de2..193197f 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1276,6 +1276,7 @@ int emulate_instruction(struct kvm_vcpu *vcpu,
 	r = x86_emulate_memop(&emulate_ctxt, &emulate_ops);
 
 	if ((r || vcpu->mmio_is_write) && run) {
+		run->exit_reason = KVM_EXIT_MMIO;
 		run->mmio.phys_addr = vcpu->mmio_phys_addr;
 		memcpy(run->mmio.data, vcpu->mmio_data, 8);
 		run->mmio.len = vcpu->mmio_size;
@@ -1937,7 +1938,6 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			/*
 			 * Read-modify-write.  Back to userspace.
 			 */
-			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			r = 0;
 			goto out;
 		}
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 5c058fa..850a1b1 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -928,7 +928,6 @@ static int pf_interception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 		return 1;
 	case EMULATE_DO_MMIO:
 		++vcpu->stat.mmio_exits;
-		kvm_run->exit_reason = KVM_EXIT_MMIO;
 		return 0;
 	case EMULATE_FAIL:
 		vcpu_printf(vcpu, "%s: emulate fail\n", __FUNCTION__);
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index f3e7818..2c4f01b 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1610,7 +1610,6 @@ static int handle_exception(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			return 1;
 		case EMULATE_DO_MMIO:
 			++vcpu->stat.mmio_exits;
-			kvm_run->exit_reason = KVM_EXIT_MMIO;
 			return 0;
 		 case EMULATE_FAIL:
 			vcpu_printf(vcpu, "%s: emulate fail\n", __FUNCTION__);
-- 
1.5.3

