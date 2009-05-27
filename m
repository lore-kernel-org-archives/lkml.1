Return-Path: <linux-kernel-owner+w=401wt.eu-S1764117AbZE0NEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764117AbZE0NEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 09:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764167AbZE0NEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 09:04:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:52835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764161AbZE0NEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 09:04:12 -0400
Date: Wed, 27 May 2009 13:03:32 GMT
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
Subject: [tip:perfcounters/core] perf_counter: tools: /usr/lib/debug%s.debug support
Message-ID: <tip-b7a16eac5e679fb5f531b9eeff7db7952303e77d@git.kernel.org>
Git-Commit-ID: b7a16eac5e679fb5f531b9eeff7db7952303e77d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 13:03:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7a16eac5e679fb5f531b9eeff7db7952303e77d
Gitweb:     http://git.kernel.org/tip/b7a16eac5e679fb5f531b9eeff7db7952303e77d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 27 May 2009 13:35:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 14:54:29 +0200

perf_counter: tools: /usr/lib/debug%s.debug support

Some distros seem to store debuginfo in weird places.

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
 Documentation/perf_counter/builtin-report.c |   94 +++++++++++++++++++++-----
 1 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 6265bed..a9ff49a 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -190,7 +190,8 @@ static inline int elf_sym__is_function(const GElf_Sym *sym)
 {
 	return elf_sym__type(sym) == STT_FUNC &&
 	       sym->st_name != 0 &&
-	       sym->st_shndx != SHN_UNDEF;
+	       sym->st_shndx != SHN_UNDEF &&
+	       sym->st_size != 0;
 }
 
 static inline const char *elf_sym__name(const GElf_Sym *sym,
@@ -222,11 +223,11 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
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
@@ -336,11 +380,23 @@ static struct dso *dsos__find(const char *name)
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
@@ -547,9 +603,9 @@ symhist__fprintf(struct symhist *self, uint64_t total_samples, FILE *fp)
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
