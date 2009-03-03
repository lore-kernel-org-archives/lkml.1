Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbZCCSZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbZCCSZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZCCSYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:24:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50246 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752918AbZCCSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:24:48 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Rapoport <mike@compulab.co.il>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] Input: add BTN_TOUCH event
Date: Tue,  3 Mar 2009 18:24:41 +0000
Message-Id: <1236104684-30214-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236104684-30214-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20090303182402.GA29542@rakim.wolfsonmicro.main>
 <1236104684-30214-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Rapoport <mike@compulab.co.il>

Add BTN_TOUCH event reporting to ucb1400_ts and accelerated mainstone-wm97xx
touchscreen drivers. Together with previously posted similar patch for
wm97xx-core this will make all touchscreen drivers behave consistently wrt.
BTN_TOUCH.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/mainstone-wm97xx.c |    1 +
 drivers/input/touchscreen/ucb1400_ts.c       |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 1d11e2b..4d49690 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -162,6 +162,7 @@ static int wm97xx_acc_pen_down(struct wm97xx *wm)
 		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
 		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
 		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
+		input_report_key(wm->input_dev, BTN_TOUCH, (p != 0));
 		input_sync(wm->input_dev);
 		reads++;
 	} while (reads < cinfo[sp_idx].reads);
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 5498662..e868264 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -151,12 +151,14 @@ static void ucb1400_ts_evt_add(struct input_dev *idev, u16 pressure, u16 x, u16
 	input_report_abs(idev, ABS_X, x);
 	input_report_abs(idev, ABS_Y, y);
 	input_report_abs(idev, ABS_PRESSURE, pressure);
+	input_report_key(idev, BTN_TOUCH, 1);
 	input_sync(idev);
 }
 
 static void ucb1400_ts_event_release(struct input_dev *idev)
 {
 	input_report_abs(idev, ABS_PRESSURE, 0);
+	input_report_key(idev, BTN_TOUCH, 0);
 	input_sync(idev);
 }
 
@@ -377,7 +379,8 @@ static int ucb1400_ts_probe(struct platform_device *dev)
 	ucb->ts_idev->id.product	= ucb->id;
 	ucb->ts_idev->open		= ucb1400_ts_open;
 	ucb->ts_idev->close		= ucb1400_ts_close;
-	ucb->ts_idev->evbit[0]		= BIT_MASK(EV_ABS);
+	ucb->ts_idev->evbit[0]		= BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+	ucb->ts_idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	ucb1400_adc_enable(ucb->ac97);
 	x_res = ucb1400_ts_read_xres(ucb);
-- 
1.6.1.3

