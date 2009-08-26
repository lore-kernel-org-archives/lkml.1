Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZHZKky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZHZKky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbZHZKku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:40:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873AbZHZKaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:11 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/47] KVM: Replace pic_lock()/pic_unlock() with direct call to spinlock functions
Date: Wed, 26 Aug 2009 13:29:32 +0300
Message-Id: <1251282609-12835-11-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

They are not doing anything else now.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 3aacd33..01f1516 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -32,18 +32,6 @@
 #include <linux/kvm_host.h>
 #include "trace.h"
 
-static void pic_lock(struct kvm_pic *s)
-	__acquires(&s->lock)
-{
-	spin_lock(&s->lock);
-}
-
-static void pic_unlock(struct kvm_pic *s)
-	__releases(&s->lock)
-{
-	spin_unlock(&s->lock);
-}
-
 static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 {
 	s->isr &= ~(1 << irq);
@@ -56,10 +44,10 @@ static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
 void kvm_pic_clear_isr_ack(struct kvm *kvm)
 {
 	struct kvm_pic *s = pic_irqchip(kvm);
-	pic_lock(s);
+	spin_lock(&s->lock);
 	s->pics[0].isr_ack = 0xff;
 	s->pics[1].isr_ack = 0xff;
-	pic_unlock(s);
+	spin_unlock(&s->lock);
 }
 
 /*
@@ -160,9 +148,9 @@ static void pic_update_irq(struct kvm_pic *s)
 
 void kvm_pic_update_irq(struct kvm_pic *s)
 {
-	pic_lock(s);
+	spin_lock(&s->lock);
 	pic_update_irq(s);
-	pic_unlock(s);
+	spin_unlock(&s->lock);
 }
 
 int kvm_pic_set_irq(void *opaque, int irq, int level)
@@ -170,14 +158,14 @@ int kvm_pic_set_irq(void *opaque, int irq, int level)
 	struct kvm_pic *s = opaque;
 	int ret = -1;
 
-	pic_lock(s);
+	spin_lock(&s->lock);
 	if (irq >= 0 && irq < PIC_NUM_PINS) {
 		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
 		pic_update_irq(s);
 		trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
 				      s->pics[irq >> 3].imr, ret == 0);
 	}
-	pic_unlock(s);
+	spin_unlock(&s->lock);
 
 	return ret;
 }
@@ -205,7 +193,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 	int irq, irq2, intno;
 	struct kvm_pic *s = pic_irqchip(kvm);
 
-	pic_lock(s);
+	spin_lock(&s->lock);
 	irq = pic_get_irq(&s->pics[0]);
 	if (irq >= 0) {
 		pic_intack(&s->pics[0], irq);
@@ -230,7 +218,7 @@ int kvm_pic_read_irq(struct kvm *kvm)
 		intno = s->pics[0].irq_base + irq;
 	}
 	pic_update_irq(s);
-	pic_unlock(s);
+	spin_unlock(&s->lock);
 
 	return intno;
 }
@@ -448,7 +436,7 @@ static int picdev_write(struct kvm_io_device *this,
 			printk(KERN_ERR "PIC: non byte write\n");
 		return 0;
 	}
-	pic_lock(s);
+	spin_lock(&s->lock);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
@@ -461,7 +449,7 @@ static int picdev_write(struct kvm_io_device *this,
 		elcr_ioport_write(&s->pics[addr & 1], addr, data);
 		break;
 	}
-	pic_unlock(s);
+	spin_unlock(&s->lock);
 	return 0;
 }
 
@@ -478,7 +466,7 @@ static int picdev_read(struct kvm_io_device *this,
 			printk(KERN_ERR "PIC: non byte read\n");
 		return 0;
 	}
-	pic_lock(s);
+	spin_lock(&s->lock);
 	switch (addr) {
 	case 0x20:
 	case 0x21:
@@ -492,7 +480,7 @@ static int picdev_read(struct kvm_io_device *this,
 		break;
 	}
 	*(unsigned char *)val = data;
-	pic_unlock(s);
+	spin_unlock(&s->lock);
 	return 0;
 }
 
-- 
1.6.4.1

