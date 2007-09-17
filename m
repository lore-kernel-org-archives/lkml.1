Return-Path: <linux-kernel-owner+w=401wt.eu-S1758588AbXIQI5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588AbXIQI5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXIQIdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:33:40 -0400
Received: from il.qumranet.com ([82.166.9.18]:45291 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbXIQIce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:34 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 086/104] KVM: Hoist SVM's get_cs_db_l_bits into core code.
Date: Mon, 17 Sep 2007 10:32:08 +0200
Message-Id: <11900179492582-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

SVM gets the DB and L bits for the cs by decoding the segment.  This
is in fact the completely generic code, so hoist it for kvm-lite to use.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   10 ++++++++++
 drivers/kvm/svm.c      |   10 +---------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 9bf9ac6..ee9f8bd 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -586,6 +586,7 @@ void set_cr4(struct kvm_vcpu *vcpu, unsigned long cr0);
 void set_cr8(struct kvm_vcpu *vcpu, unsigned long cr0);
 unsigned long get_cr8(struct kvm_vcpu *vcpu);
 void lmsw(struct kvm_vcpu *vcpu, unsigned long msw);
+void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l);
 
 int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata);
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 07a6d97..49a0ff4 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2272,6 +2272,16 @@ static int kvm_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+void kvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	struct kvm_segment cs;
+
+	get_segment(vcpu, &cs, VCPU_SREG_CS);
+	*db = cs.db;
+	*l = cs.l;
+}
+EXPORT_SYMBOL_GPL(kvm_get_cs_db_l_bits);
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index e51f6b7..35f3f83 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -724,14 +724,6 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 	var->unusable = !var->present;
 }
 
-static void svm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
-{
-	struct vmcb_seg *s = svm_seg(vcpu, VCPU_SREG_CS);
-
-	*db = (s->attrib >> SVM_SELECTOR_DB_SHIFT) & 1;
-	*l = (s->attrib >> SVM_SELECTOR_L_SHIFT) & 1;
-}
-
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct descriptor_table *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -1771,7 +1763,7 @@ static struct kvm_arch_ops svm_arch_ops = {
 	.get_segment_base = svm_get_segment_base,
 	.get_segment = svm_get_segment,
 	.set_segment = svm_set_segment,
-	.get_cs_db_l_bits = svm_get_cs_db_l_bits,
+	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr3 = svm_set_cr3,
-- 
1.5.3

