Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZKQUiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZKQUiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 15:38:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZKQUiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 15:38:08 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZKQUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 15:38:07 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/3] perf top: Don't allocate the source parsing members upfront
Date: Tue, 17 Nov 2009 18:38:02 -0200
Message-Id: <1258490282-1821-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258490282-1821-2-git-send-email-acme@infradead.org>
References: <1258490282-1821-1-git-send-email-acme@infradead.org>
 <1258490282-1821-2-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Defer to parse_source() time allocating it.

Now we use about:

 1724 root      20   0 42104  10m  940 S  0.0  0.4   0:00.23 perf

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |   76 +++++++++++++++++++++++++++-------------------
 1 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 49cf876..07b92c3 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -108,6 +108,13 @@ static int			display_weighted		=     -1;
  * Symbols
  */
 
+struct sym_entry_source {
+	struct source_line	*source;
+	struct source_line	*lines;
+	struct source_line	**lines_tail;
+	pthread_mutex_t		lock;
+};
+
 struct sym_entry {
 	struct rb_node		rb_node;
 	struct list_head	node;
@@ -117,10 +124,7 @@ struct sym_entry {
 	u16			name_len;
 	u8			origin;
 	struct map		*map;
-	struct source_line	*source;
-	struct source_line	*lines;
-	struct source_line	**lines_tail;
-	pthread_mutex_t		source_lock;
+	struct sym_entry_source	*src;
 	unsigned long		count[0];
 };
 
@@ -172,6 +176,7 @@ static void sig_winch_handler(int sig __used)
 static void parse_source(struct sym_entry *syme)
 {
 	struct symbol *sym;
+	struct sym_entry_source *source;
 	struct map *map;
 	FILE *file;
 	char command[PATH_MAX*2];
@@ -181,8 +186,17 @@ static void parse_source(struct sym_entry *syme)
 	if (!syme)
 		return;
 
-	if (syme->lines) {
-		pthread_mutex_lock(&syme->source_lock);
+	if (syme->src == NULL) {
+		syme->src = calloc(1, sizeof(*source));
+		if (syme->src == NULL)
+			return;
+		pthread_mutex_init(&syme->src->lock, NULL);
+	}
+
+	source = syme->src;
+
+	if (source->lines) {
+		pthread_mutex_lock(&source->lock);
 		goto out_assign;
 	}
 
@@ -202,8 +216,8 @@ static void parse_source(struct sym_entry *syme)
 	if (!file)
 		return;
 
-	pthread_mutex_lock(&syme->source_lock);
-	syme->lines_tail = &syme->lines;
+	pthread_mutex_lock(&source->lock);
+	source->lines_tail = &source->lines;
 	while (!feof(file)) {
 		struct source_line *src;
 		size_t dummy = 0;
@@ -223,8 +237,8 @@ static void parse_source(struct sym_entry *syme)
 			*c = 0;
 
 		src->next = NULL;
-		*syme->lines_tail = src;
-		syme->lines_tail = &src->next;
+		*source->lines_tail = src;
+		source->lines_tail = &src->next;
 
 		if (strlen(src->line)>8 && src->line[8] == ':') {
 			src->eip = strtoull(src->line, NULL, 16);
@@ -238,7 +252,7 @@ static void parse_source(struct sym_entry *syme)
 	pclose(file);
 out_assign:
 	sym_filter_entry = syme;
-	pthread_mutex_unlock(&syme->source_lock);
+	pthread_mutex_unlock(&source->lock);
 }
 
 static void __zero_source_counters(struct sym_entry *syme)
@@ -246,7 +260,7 @@ static void __zero_source_counters(struct sym_entry *syme)
 	int i;
 	struct source_line *line;
 
-	line = syme->lines;
+	line = syme->src->lines;
 	while (line) {
 		for (i = 0; i < nr_counters; i++)
 			line->count[i] = 0;
@@ -261,13 +275,13 @@ static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 	if (syme != sym_filter_entry)
 		return;
 
-	if (pthread_mutex_trylock(&syme->source_lock))
+	if (pthread_mutex_trylock(&syme->src->lock))
 		return;
 
-	if (!syme->source)
+	if (syme->src == NULL || syme->src->source == NULL)
 		goto out_unlock;
 
-	for (line = syme->lines; line; line = line->next) {
+	for (line = syme->src->lines; line; line = line->next) {
 		if (line->eip == ip) {
 			line->count[counter]++;
 			break;
@@ -276,7 +290,7 @@ static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
 			break;
 	}
 out_unlock:
-	pthread_mutex_unlock(&syme->source_lock);
+	pthread_mutex_unlock(&syme->src->lock);
 }
 
 static void lookup_sym_source(struct sym_entry *syme)
@@ -287,14 +301,14 @@ static void lookup_sym_source(struct sym_entry *syme)
 
 	sprintf(pattern, "<%s>:", symbol->name);
 
-	pthread_mutex_lock(&syme->source_lock);
-	for (line = syme->lines; line; line = line->next) {
+	pthread_mutex_lock(&syme->src->lock);
+	for (line = syme->src->lines; line; line = line->next) {
 		if (strstr(line->line, pattern)) {
-			syme->source = line;
+			syme->src->source = line;
 			break;
 		}
 	}
-	pthread_mutex_unlock(&syme->source_lock);
+	pthread_mutex_unlock(&syme->src->lock);
 }
 
 static void show_lines(struct source_line *queue, int count, int total)
@@ -324,24 +338,24 @@ static void show_details(struct sym_entry *syme)
 	if (!syme)
 		return;
 
-	if (!syme->source)
+	if (!syme->src->source)
 		lookup_sym_source(syme);
 
-	if (!syme->source)
+	if (!syme->src->source)
 		return;
 
 	symbol = sym_entry__symbol(syme);
 	printf("Showing %s for %s\n", event_name(sym_counter), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
 
-	pthread_mutex_lock(&syme->source_lock);
-	line = syme->source;
+	pthread_mutex_lock(&syme->src->lock);
+	line = syme->src->source;
 	while (line) {
 		total += line->count[sym_counter];
 		line = line->next;
 	}
 
-	line = syme->source;
+	line = syme->src->source;
 	while (line) {
 		float pcnt = 0.0;
 
@@ -366,7 +380,7 @@ static void show_details(struct sym_entry *syme)
 		line->count[sym_counter] = zero ? 0 : line->count[sym_counter] * 7 / 8;
 		line = line->next;
 	}
-	pthread_mutex_unlock(&syme->source_lock);
+	pthread_mutex_unlock(&syme->src->lock);
 	if (more)
 		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
 }
@@ -647,10 +661,10 @@ static void prompt_symbol(struct sym_entry **target, const char *msg)
 
 	/* zero counters of active symbol */
 	if (syme) {
-		pthread_mutex_lock(&syme->source_lock);
+		pthread_mutex_lock(&syme->src->lock);
 		__zero_source_counters(syme);
 		*target = NULL;
-		pthread_mutex_unlock(&syme->source_lock);
+		pthread_mutex_unlock(&syme->src->lock);
 	}
 
 	fprintf(stdout, "\n%s: ", msg);
@@ -826,10 +840,10 @@ static void handle_keypress(int c)
 			else {
 				struct sym_entry *syme = sym_filter_entry;
 
-				pthread_mutex_lock(&syme->source_lock);
+				pthread_mutex_lock(&syme->src->lock);
 				sym_filter_entry = NULL;
 				__zero_source_counters(syme);
-				pthread_mutex_unlock(&syme->source_lock);
+				pthread_mutex_unlock(&syme->src->lock);
 			}
 			break;
 		case 'U':
@@ -915,7 +929,7 @@ static int symbol_filter(struct map *map, struct symbol *sym)
 
 	syme = symbol__priv(sym);
 	syme->map = map;
-	pthread_mutex_init(&syme->source_lock, NULL);
+	syme->src = NULL;
 	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter))
 		sym_filter_entry = syme;
 
-- 
1.6.2.5

