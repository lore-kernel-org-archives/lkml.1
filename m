Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYCQJji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYCQJji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 05:39:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbYCQJhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 05:37:47 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:42595 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753546AbYCQJhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 05:37:24 -0400
From: =?utf-8?q?S=2E=C3=87a=C4=9Flar=20Onur?= <caglar@pardus.org.tr>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/net/wireless/atmel.c: Use time_* macros
Date: Mon, 17 Mar 2008 11:36:31 +0200
Message-Id: <1205746593-24820-9-git-send-email-caglar@pardus.org.tr>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205746593-24820-8-git-send-email-caglar@pardus.org.tr>
References: <>
 <1205746593-24820-1-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-2-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-3-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-4-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-5-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-6-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-7-git-send-email-caglar@pardus.org.tr>
 <1205746593-24820-8-git-send-email-caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq are more robust for comparing jiffies against other values.

So following patch implements usage of the time_after() macro, defined at linux/jiffies.h, which deals with wrapping correctly

Cc: linux-wireless@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
---
 drivers/net/wireless/atmel.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 63ec7a7..ef2da40 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -66,6 +66,7 @@
 #include <linux/device.h>
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
+#include <linux/jiffies.h>
 #include <net/ieee80211.h>
 #include "atmel.h"
 
@@ -516,7 +517,7 @@ struct atmel_private {
 		SITE_SURVEY_IN_PROGRESS,
 		SITE_SURVEY_COMPLETED
 	} site_survey_state;
-	time_t last_survey;
+	unsigned long last_survey;
 
 	int station_was_associated, station_is_associated;
 	int fast_scan;
@@ -2283,7 +2284,7 @@ static int atmel_set_scan(struct net_device *dev,
 		return -EAGAIN;
 
 	/* Timeout old surveys. */
-	if ((jiffies - priv->last_survey) > (20 * HZ))
+	if (time_after(jiffies, priv->last_survey + 20 * HZ))
 		priv->site_survey_state = SITE_SURVEY_IDLE;
 	priv->last_survey = jiffies;
 
-- 
1.5.4.3

