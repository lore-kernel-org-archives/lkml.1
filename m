Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZG1QB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZG1QB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbZG1QB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:01:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50494 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640AbZG1QB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:01:26 -0400
Date: Tue, 28 Jul 2009 17:55:33 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: p_gortmaker@yahoo.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 7/9] drivers/rtc: correct error-handling code
Message-ID: <Pine.LNX.4.64.0907281755000.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This code is not executed before ds1307->rtc has been successfully
initialized to the result of calling rtc_device_register.  Thus the test
that ds1307->rtc is not NULL is always true.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@match exists@
expression x, E;
statement S1, S2;
@@

x = rtc_device_register(...)
... when != x = E
(
*  if (x == NULL || ...) S1 else S2
|
*  if (x == NULL && ...) S1 else S2
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/rtc/rtc-ds1307.c            |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 47a93c0..eb99ee4 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -896,8 +896,7 @@ read_rtc:
 	return 0;
 
 exit_irq:
-	if (ds1307->rtc)
-		rtc_device_unregister(ds1307->rtc);
+	rtc_device_unregister(ds1307->rtc);
 exit_free:
 	kfree(ds1307);
 	return err;
