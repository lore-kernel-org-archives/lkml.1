Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbXEBGhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbXEBGhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 02:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXEBGhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 02:37:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:51879 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S2992826AbXEBGhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 02:37:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Tg11QSgHTS2nf7ceHhzu+ZHTGCz0pW4Ci2RfmIq
	29YngznzmPfUGT
Subject: Re: [patch] CFS scheduler, -v8
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>, Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20070501212223.GA29867@elte.hu>
References: <20070501212223.GA29867@elte.hu>
Content-Type: text/plain; charset=iso-8859-7
Date: Wed, 02 May 2007 08:37:14 +0200
Message-Id: <1178087834.8640.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 23:22 +0200, Ingo Molnar wrote:
> i'm pleased to announce release -v8 of the CFS scheduler patchset. (The 
> main goal of CFS is to implement "desktop scheduling" with as high 
> quality as technically possible.)
...

> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome,

Greetings,

I noticed a (harmless) bounds warning triggered by the reduction in size
of array->bitmap.  Patchlet below.

	-Mike

  CC      kernel/sched.o
kernel/sched_rt.c: In function ¡load_balance_start_rt¢:
include/asm-generic/bitops/sched.h:30: warning: array subscript is above array bounds
kernel/sched_rt.c: In function ¡pick_next_task_rt¢:
include/asm-generic/bitops/sched.h:30: warning: array subscript is above array bounds

--- linux-2.6.21-cfs.v8/include/asm-generic/bitops/sched.h.org	2007-05-02 07:16:47.000000000 +0200
+++ linux-2.6.21-cfs.v8/include/asm-generic/bitops/sched.h	2007-05-02 07:20:45.000000000 +0200
@@ -6,28 +6,23 @@
 
 /*
  * Every architecture must define this function. It's the fastest
- * way of searching a 140-bit bitmap where the first 100 bits are
- * unlikely to be set. It's guaranteed that at least one of the 140
- * bits is cleared.
+ * way of searching a 100-bit bitmap.  It's guaranteed that at least
+ * one of the 100 bits is cleared.
  */
 static inline int sched_find_first_bit(const unsigned long *b)
 {
 #if BITS_PER_LONG == 64
-	if (unlikely(b[0]))
+	if (b[0])
 		return __ffs(b[0]);
-	if (likely(b[1]))
-		return __ffs(b[1]) + 64;
-	return __ffs(b[2]) + 128;
+	return __ffs(b[1]) + 64;
 #elif BITS_PER_LONG == 32
-	if (unlikely(b[0]))
+	if (b[0])
 		return __ffs(b[0]);
-	if (unlikely(b[1]))
+	if (b[1])
 		return __ffs(b[1]) + 32;
-	if (unlikely(b[2]))
+	if (b[2])
 		return __ffs(b[2]) + 64;
-	if (b[3])
-		return __ffs(b[3]) + 96;
-	return __ffs(b[4]) + 128;
+	return __ffs(b[3]) + 96;
 #else
 #error BITS_PER_LONG not defined
 #endif


