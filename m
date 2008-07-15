Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYGOMT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYGOMT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 08:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757834AbYGOMNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 08:13:08 -0400
Received: from il.qumranet.com ([212.179.150.194]:30358 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYGOMMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 08:12:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/19] KVM: SVM: fix suspend/resume support
Date: Tue, 15 Jul 2008 15:12:27 +0300
Message-Id: <1216123958-10717-9-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6.1
In-Reply-To: <1216123958-10717-1-git-send-email-avi@qumranet.com>
References: <1216123958-10717-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

On suspend the svm_hardware_disable function is called which frees all svm_data
variables. On resume they are not re-allocated. This patch removes the
deallocation of svm_data from the hardware_disable function to the
hardware_unsetup function which is not called on suspend.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/svm.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 238e8f3..858e297 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -272,19 +272,11 @@ static int has_svm(void)
 
 static void svm_hardware_disable(void *garbage)
 {
-	struct svm_cpu_data *svm_data
-		= per_cpu(svm_data, raw_smp_processor_id());
-
-	if (svm_data) {
-		uint64_t efer;
+	uint64_t efer;
 
-		wrmsrl(MSR_VM_HSAVE_PA, 0);
-		rdmsrl(MSR_EFER, efer);
-		wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
-		per_cpu(svm_data, raw_smp_processor_id()) = NULL;
-		__free_page(svm_data->save_area);
-		kfree(svm_data);
-	}
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+	rdmsrl(MSR_EFER, efer);
+	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
 }
 
 static void svm_hardware_enable(void *garbage)
@@ -323,6 +315,19 @@ static void svm_hardware_enable(void *garbage)
 	       page_to_pfn(svm_data->save_area) << PAGE_SHIFT);
 }
 
+static void svm_cpu_uninit(int cpu)
+{
+	struct svm_cpu_data *svm_data
+		= per_cpu(svm_data, raw_smp_processor_id());
+
+	if (!svm_data)
+		return;
+
+	per_cpu(svm_data, raw_smp_processor_id()) = NULL;
+	__free_page(svm_data->save_area);
+	kfree(svm_data);
+}
+
 static int svm_cpu_init(int cpu)
 {
 	struct svm_cpu_data *svm_data;
@@ -460,6 +465,11 @@ err:
 
 static __exit void svm_hardware_unsetup(void)
 {
+	int cpu;
+
+	for_each_online_cpu(cpu)
+		svm_cpu_uninit(cpu);
+
 	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
 	iopm_base = 0;
 }
-- 
1.5.6.1

