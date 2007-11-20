Return-Path: <linux-kernel-owner+w=401wt.eu-S1764263AbXKTSg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764263AbXKTSg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761216AbXKTS2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:28:11 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52064 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762100AbXKTS2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:28:09 -0500
Date: Tue, 20 Nov 2007 10:24:55 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David P. Reed" <dpreed@reed.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 24/29] x86: fix freeze in x86_64 RTC update code in
	time_64.c
Message-ID: <20071120182455.GZ28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-rtc-locking.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David P. Reed <dpreed@reed.com>

patch c399da0d97e06803e51085ec076b63a3168aad1b in mainline.

x86: fix freeze in x86_64 RTC update code in time_64.c

Fix hard freeze on x86_64 when the ntpd service calls
update_persistent_clock()

A repeatable but randomly timed freeze has been happening in Fedora 6
and 7 for the last year, whenever I run the ntpd service on my AMD64x2
HP Pavilion dv9000z laptop.  This freeze is due to the use of
spin_lock(&rtc_lock) under the assumption (per a bad comment) that
set_rtc_mmss is called only with interrupts disabled.  The call from
ntp.c to update_persistent_clock is made with interrupts enabled.

[ tglx@linutronix.de: ported to 2.6.23.stable ]

Signed-off-by: David P. Reed <dpreed@reed.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86_64/kernel/time.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/arch/x86_64/kernel/time.c
+++ b/arch/x86_64/kernel/time.c
@@ -87,18 +87,15 @@ static int set_rtc_mmss(unsigned long no
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
 	unsigned char control, freq_select;
+	unsigned long flags;
 
 /*
- * IRQs are disabled when we're called from the timer interrupt,
- * no need for spin_lock_irqsave()
+ * set_rtc_mmss is called when irqs are enabled, so disable irqs here
  */
-
-	spin_lock(&rtc_lock);
-
+	spin_lock_irqsave(&rtc_lock, flags);
 /*
  * Tell the clock it's being set and stop it.
  */
-
 	control = CMOS_READ(RTC_CONTROL);
 	CMOS_WRITE(control | RTC_SET, RTC_CONTROL);
 
@@ -143,7 +140,7 @@ static int set_rtc_mmss(unsigned long no
 	CMOS_WRITE(control, RTC_CONTROL);
 	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
 
-	spin_unlock(&rtc_lock);
+	spin_unlock_irqrestore(&rtc_lock, flags);
 
 	return retval;
 }

-- 
