Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYAAPow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYAAPow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:44:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYAAPgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:45 -0500
Received: from il.qumranet.com ([82.166.9.18]:33804 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 28/54] KVM: Portability: Stop including x86-specific headers in kvm_main.c
Date: Tue,  1 Jan 2008 17:35:54 +0200
Message-Id: <1199201780-14001-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/i8259.c    |    1 +
 drivers/kvm/irq.h      |    7 ++++++-
 drivers/kvm/kvm.h      |    9 ++++-----
 drivers/kvm/kvm_main.c |    3 ---
 drivers/kvm/x86.h      |    8 ++++++++
 5 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/kvm/i8259.c b/drivers/kvm/i8259.c
index f0dc2ee..b3cad63 100644
--- a/drivers/kvm/i8259.c
+++ b/drivers/kvm/i8259.c
@@ -27,6 +27,7 @@
  */
 #include <linux/mm.h>
 #include "irq.h"
+#include "kvm.h"
 
 /*
  * set irq level. If an edge is detected, then the IRR is set to 1
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 803b9c7..730a87c 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -22,9 +22,14 @@
 #ifndef __IRQ_H
 #define __IRQ_H
 
-#include "kvm.h"
+#include <linux/mm_types.h>
+#include <linux/hrtimer.h>
+#include <asm/kvm.h>
 #include "iodev.h"
 
+struct kvm;
+struct kvm_vcpu;
+
 typedef void irq_request_func(void *opaque, int level);
 
 struct kvm_kpic_state {
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index a1b7d1c..0d3555b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -288,11 +288,6 @@ static inline int irqchip_in_kernel(struct kvm *kvm)
 	return pic_irqchip(kvm) != NULL;
 }
 
-struct descriptor_table {
-	u16 limit;
-	unsigned long base;
-} __attribute__((packed));
-
 /* The guest did something we don't support. */
 #define pr_unimpl(vcpu, fmt, ...)					\
  do {									\
@@ -457,4 +452,8 @@ struct kvm_stats_debugfs_item {
 };
 extern struct kvm_stats_debugfs_item debugfs_entries[];
 
+#if defined(CONFIG_X86)
+#include "x86.h"
+#endif
+
 #endif
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 8d4a06d..7785c90 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -16,8 +16,6 @@
  */
 
 #include "kvm.h"
-#include "x86.h"
-#include "irq.h"
 #include "iodev.h"
 
 #include <linux/kvm.h>
@@ -46,7 +44,6 @@
 #include <asm/processor.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/desc.h>
 #include <asm/pgtable.h>
 
 MODULE_AUTHOR("Qumranet");
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 78ab1e1..4b7acc7 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -12,6 +12,7 @@
 #define KVM_X86_H
 
 #include "kvm.h"
+#include "irq.h"
 
 #include <linux/types.h>
 #include <linux/mm.h>
@@ -19,6 +20,8 @@
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
 
+#include <asm/desc.h>
+
 #define CR3_PAE_RESERVED_BITS ((X86_CR3_PWT | X86_CR3_PCD) - 1)
 #define CR3_NONPAE_RESERVED_BITS ((PAGE_SIZE-1) & ~(X86_CR3_PWT | X86_CR3_PCD))
 #define CR3_L_MODE_RESERVED_BITS (CR3_NONPAE_RESERVED_BITS|0xFFFFFF0000000000ULL)
@@ -156,6 +159,11 @@ struct kvm_vcpu {
 	struct x86_emulate_ctxt emulate_ctxt;
 };
 
+struct descriptor_table {
+	u16 limit;
+	unsigned long base;
+} __attribute__((packed));
+
 struct kvm_x86_ops {
 	int (*cpu_has_kvm_support)(void);          /* __init */
 	int (*disabled_by_bios)(void);             /* __init */
-- 
1.5.3.7

