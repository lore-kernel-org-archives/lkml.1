Return-Path: <linux-kernel-owner+w=401wt.eu-S932575AbYBUNko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575AbYBUNko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYBUNkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:40:35 -0500
Received: from 75.neteffect.com ([204.57.75.75]:64145 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751049AbYBUNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:40:34 -0500
Date: Thu, 21 Feb 2008 08:34:58 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211434.m1LEYwnH005193@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 8/8] RDMA/nes: Fix interrupt moderation low threshold
Cc: general@lists.openfabrics.org, jlacombe@neteffect.com,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Lacombe <jlacombe@neteffect.com>

Interrupt moderation low threshold value was incorrectly
triggering, indicating that the threshold should be lowered.

The impact was the timer was likely to become 40usecs and get
stuck there.  The biggest side effect was too many interrupts
and nonoptimal performance.

Signed-off-by: John Lacombe <jlacombe@neteffect.com>
Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes_hw.c |   12 ++++--------
 drivers/infiniband/hw/nes/nes_hw.h |    2 +-
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 7c4c0fb..6b677b5 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -156,15 +156,13 @@ static void nes_nic_tune_timer(struct nes_device *nesdev)
 
 	spin_lock_irqsave(&nesadapter->periodic_timer_lock, flags);
 
-	if (shared_timer->cq_count_old < cq_count) {
-		if (cq_count > shared_timer->threshold_low)
-			shared_timer->cq_direction_downward=0;
-	}
-	if (shared_timer->cq_count_old >= cq_count)
+	if (shared_timer->cq_count_old <= cq_count)
+		shared_timer->cq_direction_downward = 0;
+	else
 		shared_timer->cq_direction_downward++;
 	shared_timer->cq_count_old = cq_count;
 	if (shared_timer->cq_direction_downward > NES_NIC_CQ_DOWNWARD_TREND) {
-		if (cq_count <= shared_timer->threshold_low) {
+		if (cq_count <= shared_timer->threshold_low && (shared_timer->threshold_low > 4)) {
 			shared_timer->threshold_low = shared_timer->threshold_low/2;
 			shared_timer->cq_direction_downward=0;
 			nesdev->currcq_count = 0;
@@ -1728,7 +1726,6 @@ int nes_napi_isr(struct nes_device *nesdev)
 			nesdev->int_req &= ~NES_INT_TIMER;
 			nes_write32(nesdev->regs+NES_INTF_INT_MASK, ~(nesdev->intf_int_req));
 			nes_write32(nesdev->regs+NES_INT_MASK, ~nesdev->int_req);
-			nesadapter->tune_timer.timer_in_use_old = 0;
 		}
 		nesdev->deepcq_count = 0;
 		return 1;
@@ -1867,7 +1864,6 @@ void nes_dpc(unsigned long param)
 					nesdev->int_req &= ~NES_INT_TIMER;
 					nes_write32(nesdev->regs + NES_INTF_INT_MASK, ~(nesdev->intf_int_req));
 					nes_write32(nesdev->regs+NES_INT_MASK, ~nesdev->int_req);
-					nesdev->nesadapter->tune_timer.timer_in_use_old = 0;
 				} else {
 					nes_write32(nesdev->regs+NES_INT_MASK, 0x0000ffff|(~nesdev->int_req));
 				}
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 1e10df5..b7e2844 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -962,7 +962,7 @@ struct nes_arp_entry {
 #define DEFAULT_JUMBO_NES_QL_LOW    12
 #define DEFAULT_JUMBO_NES_QL_TARGET 40
 #define DEFAULT_JUMBO_NES_QL_HIGH   128
-#define NES_NIC_CQ_DOWNWARD_TREND   8
+#define NES_NIC_CQ_DOWNWARD_TREND   16
 
 struct nes_hw_tune_timer {
     //u16 cq_count;
