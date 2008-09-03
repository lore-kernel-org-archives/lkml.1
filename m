Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYICRiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYICRiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYICRhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:37:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:55916 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756603AbYICRhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:37:53 -0400
Date: Wed, 3 Sep 2008 10:25:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Jan Altenberg <jan.altenberg@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>,
       Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Subject: [patch 17/42] rtc_time_to_tm: fix signed/unsigned arithmetic
Message-ID: <20080903172552.GR7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtc_time_to_tm-fix-signed-unsigned-arithmetic.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Altenberg <jan.altenberg@linutronix.de>

commit 73442daf2ea85e2a779396b76b1a39b10188ecb5 upstream

commit 945185a69daa457c4c5e46e47f4afad7dcea734f ("rtc: rtc_time_to_tm: use
unsigned arithmetic") changed the some types in rtc_time_to_tm() to
unsigned:

 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-       register int days, month, year;
+       unsigned int days, month, year;

This doesn't work for all cases, because days is checked for < 0 later
on:

if (days < 0) {
	year -= 1;
	days += 365 + LEAP_YEAR(year);
}

I think the correct fix would be to keep days signed and do an appropriate
cast later on.

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/rtc-lib.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -51,10 +51,11 @@ EXPORT_SYMBOL(rtc_year_days);
  */
 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-	unsigned int days, month, year;
+	unsigned int month, year;
+	int days;
 
 	days = time / 86400;
-	time -= days * 86400;
+	time -= (unsigned int) days * 86400;
 
 	/* day of the week, 1970-01-01 was a Thursday */
 	tm->tm_wday = (days + 4) % 7;

-- 
