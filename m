Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZGTROc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZGTROc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZGTROb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:14:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41181 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409AbZGTROa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:14:30 -0400
Date: Mon, 20 Jul 2009 14:14:12 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/1 tip] perf symbol: C++ demangling
Message-ID: <20090720171412.GB10410@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka, you may be interessted in JAVA demangling, that is also supported
by bfd_demangle :-)

Thanks Clark for rescueing me from getting carried away doing DWARF
stuff for such simple stuff :-)

- Arnaldo

[acme@doppio ~]$ perf report -s comm,dso,symbol -C firefox -d /usr/lib64/xulrunner-1.9.1/libxul.so | grep :: | head
     2.21%  [.] nsDeque::Push(void*)
     1.78%  [.] GraphWalker::DoWalk(nsDeque&)
     1.30%  [.] GCGraphBuilder::AddNode(void*, nsCycleCollectionParticipant*)
     1.27%  [.] XPCWrappedNative::CallMethod(XPCCallContext&, XPCWrappedNative::CallMode)
     1.18%  [.] imgContainer::DrawFrameTo(gfxIImageFrame*, gfxIImageFrame*, nsRect&)
     1.13%  [.] nsDeque::PopFront()
     1.11%  [.] nsGlobalWindow::RunTimeout(nsTimeout*)
     0.97%  [.] nsXPConnect::Traverse(void*, nsCycleCollectionTraversalCallback&)
     0.95%  [.] nsJSEventListener::cycleCollection::Traverse(void*, nsCycleCollectionTraversalCallback&)
     0.95%  [.] nsCOMPtr_base::~nsCOMPtr_base()
[acme@doppio ~]$

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Suggested-by: Clark Williams <williams@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile      |    2 +-
 tools/perf/util/symbol.c |   21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7822b3d..a5e9b87 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS =
+EXTLIBS = -lbfd
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index f40266b..98aee92 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -6,9 +6,15 @@
 #include <libelf.h>
 #include <gelf.h>
 #include <elf.h>
+#include <bfd.h>
 
 const char *sym_hist_filter;
 
+#ifndef DMGL_PARAMS
+#define DMGL_PARAMS      (1 << 0)       /* Include function args */
+#define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
+#endif
+
 static struct symbol *symbol__new(u64 start, u64 len,
 				  const char *name, unsigned int priv_size,
 				  u64 obj_start, int verbose)
@@ -571,6 +577,8 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 						     NULL) != NULL);
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
+		const char *name;
+		char *demangled;
 		u64 obj_start;
 		struct section *section = NULL;
 		int is_label = elf_sym__is_label(&sym);
@@ -609,10 +617,19 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 				goto out_elf_end;
 			}
 		}
+		/*
+		 * We need to figure out if the object was created from C++ sources
+		 * DWARF DW_compile_unit has this, but we don't always have access
+		 * to it...
+		 */
+		name = elf_sym__name(&sym, symstrs);
+		demangled = bfd_demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
+		if (demangled != NULL)
+			name = demangled;
 
-		f = symbol__new(sym.st_value, sym.st_size,
-				elf_sym__name(&sym, symstrs),
+		f = symbol__new(sym.st_value, sym.st_size, name,
 				self->sym_priv_size, obj_start, verbose);
+		free(demangled);
 		if (!f)
 			goto out_elf_end;
 
-- 
1.6.2.5

