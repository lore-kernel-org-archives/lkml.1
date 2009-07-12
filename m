Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbZGLUL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbZGLUL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZGLULw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:11:52 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:53999 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZGLULv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:11:51 -0400
Date: Sun, 12 Jul 2009 23:11:46 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [rfc/patch 12/15] power: bq27200: add power property
Message-ID: <20090712201145.GA11865@gandalf>
Reply-To: me@felipebalbi.com
References: <1247422177-7329-3-git-send-email-me@felipebalbi.com> <1247422177-7329-4-git-send-email-me@felipebalbi.com> <1247422177-7329-5-git-send-email-me@felipebalbi.com> <1247422177-7329-6-git-send-email-me@felipebalbi.com> <1247422177-7329-7-git-send-email-me@felipebalbi.com> <1247422177-7329-8-git-send-email-me@felipebalbi.com> <1247422177-7329-9-git-send-email-me@felipebalbi.com> <1247422177-7329-10-git-send-email-me@felipebalbi.com> <1247422177-7329-11-git-send-email-me@felipebalbi.com> <1247422177-7329-12-git-send-email-me@felipebalbi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <1247422177-7329-12-git-send-email-me@felipebalbi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jul 12, 2009 at 09:09:34PM +0300, Felipe Balbi wrote:
> @@ -190,6 +205,8 @@ static int bq27200_get_property(struct power_supply *=
psy,
>  	case POWER_SUPPLY_PROP_TEMP:
>  		val->intval =3D bq27200_temperature(bq);
>  		break;
> +	case POWER_SUPPLY_PROP_POWER_AVG:
> +		val->intval =3D bq27200_power(bq);

missing break here. Updated patch attached.

--=20
balbi

--cmJC7u66zC7hs+87
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0012-power-bq27200-add-power-property.diff"
Content-Transfer-Encoding: quoted-printable

=46rom c28459cbfa2dcdbb0c3f6ea7f662fb4f9a582ede Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <me@felipebalbi.com>
Date: Wed, 8 Jul 2009 13:33:38 +0300
Subject: [PATCH 12/15] power: bq27200: add power property

report power average to userland.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_batter=
y.c
index 658c2c5..1b08f39 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -54,6 +54,7 @@
=20
 #define BQ27200_SENSING_RESISTOR	(20)	/* 20 mOhms */
 #define BQ27200_CURRENT_CONSTANT	(256 * 3570 / 1000) /* 256 * 3.57 uV */
+#define BQ27200_POWER_CONSTANT		(256 * 29200 / 1000) /* 256 * 29.2 uVVh */
=20
 struct bq27200 {
 	struct power_supply	bat;
@@ -73,6 +74,7 @@ static enum power_supply_property bq27200_props[] =3D {
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_POWER_AVG,
 };
=20
 /*
@@ -166,6 +168,19 @@ static int bq27200_rsoc(struct bq27200 *bq)
 	return ret >> 8;
 }
=20
+static int bq27200_power(struct bq27200 *bq)
+{
+	int ret;
+
+	ret =3D bq27200_readw(bq, BQ27200_REG_AP);
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
@@ -190,6 +205,9 @@ static int bq27200_get_property(struct power_supply *ps=
y,
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval =3D bq27200_temperature(bq);
 		break;
+	case POWER_SUPPLY_PROP_POWER_AVG:
+		val->intval =3D bq27200_power(bq);
+		break;
 	default:
 		return -EINVAL;
 	}
--=20
1.6.4.rc0.17.gd9eb0


--cmJC7u66zC7hs+87--
