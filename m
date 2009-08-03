Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZHCCAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZHCCAk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbZHCCAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:00:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59622 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbZHCCAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:00:39 -0400
Date: Sun, 2 Aug 2009 22:54:30 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090803015430.GG25334@ghostprotocols.net>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> <20090802201132.GE28572@bombadil.infradead.org> <20090802204701.GE25334@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802204701.GE25334@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Aug 02, 2009 at 05:47:01PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Sun, Aug 02, 2009 at 04:11:32PM -0400, Kyle McMartin escreveu:
> > On Sun, Aug 02, 2009 at 09:50:43PM +0200, Ingo Molnar wrote:
> > > We are sticking to a given version of the API. We could turn that 
> > > into a function pointer and fill it in during startup via dlopen(). 
> > > If it's NULL then we dont call it and assume a value of NULL.
> > > 
> > > Mind submitting such a version of your fix? It would nicely decrease 
> > > the build requirements cross section surface of perf.
> > > 
> > 
> > Assuming I remember how to use dlopen/dlsym, this might work.
> > Unfortunately I can't easily test anything this weekend, so
> > I don't actually know if it works... but it links ok.
> > 
> > cheers, Kyle
> 
> Doesn't seem to work, tried with firefox, with matching
> xulrunner-debuginfo package installed and symbols didn't got properly
> demangled, gotta be afk now, but will try to figure this out later.

The problem is that at least on f11, libbfd.so is a... linker script,
not an ELF shared library as the name seemed to imply.

But if I cheat and do a dlopen on the full name, that includes the
version, it works. Argh, I don't know why this has to be so contorted,
does anybody here understands this?

Anyway, the reworked patch below works and additionally doesn't dlopens
at each DSO, but just once and only if it finds a symbol starting with
an underscore, an heuristic to avoid loading bfd if we don't need it.

Looking at each DW_AT_language attribute in the DW_TAG_compile_unit
tags, trying to figure out if there is a C++ object in the mix seems too
much, we would have to traverse all of the compile units, touching most
of the debuginfo file :-\

- Arnaldo

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4b20fa4..8fb2e12 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd -liberty
+EXTLIBS = -ldl
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b4fe057..625f975 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -4,9 +4,9 @@
 #include "symbol.h"
 
 #include <libelf.h>
+#include <dlfcn.h>
 #include <gelf.h>
 #include <elf.h>
-#include <bfd.h>
 
 const char *sym_hist_filter;
 
@@ -512,6 +512,30 @@ out:
 	return 0;
 }
 
+static char *def_perf_bfd_demangle(void __used *v, const char __used *name,
+				   int __used opt)
+{
+	return NULL;
+}
+
+static char *(*perf_bfd_demangle)(void *v, const char *name, int opt);
+
+static void load_perf_bfd_demangle(void)
+{
+	void *handle = dlopen("libbfd-2.19.51.0.2-17.fc11.so", RTLD_NOW);
+
+	if (handle) {
+		perf_bfd_demangle = dlsym(handle, "bfd_demangle");
+		if (perf_bfd_demangle)
+			return;
+		dlclose(handle);
+	} else
+		fprintf(stderr, "%s: problems finding bfd_demangle: %s.\n",
+			__func__, dlerror());
+
+	perf_bfd_demangle = def_perf_bfd_demangle;
+}
+
 static int dso__load_sym(struct dso *self, int fd, const char *name,
 			 symbol_filter_t filter, int verbose, struct module *mod)
 {
@@ -581,7 +605,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		const char *name;
-		char *demangled;
+		char *demangled = NULL;
 		u64 obj_start;
 		struct section *section = NULL;
 		int is_label = elf_sym__is_label(&sym);
@@ -626,9 +650,16 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		 * to it...
 		 */
 		name = elf_sym__name(&sym, symstrs);
-		demangled = bfd_demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
-		if (demangled != NULL)
-			name = demangled;
+		if (name && name[0] == '_') {
+			if (perf_bfd_demangle == NULL)
+				load_perf_bfd_demangle();
+
+			if (perf_bfd_demangle != NULL) {
+				demangled = perf_bfd_demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
+				if (demangled != NULL)
+					name = demangled;
+			}
+		}
 
 		f = symbol__new(sym.st_value, sym.st_size, name,
 				self->sym_priv_size, obj_start, verbose);
