Return-Path: <linux-kernel-owner+w=401wt.eu-S1764193AbXKMTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764193AbXKMTIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:08:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763977AbXKMTHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:07:41 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:45547 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763222AbXKMTHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:07:39 -0500
Message-Id: <20071113190642.486774218@polymtl.ca>
References: <20071113190302.988259011@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 13 Nov 2007 14:03:04 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Roland McGrath <roland@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC 2/3] Linux Kernel Markers - Create modpost file
Content-Disposition: inline; filename=linux-kernel-markers-create-modpost-file.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 13 Nov 2007 19:06:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds some new magic in the MODPOST phase for CONFIG_MARKERS.
Analogous to the Module.symvers file, the build will now write a
Module.markers file when CONFIG_MARKERS=y is set.  This file lists
the name, defining module, and format string of each marker,
separated by \t characters.  This simple text file can be used by
offline build procedures for instrumentation code, analogous to
how System.map and Module.symvers can be useful to have for
kernels other than the one you are running right now.

The strings are made easy to extract by having the __trace_mark macro
define the name and format together in a single array called __mstrtab_*
in the __markers_strings section.  This is straightforward and reliable
as long as the marker structs are always defined by this macro.  It is
an unreasonable amount of hairy work to extract the string pointers from
the __markers section structs, which entails handling a relocation type
for every machine under the sun.

Mathieu :
- Ran through checkpatch.pl

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/marker.h   |    9 --
 scripts/Makefile.modpost |   11 +++
 scripts/mod/modpost.c    |  164 ++++++++++++++++++++++++++++++++++++++++++++++-
 scripts/mod/modpost.h    |    3 
 4 files changed, 180 insertions(+), 7 deletions(-)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2007-11-13 09:38:34.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2007-11-13 09:38:36.000000000 -0500
