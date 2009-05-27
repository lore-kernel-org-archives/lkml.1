Return-Path: <linux-kernel-owner+w=401wt.eu-S933510AbZE0SXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510AbZE0SXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbZE0SVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:21:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52034 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbZE0SVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:21:47 -0400
Message-Id: <20090527182100.593234422@chello.nl>
References: <20090527182021.231666503@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 27 May 2009 20:20:22 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>, Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/7] perf_counter: tools: /usr/lib/debug%s.debug support
Content-Disposition: inline; filename=perf_counter-tools-report-foo.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some distro's seem to store debuginfo in weird places.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 Documentation/perf_counter/builtin-report.c |   94 ++++++++++++++++++++++------
 1 file changed, 76 insertions(+), 18 deletions(-)

Index: linux-2.6/Documentation/perf_counter/builtin-report.c
===================================================================
--- linux-2.6.orig/Documentation/perf_counter/builtin-report.c
+++ linux-2.6/Documentation/perf_counter/builtin-report.c
@@ -190,7 +190,8 @@ static inline int elf_sym__is_function(c
 {
 	return elf_sym__type(sym) == STT_FUNC &&
 	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF;
+	       sym->st_shndx != SHN_UNDEF &&
+	       sym->st_size != 0;
 }
 
 static inline const char *elf_sym__name(const GElf_Sym *sym,
@@ -222,11 +223,11 @@ static Elf_Scn *elf_section_by_name(Elf 
 	return sec;
 }
 
-static int dso__load(struct dso *self)
+static int dso__load_sym(struct dso *self, int fd, char *name)
 {
 	Elf_Data *symstrs;
 	uint32_t nr_syms;
-	int fd, err = -1;
+	int err = -1;
 	uint32_t index;
 	GElf_Ehdr ehdr;
 	GElf_Shdr shdr;
@@ -234,16 +235,12 @@ static int dso__load(struct dso *self)
 	GElf_Sym sym;
 	Elf_Scn *sec;
 	Elf *elf;
-
-
-	fd = open(self->name, O_RDONLY);
-	if (fd == -1)
-		return -1;
+	int nr = 0;
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
 		fprintf(stderr, "%s: cannot read %s ELF file.\n",
-			__func__, self->name);
+			__func__, name);
 		goto out_close;
 	}
 
@@ -292,16 +289,63 @@ static int dso__load(struct dso *self)
 			goto out_elf_end;
 
 		dso__insert_symbol(self, f);
+
+		nr++;
 	}
 
-	err = 0;
+	err = nr;
 out_elf_end:
 	elf_end(elf);
 out_close:
-	close(fd);
 	return err;
 }
 
+static int dso__load(struct dso *self)
+{
+	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
+	char *name = malloc(size);
+	int variant = 0;
+	int ret = -1;
+	int fd;
+
+	if (!name)
+		return -1;
+
+more:
+	do {
+		switch (variant) {
+		case 0: /* Fedora */
+			snprintf(name, size, "/usr/lib/debug%s.debug", self->name);
+			break;
+		case 1: /* Ubuntu */
+			snprintf(name, size, "/usr/lib/debug%s", self->name);
+			break;
+		case 2: /* Sane people */
+			snprintf(name, size, "%s", self->name);
+			break;
+
+		default:
+			goto out;
+		}
+		variant++;
+
+		fd = open(name, O_RDONLY);
+	} while (fd < 0);
+
+	ret = dso__load_sym(self, fd, name);
+	close(fd);
+
+	/*
+	 * Some people seem to have debuginfo files _WITHOUT_ debug info!?!?
+	 */
+	if (!ret)
+		goto more;
+
+out:
+	free(name);
+	return ret;
+}
+
 static size_t dso__fprintf(struct dso *self, FILE *fp)
 {
 	size_t ret = fprintf(fp, "dso: %s\n", self->name);
@@ -336,11 +380,23 @@ static struct dso *dsos__find(const char
 static struct dso *dsos__findnew(const char *name)
 {
 	struct dso *dso = dsos__find(name);
+	int nr;
 
 	if (dso == NULL) {
 		dso = dso__new(name);
-		if (dso != NULL && dso__load(dso) < 0)
+		if (!dso)
+			goto out_delete_dso;
+
+		nr = dso__load(dso);
+		if (nr < 0) {
+			fprintf(stderr, "Failed to open: %s\n", name);
 			goto out_delete_dso;
+		}
+		if (!nr) {
+			fprintf(stderr,
+		"Failed to find debug symbols for: %s, maybe install a debug package?\n",
+					name);
+		}
 
 		dsos__add(dso);
 	}
@@ -547,9 +603,9 @@ symhist__fprintf(struct symhist *self, u
 	size_t ret;
 
 	if (total_samples)
-		ret = fprintf(fp, "%5.2f", (self->count * 100.0) / total_samples);
+		ret = fprintf(fp, "%5.2f%% ", (self->count * 100.0) / total_samples);
 	else
-		ret = fprintf(fp, "%12d", self->count);
+		ret = fprintf(fp, "%12d ", self->count);
 
 	ret += fprintf(fp, "%14s [%c] ",
 		       thread__name(self->thread, bf, sizeof(bf)),
@@ -922,10 +978,12 @@ more:
 	}
 	default: {
 broken_event:
-		fprintf(stderr, "%p [%p]: skipping unknown header type: %d\n",
-			(void *)(offset + head),
-			(void *)(long)(event->header.size),
-			event->header.type);
+		if (dump_trace)
+			fprintf(stderr, "%p [%p]: skipping unknown header type: %d\n",
+					(void *)(offset + head),
+					(void *)(long)(event->header.size),
+					event->header.type);
+
 		total_unknown++;
 
 		/*

-- 

