Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbXKMQJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbXKMQJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbXKMQJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:09:30 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:39750 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758195AbXKMQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:09:29 -0500
Date: Tue, 13 Nov 2007 17:09:25 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: John Stultz <johnstul@us.ibm.com>,
       "Adrian 'Trivial' Bunk" <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] time: Fold __get_realtime_clock_ts() into getnstimeofday()
Message-ID: <Pine.LNX.4.62.0711131708010.4700@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-2056758017-1194970165=:4700"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-2056758017-1194970165=:4700
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

time: Fold __get_realtime_clock_ts() into getnstimeofday():
  - getnstimeofday() was just a wrapper around __get_realtime_clock_ts()
  - Replace calls to __get_realtime_clock_ts() by calls to getnstimeofday()
  - Fix bogus reference to get_realtime_clock_ts(), which never existed

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
The bogus reference is what made me do this in the first place...

 kernel/time/timekeeping.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -82,13 +82,12 @@ static inline s64 __get_nsec_offset(void
 }
 
 /**
- * __get_realtime_clock_ts - Returns the time of day in a timespec
+ * getnstimeofday - Returns the time of day in a timespec
  * @ts:		pointer to the timespec to be set
  *
- * Returns the time of day in a timespec. Used by
- * do_gettimeofday() and get_realtime_clock_ts().
+ * Returns the time of day in a timespec.
  */
-static inline void __get_realtime_clock_ts(struct timespec *ts)
+void getnstimeofday(struct timespec *ts)
 {
 	unsigned long seq;
 	s64 nsecs;
@@ -104,30 +103,19 @@ static inline void __get_realtime_clock_
 	timespec_add_ns(ts, nsecs);
 }
 
-/**
- * getnstimeofday - Returns the time of day in a timespec
- * @ts:		pointer to the timespec to be set
- *
- * Returns the time of day in a timespec.
- */
-void getnstimeofday(struct timespec *ts)
-{
-	__get_realtime_clock_ts(ts);
-}
-
 EXPORT_SYMBOL(getnstimeofday);
 
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
- * NOTE: Users should be converted to using get_realtime_clock_ts()
+ * NOTE: Users should be converted to using getnstimeofday()
  */
 void do_gettimeofday(struct timeval *tv)
 {
 	struct timespec now;
 
-	__get_realtime_clock_ts(&now);
+	getnstimeofday(&now);
 	tv->tv_sec = now.tv_sec;
 	tv->tv_usec = now.tv_nsec/1000;
 }

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Network and Software Technology Center Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584337861-2056758017-1194970165=:4700--
