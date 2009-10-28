Return-Path: <linux-kernel-owner+w=401wt.eu-S1757468AbZJ1HH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757468AbZJ1HH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756691AbZJ1HH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:07:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbZJ1HH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:07:26 -0400
Date: Wed, 28 Oct 2009 09:04:59 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: support static build
Message-ID: <20091028070459.GA22695@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it possible to build perf statically, by performing
make LDFLAGS=-static
Since static libraries are only searched in the order they are
specified, move library list from LDFLAGS to EXTLIBS, so that
they are put at the end of linker command line.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/perf/Makefile |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 742a32e..ecf71ab 100644
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
@@ -202,7 +204,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
 CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
-LDFLAGS = -lpthread -lrt -lelf -lm
+EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
@@ -422,27 +424,27 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) > /dev/null && echo y"), y)
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
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
-- 
1.6.5.rc2
