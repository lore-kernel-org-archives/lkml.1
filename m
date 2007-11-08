Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbXKHVkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbXKHVkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 16:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761043AbXKHVkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 16:40:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637AbXKHVkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 16:40:07 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jeremy@goop.org, avi@qumranet.com, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 1/3] include files for kvmclock
Date: Thu,  8 Nov 2007 20:39:21 -0200
Message-Id: <11945615703593-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11945615632624-git-send-email-gcosta@redhat.com>
References: <11945615632624-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the include files for kvm clock.
They'll be needed for both guest and host part.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/kvm_para.h |   25 +++++++++++++++++++++++++
 include/linux/kvm.h        |    1 +
 include/linux/kvm_para.h   |    2 ++
 3 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/kvm_para.h b/include/asm-x86/kvm_para.h
index c6f3fd8..0f6b813 100644
--- a/include/asm-x86/kvm_para.h
+++ b/include/asm-x86/kvm_para.h
@@ -10,15 +10,40 @@
  * paravirtualization, the appropriate feature bit should be checked.
  */
 #define KVM_CPUID_FEATURES	0x40000001
+#define KVM_FEATURE_CLOCKSOURCE 0
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
+extern void kvmclock_init(void);
+
+/*
+ * Guest has page alignment and padding requirements. At the host, it will
+ * only lead to wasted space at the vcpu struct. For this reason, the struct
+ * is not anonymous
+ */
+union kvm_hv_clock {
+	struct kvm_hv_clock_s {
+		u64 tsc_mult;
+		u64 now_ns;
+		/* That's the wall clock, not the water closet */
+		u64 wc_sec;
+		u64 last_tsc;
+		/* At first, we could use the tsc value as a marker, but Jeremy
+		 * well noted that it will cause us locking problems in 32-bit
+		 * sys, so we have a special version field */
+		u32 version;
+	} fields;
+	char page_align[PAGE_SIZE];
+};
+
 
 /* This instruction is vmcall.  On non-VT architectures, it will generate a
  * trap that we will then rewrite to the appropriate instruction.
  */
 #define KVM_HYPERCALL ".byte 0x0f,0x01,0xc1"
 
+#define KVM_HCALL_REGISTER_CLOCK	1
+
 /* For KVM hypercalls, a three-byte sequence of either the vmrun or the vmmrun
  * instruction.  The hypervisor may replace it with something else but only the
  * instructions are guaranteed to be supported.
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 71d33d6..9862241 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -359,6 +359,7 @@ struct kvm_signal_mask {
 #define KVM_CAP_MMU_SHADOW_CACHE_CONTROL 2
 #define KVM_CAP_USER_MEMORY 3
 #define KVM_CAP_SET_TSS_ADDR 4
+#define KVM_CAP_CLOCKSOURCE	  5
 
 /*
  * ioctls for VM fds
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index e4db25f..094efc7 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -11,6 +11,8 @@
 
 /* Return values for hypercalls */
 #define KVM_ENOSYS		1000
+#define KVM_EINVAL		1019
+#define KVM_ENODEV		1022
 
 #ifdef __KERNEL__
 /*
-- 
1.5.0.6

