Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYGBOCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYGBOCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYGBOCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:02:39 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:1149 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbYGBOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:02:38 -0400
X-BigFish: VPS-6(z6c9Rzzz10d3izzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K3DTNL-04-HVU-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@qumranet.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       Tobias Diedrich <ranma+kernel@tdiedrich.de>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] KVM: SVM: fix suspend/resume support
Date: Wed, 2 Jul 2008 16:02:11 +0200
Message-ID: <1215007331-1121-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
X-OriginalArrivalTime: 02 Jul 2008 14:02:11.0600 (UTC) FILETIME=[393D4100:01C8DC4C]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On suspend the svm_hardware_disable function is called which frees all svm_data
variables. On resume they are not re-allocated. This patch removes the
deallocation of svm_data from the hardware_disable function to the
hardware_unsetup function which is not called on suspend.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ff3e7e4..95c65f0 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -271,19 +271,11 @@ static int has_svm(void)
 
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
@@ -322,6 +314,19 @@ static void svm_hardware_enable(void *garbage)
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
@@ -459,6 +464,11 @@ err:
 
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
1.5.3.7


