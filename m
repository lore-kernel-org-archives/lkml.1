Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbZHETYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbZHETYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 15:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZHETYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 15:24:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:51389 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893AbZHETYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 15:24:00 -0400
Subject: [PATCH] perf: Don't list tracepoints without an id
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Chris Mason <chris.mason@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>
In-Reply-To: <1249497664.5890.4.camel@laptop>
References: <1249497664.5890.4.camel@laptop>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 21:23:49 +0200
Message-Id: <1249500229.5890.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop perf list from displaying tracepoints without an id file.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/util/parse-events.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7bdad8d..d00636b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -568,6 +568,7 @@ static void print_tracepoint_events(void)
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
 	struct stat st;
 	char evt_path[MAXPATHLEN];
+	int fd;
 
 	if (valid_debugfs_mount(debugfs_path))
 		return;
@@ -582,6 +583,15 @@ static void print_tracepoint_events(void)
 			goto cleanup;
 		for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next,
 								evt_path, st) {
+
+			snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id",
+					debugfs_path, 
+					sys_dirent.d_name, evt_dirent.d_name);
+			fd = open(evt_path, O_RDONLY);
+			if (fd < 0)
+				continue;
+			close(fd);
+
 			snprintf(evt_path, MAXPATHLEN, "%s:%s",
 				 sys_dirent.d_name, evt_dirent.d_name);
 			fprintf(stderr, "  %-40s [%s]\n", evt_path,


