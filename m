Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302Ab0AESuu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0AESuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:50:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251Ab0AESuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:50:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:39126 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab0AESus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:50:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 1/1] perf tools: Handle relocatable kernels
Date: Tue,  5 Jan 2010 16:50:31 -0200
Message-Id: <1262717431-1246-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

DSOs don't have this problem because the kernel emits a PERF_MMAP for
each new executable mapping it performs on monitored threads.

To fix the kernel case we simulate the same behaviour, by having 'perf
record' to synthesize a PERF_MMAP for the kernel, encoded like this:

[root@doppio ~]# perf record -a -f sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.344 MB perf.data (~15038 samples) ]
[root@doppio ~]# perf report -D | head -10

0xd0 [0x40]: event: 1
.
. ... raw event: size 64 bytes
.  0000:  01 00 00 00 00 00 40 00 00 00 00 00 00 00 00 00  ......@........
.  0010:  00 00 00 81 ff ff ff ff 00 00 00 00 00 00 00 00  ...............
.  0020:  00 00 00 00 00 00 00 00 5b 6b 65 72 6e 65 6c 2e  ........[kernel
.  0030:  6b 61 6c 6c 73 79 6d 73 2e 5f 74 65 78 74 5d 00  kallsyms._text]
.
0xd0 [0x40]: PERF_RECORD_MMAP 0/0: [0xffffffff81000000((nil)) @ (nil)]: [kernel.kallsyms._text]
[root@doppio ~]#

I.e. we identify such event as having:

 .pid      = 0
 .filename = [kernel.kallsyms.REFNAME]
 .start    = REFNAME addr in /proc/kallsyms at 'perf record' time

and use now a hardcoded value of '.text' for REFNAME.

Then, later, in 'perf report', if there are any kernel hits and thus we need to
resolve kernel symbols, we search for REFNAME and if its address changed,
relocation happened and we thus must change the kernel mapping routines to one
that uses .pgoff as the relocation to apply.

This way we use the same mechanism used for the other DSOs and don't have to do
a two pass in all the kernel symbols.

Reported-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    7 +++++
 tools/perf/util/event.c     |   64 +++++++++++++++++++++++++++++++++++++++++--
 tools/perf/util/event.h     |    4 +++
 tools/perf/util/session.c   |   46 +++++++++++++++++++++++++++++++
 tools/perf/util/session.h   |   10 +++++++
 tools/perf/util/symbol.c    |    7 +++-
 6 files changed, 133 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2654253..8f88420 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -551,6 +551,13 @@ static int __cmd_record(int argc, const char **argv)
 			return err;
 	}
 
