Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbZE0HUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbZE0HUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760483AbZE0HRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:17:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:50201 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760420AbZE0HR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:17:29 -0400
Date: Wed, 27 May 2009 07:16:50 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, rostedt@goodmis.org,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, rostedt@goodmis.org, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090526222155.GJ4424@ghostprotocols.net>
References: <20090526222155.GJ4424@ghostprotocols.net>
Subject: [tip:perfcounters/core] perf_counter tools: Introduce stricter C code checking
Message-ID: <tip-16f762a2ac5ecf8a11f6f0332e46cc3459220da5@git.kernel.org>
Git-Commit-ID: 16f762a2ac5ecf8a11f6f0332e46cc3459220da5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 May 2009 07:16:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  16f762a2ac5ecf8a11f6f0332e46cc3459220da5
Gitweb:     http://git.kernel.org/tip/16f762a2ac5ecf8a11f6f0332e46cc3459220da5
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 27 May 2009 09:10:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 May 2009 08:10:35 +0200

perf_counter tools: Introduce stricter C code checking

Tighten up our C code requirements:

 - disallow warnings
 - disallow declarations-mixed-with-statements
 - require proper prototypes
 - require C99 (with gcc extensions)

Fix up a ton of problems these measures unearth:

 - unused functions
 - needlessly global functions
 - missing prototypes
 - code mixed with declarations

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20090526222155.GJ4424@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/Makefile         |    2 +-
 Documentation/perf_counter/builtin-help.c   |    2 +-
 Documentation/perf_counter/builtin-record.c |   38 ++++++-----
 Documentation/perf_counter/builtin-report.c |  103 +++++++++++++--------------
 Documentation/perf_counter/builtin-stat.c   |    3 +-
 Documentation/perf_counter/builtin-top.c    |    2 +-
 Documentation/perf_counter/util/abspath.c   |    2 +-
 Documentation/perf_counter/util/cache.h     |    2 +
 Documentation/perf_counter/util/util.h      |    2 +
 9 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/Documentation/perf_counter/Makefile b/Documentation/perf_counter/Makefile
index 10c13a6..efb0589 100644
--- a/Documentation/perf_counter/Makefile
+++ b/Documentation/perf_counter/Makefile
@@ -159,7 +159,7 @@ uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
-CFLAGS = -ggdb3 -Wall
+CFLAGS = -ggdb3 -Wall -Werror -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes -std=gnu99 -Wdeclaration-after-statement
 LDFLAGS = -lpthread -lrt -lelf
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
diff --git a/Documentation/perf_counter/builtin-help.c b/Documentation/perf_counter/builtin-help.c
index 6616de0..d2bd317 100644
--- a/Documentation/perf_counter/builtin-help.c
+++ b/Documentation/perf_counter/builtin-help.c
@@ -399,7 +399,7 @@ static void get_html_page_path(struct strbuf *page_path, const char *page)
  * HTML.
  */
 #ifndef open_html
-void open_html(const char *path)
+static void open_html(const char *path)
 {
 	execl_perf_cmd("web--browse", "-c", "help.browser", path, NULL);
 }
diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index ec2b787..68abfdf 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -1,6 +1,7 @@
 
 
 #include "perf.h"
+#include "builtin.h"
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -144,26 +145,32 @@ static int nr_poll;
 static int nr_cpu;
 
 struct mmap_event {
-	struct perf_event_header header;
-	__u32 pid, tid;
-	__u64 start;
-	__u64 len;
-	__u64 pgoff;
-	char filename[PATH_MAX];
+	struct perf_event_header	header;
+	__u32				pid;
+	__u32				tid;
+	__u64				start;
+	__u64				len;
+	__u64				pgoff;
+	char				filename[PATH_MAX];
 };
+
 struct comm_event {
-	struct perf_event_header header;
-	__u32 pid,tid;
-	char comm[16];
+	struct perf_event_header	header;
+	__u32				pid;
+	__u32				tid;
+	char				comm[16];
 };
 
 static pid_t pid_synthesize_comm_event(pid_t pid)
 {
+	struct comm_event comm_ev;
 	char filename[PATH_MAX];
+	pid_t spid, ppid;
 	char bf[BUFSIZ];
-	struct comm_event comm_ev;
+	int fd, nr, ret;
+	char comm[18];
 	size_t size;
-	int fd;
+	char state;
 
 	snprintf(filename, sizeof(filename), "/proc/%d/stat", pid);
 
@@ -178,12 +185,8 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 	}
 	close(fd);
 
