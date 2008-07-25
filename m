Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbYGYRxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbYGYRxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 13:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYGYRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 13:52:50 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:43319 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbYGYRwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 13:52:49 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 1/1] Char: ds1286, eliminate busy waiting
Date: Fri, 25 Jul 2008 19:49:58 +0200
Message-Id: <1217008198-17143-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ds1286_get_time(); is not called from atomic context, sleep for 20 ms is
better choice than a (home-made) busy waiting for such a situation.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 drivers/char/ds1286.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ds1286.c b/drivers/char/ds1286.c
index fb58493..5329d48 100644
--- a/drivers/char/ds1286.c
+++ b/drivers/char/ds1286.c
@@ -443,7 +443,6 @@ static void ds1286_get_time(struct rtc_time *rtc_tm)
 {
 	unsigned char save_control;
 	unsigned long flags;
-	unsigned long uip_watchdog = jiffies;
 
 	/*
 	 * read RTC once any update in progress is done. The update
@@ -456,8 +455,7 @@ static void ds1286_get_time(struct rtc_time *rtc_tm)
 	 */
 
 	if (ds1286_is_updating() != 0)
-		while (time_before(jiffies, uip_watchdog + 2*HZ/100))
-			barrier();
+		msleep(20);
 
 	/*
 	 * Only the values that we read from the RTC are set. We leave
-- 
1.5.6.2

