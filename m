Return-Path: <linux-kernel-owner+w=401wt.eu-S1765363AbYDOOrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765363AbYDOOrh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 10:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761373AbYDOOrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 10:47:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43468 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759606AbYDOOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 10:47:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, Dmitry Torokhov <dtor@mail.ru>,
       Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] wm97xx-core: Support use as a wakeup source
Date: Tue, 15 Apr 2008 15:47:08 +0100
Message-Id: <1208270828-10413-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208270828-10413-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20080415144535.GA20619@rakim.wolfsonmicro.main>
 <1208270828-10413-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1208270828-10413-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM97xx touch screen controllers can be used to generate a wakeup
event when the system is suspended. Provide a new core API call
wm97xx_set_suspend_mode() allowing machine drivers to enable this. If no
suspend_mode is provided then the touch panel will be powered down when
the system is suspended.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm97xx-core.c |   39 +++++++++++++++++++++++++++++++
 include/linux/wm97xx.h                  |    3 ++
 2 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/wm97xx-core.c b/drivers/input/touchscreen/wm97xx-core.c
index fec07c2..e9c7ea4 100644
--- a/drivers/input/touchscreen/wm97xx-core.c
+++ b/drivers/input/touchscreen/wm97xx-core.c
@@ -262,6 +262,23 @@ void wm97xx_config_gpio(struct wm97xx *wm, u32 gpio, enum wm97xx_gpio_dir dir,
 EXPORT_SYMBOL_GPL(wm97xx_config_gpio);
 
 /*
+ * Configure the WM97XX_PRP value to use while system is suspended.
+ * If a value other than 0 is set then WM97xx pen detection will be
+ * left enabled in the configured mode while the system is in suspend,
+ * the device has users and suspend has not been disabled via the
+ * wakeup sysfs entries.
+ *
+ * @wm:   WM97xx device to configure
+ * @mode: WM97XX_PRP value to configure while suspended
+ */
+void wm97xx_set_suspend_mode(struct wm97xx *wm, u16 mode)
+{
+	wm->suspend_mode = mode;
+	device_init_wakeup(&wm->input_dev->dev, mode != 0);
+}
+EXPORT_SYMBOL_GPL(wm97xx_set_suspend_mode);
+
+/*
  * Handle a pen down interrupt.
  */
 static void wm97xx_pen_irq_worker(struct work_struct *work)
@@ -689,10 +706,32 @@ static int wm97xx_remove(struct device *dev)
 static int wm97xx_suspend(struct device *dev, pm_message_t state)
 {
 	struct wm97xx *wm = dev_get_drvdata(dev);
+	u16 reg;
+	int suspend_mode;
+
+	if (device_may_wakeup(&wm->input_dev->dev))
+		suspend_mode = wm->suspend_mode;
+	else
+		suspend_mode = 0;
 
 	if (wm->input_dev->users)
 		cancel_delayed_work_sync(&wm->ts_reader);
 
+	/* Power down the digitiser (bypassing the cache for resume) */
+	reg = wm97xx_reg_read(wm, AC97_WM97XX_DIGITISER2);
+	reg &= ~WM97XX_PRP_DET_DIG;
+	if (wm->input_dev->users)
+		reg |= suspend_mode;
+	wm->ac97->bus->ops->write(wm->ac97, AC97_WM97XX_DIGITISER2, reg);
+
+	/* WM9713 has an additional power bit - turn it off if there
+	 * are no users or if suspend mode is zero. */
+	if (wm->id == WM9713_ID2 &&
+	    (!wm->input_dev->users || !suspend_mode)) {
+		reg = wm97xx_reg_read(wm, AC97_EXTENDED_MID) | 0x8000;
+		wm97xx_reg_write(wm, AC97_EXTENDED_MID, reg);
+	}
+
 	return 0;
 }
 
diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
index ed01c7d..4d13732 100644
--- a/include/linux/wm97xx.h
+++ b/include/linux/wm97xx.h
@@ -282,6 +282,7 @@ struct wm97xx {
 	unsigned pen_is_down:1;		/* Pen is down */
 	unsigned aux_waiting:1;		/* aux measurement waiting */
 	unsigned pen_probably_down:1;	/* used in polling mode */
+	u16 suspend_mode;               /* PRP in suspend mode */
 };
 
 /*
@@ -297,6 +298,8 @@ void wm97xx_config_gpio(struct wm97xx *wm, u32 gpio,
 				     enum wm97xx_gpio_sticky sticky,
 				     enum wm97xx_gpio_wake wake);
 
+void wm97xx_set_suspend_mode(struct wm97xx *wm, u16 mode);
+
 /* codec AC97 IO access */
 int wm97xx_reg_read(struct wm97xx *wm, u16 reg);
 void wm97xx_reg_write(struct wm97xx *wm, u16 reg, u16 val);
-- 
1.5.5

