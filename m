Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZHBUGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZHBUGE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:06:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZHBUGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:06:03 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:26871 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbZHBUGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:06:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAFSOdUpR9cHH/2dsb2JhbADQcAmEDwWBSg
Date: Sun, 2 Aug 2009 22:05:58 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [WATCHDOG] v2.6.31-rc5 watchdog fix
Message-ID: <20090802200558.GS30892@infomag.iguana.be>
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

 drivers/watchdog/coh901327_wdt.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

with these Changes:

Author: Linus Walleij <linus.walleij@stericsson.com>
Date:   Tue Jul 21 00:40:46 2009 +0200

    [WATCHDOG] Fix COH 901 327 watchdog enablement
    
    Since the COH 901 327 found in U300 is clocked at 32 kHz we need
    to wait for the interrupt clearing flag to propagate through
    hardware in order not to accidentally fire off any interrupts
    when we enable them.
    
    Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index fecb307..aec7cef 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -18,6 +18,7 @@
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 
 #define DRV_NAME "WDOG COH 901 327"
 
@@ -92,6 +93,8 @@ static struct clk *clk;
 static void coh901327_enable(u16 timeout)
 {
 	u16 val;
+	unsigned long freq;
+	unsigned long delay_ns;
 
 	clk_enable(clk);
 	/* Restart timer if it is disabled */
@@ -102,6 +105,14 @@ static void coh901327_enable(u16 timeout)
 	/* Acknowledge any pending interrupt so it doesn't just fire off */
 	writew(U300_WDOG_IER_WILL_BARK_IRQ_ACK_ENABLE,
 	       virtbase + U300_WDOG_IER);
+	/*
+	 * The interrupt is cleared in the 32 kHz clock domain.
+	 * Wait 3 32 kHz cycles for it to take effect
+	 */
+	freq = clk_get_rate(clk);
+	delay_ns = (1000000000 + freq - 1) / freq; /* Freq to ns and round up */
+	delay_ns = 3 * delay_ns; /* Wait 3 cycles */
+	ndelay(delay_ns);
 	/* Enable the watchdog interrupt */
 	writew(U300_WDOG_IMR_WILL_BARK_IRQ_ENABLE, virtbase + U300_WDOG_IMR);
 	/* Activate the watchdog timer */
