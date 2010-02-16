Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab0BPAc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 19:32:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46161 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab0BPAcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 19:32:25 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] [WATCHDOG] bfin: fix max timeout calculation
Date: Mon, 15 Feb 2010 19:32:25 -0500
Message-Id: <1266280345-18597-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relying on overflow/wrap around isn't exact because if you wrap far
enough, you get back to "valid" values.

Reported-by: Thorsten Pohlmann <pohlmann@tetronik.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/watchdog/bfin_wdt.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/watchdog/bfin_wdt.c b/drivers/watchdog/bfin_wdt.c
index c7b3f9d..2159e66 100644
--- a/drivers/watchdog/bfin_wdt.c
+++ b/drivers/watchdog/bfin_wdt.c
@@ -1,9 +1,8 @@
 /*
  * Blackfin On-Chip Watchdog Driver
- *  Supports BF53[123]/BF53[467]/BF54[2489]/BF561
  *
  * Originally based on softdog.c
- * Copyright 2006-2007 Analog Devices Inc.
+ * Copyright 2006-2010 Analog Devices Inc.
  * Copyright 2006-2007 Michele d'Amico
  * Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>
  *
@@ -137,13 +136,15 @@ static int bfin_wdt_running(void)
  */
 static int bfin_wdt_set_timeout(unsigned long t)
 {
-	u32 cnt;
+	u32 cnt, max_t, sclk;
 	unsigned long flags;
 
-	stampit();
+	sclk = get_sclk();
+	max_t = -1 / sclk;
+	cnt = t * sclk;
+	stamp("maxtimeout=%us newtimeout=%lus (cnt=%#x)", max_t, t, cnt);
 
-	cnt = t * get_sclk();
-	if (cnt < get_sclk()) {
+	if (t > max_t) {
 		printk(KERN_WARNING PFX "timeout value is too large\n");
 		return -EINVAL;
 	}
-- 
1.7.0

