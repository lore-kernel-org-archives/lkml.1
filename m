Return-Path: <linux-kernel-owner+w=401wt.eu-S1764390AbXKTSiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764390AbXKTSiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762129AbXKTS2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:28:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52076 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762126AbXKTS2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:28:17 -0500
Date: Tue, 20 Nov 2007 10:25:02 -0800
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
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 26/29] softlockup: use cpu_clock() instead of sched_clock()
Message-ID: <20071120182502.GB28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="softlockup-use-cpu_clock-instead-of-sched_clock.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Ingo Molnar <mingo@elte.hu>

patch a3b13c23f186ecb57204580cc1f2dbe9c284953a in mainline.

sched_clock() is not a reliable time-source, use cpu_clock() instead.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/softlockup.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -43,14 +43,16 @@ static struct notifier_block panic_block
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(void)
+static unsigned long get_timestamp(int this_cpu)
 {
-	return sched_clock() >> 30;  /* 2^30 ~= 10^9 */
+	return cpu_clock(this_cpu) >> 30;  /* 2^30 ~= 10^9 */
 }
 
 void touch_softlockup_watchdog(void)
 {
-	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
+	int this_cpu = raw_smp_processor_id();
+
+	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -96,7 +98,7 @@ void softlockup_tick(void)
 		return;
 	}
 
-	now = get_timestamp();
+	now = get_timestamp(this_cpu);
 
 	/* Wake up the high-prio watchdog task every second: */
 	if (now > (touch_timestamp + 1))

-- 
