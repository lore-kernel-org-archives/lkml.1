Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZFENWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZFENWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754481AbZFENWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:22:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:59066 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbZFENWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:22:31 -0400
Date: Fri, 5 Jun 2009 13:21:54 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Deal with maps
Message-ID: <tip-fc54db5105d01ad691a7d747064c7890e17f936c@git.kernel.org>
Git-Commit-ID: fc54db5105d01ad691a7d747064c7890e17f936c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 05 Jun 2009 13:21:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc54db5105d01ad691a7d747064c7890e17f936c
Gitweb:     http://git.kernel.org/tip/fc54db5105d01ad691a7d747064c7890e17f936c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 5 Jun 2009 14:04:59 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 5 Jun 2009 14:46:41 +0200

perf report: Deal with maps

In order to deal with [vdso] maps generalize the ip->symbol path
a bit and allow to override some bits with custom functions.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |   37 +++++++++++++++++++++++++-
 Documentation/perf_counter/util/symbol.c    |    1 +
 Documentation/perf_counter/util/symbol.h    |    1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index eb5424f..9783d1e 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -79,6 +79,7 @@ typedef union event_union {
 
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
+static struct dso *vdso;
 
 static void dsos__add(struct dso *dso)
 {
@@ -136,6 +137,11 @@ static void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
+static struct symbol *vdso__find_symbol(struct dso *dso, uint64_t ip)
+{
+	return dso__find_symbol(kernel_dso, ip);
+}
+
 static int load_kernel(void)
 {
 	int err;
@@ -151,6 +157,14 @@ static int load_kernel(void)
 	} else
 		dsos__add(kernel_dso);
 
+	vdso = dso__new("[vdso]", 0);
+	if (!vdso)
+		return -1;
+
+	vdso->find_symbol = vdso__find_symbol;
+
+	dsos__add(vdso);
+
 	return err;
 }
 
@@ -173,9 +187,20 @@ struct map {
 	uint64_t	 start;
 	uint64_t	 end;
 	uint64_t	 pgoff;
+	uint64_t	 (*map_ip)(struct map *, uint64_t);
 	struct dso	 *dso;
 };
 
+static uint64_t map__map_ip(struct map *map, uint64_t ip)
+{
+	return ip - map->start + map->pgoff;
+}
+
+static uint64_t vdso__map_ip(struct map *map, uint64_t ip)
+{
+	return ip;
+}
+
 static struct map *map__new(struct mmap_event *event)
 {
 	struct map *self = malloc(sizeof(*self));
@@ -201,6 +226,11 @@ static struct map *map__new(struct mmap_event *event)
 		self->dso = dsos__findnew(filename);
 		if (self->dso == NULL)
 			goto out_delete;
+
+		if (self->dso == vdso)
+			self->map_ip = vdso__map_ip;
+		else
+			self->map_ip = map__map_ip;
 	}
 	return self;
 out_delete:
@@ -917,8 +947,8 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 
 		map = thread__find_map(thread, ip);
 		if (map != NULL) {
+			ip = map->map_ip(map, ip);
 			dso = map->dso;
-			ip -= map->start + map->pgoff;
 		} else {
 			/*
 			 * If this is outside of all known maps,
@@ -938,7 +968,10 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 
 	if (show & show_mask) {
-		struct symbol *sym = dso__find_symbol(dso, ip);
+		struct symbol *sym = NULL;
+
+		if (dso)
+			sym = dso->find_symbol(dso, ip);
 
 		if (hist_entry__add(thread, map, dso, sym, ip, level)) {
 			fprintf(stderr,
diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index 15d5cf9..a06bbfb 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -45,6 +45,7 @@ struct dso *dso__new(const char *name, unsigned int sym_priv_size)
 		strcpy(self->name, name);
 		self->syms = RB_ROOT;
 		self->sym_priv_size = sym_priv_size;
+		self->find_symbol = dso__find_symbol;
 	}
 
 	return self;
diff --git a/Documentation/perf_counter/util/symbol.h b/Documentation/perf_counter/util/symbol.h
index 8dd8522..e23cc31 100644
--- a/Documentation/perf_counter/util/symbol.h
+++ b/Documentation/perf_counter/util/symbol.h
@@ -16,6 +16,7 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
 	unsigned int	 sym_priv_size;
+	struct symbol    *(*find_symbol)(struct dso *, uint64_t ip);
 	char		 name[0];
 };
 
