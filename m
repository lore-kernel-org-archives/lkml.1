Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0BUTVX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 14:21:23 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:48024 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547Ab0BUTVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 14:21:22 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAIVgUtbstuO/2dsb2JhbACbDHS5bAyEXwQ
Date: Sun, 21 Feb 2010 20:21:20 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Mike Frysinger <vapier@gentoo.org>
Subject: [WATCHDOG] v2.6.33-rc8 - bfin_wdt.c : fix max timeout calculation
Message-ID: <20100221192120.GC6521@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/bfin_wdt.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

with these Changes:

Author: Mike Frysinger <vapier@gentoo.org>
Date:   Mon Feb 15 19:32:25 2010 -0500

    [WATCHDOG] bfin: fix max timeout calculation
    
    Relying on overflow/wrap around isn't exact because if you wrap far
    enough, you get back to "valid" values.
    
    Reported-by: Thorsten Pohlmann <pohlmann@tetronik.com>
    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
    Cc: stable <stable@kernel.org>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
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
