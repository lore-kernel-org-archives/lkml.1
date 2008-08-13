Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYHMXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYHMXqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYHMXqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:46:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbYHMXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:46:43 -0400
Date: Wed, 13 Aug 2008 16:45:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, cbouatmailru@gmail.com, dwmw2@infradead.org,
       giometti@linux.it
Subject: Re: [PATCH 1/1] power: support for Texas Instruments BQ27x00
 battery managers.
Message-Id: <20080813164530.82528a4d.akpm@linux-foundation.org>
In-Reply-To: <1217584435-7337-1-git-send-email-giometti@enneenne.com>
References: <1217584435-7337-1-git-send-email-giometti@enneenne.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  1 Aug 2008 11:53:55 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> From: Rodolfo Giometti <giometti@linux.it>
> 
> These battery managers came in two different packages: one for I2C
> busses (BQ27200) and one for HDQ busses (BQ27000).
> 
> This driver currently supports only the I2C chip version but the code
> is designed in order to easily allow the HDQ chip version integration.
> 
>
> ...
>
> +/* If the system has several batteries we need a different name for each
> + * of them...
> + */
> +DEFINE_IDR(battery_id);
> +DEFINE_MUTEX(battery_mutex);

These should be static.

>
> ...
>
> +static int bq27200_battery_probe(struct i2c_client *client,
> +					const struct i2c_device_id *id)
> +{
> +	char *name;
> +	struct bq27x00_device_info *di;
> +	struct bq27x00_access_methods *bus;
> +	int num, retval = 0;
> +
> +	/* Get new ID for the new battery device */
> +	retval = idr_pre_get(&battery_id, GFP_KERNEL);
> +	if (retval == 0)
> +		return -ENOMEM;
> +	mutex_lock(&battery_mutex);
> +	retval = idr_get_new(&battery_id, client, &num);
> +	mutex_unlock(&battery_mutex);
> +	if (retval < 0)
> +		return retval;
> +
> +	name = kmalloc(16, GFP_KERNEL);
> +	if (!name) {
> +		dev_err(&client->dev, "failed to allocate device name\n");
> +		retval = -ENOMEM;
> +		goto batt_failed_1;
> +	}
> +	sprintf(name, "bq27200-%d", num);

Use kasprintf()

> +	di = kzalloc(sizeof(*di), GFP_KERNEL);
> +	if (!di) {
> +		dev_err(&client->dev, "failed to allocate device info data\n");
> +		retval = -ENOMEM;
> +		goto batt_failed_2;
> +	}
> +	di->id = num;
> +

Please review:

From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space prohibited before that ':' (ctx:WxE)
#227: FILE: drivers/power/bq27x00_battery.c:175:
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW :
 	                                   ^

ERROR: space prohibited before that ':' (ctx:WxE)
#228: FILE: drivers/power/bq27x00_battery.c:176:
+	case POWER_SUPPLY_PROP_PRESENT :
 	                               ^

ERROR: space prohibited before that ':' (ctx:WxE)
#235: FILE: drivers/power/bq27x00_battery.c:183:
+	case POWER_SUPPLY_PROP_CURRENT_NOW :
 	                                   ^

ERROR: space prohibited before that ':' (ctx:WxE)
#240: FILE: drivers/power/bq27x00_battery.c:188:
+	case POWER_SUPPLY_PROP_CAPACITY :
 	                                ^

ERROR: space prohibited before that ':' (ctx:WxE)
#245: FILE: drivers/power/bq27x00_battery.c:193:
+	case POWER_SUPPLY_PROP_TEMP :
 	                            ^

total: 5 errors, 0 warnings, 412 lines checked

./patches/power-support-for-texas-instruments-bq27x00-battery-managers.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/bq27x00_battery.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/power/Kconfig~power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes drivers/power/Kconfig
diff -puN drivers/power/Makefile~power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes drivers/power/Makefile
diff -puN drivers/power/bq27x00_battery.c~power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes drivers/power/bq27x00_battery.c
--- a/drivers/power/bq27x00_battery.c~power-support-for-texas-instruments-bq27x00-battery-managers-checkpatch-fixes
+++ a/drivers/power/bq27x00_battery.c
@@ -172,25 +172,25 @@ static int bq27x00_battery_get_property(
 	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
 
 	switch (psp) {
-	case POWER_SUPPLY_PROP_VOLTAGE_NOW :
-	case POWER_SUPPLY_PROP_PRESENT :
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = bq27x00_battery_voltage(di);
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			val->intval = val->intval <= 0 ? 0 : 1;
 
 		break;
 
-	case POWER_SUPPLY_PROP_CURRENT_NOW :
+	case POWER_SUPPLY_PROP_CURRENT_NOW:
 		val->intval = bq27x00_battery_current(di);
 
 		break;
 
-	case POWER_SUPPLY_PROP_CAPACITY :
+	case POWER_SUPPLY_PROP_CAPACITY:
 		val->intval = bq27x00_battery_rsoc(di);
 
 		break;
 
-	case POWER_SUPPLY_PROP_TEMP :
+	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = bq27x00_battery_temperature(di);
 
 		break;
_






From: Andrew Morton <akpm@linux-foundation.org>

- make things static

- use kasprintf()

Cc: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/bq27x00_battery.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/power/Kconfig~power-support-for-texas-instruments-bq27x00-battery-managers-tweaks drivers/power/Kconfig
diff -puN drivers/power/Makefile~power-support-for-texas-instruments-bq27x00-battery-managers-tweaks drivers/power/Makefile
diff -puN drivers/power/bq27x00_battery.c~power-support-for-texas-instruments-bq27x00-battery-managers-tweaks drivers/power/bq27x00_battery.c
--- a/drivers/power/bq27x00_battery.c~power-support-for-texas-instruments-bq27x00-battery-managers-tweaks
+++ a/drivers/power/bq27x00_battery.c
@@ -40,8 +40,8 @@
 /* If the system has several batteries we need a different name for each
  * of them...
  */
-DEFINE_IDR(battery_id);
-DEFINE_MUTEX(battery_mutex);
+static DEFINE_IDR(battery_id);
+static DEFINE_MUTEX(battery_mutex);
 
 struct bq27x00_device_info;
 struct bq27x00_access_methods {
@@ -275,13 +275,12 @@ static int bq27200_battery_probe(struct 
 	if (retval < 0)
 		return retval;
 
-	name = kmalloc(16, GFP_KERNEL);
+	name = kasprintf(GFP_KERNEL, "bq27200-%d", num);
 	if (!name) {
 		dev_err(&client->dev, "failed to allocate device name\n");
 		retval = -ENOMEM;
 		goto batt_failed_1;
 	}
-	sprintf(name, "bq27200-%d", num);
 
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di) {
_

