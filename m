Return-Path: <linux-kernel-owner+w=401wt.eu-S935191AbXEIElS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935191AbXEIElS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 00:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935008AbXEIElG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 00:41:06 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:42635 "EHLO
	asav11.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934941AbXEIElF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 00:41:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuE6AI3sQEZKhRO4W2dsb2JhbACBXI4VHQ0FEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ucb1x00 - do not access input_dev->private directly
Date: Wed, 9 May 2007 00:40:58 -0400
User-Agent: KMail/1.9.3
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu, rmk@arm.linux.org.uk,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705090040.59124.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use input_get_drvdata() and input_set_drvdata() helpers to do that.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 ... Not tested - no hardware ...

 drivers/mfd/ucb1x00-ts.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

Index: work/drivers/mfd/ucb1x00-ts.c
===================================================================
--- work.orig/drivers/mfd/ucb1x00-ts.c
+++ work/drivers/mfd/ucb1x00-ts.c
@@ -300,7 +300,7 @@ static void ucb1x00_ts_irq(int idx, void
 
 static int ucb1x00_ts_open(struct input_dev *idev)
 {
-	struct ucb1x00_ts *ts = idev->private;
+	struct ucb1x00_ts *ts = input_get_drvdata(idev);
 	int ret = 0;
 
 	BUG_ON(ts->rtask);
@@ -337,7 +337,7 @@ static int ucb1x00_ts_open(struct input_
  */
 static void ucb1x00_ts_close(struct input_dev *idev)
 {
-	struct ucb1x00_ts *ts = idev->private;
+	struct ucb1x00_ts *ts = input_get_drvdata(idev);
 
 	if (ts->rtask)
 		kthread_stop(ts->rtask);
@@ -389,7 +389,6 @@ static int ucb1x00_ts_add(struct ucb1x00
 	ts->idev = idev;
 	ts->adcsync = adcsync ? UCB_SYNC : UCB_NOSYNC;
 
-	idev->private    = ts;
 	idev->name       = "Touchscreen panel";
 	idev->id.product = ts->ucb->id;
 	idev->open       = ucb1x00_ts_open;
@@ -400,6 +399,8 @@ static int ucb1x00_ts_add(struct ucb1x00
 	__set_bit(ABS_Y, idev->absbit);
 	__set_bit(ABS_PRESSURE, idev->absbit);
 
+	input_set_drvdata(idev, ts);
+
 	err = input_register_device(idev);
 	if (err)
 		goto fail;
