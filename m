Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbZHFTxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbZHFTxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbZHFTxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:53:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41563 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416AbZHFTxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:53:45 -0400
Date: Thu, 6 Aug 2009 21:53:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters fixes
Message-ID: <20090806195334.GA22054@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      perf report: Add missing command line options to man page
      perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink

Benjamin Herrenschmidt (1):
      perf_counter/powerpc: Check oprofile_cpu_type for NULL before using it

Pekka Enberg (1):
      perf report: Make --sort comm,dso,symbol the default

Peter Zijlstra (4):
      perf: Auto-detect libbfd
      ftrace: Fix perf-tracepoint OOPS
      perf: Auto-detect libelf
      perf_counter: Fix double list iteration in per task precise stats


 arch/powerpc/kernel/mpc7450-pmu.c        |    3 +-
 arch/powerpc/kernel/power4-pmu.c         |    3 +-
 arch/powerpc/kernel/power5+-pmu.c        |    5 +-
 arch/powerpc/kernel/power5-pmu.c         |    3 +-
 arch/powerpc/kernel/power6-pmu.c         |    3 +-
 arch/powerpc/kernel/power7-pmu.c         |    3 +-
 arch/powerpc/kernel/ppc970-pmu.c         |    5 +-
 include/linux/ftrace_event.h             |    8 +--
 kernel/perf_counter.c                    |    2 +-
 kernel/trace/trace_event_profile.c       |    2 +-
 kernel/trace/trace_events.c              |    2 +-
 tools/perf/Documentation/perf-record.txt |   60 ++++++++++++++++++++-
 tools/perf/Makefile                      |   29 +++++++++-
 tools/perf/builtin-report.c              |    4 +-
 tools/perf/util/symbol.c                 |   85 ++++++++++++++++++++++++++++-
 15 files changed, 189 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
