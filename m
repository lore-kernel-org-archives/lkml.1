Return-Path: <linux-kernel-owner+w=401wt.eu-S932291AbZJGHc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbZJGHc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 03:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238AbZJGHc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 03:32:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:55380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217AbZJGHc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 03:32:58 -0400
Date: Wed, 7 Oct 2009 07:31:39 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com, efault@gmx.de,
       peterz@infradead.org, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com, peterz@infradead.org,
       efault@gmx.de, fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1254856886-10348-1-git-send-email-fweisbec@gmail.com>
References: <1254856886-10348-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Start the perf.data mapping at data offset in perf trace
Message-ID: <tip-b209aa1f83964d49a332a7b6b818ebede5cdc6ef@git.kernel.org>
Git-Commit-ID: b209aa1f83964d49a332a7b6b818ebede5cdc6ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 07 Oct 2009 07:31:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b209aa1f83964d49a332a7b6b818ebede5cdc6ef
Gitweb:     http://git.kernel.org/tip/b209aa1f83964d49a332a7b6b818ebede5cdc6ef
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 6 Oct 2009 21:21:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Oct 2009 08:36:10 +0200

perf tools: Start the perf.data mapping at data offset in perf trace

Currently, we are mapping perf.data in the beginning of the file
and use the data offset as a buffer offset.

This may exceed the mapping area if the data offset is upper than
page_size * mmap_window and result in a page fault (thing that
happen if we merge trace.info in perf.data).

Instead, let's start the mapping in the page that matches our data
offset.

v2: Drop a junk from another patch (trace_report() removal)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <1254856886-10348-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-trace.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5d4c84d..d573d4e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -143,6 +143,7 @@ static int __cmd_trace(void)
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
 	unsigned long head = 0;
+	unsigned long shift;
 	struct stat perf_stat;
 	event_t *event;
 	uint32_t size;
@@ -180,6 +181,10 @@ static int __cmd_trace(void)
 		return EXIT_FAILURE;
 	}
 
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
 remap:
 	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
 			   MAP_SHARED, input, offset);
@@ -192,9 +197,9 @@ more:
 	event = (event_t *)(buf + head);
 
 	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
 		int res;
 
+		shift = page_size * (head / page_size);
 		res = munmap(buf, page_size * mmap_window);
 		assert(res == 0);
 
