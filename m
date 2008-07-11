Return-Path: <linux-kernel-owner+w=401wt.eu-S1761172AbYGKNwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761172AbYGKNwo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYGKNsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:48:08 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34987 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759411AbYGKNr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:56 -0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 18/30] W1: ds1wm.c msleep for reset
Date: Fri, 11 Jul 2008 17:51:33 +0400
Message-Id: <1215784306270-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the previous w1_io.c reset coments and msleep patch, I don't have
the hardware to verify the change, but I think it is safe.  It also
helps to see a comment like this in the code.
"We'll wait a bit longer just to be sure."
If they are going to calculate delaying 324.9us, but actually delay
500us, why not just give up the CPU and sleep?  This is designed for a
battery powered ARM system, avoiding busywaiting has to be good for
battery life.

I sent a request for testers March 7, 2008 to the Linux kernel mailing
list and two developers who have patches for ds1wm.c, but I didn't get
any respons.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds1wm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index ea894bf..29e144f 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -160,8 +160,10 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
 	 *
 	 * We'll wait a bit longer just to be sure.
+	 * Was udelay(500), but if it is going to busywait the cpu that long,
+	 * might as well come back later.
 	 */
-	udelay(500);
+	msleep(1);
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
-- 
1.4.4.4

