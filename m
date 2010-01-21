Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467Ab0AUPj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab0AUPj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303Ab0AUPjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:39:25 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:59263 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752311Ab0AUPjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:39:25 -0500
Subject: [PATCH] kernel/timekeeping:  move xtime_cache to be in the same
 cache line as the lock
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jan 2010 15:39:21 +0000
Message-ID: <1264088361.2082.45.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move xtime_cache to be in the same cache line as the lock
    
allowing current_kernel_time() to access only one cache line

when running fio write tests on a 2 core machine, on some of the runs
'perf record -e cache_misses' shows current_kernel_time near the top of
the list of cache_misses with 5.5%.
On the other runs it's down at 0.05% so I'm assuming that the difference
is just down to which core the test client get run on.

This patch moves the xtime_cache variable near to the lock so that it
only need to access one cache line.
With this applied it drops the current_kernel_time cache_misses in the
slow case to 4.5%

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>


---
patch against v2.6.33-rc4
compiled & tested on AMD64X2 x86_64


BTW on 64 bit timespec is a 16 byte structure so the aligned 16 doesn't
do much, and on 32bit timepec is 8bytes so this just seems to spread
these variables across more cache lines than necessary. Any ideas what
this is here for?

regards
Richard  



diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 7faaa32..657e861 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -137,6 +137,7 @@ static inline s64 timekeeping_get_ns_raw(void)
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
+static struct timespec xtime_cache __attribute__ ((aligned (16)));
 
 /*
  * The current time
@@ -165,7 +166,6 @@ struct timespec raw_time;
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
 
-static struct timespec xtime_cache __attribute__ ((aligned (16)));
 void update_xtime_cache(u64 nsec)
 {
 	xtime_cache = xtime;


