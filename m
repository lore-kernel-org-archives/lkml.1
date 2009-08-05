Return-Path: <linux-kernel-owner+w=401wt.eu-S934212AbZHEMRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212AbZHEMRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934117AbZHEMRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:17:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:39302 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933721AbZHEMRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:17:09 -0400
Date: Wed, 5 Aug 2009 12:16:30 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, kyle@mcmartin.ca,
       jens.axboe@oracle.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       jens.axboe@oracle.com, kyle@mcmartin.ca, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090801082048.GX12579@kernel.dk>
References: <20090801082048.GX12579@kernel.dk>
Subject: [tip:perfcounters/urgent] perf: Auto-detect libbfd
Message-ID: <tip-2cdbc46d7b2cb0acb68c3ecad93b000552121fa6@git.kernel.org>
Git-Commit-ID: 2cdbc46d7b2cb0acb68c3ecad93b000552121fa6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 05 Aug 2009 12:16:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cdbc46d7b2cb0acb68c3ecad93b000552121fa6
Gitweb:     http://git.kernel.org/tip/2cdbc46d7b2cb0acb68c3ecad93b000552121fa6
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 5 Aug 2009 14:05:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 5 Aug 2009 14:12:08 +0200

perf: Auto-detect libbfd

Since the C++ demangling isn't needed for everybody and
bfd/iberty aren't widely/easily available on all machines, make
it optional.

It also allows you to forcefully disable demangling by using
NO_DEMANGLE=1 and otherwise tries to detect libbfd/libiberty
combinations that result in a compiling demangler.

Reported-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
LKML-Reference: <20090801082048.GX12579@kernel.dk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/Makefile      |   18 +++++++++++++++++-
 tools/perf/util/symbol.c |    9 +++++++++
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4b20fa4..ff905ac 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,6 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd -liberty
 
 #
 # Platform specific tweaks
@@ -374,6 +373,23 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
+ifdef NO_DEMANGLE
+	BASIC_CFLAGS += -DNO_DEMANGLE
+else
+
+	has_bfd := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd > /dev/null 2>&1 && echo y")
+
+	has_bfd_iberty := $(shell sh -c "(echo '\#include <stdio.h>'; echo '\#include <bfd.h>'; echo '\#ifndef DMGL_PARAMS'; echo '\#define DMGL_PARAMS (1 << 0)'; echo '\#define DMGL_ANSI (1 << 1)'; echo '\#endif'; echo 'int main(int argc, char **argv) { bfd_demangle(NULL, argv[0], DMGL_PARAMS | DMGL_ANSI); return 0; }') | gcc -x c - -lbfd -liberty > /dev/null 2>&1 && echo y")
+
+	ifeq ($(has_bfd),y)
+		EXTLIBS += -lbfd
+	else ifeq ($(has_bfd_iberty),y)
+		EXTLIBS += -lbfd -liberty
+	else
+		BASIC_CFLAGS += -DNO_DEMANGLE
+	endif
+endif
+
 ifndef CC_LD_DYNPATH
 	ifdef NO_R_TO_GCC_LINKER
 		# Some gcc does not accept and pass -R to the linker to specify
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b4fe057..0580b94 100644
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
 
