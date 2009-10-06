Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbZJFTRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbZJFTRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZJFTRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:17:46 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:53541 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758087AbZJFTRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ITZeNDOO5Opn+WHZPUQpCvPMxs2uHpm3WgOZHmaap9TJtIA6UjuYaK1jQc5xfWunOU
         BsXQv1XRD9jmpFjXdPuKTQPlCPe8NbezIwxQniZTXzI8muokrmWHTDimKq5Iimy1ZY9d
         1ZXFP3ts+H5RqWZs5h+aHEnV4xpmRCASBMKx4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH] perf tools: Start the perf.data mapping at data offset in perf trace
Date: Tue,  6 Oct 2009 21:17:06 +0200
Message-Id: <1254856626-10286-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
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

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-trace.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 5d4c84d..d9abb4a 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -143,12 +143,12 @@ static int __cmd_trace(void)
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
 	unsigned long head = 0;
+	unsigned long shift;
 	struct stat perf_stat;
 	event_t *event;
 	uint32_t size;
 	char *buf;
 
-	trace_report();
 	register_idle_thread(&threads, &last_match);
 
 	input = open(input_name, O_RDONLY);
@@ -180,6 +180,10 @@ static int __cmd_trace(void)
 		return EXIT_FAILURE;
 	}
 
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
 remap:
 	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
 			   MAP_SHARED, input, offset);
@@ -192,9 +196,9 @@ more:
 	event = (event_t *)(buf + head);
 
 	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
 		int res;
 
+		shift = page_size * (head / page_size);
 		res = munmap(buf, page_size * mmap_window);
 		assert(res == 0);
 
-- 
1.6.2.3

