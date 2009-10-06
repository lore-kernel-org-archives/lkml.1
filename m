Return-Path: <linux-kernel-owner+w=401wt.eu-S1756578AbZJFGR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578AbZJFGR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 02:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbZJFGR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 02:17:28 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:58317 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZJFGR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 02:17:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JJZqcE+TFAXUpr2InGaluwbPdCk1m3AmWTHQE1Dv2d92XWYOZNfZ3v0Xdj3mibaq6x
         MsNxKtDiEIIB+LRX8npJdP+5PzAqbpocDUrBZzYHXNSkq1ybksvLwDX/vOC9TA1Nuv2y
         hx9g4NbkgqUiU93A80SysclsHyNbalVLcqcCY=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Subject: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
Date: Tue,  6 Oct 2009 01:09:54 -0500
Message-Id: <1254809398-8078-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement trace_scripting_operations to make Perl a supported perf
trace scripting language.

Also adds code that allows Perl trace scripts to access the 'flag' and
'symbolic' (__print_flags(), __print_symbolic()) field information
parsed from the trace format files.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/Makefile                 |   13 ++
 tools/perf/builtin-trace.c          |   37 +++-
 tools/perf/util/trace-event-parse.c |   18 ++-
 tools/perf/util/trace-event-perl.c  |  385 +++++++++++++++++++++++++++++++++++
 tools/perf/util/trace-event-perl.h  |   37 ++++
 tools/perf/util/trace-event.h       |    7 +
 6 files changed, 480 insertions(+), 17 deletions(-)
 create mode 100644 tools/perf/util/trace-event-perl.c
 create mode 100644 tools/perf/util/trace-event-perl.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 5a42996..a443bd3 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -375,6 +375,7 @@ LIB_OBJS += util/thread.o
 LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
 LIB_OBJS += util/trace-event-info.o
+LIB_OBJS += util/trace-event-perl.o
 LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
@@ -423,6 +424,15 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 endif
 
+PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts`
+PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts`
+
+ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o /dev/null $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
+	BASIC_CFLAGS += -DNO_LIBPERL
+else
+	ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+endif
+
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
@@ -781,6 +791,9 @@ util/config.o: util/config.c PERF-CFLAGS
 util/rbtree.o: ../../lib/rbtree.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/rbtree.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
+util/trace-event-perl.o: util/trace-event-perl.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes  -Wno-unused-parameter $<
+
 perf-%$X: %.o $(PERFLIBS)
 	$(QUIET_LINK)$(CC) $(ALL_CFLAGS) -o $@ $(ALL_LDFLAGS) $(filter %.o,$^) $(LIBS)
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a654a5a..74aec38 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -29,6 +29,8 @@ static u64		sample_type;
 
 static char		const *script_name;
 
