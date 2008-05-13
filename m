Return-Path: <linux-kernel-owner+w=401wt.eu-S1758258AbYEMQTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbYEMQTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYEMQT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:19:29 -0400
Received: from mail.queued.net ([207.210.101.209]:3809 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755324AbYEMQT2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:19:28 -0400
Date: Tue, 13 May 2008 12:23:30 -0400
From: Andres Salomon <dilinger@queued.net>
To: richard@laptop.org
Cc: avorontsov@ru.mvista.com, Andrew Morton <akpm@linux-foundation.org>,
       cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: add CHARGE_COUNTER property and
 olpc_battery support for it
Message-ID: <20080513122330.4c81e289@ephemeral>
In-Reply-To: <4829A39F.7050308@laptop.org>
References: <20080508003454.722ba511@ephemeral>
	<20080508105145.GA32017@polina.dev.rtsoft.ru>
	<20080508130102.3218f1e9@ephemeral>
	<20080508171320.GA8226@polina.dev.rtsoft.ru>
	<48234C25.4040807@laptop.org>
	<20080508193614.GA31188@polina.dev.rtsoft.ru>
	<4823663B.6060409@laptop.org>
	<20080512214629.443a5999@ephemeral>
	<4829A39F.7050308@laptop.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 10:20:15 -0400
"Richard A. Smith" <richard@laptop.org> wrote:

> Andres Salomon wrote:
> 
> > +		ec_word = be16_to_cpu(ec_word);
> > +		val->intval = ec_word * 4167 / 10;
> 
> Whats wrong with:
> 
>  > +		val->intval = ((int)ec_word) * 6250 / 15;
> 
> Which does not have overflow problems and keeps more precision.
> 

You're right, of course.  Anton, can you please apply the following?



Subject: [PATCH] power_supply: fix up CHARGE_COUNTER output to be more precise

As Richard Smith pointed out, ACR * 6250 / 15  provides for less precision
loss than ACR * 4167 / 10, _and_ it doesn't overflow.  Switch to using
that equation for CHARGE_COUNTER.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index a928165..f5d712a 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -19,7 +19,7 @@
 
 #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
 #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
-#define EC_BAT_ACR	0x12	/* int16_t,	*416.7,      µAh  */
+#define EC_BAT_ACR	0x12	/* int16_t,	*6250/15,    µAh  */
 #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   °C  */
 #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   °C  */
 #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
@@ -295,7 +295,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 			return ret;
 
 		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 4167 / 10;
+		val->intval = ec_word * 6250 / 15;
 		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
-- 
1.5.5.1

