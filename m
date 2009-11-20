Return-Path: <linux-kernel-owner+w=401wt.eu-S1758299AbZKTDhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299AbZKTDhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 22:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758243AbZKTDhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 22:37:15 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51687 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbZKTDhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 22:37:15 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf bench: Make mem/memcpy more friendly
Date: Fri, 20 Nov 2009 12:37:17 +0900
Message-Id: <1258688237-3797-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091119072252.GA11452@elte.hu>
References: <20091119072252.GA11452@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mem-memcpy.c uses perf event system calls to obtain CPU clocks.
And it suddenly dies with BUG_ON() when it running on Linux
doesn't support perf event.

Also fail at calloc() can occur easily when too large
length is passed. Fail of calloc() causes sudden death
with assert().

These behaviours are not friendly. So I fixed the treat of error.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/bench/mem-memcpy.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index d4f4f98..1252d42 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -67,6 +67,11 @@ static struct perf_event_attr clock_attr = {
 static void init_clock(void)
 {
 	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
+	if (clock_fd < 0 && errno == ENOSYS) {
+		fprintf(stderr, "! Your Linux doesn't support perf events!\n");
+		fprintf(stderr, "! Measuring clock is impossible. Aborting.\n");
+		exit(1);
+	}
 	BUG_ON(clock_fd < 0);
 }
 
@@ -124,9 +129,17 @@ int bench_mem_memcpy(int argc, const char **argv,
 	}
 
 	dst = calloc(length, sizeof(char));
-	assert(dst);
+	if (!dst) {
+		fprintf(stderr, "Allocating memory failed.\n");
+		fprintf(stderr, "Maybe length is too large.\n");
+		exit(1);
+	}
 	src = calloc(length, sizeof(char));
-	assert(src);
+	if (!src) {
+		fprintf(stderr, "Allocating memory failed.\n");
+		fprintf(stderr, "Maybe length is too large.\n");
+		exit(1);
+	}
 
 	if (bench_format == BENCH_FORMAT_DEFAULT) {
 		printf("# Copying %s Bytes from %p to %p ...\n\n",
-- 
1.6.5.2