+	err = event__synthesize_kernel_mmap(process_synthesized_event,
+					    session, "_text");
+	if (err < 0) {
+		pr_err("Couldn't record kernel reference relocation symbol.\n");
+		return err;
+	}
+
 	if (!system_wide && profile_cpu == -1)
 		event__synthesize_thread(pid, process_synthesized_event,
 					 session);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index bb0fd6d..1a31feb 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -189,6 +189,50 @@ void event__synthesize_threads(int (*process)(event_t *event,
 	closedir(proc);
 }
 
+struct process_symbol_args {
+	const char *name;
+	u64	   start;
+};
+
+static int find_symbol_cb(void *arg, const char *name, char type, u64 start)
+{
+	struct process_symbol_args *args = arg;
+
+	if (!symbol_type__is_a(type, MAP__FUNCTION) || strcmp(name, args->name))
+		return 0;
+
+	args->start = start;
+	return 1;
+}
+
+int event__synthesize_kernel_mmap(int (*process)(event_t *event,
+						 struct perf_session *session),
+				  struct perf_session *session,
+				  const char *symbol_name)
+{
+	size_t size;
+	event_t ev = {
+		.header = { .type = PERF_RECORD_MMAP },
+	};
+	/*
+	 * We should get this from /sys/kernel/sections/.text, but till that is
+	 * available use this, and after it is use this as a fallback for older
+	 * kernels.
+	 */
+	struct process_symbol_args args = { .name = symbol_name, };
+
+	if (kallsyms__parse(&args, find_symbol_cb) <= 0)
+		return -ENOENT;
+
+	size = snprintf(ev.mmap.filename, sizeof(ev.mmap.filename),
+			"[kernel.kallsyms.%s]", symbol_name) + 1;
+	size = ALIGN(size, sizeof(u64));
+	ev.mmap.header.size = (sizeof(ev.mmap) - (sizeof(ev.mmap.filename) - size));
+	ev.mmap.start = args.start;
+
+	return process(&ev, session);
+}
+
 static void thread__comm_adjust(struct thread *self)
 {
 	char *comm = self->comm;
@@ -240,9 +284,9 @@ int event__process_lost(event_t *self, struct perf_session *session)
 
 int event__process_mmap(event_t *self, struct perf_session *session)
 {
-	struct thread *thread = perf_session__findnew(session, self->mmap.pid);
-	struct map *map = map__new(&self->mmap, MAP__FUNCTION,
-				   session->cwd, session->cwdlen);
+	struct thread *thread;
+	struct map *map;
+	static const char kmmap_prefix[] = "[kernel.kallsyms.";
 
 	dump_printf(" %d/%d: [%p(%p) @ %p]: %s\n",
 		    self->mmap.pid, self->mmap.tid,
@@ -251,6 +295,20 @@ int event__process_mmap(event_t *self, struct perf_session *session)
 		    (void *)(long)self->mmap.pgoff,
 		    self->mmap.filename);
 
+	if (self->mmap.pid == 0 &&
+	    memcmp(self->mmap.filename, kmmap_prefix,
+		   sizeof(kmmap_prefix) - 1) == 0) {
+		const char *symbol_name = (self->mmap.filename +
+					   sizeof(kmmap_prefix) - 1);
+		perf_session__set_kallsyms_ref_reloc_sym(session, symbol_name,
+							 self->mmap.start);
+		return 0;
+	}
+
+	thread = perf_session__findnew(session, self->mmap.pid);
+	map = map__new(&self->mmap, MAP__FUNCTION,
+		       session->cwd, session->cwdlen);
+
 	if (thread == NULL || map == NULL)
 		dump_printf("problem processing PERF_RECORD_MMAP, skipping event.\n");
 	else
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 80fb365..61fc0dc 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -110,6 +110,10 @@ int event__synthesize_thread(pid_t pid,
 void event__synthesize_threads(int (*process)(event_t *event,
 					      struct perf_session *session),
 			       struct perf_session *session);
+int event__synthesize_kernel_mmap(int (*process)(event_t *event,
+						 struct perf_session *session),
+				  struct perf_session *session,
+				  const char *symbol_name);
 
 int event__process_comm(event_t *self, struct perf_session *session);
 int event__process_lost(event_t *self, struct perf_session *session);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7f0537d..e0e6a07 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -401,3 +401,49 @@ bool perf_session__has_traces(struct perf_session *self, const char *msg)
 
 	return true;
 }
+
+int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
+					     const char *symbol_name,
+					     u64 addr)
+{
+	char *bracket;
+
+	self->ref_reloc_sym.name = strdup(symbol_name);
+	if (self->ref_reloc_sym.name == NULL)
+		return -ENOMEM;
+
+	bracket = strchr(self->ref_reloc_sym.name, ']');
+	if (bracket)
+		*bracket = '\0';
+
+	self->ref_reloc_sym.addr = addr;
+	return 0;
+}
+
+static u64 map__reloc_map_ip(struct map *map, u64 ip)
+{
+	return ip + (s64)map->pgoff;
+}
+
+static u64 map__reloc_unmap_ip(struct map *map, u64 ip)
+{
+	return ip - (s64)map->pgoff;
+}
+
+void perf_session__reloc_vmlinux_maps(struct perf_session *self,
+				      u64 unrelocated_addr)
+{
+	enum map_type type;
+	s64 reloc = unrelocated_addr - self->ref_reloc_sym.addr;
+
+	if (!reloc)
+		return;
+
+	for (type = 0; type < MAP__NR_TYPES; ++type) {
+		struct map *map = self->vmlinux_maps[type];
+
+		map->map_ip = map__reloc_map_ip;
+		map->unmap_ip = map__reloc_unmap_ip;
+		map->pgoff = reloc;
+	}
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8db37bb..d4a9d20 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -24,6 +24,10 @@ struct perf_session {
 	unsigned long		unknown_events;
 	struct rb_root		hists;
 	u64			sample_type;
+	struct {
+		const char	*name;
+		u64		addr;
+	}			ref_reloc_sym;
 	int			fd;
 	int			cwdlen;
 	char			*cwd;
@@ -59,4 +63,10 @@ bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 int perf_header__read_build_ids(int input, u64 offset, u64 file_size);
 
+int perf_session__set_kallsyms_ref_reloc_sym(struct perf_session *self,
+					     const char *symbol_name,
+					     u64 addr);
+void perf_session__reloc_vmlinux_maps(struct perf_session *self,
+				      u64 unrelocated_addr);
+
 #endif /* __PERF_SESSION_H */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e290429..da2f07f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -956,11 +956,15 @@ static int dso__load_sym(struct dso *self, struct map *map,
 
 	elf_symtab__for_each_symbol(syms, nr_syms, idx, sym) {
 		struct symbol *f;
-		const char *elf_name;
+		const char *elf_name = elf_sym__name(&sym, symstrs);
 		char *demangled = NULL;
 		int is_label = elf_sym__is_label(&sym);
 		const char *section_name;
 
+		if (kernel && session->ref_reloc_sym.name != NULL &&
+		    strcmp(elf_name, session->ref_reloc_sym.name) == 0)
+			perf_session__reloc_vmlinux_maps(session, sym.st_value);
+
 		if (!is_label && !elf_sym__is_a(&sym, map->type))
 			continue;
 
@@ -973,7 +977,6 @@ static int dso__load_sym(struct dso *self, struct map *map,
 		if (is_label && !elf_sec__is_a(&shdr, secstrs, map->type))
 			continue;
 
-		elf_name = elf_sym__name(&sym, symstrs);
 		section_name = elf_sec__name(&shdr, secstrs);
 
 		if (kernel || kmodule) {
-- 
1.6.2.5

