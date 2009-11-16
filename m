Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbZKPFxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbZKPFxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZKPFxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:53:15 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:25904 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbZKPFxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:53:05 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] Kbuild: clear marker out of modpost
Date: Mon, 16 Nov 2009 13:49:55 +0800
Message-Id: <1258350595-19285-2-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
References: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B00E8C3.008F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecessary functions and variables.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 scripts/mod/modpost.c |  164 -------------------------------------------------
 scripts/mod/modpost.h |    3 -
 2 files changed, 0 insertions(+), 167 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 801a16a..204e3f0 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -451,8 +451,6 @@ static int parse_elf(struct elf_info *info, const char *filename)
 			info->export_unused_gpl_sec = i;
 		else if (strcmp(secname, "__ksymtab_gpl_future") == 0)
 			info->export_gpl_future_sec = i;
-		else if (strcmp(secname, "__markers_strings") == 0)
-			info->markers_strings_sec = i;
 
 		if (sechdrs[i].sh_type != SHT_SYMTAB)
 			continue;
@@ -1509,62 +1507,6 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	}
 }
 
-static void get_markers(struct elf_info *info, struct module *mod)
-{
-	const Elf_Shdr *sh = &info->sechdrs[info->markers_strings_sec];
-	const char *strings = (const char *) info->hdr + sh->sh_offset;
-	const Elf_Sym *sym, *first_sym, *last_sym;
-	size_t n;
-
-	if (!info->markers_strings_sec)
-		return;
-
-	/*
-	 * First count the strings.  We look for all the symbols defined
-	 * in the __markers_strings section named __mstrtab_*.  For
-	 * these local names, the compiler puts a random .NNN suffix on,
-	 * so the names don't correspond exactly.
-	 */
-	first_sym = last_sym = NULL;
-	n = 0;
-	for (sym = info->symtab_start; sym < info->symtab_stop; sym++)
-		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
-		    sym->st_shndx == info->markers_strings_sec &&
-		    !strncmp(info->strtab + sym->st_name,
-			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
-			if (first_sym == NULL)
-				first_sym = sym;
-			last_sym = sym;
-			++n;
-		}
-
-	if (n == 0)
-		return;
-
-	/*
-	 * Now collect each name and format into a line for the output.
-	 * Lines look like:
-	 *	marker_name	vmlinux	marker %s format %d
-	 * The format string after the second \t can use whitespace.
-	 */
-	mod->markers = NOFAIL(malloc(sizeof mod->markers[0] * n));
-	mod->nmarkers = n;
-
-	n = 0;
-	for (sym = first_sym; sym <= last_sym; sym++)
-		if (ELF_ST_TYPE(sym->st_info) == STT_OBJECT &&
-		    sym->st_shndx == info->markers_strings_sec &&
-		    !strncmp(info->strtab + sym->st_name,
-			     "__mstrtab_", sizeof "__mstrtab_" - 1)) {
-			const char *name = strings + sym->st_value;
-			const char *fmt = strchr(name, '\0') + 1;
-			char *line = NULL;
-			asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
-			NOFAIL(line);
-			mod->markers[n++] = line;
-		}
-}
-
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1620,8 +1562,6 @@ static void read_symbols(char *modname)
 		get_src_version(modname, mod->srcversion,
 				sizeof(mod->srcversion)-1);
 
