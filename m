Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbZHRPEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbZHRPEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 11:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbZHRPEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 11:04:07 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61041 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbZHRPEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 11:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=DdaTN68p0udd8MK4t/utGvEK1/zbzfKeteO/UhlbtaO2AMwh/f8zKMoBjHnIL8K1US
         F+bRa7l4UdRuFnoDVffgNQ5RncBFxoz6qXhK5TxY1OuVHWaSsiLfF9WWmWKmnMCeLvxA
         zkMQNG1zGC4iAdaWSOpu90/GaVxqTdFbG56PI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Save partial non-overlapping map
Date: Tue, 18 Aug 2009 17:04:03 +0200
Message-Id: <1250607843-7395-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The librarization of the thread helpers between annotate and report
lost some perf report specifics.

thread__insert_map() had its most uptodate version in perf report which
cared about partial map overlapping.
In case of overlap between two maps, perf annotate's version removes
the whole old map without considering if it partially or absolutely
overlaps the new map.

We exported the odd version, change it by using the perf report
version.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
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
 
-- 
1.6.2.3

