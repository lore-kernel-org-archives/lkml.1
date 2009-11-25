Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZKYREQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZKYREQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbZKYREO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:14 -0500
Received: from mx1.emlix.com ([193.175.82.87]:40541 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759039AbZKYREI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:08 -0500
From: Johannes Weiner <jw@emlix.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: [patch 2/3] rtc-x1205: reset clock to sane state after power failure
Date: Wed, 25 Nov 2009 17:32:15 +0100
Message-Id: <1259166736-31006-2-git-send-email-jw@emlix.com>
In-Reply-To: <1259166736-31006-1-git-send-email-jw@emlix.com>
References: <1259166736-31006-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When detecting power failure, the probe function would reset the clock
time to defined state.

However, the clock's _date_ might still be bogus and a subsequent
probe fails when sanity-checking these values.

Change the power-failure fixup code to do a full setting of rtc_time,
including a valid date.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 drivers/rtc/rtc-x1205.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index cc9ba47..6583c1a 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -280,9 +280,9 @@ static int x1205_fix_osc(struct i2c_client *client)
 	int err;
 	struct rtc_time tm;
 
-	tm.tm_hour = tm.tm_min = tm.tm_sec = 0;
+	memset(&tm, 0, sizeof(tm));
 
-	err = x1205_set_datetime(client, &tm, 0, X1205_CCR_BASE, 0);
+	err = x1205_set_datetime(client, &tm, 1, X1205_CCR_BASE, 0);
 	if (err < 0)
 		dev_err(&client->dev, "unable to restart the oscillator\n");
 
-- 
1.6.5

