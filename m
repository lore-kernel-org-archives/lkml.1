Return-Path: <linux-kernel-owner+w=401wt.eu-S965233AbXCTKJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbXCTKJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965242AbXCTKJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:09:46 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:60561 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965233AbXCTKJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:09:36 -0400
Date: Tue, 20 Mar 2007 11:09:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>
Subject: [PATCH] time : SMP friendly alignment of struct clocksource
Message-Id: <20070320110936.1e445e6e.dada1@cosmosbay.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct clocksource is a critical data structure.

Most of its fields are read only, some of them are heavily modified at each timer interrupt.

It makes sense to separate those fields and make sure they all share one cache line, or at least the minimum for machines with small cache lines.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--- linux-2.6.21-rc4-mm1/include/linux/clocksource.h
+++ linux-2.6.21-rc4-mm1-ed/include/linux/clocksource.h
@@ -49,25 +49,35 @@ struct clocksource;
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
 struct clocksource {
+	/*
+	 * First part of structure is read mostly
+	 */
 	char *name;
 	struct list_head list;
 	int rating;
 	cycle_t (*read)(void);
 	cycle_t mask;
 	u32 mult;
 	u32 shift;
 	unsigned long flags;
 	cycle_t (*vread)(void);
 
 	/* timekeeping specific data, ignore */
-	cycle_t cycle_last, cycle_interval;
-	u64 xtime_nsec, xtime_interval;
+	cycle_t cycle_interval;
+	u64	xtime_interval;
+	/*
+	 * Second part is written at each timer interrupt
+	 * Keep it in a different cache line to dirty no
+	 * more than one cache line.
+	 */
+	cycle_t cycle_last ____cacheline_aligned_in_smp;
+	u64 xtime_nsec;
 	s64 error;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
 	/* Watchdog related data, used by the framework */
 	struct list_head wd_list;
 	cycle_t wd_last;
