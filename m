Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZI3Rfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZI3Rfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZI3Rfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:35:51 -0400
Received: from mail-pz0-f191.google.com ([209.85.222.191]:56398 "EHLO
	mail-pz0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZI3Rfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:35:50 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: [PATCH] CPUidle: always return with interrupts enabled
Date: Wed, 30 Sep 2009 10:35:53 -0700
Message-Id: <1254332153-23493-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case where cpuidle_idle_call() returns before changing state
due to a need_resched(), it was returning with IRQs disabled.

This patch ensures IRQs are (re)enabled before returning.

Reported-by: Hemanth V <hemanthv@ti.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/cpuidle/cpuidle.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index ad41f19..12fdd39 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -76,8 +76,11 @@ static void cpuidle_idle_call(void)
 #endif
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
-	if (need_resched())
+	if (need_resched()) {
+		local_irq_enable();
 		return;
+	}
+
 	target_state = &dev->states[next_state];
 
 	/* enter the state and update stats */
-- 
1.6.4.3

