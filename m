Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbZDJKE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbZDJKE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZDJKER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:04:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:65288 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZDJKEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:04:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=rPcprV5ekNC6RfvdEiwGOWB3Suu9ZwGQuNpMOaloxT/8AhyZB2EHSCfhfd7rXIvV72
         VUgZUhZH/ygV/5PnBGx/gtj3MEdgK4blgYwXEP1IR3yrkHQJT9FjKKZxjRRIycxLO3G3
         VQ2Vcl9EugWin+4WBtmlcMORAjmikyuz6ruMU=
MIME-Version: 1.0
From: Kim Kyuwon <chammoru@gmail.com>
Date: Fri, 10 Apr 2009 19:04:01 +0900
Message-ID: <4d34a0a70904100304n1f9458cdo9924a2685bae2f9b@mail.gmail.com>
Subject: [PATCH 3/3] leds: add the sysfs interface into the leds-bd2802 driver 
	for changing wave pattern and led current.
To: LKML <linux-kernel@vger.kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
       =?EUC-KR?B?udqw5rnO?= <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allow the user application to change the wave pattern and
led current by 'wave_pattern' and 'rgb_current' sysfs files.

Signed-off-by: Kim Kyuwon <q1.kim@samsung.com>
---
 drivers/leds/leds-bd2802.c |   86 +++++++++++++++++++++++++++++++++++++-------
 1 files changed, 73 insertions(+), 13 deletions(-)

diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
index 7a03efd..779d7f2 100644
--- a/drivers/leds/leds-bd2802.c
+++ b/drivers/leds/leds-bd2802.c
@@ -97,6 +97,10 @@ struct bd2802_led {
 	enum led_ids			led_id;
 	enum led_colors			color;
 	enum led_bits			state;
+
+	/* General attributes of RGB LEDs */
+	int				wave_pattern;
+	int				rgb_current;
 };


@@ -254,7 +258,7 @@ static void bd2802_set_on(struct bd2802_led *led,
enum led_ids id,
 		bd2802_reset_cancel(led);

 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT1SETUP);
-	bd2802_write_byte(led->client, reg, BD2802_CURRENT_032);
+	bd2802_write_byte(led->client, reg, led->rgb_current);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT2SETUP);
 	bd2802_write_byte(led->client, reg, BD2802_CURRENT_000);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_WAVEPATTERN);
@@ -275,9 +279,9 @@ static void bd2802_set_blink(struct bd2802_led
*led, enum led_ids id,
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT1SETUP);
 	bd2802_write_byte(led->client, reg, BD2802_CURRENT_000);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_CURRENT2SETUP);
-	bd2802_write_byte(led->client, reg, BD2802_CURRENT_032);
+	bd2802_write_byte(led->client, reg, led->rgb_current);
 	reg = bd2802_get_reg_addr(id, color, BD2802_REG_WAVEPATTERN);
-	bd2802_write_byte(led->client, reg, BD2802_PATTERN_HALF);
+	bd2802_write_byte(led->client, reg, led->wave_pattern);

 	bd2802_enable(led, id);
 	bd2802_update_state(led, id, color, BD2802_BLINK);
