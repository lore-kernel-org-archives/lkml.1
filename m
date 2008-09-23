Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYIWNv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYIWNv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbYIWNrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:47:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52372 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbYIWNrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:47:21 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 14/40] KVM: Consolidate PIC isr clearing into a function
Date: Tue, 23 Sep 2008 16:46:28 +0300
Message-Id: <1222177614-26669-15-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/i8259.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index c31164e..55e179a 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -30,6 +30,11 @@
 
 #include <linux/kvm_host.h>
 
+static void pic_clear_isr(struct kvm_kpic_state *s, int irq)
+{
+	s->isr &= ~(1 << irq);
+}
+
 /*
  * set irq level. If an edge is detected, then the IRR is set to 1
  */
@@ -141,11 +146,12 @@ void kvm_pic_set_irq(void *opaque, int irq, int level)
  */
 static inline void pic_intack(struct kvm_kpic_state *s, int irq)
 {
+	s->isr |= 1 << irq;
 	if (s->auto_eoi) {
 		if (s->rotate_on_auto_eoi)
 			s->priority_add = (irq + 1) & 7;
-	} else
-		s->isr |= (1 << irq);
+		pic_clear_isr(s, irq);
+	}
 	/*
 	 * We don't clear a level sensitive interrupt here
 	 */
@@ -243,7 +249,7 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
 				priority = get_priority(s, s->isr);
 				if (priority != 8) {
 					irq = (priority + s->priority_add) & 7;
-					s->isr &= ~(1 << irq);
+					pic_clear_isr(s, irq);
 					if (cmd == 5)
 						s->priority_add = (irq + 1) & 7;
 					pic_update_irq(s->pics_state);
@@ -251,7 +257,7 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
 				break;
 			case 3:
 				irq = val & 7;
-				s->isr &= ~(1 << irq);
+				pic_clear_isr(s, irq);
 				pic_update_irq(s->pics_state);
 				break;
 			case 6:
@@ -260,8 +266,8 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
 				break;
 			case 7:
 				irq = val & 7;
-				s->isr &= ~(1 << irq);
 				s->priority_add = (irq + 1) & 7;
+				pic_clear_isr(s, irq);
 				pic_update_irq(s->pics_state);
 				break;
 			default:
@@ -303,7 +309,7 @@ static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
 			s->pics_state->pics[0].irr &= ~(1 << 2);
 		}
 		s->irr &= ~(1 << ret);
-		s->isr &= ~(1 << ret);
+		pic_clear_isr(s, ret);
 		if (addr1 >> 7 || ret != 2)
 			pic_update_irq(s->pics_state);
 	} else {
-- 
1.6.0.1

