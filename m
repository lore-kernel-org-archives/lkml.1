Return-Path: <linux-kernel-owner+w=401wt.eu-S1761434AbZGIQxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434AbZGIQxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 12:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760971AbZGIQxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 12:53:12 -0400
Received: from av11-1-sn2.hy.skanova.net ([81.228.8.183]:38662 "EHLO
	av11-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760852AbZGIQxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 12:53:11 -0400
Message-ID: <4A562073.1080703@mocean-labs.com>
Date: Thu, 09 Jul 2009 18:53:07 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1b3pre) Gecko/20090223 Thunderbird/3.0b2
MIME-Version: 1.0
To: linux-input@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, kwangwoo.lee@gmail.com,
       Thierry Reding <thierry.reding@avionic-design.de>,
       soni.trilok@gmail.com
Subject: [PATCH 1/1] tsc2007: Cancel work sync, increase polling frequency,
 make exit platform hw callback optional
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the remove function, ancel the work using the _sync version,
to make sure any running "work" is finished. Make the
exit_platform_hw callback optional since it's not needed on all
platforms.

When the screen is touched, the polling frequency is increased
to reduce the risk of missing taps.

Signed-off-by: Richard Röjfors <richard.rojfors.ext@mocean-labs.com>
---
Index: linux-2.6.30/drivers/input/touchscreen/tsc2007.c
===================================================================
--- linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 945)
+++ linux-2.6.30/drivers/input/touchscreen/tsc2007.c	(revision 999)
@@ -27,7 +27,7 @@
  #include <linux/i2c.h>
  #include <linux/i2c/tsc2007.h>

-#define TS_POLL_PERIOD	msecs_to_jiffies(5) /* ms delay between samples */
+#define TS_POLL_PERIOD	msecs_to_jiffies(1) /* ms delay between samples */

  #define TSC2007_MEASURE_TEMP0		(0x0 << 4)
  #define TSC2007_MEASURE_AUX		(0x2 << 4)
@@ -332,11 +332,11 @@
  	struct tsc2007	*ts = i2c_get_clientdata(client);
  	struct tsc2007_platform_data *pdata;

-	/* cancel any work */
-	cancel_delayed_work(&ts->work);
+	cancel_delayed_work_sync(&ts->work);

  	pdata = client->dev.platform_data;
-	pdata->exit_platform_hw();
+	if (pdata->exit_platform_hw)
+		pdata->exit_platform_hw();

  	free_irq(ts->irq, ts);
  	input_unregister_device(ts->input);
