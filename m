Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZEZO0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZEZO0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 10:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbZEZO0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 10:26:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:52973 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052AbZEZO0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 10:26:19 -0400
Date: Tue, 26 May 2009 14:24:31 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf report: Fix ELF symbol parsing
Message-ID: <tip-f17e04afaff84b5cfd317da29ac4d764908ff833@git.kernel.org>
Git-Commit-ID: f17e04afaff84b5cfd317da29ac4d764908ff833
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 14:24:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f17e04afaff84b5cfd317da29ac4d764908ff833
Gitweb:     http://git.kernel.org/tip/f17e04afaff84b5cfd317da29ac4d764908ff833
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 26 May 2009 15:30:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 16:18:43 +0200

perf report: Fix ELF symbol parsing

[ Impact: fix DSO symbol output in perf report ]

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile         |    2 +-
 Documentation/perf_counter/builtin-report.c |   72 ++++++++-------------------
 2 files changed, 22 insertions(+), 52 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 412dea1..10c13a6 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -159,7 +159,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -g -O2 -Wall
+CFLAGS = -ggdb3 -Wall
 LDFLAGS = -lpthread -lrt -lelf
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 9e59d60..697f960 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -55,34 +55,6 @@ typedef union event_union {
 	struct comm_event comm;
 } event_t;
 
-struct section {
-	struct list_head node;
-	uint64_t	 start;
-	uint64_t	 end;
-	uint64_t	 offset;
-	char		 name[0];
-};
-
-struct section *section__new(uint64_t start, uint64_t size,
-				    uint64_t offset, char *name)
-{
-	struct section *self = malloc(sizeof(*self) + strlen(name) + 1);
-
-	if (self != NULL) {
-		self->start  = start;
-		self->end    = start + size;
-		self->offset = offset;
-		strcpy(self->name, name);
-	}
-
-	return self;
-}
-
-static void section__delete(struct section *self)
-{
-	free(self);
-}
-
 struct symbol {
 	struct rb_node rb_node;
 	uint64_t       start;
@@ -116,7 +88,6 @@ static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 
 struct dso {
 	struct list_head node;
-	struct list_head sections;
 	struct rb_root	 syms;
 	char		 name[0];
 };
@@ -127,21 +98,12 @@ static struct dso *dso__new(const char *name)
 
 	if (self != NULL) {
 		strcpy(self->name, name);
-		INIT_LIST_HEAD(&self->sections);
 		self->syms = RB_ROOT;
 	}
 
 	return self;
 }
 
-static void dso__delete_sections(struct dso *self)
-{
-	struct section *pos, *n;
-
-	list_for_each_entry_safe(pos, n, &self->sections, node)
-		section__delete(pos);
-}
-
 static void dso__delete_symbols(struct dso *self)
 {
 	struct symbol *pos;
@@ -156,7 +118,6 @@ static void dso__delete_symbols(struct dso *self)
 
 static void dso__delete(struct dso *self)
 {
-	dso__delete_sections(self);
 	dso__delete_symbols(self);
 	free(self);
 }
@@ -282,9 +243,6 @@ static int dso__load(struct dso *self)
 	if (sec == NULL)
 		goto out_elf_end;
 
-	if (gelf_getshdr(sec, &shdr) == NULL)
-		goto out_elf_end;
-
 	Elf_Data *syms = elf_getdata(sec, NULL);
 	if (syms == NULL)
 		goto out_elf_end;
@@ -302,11 +260,21 @@ static int dso__load(struct dso *self)
 	GElf_Sym sym;
 	uint32_t index;
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
+		struct symbol *f;
+
 		if (!elf_sym__is_function(&sym))
 			continue;
-		struct symbol *f = symbol__new(sym.st_value, sym.st_size,
-					       elf_sym__name(&sym, symstrs));
-		if (f == NULL)
+
+		sec = elf_getscn(elf, sym.st_shndx);
+		if (!sec)
+			goto out_elf_end;
+
+		gelf_getshdr(sec, &shdr);
+		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+
+		f = symbol__new(sym.st_value, sym.st_size,
+				elf_sym__name(&sym, symstrs));
+		if (!f)
 			goto out_elf_end;
 
 		dso__insert_symbol(self, f);
@@ -498,7 +466,7 @@ static size_t symhist__fprintf(struct symhist *self, FILE *fp)
 		ret += fprintf(fp, "%s", self->sym ? self->sym->name: "<unknown>");
 	else
 		ret += fprintf(fp, "%s: %s",
-			       self->dso ? self->dso->name : "<unknown",
+			       self->dso ? self->dso->name : "<unknown>",
 			       self->sym ? self->sym->name : "<unknown>");
 	return ret + fprintf(fp, ": %u\n", self->count);
 }
@@ -714,6 +682,7 @@ more:
 		int show = 0;
 		struct dso *dso = NULL;
 		struct thread *thread = threads__findnew(event->ip.pid);
+		uint64_t ip = event->ip.ip;
 
 		if (thread == NULL) {
 			fprintf(stderr, "problem processing %d event, bailing out\n",
@@ -728,19 +697,20 @@ more:
 		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
 			show = SHOW_USER;
 			level = '.';
-			struct map *map = thread__find_map(thread, event->ip.ip);
-			if (map != NULL)
+			struct map *map = thread__find_map(thread, ip);
+			if (map != NULL) {
 				dso = map->dso;
+				ip -= map->start + map->pgoff;
+			}
 		} else {
 			show = SHOW_HV;
 			level = 'H';
 		}
 
 		if (show & show_mask) {
-			struct symbol *sym = dso__find_symbol(dso, event->ip.ip);
+			struct symbol *sym = dso__find_symbol(dso, ip);
 
-			if (thread__symbol_incnew(thread, sym, event->ip.ip,
-						  dso, level)) {
+			if (thread__symbol_incnew(thread, sym, ip, dso, level)) {
 				fprintf(stderr, "problem incrementing symbol count, bailing out\n");
 				goto done;
 			}
