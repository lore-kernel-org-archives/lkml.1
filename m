Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZGLS3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZGLS3s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbZGLS3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:16 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46935 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZGLS3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:14 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 12/15] power: bq27200: add power property
Date: Sun, 12 Jul 2009 21:09:34 +0300
Message-Id: <1247422177-7329-12-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-11-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
 <1247422177-7329-5-git-send-email-me@felipebalbi.com>
 <1247422177-7329-6-git-send-email-me@felipebalbi.com>
 <1247422177-7329-7-git-send-email-me@felipebalbi.com>
 <1247422177-7329-8-git-send-email-me@felipebalbi.com>
 <1247422177-7329-9-git-send-email-me@felipebalbi.com>
 <1247422177-7329-10-git-send-email-me@felipebalbi.com>
 <1247422177-7329-11-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

report power average to userland.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 658c2c5..dd1b2f2 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -54,6 +54,7 @@
 
 #define BQ27200_SENSING_RESISTOR	(20)	/* 20 mOhms */
 #define BQ27200_CURRENT_CONSTANT	(256 * 3570 / 1000) /* 256 * 3.57 uV */
+#define BQ27200_POWER_CONSTANT		(256 * 29200 / 1000) /* 256 * 29.2 uVVh */
 
 struct bq27200 {
 	struct power_supply	bat;
@@ -73,6 +74,7 @@ static enum power_supply_property bq27200_props[] = {
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_POWER_AVG,
 };
 
 /*
@@ -166,6 +168,19 @@ static int bq27200_rsoc(struct bq27200 *bq)
 	return ret >> 8;
 }
 
+static int bq27200_power(struct bq27200 *bq)
+{
+	int ret;
+
+	ret = bq27200_readw(bq, BQ27200_REG_AP);
+	if (ret < 0) {
+		dev_err(&bq->client->dev, "error reading average power\n");
+		return ret;
+	}
+
+	return (ret * BQ27200_POWER_CONSTANT) / BQ27200_SENSING_RESISTOR;
+}
+
 static int bq27200_get_property(struct power_supply *psy,
 		enum power_supply_property psp, union power_supply_propval *val)
 {
@@ -190,6 +205,8 @@ static int bq27200_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = bq27200_temperature(bq);
 		break;
+	case POWER_SUPPLY_PROP_POWER_AVG:
+		val->intval = bq27200_power(bq);
 	default:
 		return -EINVAL;
 	}
-- 
1.6.1.3

