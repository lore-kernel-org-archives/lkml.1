Return-Path: <linux-kernel-owner+w=401wt.eu-S1756237AbYHYRwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbYHYRwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYHYRwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:52:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47968 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753551AbYHYRwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:52:42 -0400
Date: Mon, 25 Aug 2008 19:52:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] timer fixes
Message-ID: <20080825175226.GA9892@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      rtc: fix deadlock


 include/asm-generic/rtc.h |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/rtc.h b/include/asm-generic/rtc.h
index be4af00..71ef3f0 100644
--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -15,6 +15,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
+#include <linux/delay.h>
 
 #define RTC_PIE 0x40		/* periodic interrupt enable */
 #define RTC_AIE 0x20		/* alarm interrupt enable */
@@ -43,7 +44,6 @@ static inline unsigned char rtc_is_updating(void)
 
 static inline unsigned int get_rtc_time(struct rtc_time *time)
 {
-	unsigned long uip_watchdog = jiffies;
 	unsigned char ctrl;
 	unsigned long flags;
 
@@ -53,19 +53,15 @@ static inline unsigned int get_rtc_time(struct rtc_time *time)
 
 	/*
 	 * read RTC once any update in progress is done. The update
-	 * can take just over 2ms. We wait 10 to 20ms. There is no need to
+	 * can take just over 2ms. We wait 20ms. There is no need to
 	 * to poll-wait (up to 1s - eeccch) for the falling edge of RTC_UIP.
 	 * If you need to know *exactly* when a second has started, enable
 	 * periodic update complete interrupts, (via ioctl) and then 
 	 * immediately read /dev/rtc which will block until you get the IRQ.
 	 * Once the read clears, read the RTC time (again via ioctl). Easy.
 	 */
-
-	if (rtc_is_updating() != 0)
-		while (jiffies - uip_watchdog < 2*HZ/100) {
-			barrier();
-			cpu_relax();
-		}
+	if (rtc_is_updating())
+		mdelay(20);
 
 	/*
 	 * Only the values that we read from the RTC are set. We leave
