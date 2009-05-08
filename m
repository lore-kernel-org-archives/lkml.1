Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbZEHSlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbZEHSlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761556AbZEHSkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:40:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:54688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763721AbZEHSkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:40:35 -0400
Date: Fri, 8 May 2009 18:39:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090508170028.923228280@chello.nl>
References: <20090508170028.923228280@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: add PERF_RECORD_CONFIG
Message-ID: <tip-a85f61abe11a46553c4562e74edb27ebc782aeb7@git.kernel.org>
Git-Commit-ID: a85f61abe11a46553c4562e74edb27ebc782aeb7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 18:39:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a85f61abe11a46553c4562e74edb27ebc782aeb7
Gitweb:     http://git.kernel.org/tip/a85f61abe11a46553c4562e74edb27ebc782aeb7
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 8 May 2009 18:52:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 8 May 2009 20:36:58 +0200

perf_counter: add PERF_RECORD_CONFIG

Much like CONFIG_RECORD_GROUP records the hw_event.config to
identify the values, allow to record this for all counters.

[ Impact: extend perfcounter output record format ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090508170028.923228280@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 88f863e..0e6303d 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -104,6 +104,7 @@ enum perf_counter_record_format {
 	PERF_RECORD_ADDR	= 1U << 3,
 	PERF_RECORD_GROUP	= 1U << 4,
 	PERF_RECORD_CALLCHAIN	= 1U << 5,
+	PERF_RECORD_CONFIG	= 1U << 6,
 };
 
 /*
@@ -258,6 +259,7 @@ enum perf_event_type {
 	 * 	{ u32			pid, tid; } && PERF_RECORD_TID
 	 * 	{ u64			time;     } && PERF_RECORD_TIME
 	 * 	{ u64			addr;     } && PERF_RECORD_ADDR
+	 * 	{ u64			config;   } && PERF_RECORD_CONFIG
 	 *
 	 * 	{ u64			nr;
 	 * 	  { u64 event, val; } 	cnt[nr];  } && PERF_RECORD_GROUP
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index f4883f1..c615f52 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1994,6 +1994,11 @@ static void perf_counter_output(struct perf_counter *counter,
 		header.size += sizeof(u64);
 	}
 
+	if (record_type & PERF_RECORD_CONFIG) {
+		header.type |= PERF_RECORD_CONFIG;
+		header.size += sizeof(u64);
+	}
+
 	if (record_type & PERF_RECORD_GROUP) {
 		header.type |= PERF_RECORD_GROUP;
 		header.size += sizeof(u64) +
@@ -2029,6 +2034,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (record_type & PERF_RECORD_ADDR)
 		perf_output_put(&handle, addr);
 
+	if (record_type & PERF_RECORD_CONFIG)
+		perf_output_put(&handle, counter->hw_event.config);
+
 	/*
 	 * XXX PERF_RECORD_GROUP vs inherited counters seems difficult.
 	 */
