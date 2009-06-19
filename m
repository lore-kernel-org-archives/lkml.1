Return-Path: <linux-kernel-owner+w=401wt.eu-S1757599AbZFSMY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbZFSMY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 08:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbZFSMYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 08:24:49 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:53613 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491AbZFSMYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 08:24:45 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19003.33494.495844.956580@cargo.ozlabs.ibm.com>
Date: Fri, 19 Jun 2009 22:21:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, benh@kernel.crashing.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: tools: Define and use our own u64, s64 etc. definitions
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64-bit powerpc, __u64 is defined to be unsigned long rather than
unsigned long long.  This causes compiler warnings every time we
print a __u64 value with %Lx.

Rather than changing __u64, we define our own u64 to be unsigned long
long on all architectures, and similarly s64 as signed long long.
For consistency we also define u32, s32, u16, s16, u8 and s8.  These
definitions are put in a new header, types.h, because these definitions
are needed in util/string.h and util/symbol.h.

The main change here is the mechanical change of __[us]{64,32,16,8}
to remove the "__".  The other changes are:

* Create types.h
* Include types.h in perf.h, util/string.h and util/symbol.h
* Add types.h to the LIB_H definition in Makefile
* Added (u64) casts in process_overflow_event() and print_sym_table()
  to kill two remaining warnings.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 tools/perf/Makefile            |    1 +
 tools/perf/builtin-annotate.c  |   66 ++++++++++++++++----------------
 tools/perf/builtin-record.c    |   20 +++++-----
 tools/perf/builtin-report.c    |   80 ++++++++++++++++++++--------------------
 tools/perf/builtin-stat.c      |   62 +++++++++++++++---------------
 tools/perf/builtin-top.c       |   24 ++++++------
 tools/perf/perf.h              |    1 +
 tools/perf/types.h             |   17 ++++++++
 tools/perf/util/parse-events.c |   10 ++--
 tools/perf/util/string.c       |    2 +-
 tools/perf/util/string.h       |    4 +-
 tools/perf/util/symbol.c       |   20 +++++-----
 tools/perf/util/symbol.h       |   15 ++++---
 13 files changed, 171 insertions(+), 151 deletions(-)
 create mode 100644 tools/perf/types.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 672c5f0..36d7eef 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -290,6 +290,7 @@ LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
 LIB_H += perf.h
+LIB_H += types.h
 LIB_H += util/list.h
 LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 94cea67..7e58e3a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -50,35 +50,35 @@ static unsigned long	mmap_window = 32;
 
 struct ip_event {
 	struct perf_event_header header;
-	__u64 ip;
-	__u32 pid, tid;
+	u64 ip;
+	u32 pid, tid;
 };
 
 struct mmap_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
-	__u64 start;
-	__u64 len;
-	__u64 pgoff;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
 	char filename[PATH_MAX];
 };
 
 struct comm_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
+	u32 pid, tid;
 	char comm[16];
 };
 
 struct fork_event {
 	struct perf_event_header header;
-	__u32 pid, ppid;
+	u32 pid, ppid;
 };
 
 struct period_event {
 	struct perf_event_header header;
-	__u64 time;
-	__u64 id;
-	__u64 sample_period;
+	u64 time;
+	u64 id;
+	u64 sample_period;
 };
 
 typedef union event_union {
@@ -158,7 +158,7 @@ static void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-static struct symbol *vdso__find_symbol(struct dso *dso, __u64 ip)
+static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
 	return dso__find_symbol(kernel_dso, ip);
 }
@@ -191,19 +191,19 @@ static int load_kernel(void)
 
 struct map {
 	struct list_head node;
-	__u64	 start;
-	__u64	 end;
-	__u64	 pgoff;
-	__u64	 (*map_ip)(struct map *, __u64);
+	u64	 start;
+	u64	 end;
+	u64	 pgoff;
+	u64	 (*map_ip)(struct map *, u64);
 	struct dso	 *dso;
 };
 
-static __u64 map__map_ip(struct map *map, __u64 ip)
+static u64 map__map_ip(struct map *map, u64 ip)
 {
 	return ip - map->start + map->pgoff;
 }
 
