Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZKHKEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZKHKEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 05:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZKHKEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 05:04:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:42358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZKHKES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 05:04:18 -0500
Date: Sun, 8 Nov 2009 10:03:34 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: acme@redhat.com, mingo@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, roland@redhat.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, acme@redhat.com, peterz@infradead.org,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       jbaron@redhat.com, mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, roland@redhat.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <1257367843-26224-1-git-send-email-acme@infradead.org>
References: <1257367843-26224-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Use the buildids if present
Message-ID: <tip-8d06367fa79c053a4a56a2ce0bb9e840f5da1236@git.kernel.org>
Git-Commit-ID: 8d06367fa79c053a4a56a2ce0bb9e840f5da1236
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d06367fa79c053a4a56a2ce0bb9e840f5da1236
Gitweb:     http://git.kernel.org/tip/8d06367fa79c053a4a56a2ce0bb9e840f5da1236
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Nov 2009 18:50:43 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 10:44:36 +0100

perf symbols: Use the buildids if present

With this change 'perf record' will intercept PERF_RECORD_MMAP
calls, creating a linked list of DSOs, then when the session
finishes, it will traverse this list and read the buildids,
stashing them at the end of the file and will set up a new
feature bit in the header bitmask.

'perf report' will then notice this feature and populate the
'dsos' list and set the build ids.

When reading the symtabs it will refuse to load from a file that
doesn't have the same build id. This improves the
reliability of the profiler output, as symbols and profiling
data is more guaranteed to match.

Example:

 [root@doppio ~]# perf report | head
 /home/acme/bin/perf with build id b1ea544ac3746e7538972548a09aadecc5753868 not found, continuing without symbols
  # Samples: 2621434559
  #
  # Overhead          Command                  Shared Object  Symbol
  # ........  ...............  .............................  ......
  #
       7.91%             init  [kernel]        [k] read_hpet
       7.64%             init  [kernel]        [k] mwait_idle_with_hints
       7.60%          swapper  [kernel]        [k] read_hpet
       7.60%          swapper  [kernel]        [k] mwait_idle_with_hints
       3.65%             init  [kernel]        [k] 0xffffffffa02339d9
[root@doppio ~]#

In this case the 'perf' binary was an older one, vanished,
so its symbols probably wouldn't match or would cause subtly
different (and misleading) output.

Next patches will support the kernel as well, reading the build
id notes for it and the modules from /sys.

Another patch should also introduce a new plumbing command:

'perf list-buildids'

that will then be used in porcelain that is distro specific to
fetch -debuginfo packages where such buildids are present. This
will in turn allow for one to run 'perf record' in one machine
and 'perf report' in another.

Future work on having the buildid sent directly from the kernel
in the PERF_RECORD_MMAP event is needed to close races, as the
DSO can be changed during a 'perf record' session, but this
patch at least helps with non-corner cases and current/older
kernels.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: K. Prasad <prasad@linux.vnet.ibm.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1257367843-26224-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   49 +++++++++++++++++++++++++--
 tools/perf/util/data_map.c  |   37 ++++++++++++++++++++
 tools/perf/util/event.h     |    7 ++++
 tools/perf/util/header.c    |   10 +++++
 tools/perf/util/header.h    |    4 ++
 tools/perf/util/map.c       |   14 +++++++-
 tools/perf/util/symbol.c    |   78 +++++++++++++++++++++++++++++++------------
 tools/perf/util/symbol.h    |   10 ++++--
 8 files changed, 179 insertions(+), 30 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 4a73d89..ab33381 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -17,6 +17,7 @@
 #include "util/header.h"
 #include "util/event.h"
 #include "util/debug.h"
+#include "util/symbol.h"
 
 #include <unistd.h>
 #include <sched.h>
@@ -109,9 +110,21 @@ static void write_output(void *buf, size_t size)
 	}
 }
 
+static void write_event(event_t *buf, size_t size)
+{
+	/*
+	* Add it to the list of DSOs, so that when we finish this
+	 * record session we can pick the available build-ids.
+	 */
+	if (buf->header.type == PERF_RECORD_MMAP)
+		dsos__findnew(buf->mmap.filename);
+
+	write_output(buf, size);
+}
+
 static int process_synthesized_event(event_t *event)
 {
-	write_output(event, event->header.size);
+	write_event(event, event->header.size);
 	return 0;
 }
 
