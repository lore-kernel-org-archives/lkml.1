Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366Ab0CMAa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:30:56 -0500
Received: from kroah.org ([198.145.64.141]:46578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935286Ab0CMAaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:30 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:05 2010
Message-Id: <20100313002705.575203876@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mike Frysinger <vapier@gentoo.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [004/145] [WATCHDOG] bfin: fix max timeout calculation
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Mike Frysinger <vapier@gentoo.org>

commit 3dae93ec3ee1fceec69f40ef9b97892ce62ba7a5 upstream.

Relying on overflow/wrap around isn't exact because if you wrap far
enough, you get back to "valid" values.

Reported-by: Thorsten Pohlmann <pohlmann@tetronik.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/bfin_wdt.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

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


