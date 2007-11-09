Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbXKIQgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbXKIQgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 11:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXKIQgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 11:36:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXKIQgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 11:36:38 -0500
Message-ID: <47348C88.8030304@redhat.com>
Date: Fri, 09 Nov 2007 10:36:24 -0600
From: David Smith <dsmith@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] markers: modpost
References: <20071015194120.GA22562@redhat.com> <20071015231209.GA18994@Krystal> <20071015235033.321E84D0389@magilla.localdomain> <20071025191722.GA6114@Krystal> <20071026142810.GA14814@redhat.com> <20071101010624.54D8D4D04AE@magilla.localdomain> <20071101024622.GA3343@Krystal> <20071101093725.891F34D04AE@magilla.localdomain> <20071101112407.GA24217@Krystal> <47336413.5030505@redhat.com> <20071108193617.GA31172@Krystal>
In-Reply-To: <20071108193617.GA31172@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Hrm, what would happen if a gcc optimization eventually decides to mix
> the memory layout of the strings ? Is there something that specifies
> that they won't ?

Here's another patch that Roland wrote and I tested that
attempts to solve the potential problem of string ordering
by merging the name and format strings.

---
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

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/marker.h   |    9 +--
 scripts/Makefile.modpost |   11 +++
 scripts/mod/modpost.c    |  163 +++++++++++++++++++++++++++++++++++++++++++++-
 scripts/mod/modpost.h    |    3 +
 4 files changed, 179 insertions(+), 7 deletions(-)

diff --git a/include/linux/marker.h b/include/linux/marker.h
index 5f36cf9..b978bbe 100644
--- a/include/linux/marker.h
+++ b/include/linux/marker.h
@@ -51,15 +51,12 @@ struct marker {
  */
 #define __trace_mark(generic, name, call_data, format, args...)		\
 	do {								\
-		static const char __mstrtab_name_##name[]		\
+		static const char __mstrtab_##name[]			\
 		__attribute__((section("__markers_strings")))		\
-		= #name;						\
-		static const char __mstrtab_format_##name[]		\
-		__attribute__((section("__markers_strings")))		\
-		= format;						\
+ 		= #name "\0" format;					\
 		static struct marker __mark_##name			\
 		__attribute__((section("__markers"), aligned(8))) =	\
-		{ __mstrtab_name_##name, __mstrtab_format_##name,	\
+		{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)],	\
 		0, __mark_empty_function, NULL };			\
 		__mark_check_format(format, ## args);			\
 		if (!generic) {						\
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index d988f5d..6321870 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
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
@@ -62,6 +67,8 @@ modpost = scripts/mod/modpost                    \
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
 
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 93ac52a..53887e8 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -11,6 +11,8 @@
  * Usage: modpost vmlinux module1.o module2.o ...
  */
 
+#define _GNU_SOURCE
+#include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
 #include "../../include/linux/license.h"
@@ -424,6 +426,8 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
+		else if (strcmp(secname, "__markers_strings") == 0)
+			info->markers_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -1249,6 +1253,62 @@ static int exit_section_ref_ok(const char *name)
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
@@ -1649,6 +1711,91 @@ static void write_dump(const char *fname)
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
+        if (!file)
+		/* No old markers, silently ignore */
+		return;
+
+	while ((line = get_next_line(&pos, file, size))) {
+		char *marker, *modname, *fmt;
+		struct module *mod;
+
+		marker = line;
+		if (!(modname = strchr(marker, '\t')))
+			goto fail;
+		*modname++ = '\0';
+		if (!(fmt = strchr(modname, '\t')))
+			goto fail;
+		*fmt++ = '\0';
+		if (*marker == '\0' || *modname == '\0')
+			goto fail;
+
+		if (!(mod = find_module(modname))) {
+			if (is_vmlinux(modname)) {
+				have_vmlinux = 1;
+			}
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
@@ -1656,10 +1803,12 @@ int main(int argc, char **argv)
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
@@ -1683,6 +1832,12 @@ int main(int argc, char **argv)
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
@@ -1724,5 +1879,11 @@ int main(int argc, char **argv)
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
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 0ffed17..175301a 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
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


