Return-Path: <linux-kernel-owner+w=401wt.eu-S1764314AbYEMU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764314AbYEMU0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbYEMURG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:17:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:38705 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761411AbYEMURB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:17:01 -0400
Date: Tue, 13 May 2008 13:12:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Subject: [patch 36/37] rtc: rtc_time_to_tm: use unsigned arithmetic
Message-ID: <20080513201253.GK31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc-rtc_time_to_tm-use-unsigned-arithmetic.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Maciej W. Rozycki <macro@linux-mips.org>

commit 945185a69daa457c4c5e46e47f4afad7dcea734f upstream
Date: Mon, 12 May 2008 14:02:24 -0700
Subject: [patch 36/37] rtc: rtc_time_to_tm: use unsigned arithmetic

The input argument to rtc_time_to_tm() is unsigned as well as are members of
the output structure.  However signed arithmetic is used within for
calculations leading to incorrect results for input values outside the signed
positive range.  If this happens the time of day returned is out of range.

Found the problem when fiddling with the RTC and the driver where year was set
to an unexpectedly large value like 2070, e.g.:

rtc0: setting system clock to 2070-01-01 1193046:71582832:26 UTC (3155760954)

while it should be:

rtc0: setting system clock to 2070-01-01 00:15:54 UTC (3155760954)

Changing types to unsigned fixes the problem.

[akpm@linux-foundation.org: remove old-fashioned `register' keyword]
Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(rtc_year_days);
  */
 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-	register int days, month, year;
+	unsigned int days, month, year;
 
 	days = time / 86400;
 	time -= days * 86400;

-- 
