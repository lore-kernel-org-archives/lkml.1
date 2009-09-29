Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZI2EG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZI2EG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 00:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZI2EGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 00:06:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654AbZI2EGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 00:06:52 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v2: kvm 4/4] Fix hotplug of CPUs for KVM.
Date: Mon, 28 Sep 2009 18:04:32 -1000
Message-Id: <1254197072-889-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1254197072-889-4-git-send-email-zamsden@redhat.com>
References: <1254197072-889-1-git-send-email-zamsden@redhat.com>
 <1254197072-889-2-git-send-email-zamsden@redhat.com>
 <1254197072-889-3-git-send-email-zamsden@redhat.com>
 <1254197072-889-4-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both VMX and SVM require per-cpu memory allocation, which is done at module
init time, for only online cpus.

Backend was not allocating enough structure for all possible CPUs, so
new CPUs coming online could not be hardware enabled.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c  |    4 ++--
 arch/x86/kvm/vmx.c  |    6 ++++--
 virt/kvm/kvm_main.c |    3 ---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d1036ce..02a4269 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -482,7 +482,7 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME);
 	}
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
 			goto err;
@@ -516,7 +516,7 @@ static __exit void svm_hardware_unsetup(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu)
+	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
 
 	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3fe0d42..e86f1a6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1350,15 +1350,17 @@ static void free_kvm_area(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu)
+	for_each_possible_cpu(cpu) {
 		free_vmcs(per_cpu(vmxarea, cpu));
+		per_cpu(vmxarea, cpu) = NULL;
+	}
 }
 
 static __init int alloc_kvm_area(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		struct vmcs *vmcs;
 
 		vmcs = alloc_vmcs_cpu(cpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e27b7a9..2cd8bc2 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1716,9 +1716,6 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 {
 	int cpu = (long)v;
 
-	if (!kvm_usage_count)
-		return NOTIFY_OK;
-
 	val &= ~CPU_TASKS_FROZEN;
 	switch (val) {
 	case CPU_DYING:
-- 
1.6.4.4

