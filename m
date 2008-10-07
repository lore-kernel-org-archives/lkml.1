Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbYJGAxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbYJGAxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbYJGAoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:24 -0400
Received: from ns1.suse.de ([195.135.220.2]:46859 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbYJGAoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:22 -0400
Date: Mon, 6 Oct 2008 17:38:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@elte.hu>
Subject: [patch 34/71] rtc: fix deadlock
Message-ID: <20081007003852.GI3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc-fix-deadlock.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ingo Molnar <mingo@elte.hu>

commit 38c052f8cff1bd323ccfa968136a9556652ee420 upstream

if get_rtc_time() is _ever_ called with IRQs off, we deadlock badly
in it, waiting for jiffies to increment.

So make the code more robust by doing an explicit mdelay(20).

This solves a very hard to reproduce/debug hard lockup reported
by Mikael Pettersson.

Reported-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/asm-generic/rtc.h |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/include/asm-generic/rtc.h
+++ b/include/asm-generic/rtc.h
@@ -15,6 +15,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
+#include <linux/delay.h>
 
 #define RTC_PIE 0x40		/* periodic interrupt enable */
 #define RTC_AIE 0x20		/* alarm interrupt enable */
@@ -43,7 +44,6 @@ static inline unsigned char rtc_is_updat
 
 static inline unsigned int get_rtc_time(struct rtc_time *time)
 {
-	unsigned long uip_watchdog = jiffies;
 	unsigned char ctrl;
 	unsigned long flags;
 
@@ -53,19 +53,15 @@ static inline unsigned int get_rtc_time(
 
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

-- 
