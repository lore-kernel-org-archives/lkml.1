Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0BYKIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:08:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:47488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab0BYKIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:08:12 -0500
Date: Thu, 25 Feb 2010 10:07:25 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1264580883-15324-5-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-5-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/scripts: Move Perl scripting files to scripting-engines dir
Message-ID: <tip-82d156cd5e817055c63ec50247a425c195f4cb14@git.kernel.org>
Git-Commit-ID: 82d156cd5e817055c63ec50247a425c195f4cb14
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:07:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82d156cd5e817055c63ec50247a425c195f4cb14
Gitweb:     http://git.kernel.org/tip/82d156cd5e817055c63ec50247a425c195f4cb14
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Wed, 27 Jan 2010 02:27:55 -0600
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Tue, 23 Feb 2010 20:49:55 +0100

perf/scripts: Move Perl scripting files to scripting-engines dir

Create a scripting-engines directory to contain scripting engine
implementation code, in anticipation of the addition of new scripting
support.  Also removes trace-event-perl.h.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1264580883-15324-5-git-send-email-tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Makefile                                |    9 +-
 .../perf/util/scripting-engines/trace-event-perl.c |  568 ++++++++++++++++++
 tools/perf/util/trace-event-perl.c                 |  634 --------------------
 tools/perf/util/trace-event-perl.h                 |   47 --
 tools/perf/util/trace-event-scripting.c            |  106 ++++
 5 files changed, 679 insertions(+), 685 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3a5fb36..0a3c0c8 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -385,7 +385,6 @@ LIB_H += util/sort.h
 LIB_H += util/hist.h
 LIB_H += util/thread.h
 LIB_H += util/trace-event.h
-LIB_H += util/trace-event-perl.h
 LIB_H += util/probe-finder.h
 LIB_H += util/probe-event.h
 
@@ -428,7 +427,7 @@ LIB_OBJS += util/thread.o
 LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
 LIB_OBJS += util/trace-event-info.o
-LIB_OBJS += util/trace-event-perl.o
+LIB_OBJS += util/trace-event-scripting.o
 LIB_OBJS += util/svghelper.o
 LIB_OBJS += util/sort.o
 LIB_OBJS += util/hist.o
@@ -519,6 +518,7 @@ ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; e
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
 	ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
+	LIB_OBJS += util/scripting-engines/trace-event-perl.o
 	LIB_OBJS += scripts/perl/Perf-Trace-Util/Context.o
 endif
 
@@ -893,8 +893,8 @@ util/hweight.o: ../../lib/hweight.c PERF-CFLAGS
 util/find_next_bit.o: ../../lib/find_next_bit.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o util/find_next_bit.o -c $(ALL_CFLAGS) -DETC_PERFCONFIG='"$(ETC_PERFCONFIG_SQ)"' $<
 