@@ -163,14 +176,14 @@ static void mmap_read(struct mmap_data *md)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		write_output(buf, size);
+		write_event(buf, size);
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
 
-	write_output(buf, size);
+	write_event(buf, size);
 
 	md->prev = old;
 	mmap_write_tail(md, old);
@@ -365,10 +378,38 @@ static void open_counters(int cpu, pid_t pid)
 	nr_cpu++;
 }
 
+static bool write_buildid_table(void)
+{
+	struct dso *pos;
+	bool have_buildid = false;
+
+	list_for_each_entry(pos, &dsos, node) {
+		struct build_id_event b;
+		size_t len;
+
+		if (filename__read_build_id(pos->long_name,
+					    &b.build_id,
+					    sizeof(b.build_id)) < 0)
+			continue;
+		have_buildid = true;
+		memset(&b.header, 0, sizeof(b.header));
+		len = strlen(pos->long_name) + 1;
+		len = ALIGN(len, 64);
+		b.header.size = sizeof(b) + len;
+		write_output(&b, sizeof(b));
+		write_output(pos->long_name, len);
+	}
+
+	return have_buildid;
+}
+
 static void atexit_header(void)
 {
 	header->data_size += bytes_written;
 
+	if (write_buildid_table())
+		perf_header__set_feat(header, HEADER_BUILD_ID);
+
 	perf_header__write(header, output);
 }
 
@@ -572,6 +613,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int counter;
 
+	symbol__init(0);
+
 	argc = parse_options(argc, argv, options, record_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
 	if (!argc && target_pid == -1 && !system_wide)
diff --git a/tools/perf/util/data_map.c b/tools/perf/util/data_map.c
index c458db9..00a9c11 100644
--- a/tools/perf/util/data_map.c
+++ b/tools/perf/util/data_map.c
@@ -70,6 +70,39 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	}
 }
 
