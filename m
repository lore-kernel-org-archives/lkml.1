Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbYAOUxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbYAOUxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYAOUuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:40 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56885 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167AbYAOUuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:32 -0500
Message-Id: <20080115205024.485041547@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:23 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>
Subject: [RFC PATCH 16/30 v3] time keeping add cycle_raw for actual incrementation
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

Index: linux-compile.git/include/linux/clocksource.h
===================================================================
--- linux-compile.git.orig/include/linux/clocksource.h	2008-01-14 13:14:13.000000000 -0500
+++ linux-compile.git/include/linux/clocksource.h	2008-01-14 14:57:47.000000000 -0500
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
