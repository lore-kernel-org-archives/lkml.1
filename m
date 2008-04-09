Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYDIIra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYDIIra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYDIIrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:47:01 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:42345 "HELO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752766AbYDIIrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:47:00 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-7.tower-164.messagelabs.com!1207730817!3023732!3
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.21]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds: automatically request trigger module
Date: Wed,  9 Apr 2008 10:46:31 +0200
Message-Id: <1207730791-31326-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Apr 2008 08:46:32.0160 (UTC) FILETIME=[35C10E00:01C89A1E]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-5.000.1023-15838.005
X-TM-AS-Result: No--9.761000-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows:
	lala:/sys/class/leds/porta6# cat trigger
	[none] heartbeat
	lala:/sys/class/leds/porta6# echo timer > trigger
	lala:/sys/class/leds/porta6# cat trigger
	none heartbeat [timer]

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
---
Hello,

this change is convenient but I'm not sure if it adds policy to the
kernel.

What do you think about requesting ("ledtrig-%s", trigger_name)?  Maybe
better use something like ("ledtrigger:%s", trigger_name)?  This looks
better IMHO, but you would need to add module aliases to the trigger
modules.

Best regards
Uwe

 drivers/leds/led-triggers.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index 13c9026..26cfeae 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -51,6 +51,8 @@ ssize_t led_trigger_store(struct device *dev, struct device_attribute *attr,
 		return count;
 	}
 
+	request_module("ledtrig-%s", trigger_name);
+
 	down_read(&triggers_list_lock);
 	list_for_each_entry(trig, &trigger_list, next_trig) {
 		if (!strcmp(trigger_name, trig->name)) {
@@ -146,6 +148,8 @@ void led_trigger_set_default(struct led_classdev *led_cdev)
 	if (!led_cdev->default_trigger)
 		return;
 
+	request_module("ledtrig-%s", led_cdev->default_trigger);
+
 	down_read(&triggers_list_lock);
 	down_write(&led_cdev->trigger_lock);
 	list_for_each_entry(trig, &trigger_list, next_trig) {
-- 
1.5.4.5

