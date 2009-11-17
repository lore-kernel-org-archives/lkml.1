Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZKQJ1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZKQJ1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 04:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZKQJ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 04:27:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:43005 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZKQJ1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 04:27:32 -0500
Date: Tue, 17 Nov 2009 09:24:53 GMT
From: "tip-bot for Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, mst@redhat.com,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, mst@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091029152002.GA5406@redhat.com>
References: <20091029152002.GA5406@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Support static build
Message-ID: <tip-751386507701010831d72c522171753d2cd903d2@git.kernel.org>
Git-Commit-ID: 751386507701010831d72c522171753d2cd903d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  751386507701010831d72c522171753d2cd903d2
Gitweb:     http://git.kernel.org/tip/751386507701010831d72c522171753d2cd903d2
Author:     Michael S. Tsirkin <mst@redhat.com>
AuthorDate: Thu, 29 Oct 2009 17:20:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 17 Nov 2009 10:18:15 +0100

perf tools: Support static build

This makes it possible to build perf statically, by
performing:

  make LDFLAGS=-static

Since static libraries are only searched in the order they are
specified, move library list from LDFLAGS to EXTLIBS, so that
they are put at the end of linker command line.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20091029152002.GA5406@redhat.com>
[ v2: resolved conflicts ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3dbb5c5..5d1a8b0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -145,6 +145,8 @@ all::
 # Define NO_EXTERNAL_GREP if you don't want "perf grep" to ever call
 # your external grep (e.g., if your system lacks grep, if its grep is
 # broken, or spawning external process is slower than built-in grep perf has).
+#
+# Define LDFLAGS=-static to build a static binary.
 
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
@@ -208,7 +210,7 @@ ifndef PERF_DEBUG
 endif
 
 CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
-LDFLAGS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -470,19 +472,19 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) > /dev/null 2>&1 && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) > /dev/null 2>&1 && echo y"), y)
 	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]);
 endif
 
-	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) > /dev/null 2>&1 && echo y"), y)
 		BASIC_CFLAGS += -DLIBELF_NO_MMAP
 	endif
 else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) > /dev/null 2>&1 && echo y"), y)
 	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
@@ -494,20 +496,20 @@ endif
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
+	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -lbfd > /dev/null 2>&1 && echo y")
 
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else
-		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
+		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty > /dev/null 2>&1 && echo y")
 		ifeq ($(has_bfd_iberty),y)
 			EXTLIBS += -lbfd -liberty
 		else
-			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
 			ifeq ($(has_bfd_iberty_z),y)
 				EXTLIBS += -lbfd -liberty -lz
 			else
-				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -liberty > /dev/null 2>&1 && echo y")
+				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -liberty > /dev/null 2>&1 && echo y")
 				ifeq ($(has_cplus_demangle),y)
 					EXTLIBS += -liberty
 					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
