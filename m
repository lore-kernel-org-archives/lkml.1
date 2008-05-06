Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbYEFWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbYEFWcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYEFWcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:32:21 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61816 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751589AbYEFWcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:32:20 -0400
Date: Tue, 6 May 2008 23:31:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH] RTC: rtc_time_to_tm: use unsigned arithmetic
Message-ID: <Pine.LNX.4.55.0805062315530.16173@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The input argument to rtc_time_to_tm() is unsigned as well as are members
of the output structure.  However signed arithmetic is used within for
calculations leading to incorrect results for input values outside the
signed positive range.  If this happens the time of day returned is out of
range.

 Found the problem when fiddling with the RTC and the driver where year
was set to an unexpectedly large value like 2070, e.g.:

rtc0: setting system clock to 2070-01-01 1193046:71582832:26 UTC (3155760954)

while it should be:

rtc0: setting system clock to 2070-01-01 00:15:54 UTC (3155760954)

Changing types to unsigned fixes the problem.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested on 64-bit MIPS.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-rtc-time-unsigned-11
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-lib.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-lib.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-lib.c	2007-07-10 04:56:26.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-lib.c	2008-05-05 02:37:38.000000000 +0000
@@ -51,7 +51,7 @@ EXPORT_SYMBOL(rtc_year_days);
  */
 void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 {
-	register int days, month, year;
+	register unsigned int days, month, year;
 
 	days = time / 86400;
 	time -= days * 86400;
