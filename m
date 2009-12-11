Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZLKQu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZLKQu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 11:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZLKQuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 11:50:46 -0500
Received: from casper.infradead.org ([85.118.1.10]:60430 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbZLKQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 11:50:45 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf symbols: Introduce symbol_type__is_a
Date: Fri, 11 Dec 2009 14:50:37 -0200
Message-Id: <1260550239-5372-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1260550239-5372-1-git-send-email-acme@infradead.org>
References: <1260550239-5372-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For selecting the right types of symbols in /proc/kallsyms, will be
followed by elf_symbol_type__is_a, for the same purpose on ELF symtabs.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.h  |    4 ++--
 tools/perf/util/symbol.c |   15 +++++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index c7a78ee..d9a65d9 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -103,10 +103,10 @@ void event__print_totals(void);
 
 enum map_type {
 	MAP__FUNCTION = 0,
-
-	MAP__NR_TYPES,
 };
 
+#define MAP__NR_TYPES (MAP__FUNCTION + 1)
+
 struct map {
 	union {
 		struct rb_node	rb_node;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9362023..bb21c96 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -56,6 +56,16 @@ static void dso__set_loaded(struct dso *self, enum map_type type)
 	self->loaded |= (1 << type);
 }
 
+static bool symbol_type__is_a(char symbol_type, enum map_type map_type)
+{
+	switch (map_type) {
+	case MAP__FUNCTION:
+		return symbol_type == 'T' || symbol_type == 'W';
+	default:
+		return false;
+	}
+}
+
 static void symbols__fixup_end(struct rb_root *self)
 {
 	struct rb_node *nd, *prevnd = rb_first(self);
@@ -327,10 +337,7 @@ static int dso__load_all_kallsyms(struct dso *self, struct map *map)
 			continue;
 
 		symbol_type = toupper(line[len]);
-		/*
-		 * We're interested only in code ('T'ext)
-		 */
-		if (symbol_type != 'T' && symbol_type != 'W')
+		if (!symbol_type__is_a(symbol_type, map->type))
 			continue;
 
 		symbol_name = line + len + 2;
-- 
1.6.2.5