+static int perf_header__read_build_ids(const struct perf_header *self,
+				       int input, off_t file_size)
+{
+	off_t offset = self->data_offset + self->data_size;
+	struct build_id_event bev;
+	char filename[PATH_MAX];
+	int err = -1;
+
+	if (lseek(input, offset, SEEK_SET) < 0)
+		return -1;
+
+	while (offset < file_size) {
+		struct dso *dso;
+		ssize_t len;
+
+		if (read(input, &bev, sizeof(bev)) != sizeof(bev))
+			goto out;
+
+		len = bev.header.size - sizeof(bev);
+		if (read(input, filename, len) != len)
+			goto out;
+
+		dso = dsos__findnew(filename);
+		if (dso != NULL)
+			dso__set_build_id(dso, &bev.build_id);
+
+		offset += bev.header.size;
+	}
+	err = 0;
+out:
+	return err;
+}
+
 int mmap_dispatch_perf_file(struct perf_header **pheader,
 			    const char *input_name,
 			    int force,
@@ -130,6 +163,10 @@ int mmap_dispatch_perf_file(struct perf_header **pheader,
 		if (curr_handler->sample_type_check(sample_type) < 0)
 			exit(-1);
 
+	if (perf_header__has_feat(header, HEADER_BUILD_ID) &&
+	    perf_header__read_build_ids(header, input, input_stat.st_size))
+		pr_debug("failed to read buildids, continuing...\n");
+
 	if (load_kernel(NULL) < 0) {
 		perror("failed to load kernel symbols");
 		return EXIT_FAILURE;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 0a443be..34c6fcb 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -61,6 +61,13 @@ struct sample_event{
 	u64 array[];
 };
 
+#define BUILD_ID_SIZE 20
+
+struct build_id_event {
+	struct perf_event_header header;
+	u8			 build_id[ALIGN(BUILD_ID_SIZE, sizeof(u64))];
+	char			 filename[];
+};
 
 typedef union event_union {
 	struct perf_event_header	header;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7d26659..050f543 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -149,6 +149,16 @@ void perf_header__feat_trace_info(struct perf_header *header)
 	set_bit(HEADER_TRACE_INFO, header->adds_features);
 }
 
+void perf_header__set_feat(struct perf_header *self, int feat)
+{
+	set_bit(feat, self->adds_features);
+}
+
+bool perf_header__has_feat(const struct perf_header *self, int feat)
+{
+	return test_bit(feat, self->adds_features);
+}
+
 static void do_write(int fd, void *buf, size_t size)
 {
 	while (size) {
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 2ea9dfb..2f233c5 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -3,6 +3,7 @@
 
 #include "../../../include/linux/perf_event.h"
 #include <sys/types.h>
+#include <stdbool.h>
 #include "types.h"
 
 #include <linux/bitmap.h>
@@ -15,6 +16,7 @@ struct perf_header_attr {
 };
 
 #define HEADER_TRACE_INFO			1
+#define HEADER_BUILD_ID				2
 
 #define HEADER_FEAT_BITS			256
 
@@ -48,6 +50,8 @@ u64 perf_header__sample_type(struct perf_header *header);
 struct perf_event_attr *
 perf_header__find_attr(u64 id, struct perf_header *header);
 void perf_header__feat_trace_info(struct perf_header *header);
+void perf_header__set_feat(struct perf_header *self, int feat);
+bool perf_header__has_feat(const struct perf_header *self, int feat);
 
 struct perf_header *perf_header__new(void);
 
diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 33f8684..94ca950 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -84,8 +84,18 @@ map__find_symbol(struct map *self, u64 ip, symbol_filter_t filter)
 		int nr = dso__load(self->dso, self, filter);
 
 		if (nr < 0) {
-			pr_warning("Failed to open %s, continuing without symbols\n",
-				   self->dso->long_name);
+			if (self->dso->has_build_id) {
+				char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+				build_id__sprintf(self->dso->build_id,
+						  sizeof(self->dso->build_id),
+						  sbuild_id);
+				pr_warning("%s with build id %s not found",
+					   self->dso->long_name, sbuild_id);
+			} else
+				pr_warning("Failed to open %s",
+					   self->dso->long_name);
+			pr_warning(", continuing without symbols\n");
 			return NULL;
 		} else if (nr == 0) {
 			const char *name = self->dso->long_name;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e7c7cdb..a2e95ce 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -121,7 +121,8 @@ struct dso *dso__new(const char *name)
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
 		self->origin = DSO__ORIG_NOT_FOUND;
-		self->loaded = false;
+		self->loaded = 0;
+		self->has_build_id = 0;
 	}
 
 	return self;
@@ -148,6 +149,12 @@ void dso__delete(struct dso *self)
 	free(self);
 }
 
+void dso__set_build_id(struct dso *self, void *build_id)
+{
+	memcpy(self->build_id, build_id, sizeof(self->build_id));
+	self->has_build_id = 1;
+}
+
 static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 {
 	struct rb_node **p = &self->syms.rb_node;
@@ -190,11 +197,30 @@ struct symbol *dso__find_symbol(struct dso *self, u64 ip)
 	return NULL;
 }
 
-size_t dso__fprintf(struct dso *self, FILE *fp)
+int build_id__sprintf(u8 *self, int len, char *bf)
 {
-	size_t ret = fprintf(fp, "dso: %s\n", self->short_name);
+	char *bid = bf;
+	u8 *raw = self;
+	int i;
 
+	for (i = 0; i < len; ++i) {
+		sprintf(bid, "%02x", *raw);
+		++raw;
+		bid += 2;
+	}
+
+	return raw - self;
+}
+
+size_t dso__fprintf(struct dso *self, FILE *fp)
+{
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
 	struct rb_node *nd;
+	size_t ret;
+
+	build_id__sprintf(self->build_id, sizeof(self->build_id), sbuild_id);
+	ret = fprintf(fp, "dso: %s (%s)\n", self->short_name, sbuild_id);
+
 	for (nd = rb_first(&self->syms); nd; nd = rb_next(nd)) {
 		struct symbol *pos = rb_entry(nd, struct symbol, rb_node);
 		ret += symbol__fprintf(pos, fp);
@@ -825,8 +851,6 @@ out_close:
 	return err;
 }
 
-#define BUILD_ID_SIZE 20
-
 int filename__read_build_id(const char *filename, void *bf, size_t size)
 {
 	int fd, err = -1;
@@ -845,7 +869,7 @@ int filename__read_build_id(const char *filename, void *bf, size_t size)
 
 	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
-		pr_err("%s: cannot read %s ELF file.\n", __func__, filename);
+		pr_debug2("%s: cannot read %s ELF file.\n", __func__, filename);
 		goto out_close;
 	}
 
@@ -874,9 +898,9 @@ out:
 
 static char *dso__read_build_id(struct dso *self)
 {
-	int i, len;
-	char *build_id = NULL, *bid;
-	unsigned char rawbf[BUILD_ID_SIZE], *raw;
+	int len;
+	char *build_id = NULL;
+	unsigned char rawbf[BUILD_ID_SIZE];
 
 	len = filename__read_build_id(self->long_name, rawbf, sizeof(rawbf));
 	if (len < 0)
@@ -885,15 +909,8 @@ static char *dso__read_build_id(struct dso *self)
 	build_id = malloc(len * 2 + 1);
 	if (build_id == NULL)
 		goto out;
-	bid = build_id;
 
-	raw = rawbf;
-	for (i = 0; i < len; ++i) {
-		sprintf(bid, "%02x", *raw);
-		++raw;
-		bid += 2;
-	}
-	pr_debug2("%s(%s): %s\n", __func__, self->long_name, build_id);
+	build_id__sprintf(rawbf, len, build_id);
 out:
 	return build_id;
 }
@@ -922,7 +939,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	int ret = -1;
 	int fd;
 
-	self->loaded = true;
+	self->loaded = 1;
 
 	if (!name)
 		return -1;
@@ -940,6 +957,8 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 
 more:
 	do {
+		int berr = 0;
+
 		self->origin++;
 		switch (self->origin) {
 		case DSO__ORIG_FEDORA:
@@ -956,8 +975,7 @@ more:
 				snprintf(name, size,
 					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
 					build_id, build_id + 2);
-				free(build_id);
-				break;
+				goto compare_build_id;
 			}
 			self->origin++;
 			/* Fall thru */
@@ -969,6 +987,22 @@ more:
 			goto out;
 		}
 
+		if (self->has_build_id) {
+			bool match;
+			build_id = malloc(BUILD_ID_SIZE);
+			if (build_id == NULL)
+				goto more;
+			berr = filename__read_build_id(name, build_id,
+						       BUILD_ID_SIZE);
+compare_build_id:
+			match = berr > 0 && memcmp(build_id, self->build_id,
+						   sizeof(self->build_id)) == 0;
+			free(build_id);
+			build_id = NULL;
+			if (!match)
+				goto more;
+		}
+
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
 
@@ -1034,7 +1068,7 @@ static int dso__load_module_sym(struct dso *self, struct map *map,
 {
 	int err = 0, fd = open(self->long_name, O_RDONLY);
 
-	self->loaded = true;
+	self->loaded = 1;
 
 	if (fd < 0) {
 		pr_err("%s: cannot open %s\n", __func__, self->long_name);
@@ -1225,7 +1259,7 @@ static int dso__load_vmlinux(struct dso *self, struct map *map,
 {
 	int err, fd = open(vmlinux, O_RDONLY);
 
-	self->loaded = true;
+	self->loaded = 1;
 
 	if (fd < 0)
 		return -1;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index e0d4a58..f8c1899 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -60,10 +60,12 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
-	unsigned char	 adjust_symbols;
-	unsigned char	 slen_calculated;
-	bool		 loaded;
+	u8		 adjust_symbols:1;
+	u8		 slen_calculated:1;
+	u8		 loaded:1;
+	u8		 has_build_id:1;
 	unsigned char	 origin;
+	u8		 build_id[BUILD_ID_SIZE];
 	const char	 *short_name;
 	char	 	 *long_name;
 	char		 name[0];
@@ -81,8 +83,10 @@ void dsos__fprintf(FILE *fp);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
 char dso__symtab_origin(const struct dso *self);
+void dso__set_build_id(struct dso *self, void *build_id);
 
 int filename__read_build_id(const char *filename, void *bf, size_t size);
+int build_id__sprintf(u8 *self, int len, char *bf);
 
 int load_kernel(symbol_filter_t filter);
 
