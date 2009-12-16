Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbZLPWMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbZLPWMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbZLPWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:12:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40365 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZLPWMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:12:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip] perf probe: Fix libdwarf include path
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Gabor Gombas <gombasg@sztaki.hu>,
       Borislav Petkov <borislav.petkov@amd.com>
Date: Wed, 16 Dec 2009 17:16:19 -0500
Message-ID: <20091216221618.13816.83296.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091216135448.GD11618@aftab>
References: <20091216135448.GD11618@aftab>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix libdwarf include path to fit debian-like systems too.

Borislav Petkov said:
> even after installing libdwarf-dev on my debian box here, make in
> tools/perf/
> still complains that it cannot find libdwarf:
>
> Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf
> support. Please install libdwarf-dev/libdwarf-devel >= 20081231
>
> The problem is that the include path on debian is not
> /usr/include/libdwarf/ but simply /usr/include because the debian
> package libdwarf-dev puts the headers straight into /usr/include.

This patch adds -I/usr/include/libdwarf to BASIC_CFLAGS
and fix probe-finder.h to include just libdwarf.h/dwarf.h.

This patch also add a workaround for undefined _MIPS_SZLONG bug
in libdwarf.h.

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>
---

 tools/perf/Makefile            |    3 ++-
 tools/perf/util/probe-finder.h |    9 +++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7814dbb..4390d22 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -487,10 +487,11 @@ else
 	msg := $(error No libelf.h/libelf found, please install libelf-dev/elfutils-libelf-devel and glibc-dev[el]);
 endif
 
-ifneq ($(shell sh -c "(echo '\#include <libdwarf/dwarf.h>'; echo '\#include <libdwarf/libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
+ifneq ($(shell sh -c "(echo '\#ifndef _MIPS_SZLONG'; echo '\#define _MIPS_SZLONG 0'; echo '\#endif'; echo '\#include <dwarf.h>'; echo '\#include <libdwarf.h>'; echo 'int main(void) { Dwarf_Debug dbg; Dwarf_Error err; Dwarf_Ranges *rng; dwarf_init(0, DW_DLC_READ, 0, 0, &dbg, &err); dwarf_get_ranges(dbg, 0, &rng, 0, 0, &err); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/libdwarf -ldwarf -lelf -o /dev/null $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdwarf.h found or old libdwarf.h found, disables dwarf support. Please install libdwarf-dev/libdwarf-devel >= 20081231);
 	BASIC_CFLAGS += -DNO_LIBDWARF
 else
+	BASIC_CFLAGS += -I/usr/include/libdwarf
 	EXTLIBS += -lelf -ldwarf
 	LIB_OBJS += util/probe-finder.o
 endif
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 5e4050c..b6858f4 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -35,8 +35,13 @@ struct probe_point {
 #ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
 
-#include <libdwarf/dwarf.h>
-#include <libdwarf/libdwarf.h>
+/* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h */
+#ifndef _MIPS_SZLONG
+#define _MIPS_SZLONG 0
+#endif
+
+#include <dwarf.h>
+#include <libdwarf.h>
 
 struct probe_finder {
 	struct probe_point	*pp;	/* Target probe point */


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
