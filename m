Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZKYREM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZKYREM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbZKYREJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:09 -0500
Received: from mx1.emlix.com ([193.175.82.87]:41763 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969AbZKYREG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:06 -0500
X-Greylist: delayed 1973 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2009 12:04:06 EST
From: Johannes Weiner <jw@emlix.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: [patch 1/3] rtc-x1205: fix rtc_time to y2k register value conversion
Date: Wed, 25 Nov 2009 17:32:14 +0100
Message-Id: <1259166736-31006-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The possible CCR_Y2K register values are 19 or 20 and struct
rtc_time's tm_year is in years since 1900.

The function translating rtc_time to register values assumes tm_year
to be years since first christmas, though, and we end up storing 0 or
1 in the CCR_Y2K register, which the hardware does not refuse to do.

A subsequent probing of the clock fails due to the invalid value range
in the register, though.

[ And if it didn't, reading the clock would yield a bogus year because
  the function translating registers to tm_year is assuming a register
  value of 19 or 20. ]

This fixes the conversion from years since 1900 in tm_year to the
corresponding CCR_Y2K value of 19 or 20.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 drivers/rtc/rtc-x1205.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 310c107..cc9ba47 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -195,7 +195,7 @@ static int x1205_set_datetime(struct i2c_client *client, struct rtc_time *tm,
 		/* year, since the rtc epoch*/
 		buf[CCR_YEAR] = bin2bcd(tm->tm_year % 100);
 		buf[CCR_WDAY] = tm->tm_wday & 0x07;
-		buf[CCR_Y2K] = bin2bcd(tm->tm_year / 100);
+		buf[CCR_Y2K] = bin2bcd((tm->tm_year + 1900) / 100);
 	}
 
 	/* If writing alarm registers, set compare bits on registers 0-4 */
-- 
1.6.5

