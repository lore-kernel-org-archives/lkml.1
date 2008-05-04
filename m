Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbYEDF2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbYEDF2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 01:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbYEDF2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 01:28:09 -0400
Received: from mail.queued.net ([207.210.101.209]:1330 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbYEDF2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 01:28:08 -0400
Date: Sun, 4 May 2008 01:31:42 -0400
From: Andres Salomon <dilinger@queued.net>
To: cbouatmailru@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] power_supply: Support serial number and ACR in
 olpc_battery
Message-ID: <20080504013142.03c8ad0b@ephemeral>
In-Reply-To: <20080502225849.GA26024@zarina>
References: <20080430163002.3c768ae0@ephemeral>
	<20080502225849.GA26024@zarina>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008 02:58:49 +0400
Anton Vorontsov <cbouatmailru@gmail.com> wrote:

> On Wed, Apr 30, 2008 at 04:30:02PM -0400, Andres Salomon wrote:
> > From: David Woodhouse <dwmw2@infradead.org>
> > 
> > This adds serial number and accumulated current support to the OLPC
> > battery driver.
> 
> How PROP_ACCUM_CURRENT is different from PROP_CHARGE_NOW (uAh)?
> 
> The DS2760 is already using the later to report its ACR register...
> 

Hm, I can change that.  In the meantime, I've stripped out the
ACR stuff.  Can you please use the following patch instead?  The change
doesn't conflict with the other 3 patches.





From: David Woodhouse <dwmw2@infradead.org>

power_supply: Support serial number in olpc_battery

This adds serial number support to the OLPC
battery driver.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index ab1e828..7524a63 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -84,6 +84,8 @@ static struct power_supply olpc_ac = {
 	.get_property = olpc_ac_get_prop,
 };
 
+static char bat_serial[17]; /* Ick */
+
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
@@ -94,6 +96,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	int ret = 0;
 	int16_t ec_word;
 	uint8_t ec_byte;
+	uint64_t ser_buf;
 
 	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
 	if (ret)
@@ -241,6 +244,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		ec_word = be16_to_cpu(ec_word);
 		val->intval = ec_word * 100 / 256;
 		break;
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
+		if (ret)
+			return ret;
+
+		sprintf(bat_serial, "%016llx", (long long)be64_to_cpu(ser_buf));
+		val->strval = bat_serial;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -260,6 +271,7 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
 
 /*********************************************************************
-- 
1.5.5.1

