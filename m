Return-Path: <linux-kernel-owner+w=401wt.eu-S933332AbXDAOgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332AbXDAOgN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXDAOgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:36:12 -0400
Received: from il.qumranet.com ([82.166.9.18]:47551 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933332AbXDAOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 41/41] KVM: SVM: enable LBRV virtualization if available
Date: Sun,  1 Apr 2007 17:35:38 +0300
Message-Id: <11754381403398-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381393751-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com> <11754381391161-git-send-email-avi@qumranet.com> <11754381393714-git-send-email-avi@qumranet.com> <11754381392948-git-send-email-avi@qumranet.com> <1175438139458-git-send-email-avi@qumranet.com> <117543813933-git-send-email-avi@qumranet.com> <11754381393962-git-send-email-avi@qumranet.com> <11754381393751-git-send-ema
 il-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch enables the virtualization of the last branch record MSRs on
SVM if this feature is available in hardware. It also introduces a small
and simple check feature for specific SVM extensions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 303e959..b7e1410 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -44,6 +44,10 @@ MODULE_LICENSE("GPL");
 #define KVM_EFER_LMA (1 << 10)
 #define KVM_EFER_LME (1 << 8)
 
+#define SVM_FEATURE_NPT  (1 << 0)
+#define SVM_FEATURE_LBRV (1 << 1)
+#define SVM_DEATURE_SVML (1 << 2)
+
 unsigned long iopm_base;
 unsigned long msrpm_base;
 
@@ -68,6 +72,7 @@ struct svm_cpu_data {
 };
 
 static DEFINE_PER_CPU(struct svm_cpu_data *, svm_data);
+static uint32_t svm_features;
 
 struct svm_init_data {
 	int cpu;
@@ -82,6 +87,11 @@ static u32 msrpm_ranges[] = {0, 0xc0000000, 0xc0010000};
 
 #define MAX_INST_SIZE 15
 
+static inline u32 svm_has(u32 feat)
+{
+	return svm_features & feat;
+}
+
 static unsigned get_addr_size(struct kvm_vcpu *vcpu)
 {
 	struct vmcb_save_area *sa = &vcpu->svm->vmcb->save;
@@ -302,6 +312,7 @@ static void svm_hardware_enable(void *garbage)
 	svm_data->asid_generation = 1;
 	svm_data->max_asid = cpuid_ebx(SVM_CPUID_FUNC) - 1;
 	svm_data->next_asid = svm_data->max_asid + 1;
+	svm_features = cpuid_edx(SVM_CPUID_FUNC);
 
 	asm volatile ( "sgdt %0" : "=m"(gdt_descr) );
 	gdt = (struct desc_struct *)gdt_descr.address;
@@ -511,6 +522,8 @@ static void init_vmcb(struct vmcb *vmcb)
 	control->msrpm_base_pa = msrpm_base;
 	control->tsc_offset = 0;
 	control->int_ctl = V_INTR_MASKING_MASK;
+	if (svm_has(SVM_FEATURE_LBRV))
+		control->lbr_ctl = 1ULL;
 
 	init_seg(&save->es);
 	init_seg(&save->ss);
-- 
1.5.0.5