-	get_markers(&info, mod);
-
 	parse_elf_finish(&info);
 
 	/* Our trick to get versioning for module struct etc. - it's
@@ -1976,96 +1916,6 @@ static void write_dump(const char *fname)
 	write_if_changed(&buf, fname);
 }
 
-static void add_marker(struct module *mod, const char *name, const char *fmt)
-{
-	char *line = NULL;
-	asprintf(&line, "%s\t%s\t%s\n", name, mod->name, fmt);
-	NOFAIL(line);
-
-	mod->markers = NOFAIL(realloc(mod->markers, ((mod->nmarkers + 1) *
-						     sizeof mod->markers[0])));
-	mod->markers[mod->nmarkers++] = line;
-}
-
-static void read_markers(const char *fname)
-{
-	unsigned long size, pos = 0;
-	void *file = grab_file(fname, &size);
-	char *line;
-
-	if (!file)		/* No old markers, silently ignore */
-		return;
-
-	while ((line = get_next_line(&pos, file, size))) {
-		char *marker, *modname, *fmt;
-		struct module *mod;
-
-		marker = line;
-		modname = strchr(marker, '\t');
-		if (!modname)
-			goto fail;
-		*modname++ = '\0';
-		fmt = strchr(modname, '\t');
-		if (!fmt)
-			goto fail;
-		*fmt++ = '\0';
-		if (*marker == '\0' || *modname == '\0')
-			goto fail;
-
-		mod = find_module(modname);
-		if (!mod) {
-			mod = new_module(modname);
-			mod->skip = 1;
-		}
-		if (is_vmlinux(modname)) {
-			have_vmlinux = 1;
-			mod->skip = 0;
-		}
-
-		if (!mod->skip)
-			add_marker(mod, marker, fmt);
-	}
-	release_file(file, size);
-	return;
-fail:
-	fatal("parse error in markers list file\n");
-}
-
-static int compare_strings(const void *a, const void *b)
-{
-	return strcmp(*(const char **) a, *(const char **) b);
-}
-
-static void write_markers(const char *fname)
-{
-	struct buffer buf = { };
-	struct module *mod;
-	size_t i;
-
-	for (mod = modules; mod; mod = mod->next)
-		if ((!external_module || !mod->skip) && mod->markers != NULL) {
-			/*
-			 * Sort the strings so we can skip duplicates when
-			 * we write them out.
-			 */
-			qsort(mod->markers, mod->nmarkers,
-			      sizeof mod->markers[0], &compare_strings);
-			for (i = 0; i < mod->nmarkers; ++i) {
-				char *line = mod->markers[i];
-				buf_write(&buf, line, strlen(line));
-				while (i + 1 < mod->nmarkers &&
-				       !strcmp(mod->markers[i],
-					       mod->markers[i + 1]))
-					free(mod->markers[i++]);
-				free(mod->markers[i]);
-			}
-			free(mod->markers);
-			mod->markers = NULL;
-		}
-
-	write_if_changed(&buf, fname);
-}
-
 struct ext_sym_list {
 	struct ext_sym_list *next;
 	const char *file;
@@ -2077,8 +1927,6 @@ int main(int argc, char **argv)
 	struct buffer buf = { };
 	char *kernel_read = NULL, *module_read = NULL;
 	char *dump_write = NULL;
-	char *markers_read = NULL;
-	char *markers_write = NULL;
 	int opt;
 	int err;
 	struct ext_sym_list *extsym_iter;
@@ -2122,12 +1970,6 @@ int main(int argc, char **argv)
 		case 'w':
 			warn_unresolved = 1;
 			break;
-			case 'M':
-				markers_write = optarg;
-				break;
-			case 'K':
-				markers_read = optarg;
-				break;
 		default:
 			exit(1);
 		}
@@ -2182,11 +2024,5 @@ int main(int argc, char **argv)
 		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
 		     sec_mismatch_count);
 
-	if (markers_read)
-		read_markers(markers_read);
-
-	if (markers_write)
-		write_markers(markers_write);
-
 	return err;
 }
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 09f58e3..be987a4 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -112,8 +112,6 @@ struct module {
 	int has_init;
 	int has_cleanup;
 	struct buffer dev_table_buf;
-	char **markers;
-	size_t nmarkers;
 	char	     srcversion[25];
 };
 
@@ -128,7 +126,6 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
-	Elf_Section  markers_strings_sec;
 	const char   *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
-- 
1.5.6

