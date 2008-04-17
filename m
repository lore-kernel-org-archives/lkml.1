Return-Path: <linux-kernel-owner+w=401wt.eu-S1765645AbYDQBQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765645AbYDQBQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753709AbYDQBHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:07:44 -0400
Received: from sous-sol.org ([216.99.217.87]:58868 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757637AbYDQBHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:07:40 -0400
Message-Id: <20080417010205.251905099@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:23 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Segher Boessenkool <segher@kernel.crashing.org>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sedat Dilek <sedat.dilek@googlemail.com>
Subject: time: prevent the loop in timespec_add_ns() from being optimised away
Content-Disposition: inline; filename=time-prevent-the-loop-in-timespec_add_ns-from-being-optimised-away.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Segher Boessenkool <segher@kernel.crashing.org>

upstream commit: 38332cb98772f5ea757e6486bed7ed0381cb5f98

Since some architectures don't support __udivdi3().

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc:  Sedat Dilek <sedat.dilek@googlemail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/time.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -173,6 +173,10 @@ static inline void timespec_add_ns(struc
 {
 	ns += a->tv_nsec;
 	while(unlikely(ns >= NSEC_PER_SEC)) {
+		/* The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation.  */
+		asm("" : "+r"(ns));
+
 		ns -= NSEC_PER_SEC;
 		a->tv_sec++;
 	}

-- 
