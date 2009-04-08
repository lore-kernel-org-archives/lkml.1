Return-Path: <linux-kernel-owner+w=401wt.eu-S934411AbZDHRL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934411AbZDHRL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934644AbZDHRKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:10:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:57488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934614AbZDHRKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:10:31 -0400
Date: Wed, 8 Apr 2009 17:09:55 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090408130409.307926436@chello.nl>
References: <20090408130409.307926436@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: move PERF_RECORD_TIME
Message-ID: <tip-4d855457d84b819fefcd1cd1b0a2a0a0ec475c07@git.kernel.org>
Git-Commit-ID: 4d855457d84b819fefcd1cd1b0a2a0a0ec475c07
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 17:09:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d855457d84b819fefcd1cd1b0a2a0a0ec475c07
Gitweb:     http://git.kernel.org/tip/4d855457d84b819fefcd1cd1b0a2a0a0ec475c07
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Apr 2009 15:01:32 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 19:05:55 +0200

perf_counter: move PERF_RECORD_TIME

Move PERF_RECORD_TIME so that all the fixed length items come before
the variable length ones.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090408130409.307926436@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    9 ++++-----
 kernel/perf_counter.c        |   26 +++++++++++++-------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a70a55f..8bd1be5 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -100,9 +100,9 @@ enum sw_event_ids {
 enum perf_counter_record_format {
 	PERF_RECORD_IP		= 1U << 0,
 	PERF_RECORD_TID		= 1U << 1,
-	PERF_RECORD_GROUP	= 1U << 2,
-	PERF_RECORD_CALLCHAIN	= 1U << 3,
-	PERF_RECORD_TIME	= 1U << 4,
+	PERF_RECORD_TIME	= 1U << 2,
+	PERF_RECORD_GROUP	= 1U << 3,
+	PERF_RECORD_CALLCHAIN	= 1U << 4,
 };
 
 /*
@@ -250,6 +250,7 @@ enum perf_event_type {
 	 *
 	 * 	{ u64			ip;	  } && PERF_RECORD_IP
 	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
+	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 *
 	 * 	{ u64			nr;
 	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
@@ -259,8 +260,6 @@ enum perf_event_type {
 	 * 				kernel,
 	 * 				user;
 	 * 	  u64			ips[nr];  } && PERF_RECORD_CALLCHAIN
-	 *
-	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 * };
 	 */
 };
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 2d4aebb..4dc8600 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1850,6 +1850,16 @@ static void perf_counter_output(struct perf_counter *counter,
 		header.size += sizeof(tid_entry);
 	}
 
+	if (record_type & PERF_RECORD_TIME) {
+		/*
+		 * Maybe do better on x86 and provide cpu_clock_nmi()
+		 */
+		time = sched_clock();
+
+		header.type |= PERF_RECORD_TIME;
+		header.size += sizeof(u64);
+	}
+
 	if (record_type & PERF_RECORD_GROUP) {
 		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
@@ -1867,16 +1877,6 @@ static void perf_counter_output(struct perf_counter *counter,
 		}
 	}
 
-	if (record_type & PERF_RECORD_TIME) {
-		/*
-		 * Maybe do better on x86 and provide cpu_clock_nmi()
-		 */
-		time = sched_clock();
-
-		header.type |= PERF_RECORD_TIME;
-		header.size += sizeof(u64);
-	}
-
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
 	if (ret)
 		return;
@@ -1889,6 +1889,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (record_type & PERF_RECORD_TID)
 		perf_output_put(&handle, tid_entry);
 
+	if (record_type & PERF_RECORD_TIME)
+		perf_output_put(&handle, time);
+
 	if (record_type & PERF_RECORD_GROUP) {
 		struct perf_counter *leader, *sub;
 		u64 nr = counter->nr_siblings;
@@ -1910,9 +1913,6 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (callchain)
 		perf_output_copy(&handle, callchain, callchain_size);
 
-	if (record_type & PERF_RECORD_TIME)
-		perf_output_put(&handle, time);
-
 	perf_output_end(&handle);
 }
 
