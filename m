Return-Path: <linux-kernel-owner+w=401wt.eu-S932865AbZJ3S3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865AbZJ3S3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 14:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932855AbZJ3S3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 14:29:02 -0400
Received: from casper.infradead.org ([85.118.1.10]:45622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701AbZJ3S3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 14:29:00 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH] perf tools: Factor out the map initialization
Date: Fri, 30 Oct 2009 16:28:23 -0200
Message-Id: <1256927305-4628-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  |    2 ++
 tools/perf/util/map.c    |   28 ++++++++++++++++++----------
 tools/perf/util/symbol.c |   12 +++---------
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 3064a05..4a158a0 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -105,6 +105,8 @@ struct symbol;
 
 typedef int (*symbol_filter_t)(struct map *map, struct symbol *sym);
 
+void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
+	       struct dso *dso);
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 		     unsigned int sym_priv_size);
 struct map *map__clone(struct map *self);
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index d302e51..3b7ce1b 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -20,6 +20,18 @@ static int strcommon(const char *pathname, char *cwd, int cwdlen)
 	return n;
 }
 
+void map__init(struct map *self, u64 start, u64 end, u64 pgoff,
+	       struct dso *dso)
+{
+	self->start    = start;
+	self->end      = end;
+	self->pgoff    = pgoff;
+	self->dso      = dso;
+	self->map_ip   = map__map_ip;
+	self->unmap_ip = map__unmap_ip;
+	RB_CLEAR_NODE(&self->rb_node);
+}
+
 struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 		     unsigned int sym_priv_size)
 {
@@ -28,6 +40,7 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 	if (self != NULL) {
 		const char *filename = event->filename;
 		char newfilename[PATH_MAX];
+		struct dso *dso;
 		int anon;
 
 		if (cwd) {
@@ -47,20 +60,15 @@ struct map *map__new(struct mmap_event *event, char *cwd, int cwdlen,
 			filename = newfilename;
 		}
 
-		self->start = event->start;
-		self->end   = event->start + event->len;
-		self->pgoff = event->pgoff;
-
-		self->dso = dsos__findnew(filename, sym_priv_size);
-		if (self->dso == NULL)
+		dso = dsos__findnew(filename, sym_priv_size);
+		if (dso == NULL)
 			goto out_delete;
 
+		map__init(self, event->start, event->start + event->len,
+			  event->pgoff, dso);
+
 		if (self->dso == vdso || anon)
 			self->map_ip = self->unmap_ip = identity__map_ip;
-		else {
-			self->map_ip = map__map_ip;
-			self->unmap_ip = map__unmap_ip;
-		}
 	}
 	return self;
 out_delete:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b058476..9dad496 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1132,18 +1132,12 @@ static struct map *map__new2(u64 start, struct dso *dso)
 	struct map *self = malloc(sizeof(*self));
 
 	if (self != NULL) {
-		self->start = start;
 		/*
-		 * Will be filled after we load all the symbols
+		 * ->end will be filled after we load all the symbols
 		 */
-		self->end = 0;
-
-		self->pgoff = 0;
-		self->dso = dso;
-		self->map_ip = map__map_ip;
-		self->unmap_ip = map__unmap_ip;
-		RB_CLEAR_NODE(&self->rb_node);
+		map__init(self, start, 0, 0, dso);
 	}
+
 	return self;
 }
 
-- 
1.6.2.5

