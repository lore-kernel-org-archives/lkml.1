Return-Path: <linux-kernel-owner+w=401wt.eu-S1757672AbYAAPog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672AbYAAPog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:44:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYAAPgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:44 -0500
Received: from il.qumranet.com ([82.166.9.18]:33805 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYAAPg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:28 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 29/54] KVM: Portability: Create kvm_arch_vcpu_runnable() function
Date: Tue,  1 Jan 2008 17:35:55 +0200
Message-Id: <1199201780-14001-30-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This abstracts the detail of x86 hlt and INIT modes into a function.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    3 +--
 drivers/kvm/x86.h      |    7 +++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7785c90..3d1023c 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -643,8 +643,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	 */
 	while (!kvm_cpu_has_interrupt(vcpu)
 	       && !signal_pending(current)
-	       && vcpu->mp_state != VCPU_MP_STATE_RUNNABLE
-	       && vcpu->mp_state != VCPU_MP_STATE_SIPI_RECEIVED) {
+	       && !kvm_arch_vcpu_runnable(vcpu)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		vcpu_put(vcpu);
 		schedule();
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 4b7acc7..eed7964 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -471,4 +471,11 @@ static inline u32 get_rdx_init_val(void)
 #define TSS_IOPB_SIZE (65536 / 8)
 #define TSS_REDIRECTION_SIZE (256 / 8)
 #define RMODE_TSS_SIZE (TSS_BASE_SIZE + TSS_REDIRECTION_SIZE + TSS_IOPB_SIZE + 1)
+
+static inline int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	return vcpu->mp_state == VCPU_MP_STATE_RUNNABLE
+	       || vcpu->mp_state == VCPU_MP_STATE_SIPI_RECEIVED;
+}
+
 #endif
-- 
1.5.3.7

