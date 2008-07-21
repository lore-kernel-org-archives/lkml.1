Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYGUOuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYGUOuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:50:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYGUOup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:50:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:51278 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbYGUOup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=omWSlRWHW9CKR0aNivJeGmsdkWFlvRZti4q8KwUCPION1ZmeGvrsIwLeOuyLeglaiW
         P4KSmffq6a1oC9kZKqgRc5L5HHEXhygTzPQPjyBiOIvswW54gNymKzdORE3v9Ek3Htvc
         u2iwMHvXGY+uiueVane3IpiufOkztdOq9iyJw=
Message-ID: <6101e8c40807210750g49481819lbf88d7aae19c9945@mail.gmail.com>
Date: Mon, 21 Jul 2008 16:50:43 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Joerg Roedel" <joerg.roedel@amd.com>
Subject: [RFC] kvm-svn fix for stable
Cc: "Avi Kivity" <avi@qumranet.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-------------->

commit 0da1db75a2feca54564add30828bab658982481c
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Wed Jul 2 16:02:11 2008 +0200

    KVM: SVM: fix suspend/resume support

    On suspend the svm_hardware_disable function is called which frees
all svm_data
    variables. On resume they are not re-allocated. This patch removes the
    deallocation of svm_data from the hardware_disable function to the
    hardware_unsetup function which is not called on suspend.

    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
    Signed-off-by: Avi Kivity <avi@qumranet.com>

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
Thanks,
Oliver
