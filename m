Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab0APQ7s (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 11:59:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712Ab0APQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 11:59:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48312 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451Ab0APQ7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 11:59:45 -0500
Date: Sat, 16 Jan 2010 17:59:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?unknown-8bit?B?RnLDqWTDqXJpYw==?= Weisbecker 
	<fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf events fixes
Message-ID: <20100116165932.GA11336@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (2):
      perf tools: Move QUIET_STDERR def to before first use
      perf tools: Check if /dev/null can be used as the -o gcc argument

Frederic Weisbecker (1):
      perf: Stop stack frame walking off kernel addresses boundaries


 arch/x86/kernel/dumpstack.c |   14 +++++++-----
 tools/perf/Makefile         |   44 +++++++++++++++++++++++++++---------------
 2 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index c56bc28..6d81755 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -123,13 +123,15 @@ print_context_stack_bp(struct thread_info *tinfo,
 	while (valid_stack_ptr(tinfo, ret_addr, sizeof(*ret_addr), end)) {
 		unsigned long addr = *ret_addr;
 
-		if (__kernel_text_address(addr)) {
-			ops->address(data, addr, 1);
-			frame = frame->next_frame;
-			ret_addr = &frame->return_address;
-			print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
-		}
+		if (!__kernel_text_address(addr))
+			break;
+
+		ops->address(data, addr, 1);
+		frame = frame->next_frame;
+		ret_addr = &frame->return_address;
+		print_ftrace_graph_addr(addr, data, ops, tinfo, graph);
 	}
+
 	return (unsigned long)frame;
 }
 EXPORT_SYMBOL_GPL(print_context_stack_bp);
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 652a470..2e7fa3a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -250,7 +250,19 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
-ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null "$(QUIET_STDERR)" && echo y"), y)
+ifeq ($(V), 2)
+	QUIET_STDERR = ">/dev/null"
+else
+	QUIET_STDERR = ">/dev/null 2>&1"
+endif
+
+BITBUCKET = "/dev/null"
+
+ifneq ($(shell sh -c "(echo '\#include <stdio.h>'; echo 'int main(void) { return puts(\"hi\"); }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) "$(QUIET_STDERR)" && echo y"), y)
+	BITBUCKET = .perf.dev.null
+endif
+
+ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o $(BITBUCKET) "$(QUIET_STDERR)" && echo y"), y)
   CFLAGS := $(CFLAGS) -fstack-protector-all
 endif
 
@@ -451,11 +463,6 @@ BUILTIN_OBJS += builtin-kmem.o
 
 PERFLIBS = $(LIB_FILE)
 
-ifeq ($(V), 2)
-	QUIET_STDERR = ">/dev/null"
-else
-	QUIET_STDERR = ">/dev/null 2>&1"
-endif
 #
 # Platform specific tweaks
 #
@@ -483,19 +490,19 @@ ifeq ($(uname_S),Darwin)
 	PTHREAD_LIBS =
 endif
 
-ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
-ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifeq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <gnu/libc-version.h>'; echo 'int main(void) { const char * version = gnu_get_libc_version(); return (long)version; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(error No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static);
 endif
 
-	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+	ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf * elf = elf_begin(0, ELF_C_READ_MMAP, 0); return (long)elf; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 		BASIC_CFLAGS += -DLIBELF_NO_MMAP
 	endif
 else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#ifndef _MIPS_SZLONG'; echo '\#define _MIPS_SZLONG 0'; echo '\#endif'; echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/libdwarf -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#ifndef _MIPS_SZLONG'; echo '\#define _MIPS_SZLONG 0'; echo '\#endif'; echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/libdwarf -ldwarf -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
@@ -509,7 +516,7 @@ PERL_EMBED_LDOPTS = `perl -MExtUtils::Embed -e ldopts 2>/dev/null`
 PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o /dev/null $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#include <EXTERN.h>'; echo '\#include <perl.h>'; echo 'int main(void) { perl_alloc(); return 0; }') | $(CC) -x c - $(PERL_EMBED_CCOPTS) -o $(BITBUCKET) $(PERL_EMBED_LDOPTS) > /dev/null 2>&1 && echo y"), y)
 	BASIC_CFLAGS += -DNO_LIBPERL
 else
 	ALL_LDFLAGS += $(PERL_EMBED_LDOPTS)
@@ -519,20 +526,20 @@ endif
 ifdef NO_DEMANGLE
 	BASIC_CFLAGS += -DNO_DEMANGLE
 else
-	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
+	has_bfd := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd "$(QUIET_STDERR)" && echo y")
 
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else
-		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty "$(QUIET_STDERR)" && echo y")
+		has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty "$(QUIET_STDERR)" && echo y")
 		ifeq ($(has_bfd_iberty),y)
 			EXTLIBS += -lbfd -liberty
 		else
-			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz "$(QUIET_STDERR)" && echo y")
+			has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -lbfd -liberty -lz "$(QUIET_STDERR)" && echo y")
 			ifeq ($(has_bfd_iberty_z),y)
 				EXTLIBS += -lbfd -liberty -lz
 			else
-				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) -liberty "$(QUIET_STDERR)" && echo y")
+				has_cplus_demangle := $(shell sh -c "(echo 'extern char *cplus_demangle(const char *, int);'; echo 'int main(void) { cplus_demangle(0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) -liberty "$(QUIET_STDERR)" && echo y")
 				ifeq ($(has_cplus_demangle),y)
 					EXTLIBS += -liberty
 					BASIC_CFLAGS += -DHAVE_CPLUS_DEMANGLE
@@ -780,7 +787,7 @@ export TAR INSTALL DESTDIR SHELL_PATH
 
 SHELL = $(SHELL_PATH)
 
-all:: shell_compatibility_test $(ALL_PROGRAMS) $(BUILT_INS) $(OTHER_PROGRAMS) PERF-BUILD-OPTIONS
+all:: .perf.dev.null shell_compatibility_test $(ALL_PROGRAMS) $(BUILT_INS) $(OTHER_PROGRAMS) PERF-BUILD-OPTIONS
 ifneq (,$X)
 	$(foreach p,$(patsubst %$X,%,$(filter %$X,$(ALL_PROGRAMS) $(BUILT_INS) perf$X)), test '$p' -ef '$p$X' || $(RM) '$p';)
 endif
@@ -1107,6 +1114,11 @@ clean:
 .PHONY: .FORCE-PERF-VERSION-FILE TAGS tags cscope .FORCE-PERF-CFLAGS
 .PHONY: .FORCE-PERF-BUILD-OPTIONS
 
+.perf.dev.null:
+		touch .perf.dev.null
+
+.INTERMEDIATE:	.perf.dev.null
+
 ### Make sure built-ins do not have dups and listed in perf.c
 #
 check-builtins::
