Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbZGLSbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbZGLSbf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZGLSaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:30:07 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47062 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbZGLSaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:30:06 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 09/15] power: bq27200: fix up current reporting
Date: Sun, 12 Jul 2009 21:09:31 +0300
Message-Id: <1247422177-7329-9-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-8-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
 <1247422177-7329-5-git-send-email-me@felipebalbi.com>
 <1247422177-7329-6-git-send-email-me@felipebalbi.com>
 <1247422177-7329-7-git-send-email-me@felipebalbi.com>
 <1247422177-7329-8-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

according to bq27200 datasheet, avarage current is calculated
with the following equation:

current = (256 * AI) * 3.57 / Rs

where Rs = 20mOhms

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index f36633c..869761e 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -52,6 +52,9 @@
 #define BQ27200_REG_CYCT		0x2a	/* cycle-count total */
 #define BQ27200_REG_CSOC		0x2c	/* compensated state-of-charge */
 
+#define BQ27200_SENSING_RESISTOR	(20)	/* 20 mOhms */
+#define BQ27200_CURRENT_CONSTANT	(256 * 3570 / 1000) /* 256 * 3.57 uV */
+
 struct bq27200 {
 	struct power_supply	bat;
 	struct i2c_client	*client;
@@ -143,7 +146,7 @@ static int bq27200_current(struct bq27200 *bq)
 		return 0;
 	}
 
-	return ret;
+	return (ret * BQ27200_CURRENT_CONSTANT) / BQ27200_SENSING_RESISTOR;
 }
 
 /*
-- 
1.6.1.3

