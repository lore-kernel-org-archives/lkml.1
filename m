Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYAAPnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYAAPnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755387AbYAAPgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:41 -0500
Received: from il.qumranet.com ([82.166.9.18]:33802 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbYAAPg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:27 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 24/54] KVM: Replace dest_Lowest_Prio and dest_Fixed with self-defined macros
Date: Tue,  1 Jan 2008 17:35:50 +0200
Message-Id: <1199201780-14001-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Change
  dest_Loest_Prio -> IOAPIC_LOWEST_PRIORITY
  dest_Fixed -> IOAPIC_FIXED

the original names are x86 specific, while the ioapic code will be reused
for ia64.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/ioapic.c |   13 +++++--------
 drivers/kvm/irq.h    |    8 ++++++++
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/ioapic.c b/drivers/kvm/ioapic.c
index 3629867..0feae6f 100644
--- a/drivers/kvm/ioapic.c
+++ b/drivers/kvm/ioapic.c
@@ -36,11 +36,8 @@
 #include <linux/hrtimer.h>
 #include <linux/io.h>
 #include <asm/processor.h>
-#include <asm/msr.h>
 #include <asm/page.h>
 #include <asm/current.h>
-#include <asm/apicdef.h>
-#include <asm/io_apic.h>
 #include "irq.h"
 #if 0
 #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
@@ -142,8 +139,8 @@ static void ioapic_inj_irq(struct kvm_ioapic *ioapic,
 	ioapic_debug("irq %d trig %d deliv %d\n", vector, trig_mode,
 		     delivery_mode);
 
-	ASSERT((delivery_mode == dest_Fixed) ||
-	       (delivery_mode == dest_LowestPrio));
+	ASSERT((delivery_mode == IOAPIC_FIXED) ||
+	       (delivery_mode == IOAPIC_LOWEST_PRIORITY));
 
 	kvm_apic_set_irq(vcpu, vector, trig_mode);
 }
@@ -210,7 +207,7 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 	}
 
 	switch (delivery_mode) {
-	case dest_LowestPrio:
+	case IOAPIC_LOWEST_PRIORITY:
 		vcpu = kvm_get_lowest_prio_vcpu(ioapic->kvm, vector,
 				deliver_bitmask);
 		if (vcpu != NULL)
@@ -219,9 +216,9 @@ static void ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 		else
 			ioapic_debug("null lowest prio vcpu: "
 				     "mask=%x vector=%x delivery_mode=%x\n",
-				     deliver_bitmask, vector, dest_LowestPrio);
+				     deliver_bitmask, vector, IOAPIC_LOWEST_PRIORITY);
 		break;
-	case dest_Fixed:
+	case IOAPIC_FIXED:
 		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
 			if (!(deliver_bitmask & (1 << vcpu_id)))
 				continue;
diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 78a34dd..75f5f18 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -79,6 +79,14 @@ void kvm_pic_update_irq(struct kvm_pic *s);
 #define IOAPIC_REG_VERSION 0x01
 #define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
 
+/*ioapic delivery mode*/
+#define	IOAPIC_FIXED			0x0
+#define	IOAPIC_LOWEST_PRIORITY		0x1
+#define	IOAPIC_PMI			0x2
+#define	IOAPIC_NMI			0x4
+#define	IOAPIC_INIT			0x5
+#define	IOAPIC_EXTINT			0x7
+
 struct kvm_ioapic {
 	u64 base_address;
 	u32 ioregsel;
-- 
1.5.3.7

