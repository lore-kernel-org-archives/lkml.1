Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbZASNBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbZASNBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760013AbZASNBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:01:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42531 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993AbZASNBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:01:02 -0500
From: Avi Kivity <avi@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: [PATCH] KVM: Avoid using CONFIG_ in userspace visible headers
Date: Mon, 19 Jan 2009 15:00:50 +0200
Message-Id: <1232370050-7434-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig symbols are not available in userspace, and are not stripped by
headers-install.  Avoid their use by adding #defines in <asm/kvm.h> to
suit each architecture.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/ia64/include/asm/kvm.h |    4 ++++
 arch/x86/include/asm/kvm.h  |    7 +++++++
 include/linux/kvm.h         |   10 +++++-----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/include/asm/kvm.h b/arch/ia64/include/asm/kvm.h
index 68aa6da..bfa86b6 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -25,6 +25,10 @@
 
 #include <linux/ioctl.h>
 
+/* Select x86 specific features in <linux/kvm.h> */
+#define __KVM_HAVE_IOAPIC
+#define __KVM_HAVE_DEVICE_ASSIGNMENT
+
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
diff --git a/arch/x86/include/asm/kvm.h b/arch/x86/include/asm/kvm.h
index b95162a..c4c5c69 100644
--- a/arch/x86/include/asm/kvm.h
+++ b/arch/x86/include/asm/kvm.h
@@ -9,6 +9,13 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
+/* Select x86 specific features in <linux/kvm.h> */
+#define __KVM_HAVE_PIT
+#define __KVM_HAVE_IOAPIC
+#define __KVM_HAVE_DEVICE_ASSIGNMENT
+#define __KVM_HAVE_MSI
+#define __KVM_HAVE_USER_NMI
+
 /* Architectural interrupt line count. */
 #define KVM_NR_INTERRUPTS 256
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5715f19..0424326 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -58,10 +58,10 @@ struct kvm_irqchip {
 	__u32 pad;
         union {
 		char dummy[512];  /* reserving space */
-#ifdef CONFIG_X86
+#ifdef __KVM_HAVE_PIT
 		struct kvm_pic_state pic;
 #endif
-#if defined(CONFIG_X86) || defined(CONFIG_IA64)
+#ifdef __KVM_HAVE_IOAPIC
 		struct kvm_ioapic_state ioapic;
 #endif
 	} chip;
@@ -384,16 +384,16 @@ struct kvm_trace_rec {
 #define KVM_CAP_MP_STATE 14
 #define KVM_CAP_COALESCED_MMIO 15
 #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
-#if defined(CONFIG_X86)||defined(CONFIG_IA64)
+#ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
 #define KVM_CAP_DEVICE_ASSIGNMENT 17
 #endif
 #define KVM_CAP_IOMMU 18
-#if defined(CONFIG_X86)
+#ifdef __KVM_HAVE_MSI
 #define KVM_CAP_DEVICE_MSI 20
 #endif
 /* Bug in KVM_SET_USER_MEMORY_REGION fixed: */
 #define KVM_CAP_DESTROY_MEMORY_REGION_WORKS 21
-#if defined(CONFIG_X86)
+#ifdef __KVM_HAVE_USER_NMI
 #define KVM_CAP_USER_NMI 22
 #endif
 
-- 
1.6.0.6

