Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZDGJKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZDGJKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZDGJI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:08:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:47041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbZDGJIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:08:54 -0400
Date: Tue, 7 Apr 2009 09:08:13 GMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090406094518.024173282@chello.nl>
References: <20090406094518.024173282@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: PERF_RECORD_TIME
Message-ID: <tip-339f7c90b8a2f3aa2dd4267e79f797999e8a3c59@git.kernel.org>
Git-Commit-ID: 339f7c90b8a2f3aa2dd4267e79f797999e8a3c59
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 07 Apr 2009 09:08:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  339f7c90b8a2f3aa2dd4267e79f797999e8a3c59
Gitweb:     http://git.kernel.org/tip/339f7c90b8a2f3aa2dd4267e79f797999e8a3c59
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Apr 2009 11:45:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 10:48:57 +0200

perf_counter: PERF_RECORD_TIME

By popular request, provide means to log a timestamp along with the
counter overflow event.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
LKML-Reference: <20090406094518.024173282@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 kernel/perf_counter.c        |   14 ++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index ca2d4df..928a7fa 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -102,6 +102,7 @@ enum perf_counter_record_format {
 	PERF_RECORD_TID		= 1U << 1,
 	PERF_RECORD_GROUP	= 1U << 2,
 	PERF_RECORD_CALLCHAIN	= 1U << 3,
+	PERF_RECORD_TIME	= 1U << 4,
 };
 
 /*
@@ -221,6 +222,7 @@ enum perf_event_type {
 	__PERF_EVENT_TID		= PERF_RECORD_TID,
 	__PERF_EVENT_GROUP		= PERF_RECORD_GROUP,
 	__PERF_EVENT_CALLCHAIN		= PERF_RECORD_CALLCHAIN,
+	__PERF_EVENT_TIME		= PERF_RECORD_TIME,
 };
 
 #ifdef __KERNEL__
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index c841563..19990d1 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1826,6 +1826,7 @@ static void perf_counter_output(struct perf_counter *counter,
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
 	int callchain_size = 0;
+	u64 time;
 
 	header.type = PERF_EVENT_COUNTER_OVERFLOW;
 	header.size = sizeof(header);
@@ -1862,6 +1863,16 @@ static void perf_counter_output(struct perf_counter *counter,
 		}
 	}
 
+	if (record_type & PERF_RECORD_TIME) {
+		/*
+		 * Maybe do better on x86 and provide cpu_clock_nmi()
+		 */
+		time = sched_clock();
+
+		header.type |= __PERF_EVENT_TIME;
+		header.size += sizeof(u64);
+	}
+
 	ret = perf_output_begin(&handle, counter, header.size, nmi);
 	if (ret)
 		return;
@@ -1895,6 +1906,9 @@ static void perf_counter_output(struct perf_counter *counter,
 	if (callchain)
 		perf_output_copy(&handle, callchain, callchain_size);
 
+	if (record_type & PERF_RECORD_TIME)
+		perf_output_put(&handle, time);
+
 	perf_output_end(&handle);
 }
 
