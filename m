Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbZJFTWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbZJFTWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932403AbZJFTWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:22:07 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:55422 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZJFTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=yDdWNviNik6INC48EvPqWvwKCz/Zce0cRNM1u3c47mdcRJzV2S3AL8HG2hH1prDaYV
         6letwWuuWkvfyv42xM+4S4P11ad4FGeuKkUJF5tzN72lEoR4ETEb+Jh1/tZrfxO1U0vt
         o+UuDttXJz3hIhoe/mM+lpnll49Ijey2DJ7jA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH v2] perf tools: Start the perf.data mapping at data offset in perf trace
Date: Tue,  6 Oct 2009 21:21:26 +0200
Message-Id: <1254856886-10348-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1254856626-10286-1-git-send-email-fweisbec@gmail.com>
References: <1254856626-10286-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we are mapping perf.data in the beginning of the file
and use the data offset as a buffer offset. This may exceed the
mapping area if the data offset is upper than page_size * mmap_window
and result in a page fault (thing that happen if we merge trace.info
in perf.data).

Instead, let's start the mapping in the page that matches our data
offset.

v2: Drop a junk from another patch (trace_report() removal)

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
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
 
-- 
1.6.2.3

