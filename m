Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbZK0CWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbZK0CWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 21:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZK0CWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 21:22:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60045 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZK0CWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 21:22:51 -0500
Date: Fri, 27 Nov 2009 13:22:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Wenji Huang <wenji.huang@oracle.com>, Michal Marek <mmarek@suse.cz>
Subject: linux-next: manual merge of the rr tree with the kbuild tree
Message-Id: <20091127132254.f9b1fc34.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
scripts/mod/modpost.c between commit
36021384778b40ffdd59ab34c275786507ef30a6 ("Kbuild: clear marker out of
modpost") from the kbuild tree and commit
215143067b9bfacdfd475c5b2fa5536ee30f50ec ("kbuild: sort the list of
symbols exported by the kernel (__ksymtab)") from the rr tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc scripts/mod/modpost.c
index 204e3f0,542bd05..0000000
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@@ -1916,6 -2019,149 +1959,59 @@@ static void write_dump(const char *fnam
  	write_if_changed(&buf, fname);
  }
  
+ static const char *section_names[] = {
+ 	[export_plain] 		= "",
+ 	[export_unused]		= "_unused",
+ 	[export_gpl]		= "_gpl",
+ 	[export_unused_gpl]	= "_unused_gpl",
+ 	[export_gpl_future]	= "_gpl_future",
+ };
+ 
+ static int compare_symbol_names(const void *a, const void *b)
+ {
+ 	struct symbol *const *syma = a;
+ 	struct symbol *const *symb = b;
+ 
+ 	return strcmp((*syma)->name, (*symb)->name);
+ }
+ 
+ /* sort exported symbols and output using arch-independent assembly macros */
+ static void write_exports(const char *fname)
+ {
+ 	struct buffer buf = { };
+ 	struct symbol *sym, **symbols;
+ 	int i, n;
+ 
+ 	symbols = NOFAIL(malloc(sizeof(struct symbol *) * symbolcount));
+ 	n = 0;
+ 
+ 	for (i = 0; i < SYMBOL_HASH_SIZE; i++) {
+ 		for (sym = symbolhash[i]; sym; sym = sym->next)
+ 			symbols[n++] = sym;
+ 	}
+ 
+ 	qsort(symbols, n, sizeof(struct symbol *), compare_symbol_names);
+ 
+ 	buf_printf(&buf, "#define __MODPOST_EXPORTS__\n");
+ 	buf_printf(&buf, "#include <linux/mod_export.h>\n");
+ 	buf_printf(&buf, "\n");
+ 
+ 	for (i = 0; i < n; i++) {
+ 		sym = symbols[i];
+ 
+ 		buf_printf(&buf, "__EXPORT_%s_SYMBOL(%s,"
+ 					" __ksymtab%s_sorted,"
+ 					" __ksymtab_strings_sorted,"
+ 					" __kcrctab%s_sorted)\n",
+ 					sym->function ? "FUNCTION" : "DATA",
+ 					sym->name,
+ 					section_names[sym->export],
+ 					section_names[sym->export]);
+ 	}
+ 
+ 	write_if_changed(&buf, fname);
+ }
+ 
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
@@@ -1927,6 -2173,9 +2023,7 @@@ int main(int argc, char **argv
  	struct buffer buf = { };
  	char *kernel_read = NULL, *module_read = NULL;
  	char *dump_write = NULL;
+ 	char *exports_write = NULL;
 -	char *markers_read = NULL;
 -	char *markers_write = NULL;
  	int opt;
  	int err;
  	struct ext_sym_list *extsym_iter;
@@@ -1970,6 -2219,15 +2067,9 @@@
  		case 'w':
  			warn_unresolved = 1;
  			break;
+ 		case 'x':
+ 			exports_write = optarg;
+ 			break;
 -			case 'M':
 -				markers_write = optarg;
 -				break;
 -			case 'K':
 -				markers_read = optarg;
 -				break;
  		default:
  			exit(1);
  		}
@@@ -2024,5 -2282,14 +2124,8 @@@
  		     "'make CONFIG_DEBUG_SECTION_MISMATCH=y'\n",
  		     sec_mismatch_count);
  
+ 	if (exports_write)
+ 		write_exports(exports_write);
+ 
 -	if (markers_read)
 -		read_markers(markers_read);
 -
 -	if (markers_write)
 -		write_markers(markers_write);
 -
  	return err;
  }
