Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZEZMNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZEZMNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZEZMNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:13:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:51231 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZEZMN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:13:29 -0400
Date: Tue, 26 May 2009 12:13:00 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Implement dso__load using libelf
Message-ID: <tip-62eb93905b3b43cea407cfbc061cc7b40ae1c6e9@git.kernel.org>
Git-Commit-ID: 62eb93905b3b43cea407cfbc061cc7b40ae1c6e9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 26 May 2009 12:13:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62eb93905b3b43cea407cfbc061cc7b40ae1c6e9
Gitweb:     http://git.kernel.org/tip/62eb93905b3b43cea407cfbc061cc7b40ae1c6e9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 18 May 2009 14:28:47 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 26 May 2009 13:52:53 +0200

perf_counter: Implement dso__load using libelf

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile         |    2 +-
 Documentation/perf_counter/builtin-report.c |  122 ++++++++++++++++++++++++++-
 2 files changed, 121 insertions(+), 3 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 49c601e..6bffa86 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -160,7 +160,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 CFLAGS = -g -O2 -Wall
-LDFLAGS = -lpthread -lrt
+LDFLAGS = -lpthread -lrt -lelf
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 864f68f..ad2f327 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -8,6 +8,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <limits.h>
+#include <gelf.h>
+#include <elf.h>
+#include <libelf.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <errno.h>
@@ -195,10 +198,123 @@ static struct symbol *dso__find_symbol(struct dso *self, uint64_t ip)
 	return NULL;
 }
 
+/**
+ * elf_symtab__for_each_symbol - iterate thru all the symbols
+ *
+ * @self: struct elf_symtab instance to iterate
+ * @index: uint32_t index
+ * @sym: GElf_Sym iterator
+ */
+#define elf_symtab__for_each_symbol(syms, nr_syms, index, sym) \
+	for (index = 0, gelf_getsym(syms, index, &sym);\
+	     index < nr_syms; \
+	     index++, gelf_getsym(syms, index, &sym))
+
+static inline uint8_t elf_sym__type(const GElf_Sym *sym)
+{
+	return GELF_ST_TYPE(sym->st_info);
+}
+
+static inline bool elf_sym__is_function(const GElf_Sym *sym)
+{
+	return elf_sym__type(sym) == STT_FUNC &&
+	       sym->st_name != 0 &&
+	       sym->st_shndx != SHN_UNDEF;
+}
+
+static inline const char *elf_sym__name(const GElf_Sym *sym,
+					const Elf_Data *symstrs)
+{
+	return symstrs->d_buf + sym->st_name;
+}
+
+static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
+				    GElf_Shdr *shp, const char *name,
+				    size_t *index)
+{
+	Elf_Scn *sec = NULL;
+	size_t cnt = 1;
+
+	while ((sec = elf_nextscn(elf, sec)) != NULL) {
+		char *str;
+
+		gelf_getshdr(sec, shp);
+		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
+		if (!strcmp(name, str)) {
+			if (index)
+				*index = cnt;
+			break;
+		}
+		++cnt;
+	}
+
+	return sec;
+}
+
 static int dso__load(struct dso *self)
 {
-	/* FIXME */
-	return 0;
+	int fd = open(self->name, O_RDONLY), err = -1;
+
+	if (fd == -1)
+		return -1;
+
+	Elf *elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		fprintf(stderr, "%s: cannot read %s ELF file.\n",
+			__func__, self->name);
+		goto out_close;
+	}
+
+	GElf_Ehdr ehdr;
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		goto out_elf_end;
+	}
+
+	GElf_Shdr shdr;
+	Elf_Scn *sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
+	if (sec == NULL)
+		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
+
+	if (sec == NULL)
+		goto out_elf_end;
+
+	if (gelf_getshdr(sec, &shdr) == NULL)
+		goto out_elf_end;
+
+	Elf_Data *syms = elf_getdata(sec, NULL);
+	if (syms == NULL)
+		goto out_elf_end;
+
+	sec = elf_getscn(elf, shdr.sh_link);
+	if (sec == NULL)
+		goto out_elf_end;
+
+	Elf_Data *symstrs = elf_getdata(sec, NULL);
+	if (symstrs == NULL)
+		goto out_elf_end;
+
+	const uint32_t nr_syms = shdr.sh_size / shdr.sh_entsize;
+
+	GElf_Sym sym;
+	uint32_t index;
+	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
+		if (!elf_sym__is_function(&sym))
+			continue;
+		struct symbol *f = symbol__new(sym.st_value, sym.st_size,
+					       elf_sym__name(&sym, symstrs));
+		if (f == NULL)
+			goto out_elf_end;
+
+		dso__insert_symbol(self, f);
+	}
+
+	err = 0;
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+	return err;
 }
 
 static size_t dso__fprintf(struct dso *self, FILE *fp)
@@ -614,6 +730,8 @@ int cmd_report(int argc, char **argv)
 	int ret, rc = EXIT_FAILURE;
 	unsigned long total = 0;
 
+	elf_version(EV_CURRENT);
+
 	page_size = getpagesize();
 
 	process_options(argc, argv);
