Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYKDO53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYKDO53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 09:57:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYKDOxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:53:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60546 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbYKDOxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:53:42 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 15/16] kvm: x86: set kdump virt_disable function on initialization
Date: Tue,  4 Nov 2008 12:52:43 -0200
Message-Id: <1225810364-8990-16-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally implement the virt_disable function for kdump. It will call
kvm_x86_ops->crash_hardware_disable(), that will disable virtualization
extensions on the CPU if it is not disabled yet.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/x86.c |   19 ++++++++++++++++++-
 1 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 049c6a0..9e61baf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -40,6 +40,7 @@
 #include <asm/msr.h>
 #include <asm/desc.h>
 #include <asm/mtrr.h>
+#include <asm/virtext.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -2581,6 +2582,13 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
+/* Called at crash time, so we can disable virtualization if needed
+ */
+static void crash_hardware_disable(void)
+{
+	kvm_x86_ops->crash_hardware_disable(NULL);
+}
+
 int kvm_arch_init(void *opaque)
 {
 	int r;
@@ -2605,9 +2613,15 @@ int kvm_arch_init(void *opaque)
 
 	kvm_x86_ops = ops;
 
+	r = set_virt_disable_func(crash_hardware_disable);
+	if (r) {
+		printk(KERN_ERR "kvm: virt_disable function already set?\n");
+		goto out_clear_ops;
+	}
+
 	r = kvm_mmu_module_init();
 	if (r)
-		goto out_clear_ops;
+		goto out_clear_crash;
 
 	kvm_init_msr_list();
 
@@ -2617,6 +2631,8 @@ int kvm_arch_init(void *opaque)
 			PT_DIRTY_MASK, PT64_NX_MASK, 0, 0);
 	return 0;
 
+out_clear_crash:
+	clear_virt_disable_func();
 out_clear_ops:
 	kvm_x86_ops = NULL;
 out:
@@ -2625,6 +2641,7 @@ out:
 
 void kvm_arch_exit(void)
 {
+	clear_virt_disable_func();
 	kvm_x86_ops = NULL;
 	kvm_mmu_module_exit();
 }
-- 
1.5.5.GIT

