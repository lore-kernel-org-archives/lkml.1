Return-Path: <linux-kernel-owner+w=401wt.eu-S933440AbZLOTZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbZLOTZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 14:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933377AbZLOTZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 14:25:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:35901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbZLOTZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 14:25:29 -0500
Date: Tue, 15 Dec 2009 19:24:34 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1260902591.8023.781.camel@laptop>
References: <1260902591.8023.781.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix perf_event_attr layout
Message-ID: <tip-f13c12c634e124d5d31f912b969d542a016d6105@git.kernel.org>
Git-Commit-ID: f13c12c634e124d5d31f912b969d542a016d6105
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f13c12c634e124d5d31f912b969d542a016d6105
Gitweb:     http://git.kernel.org/tip/f13c12c634e124d5d31f912b969d542a016d6105
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 15 Dec 2009 19:43:11 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:12:20 +0100

perf_events: Fix perf_event_attr layout

The miss-alignment of bp_addr created a 32bit hole, causing
different structure packings on 32 and 64 bit machines.

Fix that by moving __reserve_2 into that hole.

Further, remove the useless struct and redundant __bp_reserve
muck.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1260902591.8023.781.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |   12 +++---------
 kernel/perf_event.c        |    2 +-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 64a53f7..5fcbf7d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -211,17 +211,11 @@ struct perf_event_attr {
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
 
-	struct { /* Hardware breakpoint info */
-		__u64		bp_addr;
-		__u32		bp_type;
-		__u32		bp_len;
-		__u64		__bp_reserved_1;
-		__u64		__bp_reserved_2;
-	};
-
 	__u32			__reserved_2;
 
-	__u64			__reserved_3;
+	__u64			bp_addr;
+	__u32			bp_type;
+	__u32			bp_len;
 };
 
 /*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8823b08..0dd8e5d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4564,7 +4564,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1 || attr->__reserved_2 || attr->__reserved_3)
+	if (attr->__reserved_1 || attr->__reserved_2)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
