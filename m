Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYAIXco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYAIXco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYAIXaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:30:55 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:33558 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbYAIXav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:51 -0500
Message-Id: <20080109233044.465775048@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: [RFC PATCH 14/22 -v2] time keeping add cycle_raw for actual incrementation
Content-Disposition: inline; filename=timekeeping-add-cycle-raw-for-actual-incrementation.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The get_monotonic_cycles needs to produce a monotonic counter as output.

This patch adds a cycle_raw to produce an accumulative counter.
Unfortunately there is already an cycle_accumulate variable, but that is
used to avoid clock source overflow and can also be decremented
(probably that name should be changed and we should use that for this
patch).


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: John Stultz <johnstul@us.ibm.com>

---
 include/linux/clocksource.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-compile-i386.git/include/linux/clocksource.h
===================================================================
--- linux-compile-i386.git.orig/include/linux/clocksource.h	2008-01-09 14:23:29.000000000 -0500
+++ linux-compile-i386.git/include/linux/clocksource.h	2008-01-09 15:17:31.000000000 -0500
@@ -87,7 +87,7 @@ struct clocksource {
 	 * more than one cache line.
 	 */
 	struct {
-		cycle_t cycle_last, cycle_accumulated;
+		cycle_t cycle_last, cycle_accumulated, cycle_raw;
 	} ____cacheline_aligned_in_smp;
 
 	u64 xtime_nsec;
@@ -204,6 +204,7 @@ static inline void clocksource_accumulat
 	cycle_t offset = (now - cs->cycle_last) & cs->mask;
 	cs->cycle_last = now;
 	cs->cycle_accumulated += offset;
+	cs->cycle_raw += offset;
 }
 
 /**

-- 
