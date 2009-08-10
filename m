Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbZHJJh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbZHJJh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZHJJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:37:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:43083 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZHJJhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:37:13 -0400
Date: Mon, 10 Aug 2009 09:36:35 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1249896447.17467.74.camel@twins>
References: <1249896447.17467.74.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Correct PERF_SAMPLE_RAW output
Message-ID: <tip-a044560c3a1f0ad75ce685c1ed7604820b9ed319@git.kernel.org>
Git-Commit-ID: a044560c3a1f0ad75ce685c1ed7604820b9ed319
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 10 Aug 2009 09:36:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a044560c3a1f0ad75ce685c1ed7604820b9ed319
Gitweb:     http://git.kernel.org/tip/a044560c3a1f0ad75ce685c1ed7604820b9ed319
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 10 Aug 2009 11:16:52 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 Aug 2009 11:33:09 +0200

perf_counter: Correct PERF_SAMPLE_RAW output

PERF_SAMPLE_* output switches should unconditionally output the
correct format, as they are the only way to unambiguously parse
the PERF_EVENT_SAMPLE data.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249896447.17467.74.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 ++
 include/trace/ftrace.h       |    3 ++-
 kernel/perf_counter.c        |   30 ++++++++++++++++++++++++------
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 2aabe43..a9d823a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -369,6 +369,8 @@ enum perf_event_type {
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
+	 *	{ u32			size;
+	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
 	 */
 	PERF_EVENT_SAMPLE		= 9,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7fb16d9..7167b9b 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -685,7 +685,8 @@ static void ftrace_profile_##call(proto)				\
 	pc = preempt_count();						\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
-	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
+	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
+			     sizeof(u64));				\
 									\
 	do {								\
 		char raw_data[__entry_size];				\
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 546e62d..5229d16 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2646,7 +2646,6 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
-	struct perf_raw_record *raw = NULL;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2716,9 +2715,15 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
-		raw = data->raw;
-		if (raw)
-			header.size += raw->size;
+		int size = sizeof(u32);
+
+		if (data->raw)
+			size += data->raw->size;
+		else
+			size += sizeof(u32);
+
+		WARN_ON_ONCE(size & (sizeof(u64)-1));
+		header.size += size;
 	}
 
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
@@ -2784,8 +2789,21 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if ((sample_type & PERF_SAMPLE_RAW) && raw)
-		perf_output_copy(&handle, raw->data, raw->size);
+	if (sample_type & PERF_SAMPLE_RAW) {
+		if (data->raw) {
+			perf_output_put(&handle, data->raw->size);
+			perf_output_copy(&handle, data->raw->data, data->raw->size);
+		} else {
+			struct {
+				u32	size;
+				u32	data;
+			} raw = {
+				.size = sizeof(u32),
+				.data = 0,
+			};
+			perf_output_put(&handle, raw);
+		}
+	}
 
 	perf_output_end(&handle);
 }
