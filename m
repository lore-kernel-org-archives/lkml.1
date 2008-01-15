Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYAOPST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYAOPST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbYAOPSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:18:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34797 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbYAOPSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:18:11 -0500
Date: Tue, 15 Jan 2008 16:17:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       rjw@sisk.pl, pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [15/16] Force __cpuinit on for CONFIG_PM without
	HOTPLUG_CPU
Message-ID: <20080115151742.GB10722@elte.hu>
References: <200801101242.53504.ak@suse.de> <20080110124702.GF28740@does.not.exist> <p73fxx5omck.fsf@bingen.suse.de> <20080110150911.GG28740@does.not.exist> <20080114135240.GA15357@elte.hu> <20080114140910.GA8507@uranus.ravnborg.org> <20080114145854.GA31695@elte.hu> <20080114150553.GA3524@elte.hu> <20080114152440.GA9174@elte.hu> <20080114201214.GC9257@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114201214.GC9257@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > find below the current set of warnings on -git. There are 62.
> 
> The correct figure is 112.
> 
> You need to do a:
> make KCFLAGS=-fno-unit-at-a-time
> build to see them all.

btw., please add a .config option to trigger the -fno-unit-at-a-time 
flags. Something like CONFIG_SECTION_ERRORS=y - plus perhaps combine it 
with the patch below that turns such section bugs into detectable build 
errors. A distro does not want to build a kernel that could potentially 
corrupt kernel memory. (it's a security risk as well.) If we make the 
err=1 dependent on CONFIG_SECTION_ERRORS then we'll have this 
configurable.

	Ingo

---------------->
Subject: x86: link mismatch error
From: Ingo Molnar <mingo@elte.hu>

turn the build warning into a build error.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 scripts/mod/modpost.c |   63 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

Index: linux/scripts/mod/modpost.c
===================================================================
--- linux.orig/scripts/mod/modpost.c
+++ linux/scripts/mod/modpost.c
@@ -863,8 +863,8 @@ static void find_symbols_between(struct 
  * Try to find symbols near it so user can find it.
  * Check whitelist before warning - it may be a false positive.
  **/
-static void warn_sec_mismatch(const char *modname, const char *fromsec,
-			      struct elf_info *elf, Elf_Sym *sym, Elf_Rela r)
+static int error_sec_mismatch(const char *modname, const char *fromsec,
+			     struct elf_info *elf, Elf_Sym *sym, Elf_Rela r)
 {
 	const char *refsymname = "";
 	Elf_Sym *before, *after;
@@ -874,6 +874,7 @@ static void warn_sec_mismatch(const char
 	const char *secstrings = (void *)hdr +
 				 sechdrs[hdr->e_shstrndx].sh_offset;
 	const char *secname = secstrings + sechdrs[sym->st_shndx].sh_name;
+	int err = 0;
 
 	find_symbols_between(elf, r.r_offset, fromsec, &before, &after);
 
@@ -885,32 +886,38 @@ static void warn_sec_mismatch(const char
 	if (secref_whitelist(modname, secname, fromsec,
 			     before ? elf->strtab + before->st_name : "",
 	                     refsymname))
-		return;
+		goto out;
 
 	if (before && after) {
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		merror("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(between '%s' and '%s')\n",
 		     modname, fromsec, (unsigned long long)r.r_offset,
 		     secname, refsymname,
 		     elf->strtab + before->st_name,
 		     elf->strtab + after->st_name);
+		err = 1;
 	} else if (before) {
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		merror("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "(after '%s')\n",
 		     modname, fromsec, (unsigned long long)r.r_offset,
 		     secname, refsymname,
 		     elf->strtab + before->st_name);
+		err = 1;
 	} else if (after) {
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
+		merror("%s(%s+0x%llx): Section mismatch: reference to %s:%s "
 		     "before '%s' (at offset -0x%llx)\n",
 		     modname, fromsec, (unsigned long long)r.r_offset,
 		     secname, refsymname,
 		     elf->strtab + after->st_name);
+		err = 1;
 	} else {
-		warn("%s(%s+0x%llx): Section mismatch: reference to %s:%s\n",
+		merror("%s(%s+0x%llx): Section mismatch: reference to %s:%s\n",
 		     modname, fromsec, (unsigned long long)r.r_offset,
 		     secname, refsymname);
+		err = 1;
 	}
+out:
+	return err;
 }
 
 static unsigned int *reloc_location(struct elf_info *elf,
@@ -997,10 +1004,10 @@ static int addend_mips_rel(struct elf_in
  * to find all references to a section that reference a section that will
  * be discarded and warns about it.
  **/
-static void check_sec_ref(struct module *mod, const char *modname,
-			  struct elf_info *elf,
-			  int section(const char*),
-			  int section_ref_ok(const char *))
+static int check_sec_ref(struct module *mod, const char *modname,
+			 struct elf_info *elf,
+			 int section(const char*),
+			 int section_ref_ok(const char *))
 {
 	int i;
 	Elf_Sym  *sym;
@@ -1049,9 +1056,11 @@ static void check_sec_ref(struct module 
 
 				secname = secstrings +
 					sechdrs[sym->st_shndx].sh_name;
-				if (section(secname))
-					warn_sec_mismatch(modname, name,
-							  elf, sym, r);
+				if (section(secname)) {
+					if (error_sec_mismatch(modname, name,
+							  elf, sym, r))
+						return 1;
+				}
 			}
 		} else if (sechdrs[i].sh_type == SHT_REL) {
 			Elf_Rel *rel;
@@ -1100,12 +1109,15 @@ static void check_sec_ref(struct module 
 
 				secname = secstrings +
 					sechdrs[sym->st_shndx].sh_name;
-				if (section(secname))
-					warn_sec_mismatch(modname, name,
-							  elf, sym, r);
+				if (section(secname)) {
+					if (error_sec_mismatch(modname, name,
+							  elf, sym, r))
+						return 1;
+				}
 			}
 		}
 	}
+	return 0;
 }
 
 /*
@@ -1249,7 +1261,7 @@ static int exit_section_ref_ok(const cha
 	return 0;
 }
 
-static void read_symbols(char *modname)
+static int read_symbols(char *modname)
 {
 	const char *symname;
 	char *version;
@@ -1257,9 +1269,10 @@ static void read_symbols(char *modname)
 	struct module *mod;
 	struct elf_info info = { };
 	Elf_Sym *sym;
+	int err = 0;
 
 	if (!parse_elf(&info, modname))
-		return;
+		goto out;
 
 	mod = new_module(modname);
 
@@ -1289,8 +1302,8 @@ static void read_symbols(char *modname)
 		handle_moddevtable(mod, &info, sym, symname);
 	}
 	if (is_vmlinux(modname) && vmlinux_section_warnings) {
-		check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
-		check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
+		err |= check_sec_ref(mod, modname, &info, init_section, init_section_ref_ok);
+		err |= check_sec_ref(mod, modname, &info, exit_section, exit_section_ref_ok);
 	}
 
 	version = get_modinfo(info.modinfo, info.modinfo_len, "version");
@@ -1309,6 +1322,8 @@ static void read_symbols(char *modname)
 	 * important anyhow */
 	if (modversions)
 		mod->unres = alloc_symbol("struct_module", 0, mod->unres);
+out:
+	return err;
 }
 
 #define SZ 500
@@ -1693,8 +1708,10 @@ int main(int argc, char **argv)
 	if (module_read)
 		read_dump(module_read, 0);
 
+	err = 0;
+
 	while (optind < argc) {
-		read_symbols(argv[optind++]);
+		err |= read_symbols(argv[optind++]);
 	}
 
 	for (mod = modules; mod; mod = mod->next) {
@@ -1703,8 +1720,6 @@ int main(int argc, char **argv)
 		check_exports(mod);
 	}
 
-	err = 0;
-
 	for (mod = modules; mod; mod = mod->next) {
 		if (mod->skip)
 			continue;
