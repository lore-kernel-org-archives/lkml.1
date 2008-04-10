Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYDJC1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYDJC1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 22:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYDJC1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 22:27:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbYDJC1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 22:27:32 -0400
Date: Wed, 9 Apr 2008 19:27:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: local_softirq_pending()
Message-Id: <20080409192708.7bdbbe9a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
kernel/time/tick-sched.c:229: warning: format '%02x' expects type 'unsigned int', but argument 2 has type '__u64'

I don't think the architecture's local_softirq_pending() should return u64.
This is the sort of thing which should be consistent across architectures.

Problem is, we've made such a complete mess of everything that this is a
bitch to fix.

The obvious and moderately clean fix is:

--- a/include/asm-s390/hardirq.h~a
+++ a/include/asm-s390/hardirq.h
@@ -25,10 +25,24 @@ typedef struct {
 	unsigned int __softirq_pending;
 } irq_cpustat_t;
 
-#define local_softirq_pending() (S390_lowcore.softirq_pending)
+static inline unsigned int local_softirq_pending(void)
+{
+	return S390_lowcore.softirq_pending;
+}
+
+static inline void set_softirq_pending(unsigned int val)
+{
+	S390_lowcore.softirq_pending = val;
+}
+
+static inline void or_softirq_pending(unsigned int val)
+{
+	S390_lowcore.softirq_pending |= val;
+}
 
 #define __ARCH_IRQ_STAT
 #define __ARCH_HAS_DO_SOFTIRQ
+#define __ARCH_SET_SOFTIRQ_PENDING
 
 #define HARDIRQ_BITS	8
 

But that doesn't work because sometimes this 'orrible crap from
linux/interrupt.h:

#ifndef __ARCH_SET_SOFTIRQ_PENDING
#define set_softirq_pending(x) (local_softirq_pending() = (x))
#define or_softirq_pending(x)  (local_softirq_pending() |= (x))
#endif

gets included first, which screws up include/asm-s390/hardirq.h.

So I'll cheerfully drop it into someone else's lap.  A sensible fix would
be to remove that nonsense from linux/interrupt.h (which appears to have
been added for x86) and give each architecture its own
local_softirq_pending(), set_softirq_pending() and or_softirq_pending(). 
Very much preferably for avoiding any ^+#define...


btw, there's a naming inconsistency here.  Shouldn't they be

local_softirq_pending
set_local_softirq_pending
or_local_softirq_pending

?


btw2, why do we need a per-arch or_softirq_pending()?  Can't that just be
built from set_softirq_pending() and local_softirq_pending() in generic code?

