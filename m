Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbYIEVjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbYIEVjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYIEVjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:39:23 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:49884 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYIEVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:39:23 -0400
Date: Fri, 5 Sep 2008 23:46:19 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.27-rc5-mm1 compilation fix with gcc 3.4.6
Message-Id: <20080905234619.2e95ae92.krzysztof.h1@poczta.fm>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: ec0b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

I found that 2.6.27-rc5-mm1 does not compile with gcc 3.4.6.
The error is:
  CC      kernel/sched.o
kernel/sched.c: In function `start_rt_bandwidth':
kernel/sched.c:208: sorry, unimplemented: inlining failed in call to 'rt_bandwidth_enabled': function body not available
kernel/sched.c:214: sorry, unimplemented: called from here
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

It seems that the gcc 3.4.6 requires full inline definition before first usage.
The patch below fixes the compilation problem.

Regards,
Krzysztof

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl> (if needed>

diff -urp linux-ref/kernel/sched.c linux-mm/kernel/sched.c
--- linux-ref/kernel/sched.c	2008-09-05 23:39:02.000000000 +0200
+++ linux-mm/kernel/sched.c	2008-09-05 23:41:12.779563125 +0200
@@ -205,7 +205,10 @@ void init_rt_bandwidth(struct rt_bandwid
 	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
 
-static inline int rt_bandwidth_enabled(void);
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
 
 static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
@@ -844,11 +847,6 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
-static inline int rt_bandwidth_enabled(void)
-{
-	return sysctl_sched_rt_runtime >= 0;
-}
-
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif


----------------------------------------------------------------------
Nie zwlekaj! Tapetuj z nami!
Sprawdz >>  http://link.interia.pl/f1f01