@@ -406,7 +410,7 @@ static void bd2802_enable_adv_conf(struct bd2802_led *led)
 		ret = device_create_file(&led->client->dev,
 						bd2802_addr_attributes[i]);
 		if (ret) {
-			dev_err(&led->client->dev, "failed to sysfs file %s\n",
+			dev_err(&led->client->dev, "failed: sysfs file %s\n",
 					bd2802_addr_attributes[i]->attr.name);
 			goto failed_remove_files;
 		}
@@ -483,6 +487,52 @@ static struct device_attribute bd2802_adv_conf_attr = {
 	.store = bd2802_store_adv_conf,
 };

+#define BD2802_CONTROL_ATTR(attr_name, name_str)			\
+static ssize_t bd2802_show_##attr_name(struct device *dev,		\
+	struct device_attribute *attr, char *buf)			\
+{									\
+	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
+	ssize_t ret;							\
+	down_read(&led->rwsem);						\
+	ret = sprintf(buf, "0x%02x\n", led->attr_name);			\
+	up_read(&led->rwsem);						\
+	return ret;							\
+}									\
+static ssize_t bd2802_store_##attr_name(struct device *dev,		\
+	struct device_attribute *attr, const char *buf, size_t count)	\
+{									\
+	struct bd2802_led *led = i2c_get_clientdata(to_i2c_client(dev));\
+	unsigned long val;						\
+	int ret;							\
+	if (!count)							\
+		return -EINVAL;						\
+	ret = strict_strtoul(buf, 16, &val);				\
+	if (ret)							\
+		return ret;						\
+	down_write(&led->rwsem);					\
+	led->attr_name = val;						\
+	up_write(&led->rwsem);						\
+	return count;							\
+}									\
+static struct device_attribute bd2802_##attr_name##_attr = {		\
+	.attr = {							\
+		.name = name_str,					\
+		.mode = 0644,						\
+		.owner = THIS_MODULE					\
+	},								\
+	.show = bd2802_show_##attr_name,				\
+	.store = bd2802_store_##attr_name,				\
+};
+
+BD2802_CONTROL_ATTR(wave_pattern, "wave_pattern");
+BD2802_CONTROL_ATTR(rgb_current, "rgb_current");
+
+static struct device_attribute *bd2802_attributes[] = {
+	&bd2802_adv_conf_attr,
+	&bd2802_wave_pattern_attr,
+	&bd2802_rgb_current_attr,
+};
+
 static void bd2802_led_work(struct work_struct *work)
 {
 	struct bd2802_led *led = container_of(work, struct bd2802_led, work);
@@ -635,7 +685,7 @@ static int __devinit bd2802_probe(struct i2c_client *client,
 {
 	struct bd2802_led *led;
 	struct bd2802_led_platform_data *pdata;
-	int ret;
+	int ret, i;

 	led = kzalloc(sizeof(struct bd2802_led), GFP_KERNEL);
 	if (!led) {
@@ -665,13 +715,20 @@ static int __devinit bd2802_probe(struct
i2c_client *client,
 	/* To save the power, reset BD2802 after detecting */
 	gpio_set_value(led->pdata->reset_gpio, 0);

+	/* Default attributes */
+	led->wave_pattern = BD2802_PATTERN_HALF;
+	led->rgb_current = BD2802_CURRENT_032;
+
 	init_rwsem(&led->rwsem);

-	ret = device_create_file(&client->dev, &bd2802_adv_conf_attr);
-	if (ret) {
-		dev_err(&client->dev, "failed to create sysfs file %s\n",
-					bd2802_adv_conf_attr.attr.name);
-		goto failed_free;
+	for (i = 0; i < ARRAY_SIZE(bd2802_attributes); i++) {
+		ret = device_create_file(&led->client->dev,
+						bd2802_attributes[i]);
+		if (ret) {
+			dev_err(&led->client->dev, "failed: sysfs file %s\n",
+					bd2802_attributes[i]->attr.name);
+			goto failed_unregister_dev_file;
+		}
 	}

 	ret = bd2802_register_led_classdev(led);
@@ -681,7 +738,8 @@ static int __devinit bd2802_probe(struct i2c_client *client,
 	return 0;

 failed_unregister_dev_file:
-	device_remove_file(&client->dev, &bd2802_adv_conf_attr);
+	for (i--; i >= 0; i--)
+		device_remove_file(&led->client->dev, bd2802_attributes[i]);
 failed_free:
 	i2c_set_clientdata(client, NULL);
 	kfree(led);
@@ -692,12 +750,14 @@ failed_free:
 static int __exit bd2802_remove(struct i2c_client *client)
 {
 	struct bd2802_led *led = i2c_get_clientdata(client);
+	int i;

-	bd2802_unregister_led_classdev(led);
 	gpio_set_value(led->pdata->reset_gpio, 0);
+	bd2802_unregister_led_classdev(led);
 	if (led->adf_on)
 		bd2802_disable_adv_conf(led);
-	device_remove_file(&client->dev, &bd2802_adv_conf_attr);
+	for (i = 0; i < ARRAY_SIZE(bd2802_attributes); i++)
+		device_remove_file(&led->client->dev, bd2802_attributes[i]);
 	i2c_set_clientdata(client, NULL);
 	kfree(led);

-- 
1.5.2.5


-- 
Kyuwon (±Ô¿ø)
