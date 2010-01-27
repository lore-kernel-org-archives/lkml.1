Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854Ab0A0Iai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab0A0Iai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563Ab0A0Iae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:30:34 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:38170 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab0A0I2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KKcF+4W5ZX17IHEu0HfHM/UfwlUevQADfhj5nNa6lDwp8VXUVgr8QU2MfDOColw3rF
         RY27MgdNeQEFrxlHD/Jj79GSnxZX7Xv4niYfC+Wrr4f/Rv0NL9Evb4Ejx02n2IyTAvJ3
         loGZITcB2qzf65LL7dNEBgPXPswY+644Y0Gjs=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com
Subject: [PATCH 03/12] perf trace/scripting: move common code out of Perl-specific files
Date: Wed, 27 Jan 2010 02:27:54 -0600
Message-Id: <1264580883-15324-4-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
References: <1264580883-15324-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This stuff is needed by all scripting engines; move it from the Perl
engine source to a more common place.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/Context.c  |    5 ++-
 tools/perf/scripts/perl/Perf-Trace-Util/Context.xs |    3 +-
 tools/perf/util/trace-event-parse.c                |   15 +++++++++++
 tools/perf/util/trace-event-perl.c                 |   27 --------------------
 tools/perf/util/trace-event-perl.h                 |    8 ------
 tools/perf/util/trace-event.h                      |    9 ++++++-
 6 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
index af78d9a..01a64ad 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.c
@@ -31,13 +31,14 @@
 #include "EXTERN.h"
 #include "perl.h"
 #include "XSUB.h"
-#include "../../../util/trace-event-perl.h"
+#include "../../../perf.h"
+#include "../../../util/trace-event.h"
 
 #ifndef PERL_UNUSED_VAR
 #  define PERL_UNUSED_VAR(var) if (0) var = var
 #endif
 
-#line 41 "Context.c"
+#line 42 "Context.c"
 
 XS(XS_Perf__Trace__Context_common_pc); /* prototype to pass -Wmissing-prototypes */
 XS(XS_Perf__Trace__Context_common_pc)
diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
index fb78006..549cf04 100644
--- a/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/Context.xs
@@ -22,7 +22,8 @@
 #include "EXTERN.h"
 #include "perl.h"
 #include "XSUB.h"
-#include "../../../util/trace-event-perl.h"
+#include "../../../perf.h"
+#include "../../../util/trace-event.h"
 
 MODULE = Perf::Trace::Context		PACKAGE = Perf::Trace::Context
 PROTOTYPES: ENABLE
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index c5c32be..c1299ff 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -3277,3 +3277,18 @@ void parse_set_info(int nr_cpus, int long_sz)
 	cpus = nr_cpus;
 	long_size = long_sz;
 }
+
+int common_pc(struct scripting_context *context)
+{
+	return parse_common_pc(context->event_data);
+}
+
+int common_flags(struct scripting_context *context)
+{
+	return parse_common_flags(context->event_data);
+}
+
+int common_lock_depth(struct scripting_context *context)
+{
+	return parse_common_lock_depth(context->event_data);
+}
diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
index 6d6d76b..5b49df0 100644
--- a/tools/perf/util/trace-event-perl.c
+++ b/tools/perf/util/trace-event-perl.c
@@ -239,33 +239,6 @@ static inline struct event *find_cache_event(int type)
 	return event;
 }
 
-int common_pc(struct scripting_context *context)
-{
-	int pc;
-
-	pc = parse_common_pc(context->event_data);
-
-	return pc;
-}
-
-int common_flags(struct scripting_context *context)
-{
-	int flags;
-
-	flags = parse_common_flags(context->event_data);
-
-	return flags;
-}
-
-int common_lock_depth(struct scripting_context *context)
-{
-	int lock_depth;
-
-	lock_depth = parse_common_lock_depth(context->event_data);
-
-	return lock_depth;
-}
-
 static void perl_process_event(int cpu, void *data,
 			       int size __unused,
 			       unsigned long long nsecs, char *comm)
diff --git a/tools/perf/util/trace-event-perl.h b/tools/perf/util/trace-event-perl.h
index e88fb26..01efcc9 100644
--- a/tools/perf/util/trace-event-perl.h
+++ b/tools/perf/util/trace-event-perl.h
@@ -44,12 +44,4 @@ void boot_DynaLoader(pTHX_ CV *cv);
 typedef PerlInterpreter * INTERP;
 #endif
 
-struct scripting_context {
-	void *event_data;
-};
-
-int common_pc(struct scripting_context *context);
-int common_flags(struct scripting_context *context);
-int common_lock_depth(struct scripting_context *context);
-
 #endif /* __PERF_TRACE_EVENT_PERL_H */
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 6ad4056..aaf2da2 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -279,7 +279,14 @@ struct scripting_ops {
 
 int script_spec_register(const char *spec, struct scripting_ops *ops);
 
-extern struct scripting_ops perl_scripting_ops;
 void setup_perl_scripting(void);
 
+struct scripting_context {
+	void *event_data;
+};
+
+int common_pc(struct scripting_context *context);
+int common_flags(struct scripting_context *context);
+int common_lock_depth(struct scripting_context *context);
+
 #endif /* __PERF_TRACE_EVENTS_H */
-- 
1.6.4.GIT

