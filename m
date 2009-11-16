Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbZKPM2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbZKPM2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 07:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbZKPMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 07:19:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbZKPMTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 07:19:42 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 32/42] KVM: Fix hotplug of CPUs
Date: Mon, 16 Nov 2009 14:19:33 +0200
Message-Id: <1258373983-8693-33-git-send-email-avi@redhat.com>
In-Reply-To: <1258373983-8693-1-git-send-email-avi@redhat.com>
References: <1258373983-8693-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zamsden@redhat.com>

Both VMX and SVM require per-cpu memory allocation, which is done at module
init time, for only online cpus.

Backend was not allocating enough structure for all possible CPUs, so
new CPUs coming online could not be hardware enabled.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/kvm/svm.c |    4 ++--
 arch/x86/kvm/vmx.c |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

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
index a187570..97f4265 100644
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
-- 
1.6.5.2