index c244133..cc466d0 100644
--- a/arch/powerpc/kernel/mpc7450-pmu.c
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -407,7 +407,8 @@ struct power_pmu mpc7450_pmu = {
 
 static int init_mpc7450_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc/7450"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc/7450"))
 		return -ENODEV;
 
 	return register_power_pmu(&mpc7450_pmu);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index db90b0c..3c90a3d 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -606,7 +606,8 @@ static struct power_pmu power4_pmu = {
 
 static int init_power4_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power4"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power4"))
 		return -ENODEV;
 
 	return register_power_pmu(&power4_pmu);
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index f4adca8..31918af 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -678,8 +678,9 @@ static struct power_pmu power5p_pmu = {
 
 static int init_power5p_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5+")
-	    && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5++"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5+")
+	     && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5++")))
 		return -ENODEV;
 
 	return register_power_pmu(&power5p_pmu);
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 29b2c6c..867f6f6 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -618,7 +618,8 @@ static struct power_pmu power5_pmu = {
 
 static int init_power5_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power5"))
 		return -ENODEV;
 
 	return register_power_pmu(&power5_pmu);
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 09ae5bf..fa21890 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -537,7 +537,8 @@ static struct power_pmu power6_pmu = {
 
 static int init_power6_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power6"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power6"))
 		return -ENODEV;
 
 	return register_power_pmu(&power6_pmu);
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 5a9f5cb..388cf57 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -366,7 +366,8 @@ static struct power_pmu power7_pmu = {
 
 static int init_power7_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power7"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/power7"))
 		return -ENODEV;
 
 	return register_power_pmu(&power7_pmu);
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 833097a..75dccb7 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -488,8 +488,9 @@ static struct power_pmu ppc970_pmu = {
 
 static int init_ppc970_pmu(void)
 {
-	if (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970")
-	    && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970MP"))
+	if (!cur_cpu_spec->oprofile_cpu_type ||
+	    (strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970")
+	     && strcmp(cur_cpu_spec->oprofile_cpu_type, "ppc64/970MP")))
 		return -ENODEV;
 
 	return register_power_pmu(&ppc970_pmu);
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 5c093ff..d7cd193 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -119,11 +119,9 @@ struct ftrace_event_call {
 	void			*filter;
 	void			*mod;
 
-#ifdef CONFIG_EVENT_PROFILE
-	atomic_t	profile_count;
-	int		(*profile_enable)(struct ftrace_event_call *);
-	void		(*profile_disable)(struct ftrace_event_call *);
-#endif
+	atomic_t		profile_count;
+	int			(*profile_enable)(struct ftrace_event_call *);
+	void			(*profile_disable)(struct ftrace_event_call *);
 };
 
 #define MAX_FILTER_PRED		32
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 199ed47..673c1aa 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1104,7 +1104,7 @@ static void perf_counter_sync_stat(struct perf_counter_context *ctx,
 		__perf_counter_sync_stat(counter, next_counter);
 
 		counter = list_next_entry(counter, event_entry);
-		next_counter = list_next_entry(counter, event_entry);
+		next_counter = list_next_entry(next_counter, event_entry);
 	}
 }
 
diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
index 5b5895a..11ba5bb 100644
--- a/kernel/trace/trace_event_profile.c
+++ b/kernel/trace/trace_event_profile.c
@@ -14,7 +14,7 @@ int ftrace_profile_enable(int event_id)
 
 	mutex_lock(&event_mutex);
 	list_for_each_entry(event, &ftrace_events, list) {
-		if (event->id == event_id) {
+		if (event->id == event_id && event->profile_enable) {
 			ret = event->profile_enable(event);
 			break;
 		}
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 23d2972..e75276a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -940,7 +940,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		entry = trace_create_file("enable", 0644, call->dir, call,
 					  enable);
 
-	if (call->id)
+	if (call->id && call->profile_enable)
 		entry = trace_create_file("id", 0444, call->dir, call,
 					  id);
 
diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 1dbc1ee..6be696b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -29,13 +29,67 @@ OPTIONS
 	Select the PMU event. Selection can be a symbolic event name
 	(use 'perf list' to list all events) or a raw PMU
 	event (eventsel+umask) in the form of rNNN where NNN is a
-	 hexadecimal event descriptor.
+	hexadecimal event descriptor.
 
 -a::
-        system-wide collection
+        System-wide collection.
 
 -l::
-        scale counter values
+        Scale counter values.
+
+-p::
+--pid=::
+	Record events on existing pid.
+
+-r::
+--realtime=::
+	Collect data with this RT SCHED_FIFO priority.
+-A::
+--append::
+	Append to the output file to do incremental profiling.
+
+-f::
+--force::
+	Overwrite existing data file.
+
+-c::
+--count=::
+	Event period to sample.
+
+-o::
+--output=::
+	Output file name.
+
+-i::
+--inherit::
+	Child tasks inherit counters.
+-F::
+--freq=::
+	Profile at this frequency.
+
+-m::
+--mmap-pages=::
+	Number of mmap data pages.
+
+-g::
+--call-graph::
+	Do call-graph (stack chain/backtrace) recording.
+
+-v::
+--verbose::
+	Be more verbose (show counter open errors, etc).
+
+-s::
+--stat::
+	Per thread counts.
+
+-d::
+--data::
+	Sample addresses.
+
+-n::
+--no-samples::
+	Don't sample.
 
 SEE ALSO
 --------
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4b20fa4..1916e44 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -158,8 +158,10 @@ uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
 # If we're on a 64-bit kernel, use -m64
-ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-  M64 := -m64
+ifndef NO_64BIT
+	ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+	  M64 := -m64
+	endif
 endif
 
 # CFLAGS and LDFLAGS are for the users to override from the command line.
@@ -345,7 +347,6 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd -liberty
 
 #
 # Platform specific tweaks
@@ -374,6 +375,28 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
+endif
+
+ifdef NO_DEMANGLE
+	BASIC_CFLAGS += -DNO_DEMANGLE
+else
+
+	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
+
+	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
+
+	ifeq ($(has_bfd),y)
+		EXTLIBS += -lbfd
+	else ifeq ($(has_bfd_iberty),y)
+		EXTLIBS += -lbfd -liberty
+	else
+		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
+		BASIC_CFLAGS += -DNO_DEMANGLE
+	endif
+endif
+
 ifndef CC_LD_DYNPATH
 	ifdef NO_R_TO_GCC_LINKER
 		# Some gcc does not accept and pass -R to the linker to specify
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ce4f286..8cb58d6 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -31,7 +31,7 @@
 static char		const *input_name = "perf.data";
 static char		*vmlinux = NULL;
 
-static char		default_sort_order[] = "comm,dso";
+static char		default_sort_order[] = "comm,dso,symbol";
 static char		*sort_order = default_sort_order;
 static char		*dso_list_str, *comm_list_str, *sym_list_str,
 			*col_width_list_str;
@@ -1424,7 +1424,7 @@ print_entries:
 	if (sort_order == default_sort_order &&
 			parent_pattern == default_parent_pattern) {
 		fprintf(fp, "#\n");
-		fprintf(fp, "# (For more details, try: perf report --sort comm,dso,symbol)\n");
+		fprintf(fp, "# (For a higher level overview, try: perf report --sort comm,dso)\n");
 		fprintf(fp, "#\n");
 	}
 	fprintf(fp, "\n");
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b4fe057..16ddca2 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -6,7 +6,16 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
+
+#ifndef NO_DEMANGLE
 #include <bfd.h>
+#else
+static inline
+char *bfd_demangle(void __used *v, const char __used *c, int __used i)
+{
+	return NULL;
+}
+#endif
 
 const char *sym_hist_filter;
 
@@ -652,10 +661,69 @@ out_close:
 	return err;
 }
 
+#define BUILD_ID_SIZE 128
+
+static char *dso__read_build_id(struct dso *self, int verbose)
+{
+	int i;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+	Elf_Data *build_id_data;
+	Elf_Scn *sec;
+	char *build_id = NULL, *bid;
+	unsigned char *raw;
+	Elf *elf;
+	int fd = open(self->name, O_RDONLY);
+
+	if (fd < 0)
+		goto out;
+
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (elf == NULL) {
+		if (verbose)
+			fprintf(stderr, "%s: cannot read %s ELF file.\n",
+				__func__, self->name);
+		goto out_close;
+	}
+
+	if (gelf_getehdr(elf, &ehdr) == NULL) {
+		if (verbose)
+			fprintf(stderr, "%s: cannot get elf header.\n", __func__);
+		goto out_elf_end;
+	}
+
+	sec = elf_section_by_name(elf, &ehdr, &shdr, ".note.gnu.build-id", NULL);
+	if (sec == NULL)
+		goto out_elf_end;
+
+	build_id_data = elf_getdata(sec, NULL);
+	if (build_id_data == NULL)
+		goto out_elf_end;
+	build_id = malloc(BUILD_ID_SIZE);
+	if (build_id == NULL)
+		goto out_elf_end;
+	raw = build_id_data->d_buf + 16;
+	bid = build_id;
+
+	for (i = 0; i < 20; ++i) {
+		sprintf(bid, "%02x", *raw);
+		++raw;
+		bid += 2;
+	}
+	if (verbose)
+		printf("%s(%s): %s\n", __func__, self->name, build_id);
+out_elf_end:
+	elf_end(elf);
+out_close:
+	close(fd);
+out:
+	return build_id;
+}
+
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 {
-	int size = strlen(self->name) + sizeof("/usr/lib/debug%s.debug");
-	char *name = malloc(size);
+	int size = PATH_MAX;
+	char *name = malloc(size), *build_id = NULL;
 	int variant = 0;
 	int ret = -1;
 	int fd;
@@ -677,7 +745,18 @@ more:
 		case 1: /* Ubuntu */
 			snprintf(name, size, "/usr/lib/debug%s", self->name);
 			break;
-		case 2: /* Sane people */
+		case 2:
+			build_id = dso__read_build_id(self, verbose);
+			if (build_id != NULL) {
+				snprintf(name, size,
+					 "/usr/lib/debug/.build-id/%.2s/%s.debug",
+					build_id, build_id + 2);
+				free(build_id);
+				break;
+			}
+			variant++;
+			/* Fall thru */
+		case 3: /* Sane people */
 			snprintf(name, size, "%s", self->name);
 			break;
 
