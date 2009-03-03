Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZCCIbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZCCIbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 03:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZCCIau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 03:30:50 -0500
Received: from cathcart.site5.com ([74.54.107.137]:36661 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZCCIat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 03:30:49 -0500
Message-ID: <49ACEAB5.6040404@compulab.co.il>
Date: Tue, 03 Mar 2009 10:30:45 +0200
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.16 (X11/20080907)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: dmitry.torokhov@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       linux-input <linux-input@vger.kernel.org>
Subject: Re: [PATCH RESEND] Input: wm97xx: add BTN_TOUCH event to wm97xx to
 use it with Android
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

Mark,

Mark Brown wrote:
> On Mon, Mar 02, 2009 at 06:16:55PM +0200, Mike Rapoport wrote:
> 
>> Most touchscreen drivers already have BTN_TOUCH event generation:
> 
> Hrm, I'd found some other hits but I could well have been working on a
> platform tree with additional drivers merged at the time.
> 
>> If there no objection I can make a similar patch for mainstone-wm97xx.c and ucb1400_ts.c
> 
> No problem for me.  Please see the other two accelerated WM97xx drivers
> I posted today too.

The below patch adds BTN_TOUCH event reporting for two accelerated drivers
you've posted yesterday [1] and [2]. This patch is incremental vs. the first spin.


[1] http://lkml.org/lkml/2009/3/2/49
[2] http://lkml.org/lkml/2009/3/2/50

Signed-off-by: Mike Rapoport <mike@compulab.co.il>

 drivers/input/touchscreen/at32-wm97xx.c     |    6 ++++++
 drivers/input/touchscreen/zylonite-wm97xx.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/at32-wm97xx.c b/drivers/input/touchscreen/at32-wm97xx.c
index 96eeb2d..e34edcd 100644
--- a/drivers/input/touchscreen/at32-wm97xx.c
+++ b/drivers/input/touchscreen/at32-wm97xx.c
@@ -145,11 +145,15 @@ static irqreturn_t at32_wm97xx_channel_b_interrupt(int irq, void *dev_id)
 			input_report_abs(wm->input_dev, ABS_X, at32_wm97xx->x);
 			input_report_abs(wm->input_dev, ABS_Y, at32_wm97xx->y);
 			input_report_abs(wm->input_dev, ABS_PRESSURE, pen_down);
+			input_report_key(wm->input_dev, BTN_TOUCH,
+					 (pen_down != 0));
 			input_sync(wm->input_dev);
 		} else if (pressure && source == WM97XX_ADCSEL_PRES) {
 			input_report_abs(wm->input_dev, ABS_X, at32_wm97xx->x);
 			input_report_abs(wm->input_dev, ABS_Y, at32_wm97xx->y);
 			input_report_abs(wm->input_dev, ABS_PRESSURE, value);
+			input_report_key(wm->input_dev, BTN_TOUCH,
+					 (value != 0));
 			input_sync(wm->input_dev);
 		}

@@ -170,6 +174,7 @@ static void at32_wm97xx_pen_timer(unsigned long data)
 				+ msecs_to_jiffies(1));
 	} else {
 		input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
+		input_report_key(wm->input_dev, BTN_TOUCH, 0);
 		input_sync(wm->input_dev);
 	}
 }
@@ -184,6 +189,7 @@ static void at32_wm97xx_acc_pen_up(struct wm97xx *wm)
 				+ msecs_to_jiffies(1));
 	} else {
 		input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
+		input_report_key(wm->input_dev, BTN_TOUCH, 0);
 		input_sync(wm->input_dev);
 	}
 }
diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
index b016021..609c23c 100644
--- a/drivers/input/touchscreen/zylonite-wm97xx.c
+++ b/drivers/input/touchscreen/zylonite-wm97xx.c
@@ -130,6 +130,7 @@ static int wm97xx_acc_pen_down(struct wm97xx *wm)
 		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
 		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
 		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
+		input_report_key(wm->input_dev, BTN_TOUCH, (p != 0));
 		input_sync(wm->input_dev);
 		reads++;
 	} while (reads < cinfo[sp_idx].reads);


-- 
Sincerely yours,
Mike.



