Return-Path: <linux-kernel-owner+w=401wt.eu-S1757293AbZFJFnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293AbZFJFnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755843AbZFJFmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:42:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZFJFmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:42:51 -0400
Message-Id: <20090610054253.289173082@goodmis.org>
References: <20090610054206.510574695@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 01:42:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 03/11] tracing: convert lockdep lock_acquired trace point to use nsec2usec tag
Content-Disposition: inline; filename=0003-tracing-convert-lockdep-lock_acquired-trace-point-to.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The current conversion of the nsec value in the lockstat lock event
is performed in the fast path. Now that there is a tag to do the conversion
we can move this into the slow path and increase performance while tracing.

This patch also fixes a typo in the tag name.

[ Impact: increase performance in lockstat tracing and tag typo fix ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/events/lockdep.h |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/include/trace/events/lockdep.h b/include/trace/events/lockdep.h
index f9d74c8..4251f17 100644
--- a/include/trace/events/lockdep.h
+++ b/include/trace/events/lockdep.h
@@ -74,15 +74,13 @@ TRACE_EVENT(lock_acquired,
 
 	TP_STRUCT__entry(
 		__string(name, lock->name)
-		__field(unsigned long, wait_usec)
-		__field(unsigned long, wait_nsec_rem)
+		__field(long long, wait_nsec)
 	),
 	TP_fast_assign(
 		__assign_str(name, lock->name);
-		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
-		__entry->wait_usec = (unsigned long) waittime;
+		__entry->wait_nsec = waittime;
 	),
-	TP_FORMAT("<sting:name> (<uint:wait_usec>.<printf:wait_nsec_rem:03lu> us)")
+	TP_FORMAT("<string:name> (<nsec2usec:3:wait_nsec> us)")
 );
 
 #endif
-- 
1.6.3.1

-- 
