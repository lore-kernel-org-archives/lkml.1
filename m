Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZJBVrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZJBVrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 17:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbZJBVrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 17:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbZJBVr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 17:47:29 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes v2 4/5] perf: Add perf probe subcommand for
	kprobe-event setup helper
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 02 Oct 2009 17:49:05 -0400
Message-ID: <20091002214904.30906.11622.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091002214834.30906.86502.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add perf probe subcommand for kprobe-event setup helper to perf command.
This allows user to define kprobe events by C expressions (C line numbers,
C function names, and C local variables).

Usage
-----
 perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]

    -k, --vmlinux <file>  vmlinux/module pathname
    -r, --release <rel>   kernel release
    -P, --probe <p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
                          probe point definition, where
		p:	kprobe probe
		r:	kretprobe probe
		GRP:	Group name (optional)
		NAME:	Event name
		FUNC:	Function name
		OFFS:	Offset from function entry (in byte)
		SRC:	Source code path
		LINE:	Line number
		ARG:	Probe argument (local variable name or
			kprobe-tracer argument format is supported.)

Changes in v2:
 - Check synthesized string length.
 - Rename perf kprobe to perf probe.
 - Use spaces for separator and update usage comment.
 - Check error paths in parse_probepoint().
 - Check optimized-out variables.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 tools/perf/Makefile            |   10 +
 tools/perf/builtin-probe.c     |  356 +++++++++++++++++++++
 tools/perf/builtin.h           |    1 
 tools/perf/perf.c              |    3 
 tools/perf/util/probe-finder.c |  690 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-finder.h |   68 ++++
 6 files changed, 1128 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/builtin-probe.c
 create mode 100644 tools/perf/util/probe-finder.c
 create mode 100644 tools/perf/util/probe-finder.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b5f1953..6dabcf1 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -419,6 +419,16 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 endif
 
+ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(warning No libdwarf.h found, disables probe subcommand. Please install libdwarf-dev/libdwarf-devel);
+else
+	EXTLIBS += -lelf -ldwarf
+	LIB_H += util/probe-finder.h
+	LIB_OBJS += util/probe-finder.o
+	BUILTIN_OBJS += builtin-probe.o
+	BASIC_CFLAGS += -DSUPPORT_DWARF
+endif
+
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
new file mode 100644
index 0000000..47c5fb8
--- /dev/null
+++ b/tools/perf/builtin-probe.c
@@ -0,0 +1,356 @@
+/*
+ * builtin-probe.c
+ *
+ * Builtin probe command: Set up probe events by C expression
+ *
+ * Written by Masami Hiramatsu <mhiramat@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include <sys/utsname.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "perf.h"
+#include "builtin.h"
+#include "util/util.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"	/* For debugfs_path */
+#include "util/probe-finder.h"
+
+/* Default vmlinux search paths */
+#define NR_SEARCH_PATH 3
+const char *default_search_path[NR_SEARCH_PATH] = {
+"/lib/modules/%s/build/vmlinux",		/* Custom build kernel */
+"/usr/lib/debug/lib/modules/%s/vmlinux",	/* Red Hat debuginfo */
+"/boot/vmlinux-debug-%s",			/* Ubuntu */
+};
+
+#define MAX_PATH_LEN 256
+#define MAX_PROBES 128
+
+/* Session management structure */
+static struct {
+	char *vmlinux;
+	char *release;
+	int nr_probe;
+	struct probe_point probes[MAX_PROBES];
+	char *events[MAX_PROBES];
+} session;
+
+static void semantic_error(const char *msg)
+{
+	fprintf(stderr, "Semantic error: %s\n", msg);
+	exit(1);
+}
+
+static void perror_exit(const char *msg)
+{
+	perror(msg);
+	exit(1);
+}
+
+#define MAX_PROBE_ARGS 128
+
+static int parse_probepoint(const struct option *opt __used,
+			    const char *str, int unset __used)
+{
+	char *argv[MAX_PROBE_ARGS + 2];	/* Event + probe + args */
+	int argc, i;
+	char *arg, *ptr;
+	struct probe_point *pp = &session.probes[session.nr_probe];
+	char **event = &session.events[session.nr_probe];
+	int retp = 0;
+
+	if (!str)	/* The end of probe points */
+		return 0;
+
+	debug("Probe-define(%d): %s\n", session.nr_probe, str);
+	if (++session.nr_probe == MAX_PROBES)
+		semantic_error("Too many probes");
+
+	/* Separate arguments, similar to argv_split */
+	argc = 0;
+	do {
+		/* Skip separators */
+		while (isspace(*str))
+			str++;
+
+		/* Add an argument */
+		if (*str != '\0') {
+			const char *s = str;
+
+			/* Skip the argument */
+			while (!isspace(*str) && *str != '\0')
+				str++;
+
+			/* Duplicate the argument */
+			argv[argc] = strndup(s, str - s);
+			if (argv[argc] == NULL)
+				perror_exit("strndup");
+			if (++argc == MAX_PROBE_ARGS)
+				semantic_error("Too many arguments");
+			debug("argv[%d]=%s\n", argc, argv[argc - 1]);
+		}
+	} while (*str != '\0');
+	if (argc < 2)
+		semantic_error("Need event-name and probe-point at least.");
+
+	/* Parse the event name */
+	if (argv[0][0] == 'r')
+		retp = 1;
+	else if (argv[0][0] != 'p')
+		semantic_error("You must specify 'p'(kprobe) or"
+				" 'r'(kretprobe) first.");
+	/* TODO: check event name */
+	*event = argv[0];
+
+	/* Parse probe point */
+	arg = argv[1];
+	if (arg[0] == '@') {
+		/* Source Line */
+		arg++;
+		ptr = strchr(arg, ':');
+		if (!ptr || !isdigit(ptr[1]))
+			semantic_error("Line number is required.");
+		*ptr++ = '\0';
+		if (strlen(arg) == 0)
+			semantic_error("No file name.");
+		pp->file = strdup(arg);
+		pp->line = atoi(ptr);
+		if (!pp->file || !pp->line)
+			semantic_error("Failed to parse line.");
+		debug("file:%s line:%d\n", pp->file, pp->line);
+	} else {
+		/* Function name */
+		ptr = strchr(arg, '+');
+		if (ptr) {
+			if (!isdigit(ptr[1]))
+				semantic_error("Offset is required.");
+			*ptr++ = '\0';
+			pp->offset = atoi(ptr);
+		} else
+			ptr = arg;
+		ptr = strchr(ptr, '@');
+		if (ptr) {
+			*ptr++ = '\0';
+			pp->file = strdup(ptr);
+		}
+		pp->function = strdup(arg);
+		debug("symbol:%s file:%s offset:%d\n",
+		      pp->function, pp->file, pp->offset);
+	}
+	free(argv[1]);
+
+	/* Copy arguments */
+	pp->nr_args = argc - 2;
+	if (pp->nr_args > 0) {
+		pp->args = (char **)malloc(sizeof(char *) * pp->nr_args);
+		memcpy(pp->args, &argv[2], sizeof(char *) * pp->nr_args);
+	}
+
+	/* Ensure return probe has no C argument */
+	if (retp)
+		for (i = 0; i < pp->nr_args; i++)
+			if (is_c_varname(pp->args[i]))
+				semantic_error("You can't specify local"
+						" variable for kretprobe");
+	debug("%d arguments\n", pp->nr_args);
+	return 0;
+}
+
+static int open_default_vmlinux(void)
+{
+	struct utsname uts;
+	char fname[MAX_PATH_LEN];
+	int fd, ret, i;
+
+	if (!session.release) {
+		ret = uname(&uts);
+		if (ret) {
+			debug("uname() failed.\n");
+			return -errno;
+		}
+		session.release = uts.release;
+	}
+	for (i = 0; i < NR_SEARCH_PATH; i++) {
+		ret = snprintf(fname, MAX_PATH_LEN,
+			       default_search_path[i], session.release);
+		if (ret >= MAX_PATH_LEN || ret < 0) {
+			debug("Filename(%d,%s) is too long.\n", i, uts.release);
+			errno = E2BIG;
+			return -E2BIG;
+		}
+		debug("try to open %s\n", fname);
+		fd = open(fname, O_RDONLY);
+		if (fd >= 0)
+			break;
+	}
+	return fd;
+}
+
+static const char * const probe_usage[] = {
+	"perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]",
+	NULL
+};
+
+static const struct option options[] = {
+	OPT_STRING('k', "vmlinux", &session.vmlinux, "file",
+		"vmlinux/module pathname"),
+	OPT_STRING('r', "release", &session.release, "rel", "kernel release"),
+	OPT_CALLBACK('P', "probe", NULL,
+		"p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]",
+		"probe point definition, where\n"
+		"\t\tp:\tkprobe probe\n"
+		"\t\tr:\tkretprobe probe\n"
+		"\t\tGRP:\tGroup name (optional)\n"
+		"\t\tNAME:\tEvent name\n"
+		"\t\tFUNC:\tFunction name\n"
+		"\t\tOFFS:\tOffset from function entry (in byte)\n"
+		"\t\tSRC:\tSource code path\n"
+		"\t\tLINE:\tLine number\n"
+		"\t\tARG:\tProbe argument (local variable name or\n"
+		"\t\t\tkprobe-tracer argument format is supported.)\n",
+		parse_probepoint),
+	OPT_END()
+};
+
+static int write_new_event(int fd, const char *buf)
+{
+	int ret;
+
+	printf("Adding new event: %s\n", buf);
+	ret = write(fd, buf, strlen(buf));
+	if (ret <= 0)
+		perror("Error: Failed to create event");
+
+	return ret;
+}
+
+#define MAX_CMDLEN 256
+
+static int synthesize_probepoint(struct probe_point *pp)
+{
+	char *buf;
+	int i, len, ret;
+	pp->probes[0] = buf = (char *)calloc(MAX_CMDLEN, sizeof(char));
+	ret = snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
+	if (ret <= 0 || ret >= MAX_CMDLEN)
+		goto error;
+	len = ret;
+
+	for (i = 0; i < pp->nr_args; i++) {
+		ret = snprintf(&buf[len], MAX_CMDLEN - len, " %s",
+			       pp->args[i]);
+		if (ret <= 0 || ret >= MAX_CMDLEN - len)
+			goto error;
+		len += ret;
+	}
+	pp->found = 1;
+	return pp->found;
+error:
+	free(pp->probes[0]);
+	if (ret > 0)
+		ret = -E2BIG;
+	return ret;
+}
+
+int cmd_probe(int argc, const char **argv, const char *prefix __used)
+{
+	int i, j, fd, ret, need_dwarf = 0;
+	struct probe_point *pp;
+	char buf[MAX_CMDLEN];
+
+	argc = parse_options(argc, argv, options, probe_usage,
+		PARSE_OPT_STOP_AT_NON_OPTION);
+	if (argc || session.nr_probe == 0)
+		usage_with_options(probe_usage, options);
+
+	/* Synthesize return probes */
+	for (j = 0; j < session.nr_probe; j++) {
+		if (session.events[j][0] != 'r') {
+			need_dwarf = 1;
+			continue;
+		}
+		ret = synthesize_probepoint(&session.probes[j]);
+		if (ret == -E2BIG)
+			semantic_error("probe point is too long.");
+		else if (ret < 0) {
+			perror("snprintf");
+			return -1;
+		}
+	}
+
+	if (!need_dwarf)
+		goto setup_probes;
+
+	if (session.vmlinux)
+		fd = open(session.vmlinux, O_RDONLY);
+	else
+		fd = open_default_vmlinux();
+	if (fd < 0) {
+		perror("vmlinux/module file open");
+		return -1;
+	}
+
+	/* Searching probe points */
+	for (j = 0; j < session.nr_probe; j++) {
+		pp = &session.probes[j];
+		if (pp->found)
+			continue;
+
+		lseek(fd, SEEK_SET, 0);
+		ret = find_probepoint(fd, pp);
+		if (ret <= 0) {
+			fprintf(stderr, "Error: No probe point found.\n");
+			return -1;
+		}
+		debug("probe event %s found\n", session.events[j]);
+	}
+	close(fd);
+
+setup_probes:
+	/* Settng up probe points */
+	snprintf(buf, MAX_CMDLEN, "%s/../kprobe_events", debugfs_path);
+	fd = open(buf, O_WRONLY, O_APPEND);
+	if (fd < 0) {
+		perror("kprobe_events open");
+		return -1;
+	}
+	for (j = 0; j < session.nr_probe; j++) {
+		pp = &session.probes[j];
+		if (pp->found == 1) {
+			snprintf(buf, MAX_CMDLEN, "%s %s\n",
+				session.events[j], pp->probes[0]);
+			write_new_event(fd, buf);
+		} else
+			for (i = 0; i < pp->found; i++) {
+				snprintf(buf, MAX_CMDLEN, "%s%d %s\n",
+					session.events[j], i, pp->probes[i]);
+				write_new_event(fd, buf);
+			}
+	}
+	close(fd);
+	return 0;
+}
+
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index e11d8d2..ad5f0f4 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -25,5 +25,6 @@ extern int cmd_timechart(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
 extern int cmd_version(int argc, const char **argv, const char *prefix);
+extern int cmd_probe(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 19fc7fe..f598120 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -295,6 +295,9 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "version", cmd_version, 0 },
 		{ "trace", cmd_trace, 0 },
 		{ "sched", cmd_sched, 0 },
+#ifdef SUPPORT_DWARF
+		{ "probe", cmd_probe, 0 },
+#endif
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
new file mode 100644
index 0000000..25e22fe
--- /dev/null
+++ b/tools/perf/util/probe-finder.c
@@ -0,0 +1,690 @@
+/*
+ * probe-finder.c : C expression to kprobe event converter
+ *
+ * Written by Masami Hiramatsu <mhiramat@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ */
+
+#include <sys/utsname.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <getopt.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdarg.h>
+#include <ctype.h>
+#include "probe-finder.h"
+
+
+/* Dwarf_Die Linkage to parent Die */
+struct die_link {
+	struct die_link *parent;	/* Parent die */
+	Dwarf_Die die;			/* Current die */
+};
+
+static Dwarf_Debug __dw_debug;
+static Dwarf_Error __dw_error;
+
+static void msg_exit(int ret, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	fprintf(stderr, "Error:  ");
+	vfprintf(stderr, fmt, ap);
+	va_end(ap);
+
+	fprintf(stderr, "\n");
+	exit(ret);
+}
+
+
+/*
+ * Generic dwarf analysis helpers
+ */
+
+#define X86_32_MAX_REGS 8
+const char *x86_32_regs_table[X86_32_MAX_REGS] = {
+	"%ax",
+	"%cx",
+	"%dx",
+	"%bx",
+	"$sa",	/* Stack address */
+	"%bp",
+	"%si",
+	"%di",
+};
+
+#define X86_64_MAX_REGS 16
+const char *x86_64_regs_table[X86_64_MAX_REGS] = {
+	"%ax",
+	"%dx",
+	"%cx",
+	"%bx",
+	"%si",
+	"%di",
+	"%bp",
+	"%sp",
+	"%r8",
+	"%r9",
+	"%r10",
+	"%r11",
+	"%r12",
+	"%r13",
+	"%r14",
+	"%r15",
+};
+
+/* TODO: switching by dwarf address size */
+#ifdef __x86_64__
+#define ARCH_MAX_REGS X86_64_MAX_REGS
+#define arch_regs_table x86_64_regs_table
+#else
+#define ARCH_MAX_REGS X86_32_MAX_REGS
+#define arch_regs_table x86_32_regs_table
+#endif
+
+/* Return architecture dependent register string (for kprobe-tracer) */
+static const char *get_arch_regstr(unsigned int n)
+{
+	return (n <= ARCH_MAX_REGS) ? arch_regs_table[n] : NULL;
+}
+
+/*
+ * Compare the tail of two strings.
+ * Return 0 if whole of either string is same as another's tail part.
+ */
+static int strtailcmp(const char *s1, const char *s2)
+{
+	int i1 = strlen(s1);
+	int i2 = strlen(s2);
+	while (--i1 > 0 && --i2 > 0) {
+		if (s1[i1] != s2[i2])
+			return s1[i1] - s2[i2];
+	}
+	return 0;
+}
+
+/* Find the fileno of the target file. */
+static Dwarf_Unsigned die_get_fileno(Dwarf_Die cu_die, const char *fname)
+{
+	Dwarf_Signed cnt, i;
+	Dwarf_Unsigned found = 0;
+	char **srcs;
+	int ret;
+
+	if (!fname)
+		return 0;
+
+	ret = dwarf_srcfiles(cu_die, &srcs, &cnt, &__dw_error);
+	if (ret == DW_DLV_OK) {
+		for (i = 0; i < cnt && !found; i++) {
+			if (strtailcmp(srcs[i], fname) == 0)
+				found = i + 1;
+			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
+		}
+		for (; i < cnt; i++)
+			dwarf_dealloc(__dw_debug, srcs[i], DW_DLA_STRING);
+		dwarf_dealloc(__dw_debug, srcs, DW_DLA_LIST);
+	}
+	if (found)
+		debug("found fno: %d\n", (int)found);
+	return found;
+}
+
+/* Compare diename and tname */
+static int die_compare_name(Dwarf_Die die, const char *tname)
+{
+	char *name;
+	int ret;
+	ret = dwarf_diename(die, &name, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (ret == DW_DLV_OK) {
+		ret = strcmp(tname, name);
+		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
+	} else
+		ret = -1;
+	return ret;
+}
+
+/* Check the address is in the subprogram(function). */
+static int die_within_subprogram(Dwarf_Die sp_die, Dwarf_Addr addr,
+				 Dwarf_Signed *offs)
+{
+	Dwarf_Addr lopc, hipc;
+	int ret;
+
+	/* TODO: check ranges */
+	ret = dwarf_lowpc(sp_die, &lopc, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (ret == DW_DLV_NO_ENTRY)
+		return 0;
+	ret = dwarf_highpc(sp_die, &hipc, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	if (lopc <= addr && addr < hipc) {
+		*offs = addr - lopc;
+		return 1;
+	} else
+		return 0;
+}
+
+/* Check the die is inlined function */
+static Dwarf_Bool die_inlined_subprogram(Dwarf_Die die)
+{
+	/* TODO: check strictly */
+	Dwarf_Bool inl;
+	int ret;
+
+	ret = dwarf_hasattr(die, DW_AT_inline, &inl, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	return inl;
+}
+
+/* Get the offset of abstruct_origin */
+static Dwarf_Off die_get_abstract_origin(Dwarf_Die die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Off cu_offs;
+	int ret;
+
+	ret = dwarf_attr(die, DW_AT_abstract_origin, &attr, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	ret = dwarf_formref(attr, &cu_offs, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+	return cu_offs;
+}
+
+/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
+static Dwarf_Addr die_get_entrypc(Dwarf_Die die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Addr addr;
+	Dwarf_Off offs;
+	Dwarf_Ranges *ranges;
+	Dwarf_Signed cnt;
+	int ret;
+
+	/* Try to get entry pc */
+	ret = dwarf_attr(die, DW_AT_entry_pc, &attr, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (ret == DW_DLV_OK) {
+		ret = dwarf_formaddr(attr, &addr, &__dw_error);
+		ERR_IF(ret != DW_DLV_OK);
+		dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+		return addr;
+	}
+
+	/* Try to get low pc */
+	ret = dwarf_lowpc(die, &addr, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (ret == DW_DLV_OK)
+		return addr;
+
+	/* Try to get ranges */
+	ret = dwarf_attr(die, DW_AT_ranges, &attr, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	ret = dwarf_formref(attr, &offs, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	ret = dwarf_get_ranges(__dw_debug, offs, &ranges, &cnt, NULL,
+				&__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	addr = ranges[0].dwr_addr1;
+	dwarf_ranges_dealloc(__dw_debug, ranges, cnt);
+	return addr;
+}
+
+/*
+ * Search a Die from Die tree.
+ * Note: cur_link->die should be deallocated in this function.
+ */
+static int __search_die_tree(struct die_link *cur_link,
+			     int (*die_cb)(struct die_link *, void *),
+			     void *data)
+{
+	Dwarf_Die new_die;
+	struct die_link new_link;
+	int ret;
+
+	if (!die_cb)
+		return 0;
+
+	/* Check current die */
+	while (!(ret = die_cb(cur_link, data))) {
+		/* Check child die */
+		ret = dwarf_child(cur_link->die, &new_die, &__dw_error);
+		ERR_IF(ret == DW_DLV_ERROR);
+		if (ret == DW_DLV_OK) {
+			new_link.parent = cur_link;
+			new_link.die = new_die;
+			ret = __search_die_tree(&new_link, die_cb, data);
+			if (ret)
+				break;
+		}
+
+		/* Move to next sibling */
+		ret = dwarf_siblingof(__dw_debug, cur_link->die, &new_die,
+				      &__dw_error);
+		ERR_IF(ret == DW_DLV_ERROR);
+		dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
+		cur_link->die = new_die;
+		if (ret == DW_DLV_NO_ENTRY)
+			return 0;
+	}
+	dwarf_dealloc(__dw_debug, cur_link->die, DW_DLA_DIE);
+	return ret;
+}
+
+/* Search a die in its children's die tree */
+static int search_die_from_children(Dwarf_Die parent_die,
+				    int (*die_cb)(struct die_link *, void *),
+				    void *data)
+{
+	struct die_link new_link;
+	int ret;
+
+	new_link.parent = NULL;
+	ret = dwarf_child(parent_die, &new_link.die, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (ret == DW_DLV_OK)
+		return __search_die_tree(&new_link, die_cb, data);
+	else
+		return 0;
+}
+
+/* Find a locdesc corresponding to the address */
+static int attr_get_locdesc(Dwarf_Attribute attr, Dwarf_Locdesc *desc,
+			    Dwarf_Addr addr)
+{
+	Dwarf_Signed lcnt;
+	Dwarf_Locdesc **llbuf;
+	int ret, i;
+
+	ret = dwarf_loclist_n(attr, &llbuf, &lcnt, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	ret = DW_DLV_NO_ENTRY;
+	for (i = 0; i < lcnt; ++i) {
+		if (llbuf[i]->ld_lopc <= addr &&
+		    llbuf[i]->ld_hipc > addr) {
+			memcpy(desc, llbuf[i], sizeof(Dwarf_Locdesc));
+			desc->ld_s =
+				malloc(sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
+			ERR_IF(desc->ld_s == NULL);
+			memcpy(desc->ld_s, llbuf[i]->ld_s,
+				sizeof(Dwarf_Loc) * llbuf[i]->ld_cents);
+			ret = DW_DLV_OK;
+			break;
+		}
+		dwarf_dealloc(__dw_debug, llbuf[i]->ld_s, DW_DLA_LOC_BLOCK);
+		dwarf_dealloc(__dw_debug, llbuf[i], DW_DLA_LOCDESC);
+	}
+	/* Releasing loop */
+	for (; i < lcnt; ++i) {
+		dwarf_dealloc(__dw_debug, llbuf[i]->ld_s, DW_DLA_LOC_BLOCK);
+		dwarf_dealloc(__dw_debug, llbuf[i], DW_DLA_LOCDESC);
+	}
+	dwarf_dealloc(__dw_debug, llbuf, DW_DLA_LIST);
+	return ret;
+}
+
+/*
+ * Probe finder related functions
+ */
+
+/* Show a location */
+static void show_location(Dwarf_Loc *loc, struct probe_finder *pf)
+{
+	Dwarf_Small op;
+	Dwarf_Unsigned regn;
+	Dwarf_Signed offs;
+	int deref = 0, ret;
+	const char *regs;
+
+	op = loc->lr_atom;
+
+	/* If this is based on frame buffer, set the offset */
+	if (op == DW_OP_fbreg) {
+		deref = 1;
+		offs = (Dwarf_Signed)loc->lr_number;
+		op = pf->fbloc.ld_s[0].lr_atom;
+		loc = &pf->fbloc.ld_s[0];
+	} else
+		offs = 0;
+
+	if (op >= DW_OP_breg0 && op <= DW_OP_breg31) {
+		regn = op - DW_OP_breg0;
+		offs += (Dwarf_Signed)loc->lr_number;
+		deref = 1;
+	} else if (op >= DW_OP_reg0 && op <= DW_OP_reg31) {
+		regn = op - DW_OP_reg0;
+	} else if (op == DW_OP_bregx) {
+		regn = loc->lr_number;
+		offs += (Dwarf_Signed)loc->lr_number2;
+		deref = 1;
+	} else if (op == DW_OP_regx) {
+		regn = loc->lr_number;
+	} else
+		msg_exit(-EINVAL, "Dwarf_OP %d is not supported.\n", op);
+
+	regs = get_arch_regstr(regn);
+	if (!regs)
+		msg_exit(-EINVAL, "%lld exceeds max register number.\n", regn);
+
+	if (deref)
+		ret = snprintf(pf->buf, pf->len,
+				 " %s=%+lld(%s)", pf->var, offs, regs);
+	else
+		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
+	ERR_IF(ret < 0);
+	ERR_IF(ret >= pf->len);
+}
+
+/* Show a variables in kprobe event format */
+static void show_variable(Dwarf_Die vr_die, struct probe_finder *pf)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Locdesc ld;
+	int ret;
+
+	ret = dwarf_attr(vr_die, DW_AT_location, &attr, &__dw_error);
+	if (ret != DW_DLV_OK)
+		goto error;
+	ret = attr_get_locdesc(attr, &ld, (pf->addr - pf->cu_base));
+	if (ret != DW_DLV_OK)
+		goto error;
+	/* TODO? */
+	ERR_IF(ld.ld_cents != 1);
+	show_location(&ld.ld_s[0], pf);
+	free(ld.ld_s);
+	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+	return ;
+error:
+	msg_exit(-1, "Failed to find the location of %s at this address.\n"
+		 " Perhaps, it was optimized out.\n", pf->var);
+}
+
+static int variable_callback(struct die_link *dlink, void *data)
+{
+	struct probe_finder *pf = (struct probe_finder *)data;
+	Dwarf_Half tag;
+	int ret;
+
+	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if ((tag == DW_TAG_formal_parameter ||
+	     tag == DW_TAG_variable) &&
+	    (die_compare_name(dlink->die, pf->var) == 0)) {
+		show_variable(dlink->die, pf);
+		return 1;
+	}
+	/* TODO: Support struct members and arrays */
+	return 0;
+}
+
+/* Find a variable in a subprogram die */
+static void find_variable(Dwarf_Die sp_die, struct probe_finder *pf)
+{
+	int ret;
+
+	if (!is_c_varname(pf->var)) {
+		/* Output raw parameters */
+		ret = snprintf(pf->buf, pf->len, " %s", pf->var);
+		ERR_IF(ret < 0);
+		ERR_IF(ret >= pf->len);
+		return ;
+	}
+
+	debug("Searching '%s' variable in context.\n", pf->var);
+	/* Search child die for local variables and parameters. */
+	ret = search_die_from_children(sp_die, variable_callback, pf);
+	if (!ret)
+		msg_exit(-1, "Failed to find '%s' in this function.\n",
+			 pf->var);
+}
+
+/* Get a frame base on the address */
+static void get_current_frame_base(Dwarf_Die sp_die, struct probe_finder *pf)
+{
+	Dwarf_Attribute attr;
+	int ret;
+
+	ret = dwarf_attr(sp_die, DW_AT_frame_base, &attr, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+	ret = attr_get_locdesc(attr, &pf->fbloc, (pf->addr - pf->cu_base));
+	ERR_IF(ret != DW_DLV_OK);
+	dwarf_dealloc(__dw_debug, attr, DW_DLA_ATTR);
+}
+
+static void free_current_frame_base(struct probe_finder *pf)
+{
+	free(pf->fbloc.ld_s);
+	memset(&pf->fbloc, 0, sizeof(Dwarf_Locdesc));
+}
+
+/* Show a probe point to output buffer */
+static void show_probepoint(Dwarf_Die sp_die, Dwarf_Signed offs,
+			    struct probe_finder *pf)
+{
+	struct probe_point *pp = pf->pp;
+	char *name;
+	char tmp[MAX_PROBE_BUFFER];
+	int ret, i, len;
+
+	/* Output name of probe point */
+	ret = dwarf_diename(sp_die, &name, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (ret == DW_DLV_OK) {
+		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%u", name,
+				(unsigned int)offs);
+		dwarf_dealloc(__dw_debug, name, DW_DLA_STRING);
+	} else {
+		/* This function has no name. */
+		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%llx", pf->addr);
+	}
+	ERR_IF(ret < 0);
+	ERR_IF(ret >= MAX_PROBE_BUFFER);
+	len = ret;
+
+	/* Find each argument */
+	get_current_frame_base(sp_die, pf);
+	for (i = 0; i < pp->nr_args; i++) {
+		pf->var = pp->args[i];
+		pf->buf = &tmp[len];
+		pf->len = MAX_PROBE_BUFFER - len;
+		find_variable(sp_die, pf);
+		len += strlen(pf->buf);
+	}
+	free_current_frame_base(pf);
+
+	pp->probes[pp->found] = strdup(tmp);
+	pp->found++;
+}
+
+static int probeaddr_callback(struct die_link *dlink, void *data)
+{
+	struct probe_finder *pf = (struct probe_finder *)data;
+	Dwarf_Half tag;
+	Dwarf_Signed offs;
+	int ret;
+
+	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	/* Check the address is in this subprogram */
+	if (tag == DW_TAG_subprogram &&
+	    die_within_subprogram(dlink->die, pf->addr, &offs)) {
+		show_probepoint(dlink->die, offs, pf);
+		return 1;
+	}
+	return 0;
+}
+
+/* Find probe point from its line number */
+static void find_by_line(Dwarf_Die cu_die, struct probe_finder *pf)
+{
+	struct probe_point *pp = pf->pp;
+	Dwarf_Signed cnt, i;
+	Dwarf_Line *lines;
+	Dwarf_Unsigned lineno = 0;
+	Dwarf_Addr addr;
+	Dwarf_Unsigned fno;
+	int ret;
+
+	ret = dwarf_srclines(cu_die, &lines, &cnt, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+
+	for (i = 0; i < cnt; i++) {
+		ret = dwarf_line_srcfileno(lines[i], &fno, &__dw_error);
+		ERR_IF(ret != DW_DLV_OK);
+		if (fno != pf->fno)
+			continue;
+
+		ret = dwarf_lineno(lines[i], &lineno, &__dw_error);
+		ERR_IF(ret != DW_DLV_OK);
+		if (lineno != (Dwarf_Unsigned)pp->line)
+			continue;
+
+		ret = dwarf_lineaddr(lines[i], &addr, &__dw_error);
+		ERR_IF(ret != DW_DLV_OK);
+		debug("Probe point found: 0x%llx\n", addr);
+		pf->addr = addr;
+		/* Search a real subprogram including this line, */
+		ret = search_die_from_children(cu_die, probeaddr_callback, pf);
+		if (ret == 0)
+			msg_exit(-1,
+				 "Probe point is not found in subprograms.\n");
+		/* Continuing, because target line might be inlined. */
+	}
+	dwarf_srclines_dealloc(__dw_debug, lines, cnt);
+}
+
+/* Search function from function name */
+static int probefunc_callback(struct die_link *dlink, void *data)
+{
+	struct probe_finder *pf = (struct probe_finder *)data;
+	struct probe_point *pp = pf->pp;
+	struct die_link *lk;
+	Dwarf_Signed offs;
+	Dwarf_Half tag;
+	int ret;
+
+	ret = dwarf_tag(dlink->die, &tag, &__dw_error);
+	ERR_IF(ret == DW_DLV_ERROR);
+	if (tag == DW_TAG_subprogram) {
+		if (die_compare_name(dlink->die, pp->function) == 0) {
+			if (die_inlined_subprogram(dlink->die)) {
+				/* Inlined function, save it. */
+				ret = dwarf_die_CU_offset(dlink->die,
+							  &pf->inl_offs,
+							  &__dw_error);
+				ERR_IF(ret != DW_DLV_OK);
+				debug("inline definition offset %lld\n",
+					pf->inl_offs);
+				return 0;
+			}
+			/* Get probe address */
+			pf->addr = die_get_entrypc(dlink->die);
+			pf->addr += pp->offset;
+			/* TODO: Check the address in this function */
+			show_probepoint(dlink->die, pp->offset, pf);
+			/* Continue to search */
+		}
+	} else if (tag == DW_TAG_inlined_subroutine && pf->inl_offs) {
+		if (die_get_abstract_origin(dlink->die) == pf->inl_offs) {
+			/* Get probe address */
+			pf->addr = die_get_entrypc(dlink->die);
+			pf->addr += pp->offset;
+			debug("found inline addr: 0x%llx\n", pf->addr);
+			/* Inlined function. Get a real subprogram */
+			for (lk = dlink->parent; lk != NULL; lk = lk->parent) {
+				tag = 0;
+				dwarf_tag(lk->die, &tag, &__dw_error);
+				ERR_IF(ret == DW_DLV_ERROR);
+				if (tag == DW_TAG_subprogram &&
+				    !die_inlined_subprogram(lk->die))
+					goto found;
+			}
+			msg_exit(-1, "Failed to find real subprogram.\n");
+found:
+			/* Get offset from subprogram */
+			ret = die_within_subprogram(lk->die, pf->addr, &offs);
+			ERR_IF(!ret);
+			show_probepoint(lk->die, offs, pf);
+			/* Continue to search */
+		}
+	}
+	return 0;
+}
+
+static void find_by_func(Dwarf_Die cu_die, struct probe_finder *pf)
+{
+	search_die_from_children(cu_die, probefunc_callback, pf);
+}
+
+/* Find a probe point */
+int find_probepoint(int fd, struct probe_point *pp)
+{
+	Dwarf_Half addr_size = 0;
+	Dwarf_Unsigned next_cuh = 0;
+	Dwarf_Die cu_die = 0;
+	int cu_number = 0, ret;
+	struct probe_finder pf = {.pp = pp};
+
+	ret = dwarf_init(fd, DW_DLC_READ, 0, 0, &__dw_debug, &__dw_error);
+	if (ret != DW_DLV_OK)
+		msg_exit(-1, "Failed to call dwarf_init(). "
+			 "Maybe, not a dwarf file?\n");
+
+	pp->found = 0;
+	while (++cu_number) {
+		/* Search CU (Compilation Unit) */
+		ret = dwarf_next_cu_header(__dw_debug, NULL, NULL, NULL,
+			&addr_size, &next_cuh, &__dw_error);
+		ERR_IF(ret == DW_DLV_ERROR);
+		if (ret == DW_DLV_NO_ENTRY)
+			break;
+
+		/* Get the DIE(Debugging Information Entry) of this CU */
+		ret = dwarf_siblingof(__dw_debug, 0, &cu_die, &__dw_error);
+		ERR_IF(ret != DW_DLV_OK);
+
+		/* Check if target file is included. */
+		if (pp->file)
+			pf.fno = die_get_fileno(cu_die, pp->file);
+
+		if (!pp->file || pf.fno) {
+			/* Save CU base address (for frame_base) */
+			ret = dwarf_lowpc(cu_die, &pf.cu_base, &__dw_error);
+			ERR_IF(ret == DW_DLV_ERROR);
+			if (ret == DW_DLV_NO_ENTRY)
+				pf.cu_base = 0;
+			if (pp->line)
+				find_by_line(cu_die, &pf);
+			if (pp->function)
+				find_by_func(cu_die, &pf);
+		}
+		dwarf_dealloc(__dw_debug, cu_die, DW_DLA_DIE);
+	}
+	ret = dwarf_finish(__dw_debug, &__dw_error);
+	ERR_IF(ret != DW_DLV_OK);
+
+	return pp->found;
+}
+
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
new file mode 100644
index 0000000..af920de
--- /dev/null
+++ b/tools/perf/util/probe-finder.h
@@ -0,0 +1,68 @@
+#ifndef _PROBE_FINDER_H
+#define _PROBE_FINDER_H
+
+#define _stringify(n)	#n
+#define stringify(n)	_stringify(n)
+
+#ifdef DEBUG
+#define debug(fmt ...)	\
+	fprintf(stderr, "DBG(" __FILE__ ":" stringify(__LINE__) "): " fmt)
+#else
+#define debug(fmt ...)	do {} while (0)
+#endif
+
+#define ERR_IF(cnd)	\
+	do { if (cnd) {	\
+		fprintf(stderr, "Error (" __FILE__ ":" stringify(__LINE__) \
+			"): " stringify(cnd) "\n");			\
+		exit(1);						\
+	} } while (0)
+
+#define MAX_PATH_LEN 256
+#define MAX_PROBE_BUFFER 1024
+#define MAX_PROBES 128
+
+static inline int is_c_varname(const char *name)
+{
+	/* TODO */
+	return isalpha(name[0]) || name[0] == '_';
+}
+
+struct probe_point {
+	/* Inputs */
+	char	*file;		/* File name */
+	int	line;		/* Line number */
+
+	char	*function;	/* Function name */
+	int	offset;		/* Offset bytes */
+
+	int	nr_args;	/* Number of arguments */
+	char	**args;		/* Arguments */
+
+	/* Output */
+	int	found;		/* Number of found probe points */
+	char	*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
+};
+
+extern int find_probepoint(int fd, struct probe_point *pp);
+
+#include <libdwarf/dwarf.h>
+#include <libdwarf/libdwarf.h>
+
+struct probe_finder {
+	struct probe_point	*pp;	/* Target probe point */
+
+	/* For function searching */
+	Dwarf_Addr	addr;		/* Address */
+	Dwarf_Unsigned	fno;		/* File number */
+	Dwarf_Off	inl_offs;	/* Inline offset */
+
+	/* For variable searching */
+	Dwarf_Addr	cu_base;	/* Current CU base address */
+	Dwarf_Locdesc	fbloc;		/* Location of Current Frame Base */
+	const char	*var;		/* Current variable name */
+	char		*buf;		/* Current output buffer */
+	int		len;		/* Length of output buffer */
+};
+
+#endif /*_PROBE_FINDER_H */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
