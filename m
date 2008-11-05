Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbYKEUBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbYKEUBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:01:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbYKET6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41438 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756957AbYKET6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:08 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 13/15] kvm: svm: register virt_disable function on hardware_setup
Date: Wed,  5 Nov 2008 17:56:56 -0200
Message-Id: <1225915018-6548-14-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call set_virt_disable_func() on hardware_setup, and clear it on
hardware_unsetup.

This way kdump and reboot code will be able to disable svm when needed.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/svm.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3d330a2..8f9256d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 
 #include <asm/desc.h>
+#include <asm/virtext.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -422,10 +423,16 @@ static __init int svm_hardware_setup(void)
 	void *iopm_va;
 	int r;
 
+	r = set_virt_disable_func(__svm_hardware_disable);
+	if (r)
+		goto err;
+
 	iopm_pages = alloc_pages(GFP_KERNEL, IOPM_ALLOC_ORDER);
 
-	if (!iopm_pages)
-		return -ENOMEM;
+	if (!iopm_pages) {
+		r = -ENOMEM;
+		goto err_clear_virt_disable;
+	}
 
 	iopm_va = page_address(iopm_pages);
 	memset(iopm_va, 0xff, PAGE_SIZE * (1 << IOPM_ALLOC_ORDER));
@@ -438,7 +445,7 @@ static __init int svm_hardware_setup(void)
 	for_each_online_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)
-			goto err;
+			goto err_free_iopm;
 	}
 
 	svm_features = cpuid_edx(SVM_CPUID_FUNC);
@@ -459,9 +466,12 @@ static __init int svm_hardware_setup(void)
 
 	return 0;
 
-err:
+err_free_iopm:
 	__free_pages(iopm_pages, IOPM_ALLOC_ORDER);
 	iopm_base = 0;
+err_clear_virt_disable:
+	clear_virt_disable_func();
+err:
 	return r;
 }
 
@@ -474,6 +484,7 @@ static __exit void svm_hardware_unsetup(void)
 
 	__free_pages(pfn_to_page(iopm_base >> PAGE_SHIFT), IOPM_ALLOC_ORDER);
 	iopm_base = 0;
+	clear_virt_disable_func();
 }
 
 static void init_seg(struct vmcb_seg *seg)
-- 
1.5.5.GIT

