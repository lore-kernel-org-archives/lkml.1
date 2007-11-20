Return-Path: <linux-kernel-owner+w=401wt.eu-S1764200AbXKTSgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764200AbXKTSgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760999AbXKTS2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:28:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52055 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761395AbXKTS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:28:05 -0500
Date: Tue, 20 Nov 2007 10:24:52 -0800
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
Subject: [patch 23/29] ntp: fix typo that makes sync_cmos_clock erratic
Message-ID: <20071120182452.GY28611@kroah.com>
References: <20071120181733.702234406@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ntp-fix-sync-cmos-clock-typo.patch"
In-Reply-To: <20071120182248.GA28611@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David P. Reed <dpreed@reed.com>

patch fa6a1a554b50cbb7763f6907e6fef927ead480d9 in mainline.

ntp: fix typo that makes sync_cmos_clock erratic

Fix a typo in ntp.c that has caused updating of the persistent (RTC)
clock when synced to NTP to behave erratically.

When debugging a freeze that arises on my AMD64 machines when I
run the ntpd service, I added a number of printk's to monitor the
sync_cmos_clock procedure.  I discovered that it was not syncing to
cmos RTC every 11 minutes as documented, but instead would keep trying
every second for hours at a time.  The reason turned out to be a typo
in sync_cmos_clock, where it attempts to ensure that
update_persistent_clock is called very close to 500 msec. after a 1
second boundary (required by the PC RTC's spec). That typo referred to
"xtime" in one spot, rather than "now", which is derived from "xtime"
but not equal to it.  This makes the test erratic, creating a
"coin-flip" that decides when update_persistent_clock is called - when
it is called, which is rarely, it may be at any time during the one
second period, rather than close to 500 msec, so the value written is
needlessly incorrect, too.

Signed-off-by: David P. Reed <dpreed@reed.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/time/ntp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -205,7 +205,7 @@ static void sync_cmos_clock(unsigned lon
 		return;
 
 	getnstimeofday(&now);
-	if (abs(xtime.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
+	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
 
 	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;

-- 