-static __u64 vdso__map_ip(struct map *map, __u64 ip)
+static u64 vdso__map_ip(struct map *map, u64 ip)
 {
 	return ip;
 }
@@ -386,7 +386,7 @@ static int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-static struct map *thread__find_map(struct thread *self, __u64 ip)
+static struct map *thread__find_map(struct thread *self, u64 ip)
 {
 	struct map *pos;
 
@@ -427,7 +427,7 @@ struct hist_entry {
 	struct map	 *map;
 	struct dso	 *dso;
 	struct symbol	 *sym;
-	__u64	 ip;
+	u64	 ip;
 	char		 level;
 
 	uint32_t	 count;
@@ -532,7 +532,7 @@ sort__dso_print(FILE *fp, struct hist_entry *self)
 	if (self->dso)
 		return fprintf(fp, "%-25s", self->dso->name);
 
-	return fprintf(fp, "%016llx         ", (__u64)self->ip);
+	return fprintf(fp, "%016llx         ", (u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
@@ -546,7 +546,7 @@ static struct sort_entry sort_dso = {
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	__u64 ip_l, ip_r;
+	u64 ip_l, ip_r;
 
 	if (left->sym == right->sym)
 		return 0;
@@ -563,13 +563,13 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "%#018llx  ", (__u64)self->ip);
+		ret += fprintf(fp, "%#018llx  ", (u64)self->ip);
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
 			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
 	} else {
-		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
+		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
 
 	return ret;
@@ -660,7 +660,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 /*
  * collect histogram counts
  */
-static void hist_hit(struct hist_entry *he, __u64 ip)
+static void hist_hit(struct hist_entry *he, u64 ip)
 {
 	unsigned int sym_size, offset;
 	struct symbol *sym = he->sym;
@@ -689,7 +689,7 @@ static void hist_hit(struct hist_entry *he, __u64 ip)
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, char level)
+		struct symbol *sym, u64 ip, char level)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -861,7 +861,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	int show = 0;
 	struct dso *dso = NULL;
 	struct thread *thread = threads__findnew(event->ip.pid);
-	__u64 ip = event->ip.ip;
+	u64 ip = event->ip.ip;
 	struct map *map = NULL;
 
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p\n",
@@ -1062,14 +1062,14 @@ static char *get_color(double percent)
 }
 
 static int
-parse_line(FILE *file, struct symbol *sym, __u64 start, __u64 len)
+parse_line(FILE *file, struct symbol *sym, u64 start, u64 len)
 {
 	char *line = NULL, *tmp, *tmp2;
 	static const char *prev_line;
 	static const char *prev_color;
 	unsigned int offset;
 	size_t line_len;
-	__u64 line_ip;
+	u64 line_ip;
 	int ret;
 	char *c;
 
@@ -1191,7 +1191,7 @@ static void free_source_line(struct symbol *sym, int len)
 
 /* Get the filename:line for the colored entries */
 static void
-get_source_line(struct symbol *sym, __u64 start, int len, char *filename)
+get_source_line(struct symbol *sym, u64 start, int len, char *filename)
 {
 	int i;
 	char cmd[PATH_MAX * 2];
@@ -1209,7 +1209,7 @@ get_source_line(struct symbol *sym, __u64 start, int len, char *filename)
 	for (i = 0; i < len; i++) {
 		char *path = NULL;
 		size_t line_len;
-		__u64 offset;
+		u64 offset;
 		FILE *fp;
 
 		sym_ext[i].percent = 100.0 * sym->hist[i] / sym->hist_sum;
@@ -1269,7 +1269,7 @@ static void print_summary(char *filename)
 static void annotate_sym(struct dso *dso, struct symbol *sym)
 {
 	char *filename = dso->name;
-	__u64 start, end, len;
+	u64 start, end, len;
 	char command[PATH_MAX*2];
 	FILE *file;
 
@@ -1297,7 +1297,7 @@ static void annotate_sym(struct dso *dso, struct symbol *sym)
 	if (verbose >= 2)
 		printf("annotating [%p] %30s : [%p] %30s\n", dso, dso->name, sym, sym->name);
 
-	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (__u64)start, (__u64)end, filename);
+	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", (u64)start, (u64)end, filename);
 
 	if (verbose >= 3)
 		printf("doing: %s\n", command);
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 06fdfb8..5092991 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -44,7 +44,7 @@ static long			samples;
 static struct timeval		last_read;
 static struct timeval		this_read;
 
-static __u64			bytes_written;
+static u64			bytes_written;
 
 static struct pollfd		event_array[MAX_NR_CPUS * MAX_COUNTERS];
 
@@ -53,18 +53,18 @@ static int			nr_cpu;
 
 struct mmap_event {
 	struct perf_event_header	header;
-	__u32				pid;
-	__u32				tid;
-	__u64				start;
-	__u64				len;
-	__u64				pgoff;
+	u32				pid;
+	u32				tid;
+	u64				start;
+	u64				len;
+	u64				pgoff;
 	char				filename[PATH_MAX];
 };
 
 struct comm_event {
 	struct perf_event_header	header;
-	__u32				pid;
-	__u32				tid;
+	u32				pid;
+	u32				tid;
 	char				comm[16];
 };
 
@@ -240,7 +240,7 @@ static void pid_synthesize_comm_event(pid_t pid, int full)
 
 	comm_ev.pid = pid;
 	comm_ev.header.type = PERF_EVENT_COMM;
-	size = ALIGN(size, sizeof(__u64));
+	size = ALIGN(size, sizeof(u64));
 	comm_ev.header.size = sizeof(comm_ev) - (sizeof(comm_ev.comm) - size);
 
 	if (!full) {
@@ -325,7 +325,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(mmap_ev.filename, execname, size);
-			size = ALIGN(size, sizeof(__u64));
+			size = ALIGN(size, sizeof(u64));
 			mmap_ev.len -= mmap_ev.start;
 			mmap_ev.header.size = (sizeof(mmap_ev) -
 					       (sizeof(mmap_ev.filename) - size));
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 86981bd..df373c7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -54,42 +54,42 @@ static int		exclude_other = 1;
 
 struct ip_event {
 	struct perf_event_header header;
-	__u64 ip;
-	__u32 pid, tid;
+	u64 ip;
+	u32 pid, tid;
 	unsigned char __more_data[];
 };
 
 struct mmap_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
-	__u64 start;
-	__u64 len;
-	__u64 pgoff;
+	u32 pid, tid;
+	u64 start;
+	u64 len;
+	u64 pgoff;
 	char filename[PATH_MAX];
 };
 
 struct comm_event {
 	struct perf_event_header header;
-	__u32 pid, tid;
+	u32 pid, tid;
 	char comm[16];
 };
 
 struct fork_event {
 	struct perf_event_header header;
-	__u32 pid, ppid;
+	u32 pid, ppid;
 };
 
 struct period_event {
 	struct perf_event_header header;
-	__u64 time;
-	__u64 id;
-	__u64 sample_period;
+	u64 time;
+	u64 id;
+	u64 sample_period;
 };
 
 struct lost_event {
 	struct perf_event_header header;
-	__u64 id;
-	__u64 lost;
+	u64 id;
+	u64 lost;
 };
 
 typedef union event_union {
@@ -158,7 +158,7 @@ static void dsos__fprintf(FILE *fp)
 		dso__fprintf(pos, fp);
 }
 
-static struct symbol *vdso__find_symbol(struct dso *dso, __u64 ip)
+static struct symbol *vdso__find_symbol(struct dso *dso, u64 ip)
 {
 	return dso__find_symbol(kernel_dso, ip);
 }
@@ -205,19 +205,19 @@ static int strcommon(const char *pathname)
 
 struct map {
 	struct list_head node;
-	__u64	 start;
-	__u64	 end;
-	__u64	 pgoff;
-	__u64	 (*map_ip)(struct map *, __u64);
+	u64	 start;
+	u64	 end;
+	u64	 pgoff;
+	u64	 (*map_ip)(struct map *, u64);
 	struct dso	 *dso;
 };
 
-static __u64 map__map_ip(struct map *map, __u64 ip)
+static u64 map__map_ip(struct map *map, u64 ip)
 {
 	return ip - map->start + map->pgoff;
 }
 
-static __u64 vdso__map_ip(struct map *map, __u64 ip)
+static u64 vdso__map_ip(struct map *map, u64 ip)
 {
 	return ip;
 }
@@ -424,7 +424,7 @@ static int thread__fork(struct thread *self, struct thread *parent)
 	return 0;
 }
 
-static struct map *thread__find_map(struct thread *self, __u64 ip)
+static struct map *thread__find_map(struct thread *self, u64 ip)
 {
 	struct map *pos;
 
@@ -466,10 +466,10 @@ struct hist_entry {
 	struct dso	 *dso;
 	struct symbol	 *sym;
 	struct symbol	 *parent;
-	__u64		 ip;
+	u64		 ip;
 	char		 level;
 
-	__u64		 count;
+	u64		 count;
 };
 
 /*
@@ -569,7 +569,7 @@ sort__dso_print(FILE *fp, struct hist_entry *self)
 	if (self->dso)
 		return fprintf(fp, "%-25s", self->dso->name);
 
-	return fprintf(fp, "%016llx         ", (__u64)self->ip);
+	return fprintf(fp, "%016llx         ", (u64)self->ip);
 }
 
 static struct sort_entry sort_dso = {
@@ -583,7 +583,7 @@ static struct sort_entry sort_dso = {
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	__u64 ip_l, ip_r;
+	u64 ip_l, ip_r;
 
 	if (left->sym == right->sym)
 		return 0;
@@ -600,13 +600,13 @@ sort__sym_print(FILE *fp, struct hist_entry *self)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += fprintf(fp, "%#018llx  ", (__u64)self->ip);
+		ret += fprintf(fp, "%#018llx  ", (u64)self->ip);
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
 			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
 	} else {
-		ret += fprintf(fp, "%#016llx", (__u64)self->ip);
+		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
 
 	return ret;
@@ -740,7 +740,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
-hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
+hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 {
 	struct sort_entry *se;
 	size_t ret;
@@ -788,7 +788,7 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, __u64 total_samples)
 
 static struct symbol *
 resolve_symbol(struct thread *thread, struct map **mapp,
-	       struct dso **dsop, __u64 *ipp)
+	       struct dso **dsop, u64 *ipp)
 {
 	struct dso *dso = dsop ? *dsop : NULL;
 	struct map *map = mapp ? *mapp : NULL;
@@ -850,8 +850,8 @@ static struct symbol *call__match(struct symbol *sym)
 
 static int
 hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
-		struct symbol *sym, __u64 ip, struct perf_callchain_entry *chain,
-		char level, __u64 count)
+		struct symbol *sym, u64 ip, struct perf_callchain_entry *chain,
+		char level, u64 count)
 {
 	struct rb_node **p = &hist.rb_node;
 	struct rb_node *parent = NULL;
@@ -872,7 +872,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		int i, nr = chain->hv;
 		struct symbol *sym;
 		struct dso *dso;
-		__u64 ip;
+		u64 ip;
 
 		for (i = 0; i < chain->kernel; i++) {
 			ip = chain->ip[nr + i];
@@ -1026,7 +1026,7 @@ static void output__resort(void)
 	}
 }
 
-static size_t output__fprintf(FILE *fp, __u64 total_samples)
+static size_t output__fprintf(FILE *fp, u64 total_samples)
 {
 	struct hist_entry *pos;
 	struct sort_entry *se;
@@ -1035,7 +1035,7 @@ static size_t output__fprintf(FILE *fp, __u64 total_samples)
 
 	fprintf(fp, "\n");
 	fprintf(fp, "#\n");
-	fprintf(fp, "# (%Ld samples)\n", (__u64)total_samples);
+	fprintf(fp, "# (%Ld samples)\n", (u64)total_samples);
 	fprintf(fp, "#\n");
 
 	fprintf(fp, "# Overhead");
@@ -1113,7 +1113,7 @@ static int validate_chain(struct perf_callchain_entry *chain, event_t *event)
 	chain_size = event->header.size;
 	chain_size -= (unsigned long)&event->ip.__more_data - (unsigned long)event;
 
-	if (chain->nr*sizeof(__u64) > chain_size)
+	if (chain->nr*sizeof(u64) > chain_size)
 		return -1;
 
 	return 0;
@@ -1126,15 +1126,15 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	int show = 0;
 	struct dso *dso = NULL;
 	struct thread *thread = threads__findnew(event->ip.pid);
-	__u64 ip = event->ip.ip;
-	__u64 period = 1;
+	u64 ip = event->ip.ip;
+	u64 period = 1;
 	struct map *map = NULL;
 	void *more_data = event->ip.__more_data;
 	struct perf_callchain_entry *chain = NULL;
 
 	if (event->header.type & PERF_SAMPLE_PERIOD) {
-		period = *(__u64 *)more_data;
-		more_data += sizeof(__u64);
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
 	}
 
 	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
@@ -1162,7 +1162,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 
 		if (dump_trace) {
 			for (i = 0; i < chain->nr; i++)
-				dprintf("..... %2d: %016Lx\n", i, chain->ip[i]);
+				dprintf("..... %2d: %016Lx\n", i, (u64)chain->ip[i]);
 		}
 	}
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e5b3c0f..6d3eeac 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -85,29 +85,29 @@ static const unsigned int default_count[] = {
 static int			run_count		=  1;
 static int			run_idx			=  0;
 
-static __u64			event_res[MAX_RUN][MAX_COUNTERS][3];
-static __u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
 
-//static __u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
+//static u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
 
 
-static __u64			runtime_nsecs[MAX_RUN];
-static __u64			walltime_nsecs[MAX_RUN];
-static __u64			runtime_cycles[MAX_RUN];
+static u64			runtime_nsecs[MAX_RUN];
+static u64			walltime_nsecs[MAX_RUN];
+static u64			runtime_cycles[MAX_RUN];
 
-static __u64			event_res_avg[MAX_COUNTERS][3];
-static __u64			event_res_noise[MAX_COUNTERS][3];
+static u64			event_res_avg[MAX_COUNTERS][3];
+static u64			event_res_noise[MAX_COUNTERS][3];
 
-static __u64			event_scaled_avg[MAX_COUNTERS];
+static u64			event_scaled_avg[MAX_COUNTERS];
 
-static __u64			runtime_nsecs_avg;
-static __u64			runtime_nsecs_noise;
+static u64			runtime_nsecs_avg;
+static u64			runtime_nsecs_noise;
 
-static __u64			walltime_nsecs_avg;
-static __u64			walltime_nsecs_noise;
+static u64			walltime_nsecs_avg;
+static u64			walltime_nsecs_noise;
 
-static __u64			runtime_cycles_avg;
-static __u64			runtime_cycles_noise;
+static u64			runtime_cycles_avg;
+static u64			runtime_cycles_noise;
 
 static void create_perf_stat_counter(int counter)
 {
@@ -158,7 +158,7 @@ static inline int nsec_counter(int counter)
  */
 static void read_counter(int counter)
 {
-	__u64 *count, single_count[3];
+	u64 *count, single_count[3];
 	ssize_t res;
 	int cpu, nv;
 	int scaled;
@@ -172,8 +172,8 @@ static void read_counter(int counter)
 		if (fd[cpu][counter] < 0)
 			continue;
 
-		res = read(fd[cpu][counter], single_count, nv * sizeof(__u64));
-		assert(res == nv * sizeof(__u64));
+		res = read(fd[cpu][counter], single_count, nv * sizeof(u64));
+		assert(res == nv * sizeof(u64));
 		close(fd[cpu][counter]);
 		fd[cpu][counter] = -1;
 
@@ -251,14 +251,14 @@ static int run_perf_stat(int argc, const char **argv)
 	return WEXITSTATUS(status);
 }
 
-static void print_noise(__u64 *count, __u64 *noise)
+static void print_noise(u64 *count, u64 *noise)
 {
 	if (run_count > 1)
 		fprintf(stderr, "   ( +- %7.3f%% )",
 			(double)noise[0]/(count[0]+1)*100.0);
 }
 
-static void nsec_printout(int counter, __u64 *count, __u64 *noise)
+static void nsec_printout(int counter, u64 *count, u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
@@ -274,7 +274,7 @@ static void nsec_printout(int counter, __u64 *count, __u64 *noise)
 	print_noise(count, noise);
 }
 
-static void abs_printout(int counter, __u64 *count, __u64 *noise)
+static void abs_printout(int counter, u64 *count, u64 *noise)
 {
 	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
 
@@ -298,7 +298,7 @@ static void abs_printout(int counter, __u64 *count, __u64 *noise)
  */
 static void print_counter(int counter)
 {
-	__u64 *count, *noise;
+	u64 *count, *noise;
 	int scaled;
 
 	count = event_res_avg[counter];
@@ -326,16 +326,16 @@ static void print_counter(int counter)
 /*
  * normalize_noise noise values down to stddev:
  */
-static void normalize_noise(__u64 *val)
+static void normalize_noise(u64 *val)
 {
 	double res;
 
 	res = (double)*val / (run_count * sqrt((double)run_count));
 
-	*val = (__u64)res;
+	*val = (u64)res;
 }
 
-static void update_avg(const char *name, int idx, __u64 *avg, __u64 *val)
+static void update_avg(const char *name, int idx, u64 *avg, u64 *val)
 {
 	*avg += *val;
 
@@ -380,19 +380,19 @@ static void calc_avg(void)
 
 	for (i = 0; i < run_count; i++) {
 		runtime_nsecs_noise +=
-			abs((__s64)(runtime_nsecs[i] - runtime_nsecs_avg));
+			abs((s64)(runtime_nsecs[i] - runtime_nsecs_avg));
 		walltime_nsecs_noise +=
-			abs((__s64)(walltime_nsecs[i] - walltime_nsecs_avg));
+			abs((s64)(walltime_nsecs[i] - walltime_nsecs_avg));
 		runtime_cycles_noise +=
-			abs((__s64)(runtime_cycles[i] - runtime_cycles_avg));
+			abs((s64)(runtime_cycles[i] - runtime_cycles_avg));
 
 		for (j = 0; j < nr_counters; j++) {
 			event_res_noise[j][0] +=
-				abs((__s64)(event_res[i][j][0] - event_res_avg[j][0]));
+				abs((s64)(event_res[i][j][0] - event_res_avg[j][0]));
 			event_res_noise[j][1] +=
-				abs((__s64)(event_res[i][j][1] - event_res_avg[j][1]));
+				abs((s64)(event_res[i][j][1] - event_res_avg[j][1]));
 			event_res_noise[j][2] +=
-				abs((__s64)(event_res[i][j][2] - event_res_avg[j][2]));
+				abs((s64)(event_res[i][j][2] - event_res_avg[j][2]));
 		}
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fe338d3..5352b5e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -54,7 +54,7 @@ static int			system_wide			=  0;
 
 static int			default_interval		= 100000;
 
-static __u64			count_filter			=  5;
+static u64			count_filter			=  5;
 static int			print_entries			= 15;
 
 static int			target_pid			= -1;
@@ -79,8 +79,8 @@ static int			dump_symtab;
  * Symbols
  */
 
-static __u64			min_ip;
-static __u64			max_ip = -1ll;
+static u64			min_ip;
+static u64			max_ip = -1ll;
 
 struct sym_entry {
 	struct rb_node		rb_node;
@@ -194,7 +194,7 @@ static void print_sym_table(void)
 		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
 
 	if (nr_counters == 1) {
-		printf("%Ld", attrs[0].sample_period);
+		printf("%Ld", (u64)attrs[0].sample_period);
 		if (freq)
 			printf("Hz ");
 		else
@@ -372,7 +372,7 @@ out_delete_dso:
 /*
  * Binary search in the histogram table and record the hit:
  */
-static void record_ip(__u64 ip, int counter)
+static void record_ip(u64 ip, int counter)
 {
 	struct symbol *sym = dso__find_symbol(kernel_dso, ip);
 
@@ -392,7 +392,7 @@ static void record_ip(__u64 ip, int counter)
 	samples--;
 }
 
-static void process_event(__u64 ip, int counter)
+static void process_event(u64 ip, int counter)
 {
 	samples++;
 
@@ -463,15 +463,15 @@ static void mmap_read_counter(struct mmap_data *md)
 	for (; old != head;) {
 		struct ip_event {
 			struct perf_event_header header;
-			__u64 ip;
-			__u32 pid, target_pid;
+			u64 ip;
+			u32 pid, target_pid;
 		};
 		struct mmap_event {
 			struct perf_event_header header;
-			__u32 pid, target_pid;
-			__u64 start;
-			__u64 len;
-			__u64 pgoff;
+			u32 pid, target_pid;
+			u64 start;
+			u64 len;
+			u64 pgoff;
 			char filename[PATH_MAX];
 		};
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 87a1aca..8c728b8 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -19,6 +19,7 @@
 #include <sys/syscall.h>
 
 #include "../../include/linux/perf_counter.h"
+#include "types.h"
 
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
diff --git a/tools/perf/types.h b/tools/perf/types.h
new file mode 100644
index 0000000..5e75f90
--- /dev/null
+++ b/tools/perf/types.h
@@ -0,0 +1,17 @@
+#ifndef _PERF_TYPES_H
+#define _PERF_TYPES_H
+
+/*
+ * We define u64 as unsigned long long for every architecture
+ * so that we can print it with %Lx without getting warnings.
+ */
+typedef unsigned long long u64;
+typedef signed long long   s64;
+typedef unsigned int	   u32;
+typedef signed int	   s32;
+typedef unsigned short	   u16;
+typedef signed short	   s16;
+typedef unsigned char	   u8;
+typedef signed char	   s8;
+
+#endif /* _PERF_TYPES_H */
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f0c9f26..35d04da 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -13,8 +13,8 @@ int					nr_counters;
 struct perf_counter_attr		attrs[MAX_COUNTERS];
 
 struct event_symbol {
-	__u8	type;
-	__u64	config;
+	u8	type;
+	u64	config;
 	char	*symbol;
 };
 
@@ -96,7 +96,7 @@ static char *hw_cache_result [][MAX_ALIASES] = {
 
 char *event_name(int counter)
 {
-	__u64 config = attrs[counter].config;
+	u64 config = attrs[counter].config;
 	int type = attrs[counter].type;
 	static char buf[32];
 
@@ -112,7 +112,7 @@ char *event_name(int counter)
 		return "unknown-hardware";
 
 	case PERF_TYPE_HW_CACHE: {
-		__u8 cache_type, cache_op, cache_result;
+		u8 cache_type, cache_op, cache_result;
 		static char name[100];
 
 		cache_type   = (config >>  0) & 0xff;
@@ -202,7 +202,7 @@ static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *a
  */
 static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 {
-	__u64 config, id;
+	u64 config, id;
 	int type;
 	unsigned int i;
 	const char *sep, *pstr;
diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index ec33c0c..c93eca9 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -15,7 +15,7 @@ static int hex(char ch)
  * While we find nice hex chars, build a long_val.
  * Return number of chars processed.
  */
-int hex2u64(const char *ptr, __u64 *long_val)
+int hex2u64(const char *ptr, u64 *long_val)
 {
 	const char *p = ptr;
 	*long_val = 0;
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 72812c1..37b0325 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,8 +1,8 @@
 #ifndef _PERF_STRING_H_
 #define _PERF_STRING_H_
 
-#include <linux/types.h>
+#include "../types.h"
 
-int hex2u64(const char *ptr, __u64 *val);
+int hex2u64(const char *ptr, u64 *val);
 
 #endif
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 49a55f8..86e1437 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -9,9 +9,9 @@
 
 const char *sym_hist_filter;
 
-static struct symbol *symbol__new(__u64 start, __u64 len,
+static struct symbol *symbol__new(u64 start, u64 len,
 				  const char *name, unsigned int priv_size,
-				  __u64 obj_start, int verbose)
+				  u64 obj_start, int verbose)
 {
 	size_t namelen = strlen(name) + 1;
 	struct symbol *self = calloc(1, priv_size + sizeof(*self) + namelen);
@@ -21,14 +21,14 @@ static struct symbol *symbol__new(__u64 start, __u64 len,
 
 	if (verbose >= 2)
 		printf("new symbol: %016Lx [%08lx]: %s, hist: %p, obj_start: %p\n",
-			(__u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
+			(u64)start, (unsigned long)len, name, self->hist, (void *)(unsigned long)obj_start);
 
 	self->obj_start= obj_start;
 	self->hist = NULL;
 	self->hist_sum = 0;
 
 	if (sym_hist_filter && !strcmp(name, sym_hist_filter))
-		self->hist = calloc(sizeof(__u64), len);
+		self->hist = calloc(sizeof(u64), len);
 
 	if (priv_size) {
 		memset(self, 0, priv_size);
@@ -89,7 +89,7 @@ static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 {
 	struct rb_node **p = &self->syms.rb_node;
 	struct rb_node *parent = NULL;
-	const __u64 ip = sym->start;
+	const u64 ip = sym->start;
 	struct symbol *s;
 
 	while (*p != NULL) {
@@ -104,7 +104,7 @@ static void dso__insert_symbol(struct dso *self, struct symbol *sym)
 	rb_insert_color(&sym->rb_node, &self->syms);
 }
 
-struct symbol *dso__find_symbol(struct dso *self, __u64 ip)
+struct symbol *dso__find_symbol(struct dso *self, u64 ip)
 {
 	struct rb_node *n;
 
@@ -151,7 +151,7 @@ static int dso__load_kallsyms(struct dso *self, symbol_filter_t filter, int verb
 		goto out_failure;
 
 	while (!feof(file)) {
-		__u64 start;
+		u64 start;
 		struct symbol *sym;
 		int line_len, len;
 		char symbol_type;
@@ -232,7 +232,7 @@ static int dso__load_perf_map(struct dso *self, symbol_filter_t filter, int verb
 		goto out_failure;
 
 	while (!feof(file)) {
-		__u64 start, size;
+		u64 start, size;
 		struct symbol *sym;
 		int line_len, len;
 
@@ -353,7 +353,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, Elf *elf,
 {
 	uint32_t nr_rel_entries, idx;
 	GElf_Sym sym;
-	__u64 plt_offset;
+	u64 plt_offset;
 	GElf_Shdr shdr_plt;
 	struct symbol *f;
 	GElf_Shdr shdr_rel_plt;
@@ -523,7 +523,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
-		__u64 obj_start;
+		u64 obj_start;
 
 		if (!elf_sym__is_function(&sym))
 			continue;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5ad9b06..ea332e5 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -2,16 +2,17 @@
 #define _PERF_SYMBOL_ 1
 
 #include <linux/types.h>
+#include "../types.h"
 #include "list.h"
 #include "rbtree.h"
 
 struct symbol {
 	struct rb_node	rb_node;
-	__u64		start;
-	__u64		end;
-	__u64		obj_start;
-	__u64		hist_sum;
-	__u64		*hist;
+	u64		start;
+	u64		end;
+	u64		obj_start;
+	u64		hist_sum;
+	u64		*hist;
 	void		*priv;
 	char		name[0];
 };
@@ -20,7 +21,7 @@ struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
 	unsigned int	 sym_priv_size;
-	struct symbol    *(*find_symbol)(struct dso *, __u64 ip);
+	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
 	char		 name[0];
 };
 
@@ -36,7 +37,7 @@ static inline void *dso__sym_priv(struct dso *self, struct symbol *sym)
 	return ((void *)sym) - self->sym_priv_size;
 }
 
-struct symbol *dso__find_symbol(struct dso *self, __u64 ip);
+struct symbol *dso__find_symbol(struct dso *self, u64 ip);
 
 int dso__load_kernel(struct dso *self, const char *vmlinux,
 		     symbol_filter_t filter, int verbose);
-- 
1.6.0.4

