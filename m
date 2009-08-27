Return-Path: <linux-kernel-owner+w=401wt.eu-S1751728AbZH0ITO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbZH0ITO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 04:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZH0ITO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 04:19:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:54388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbZH0ITM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 04:19:12 -0400
Subject: [PATCH] perf: remove PERF_SAMPLE_RAW
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 27 Aug 2009 10:17:53 +0200
Message-Id: <1251361073.18584.46.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems I forgot lkml...

---
Apparently people think trace-events became an ABI the moment perf
exported them, regardless what the text surrounding PERF_SAMPLE_RAW said
about the opaqueness of the data provided.

I'm not willing to make anything trace related into an ABI, hence remove
this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |   17 +----------------
 kernel/perf_counter.c        |   36 ------------------------------------
 2 files changed, 1 insertions(+), 52 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 972f90d..1056676 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -121,9 +121,8 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
-	PERF_SAMPLE_RAW				= 1U << 10,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 10,		/* non-ABI */
 };
 
 /*
@@ -383,20 +382,6 @@ enum perf_event_type {
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
-	 *
-	 * 	#
-	 * 	# The RAW record below is opaque data wrt the ABI
-	 * 	#
-	 * 	# That is, the ABI doesn't make any promises wrt to
-	 * 	# the stability of its content, it may vary depending
-	 * 	# on event, hardware, kernel version and phase of
-	 * 	# the moon.
-	 * 	#
-	 * 	# In other words, PERF_SAMPLE_RAW contents are not an ABI.
-	 * 	#
-	 *
-	 *	{ u32			size;
-	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
 	 */
 	PERF_EVENT_SAMPLE		= 9,
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 53abcbe..e72ba84 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2935,18 +2935,6 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 			header.size += sizeof(u64);
 	}
 
-	if (sample_type & PERF_SAMPLE_RAW) {
-		int size = sizeof(u32);
-
-		if (data->raw)
-			size += data->raw->size;
-		else
-			size += sizeof(u32);
-
-		WARN_ON_ONCE(size & (sizeof(u64)-1));
-		header.size += size;
-	}
-
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
 	if (ret)
 		return;
@@ -2992,22 +2980,6 @@ void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if (sample_type & PERF_SAMPLE_RAW) {
-		if (data->raw) {
-			perf_output_put(&handle, data->raw->size);
-			perf_output_copy(&handle, data->raw->data, data->raw->size);
-		} else {
-			struct {
-				u32	size;
-				u32	data;
-			} raw = {
-				.size = sizeof(u32),
-				.data = 0,
-			};
-			perf_output_put(&handle, raw);
-		}
-	}
-
 	perf_output_end(&handle);
 }
 
@@ -3966,14 +3938,6 @@ static void tp_perf_counter_destroy(struct perf_counter *counter)
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
-	/*
-	 * Raw tracepoint data is a severe data leak, only allow root to
-	 * have these.
-	 */
-	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
-			!capable(CAP_SYS_ADMIN))
-		return ERR_PTR(-EPERM);
-
 	if (ftrace_profile_enable(counter->attr.config))
 		return NULL;
 