-util/trace-event-perl.o: util/trace-event-perl.c PERF-CFLAGS
-	$(QUIET_CC)$(CC) -o util/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
+util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o util/scripting-engines/trace-event-perl.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
 
 scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o scripts/perl/Perf-Trace-Util/Context.o -c $(ALL_CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
@@ -1012,6 +1012,7 @@ install: all
 	$(INSTALL) scripts/perl/Perf-Trace-Util/lib/Perf/Trace/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
 	$(INSTALL) scripts/perl/*.pl -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl'
 	$(INSTALL) scripts/perl/bin/* -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/bin'
+
 ifdef BUILT_INS
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(BUILT_INS) '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
new file mode 100644
index 0000000..5376378
--- /dev/null
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -0,0 +1,568 @@
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
+#include "../../perf.h"
+#include "../util.h"
+#include "../trace-event.h"
+
+#include <EXTERN.h>
+#include <perl.h>
+
+void boot_Perf__Trace__Context(pTHX_ CV *cv);
+void boot_DynaLoader(pTHX_ CV *cv);
+typedef PerlInterpreter * INTERP;
+
+void xs_init(pTHX);
+
+void xs_init(pTHX)
+{
+	const char *file = __FILE__;
+	dXSUB_SYS;
+
+	newXS("Perf::Trace::Context::bootstrap", boot_Perf__Trace__Context,
+	      file);
+	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
+}
+
+INTERP my_perl;
+
+#define FTRACE_MAX_EVENT				\
+	((1 << (sizeof(unsigned short) * 8)) - 1)
+
+struct event *events[FTRACE_MAX_EVENT];
+
+extern struct scripting_context *scripting_context;
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
+			       int size __unused,
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
+	scripting_context->event_data = data;
+
+	ENTER;
+	SAVETMPS;
+	PUSHMARK(SP);
+
+	XPUSHs(sv_2mortal(newSVpv(handler, 0)));
+	XPUSHs(sv_2mortal(newSViv(PTR2IV(scripting_context))));
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
+
+	if (get_cv(handler, 0))
+		call_pv(handler, G_SCALAR);
+	else if (get_cv("main::trace_unhandled", 0)) {
+		XPUSHs(sv_2mortal(newSVpv(handler, 0)));
+		XPUSHs(sv_2mortal(newSViv(PTR2IV(scripting_context))));
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
+static int perl_start_script(const char *script, int argc, const char **argv)
+{
+	const char **command_line;
+	int i, err = 0;
+
+	command_line = malloc((argc + 2) * sizeof(const char *));
+	command_line[0] = "";
+	command_line[1] = script;
+	for (i = 2; i < argc + 2; i++)
+		command_line[i] = argv[i - 2];
+
+	my_perl = perl_alloc();
+	perl_construct(my_perl);
+
+	if (perl_parse(my_perl, xs_init, argc + 2, (char **)command_line,
+		       (char **)NULL)) {
+		err = -1;
+		goto error;
+	}
+
+	if (perl_run(my_perl)) {
+		err = -1;
+		goto error;
+	}
+
+	if (SvTRUE(ERRSV)) {
+		err = -1;
+		goto error;
+	}
+
+	run_start_sub();
+
+	free(command_line);
+	fprintf(stderr, "perf trace started with Perl script %s\n\n", script);
+	return 0;
+error:
+	perl_free(my_perl);
+	free(command_line);
+
+	return err;
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
+static int perl_generate_script(const char *outfile)
+{
+	struct event *event = NULL;
+	struct format_field *f;
+	char fname[PATH_MAX];
+	int not_first, count;
+	FILE *ofp;
+
+	sprintf(fname, "%s.pl", outfile);
+	ofp = fopen(fname, "w");
+	if (ofp == NULL) {
+		fprintf(stderr, "couldn't open %s\n", fname);
+		return -1;
+	}
+
+	fprintf(ofp, "# perf trace event handlers, "
+		"generated by perf trace -g perl\n");
+
+	fprintf(ofp, "# Licensed under the terms of the GNU GPL"
+		" License version 2\n\n");
+
+	fprintf(ofp, "# The common_* event handler fields are the most useful "
+		"fields common to\n");
+
+	fprintf(ofp, "# all events.  They don't necessarily correspond to "
+		"the 'common_*' fields\n");
+
+	fprintf(ofp, "# in the format files.  Those fields not available as "
+		"handler params can\n");
+
+	fprintf(ofp, "# be retrieved using Perl functions of the form "
+		"common_*($context).\n");
+
+	fprintf(ofp, "# See Context.pm for the list of available "
+		"functions.\n\n");
+
+	fprintf(ofp, "use lib \"$ENV{'PERF_EXEC_PATH'}/scripts/perl/"
+		"Perf-Trace-Util/lib\";\n");
+
+	fprintf(ofp, "use lib \"./Perf-Trace-Util/lib\";\n");
+	fprintf(ofp, "use Perf::Trace::Core;\n");
+	fprintf(ofp, "use Perf::Trace::Context;\n");
+	fprintf(ofp, "use Perf::Trace::Util;\n\n");
+
+	fprintf(ofp, "sub trace_begin\n{\n\t# optional\n}\n\n");
+	fprintf(ofp, "sub trace_end\n{\n\t# optional\n}\n\n");
+
+	while ((event = trace_find_next_event(event))) {
+		fprintf(ofp, "sub %s::%s\n{\n", event->system, event->name);
+		fprintf(ofp, "\tmy (");
+
+		fprintf(ofp, "$event_name, ");
+		fprintf(ofp, "$context, ");
+		fprintf(ofp, "$common_cpu, ");
+		fprintf(ofp, "$common_secs, ");
+		fprintf(ofp, "$common_nsecs,\n");
+		fprintf(ofp, "\t    $common_pid, ");
+		fprintf(ofp, "$common_comm,\n\t    ");
+
+		not_first = 0;
+		count = 0;
+
+		for (f = event->format.fields; f; f = f->next) {
+			if (not_first++)
+				fprintf(ofp, ", ");
+			if (++count % 5 == 0)
+				fprintf(ofp, "\n\t    ");
+
+			fprintf(ofp, "$%s", f->name);
+		}
+		fprintf(ofp, ") = @_;\n\n");
+
+		fprintf(ofp, "\tprint_header($event_name, $common_cpu, "
+			"$common_secs, $common_nsecs,\n\t             "
+			"$common_pid, $common_comm);\n\n");
+
+		fprintf(ofp, "\tprintf(\"");
+
+		not_first = 0;
+		count = 0;
+
+		for (f = event->format.fields; f; f = f->next) {
+			if (not_first++)
+				fprintf(ofp, ", ");
+			if (count && count % 4 == 0) {
+				fprintf(ofp, "\".\n\t       \"");
+			}
+			count++;
+
+			fprintf(ofp, "%s=", f->name);
+			if (f->flags & FIELD_IS_STRING ||
+			    f->flags & FIELD_IS_FLAG ||
+			    f->flags & FIELD_IS_SYMBOLIC)
+				fprintf(ofp, "%%s");
+			else if (f->flags & FIELD_IS_SIGNED)
+				fprintf(ofp, "%%d");
+			else
+				fprintf(ofp, "%%u");
+		}
+
+		fprintf(ofp, "\\n\",\n\t       ");
+
+		not_first = 0;
+		count = 0;
+
+		for (f = event->format.fields; f; f = f->next) {
+			if (not_first++)
+				fprintf(ofp, ", ");
+
+			if (++count % 5 == 0)
+				fprintf(ofp, "\n\t       ");
+
+			if (f->flags & FIELD_IS_FLAG) {
+				if ((count - 1) % 5 != 0) {
+					fprintf(ofp, "\n\t       ");
+					count = 4;
+				}
+				fprintf(ofp, "flag_str(\"");
+				fprintf(ofp, "%s::%s\", ", event->system,
+					event->name);
+				fprintf(ofp, "\"%s\", $%s)", f->name,
+					f->name);
+			} else if (f->flags & FIELD_IS_SYMBOLIC) {
+				if ((count - 1) % 5 != 0) {
+					fprintf(ofp, "\n\t       ");
+					count = 4;
+				}
+				fprintf(ofp, "symbol_str(\"");
+				fprintf(ofp, "%s::%s\", ", event->system,
+					event->name);
+				fprintf(ofp, "\"%s\", $%s)", f->name,
+					f->name);
+			} else
+				fprintf(ofp, "$%s", f->name);
+		}
+
+		fprintf(ofp, ");\n");
+		fprintf(ofp, "}\n\n");
+	}
+
+	fprintf(ofp, "sub trace_unhandled\n{\n\tmy ($event_name, $context, "
+		"$common_cpu, $common_secs, $common_nsecs,\n\t    "
+		"$common_pid, $common_comm) = @_;\n\n");
+
+	fprintf(ofp, "\tprint_header($event_name, $common_cpu, "
+		"$common_secs, $common_nsecs,\n\t             $common_pid, "
+		"$common_comm);\n}\n\n");
+
+	fprintf(ofp, "sub print_header\n{\n"
+		"\tmy ($event_name, $cpu, $secs, $nsecs, $pid, $comm) = @_;\n\n"
+		"\tprintf(\"%%-20s %%5u %%05u.%%09u %%8u %%-20s \",\n\t       "
+		"$event_name, $cpu, $secs, $nsecs, $pid, $comm);\n}");
+
+	fclose(ofp);
+
+	fprintf(stderr, "generated Perl script: %s\n", fname);
+
+	return 0;
+}
+
+struct scripting_ops perl_scripting_ops = {
+	.name = "Perl",
+	.start_script = perl_start_script,
+	.stop_script = perl_stop_script,
+	.process_event = perl_process_event,
+	.generate_script = perl_generate_script,
+};
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
deleted file mode 100644
index 5b49df0..0000000
--- a/tools/perf/util/trace-event-perl.c
+++ /dev/null
@@ -1,634 +0,0 @@
-/*
- * trace-event-perl.  Feed perf trace events to an embedded Perl interpreter.
- *
- * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
- *
- *  This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation; either version 2 of the License, or
- *  (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- *
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <ctype.h>
-#include <errno.h>
-
-#include "../perf.h"
-#include "util.h"
-#include "trace-event.h"
-#include "trace-event-perl.h"
-
-void xs_init(pTHX);
-
-void xs_init(pTHX)
-{
-	const char *file = __FILE__;
-	dXSUB_SYS;
-
-	newXS("Perf::Trace::Context::bootstrap", boot_Perf__Trace__Context,
-	      file);
-	newXS("DynaLoader::boot_DynaLoader", boot_DynaLoader, file);
-}
-
-INTERP my_perl;
-
-#define FTRACE_MAX_EVENT				\
-	((1 << (sizeof(unsigned short) * 8)) - 1)
-
-struct event *events[FTRACE_MAX_EVENT];
-
-static struct scripting_context *scripting_context;
-
-static char *cur_field_name;
-static int zero_flag_atom;
-
-static void define_symbolic_value(const char *ev_name,
-				  const char *field_name,
-				  const char *field_value,
-				  const char *field_str)
-{
-	unsigned long long value;
-	dSP;
-
-	value = eval_flag(field_value);
-
-	ENTER;
-	SAVETMPS;
-	PUSHMARK(SP);
-
-	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
-	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
-	XPUSHs(sv_2mortal(newSVuv(value)));
-	XPUSHs(sv_2mortal(newSVpv(field_str, 0)));
-
-	PUTBACK;
-	if (get_cv("main::define_symbolic_value", 0))
-		call_pv("main::define_symbolic_value", G_SCALAR);
-	SPAGAIN;
-	PUTBACK;
-	FREETMPS;
-	LEAVE;
-}
-
-static void define_symbolic_values(struct print_flag_sym *field,
-				   const char *ev_name,
-				   const char *field_name)
-{
-	define_symbolic_value(ev_name, field_name, field->value, field->str);
-	if (field->next)
-		define_symbolic_values(field->next, ev_name, field_name);
-}
-
-static void define_symbolic_field(const char *ev_name,
-				  const char *field_name)
-{
-	dSP;
-
-	ENTER;
-	SAVETMPS;
-	PUSHMARK(SP);
-
-	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
-	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
-
-	PUTBACK;
-	if (get_cv("main::define_symbolic_field", 0))
-		call_pv("main::define_symbolic_field", G_SCALAR);
-	SPAGAIN;
-	PUTBACK;
-	FREETMPS;
-	LEAVE;
-}
-
-static void define_flag_value(const char *ev_name,
-			      const char *field_name,
-			      const char *field_value,
-			      const char *field_str)
-{
-	unsigned long long value;
-	dSP;
-
-	value = eval_flag(field_value);
-
-	ENTER;
-	SAVETMPS;
-	PUSHMARK(SP);
-
-	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
-	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
-	XPUSHs(sv_2mortal(newSVuv(value)));
-	XPUSHs(sv_2mortal(newSVpv(field_str, 0)));
-
-	PUTBACK;
-	if (get_cv("main::define_flag_value", 0))
-		call_pv("main::define_flag_value", G_SCALAR);
-	SPAGAIN;
-	PUTBACK;
-	FREETMPS;
-	LEAVE;
-}
-
-static void define_flag_values(struct print_flag_sym *field,
-			       const char *ev_name,
-			       const char *field_name)
-{
-	define_flag_value(ev_name, field_name, field->value, field->str);
-	if (field->next)
-		define_flag_values(field->next, ev_name, field_name);
-}
-
-static void define_flag_field(const char *ev_name,
-			      const char *field_name,
-			      const char *delim)
-{
-	dSP;
-
-	ENTER;
-	SAVETMPS;
-	PUSHMARK(SP);
-
-	XPUSHs(sv_2mortal(newSVpv(ev_name, 0)));
-	XPUSHs(sv_2mortal(newSVpv(field_name, 0)));
-	XPUSHs(sv_2mortal(newSVpv(delim, 0)));
-
-	PUTBACK;
-	if (get_cv("main::define_flag_field", 0))
-		call_pv("main::define_flag_field", G_SCALAR);
-	SPAGAIN;
-	PUTBACK;
-	FREETMPS;
-	LEAVE;
-}
-
-static void define_event_symbols(struct event *event,
-				 const char *ev_name,
-				 struct print_arg *args)
-{
-	switch (args->type) {
-	case PRINT_NULL:
-		break;
-	case PRINT_ATOM:
-		define_flag_value(ev_name, cur_field_name, "0",
-				  args->atom.atom);
-		zero_flag_atom = 0;
-		break;
-	case PRINT_FIELD:
-		if (cur_field_name)
-			free(cur_field_name);
-		cur_field_name = strdup(args->field.name);
-		break;
-	case PRINT_FLAGS:
-		define_event_symbols(event, ev_name, args->flags.field);
-		define_flag_field(ev_name, cur_field_name, args->flags.delim);
-		define_flag_values(args->flags.flags, ev_name, cur_field_name);
-		break;
-	case PRINT_SYMBOL:
-		define_event_symbols(event, ev_name, args->symbol.field);
-		define_symbolic_field(ev_name, cur_field_name);
-		define_symbolic_values(args->symbol.symbols, ev_name,
-				       cur_field_name);
-		break;
-	case PRINT_STRING:
-		break;
-	case PRINT_TYPE:
-		define_event_symbols(event, ev_name, args->typecast.item);
-		break;
-	case PRINT_OP:
-		if (strcmp(args->op.op, ":") == 0)
-			zero_flag_atom = 1;
-		define_event_symbols(event, ev_name, args->op.left);
-		define_event_symbols(event, ev_name, args->op.right);
-		break;
-	default:
-		/* we should warn... */
-		return;
-	}
-
-	if (args->next)
-		define_event_symbols(event, ev_name, args->next);
-}
-
-static inline struct event *find_cache_event(int type)
-{
-	static char ev_name[256];
-	struct event *event;
-
-	if (events[type])
-		return events[type];
-
-	events[type] = event = trace_find_event(type);
-	if (!event)
-		return NULL;
-
-	sprintf(ev_name, "%s::%s", event->system, event->name);
-
-	define_event_symbols(event, ev_name, event->print_fmt.args);
-
-	return event;
-}
-
-static void perl_process_event(int cpu, void *data,
-			       int size __unused,
-			       unsigned long long nsecs, char *comm)
-{
-	struct format_field *field;
-	static char handler[256];
-	unsigned long long val;
-	unsigned long s, ns;
-	struct event *event;
-	int type;
-	int pid;
-
-	dSP;
-
-	type = trace_parse_common_type(data);
-
-	event = find_cache_event(type);
-	if (!event)
-		die("ug! no event found for type %d", type);
-
-	pid = trace_parse_common_pid(data);
-
-	sprintf(handler, "%s::%s", event->system, event->name);
-
-	s = nsecs / NSECS_PER_SEC;
-	ns = nsecs - s * NSECS_PER_SEC;
-
-	scripting_context->event_data = data;
-
-	ENTER;
-	SAVETMPS;
-	PUSHMARK(SP);
-
-	XPUSHs(sv_2mortal(newSVpv(handler, 0)));
-	XPUSHs(sv_2mortal(newSViv(PTR2IV(scripting_context))));
-	XPUSHs(sv_2mortal(newSVuv(cpu)));
-	XPUSHs(sv_2mortal(newSVuv(s)));
-	XPUSHs(sv_2mortal(newSVuv(ns)));
-	XPUSHs(sv_2mortal(newSViv(pid)));
-	XPUSHs(sv_2mortal(newSVpv(comm, 0)));
-
-	/* common fields other than pid can be accessed via xsub fns */
-
-	for (field = event->format.fields; field; field = field->next) {
-		if (field->flags & FIELD_IS_STRING) {
-			int offset;
-			if (field->flags & FIELD_IS_DYNAMIC) {
-				offset = *(int *)(data + field->offset);
-				offset &= 0xffff;
-			} else
-				offset = field->offset;
-			XPUSHs(sv_2mortal(newSVpv((char *)data + offset, 0)));
-		} else { /* FIELD_IS_NUMERIC */
-			val = read_size(data + field->offset, field->size);
-			if (field->flags & FIELD_IS_SIGNED) {
-				XPUSHs(sv_2mortal(newSViv(val)));
-			} else {
-				XPUSHs(sv_2mortal(newSVuv(val)));
-			}
-		}
-	}
-
-	PUTBACK;
-
-	if (get_cv(handler, 0))
-		call_pv(handler, G_SCALAR);
-	else if (get_cv("main::trace_unhandled", 0)) {
-		XPUSHs(sv_2mortal(newSVpv(handler, 0)));
-		XPUSHs(sv_2mortal(newSViv(PTR2IV(scripting_context))));
-		XPUSHs(sv_2mortal(newSVuv(cpu)));
-		XPUSHs(sv_2mortal(newSVuv(nsecs)));
-		XPUSHs(sv_2mortal(newSViv(pid)));
-		XPUSHs(sv_2mortal(newSVpv(comm, 0)));
-		call_pv("main::trace_unhandled", G_SCALAR);
-	}
-	SPAGAIN;
-	PUTBACK;
-	FREETMPS;
-	LEAVE;
-}
-
-static void run_start_sub(void)
-{
-	dSP; /* access to Perl stack */
-	PUSHMARK(SP);
-
-	if (get_cv("main::trace_begin", 0))
-		call_pv("main::trace_begin", G_DISCARD | G_NOARGS);
-}
-
-/*
- * Start trace script
- */
-static int perl_start_script(const char *script, int argc, const char **argv)
-{
-	const char **command_line;
-	int i, err = 0;
-
-	command_line = malloc((argc + 2) * sizeof(const char *));
-	command_line[0] = "";
-	command_line[1] = script;
-	for (i = 2; i < argc + 2; i++)
-		command_line[i] = argv[i - 2];
-
-	my_perl = perl_alloc();
-	perl_construct(my_perl);
-
-	if (perl_parse(my_perl, xs_init, argc + 2, (char **)command_line,
-		       (char **)NULL)) {
-		err = -1;
-		goto error;
-	}
-
-	if (perl_run(my_perl)) {
-		err = -1;
-		goto error;
-	}
-
-	if (SvTRUE(ERRSV)) {
-		err = -1;
-		goto error;
-	}
-
-	run_start_sub();
-
-	free(command_line);
-	fprintf(stderr, "perf trace started with Perl script %s\n\n", script);
-	return 0;
-error:
-	perl_free(my_perl);
-	free(command_line);
-
-	return err;
-}
-
-/*
- * Stop trace script
- */
-static int perl_stop_script(void)
-{
-	dSP; /* access to Perl stack */
-	PUSHMARK(SP);
-
-	if (get_cv("main::trace_end", 0))
-		call_pv("main::trace_end", G_DISCARD | G_NOARGS);
-
-	perl_destruct(my_perl);
-	perl_free(my_perl);
-
-	fprintf(stderr, "\nperf trace Perl script stopped\n");
-
-	return 0;
-}
-
-static int perl_generate_script(const char *outfile)
-{
-	struct event *event = NULL;
-	struct format_field *f;
-	char fname[PATH_MAX];
-	int not_first, count;
-	FILE *ofp;
-
-	sprintf(fname, "%s.pl", outfile);
-	ofp = fopen(fname, "w");
-	if (ofp == NULL) {
-		fprintf(stderr, "couldn't open %s\n", fname);
-		return -1;
-	}
-
-	fprintf(ofp, "# perf trace event handlers, "
-		"generated by perf trace -g perl\n");
-
-	fprintf(ofp, "# Licensed under the terms of the GNU GPL"
-		" License version 2\n\n");
-
-	fprintf(ofp, "# The common_* event handler fields are the most useful "
-		"fields common to\n");
-
-	fprintf(ofp, "# all events.  They don't necessarily correspond to "
-		"the 'common_*' fields\n");
-
-	fprintf(ofp, "# in the format files.  Those fields not available as "
-		"handler params can\n");
-
-	fprintf(ofp, "# be retrieved using Perl functions of the form "
-		"common_*($context).\n");
-
-	fprintf(ofp, "# See Context.pm for the list of available "
-		"functions.\n\n");
-
-	fprintf(ofp, "use lib \"$ENV{'PERF_EXEC_PATH'}/scripts/perl/"
-		"Perf-Trace-Util/lib\";\n");
-
-	fprintf(ofp, "use lib \"./Perf-Trace-Util/lib\";\n");
-	fprintf(ofp, "use Perf::Trace::Core;\n");
-	fprintf(ofp, "use Perf::Trace::Context;\n");
-	fprintf(ofp, "use Perf::Trace::Util;\n\n");
-
-	fprintf(ofp, "sub trace_begin\n{\n\t# optional\n}\n\n");
-	fprintf(ofp, "sub trace_end\n{\n\t# optional\n}\n\n");
-
-	while ((event = trace_find_next_event(event))) {
-		fprintf(ofp, "sub %s::%s\n{\n", event->system, event->name);
-		fprintf(ofp, "\tmy (");
-
-		fprintf(ofp, "$event_name, ");
-		fprintf(ofp, "$context, ");
-		fprintf(ofp, "$common_cpu, ");
-		fprintf(ofp, "$common_secs, ");
-		fprintf(ofp, "$common_nsecs,\n");
-		fprintf(ofp, "\t    $common_pid, ");
-		fprintf(ofp, "$common_comm,\n\t    ");
-
-		not_first = 0;
-		count = 0;
-
-		for (f = event->format.fields; f; f = f->next) {
-			if (not_first++)
-				fprintf(ofp, ", ");
-			if (++count % 5 == 0)
-				fprintf(ofp, "\n\t    ");
-
-			fprintf(ofp, "$%s", f->name);
-		}
-		fprintf(ofp, ") = @_;\n\n");
-
-		fprintf(ofp, "\tprint_header($event_name, $common_cpu, "
-			"$common_secs, $common_nsecs,\n\t             "
-			"$common_pid, $common_comm);\n\n");
-
-		fprintf(ofp, "\tprintf(\"");
-
-		not_first = 0;
-		count = 0;
-
-		for (f = event->format.fields; f; f = f->next) {
-			if (not_first++)
-				fprintf(ofp, ", ");
-			if (count && count % 4 == 0) {
-				fprintf(ofp, "\".\n\t       \"");
-			}
-			count++;
-
-			fprintf(ofp, "%s=", f->name);
-			if (f->flags & FIELD_IS_STRING ||
-			    f->flags & FIELD_IS_FLAG ||
-			    f->flags & FIELD_IS_SYMBOLIC)
-				fprintf(ofp, "%%s");
-			else if (f->flags & FIELD_IS_SIGNED)
-				fprintf(ofp, "%%d");
-			else
-				fprintf(ofp, "%%u");
-		}
-
-		fprintf(ofp, "\\n\",\n\t       ");
-
-		not_first = 0;
-		count = 0;
-
-		for (f = event->format.fields; f; f = f->next) {
-			if (not_first++)
-				fprintf(ofp, ", ");
-
-			if (++count % 5 == 0)
-				fprintf(ofp, "\n\t       ");
-
-			if (f->flags & FIELD_IS_FLAG) {
-				if ((count - 1) % 5 != 0) {
-					fprintf(ofp, "\n\t       ");
-					count = 4;
-				}
-				fprintf(ofp, "flag_str(\"");
-				fprintf(ofp, "%s::%s\", ", event->system,
-					event->name);
-				fprintf(ofp, "\"%s\", $%s)", f->name,
-					f->name);
-			} else if (f->flags & FIELD_IS_SYMBOLIC) {
-				if ((count - 1) % 5 != 0) {
-					fprintf(ofp, "\n\t       ");
-					count = 4;
-				}
-				fprintf(ofp, "symbol_str(\"");
-				fprintf(ofp, "%s::%s\", ", event->system,
-					event->name);
-				fprintf(ofp, "\"%s\", $%s)", f->name,
-					f->name);
-			} else
-				fprintf(ofp, "$%s", f->name);
-		}
-
-		fprintf(ofp, ");\n");
-		fprintf(ofp, "}\n\n");
-	}
-
-	fprintf(ofp, "sub trace_unhandled\n{\n\tmy ($event_name, $context, "
-		"$common_cpu, $common_secs, $common_nsecs,\n\t    "
-		"$common_pid, $common_comm) = @_;\n\n");
-
-	fprintf(ofp, "\tprint_header($event_name, $common_cpu, "
-		"$common_secs, $common_nsecs,\n\t             $common_pid, "
-		"$common_comm);\n}\n\n");
-
-	fprintf(ofp, "sub print_header\n{\n"
-		"\tmy ($event_name, $cpu, $secs, $nsecs, $pid, $comm) = @_;\n\n"
-		"\tprintf(\"%%-20s %%5u %%05u.%%09u %%8u %%-20s \",\n\t       "
-		"$event_name, $cpu, $secs, $nsecs, $pid, $comm);\n}");
-
-	fclose(ofp);
-
-	fprintf(stderr, "generated Perl script: %s\n", fname);
-
-	return 0;
-}
-
-struct scripting_ops perl_scripting_ops = {
-	.name = "Perl",
-	.start_script = perl_start_script,
-	.stop_script = perl_stop_script,
-	.process_event = perl_process_event,
-	.generate_script = perl_generate_script,
-};
-
-static void print_unsupported_msg(void)
-{
-	fprintf(stderr, "Perl scripting not supported."
-		"  Install libperl and rebuild perf to enable it.\n"
-		"For example:\n  # apt-get install libperl-dev (ubuntu)"
-		"\n  # yum install perl-ExtUtils-Embed (Fedora)"
-		"\n  etc.\n");
-}
-
-static int perl_start_script_unsupported(const char *script __unused,
-					 int argc __unused,
-					 const char **argv __unused)
-{
-	print_unsupported_msg();
-
-	return -1;
-}
-
-static int perl_stop_script_unsupported(void)
-{
-	return 0;
-}
-
-static void perl_process_event_unsupported(int cpu __unused,
-					   void *data __unused,
-					   int size __unused,
-					   unsigned long long nsecs __unused,
-					   char *comm __unused)
-{
-}
-
-static int perl_generate_script_unsupported(const char *outfile __unused)
-{
-	print_unsupported_msg();
-
-	return -1;
-}
-
-struct scripting_ops perl_scripting_unsupported_ops = {
-	.name = "Perl",
-	.start_script = perl_start_script_unsupported,
-	.stop_script = perl_stop_script_unsupported,
-	.process_event = perl_process_event_unsupported,
-	.generate_script = perl_generate_script_unsupported,
-};
-
-static void register_perl_scripting(struct scripting_ops *scripting_ops)
-{
-	int err;
-	err = script_spec_register("Perl", scripting_ops);
-	if (err)
-		die("error registering Perl script extension");
-
-	err = script_spec_register("pl", scripting_ops);
-	if (err)
-		die("error registering pl script extension");
-
-	scripting_context = malloc(sizeof(struct scripting_context));
-}
-
-#ifdef NO_LIBPERL
-void setup_perl_scripting(void)
-{
-	register_perl_scripting(&perl_scripting_unsupported_ops);
-}
-#else
-void setup_perl_scripting(void)
-{
-	register_perl_scripting(&perl_scripting_ops);
-}
-#endif
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
deleted file mode 100644
index 01efcc9..0000000
--- a/tools/perf/util/trace-event-perl.h
+++ /dev/null
@@ -1,47 +0,0 @@
-#ifndef __PERF_TRACE_EVENT_PERL_H
-#define __PERF_TRACE_EVENT_PERL_H
-#ifdef NO_LIBPERL
-typedef int INTERP;
-#define dSP
-#define ENTER
-#define SAVETMPS
-#define PUTBACK
-#define SPAGAIN
-#define FREETMPS
-#define LEAVE
-#define SP
-#define ERRSV
-#define G_SCALAR		(0)
-#define G_DISCARD		(0)
-#define G_NOARGS		(0)
-#define PUSHMARK(a)
-#define SvTRUE(a)		(0)
-#define XPUSHs(s)
-#define sv_2mortal(a)
-#define newSVpv(a,b)
-#define newSVuv(a)
-#define newSViv(a)
-#define get_cv(a,b)		(0)
-#define call_pv(a,b)		(0)
-#define perl_alloc()		(0)
-#define perl_construct(a)	(0)
-#define perl_parse(a,b,c,d,e)	(0)
-#define perl_run(a)		(0)
-#define perl_destruct(a)	(0)
-#define perl_free(a)		(0)
-#define pTHX			void
-#define CV			void
-#define dXSUB_SYS
-#define pTHX_
-static inline void newXS(const char *a, void *b, const char *c) {}
-static void boot_Perf__Trace__Context(pTHX_ CV *cv) {}
-static void boot_DynaLoader(pTHX_ CV *cv) {}
-#else
-#include <EXTERN.h>
-#include <perl.h>
-void boot_Perf__Trace__Context(pTHX_ CV *cv);
-void boot_DynaLoader(pTHX_ CV *cv);
-typedef PerlInterpreter * INTERP;
-#endif
-
-#endif /* __PERF_TRACE_EVENT_PERL_H */
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
new file mode 100644
index 0000000..9e37196
--- /dev/null
+++ b/tools/perf/util/trace-event-scripting.c
@@ -0,0 +1,106 @@
+/*
+ * trace-event-scripting.  Scripting engine common and initialization code.
+ *
+ * Copyright (C) 2009-2010 Tom Zanussi <tzanussi@gmail.com>
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
+#include "trace-event.h"
+
+struct scripting_context *scripting_context;
+
+static int stop_script_unsupported(void)
+{
+	return 0;
+}
+
+static void process_event_unsupported(int cpu __unused,
+				      void *data __unused,
+				      int size __unused,
+				      unsigned long long nsecs __unused,
+				      char *comm __unused)
+{
+}
+
+static void print_perl_unsupported_msg(void)
+{
+	fprintf(stderr, "Perl scripting not supported."
+		"  Install libperl and rebuild perf to enable it.\n"
+		"For example:\n  # apt-get install libperl-dev (ubuntu)"
+		"\n  # yum install 'perl(ExtUtils::Embed)' (Fedora)"
+		"\n  etc.\n");
+}
+
+static int perl_start_script_unsupported(const char *script __unused,
+					 int argc __unused,
+					 const char **argv __unused)
+{
+	print_perl_unsupported_msg();
+
+	return -1;
+}
+
+static int perl_generate_script_unsupported(const char *outfile __unused)
+{
+	print_perl_unsupported_msg();
+
+	return -1;
+}
+
+struct scripting_ops perl_scripting_unsupported_ops = {
+	.name = "Perl",
+	.start_script = perl_start_script_unsupported,
+	.stop_script = stop_script_unsupported,
+	.process_event = process_event_unsupported,
+	.generate_script = perl_generate_script_unsupported,
+};
+
+static void register_perl_scripting(struct scripting_ops *scripting_ops)
+{
+	int err;
+	err = script_spec_register("Perl", scripting_ops);
+	if (err)
+		die("error registering Perl script extension");
+
+	err = script_spec_register("pl", scripting_ops);
+	if (err)
+		die("error registering pl script extension");
+
+	scripting_context = malloc(sizeof(struct scripting_context));
+}
+
+#ifdef NO_LIBPERL
+void setup_perl_scripting(void)
+{
+	register_perl_scripting(&perl_scripting_unsupported_ops);
+}
+#else
+struct scripting_ops perl_scripting_ops;
+
+void setup_perl_scripting(void)
+{
+	register_perl_scripting(&perl_scripting_ops);
+}
+#endif
