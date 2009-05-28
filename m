Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZE1V64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZE1V64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZE1V6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:58:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:43611 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbZE1V6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:58:45 -0400
Date: Thu, 28 May 2009 21:58:07 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090528175513.GD4747@ghostprotocols.net>
References: <20090528175513.GD4747@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf_counter tools: struct symbol priv area
Message-ID: <tip-0085c954140d27937ada29d139c16341075d45e4@git.kernel.org>
Git-Commit-ID: 0085c954140d27937ada29d139c16341075d45e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 May 2009 21:58:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0085c954140d27937ada29d139c16341075d45e4
Gitweb:     http://git.kernel.org/tip/0085c954140d27937ada29d139c16341075d45e4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 28 May 2009 14:55:13 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 May 2009 23:25:43 +0200

perf_counter tools: struct symbol priv area

When creating a dso instance allow asking that all symbols in this dso
have a private area just before the symbol.

perf top will use this for its counters, etc.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20090528175513.GD4747@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-report.c |    4 ++--
 Documentation/perf_counter/util/symbol.c    |   26 +++++++++++++++++---------
 Documentation/perf_counter/util/symbol.h    |    8 +++++++-
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 04fc7ec..889067e 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -83,7 +83,7 @@ static struct dso *dsos__findnew(const char *name)
 	int nr;
 
 	if (dso == NULL) {
-		dso = dso__new(name);
+		dso = dso__new(name, 0);
 		if (!dso)
 			goto out_delete_dso;
 
@@ -120,7 +120,7 @@ static int load_kernel(void)
 {
 	int err = -1;
 
-	kernel_dso = dso__new("[kernel]");
+	kernel_dso = dso__new("[kernel]", 0);
 	if (!kernel_dso)
 		return -1;
 
diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index d06de2c..7088206 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -7,22 +7,27 @@
 #include <elf.h>
 
 static struct symbol *symbol__new(uint64_t start, uint64_t len,
-				  const char *name)
+				  const char *name, unsigned int priv_size)
 {
-	struct symbol *self = malloc(sizeof(*self) + strlen(name) + 1);
+	size_t namelen = strlen(name) + 1;
+	struct symbol *self = malloc(priv_size + sizeof(*self) + namelen);
 
 	if (self != NULL) {
+		if (priv_size) {
+			memset(self, 0, priv_size);
+			self = ((void *)self) + priv_size;
+		}
 		self->start = start;
 		self->end   = start + len;
-		strcpy(self->name, name);
+		memcpy(self->name, name, namelen);
 	}
 
 	return self;
 }
 
-static void symbol__delete(struct symbol *self)
+static void symbol__delete(struct symbol *self, unsigned int priv_size)
 {
-	free(self);
+	free(((void *)self) - priv_size);
 }
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
@@ -31,13 +36,14 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 		       self->start, self->end, self->name);
 }
 
-struct dso *dso__new(const char *name)
+struct dso *dso__new(const char *name, unsigned int sym_priv_size)
 {
 	struct dso *self = malloc(sizeof(*self) + strlen(name) + 1);
 
 	if (self != NULL) {
 		strcpy(self->name, name);
 		self->syms = RB_ROOT;
+		self->sym_priv_size = sym_priv_size;
 	}
 
 	return self;
@@ -51,7 +57,7 @@ static void dso__delete_symbols(struct dso *self)
 	while (next) {
 		pos = rb_entry(next, struct symbol, rb_node);
 		next = rb_next(&pos->rb_node);
-		symbol__delete(pos);
+		symbol__delete(pos, self->sym_priv_size);
 	}
 }
 
@@ -189,7 +195,8 @@ int dso__load_kallsyms(struct dso *self)
 		/*
 		 * Well fix up the end later, when we have all sorted.
 		 */
-		sym = symbol__new(start, 0xdead, line + len + 2);
+		sym = symbol__new(start, 0xdead, line + len + 2,
+				  self->sym_priv_size);
 
 		if (sym == NULL)
 			goto out_delete_line;
@@ -340,7 +347,8 @@ static int dso__load_sym(struct dso *self, int fd, const char *name)
 		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
 
 		f = symbol__new(sym.st_value, sym.st_size,
-				elf_sym__name(&sym, symstrs));
+				elf_sym__name(&sym, symstrs),
+				self->sym_priv_size);
 		if (!f)
 			goto out_elf_end;
 
diff --git a/Documentation/perf_counter/util/symbol.h b/Documentation/perf_counter/util/symbol.h
index 6dffe76..9e120af 100644
--- a/Documentation/perf_counter/util/symbol.h
+++ b/Documentation/perf_counter/util/symbol.h
@@ -15,12 +15,18 @@ struct symbol {
 struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
+	unsigned int	 sym_priv_size;
 	char		 name[0];
 };
 
-struct dso *dso__new(const char *name);
+struct dso *dso__new(const char *name, unsigned int sym_priv_size);
 void dso__delete(struct dso *self);
 
+static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
+{
+	return ((void *)sym) - self->sym_priv_size;
+}
+
 struct symbol *dso__find_symbol(struct dso *self, uint64_t ip);
 
 int dso__load_kallsyms(struct dso *self);
