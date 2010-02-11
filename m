Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab0BKAYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:24:54 -0500
Received: from borg.medozas.de ([188.40.89.202]:45815 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab0BKAYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:24:52 -0500
Date: Thu, 11 Feb 2010 01:24:49 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: tools/perf: libraries must come after objects
Message-ID: <alpine.LSU.2.01.1002110124030.13770@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parent b4bdd73ce865213a5653dc424873e8da37e858cc (v2.6.32.7)
commit 588424af1a51fa41ea4811200889d6a03219c6fd
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Feb 11 01:20:54 2010 +0100

tools/perf: libraries must come after objects

Link order matters, especially now since distributions are
using -Wl,--as-needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 tools/perf/Makefile |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e190d5..9c688cd 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -201,7 +201,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
 CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
-LDFLAGS = -lpthread -lrt -lelf -lm
+LDLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -421,8 +421,8 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(LDFLAGS) $(LDLIBS) > /dev/null 2>&1 && echo y"), y)
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(LDFLAGS) $(LDLIBS) > /dev/null 2>&1 && echo y"), y)
 		BASIC_CFLAGS += -DLIBELF_NO_MMAP
 	endif
 else
@@ -432,20 +432,20 @@ endif
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd > /dev/null 2>&1 && echo y")
+	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(LDFLAGS) $(LDLIBS) -lbfd > /dev/null 2>&1 && echo y")
 
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else
-		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
+		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(LDFLAGS) $(LDLIBS) -lbfd -liberty > /dev/null 2>&1 && echo y")
 		ifeq ($(has_bfd_iberty),y)
 			EXTLIBS += -lbfd -liberty
 		else
-			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(LDFLAGS) $(LDLIBS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
 			ifeq ($(has_bfd_iberty_z),y)
 				EXTLIBS += -lbfd -liberty -lz
 			else
-				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -liberty > /dev/null 2>&1 && echo y")
+				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(LDFLAGS) $(LDLIBS) -liberty > /dev/null 2>&1 && echo y")
 				ifeq ($(has_cplus_demangle),y)
 					EXTLIBS += -liberty
 					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
@@ -677,7 +677,7 @@ prefix_SQ = $(subst ','\'',$(prefix))
 SHELL_PATH_SQ = $(subst ','\'',$(SHELL_PATH))
 PERL_PATH_SQ = $(subst ','\'',$(PERL_PATH))
 
-LIBS = $(PERFLIBS) $(EXTLIBS)
+LIBS = $(PERFLIBS) $(LDLIBS) $(EXTLIBS)
 
 BASIC_CFLAGS += -DSHA1_HEADER='$(SHA1_HEADER_SQ)' \
 	$(COMPAT_CFLAGS)
-- 
# Created with git-export-patch

