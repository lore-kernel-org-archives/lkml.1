Return-Path: <linux-kernel-owner+w=401wt.eu-S1752555AbZJQAHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbZJQAHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZJQAHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:07:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbZJQAHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:07:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 5/9] perf: Check libdwarf APIs for perf
	probe
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:07:52 -0400
Message-ID: <20091017000752.16556.92051.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check libdwarf APIs for perf probe in tools/perf/Makefile. Since
dwarf_get_ranges() has been added from libdwarf 20081231 (and it's
the newest function used in probe-finder.c), this just checks
whether the function is defined.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
-
---

 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 52b1f43..03c27b9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -420,8 +420,8 @@ ifneq ($(shell sh -c "(echo '\#include <libelf.h>'; echo 'int main(void) { Elf *
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
-	msg := $(warning No libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel);
+ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) > /dev/null 2>&1 && echo y"), y)
+	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
 	EXTLIBS += -lelf -ldwarf


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
