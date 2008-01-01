Return-Path: <linux-kernel-owner+w=401wt.eu-S1758644AbYAAPsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758644AbYAAPsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbYAAPgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:53 -0500
Received: from il.qumranet.com ([82.166.9.18]:33791 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbYAAPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:28 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 37/54] KVM: VMX: Avoid exit when setting cr8 if the local apic is in the kernel
Date: Tue,  1 Jan 2008 17:36:03 +0200
Message-Id: <1199201780-14001-38-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With apic in userspace, we must exit to userspace after a cr8 write in order
to update the tpr.  But if the apic is in the kernel, the exit is unnecessary.

Noticed by Joerg Roedel.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index aa6bf2b..548e3a5 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1973,6 +1973,8 @@ static int handle_cr(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 			vcpu_load_rsp_rip(vcpu);
 			set_cr8(vcpu, vcpu->regs[reg]);
 			skip_emulated_instruction(vcpu);
+			if (irqchip_in_kernel(vcpu->kvm))
+				return 1;
 			kvm_run->exit_reason = KVM_EXIT_SET_TPR;
 			return 0;
 		};
-- 
1.5.3.7

