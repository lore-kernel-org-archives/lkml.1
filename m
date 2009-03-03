Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZCCI2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZCCI2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:28:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZCCI2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:28:00 -0500
Received: from cathcart.site5.com ([74.54.107.137]:36502 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbZCCI17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:27:59 -0500
Message-ID: <49ACEA0A.7040906@compulab.co.il>
Date: Tue, 03 Mar 2009 10:27:54 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: dmitry.torokhov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Subject: [PATCH] Input: add BTN_TOUCH event (Was: [PATCH RESEND] Input: wm97xx:
 add BTN_TOUCH event to wm97xx)
References: <49ABE938.8040502@compulab.co.il> <20090302142838.GA23342@rakim.wolfsonmicro.main> <49AC0677.7040102@compulab.co.il> <20090302162151.GA24717@rakim.wolfsonmicro.main>
In-Reply-To: <20090302162151.GA24717@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Mon, Mar 02, 2009 at 06:16:55PM +0200, Mike Rapoport wrote:
> 
>> Most touchscreen drivers already have BTN_TOUCH event generation:
> 
> Hrm, I'd found some other hits but I could well have been working on a
> platform tree with additional drivers merged at the time.
> 
>> If there no objection I can make a similar patch for mainstone-wm97xx.c and ucb1400_ts.c

Add BTN_TOUCH event reporting to ucb1400_ts and accelerated mainstone-wm97xx
touchscreen drivers. Together with previously posted similar patch for
wm97xx-core this will make all touchscreen drivers behave consistently wrt.
BTN_TOUCH.


Signed-off-by: Mike Rapoport <mike@compulab.co.il>

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
Sincerely yours,
Mike.



