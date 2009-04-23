Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZDWXK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZDWXK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755554AbZDWXKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:10:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50464 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbZDWXKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:10:46 -0400
From: Dave Airlie <airlied@gmail.com>
To: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Dave Airlie <airlied@redhat.com>
Subject: [PATCH] i2c: fix bit algorithm timeout for low values.
Date: Fri, 24 Apr 2009 09:09:13 +1000
Message-Id: <1240528153-5370-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

When fetching DDC using i2c algo bit, we were often seeing timeouts
before getting valid EDID on a retry. The VESA spec states 2ms is the
DDC timeout, so when this translates into 1 jiffie and we are close
to the end of the time period, it could return with a timeout less than
2ms.

Change this code to use time_after instead of time_after_eq.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/i2c/algos/i2c-algo-bit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/algos/i2c-algo-bit.c b/drivers/i2c/algos/i2c-algo-bit.c
index d420cc5..e25e139 100644
--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -104,7 +104,7 @@ static int sclhi(struct i2c_algo_bit_data *adap)
 		 * chips may hold it low ("clock stretching") while they
 		 * are processing data internally.
 		 */
-		if (time_after_eq(jiffies, start + adap->timeout))
+		if (time_after(jiffies, start + adap->timeout))
 			return -ETIMEDOUT;
 		cond_resched();
 	}
-- 
1.6.0.6