+static int		do_perl;
+
 static int default_start_script(const char *script __attribute((unused)))
 {
 	return 0;
@@ -47,18 +49,6 @@ static struct trace_scripting_operations default_scripting_ops = {
 
 static struct trace_scripting_operations *scripting_ops;
 
-static int setup_scripting(const char *script __attribute((unused)))
-{
-	scripting_ops = &default_scripting_ops;
-
-	return 0;
-}
-
-static int cleanup_scripting(void)
-{
-	return scripting_ops->stop_script();
-}
-
 static int
 process_comm_event(event_t *event, unsigned long offset, unsigned long head)
 {
@@ -271,11 +261,34 @@ static const struct option options[] = {
 		    "dump raw trace in ASCII"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('p', "perl", &do_perl,
+		    "send output to a Perl script"),
 	OPT_STRING('s', "script", &script_name, "file",
 		    "script file name"),
 	OPT_END()
 };
 
+static int setup_scripting(const char *script)
+{
+	if ((do_perl && !script) || (script && !do_perl))
+		usage_with_options(annotate_usage, options);
+
+	scripting_ops = &default_scripting_ops;
+
+	if (do_perl) {
+		scripting_ops = setup_perl_scripting();
+		if (!scripting_ops)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int cleanup_scripting(void)
+{
+	return scripting_ops->stop_script();
+}
+
 int cmd_trace(int argc, const char **argv, const char *prefix __used)
 {
 	int err;
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6f851f9..bc482c5 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1798,7 +1798,7 @@ find_any_field(struct event *event, const char *name)
 	return find_field(event, name);
 }
 
-static unsigned long long read_size(void *ptr, int size)
+unsigned long long read_size(void *ptr, int size)
 {
 	switch (size) {
 	case 1:
@@ -1877,7 +1877,7 @@ int trace_parse_common_type(void *data)
 	return read_size(data + type_offset, type_size);
 }
 
-static int parse_common_pid(void *data)
+int trace_parse_common_pid(void *data)
 {
 	static int pid_offset;
 	static int pid_size;
@@ -1905,6 +1905,14 @@ struct event *trace_find_event(int id)
 	return event;
 }
 
+struct event *trace_find_next_event(struct event *event)
+{
+	if (!event)
+		return event_list;
+
+	return event->next;
+}
+
 static unsigned long long eval_num_arg(void *data, int size,
 				   struct event *event, struct print_arg *arg)
 {
@@ -2017,7 +2025,7 @@ static const struct flag flags[] = {
 	{ "HRTIMER_RESTART", 1 },
 };
 
-static unsigned long long eval_flag(const char *flag)
+unsigned long long eval_flag(const char *flag)
 {
 	int i;
 
@@ -2491,7 +2499,7 @@ get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 	if (!(event->flags & EVENT_FL_ISFUNCRET))
 		return NULL;
 
-	pid = parse_common_pid(next->data);
+	pid = trace_parse_common_pid(next->data);
 	field = find_field(event, "func");
 	if (!field)
 		die("function return does not have field func");
@@ -2767,7 +2775,7 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 		return;
 	}
 
-	pid = parse_common_pid(data);
+	pid = trace_parse_common_pid(data);
 
 	if (event->flags & (EVENT_FL_ISFUNCENT | EVENT_FL_ISFUNCRET))
 		return pretty_print_func_graph(data, size, event, cpu,
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
new file mode 100644
index 0000000..1264e14
--- /dev/null
+++ b/tools/perf/util/trace-event-perl.c
@@ -0,0 +1,385 @@
+/*
+ * trace-event-perl.  Feed perf trace events to an embedded Perl interpreter.
+ *
+ * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <ctype.h>
+#include <errno.h>
+
+#include "../perf.h"
+#include "util.h"
+#include "exec_cmd.h"
+#include "trace-event.h"
+#include "trace-event-perl.h"
+
+INTERP my_perl;
+
+#define FTRACE_MAX_EVENT						\
+	((1 << (sizeof(unsigned short) * 8)) - 1)
+
+struct event *events[FTRACE_MAX_EVENT];
+
+static char *cur_field_name;
+static int zero_flag_atom;
+
+static void define_symbolic_value(const char *ev_name,
+				  const char *field_name,
+				  const char *field_value,
+				  const char *field_str)
+{
+	unsigned long long value;
+	dSP;
+
+	value = eval_flag(field_value);
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+
+	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
+	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
+	XPUSHs(sv_2mortal(newSVuv(value)));
+	XPUSHs(sv_2mortal(newSVpv(field_str, 0)));
+
+	PUTBACK;
+	if (get_cv("main::define_symbolic_value", 0))
+		call_pv("main::define_symbolic_value", G_SCALAR);
+	SPAGAIN;
+	PUTBACK;
+	FREETMPS;
+	LEAVE;
+}
+
+static void define_symbolic_values(struct print_flag_sym *field,
+				   const char *ev_name,
+				   const char *field_name)
+{
+	define_symbolic_value(ev_name, field_name, field->value, field->str);
+	if (field->next)
+		define_symbolic_values(field->next, ev_name, field_name);
+}
+
+static void define_symbolic_field(const char *ev_name,
+				  const char *field_name)
+{
+	dSP;
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+
+	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
+	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
+
+	PUTBACK;
+	if (get_cv("main::define_symbolic_field", 0))
+		call_pv("main::define_symbolic_field", G_SCALAR);
+	SPAGAIN;
+	PUTBACK;
+	FREETMPS;
+	LEAVE;
+}
+
+static void define_flag_value(const char *ev_name,
+			      const char *field_name,
+			      const char *field_value,
+			      const char *field_str)
+{
+	unsigned long long value;
+	dSP;
+
+	value = eval_flag(field_value);
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+
+	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
+	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
+	XPUSHs(sv_2mortal(newSVuv(value)));
+	XPUSHs(sv_2mortal(newSVpv(field_str, 0)));
+
+	PUTBACK;
+	if (get_cv("main::define_flag_value", 0))
+		call_pv("main::define_flag_value", G_SCALAR);
+	SPAGAIN;
+	PUTBACK;
+	FREETMPS;
+	LEAVE;
+}
+
+static void define_flag_values(struct print_flag_sym *field,
+			       const char *ev_name,
+			       const char *field_name)
+{
+	define_flag_value(ev_name, field_name, field->value, field->str);
+	if (field->next)
+		define_flag_values(field->next, ev_name, field_name);
+}
+
+static void define_flag_field(const char *ev_name,
+			      const char *field_name,
+			      const char *delim)
+{
+	dSP;
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+
+	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
+	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
+	XPUSHs(sv_2mortal(newSVpv(delim, 0)));
+
+	PUTBACK;
+	if (get_cv("main::define_flag_field", 0))
+		call_pv("main::define_flag_field", G_SCALAR);
+	SPAGAIN;
+	PUTBACK;
+	FREETMPS;
+	LEAVE;
+}
+
+static void define_event_symbols(struct event *event,
+				 const char *ev_name,
+				 struct print_arg *args)
+{
+	switch (args->type) {
+	case PRINT_NULL:
+		break;
+	case PRINT_ATOM:
+		define_flag_value(ev_name, cur_field_name, "0",
+				  args->atom.atom);
+		zero_flag_atom = 0;
+		break;
+	case PRINT_FIELD:
+		if (cur_field_name)
+			free(cur_field_name);
+		cur_field_name = strdup(args->field.name);
+		break;
+	case PRINT_FLAGS:
+		define_event_symbols(event, ev_name, args->flags.field);
+		define_flag_field(ev_name, cur_field_name, args->flags.delim);
+		define_flag_values(args->flags.flags, ev_name, cur_field_name);
+		break;
+	case PRINT_SYMBOL:
+		define_event_symbols(event, ev_name, args->symbol.field);
+		define_symbolic_field(ev_name, cur_field_name);
+		define_symbolic_values(args->symbol.symbols, ev_name,
+				       cur_field_name);
+		break;
+	case PRINT_STRING:
+		break;
+	case PRINT_TYPE:
+		define_event_symbols(event, ev_name, args->typecast.item);
+		break;
+	case PRINT_OP:
+		if (strcmp(args->op.op, ":") == 0)
+			zero_flag_atom = 1;
+		define_event_symbols(event, ev_name, args->op.left);
+		define_event_symbols(event, ev_name, args->op.right);
+		break;
+	default:
+		/* we should warn... */
+		return;
+	}
+
+	if (args->next)
+		define_event_symbols(event, ev_name, args->next);
+}
+
+static inline struct event *find_cache_event(int type)
+{
+	static char ev_name[256];
+	struct event *event;
+
+	if (events[type])
+		return events[type];
+
+	events[type] = event = trace_find_event(type);
+	if (!event)
+		return NULL;
+
+	sprintf(ev_name, "%s::%s", event->system, event->name);
+
+	define_event_symbols(event, ev_name, event->print_fmt.args);
+
+	return event;
+}
+
+static void perl_process_event(int cpu, void *data,
+			       int size __attribute((unused)),
+			       unsigned long long nsecs, char *comm)
+{
+	struct format_field *field;
+	static char handler[256];
+	unsigned long long val;
+	unsigned long s, ns;
+	struct event *event;
+	int type;
+	int pid;
+
+	dSP;
+
+	type = trace_parse_common_type(data);
+
+	event = find_cache_event(type);
+	if (!event)
+		die("ug! no event found for type %d", type);
+
+	pid = trace_parse_common_pid(data);
+
+	sprintf(handler, "%s::%s", event->system, event->name);
+
+	s = nsecs / NSECS_PER_SEC;
+	ns = nsecs - s * NSECS_PER_SEC;
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+
+	XPUSHs(sv_2mortal(newSVpv(handler, 0)));
+	XPUSHs(sv_2mortal(newSVuv(cpu)));
+	XPUSHs(sv_2mortal(newSVuv(s)));
+	XPUSHs(sv_2mortal(newSVuv(ns)));
+	XPUSHs(sv_2mortal(newSViv(pid)));
+	XPUSHs(sv_2mortal(newSVpv(comm, 0)));
+
+	/* common fields other than pid can be accessed via xsub fns */
+
+	for (field = event->format.fields; field; field = field->next) {
+		if (field->flags & FIELD_IS_STRING) {
+			int offset;
+			if (field->flags & FIELD_IS_DYNAMIC) {
+				offset = *(int *)(data + field->offset);
+				offset &= 0xffff;
+			} else
+				offset = field->offset;
+			XPUSHs(sv_2mortal(newSVpv((char *)data + offset, 0)));
+		} else { /* FIELD_IS_NUMERIC */
+			val = read_size(data + field->offset, field->size);
+			if (field->flags & FIELD_IS_SIGNED) {
+				XPUSHs(sv_2mortal(newSViv(val)));
+			} else {
+				XPUSHs(sv_2mortal(newSVuv(val)));
+			}
+		}
+	}
+
+	PUTBACK;
+	if (get_cv(handler, 0))
+		call_pv(handler, G_SCALAR);
+	else if (get_cv("main::trace_unhandled", 0)) {
+		XPUSHs(sv_2mortal(newSVpv(handler, 0)));
+		XPUSHs(sv_2mortal(newSVuv(cpu)));
+		XPUSHs(sv_2mortal(newSVuv(nsecs)));
+		XPUSHs(sv_2mortal(newSViv(pid)));
+		XPUSHs(sv_2mortal(newSVpv(comm, 0)));
+		call_pv("main::trace_unhandled", G_SCALAR);
+	}
+	SPAGAIN;
+	PUTBACK;
+	FREETMPS;
+	LEAVE;
+}
+
+static void run_start_sub(void)
+{
+	dSP; /* access to Perl stack */
+	PUSHMARK(SP);
+
+	if (get_cv("main::trace_begin", 0))
+		call_pv("main::trace_begin", G_DISCARD | G_NOARGS);
+}
+
+/*
+ * Start trace script
+ */
+static int perl_start_script(const char *script)
+{
+	const char *command_line[2] = { "", NULL };
+
+	command_line[1] = script;
+
+	my_perl = perl_alloc();
+	perl_construct(my_perl);
+
+	if (perl_parse(my_perl, NULL, 2, (char **)command_line, (char **)NULL))
+		return -1;
+
+	perl_run(my_perl);
+	if (SvTRUE(ERRSV))
+		return -1;
+
+	run_start_sub();
+
+	fprintf(stderr, "perf trace started with Perl script %s\n\n", script);
+
+	return 0;
+}
+
+/*
+ * Stop trace script
+ */
+static int perl_stop_script(void)
+{
+	dSP; /* access to Perl stack */
+	PUSHMARK(SP);
+
+	if (get_cv("main::trace_end", 0))
+		call_pv("main::trace_end", G_DISCARD | G_NOARGS);
+
+	perl_destruct(my_perl);
+	perl_free(my_perl);
+
+	fprintf(stderr, "\nperf trace Perl script stopped\n");
+
+	return 0;
+}
+
+struct trace_scripting_operations perl_scripting_ops = {
+	.start_script = perl_start_script,
+	.stop_script = perl_stop_script,
+	.process_event = perl_process_event,
+};
+
+#ifdef NO_LIBPERL
+struct trace_scripting_operations *setup_perl_scripting(void)
+{
+	fprintf(stderr, "Perl scripting not supported."
+		"  Install libperl-dev[el] and rebuild perf to get it.\n");
+
+	return NULL;
+}
+#else
+struct trace_scripting_operations *setup_perl_scripting(void)
+{
+	struct trace_scripting_operations *scripting_ops;
+
+	scripting_ops = &perl_scripting_ops;
+
+	/* make sure PERF_EXEC_PATH is set for scripts */
+	perf_set_argv_exec_path(perf_exec_path());
+
+	return scripting_ops;
+}
+#endif
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
new file mode 100644
index 0000000..0db7484
--- /dev/null
+++ b/tools/perf/util/trace-event-perl.h
@@ -0,0 +1,37 @@
+#ifndef __PERF_TRACE_EVENT_PERL_H
+#define __PERF_TRACE_EVENT_PERL_H
+#ifdef NO_LIBPERL
+typedef int INTERP;
+#define dSP
+#define ENTER
+#define SAVETMPS
+#define PUTBACK
+#define SPAGAIN
+#define FREETMPS
+#define LEAVE
+#define SP
+#define ERRSV
+#define G_SCALAR		(0)
+#define G_DISCARD		(0)
+#define G_NOARGS		(0)
+#define PUSHMARK(a)
+#define SvTRUE(a)		(0)
+#define XPUSHs(s)
+#define sv_2mortal(a)
+#define newSVpv(a,b)
+#define newSVuv(a)
+#define newSViv(a)
+#define get_cv(a,b)		(0)
+#define call_pv(a,b)		(0)
+#define perl_alloc()		(0)
+#define perl_construct(a)	(0)
+#define perl_parse(a,b,c,d,e)	(0)
+#define perl_run(a)		(0)
+#define perl_destruct(a)	(0)
+#define perl_free(a)		(0)
+#else
+#include <EXTERN.h>
+#include <perl.h>
+typedef PerlInterpreter * INTERP;
+#endif
+#endif /* __PERF_TRACE_EVENT_PERL_H */
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 449c23d..f812a8e 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -239,10 +239,14 @@ extern int header_page_data_size;
 
 int parse_header_page(char *buf, unsigned long size);
 int trace_parse_common_type(void *data);
+int trace_parse_common_pid(void *data);
 struct event *trace_find_event(int id);
+struct event *trace_find_next_event(struct event *event);
+unsigned long long read_size(void *ptr, int size);
 unsigned long long
 raw_field_value(struct event *event, const char *name, void *data);
 void *raw_field_ptr(struct event *event, const char *name, void *data);
+unsigned long long eval_flag(const char *flag);
 
 void read_tracing_data(struct perf_event_attr *pattrs, int nb_events);
 
@@ -253,4 +257,7 @@ struct trace_scripting_operations {
 			       unsigned long long nsecs, char *comm);
 };
 
+extern struct trace_scripting_operations perl_scripting_ops;
+struct trace_scripting_operations *setup_perl_scripting(void);
+
 #endif /* __PERF_TRACE_EVENTS_H */
-- 
1.6.4.GIT

