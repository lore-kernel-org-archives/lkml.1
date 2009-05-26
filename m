Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbZEZTXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbZEZTXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756992AbZEZTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:23:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:38576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689AbZEZTXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:23:04 -0400
Date: Tue, 26 May 2009 19:21:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: More robust error handling
Message-ID: <tip-6142f9ec108a4ddbf0d5904c3daa5fdcaa618792@git.kernel.org>
Git-Commit-ID: 6142f9ec108a4ddbf0d5904c3daa5fdcaa618792
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 19:21:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6142f9ec108a4ddbf0d5904c3daa5fdcaa618792
Gitweb:     http://git.kernel.org/tip/6142f9ec108a4ddbf0d5904c3daa5fdcaa618792
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 26 May 2009 20:51:47 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 20:17:46 +0200

perf report: More robust error handling

Don't let funny events confuse us, stick to what we know and
try to find sensible data again.

If we find an unknown event, check we're still u64 aligned, and
increment by one u64. This ensures we're bound to happen upon a
valid event soon.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 2d4e4cc..a58be7f 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -645,6 +645,7 @@ static int __cmd_report(void)
 	char *buf;
 	event_t *event;
 	int ret, rc = EXIT_FAILURE;
+	uint32_t size;
 	unsigned long total = 0, total_mmap = 0, total_comm = 0, total_unknown = 0;
 
 	input = open(input_name, O_RDONLY);
@@ -680,6 +681,10 @@ remap:
 more:
 	event = (event_t *)(buf + head);
 
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
 	if (head + event->header.size >= page_size * mmap_window) {
 		unsigned long shift = page_size * (head / page_size);
 		int ret;
@@ -692,12 +697,9 @@ more:
 		goto remap;
 	}
 
-
-	if (!event->header.size) {
-		fprintf(stderr, "zero-sized event at file offset %ld\n", offset + head);
-		fprintf(stderr, "skipping %ld bytes of events.\n", stat.st_size - offset - head);
-		goto done;
-	}
+	size = event->header.size;
+	if (!size)
+		goto broken_event;
 
 	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
 		char level;
@@ -787,15 +789,26 @@ more:
 		break;
 	}
 	default: {
+broken_event:
 		fprintf(stderr, "%p [%p]: skipping unknown header type: %d\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->header.type);
 		total_unknown++;
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
 	}
 	}
 
-	head += event->header.size;
+	head += size;
 
 	if (offset + head < stat.st_size)
 		goto more;
