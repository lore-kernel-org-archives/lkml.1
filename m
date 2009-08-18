Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbZHRPWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbZHRPWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759235AbZHRPWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:22:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:54369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759229AbZHRPWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:22:33 -0400
Date: Tue, 18 Aug 2009 15:21:54 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1250607843-7395-1-git-send-email-fweisbec@gmail.com>
References: <1250607843-7395-1-git-send-email-fweisbec@gmail.com>
Subject: [tip:perfcounters/core] perf tools: Save partial non-overlapping map
Message-ID: <tip-6e086437f35ad9fda448711732c4ce0f82aad569@git.kernel.org>
Git-Commit-ID: 6e086437f35ad9fda448711732c4ce0f82aad569
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 18 Aug 2009 15:21:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e086437f35ad9fda448711732c4ce0f82aad569
Gitweb:     http://git.kernel.org/tip/6e086437f35ad9fda448711732c4ce0f82aad569
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 18 Aug 2009 17:04:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 Aug 2009 17:18:03 +0200

perf tools: Save partial non-overlapping map

The librarization of the thread helpers between annotate and
report lost some perf report specifics.

thread__insert_map() had its most uptodate version in perf
report which cared about partial map overlapping. In case of
overlap between two maps, perf annotate's version removes the
whole old map without considering if it partially or
absolutely overlaps the new map.

We exported the odd version, change it by using the perf
report version.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <1250607843-7395-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/thread.c |   25 ++++++++++++++++++++++---
 1 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 00c14b9..f98032c 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -4,6 +4,7 @@
 #include <string.h>
 #include "thread.h"
 #include "util.h"
+#include "debug.h"
 
 static struct thread *thread__new(pid_t pid)
 {
@@ -85,9 +86,27 @@ void thread__insert_map(struct thread *self, struct map *map)
 
 	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
 		if (map__overlap(pos, map)) {
-			list_del_init(&pos->node);
-			/* XXX leaks dsos */
-			free(pos);
+			if (verbose >= 2) {
+				printf("overlapping maps:\n");
+				map__fprintf(map, stdout);
+				map__fprintf(pos, stdout);
+			}
+
+			if (map->start <= pos->start && map->end > pos->start)
+				pos->start = map->end;
+
+			if (map->end >= pos->end && map->start < pos->end)
+				pos->end = map->start;
+
+			if (verbose >= 2) {
+				printf("after collision:\n");
+				map__fprintf(pos, stdout);
+			}
+
+			if (pos->start >= pos->end) {
+				list_del_init(&pos->node);
+				free(pos);
+			}
 		}
 	}
 
