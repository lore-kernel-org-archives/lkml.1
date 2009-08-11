Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZHKTWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZHKTWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbZHKTWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:22:35 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46962 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbZHKTWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:22:34 -0400
Date: Tue, 11 Aug 2009 16:22:11 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Luis Claudio =?iso-8859-1?Q?R=2E_Gon=E7alves?= 
	<lclaudio@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH tip 3/3] perf tools: Fallback to cplus_demangle when
	bfd_demangle is not available
Message-ID: <20090811192211.GG18061@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In old binutils we can't access bfd_demangle, use cplus_demangle just
like oprofile.

Cc: Luis Claudio R. Gonçalves <lclaudio@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |   29 ++++++++++++++++++-----------
 tools/perf/util/symbol.c |   15 ---------------
 tools/perf/util/symbol.h |   24 ++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index de7beac..3ab09e5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -384,22 +384,29 @@ endif
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-
 	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
 
-	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
-
-	has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
-
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
-	else ifeq ($(has_bfd_iberty),y)
-		EXTLIBS += -lbfd -liberty
-	else ifeq ($(has_bfd_iberty_z),y)
-		EXTLIBS += -lbfd -liberty -lz
 	else
-		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
-		BASIC_CFLAGS += -DNO_DEMANGLE
+		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
+		ifeq ($(has_bfd_iberty),y)
+			EXTLIBS += -lbfd -liberty
+		else
+			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+			ifeq ($(has_bfd_iberty_z),y)
+				EXTLIBS += -lbfd -liberty -lz
+			else
+				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -liberty > /dev/null 2>&1 && echo y")
+				ifeq ($(has_cplus_demangle),y)
+					EXTLIBS += -liberty
+					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
+				else
+					msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
+					BASIC_CFLAGS += -DNO_DEMANGLE
+				endif
+			endif
+		endif
 	endif
 endif
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f1dcede..2473fd4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -7,23 +7,8 @@
 #include <gelf.h>
 #include <elf.h>
 
-#ifndef NO_DEMANGLE
-#include <bfd.h>
-#else
-static inline
-char *bfd_demangle(void __used *v, const char __used *c, int __used i)
-{
-	return NULL;
-}
-#endif
-
 const char *sym_hist_filter;
 
-#ifndef DMGL_PARAMS
-#define DMGL_PARAMS      (1 << 0)       /* Include function args */
-#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
-#endif
-
 enum dso_origin {
 	DSO__ORIG_KERNEL = 0,
 	DSO__ORIG_JAVA_JIT,
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 1e003ec..b53bf01 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -7,6 +7,30 @@
 #include <linux/rbtree.h>
 #include "module.h"
 
+#ifdef HAVE_CPLUS_DEMANGLE
+extern char *cplus_demangle(const char *, int);
+
+static inline char *bfd_demangle(void __used *v, const char *c, int i)
+{
+	return cplus_demangle(c, i);
+}
+#else
+#ifdef NO_DEMANGLE
+static inline char *bfd_demangle(void __used *v, const char __used *c,
+				 int __used i)
+{
+	return NULL;
+}
+#else
+#include <bfd.h>
+#endif
+#endif
+
+#ifndef DMGL_PARAMS
+#define DMGL_PARAMS      (1 << 0)       /* Include function args */
+#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
+#endif
+
 struct symbol {
 	struct rb_node	rb_node;
 	u64		start;
-- 
1.6.2.5

