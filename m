Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXJULLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXJULLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbXJULIB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:08:01 -0400
Received: from il.qumranet.com ([82.166.9.18]:58449 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbXJULH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:07:56 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Kevin Pedretti <kevin.pedretti@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 11/11] KVM: Improve local apic timer wraparound handling
Date: Sun, 21 Oct 2007 13:08:12 +0200
Message-Id: <11929648924174-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <1192964892617-git-send-email-avi@qumranet.com>
References: <1192964892617-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Pedretti <kevin.pedretti@gmail.com>

Better handle wrap-around cases when reading the APIC CCR
(current count register).  Also, if ICR is 0, CCR should also
be 0... previously reading CCR before setting ICR would result
in a large kinda-random number.

Signed-off-by: Kevin Pedretti <kevin.pedretti@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/lapic.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/kvm/lapic.c b/drivers/kvm/lapic.c
index 443730e..238fcad 100644
--- a/drivers/kvm/lapic.c
+++ b/drivers/kvm/lapic.c
@@ -494,12 +494,19 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 
 static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
-	u32 counter_passed;
-	ktime_t passed, now = apic->timer.dev.base->get_time();
-	u32 tmcct = apic_get_reg(apic, APIC_TMICT);
+	u64 counter_passed;
+	ktime_t passed, now;
+	u32 tmcct;
 
 	ASSERT(apic != NULL);
 
+	now = apic->timer.dev.base->get_time();
+	tmcct = apic_get_reg(apic, APIC_TMICT);
+
+	/* if initial count is 0, current count should also be 0 */
+	if (tmcct == 0)
+		return 0;
+
 	if (unlikely(ktime_to_ns(now) <=
 		ktime_to_ns(apic->timer.last_update))) {
 		/* Wrap around */
@@ -514,15 +521,24 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 
 	counter_passed = div64_64(ktime_to_ns(passed),
 				  (APIC_BUS_CYCLE_NS * apic->timer.divide_count));
-	tmcct -= counter_passed;
 
-	if (tmcct <= 0) {
-		if (unlikely(!apic_lvtt_period(apic)))
+	if (counter_passed > tmcct) {
+		if (unlikely(!apic_lvtt_period(apic))) {
+			/* one-shot timers stick at 0 until reset */
 			tmcct = 0;
-		else
-			do {
-				tmcct += apic_get_reg(apic, APIC_TMICT);
-			} while (tmcct <= 0);
+		} else {
+			/*
+			 * periodic timers reset to APIC_TMICT when they
+			 * hit 0. The while loop simulates this happening N
+			 * times. (counter_passed %= tmcct) would also work,
+			 * but might be slower or not work on 32-bit??
+			 */
+			while (counter_passed > tmcct)
+				counter_passed -= tmcct;
+			tmcct -= counter_passed;
+		}
+	} else {
+		tmcct -= counter_passed;
 	}
 
 	return tmcct;
-- 
1.5.3