-	pid_t spid, ppid;
-	char state;
-	char comm[18];
-
 	memset(&comm_ev, 0, sizeof(comm_ev));
-        int nr = sscanf(bf, "%d %s %c %d %d ",
+        nr = sscanf(bf, "%d %s %c %d %d ",
 			&spid, comm, &state, &ppid, &comm_ev.pid);
 	if (nr != 5) {
 		fprintf(stderr, "couldn't get COMM and pgid, malformed %s\n",
@@ -198,7 +201,8 @@ static pid_t pid_synthesize_comm_event(pid_t pid)
 	memcpy(comm_ev.comm, comm + 1, size);
 	size = ALIGN(size, sizeof(uint64_t));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
-	int ret = write(output, &comm_ev, comm_ev.header.size);
+
+	ret = write(output, &comm_ev, comm_ev.header.size);
 	if (ret < 0) {
 		perror("failed to write");
 		exit(-1);
diff --git a/Documentation/perf_counter/builtin-report.c b/Documentation/perf_counter/builtin-report.c
index 2d65d9c..7f1255d 100644
--- a/Documentation/perf_counter/builtin-report.c
+++ b/Documentation/perf_counter/builtin-report.c
@@ -1,4 +1,5 @@
 #include "util/util.h"
+#include "builtin.h"
 
 #include <libelf.h>
 #include <gelf.h>
@@ -22,7 +23,7 @@ static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
 
 static int		dump_trace = 0;
-static int 		verbose;
+static int		verbose;
 
 static unsigned long	page_size;
 static unsigned long	mmap_window = 32;
@@ -60,10 +61,10 @@ typedef union event_union {
 } event_t;
 
 struct symbol {
-	struct rb_node rb_node;
-	uint64_t       start;
-	uint64_t       end;
-	char	       name[0];
+	struct rb_node		rb_node;
+	__u64			start;
+	__u64			end;
+	char			name[0];
 };
 
 static struct symbol *symbol__new(uint64_t start, uint64_t len, const char *name)
@@ -86,7 +87,7 @@ static void symbol__delete(struct symbol *self)
 
 static size_t symbol__fprintf(struct symbol *self, FILE *fp)
 {
-	return fprintf(fp, " %lx-%lx %s\n",
+	return fprintf(fp, " %llx-%llx %s\n",
 		       self->start, self->end, self->name);
 }
 
@@ -147,10 +148,12 @@ static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 
 static struct symbol *dso__find_symbol(struct dso *self, uint64_t ip)
 {
+	struct rb_node *n;
+
 	if (self == NULL)
 		return NULL;
 
-	struct rb_node *n = self->syms.rb_node;
+	n = self->syms.rb_node;
 
 	while (n) {
 		struct symbol *s = rb_entry(n, struct symbol, rb_node);
@@ -221,33 +224,42 @@ static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 
 static int dso__load(struct dso *self)
 {
-	int fd = open(self->name, O_RDONLY), err = -1;
+	Elf_Data *symstrs;
+	uint32_t nr_syms;
+	int fd, err = -1;
+	uint32_t index;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *syms;
+	GElf_Sym sym;
+	Elf_Scn *sec;
+	Elf *elf;
 
+
+	fd = open(self->name, O_RDONLY);
 	if (fd == -1)
 		return -1;
 
-	Elf *elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
 		fprintf(stderr, "%s: cannot read %s ELF file.\n",
 			__func__, self->name);
 		goto out_close;
 	}
 
-	GElf_Ehdr ehdr;
 	if (gelf_getehdr(elf, &ehdr) == NULL) {
 		fprintf(stderr, "%s: cannot get elf header.\n", __func__);
 		goto out_elf_end;
 	}
 
-	GElf_Shdr shdr;
-	Elf_Scn *sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
+	sec = elf_section_by_name(elf, &ehdr, &shdr, ".symtab", NULL);
 	if (sec == NULL)
 		sec = elf_section_by_name(elf, &ehdr, &shdr, ".dynsym", NULL);
 
 	if (sec == NULL)
 		goto out_elf_end;
 
-	Elf_Data *syms = elf_getdata(sec, NULL);
+	syms = elf_getdata(sec, NULL);
 	if (syms == NULL)
 		goto out_elf_end;
 
@@ -255,14 +267,12 @@ static int dso__load(struct dso *self)
 	if (sec == NULL)
 		goto out_elf_end;
 
-	Elf_Data *symstrs = elf_getdata(sec, NULL);
+	symstrs = elf_getdata(sec, NULL);
 	if (symstrs == NULL)
 		goto out_elf_end;
 
-	const uint32_t nr_syms = shdr.sh_size / shdr.sh_entsize;
+	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
-	GElf_Sym sym;
-	uint32_t index;
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 
@@ -342,7 +352,7 @@ out_delete_dso:
 	return NULL;
 }
 
-void dsos__fprintf(FILE *fp)
+static void dsos__fprintf(FILE *fp)
 {
 	struct dso *pos;
 
@@ -365,7 +375,7 @@ static int hex(char ch)
  * While we find nice hex chars, build a long_val.
  * Return number of chars processed.
  */
-int hex2long(char *ptr, unsigned long *long_val)
+static int hex2long(char *ptr, unsigned long *long_val)
 {
 	const char *p = ptr;
 	*long_val = 0;
@@ -493,12 +503,6 @@ out_delete:
 	return NULL;
 }
 
-static size_t map__fprintf(struct map *self, FILE *fp)
-{
-	return fprintf(fp, " %lx-%lx %lx %s\n",
-		       self->start, self->end, self->pgoff, self->dso->name);
-}
-
 struct thread;
 
 static const char *thread__name(struct thread *self, char *bf, size_t size);
@@ -531,11 +535,6 @@ static struct symhist *symhist__new(struct symbol *sym, uint64_t ip,
 	return self;
 }
 
-void symhist__delete(struct symhist *self)
-{
-	free(self);
-}
-
 static void symhist__inc(struct symhist *self)
 {
 	++self->count;
@@ -608,6 +607,8 @@ static int thread__symbol_incnew(struct thread *self, struct symbol *sym,
 	struct symhist *sh;
 
 	while (*p != NULL) {
+		uint64_t start;
+
 		parent = *p;
 		sh = rb_entry(parent, struct symhist, rb_node);
 
@@ -617,7 +618,7 @@ static int thread__symbol_incnew(struct thread *self, struct symbol *sym,
 		}
 
 		/* Handle unresolved symbols too */
-		const uint64_t start = !sh->sym ? sh->ip : sh->sym->start;
+		start = !sh->sym ? sh->ip : sh->sym->start;
 
 		if (ip < start)
 			p = &(*p)->rb_left;
@@ -639,17 +640,6 @@ static int thread__set_comm(struct thread *self, const char *comm)
 	return self->comm ? 0 : -ENOMEM;
 }
 
-size_t thread__maps_fprintf(struct thread *self, FILE *fp)
-{
-	struct map *pos;
-	size_t ret = 0;
-
-	list_for_each_entry(pos, &self->maps, node)
-		ret += map__fprintf(pos, fp);
-
-	return ret;
-}
-
 static size_t thread__fprintf(struct thread *self, FILE *fp)
 {
 	int ret = fprintf(fp, "thread: %d %s\n", self->pid, self->comm);
@@ -657,13 +647,14 @@ static size_t thread__fprintf(struct thread *self, FILE *fp)
 
 	for (nd = rb_first(&self->symhists); nd; nd = rb_next(nd)) {
 		struct symhist *pos = rb_entry(nd, struct symhist, rb_node);
+
 		ret += symhist__fprintf(pos, 0, fp);
 	}
 
 	return ret;
 }
 
-static struct rb_root threads = RB_ROOT;
+static struct rb_root threads;
 
 static struct thread *threads__findnew(pid_t pid)
 {
@@ -699,11 +690,11 @@ static void thread__insert_map(struct thread *self, struct map *map)
 
 static struct map *thread__find_map(struct thread *self, uint64_t ip)
 {
+	struct map *pos;
+
 	if (self == NULL)
 		return NULL;
 
-	struct map *pos;
-
 	list_for_each_entry(pos, &self->maps, node)
 		if (ip >= pos->start && ip <= pos->end)
 			return pos;
@@ -711,7 +702,7 @@ static struct map *thread__find_map(struct thread *self, uint64_t ip)
 	return NULL;
 }
 
-void threads__fprintf(FILE *fp)
+static void threads__fprintf(FILE *fp)
 {
 	struct rb_node *nd;
 	for (nd = rb_first(&threads); nd; nd = rb_next(nd)) {
@@ -720,7 +711,7 @@ void threads__fprintf(FILE *fp)
 	}
 }
 
-static struct rb_root global_symhists = RB_ROOT;
+static struct rb_root global_symhists;
 
 static void threads__insert_symhist(struct symhist *sh)
 {
@@ -852,7 +843,7 @@ more:
 				(void *)(long)(event->header.size),
 				event->header.misc,
 				event->ip.pid,
-				(void *)event->ip.ip);
+				(void *)(long)ip);
 		}
 
 		if (thread == NULL) {
@@ -866,9 +857,12 @@ more:
 			level = 'k';
 			dso = kernel_dso;
 		} else if (event->header.misc & PERF_EVENT_MISC_USER) {
+			struct map *map;
+
 			show = SHOW_USER;
 			level = '.';
-			struct map *map = thread__find_map(thread, ip);
+
+			map = thread__find_map(thread, ip);
 			if (map != NULL) {
 				dso = map->dso;
 				ip -= map->start + map->pgoff;
@@ -896,9 +890,9 @@ more:
 			fprintf(stderr, "%p [%p]: PERF_EVENT_MMAP: [%p(%p) @ %p]: %s\n",
 				(void *)(offset + head),
 				(void *)(long)(event->header.size),
-				(void *)event->mmap.start,
-				(void *)event->mmap.len,
-				(void *)event->mmap.pgoff,
+				(void *)(long)event->mmap.start,
+				(void *)(long)event->mmap.len,
+				(void *)(long)event->mmap.pgoff,
 				event->mmap.filename);
 		}
 		if (thread == NULL || map == NULL) {
@@ -964,6 +958,11 @@ done:
 		return 0;
 	}
 
+	if (verbose >= 2) {
+		dsos__fprintf(stdout);
+		threads__fprintf(stdout);
+	}
+
 	threads__sort_symhists();
 	threads__symhists_fprintf(total, stdout);
 
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index e7cb941..ce661e2 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -30,6 +30,7 @@
  */
 
 #include "perf.h"
+#include "builtin.h"
 #include "util/util.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -108,7 +109,7 @@ static void create_perfstat_counter(int counter)
 	}
 }
 
-int do_perfstat(int argc, const char **argv)
+static int do_perfstat(int argc, const char **argv)
 {
 	unsigned long long t0, t1;
 	int counter;
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 6b1c66f..a890872 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -42,8 +42,8 @@
   * Released under the GPL v2. (and only v2, not any later version)
   */
 
-
 #include "perf.h"
+#include "builtin.h"
 #include "util/util.h"
 #include "util/util.h"
 #include "util/parse-options.h"
diff --git a/Documentation/perf_counter/util/abspath.c b/Documentation/perf_counter/util/abspath.c
index 649f34f..61d33b8 100644
--- a/Documentation/perf_counter/util/abspath.c
+++ b/Documentation/perf_counter/util/abspath.c
@@ -5,7 +5,7 @@
  * symlink to a directory, we do not want to say it is a directory when
  * dealing with tracked content in the working tree.
  */
-int is_directory(const char *path)
+static int is_directory(const char *path)
 {
 	struct stat st;
 	return (!stat(path, &st) && S_ISDIR(st.st_mode));
diff --git a/Documentation/perf_counter/util/cache.h b/Documentation/perf_counter/util/cache.h
index 7108051..393d614 100644
--- a/Documentation/perf_counter/util/cache.h
+++ b/Documentation/perf_counter/util/cache.h
@@ -104,6 +104,8 @@ char *strip_path_suffix(const char *path, const char *suffix);
 
 extern char *mkpath(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
 extern char *perf_path(const char *fmt, ...) __attribute__((format (printf, 1, 2)));
+/* perf_mkstemp() - create tmp file honoring TMPDIR variable */
+extern int perf_mkstemp(char *path, size_t len, const char *template);
 
 extern char *mksnpath(char *buf, size_t n, const char *fmt, ...)
 	__attribute__((format (printf, 3, 4)));
diff --git a/Documentation/perf_counter/util/util.h b/Documentation/perf_counter/util/util.h
index 36e40c3..76590a1 100644
--- a/Documentation/perf_counter/util/util.h
+++ b/Documentation/perf_counter/util/util.h
@@ -309,6 +309,8 @@ extern ssize_t xread(int fd, void *buf, size_t len);
 extern ssize_t xwrite(int fd, const void *buf, size_t len);
 extern int xdup(int fd);
 extern FILE *xfdopen(int fd, const char *mode);
+extern int xmkstemp(char *template);
+
 static inline size_t xsize_t(off_t len)
 {
 	return (size_t)len;
