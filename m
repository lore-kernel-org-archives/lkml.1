Return-Path: <linux-kernel-owner+w=401wt.eu-S1751541AbXLZLL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbXLZLL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbXLZLGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:30 -0500
Received: from il.qumranet.com ([82.166.9.18]:50468 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbXLZLGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:05 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Carsten Otte <cotte@de.ibm.com>
Subject: [PATCH 19/55] KVM: Portability: Move memory segmentation to x86.c
Date: Wed, 26 Dec 2007 13:05:24 +0200
Message-Id: <1198667160-22953-20-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

This patch moves the definition of segment_descriptor_64 for AMD64 and
EM64T from kvm_main.c to segment_descriptor.h. It also adds a proper
#ifndef...#define...#endif around that header file.
The implementation of segment_base is moved from kvm_main.c to x86.c.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c           |   42 --------------------------------------
 drivers/kvm/segment_descriptor.h |   12 ++++++++++
 drivers/kvm/x86.c                |   33 +++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9c0175d..00f9c9e 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -18,7 +18,6 @@
 #include "kvm.h"
 #include "x86.h"
 #include "x86_emulate.h"
-#include "segment_descriptor.h"
 #include "irq.h"
 
 #include <linux/kvm.h>
@@ -104,50 +103,9 @@ static struct dentry *debugfs_dir;
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
 #define EFER_RESERVED_BITS 0xfffffffffffff2fe
 
-#ifdef CONFIG_X86_64
-/* LDT or TSS descriptor in the GDT. 16 bytes. */
-struct segment_descriptor_64 {
-	struct segment_descriptor s;
-	u32 base_higher;
-	u32 pad_zero;
-};
-
-#endif
-
 static long kvm_vcpu_ioctl(struct file *file, unsigned int ioctl,
 			   unsigned long arg);
 
-unsigned long segment_base(u16 selector)
-{
-	struct descriptor_table gdt;
-	struct segment_descriptor *d;
-	unsigned long table_base;
-	unsigned long v;
-
-	if (selector == 0)
-		return 0;
-
-	asm("sgdt %0" : "=m"(gdt));
-	table_base = gdt.base;
-
-	if (selector & 4) {           /* from ldt */
-		u16 ldt_selector;
-
-		asm("sldt %0" : "=g"(ldt_selector));
-		table_base = segment_base(ldt_selector);
-	}
-	d = (struct segment_descriptor *)(table_base + (selector & ~7));
-	v = d->base_low | ((unsigned long)d->base_mid << 16) |
-		((unsigned long)d->base_high << 24);
-#ifdef CONFIG_X86_64
-	if (d->system == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
-		v |= ((unsigned long) \
-		      ((struct segment_descriptor_64 *)d)->base_higher) << 32;
-#endif
-	return v;
-}
-EXPORT_SYMBOL_GPL(segment_base);
-
 static inline int valid_vcpu(int n)
 {
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
diff --git a/drivers/kvm/segment_descriptor.h b/drivers/kvm/segment_descriptor.h
index 71fdf45..56fc4c8 100644
--- a/drivers/kvm/segment_descriptor.h
+++ b/drivers/kvm/segment_descriptor.h
@@ -1,3 +1,6 @@
+#ifndef __SEGMENT_DESCRIPTOR_H
+#define __SEGMENT_DESCRIPTOR_H
+
 struct segment_descriptor {
 	u16 limit_low;
 	u16 base_low;
@@ -14,4 +17,13 @@ struct segment_descriptor {
 	u8  base_high;
 } __attribute__((packed));
 
+#ifdef CONFIG_X86_64
+/* LDT or TSS descriptor in the GDT. 16 bytes. */
+struct segment_descriptor_64 {
+	struct segment_descriptor s;
+	u32 base_higher;
+	u32 pad_zero;
+};
 
+#endif
+#endif
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index b84cb67..5a95922 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -16,16 +16,49 @@
 
 #include "kvm.h"
 #include "x86.h"
+#include "segment_descriptor.h"
 #include "irq.h"
 
 #include <linux/kvm.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 
 #define MAX_IO_MSRS 256
 
+unsigned long segment_base(u16 selector)
+{
+	struct descriptor_table gdt;
+	struct segment_descriptor *d;
+	unsigned long table_base;
+	unsigned long v;
+
+	if (selector == 0)
+		return 0;
+
+	asm("sgdt %0" : "=m"(gdt));
+	table_base = gdt.base;
+
+	if (selector & 4) {           /* from ldt */
+		u16 ldt_selector;
+
+		asm("sldt %0" : "=g"(ldt_selector));
+		table_base = segment_base(ldt_selector);
+	}
+	d = (struct segment_descriptor *)(table_base + (selector & ~7));
+	v = d->base_low | ((unsigned long)d->base_mid << 16) |
+		((unsigned long)d->base_high << 24);
+#ifdef CONFIG_X86_64
+	if (d->system == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
+		v |= ((unsigned long) \
+		      ((struct segment_descriptor_64 *)d)->base_higher) << 32;
+#endif
+	return v;
+}
+EXPORT_SYMBOL_GPL(segment_base);
+
 /*
  * List of msr numbers which we expose to userspace through KVM_GET_MSRS
  * and KVM_SET_MSRS, and KVM_GET_MSR_INDEX_LIST.
-- 
1.5.3.7

