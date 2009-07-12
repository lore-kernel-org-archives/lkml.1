Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbZGLSag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbZGLSag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZGLS3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:19 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46947 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbZGLS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:18 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 15/15] power: bq27200: add energy average
Date: Sun, 12 Jul 2009 21:09:37 +0300
Message-Id: <1247422177-7329-15-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-14-git-send-email-me@felipebalbi.com>
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
 <1247422177-7329-12-git-send-email-me@felipebalbi.com>
 <1247422177-7329-13-git-send-email-me@felipebalbi.com>
 <1247422177-7329-14-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

report energy average to userland.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 26ef2be..2fbe7a4 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -77,6 +77,7 @@ static enum power_supply_property bq27200_props[] = {
 	POWER_SUPPLY_PROP_POWER_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
+	POWER_SUPPLY_PROP_ENERGY_AVG,
 };
 
 /*
@@ -183,6 +184,19 @@ static int bq27200_power(struct bq27200 *bq)
 	return (ret * BQ27200_POWER_CONSTANT) / BQ27200_SENSING_RESISTOR;
 }
 
+static int bq27200_energy(struct bq27200 *bq)
+{
+	int ret;
+
+	ret = bq27200_readw(bq, BQ27200_REG_SAE);
+	if (ret < 0) {
+		dev_err(&bq->client->dev, "error reading average energy\n");
+		return ret;
+	}
+
+	return (ret * BQ27200_POWER_CONSTANT) / BQ27200_SENSING_RESISTOR;
+}
+
 static int bq27200_time_to_empty(struct bq27200 *bq)
 {
 	int ret;
@@ -242,6 +256,9 @@ static int bq27200_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
 		val->intval = bq27200_time_to_full(bq);
 		break;
+	case POWER_SUPPLY_PROP_ENERGY_AVG:
+		val->intval = bq27200_energy(bq);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.6.1.3