@@ -61,15 +61,12 @@ struct marker {
  */
 #define __trace_mark(name, call_data, format, args...)			\
 	do {								\
-		static const char __mstrtab_name_##name[]		\
+		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
-		= #name;						\
-		static const char __mstrtab_format_##name[]		\
-		__attribute__((section("__markers_strings")))		\
-		= format;						\
+		= #name "\0" format;					\
 		static struct marker __mark_##name			\
 		__attribute__((section("__markers"), aligned(8))) =	\
-		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
+		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
 		0, 0, marker_probe_cb,					\
 		{ __mark_empty_function, NULL}, NULL };			\
 		__mark_check_format(format, ## args);			\
Index: linux-2.6-lttng/scripts/Makefile.modpost
===================================================================
--- linux-2.6-lttng.orig/scripts/Makefile.modpost	2007-11-13 09:25:30.000000000 -0500
+++ linux-2.6-lttng/scripts/Makefile.modpost	2007-11-13 09:38:36.000000000 -0500
@@ -13,6 +13,7 @@
 # 2) modpost is then used to
 # 3)  create one <module>.mod.c file pr. module
 # 4)  create one Module.symvers file with CRC for all exported symbols
+# 4a) [CONFIG_MARKERS] create one Module.markers file listing defined markers
 # 5) compile all <module>.mod.c files
 # 6) final link of the module to a <module.ko> file
 
@@ -45,6 +46,10 @@ include scripts/Makefile.lib
 
 kernelsymfile := $(objtree)/Module.symvers
 modulesymfile := $(firstword $(KBUILD_EXTMOD))/Module.symvers
+kernelmarkersfile := $(objtree)/Module.markers
+modulemarkersfile := $(firstword $(KBUILD_EXTMOD))/Module.markers
+
+markersfile = $(if $(KBUILD_EXTMOD),$(modulemarkersfile),$(kernelmarkersfile))
 
 # Step 1), find all modules listed in $(MODVERDIR)/
 __modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard $(MODVERDIR)/*.mod)))
@@ -62,6 +67,8 @@ modpost = scripts/mod/modpost           
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
+ $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \
+ $(if $(CONFIG_MARKERS),-M $(markersfile))	 \
  $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)
 
 quiet_cmd_modpost = MODPOST $(words $(filter-out vmlinux FORCE, $^)) modules
@@ -81,6 +88,10 @@ vmlinux.o: FORCE
 $(symverfile):         __modpost ;
 $(modules:.ko=.mod.c): __modpost ;
 
+ifdef CONFIG_MARKERS
+$(markersfile):	       __modpost ;
+endif
+
 
 # Step 5), compile all *.mod.c files
 
Index: linux-2.6-lttng/scripts/mod/modpost.c
===================================================================
--- linux-2.6-lttng.orig/scripts/mod/modpost.c	2007-11-13 09:25:30.000000000 -0500
+++ linux-2.6-lttng/scripts/mod/modpost.c	2007-11-13 09:41:23.000000000 -0500
@@ -11,6 +11,8 @@
  * Usage: modpost vmlinux module1.o module2.o ...
  */
 
+#define _GNU_SOURCE
+#include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
@@ -424,6 +426,8 @@ static int parse_elf(struct elf_info *in
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
+		else if (strcmp(secname, "__markers_strings") == 0)
+			info->markers_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -1249,6 +1253,62 @@ static int exit_section_ref_ok(const cha
 	return 0;
 }
 
+static void get_markers(struct elf_info *info, struct module *mod)
+{
+	const Elf_Shdr *sh = &info->sechdrs[info->markers_strings_sec];
+	const char *strings = (const char *) info->hdr + sh->sh_offset;
+	const Elf_Sym *sym, *first_sym, *last_sym;
+	size_t n;
+
+	if (!info->markers_strings_sec)
+		return;
+
+	/*
+	 * First count the strings.  We look for all the symbols defined
+	 * in the __markers_strings section named __mstrtab_*.  For
+	 * these local names, the compiler puts a random .NNN suffix on,
+	 * so the names don't correspond exactly.
+	 */
+	first_sym = last_sym = NULL;
+	n = 0;
+	for (sym = info->symtab_start; sym < info->symtab_stop; sym++)
+		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
+		    sym->st_shndx == info->markers_strings_sec &&
+		    !strncmp(info->strtab + sym->st_name,
+			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
+			if (first_sym == NULL)
+				first_sym = sym;
+			last_sym = sym;
+			++n;
+		}
+
+	if (n == 0)
+		return;
+
+	/*
+	 * Now collect each name and format into a line for the output.
+	 * Lines look like:
+	 *	marker_name	vmlinux	marker %s format %d
+	 * The format string after the second \t can use whitespace.
+	 */
+	mod->markers = NOFAIL(malloc(sizeof mod->markers[0] * n));
+	mod->nmarkers = n;
+
+	n = 0;
+	for (sym = first_sym; sym <= last_sym; sym++)
+		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
+		    sym->st_shndx == info->markers_strings_sec &&
+		    !strncmp(info->strtab + sym->st_name,
+			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
+			const char *name = strings + sym->st_value;
+			const char *fmt = strchr(name, '\0') + 1;
+			char *line = NULL;
+			asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
+			NOFAIL(line);
+			mod->markers[n++] = line;
+		}
+}
+
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1301,6 +1361,8 @@ static void read_symbols(char *modname)
 		get_src_version(modname, mod->srcversion,
 				sizeof(mod->srcversion)-1);
 
+	get_markers(&info, mod);
+
 	parse_elf_finish(&info);
 
 	/* Our trick to get versioning for struct_module - it's
@@ -1649,6 +1711,92 @@ static void write_dump(const char *fname
 	write_if_changed(&buf, fname);
 }
 
+static void add_marker(struct module *mod, const char *name, const char *fmt)
+{
+	char *line = NULL;
+	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
+	NOFAIL(line);
+
+	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
+						     sizeof mod->markers[0])));
+	mod->markers[mod->nmarkers++] = line;
+}
+
+static void read_markers(const char *fname)
+{
+	unsigned long size, pos = 0;
+	void *file = grab_file(fname, &size);
+	char *line;
+
+	if (!file)		/* No old markers, silently ignore */
+		return;
+
+	while ((line = get_next_line(&pos, file, size))) {
+		char *marker, *modname, *fmt;
+		struct module *mod;
+
+		marker = line;
+		modname = strchr(marker, '\t');
+		if (!modname)
+			goto fail;
+		*modname++ = '\0';
+		fmt = strchr(modname, '\t');
+		if (!fmt)
+			goto fail;
+		*fmt++ = '\0';
+		if (*marker == '\0' || *modname == '\0')
+			goto fail;
+
+		mod = find_module(modname);
+		if (!mod) {
+			if (is_vmlinux(modname))
+				have_vmlinux = 1;
+			mod = new_module(NOFAIL(strdup(modname)));
+			mod->skip = 1;
+		}
+
+		add_marker(mod, marker, fmt);
+	}
+	return;
+fail:
+	fatal("parse error in markers list file\n");
+}
+
+static int compare_strings(const void *a, const void *b)
+{
+	return strcmp(*(const char **) a, *(const char **) b);
+}
+
+static void write_markers(const char *fname)
+{
+	struct buffer buf = { };
+	struct module *mod;
+	size_t i;
+
+	for (mod = modules; mod; mod = mod->next)
+		if ((!external_module || !mod->skip) && mod->markers != NULL) {
+			/*
+			 * Sort the strings so we can skip duplicates when
+			 * we write them out.
+			 */
+			qsort(mod->markers, mod->nmarkers,
+			      sizeof mod->markers[0], &compare_strings);
+			for (i = 0; i < mod->nmarkers; ++i) {
+				char *line = mod->markers[i];
+				buf_write(&buf, line, strlen(line));
+				while (i + 1 < mod->nmarkers &&
+				       !strcmp(mod->markers[i],
+					       mod->markers[i + 1]))
+					free(mod->markers[i++]);
+				free(mod->markers[i]);
+			}
+			free(mod->markers);
+			mod->markers = NULL;
+		}
+
+	write_if_changed(&buf, fname);
+}
+
 int main(int argc, char **argv)
 {
 	struct module *mod;
@@ -1656,10 +1804,12 @@ int main(int argc, char **argv)
 	char fname[SZ];
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
+	char *markers_read = NULL;
+	char *markers_write = NULL;
 	int opt;
 	int err;
 
-	while ((opt = getopt(argc, argv, "i:I:mso:aw")) != -1) {
+	while ((opt = getopt(argc, argv, "i:I:mso:awM:K:")) != -1) {
 		switch(opt) {
 			case 'i':
 				kernel_read = optarg;
@@ -1683,6 +1833,12 @@ int main(int argc, char **argv)
 			case 'w':
 				warn_unresolved = 1;
 				break;
+			case 'M':
+				markers_write = optarg;
+				break;
+			case 'K':
+				markers_read = optarg;
+				break;
 			default:
 				exit(1);
 		}
@@ -1724,5 +1880,11 @@ int main(int argc, char **argv)
 	if (dump_write)
 		write_dump(dump_write);
 
+	if (markers_read)
+		read_markers(markers_read);
+
+	if (markers_write)
+		write_markers(markers_write);
+
 	return err;
 }
Index: linux-2.6-lttng/scripts/mod/modpost.h
===================================================================
--- linux-2.6-lttng.orig/scripts/mod/modpost.h	2007-11-13 09:25:30.000000000 -0500
+++ linux-2.6-lttng/scripts/mod/modpost.h	2007-11-13 09:38:36.000000000 -0500
@@ -110,6 +110,8 @@ struct module {
 	int has_init;
 	int has_cleanup;
 	struct buffer dev_table_buf;
+	char **markers;
+	size_t nmarkers;
 	char	     srcversion[25];
 };
 
@@ -124,6 +126,7 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
+	Elf_Section  markers_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
