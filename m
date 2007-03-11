Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbXCKNz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbXCKNz4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXCKNzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:55:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:43440 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933569AbXCKNxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:31 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 09/15] KVM: Allow userspace to process hypercalls which have no kernel handler
Date: Sun, 11 Mar 2007 15:53:21 +0200
Message-Id: <11736212073905-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful for paravirtualized graphics devices, for example.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   18 +++++++++++++++++-
 include/linux/kvm.h    |   10 +++++++++-
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 376538c..2220e49 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1203,7 +1203,16 @@ int kvm_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	}
 	switch (nr) {
 	default:
-		;
+		run->hypercall.args[0] = a0;
+		run->hypercall.args[1] = a1;
+		run->hypercall.args[2] = a2;
+		run->hypercall.args[3] = a3;
+		run->hypercall.args[4] = a4;
+		run->hypercall.args[5] = a5;
+		run->hypercall.ret = ret;
+		run->hypercall.longmode = is_long_mode(vcpu);
+		kvm_arch_ops->decache_regs(vcpu);
+		return 0;
 	}
 	vcpu->regs[VCPU_REGS_RAX] = ret;
 	kvm_arch_ops->decache_regs(vcpu);
@@ -1599,6 +1608,13 @@ static int kvm_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	vcpu->mmio_needed = 0;
 
+	if (kvm_run->exit_type == KVM_EXIT_TYPE_VM_EXIT
+	    && kvm_run->exit_type == KVM_EXIT_HYPERCALL) {
+		kvm_arch_ops->cache_regs(vcpu);
+		vcpu->regs[VCPU_REGS_RAX] = kvm_run->hypercall.ret;
+		kvm_arch_ops->decache_regs(vcpu);
+	}
+
 	r = kvm_arch_ops->run(vcpu, kvm_run);
 
 	vcpu_put(vcpu);
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c93cf53..9151ebf 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 6
+#define KVM_API_VERSION 7
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -41,6 +41,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_UNKNOWN          = 0,
 	KVM_EXIT_EXCEPTION        = 1,
 	KVM_EXIT_IO               = 2,
+	KVM_EXIT_HYPERCALL        = 3,
 	KVM_EXIT_DEBUG            = 4,
 	KVM_EXIT_HLT              = 5,
 	KVM_EXIT_MMIO             = 6,
@@ -103,6 +104,13 @@ struct kvm_run {
 			__u32 len;
 			__u8  is_write;
 		} mmio;
+		/* KVM_EXIT_HYPERCALL */
+		struct {
+			__u64 args[6];
+			__u64 ret;
+			__u32 longmode;
+			__u32 pad;
+		} hypercall;
 	};
 };
 
-- 
1.5.0.2

