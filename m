Return-Path: <linux-kernel-owner+w=401wt.eu-S1753006AbZIYAtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbZIYAtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZIYAtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:49:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZIYAth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:49:37 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH: kvm 4/5] Fix hotremove of CPUs for KVM.
Date: Thu, 24 Sep 2009 14:47:19 -1000
Message-Id: <1253839640-12695-5-git-send-email-zamsden@redhat.com>
In-Reply-To: <1253839640-12695-4-git-send-email-zamsden@redhat.com>
References: <20090924151049.GB14102@amt.cnet>
 <1253839640-12695-1-git-send-email-zamsden@redhat.com>
 <1253839640-12695-2-git-send-email-zamsden@redhat.com>
 <1253839640-12695-3-git-send-email-zamsden@redhat.com>
 <1253839640-12695-4-git-send-email-zamsden@redhat.com>
Organization: Frobozz Magic Timekeeping Company
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the process of bringing down CPUs, the SVM / VMX structures associated
with those CPUs are not freed.  This may cause leaks when unloading and
reloading the KVM module, as only the structures associated with online
CPUs are cleaned up.  So, clean up all possible CPUs, not just online ones.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |    2 +-
 arch/x86/kvm/vmx.c |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8f99d0c..13ca268 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -525,7 +525,7 @@ static __exit void svm_hardware_unsetup(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu)
+	for_each_possible_cpu(cpu)
 		svm_cpu_uninit(cpu);
 
 	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index b8a8428..603bde3 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1350,8 +1350,11 @@ static void free_kvm_area(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu)
-		free_vmcs(per_cpu(vmxarea, cpu));
+	for_each_possible_cpu(cpu)
+		if (per_cpu(vmxarea, cpu)) {
+			free_vmcs(per_cpu(vmxarea, cpu));
+			per_cpu(vmxarea, cpu) = NULL;
+		}
 }
 
 static __init int alloc_kvm_area(void)
-- 
1.6.4.4

