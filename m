Return-Path: <linux-kernel-owner+w=401wt.eu-S1752843AbZKAPgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843AbZKAPgn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZKAPgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:36:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbZKAPgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:36:42 -0500
Date: Sun, 1 Nov 2009 16:36:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20091101153630.GA2430@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Marti Raudsepp (1):
      perf tools: Fix compatibility with libelf 0.8 and autodetect

Paul Mundt (1):
      perf tools: Remove -Wcast-align

Soeren Sandmann (2):
      perf events: Fix swevent hrtimer sampling by keeping track of remaining time when enabling/disabling swevent hrtimers
      perf events: Don't generate events for the idle task when exclude_idle is set


 include/linux/perf_event.h |    4 +-
 kernel/perf_event.c        |   66 +++++++++++++++++++++++++++++--------------
 tools/perf/Makefile        |    9 ++++--
 tools/perf/util/symbol.c   |    6 ++--
 tools/perf/util/symbol.h   |   10 ++++++
 5 files changed, 65 insertions(+), 30 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e6d95f..9e70126 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -471,8 +471,8 @@ struct hw_perf_event {
 			unsigned long	event_base;
 			int		idx;
 		};
-		union { /* software */
-			atomic64_t	count;
+		struct { /* software */
+			s64		remaining;
 			struct hrtimer	hrtimer;
 		};
 	};
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index afb7ef3..7f29643 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3959,8 +3959,9 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 		regs = task_pt_regs(current);
 
 	if (regs) {
-		if (perf_event_overflow(event, 0, &data, regs))
-			ret = HRTIMER_NORESTART;
+		if (!(event->attr.exclude_idle && current->pid == 0))
+			if (perf_event_overflow(event, 0, &data, regs))
+				ret = HRTIMER_NORESTART;
 	}
 
 	period = max_t(u64, 10000, event->hw.sample_period);
@@ -3969,6 +3970,42 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	return ret;
 }
 
+static void perf_swevent_start_hrtimer(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swevent_hrtimer;
+	if (hwc->sample_period) {
+		u64 period;
+
+		if (hwc->remaining) {
+			if (hwc->remaining < 0)
+				period = 10000;
+			else
+				period = hwc->remaining;
+			hwc->remaining = 0;
+		} else {
+			period = max_t(u64, 10000, hwc->sample_period);
+		}
+		__hrtimer_start_range_ns(&hwc->hrtimer,
+				ns_to_ktime(period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
+}
+
+static void perf_swevent_cancel_hrtimer(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (hwc->sample_period) {
+		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
+		hwc->remaining = ktime_to_ns(remaining);
+
+		hrtimer_cancel(&hwc->hrtimer);
+	}
+}
+
 /*
  * Software event: cpu wall time clock
  */
@@ -3991,22 +4028,14 @@ static int cpu_clock_perf_event_enable(struct perf_event *event)
 	int cpu = raw_smp_processor_id();
 
 	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
-	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
-		u64 period = max_t(u64, 10000, hwc->sample_period);
-		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
-	}
+	perf_swevent_start_hrtimer(event);
 
 	return 0;
 }
 
 static void cpu_clock_perf_event_disable(struct perf_event *event)
 {
-	if (event->hw.sample_period)
-		hrtimer_cancel(&event->hw.hrtimer);
+	perf_swevent_cancel_hrtimer(event);
 	cpu_clock_perf_event_update(event);
 }
 
@@ -4043,22 +4072,15 @@ static int task_clock_perf_event_enable(struct perf_event *event)
 	now = event->ctx->time;
 
 	atomic64_set(&hwc->prev_count, now);
-	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hwc->hrtimer.function = perf_swevent_hrtimer;
-	if (hwc->sample_period) {
-		u64 period = max_t(u64, 10000, hwc->sample_period);
-		__hrtimer_start_range_ns(&hwc->hrtimer,
-				ns_to_ktime(period), 0,
-				HRTIMER_MODE_REL, 0);
-	}
+
+	perf_swevent_start_hrtimer(event);
 
 	return 0;
 }
 
 static void task_clock_perf_event_disable(struct perf_event *event)
 {
-	if (event->hw.sample_period)
-		hrtimer_cancel(&event->hw.hrtimer);
+	perf_swevent_cancel_hrtimer(event);
 	task_clock_perf_event_update(event, event->ctx->time);
 
 }
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 742a32e..7e190d5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -177,8 +177,7 @@ endif
 # Include saner warnings here, which can catch bugs:
 #
 
-EXTRA_WARNINGS := -Wcast-align
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat
+EXTRA_WARNINGS := -Wformat
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
@@ -422,7 +421,11 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+		BASIC_CFLAGS += -DLIBELF_NO_MMAP
+	endif
+else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 47ea060..226f44a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -413,7 +413,7 @@ static int dso__synthesize_plt_symbols(struct  dso *self, int v)
 	if (fd < 0)
 		goto out;
 
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL)
 		goto out_close;
 
@@ -533,7 +533,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	Elf *elf;
 	int nr = 0, kernel = !strcmp("[kernel]", self->name);
 
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
 		if (v)
 			fprintf(stderr, "%s: cannot read %s ELF file.\n",
@@ -675,7 +675,7 @@ static char *dso__read_build_id(struct dso *self, int v)
 	if (fd < 0)
 		goto out;
 
-	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	elf = elf_begin(fd, PERF_ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
 		if (v)
 			fprintf(stderr, "%s: cannot read %s ELF file.\n",
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 6e84907..829da9e 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -27,6 +27,16 @@ static inline char *bfd_demangle(void __used *v, const char __used *c,
 #endif
 #endif
 
+/*
+ * libelf 0.8.x and earlier do not support ELF_C_READ_MMAP;
+ * for newer versions we can use mmap to reduce memory usage:
+ */
+#ifdef LIBELF_NO_MMAP
+# define PERF_ELF_C_READ_MMAP ELF_C_READ
+#else
+# define PERF_ELF_C_READ_MMAP ELF_C_READ_MMAP
+#endif
+
 #ifndef DMGL_PARAMS
 #define DMGL_PARAMS      (1 << 0)       /* Include function args */
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
