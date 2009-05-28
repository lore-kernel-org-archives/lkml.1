Return-Path: <linux-kernel-owner+w=401wt.eu-S1763534AbZE1R4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763534AbZE1R4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763509AbZE1Rzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:55:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35344 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763645AbZE1Rzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:55:52 -0400
Date: Thu, 28 May 2009 14:55:26 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 4/5] perf: Optionally pass a symbol filter to the dso
	load routines
Message-ID: <20090528175526.GF4747@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be used by perf top.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/perf_counter/builtin-report.c |    4 +-
 Documentation/perf_counter/util/symbol.c    |   34 ++++++++++++++++----------
 Documentation/perf_counter/util/symbol.h    |    7 ++++-
 3 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 4e9f2bc..412d524 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -87,7 +87,7 @@ static struct dso *dsos__findnew(const char *name)
 		if (!dso)
 			goto out_delete_dso;
 
-		nr = dso__load(dso);
+		nr = dso__load(dso, NULL);
 		if (nr < 0) {
 			fprintf(stderr, "Failed to open: %s\n", name);
 			goto out_delete_dso;
@@ -124,7 +124,7 @@ static int load_kernel(void)
 	if (!kernel_dso)
 		return -1;
 
-	err = dso__load_kernel(kernel_dso, vmlinux);
+	err = dso__load_kernel(kernel_dso, vmlinux, NULL);
 	if (err) {
 		dso__delete(kernel_dso);
 		kernel_dso = NULL;
diff --git a/Documentation/perf_counter/util/symbol.c b/Documentation/perf_counter/util/symbol.c
index 504ac31..4728121 100644
--- a/Documentation/perf_counter/util/symbol.c
+++ b/Documentation/perf_counter/util/symbol.c
@@ -155,7 +155,7 @@ static int hex2long(char *ptr, unsigned long *long_val)
 	return p - ptr;
 }
 
-static int dso__load_kallsyms(struct dso *self)
+static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter)
 {
 	struct rb_node *nd, *prevnd;
 	char *line = NULL;
@@ -201,7 +201,10 @@ static int dso__load_kallsyms(struct dso *self)
 		if (sym == NULL)
 			goto out_delete_line;
 
-		dso__insert_symbol(self, sym);
+		if (filter && filter(self, sym))
+			symbol__delete(sym, self->sym_priv_size);
+		else
+			dso__insert_symbol(self, sym);
 	}
 
 	/*
@@ -286,7 +289,8 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	return sec;
 }
 
-static int dso__load_sym(struct dso *self, int fd, const char *name)
+static int dso__load_sym(struct dso *self, int fd, const char *name,
+			 symbol_filter_t filter)
 {
 	Elf_Data *symstrs;
 	uint32_t nr_syms;
@@ -352,9 +356,12 @@ static int dso__load_sym(struct dso *self, int fd, const char *name)
 		if (!f)
 			goto out_elf_end;
 
-		dso__insert_symbol(self, f);
-
-		nr++;
+		if (filter && filter(self, f))
+			symbol__delete(f, self->sym_priv_size);
+		else {
+			dso__insert_symbol(self, f);
+			nr++;
+		}
 	}
 
 	err = nr;
@@ -364,7 +371,7 @@ out_close:
 	return err;
 }
 
-int dso__load(struct dso *self)
+int dso__load(struct dso *self, symbol_filter_t filter)
 {
 	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
 	char *name = malloc(size);
@@ -396,7 +403,7 @@ more:
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
-	ret = dso__load_sym(self, fd, name);
+	ret = dso__load_sym(self, fd, name, filter);
 	close(fd);
 
 	/*
@@ -410,28 +417,29 @@ out:
 	return ret;
 }
 
-static int dso__load_vmlinux(struct dso *self, const char *vmlinux)
+static int dso__load_vmlinux(struct dso *self, const char *vmlinux,
+			     symbol_filter_t filter)
 {
 	int err, fd = open(vmlinux, O_RDONLY);
 
 	if (fd < 0)
 		return -1;
 
-	err = dso__load_sym(self, fd, vmlinux);
+	err = dso__load_sym(self, fd, vmlinux, filter);
 	close(fd);
 
 	return err;
 }
 
-int dso__load_kernel(struct dso *self, const char *vmlinux)
+int dso__load_kernel(struct dso *self, const char *vmlinux, symbol_filter_t filter)
 {
 	int err = -1;
 
 	if (vmlinux)
-		err = dso__load_vmlinux(self, vmlinux);
+		err = dso__load_vmlinux(self, vmlinux, filter);
 
 	if (err)
-		err = dso__load_kallsyms(self);
+		err = dso__load_kallsyms(self, filter);
 
 	return err;
 }
diff --git a/Documentation/perf_counter/util/symbol.h b/Documentation/perf_counter/util/symbol.h
index db2fdf9..b0299bc 100644
--- a/Documentation/perf_counter/util/symbol.h
+++ b/Documentation/perf_counter/util/symbol.h
@@ -19,6 +19,8 @@ struct dso {
 	char		 name[0];
 };
 
+typedef int (*symbol_filter_t)(struct dso *self, struct symbol *sym);
+
 struct dso *dso__new(const char *name, unsigned int sym_priv_size);
 void dso__delete(struct dso *self);
 
@@ -29,8 +31,9 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 
 struct symbol *dso__find_symbol(struct dso *self, uint64_t ip);
 
-int dso__load_kernel(struct dso *self, const char *vmlinux);
-int dso__load(struct dso *self);
+int dso__load_kernel(struct dso *self, const char *vmlinux,
+		     symbol_filter_t filter);
+int dso__load(struct dso *self, symbol_filter_t filter);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 
-- 
1.6.0.6

