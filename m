Return-Path: <linux-kernel-owner+w=401wt.eu-S1759861AbYDCTe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759861AbYDCTe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760352AbYDCTc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:32:59 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53007
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960AbYDCTcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:55 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/35] KVM: Use x86's segment descriptor struct instead of private definition
Date: Thu,  3 Apr 2008 22:32:16 +0300
Message-Id: <1207251170-5013-2-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 desc_struct unification allows us to remove segment_descriptor.h.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/segment_descriptor.h |   29 -----------------------------
 arch/x86/kvm/vmx.c                |    3 +--
 arch/x86/kvm/x86.c                |   15 +++++++--------
 3 files changed, 8 insertions(+), 39 deletions(-)
 delete mode 100644 arch/x86/kvm/segment_descriptor.h

diff --git a/arch/x86/kvm/segment_descriptor.h b/arch/x86/kvm/segment_descriptor.h
deleted file mode 100644
index 56fc4c8..0000000
--- a/arch/x86/kvm/segment_descriptor.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef __SEGMENT_DESCRIPTOR_H
-#define __SEGMENT_DESCRIPTOR_H
-
-struct segment_descriptor {
-	u16 limit_low;
-	u16 base_low;
-	u8  base_mid;
-	u8  type : 4;
-	u8  system : 1;
-	u8  dpl : 2;
-	u8  present : 1;
-	u8  limit_high : 4;
-	u8  avl : 1;
-	u8  long_mode : 1;
-	u8  default_op : 1;
-	u8  granularity : 1;
-	u8  base_high;
-} __attribute__((packed));
-
-#ifdef CONFIG_X86_64
-/* LDT or TSS descriptor in the GDT. 16 bytes. */
-struct segment_descriptor_64 {
-	struct segment_descriptor s;
-	u32 base_higher;
-	u32 pad_zero;
-};
-
-#endif
-#endif
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2d5ccec..f46ad03 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -17,7 +17,6 @@
 
 #include "irq.h"
 #include "vmx.h"
-#include "segment_descriptor.h"
 #include "mmu.h"
 
 #include <linux/kvm_host.h>
@@ -388,7 +387,7 @@ static void reload_tss(void)
 	 * VT restores TR but not its size.  Useless.
 	 */
 	struct descriptor_table gdt;
-	struct segment_descriptor *descs;
+	struct desc_struct *descs;
 
 	get_gdt(&gdt);
 	descs = (void *)gdt.base;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b7c32f6..a063f44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -15,7 +15,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include "segment_descriptor.h"
 #include "irq.h"
 #include "mmu.h"
 
@@ -29,6 +28,7 @@
 
 #include <asm/uaccess.h>
 #include <asm/msr.h>
+#include <asm/desc.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
@@ -94,7 +94,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 unsigned long segment_base(u16 selector)
 {
 	struct descriptor_table gdt;
-	struct segment_descriptor *d;
+	struct desc_struct *d;
 	unsigned long table_base;
 	unsigned long v;
 
@@ -110,13 +110,12 @@ unsigned long segment_base(u16 selector)
 		asm("sldt %0" : "=g"(ldt_selector));
 		table_base = segment_base(ldt_selector);
 	}
-	d = (struct segment_descriptor *)(table_base + (selector & ~7));
-	v = d->base_low | ((unsigned long)d->base_mid << 16) |
-		((unsigned long)d->base_high << 24);
+	d = (struct desc_struct *)(table_base + (selector & ~7));
+	v = d->base0 | ((unsigned long)d->base1 << 16) |
+		((unsigned long)d->base2 << 24);
 #ifdef CONFIG_X86_64
-	if (d->system == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
-		v |= ((unsigned long) \
-		      ((struct segment_descriptor_64 *)d)->base_higher) << 32;
+	if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
+		v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
 #endif
 	return v;
 }
-- 
1.5.4.5

