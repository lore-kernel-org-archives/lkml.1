Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab0BYDoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 22:44:30 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37233 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab0BYDmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 22:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZfPIUV01gvHtFtsFhq0cbKD3YMlxMIZlrD8DAQse9XlIbva67xJPISumAWO35H3dGu
         owiKfIivj0swDtKkCulxeAK7LwFlaFAYamqNl861NgUM2TTvWIF+MR191WptOqkl2m8n
         B7o1K3ZtHdAmtB/p2Qz/CLffwegs5NUyHyc6s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Keiichi KII <k-keiichi@bx.jp.nec.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 04/10] perf/scripts: Move Perl scripting files to scripting-engines dir
Date: Thu, 25 Feb 2010 04:42:35 +0100
Message-Id: <1267069361-10909-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
References: <1267069361-10909-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

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
 .../{ => scripting-engines}/trace-event-perl.c     |   88 ++--------------
 tools/perf/util/trace-event-perl.h                 |   47 ---------
 tools/perf/util/trace-event-scripting.c            |  106 ++++++++++++++++++++
 4 files changed, 122 insertions(+), 128 deletions(-)
 rename tools/perf/util/{ => scripting-engines}/trace-event-perl.c (87%)
 delete mode 100644 tools/perf/util/trace-event-perl.h
 create mode 100644 tools/perf/util/trace-event-scripting.c

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
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
similarity index 87%
rename from tools/perf/util/trace-event-perl.c
rename to tools/perf/util/scripting-engines/trace-event-perl.c
index 5b49df0..5376378 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -25,10 +25,16 @@
 #include <ctype.h>
 #include <errno.h>
 
-#include "../perf.h"
-#include "util.h"
-#include "trace-event.h"
-#include "trace-event-perl.h"
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
 
 void xs_init(pTHX);
 
@@ -49,7 +55,7 @@ INTERP my_perl;
 
 struct event *events[FTRACE_MAX_EVENT];
 
-static struct scripting_context *scripting_context;
+extern struct scripting_context *scripting_context;
 
 static char *cur_field_name;
 static int zero_flag_atom;
@@ -560,75 +566,3 @@ struct scripting_ops perl_scripting_ops = {
 	.process_event = perl_process_event,
 	.generate_script = perl_generate_script,
 };
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
-- 
1.6.2.3

