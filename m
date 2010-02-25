Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434Ab0BYP5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:57:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759418Ab0BYP5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:57:48 -0500
Date: Thu, 25 Feb 2010 12:57:40 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Anton Blanchard <anton@samba.org>
Subject: Re: perf per-symbol histogram causes memory corruption
Message-ID: <20100225155740.GB8553@ghostprotocols.net>
References: <20100225.022618.256301798.davem@davemloft.net> <20100225111148.GA5754@elte.hu> <20100225141351.GA8553@ghostprotocols.net> <20100225.070250.24592273.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225.070250.24592273.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 25, 2010 at 07:02:50AM -0800, David Miller escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Thu, 25 Feb 2010 11:13:51 -0300
> 
> > I.e. 'perf annotate' is not using this mechanism as a filter. Its a post
> > processing phase.
> 
> Right, it's abusing the filter callback.
> 
> > I'll provide a patch.
> 
> Sounds good.

Can you try this one?

>From f7f95900abe585e1fba887f5eecbc6a9e2686071 Mon Sep 17 00:00:00 2001
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Thu, 25 Feb 2010 13:50:26 -0300
Subject: [PATCH 1/1] perf annotate: Defer allocating sym_priv->hist array

Because symbol->end is not fixed up at symbol_filter time, only after all
symbols for a DSO are loaded, and that, for asm symbols, may be bogus, causing
segfaults when hits happen in these symbols.

Reported-by: David Miller <davem@davemloft.net>
Reported-by: Anton Blanchard <anton@samba.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |   59 +++++++++++++++++++++--------------------
 tools/perf/util/symbol.c      |    2 +-
 tools/perf/util/symbol.h      |    2 +
 3 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 28ea4e0..e47dd15 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -53,32 +53,20 @@ struct sym_priv {
 
 static const char *sym_hist_filter;
 
-static int symbol_filter(struct map *map __used, struct symbol *sym)
+static int sym__alloc_hist(struct symbol *self)
 {
-	if (sym_hist_filter == NULL ||
-	    strcmp(sym->name, sym_hist_filter) == 0) {
-		struct sym_priv *priv = symbol__priv(sym);
-		const int size = (sizeof(*priv->hist) +
-				  (sym->end - sym->start) * sizeof(u64));
+	struct sym_priv *priv = symbol__priv(self);
+	const int size = (sizeof(*priv->hist) +
+			  (self->end - self->start) * sizeof(u64));
 
-		priv->hist = malloc(size);
-		if (priv->hist)
-			memset(priv->hist, 0, size);
-		return 0;
-	}
-	/*
-	 * FIXME: We should really filter it out, as we don't want to go thru symbols
-	 * we're not interested, and if a DSO ends up with no symbols, delete it too,
-	 * but right now the kernel loading routines in symbol.c bail out if no symbols
-	 * are found, fix it later.
-	 */
-	return 0;
+	priv->hist = zalloc(size);
+	return priv->hist == NULL ? -1 : 0;
 }
 
 /*
  * collect histogram counts
  */
-static void hist_hit(struct hist_entry *he, u64 ip)
+static int annotate__hist_hit(struct hist_entry *he, u64 ip)
 {
 	unsigned int sym_size, offset;
 	struct symbol *sym = he->sym;
@@ -88,11 +76,11 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 	he->count++;
 
 	if (!sym || !he->map)
-		return;
+		return 0;
 
 	priv = symbol__priv(sym);
-	if (!priv->hist)
-		return;
+	if (priv->hist == NULL && sym__alloc_hist(sym) < 0)
+		return -ENOMEM;
 
 	sym_size = sym->end - sym->start;
 	offset = ip - sym->start;
@@ -100,7 +88,7 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 	pr_debug3("%s: ip=%#Lx\n", __func__, he->map->unmap_ip(he->map, ip));
 
 	if (offset >= sym_size)
-		return;
+		return 0;
 
 	h = priv->hist;
 	h->sum++;
@@ -108,18 +96,31 @@ static void hist_hit(struct hist_entry *he, u64 ip)
 
 	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", he->sym->start,
 		  he->sym->name, ip, ip - he->sym->start, h->ip[offset]);
+	return 0;
 }
 
 static int perf_session__add_hist_entry(struct perf_session *self,
 					struct addr_location *al, u64 count)
 {
 	bool hit;
-	struct hist_entry *he = __perf_session__add_hist_entry(self, al, NULL,
-							       count, &hit);
+	struct hist_entry *he;
+
+	if (sym_hist_filter != NULL &&
+	    (al->sym == NULL || strcmp(sym_hist_filter, al->sym->name) != 0)) {
+		/* We're only interested in a symbol named sym_hist_filter */
+		if (al->sym != NULL) {
+			rb_erase(&al->sym->rb_node,
+				 &al->map->dso->symbols[al->map->type]);
+			symbol__delete(al->sym);
+		}
+		return 0;
+	}
+
+	he = __perf_session__add_hist_entry(self, al, NULL, count, &hit);
 	if (he == NULL)
 		return -ENOMEM;
-	hist_hit(he, al->addr);
-	return 0;
+
+	return annotate__hist_hit(he, al->addr);
 }
 
 static int process_sample_event(event_t *event, struct perf_session *session)
@@ -129,7 +130,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	dump_printf("(IP, %d): %d: %#Lx\n", event->header.misc,
 		    event->ip.pid, event->ip.ip);
 
-	if (event__preprocess_sample(event, session, &al, symbol_filter) < 0) {
+	if (event__preprocess_sample(event, session, &al, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 7aab4e5..323c0ae 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -144,7 +144,7 @@ static struct symbol *symbol__new(u64 start, u64 len, const char *name)
 	return self;
 }
 
-static void symbol__delete(struct symbol *self)
+void symbol__delete(struct symbol *self)
 {
 	free(((void *)self) - symbol_conf.priv_size);
 }
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1b4192e..280dadd 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -51,6 +51,8 @@ struct symbol {
 	char		name[0];
 };
 
+void symbol__delete(struct symbol *self);
+
 struct strlist;
 
 struct symbol_conf {
-- 
1.5.5.1

