Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbZHBULt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbZHBULt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZHBULt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:11:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbZHBULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:11:48 -0400
Date: Sun, 2 Aug 2009 16:11:32 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802201132.GE28572@bombadil.infradead.org>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802195043.GD24486@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 02, 2009 at 09:50:43PM +0200, Ingo Molnar wrote:
> We are sticking to a given version of the API. We could turn that 
> into a function pointer and fill it in during startup via dlopen(). 
> If it's NULL then we dont call it and assume a value of NULL.
> 
> Mind submitting such a version of your fix? It would nicely decrease 
> the build requirements cross section surface of perf.
> 

Assuming I remember how to use dlopen/dlsym, this might work.
Unfortunately I can't easily test anything this weekend, so
I don't actually know if it works... but it links ok.

cheers, Kyle

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a5e9b87..8fb2e12 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -345,7 +345,7 @@ BUILTIN_OBJS += builtin-stat.o
 BUILTIN_OBJS += builtin-top.o
 
 PERFLIBS = $(LIB_FILE)
-EXTLIBS = -lbfd
+EXTLIBS = -ldl
 
 #
 # Platform specific tweaks
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 2810605..e41cb71 100644
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
 
@@ -512,6 +512,11 @@ out:
 	return 0;
 }
 
+static char *perf_bfd_demangle(void __used *v,
+	const char __used *name, int __used opt) {
+	return NULL;
+}
+
 static int dso__load_sym(struct dso *self, int fd, const char *name,
 			 symbol_filter_t filter, int verbose, struct module *mod)
 {
@@ -526,6 +531,8 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	Elf_Scn *sec, *sec_strndx;
 	Elf *elf;
 	int nr = 0, kernel = !strcmp("[kernel]", self->name);
+	char *(*demangle)(void *v, const char *name, int opt) = NULL;
+	void *handle;
 
 	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
 	if (elf == NULL) {
@@ -578,6 +585,13 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 						     NULL) != NULL);
 	} else self->adjust_symbols = 0;
 
+	handle = dlopen("libbfd.so", RTLD_NOW);
+	if (!handle)
+		demangle = perf_bfd_demangle;
+	demangle = dlsym(handle, "bfd_demangle");
+	if (!demangle)
+		demangle = perf_bfd_demangle;
+
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		const char *name;
@@ -592,7 +606,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 
 		sec = elf_getscn(elf, sym.st_shndx);
 		if (!sec)
-			goto out_elf_end;
+			goto out_dlclose;
 
 		gelf_getshdr(sec, &shdr);
 
@@ -617,7 +631,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 			else {
 				fprintf(stderr, "dso__load_sym() module %s lookup of %s failed\n",
 					mod->name, section_name);
-				goto out_elf_end;
+				goto out_dlclose;
 			}
 		}
 		/*
@@ -626,7 +640,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		 * to it...
 		 */
 		name = elf_sym__name(&sym, symstrs);
-		demangled = bfd_demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
+		demangled = demangle(NULL, name, DMGL_PARAMS | DMGL_ANSI);
 		if (demangled != NULL)
 			name = demangled;
 
@@ -634,7 +648,7 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 				self->sym_priv_size, obj_start, verbose);
 		free(demangled);
 		if (!f)
-			goto out_elf_end;
+			goto out_dlclose;
 
 		if (filter && filter(self, f))
 			symbol__delete(f, self->sym_priv_size);
@@ -646,6 +660,9 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	}
 
 	err = nr;
+out_dlclose:
+	if (handle)
+		dlclose(handle);
 out_elf_end:
 	elf_end(elf);
 out_close:
