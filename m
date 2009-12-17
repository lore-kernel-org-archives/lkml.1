Return-Path: <linux-kernel-owner+w=401wt.eu-S1759232AbZLQH5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759232AbZLQH5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZLQH5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:57:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:60748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbZLQH5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:57:09 -0500
Date: Thu, 17 Dec 2009 07:54:37 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       gombasg@sztaki.hu, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com,
       borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, gombasg@sztaki.hu,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       srikar@linux.vnet.ibm.com, tglx@linutronix.de, mhiramat@redhat.com,
       borislav.petkov@amd.com, systemtap@sources.redhat.com, mingo@elte.hu
In-Reply-To: <20091216221618.13816.83296.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091216221618.13816.83296.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix libdwarf include path for Debian
Message-ID: <tip-27f3b24de03fc7cec6f2406f8525ad18086c2121@git.kernel.org>
Git-Commit-ID: 27f3b24de03fc7cec6f2406f8525ad18086c2121
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  27f3b24de03fc7cec6f2406f8525ad18086c2121
Gitweb:     http://git.kernel.org/tip/27f3b24de03fc7cec6f2406f8525ad18086c2121
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 16 Dec 2009 17:16:19 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 17 Dec 2009 08:06:41 +0100

perf probe: Fix libdwarf include path for Debian

Fix libdwarf include path to fit debian-like systems too.

Borislav Petkov reported:

> even after installing libdwarf-dev on my debian box here,
> make in tools/perf/ still complains that it cannot find libdwarf:
>
> Makefile:491: No libdwarf.h found or old libdwarf.h found, disables dwarf
> support. Please install libdwarf-dev/libdwarf-devel >= 20081231
>
> The problem is that the include path on debian is not
> /usr/include/libdwarf/ but simply /usr/include because the debian
> package libdwarf-dev puts the headers straight into
> /usr/include.

This patch adds -I/usr/include/libdwarf to BASIC_CFLAGS
and fix probe-finder.h to include just libdwarf.h/dwarf.h.

This patch also adds a workaround for the undefined _MIPS_SZLONG
bug in libdwarf.h.

Reported-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Gabor Gombas <gombasg@sztaki.hu>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20091216221618.13816.83296.stgit@dhcp-100-2-132.bos.redhat.com>
[ v2: small stylistic fixlets to probe-finder.h ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile            |    3 +-
 tools/perf/util/probe-finder.h |   59 +++++++++++++++++++++------------------
 2 files changed, 34 insertions(+), 28 deletions(-)

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
index 5e4050c..a4086aa 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -1,9 +1,9 @@
 #ifndef _PROBE_FINDER_H
 #define _PROBE_FINDER_H
 
-#define MAX_PATH_LEN 256
-#define MAX_PROBE_BUFFER 1024
-#define MAX_PROBES 128
+#define MAX_PATH_LEN		 256
+#define MAX_PROBE_BUFFER	1024
+#define MAX_PROBES		 128
 
 static inline int is_c_varname(const char *name)
 {
@@ -12,48 +12,53 @@ static inline int is_c_varname(const char *name)
 }
 
 struct probe_point {
-	char	*event;		/* Event name */
-	char	*group;		/* Event group */
+	char			*event;			/* Event name */
+	char			*group;			/* Event group */
 
 	/* Inputs */
-	char	*file;		/* File name */
-	int	line;		/* Line number */
+	char			*file;			/* File name */
+	int			line;			/* Line number */
 
-	char	*function;	/* Function name */
-	int	offset;		/* Offset bytes */
+	char			*function;		/* Function name */
+	int			offset;			/* Offset bytes */
 
-	int	nr_args;	/* Number of arguments */
-	char	**args;		/* Arguments */
+	int			nr_args;		/* Number of arguments */
+	char			**args;			/* Arguments */
 
-	int	retprobe;	/* Return probe */
+	int			retprobe;		/* Return probe */
 
 	/* Output */
-	int	found;		/* Number of found probe points */
-	char	*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
+	int			found;			/* Number of found probe points */
+	char			*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
 };
 
 #ifndef NO_LIBDWARF
 extern int find_probepoint(int fd, struct probe_point *pp);
 
-#include <libdwarf/dwarf.h>
-#include <libdwarf/libdwarf.h>
+/* Workaround for undefined _MIPS_SZLONG bug in libdwarf.h: */
+#ifndef _MIPS_SZLONG
+# define _MIPS_SZLONG		0
+#endif
+
+#include <dwarf.h>
+#include <libdwarf.h>
 
 struct probe_finder {
-	struct probe_point	*pp;	/* Target probe point */
+	struct probe_point	*pp;			/* Target probe point */
 
 	/* For function searching */
-	Dwarf_Addr	addr;		/* Address */
-	Dwarf_Unsigned	fno;		/* File number */
-	Dwarf_Unsigned	lno;		/* Line number */
-	Dwarf_Off	inl_offs;	/* Inline offset */
-	Dwarf_Die	cu_die;		/* Current CU */
+	Dwarf_Addr		addr;			/* Address */
+	Dwarf_Unsigned		fno;			/* File number */
+	Dwarf_Unsigned		lno;			/* Line number */
+	Dwarf_Off		inl_offs;		/* Inline offset */
+	Dwarf_Die		cu_die;			/* Current CU */
 
 	/* For variable searching */
-	Dwarf_Addr	cu_base;	/* Current CU base address */
-	Dwarf_Locdesc	fbloc;		/* Location of Current Frame Base */
-	const char	*var;		/* Current variable name */
-	char		*buf;		/* Current output buffer */
-	int		len;		/* Length of output buffer */
+	Dwarf_Addr		cu_base;		/* Current CU base address */
+	Dwarf_Locdesc		fbloc;			/* Location of Current Frame Base */
+	const char		*var;			/* Current variable name */
+	char			*buf;			/* Current output buffer */
+	int			len;			/* Length of output buffer */
 };
 #endif /* NO_LIBDWARF */
 
