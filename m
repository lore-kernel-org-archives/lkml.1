Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZGLUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZGLUNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZGLUM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:12:59 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:42454 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbZGLUM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:12:59 -0400
Date: Sun, 12 Jul 2009 23:12:53 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc/patch 14/15] power: bq27200: add time to empty/full
Message-ID: <20090712201252.GB11865@gandalf>
Reply-To: me@felipebalbi.com
References: <1247422177-7329-5-git-send-email-me@felipebalbi.com> <1247422177-7329-6-git-send-email-me@felipebalbi.com> <1247422177-7329-7-git-send-email-me@felipebalbi.com> <1247422177-7329-8-git-send-email-me@felipebalbi.com> <1247422177-7329-9-git-send-email-me@felipebalbi.com> <1247422177-7329-10-git-send-email-me@felipebalbi.com> <1247422177-7329-11-git-send-email-me@felipebalbi.com> <1247422177-7329-12-git-send-email-me@felipebalbi.com> <1247422177-7329-13-git-send-email-me@felipebalbi.com> <1247422177-7329-14-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <1247422177-7329-14-git-send-email-me@felipebalbi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Sun, Jul 12, 2009 at 09:09:36PM +0300, Felipe Balbi wrote:
> @@ -207,6 +235,13 @@ static int bq27200_get_property(struct power_supply *psy,
>  		break;
>  	case POWER_SUPPLY_PROP_POWER_AVG:
>  		val->intval = bq27200_power(bq);
> +		break;

this break doesn't belong here. Updated patch attached.

-- 
balbi

--UFHRwCdBEJvubb2X
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0014-power-bq27200-add-time-to-empty-full.diff"

>From 6b84f9b12f449df2131bf446f4f1e1f12148ef2f Mon Sep 17 00:00:00 2001
From: Felipe Balbi <me@felipebalbi.com>
Date: Wed, 8 Jul 2009 13:45:02 +0300
Subject: [PATCH 14/15] power: bq27200: add time to empty/full

the chip reports time to empty and time to full
in minutes, so we multiply the result by 60 to get
it in seconds as requested by power_supply interface.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 442d81a..26ef2be 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -75,6 +75,8 @@ static enum power_supply_property bq27200_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_POWER_AVG,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
+	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
 };
 
 /*
@@ -181,6 +183,32 @@ static int bq27200_power(struct bq27200 *bq)
 	return (ret * BQ27200_POWER_CONSTANT) / BQ27200_SENSING_RESISTOR;
 }
 
+static int bq27200_time_to_empty(struct bq27200 *bq)
+{
+	int ret;
+
+	ret = bq27200_readw(bq, BQ27200_REG_TTE);
+	if (ret < 0) {
+		dev_err(&bq->client->dev, "error reading time to empty\n");
+		return ret;
+	}
+
+	return ret * 60;
+}
+
+static int bq27200_time_to_full(struct bq27200 *bq)
+{
+	int ret;
+
+	ret = bq27200_readw(bq, BQ27200_REG_TTF);
+	if (ret < 0) {
+		dev_err(&bq->client->dev, "error reading time to full\n");
+		return ret;
+	}
+
+	return ret * 60;
+}
+
 static int bq27200_get_property(struct power_supply *psy,
 		enum power_supply_property psp, union power_supply_propval *val)
 {
@@ -208,6 +236,12 @@ static int bq27200_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_POWER_AVG:
 		val->intval = bq27200_power(bq);
 		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+		val->intval = bq27200_time_to_empty(bq);
+		break;
+	case POWER_SUPPLY_PROP_TIME_TO_FULL_AVG:
+		val->intval = bq27200_time_to_full(bq);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
1.6.4.rc0.17.gd9eb0


--UFHRwCdBEJvubb2X--
