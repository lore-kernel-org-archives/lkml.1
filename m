Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab0CEOyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:54:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:45031 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0CEOyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:54:15 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf tools: Don't trow away old map slices not overlapped by new maps
Date: Fri,  5 Mar 2010 11:54:02 -0300
Message-Id: <1267800842-22324-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 21b9216..9024fa1 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -183,8 +183,8 @@ struct thread *perf_session__findnew(struct perf_session *self, pid_t pid)
 	return th;
 }
 
-static void map_groups__remove_overlappings(struct map_groups *self,
-					    struct map *map)
+static int map_groups__fixup_overlappings(struct map_groups *self,
+					  struct map *map)
 {
 	struct rb_root *root = &self->maps[map->type];
 	struct rb_node *next = rb_first(root);
@@ -209,7 +209,36 @@ static void map_groups__remove_overlappings(struct map_groups *self,
 		 * list.
 		 */
 		list_add_tail(&pos->node, &self->removed_maps[map->type]);
+		/*
+		 * Now check if we need to create new maps for areas not
+		 * overlapped by the new map:
+		 */
+		if (map->start > pos->start) {
+			struct map *before = map__clone(pos);
+
+			if (before == NULL)
+				return -ENOMEM;
+
+			before->end = map->start - 1;
+			map_groups__insert(self, before);
+			if (verbose >= 2)
+				map__fprintf(before, stderr);
+		}
+
+		if (map->end < pos->end) {
+			struct map *after = map__clone(pos);
+
+			if (after == NULL)
+				return -ENOMEM;
+
+			after->start = map->end + 1;
+			map_groups__insert(self, after);
+			if (verbose >= 2)
+				map__fprintf(after, stderr);
+		}
 	}
+
+	return 0;
 }
 
 void maps__insert(struct rb_root *maps, struct map *map)
@@ -254,7 +283,7 @@ struct map *maps__find(struct rb_root *maps, u64 ip)
 
 void thread__insert_map(struct thread *self, struct map *map)
 {
-	map_groups__remove_overlappings(&self->mg, map);
+	map_groups__fixup_overlappings(&self->mg, map);
 	map_groups__insert(&self->mg, map);
 }
 
-- 
1.5.5.6

