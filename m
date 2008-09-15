Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYIOS1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYIOS1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYIOS06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:26:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbYIOS05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:26:57 -0400
Subject: [PATCH] sched_clock: fix jiffie fallback clock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Sep 2008 20:26:19 +0200
Message-Id: <1221503179.7154.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


David pointed out that the default sched_clock() fallback is broken in that it
wraps too soon. Fix this by using the 64 bit jiffie value so that we're large 
enough to overflow properly.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: David Howells <dhowells@redhat.com>
---
 arch/x86/kernel/tsc.c |    6 ++----
 kernel/sched_clock.c  |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c	2008-09-15 18:41:26.000000000 +0200
+++ linux-2.6/arch/x86/kernel/tsc.c	2008-09-15 18:41:33.000000000 +0200
@@ -46,10 +46,8 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achive it. )
 	 */
-	if (unlikely(tsc_disabled)) {
-		/* No locking but a rare wrong value is not a big deal: */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
-	}
+	if (unlikely(tsc_disabled))
+		return (get_jiffies_64() - INITIAL_JIFFIES) * (NSEC_PER_SEC/HZ);
 
 	/* read the Time Stamp Counter: */
 	rdtscll(this_offset);
Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c	2008-09-15 18:41:26.000000000 +0200
+++ linux-2.6/kernel/sched_clock.c	2008-09-15 18:41:33.000000000 +0200
@@ -38,7 +38,7 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
+	return (get_jiffies_64() - INITIAL_JIFFIES) * (NSEC_PER_SEC/HZ);
 }
 
 static __read_mostly int sched_clock_running;


