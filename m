Return-Path: <linux-kernel-owner+w=401wt.eu-S1759657AbZLOSnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759657AbZLOSnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759399AbZLOSnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:43:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:59969 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339AbZLOSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:43:17 -0500
Subject: [PATCH] perf: fix perf_event_attr layout -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1260902179.8023.767.camel@laptop>
References: <1260902179.8023.767.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 19:43:11 +0100
Message-ID: <1260902591.8023.781.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-15 at 19:36 +0100, Peter Zijlstra wrote:
> [now with lkml added too]

compile tested...

> 
> The miss-alignment of bp_addr created a 32bit hole, causing different
> structure packings on 32 and 64 bit machines.
> 
> Fix that by moving __reserve_2 into that hole.
> 
> Further, remove the useless struct and redundant __bp_reserve muck.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |   12 +++---------
 kernel/perf_event.c        |    2 +-
 2 files changed, 4 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
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
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4564,7 +4564,7 @@ static int perf_copy_attr(struct perf_ev
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1 || attr->__reserved_2 || attr->__reserved_3)
+	if (attr->__reserved_1 || attr->__reserved_2)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))


