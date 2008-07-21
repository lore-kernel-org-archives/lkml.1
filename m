Return-Path: <linux-kernel-owner+w=401wt.eu-S932219AbYGUDFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbYGUDFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932074AbYGUDD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:03:59 -0400
Received: from mail.suse.de ([195.135.220.2]:33932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908AbYGUDD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:03:56 -0400
Message-Id: <20080721025913.231929061@suse.de>
User-Agent: quilt/0.46_cvs20080326-18
Date: Mon, 21 Jul 2008 04:28:27 +0200
From: Andreas Gruenbacher <agruen@suse.de>
To: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: [genksyms patch 4/4] Allow to ignore symbol checksum changes
References: <20080721022823.896799736@suse.de>
Content-Disposition: inline; filename=patches.suse/genksyms-override.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an "override" keyword for use in *.symvers / *.symref files.  When a
symbol is overridden, the symbol's old definition will be used for computing
checksums instead of the new one, preserving the previous checksum.  (Genksyms
will still warn about the change.)

This is meant to allow distributions to hide minor actual as well as fake ABI
changes. (For example, when extra type information becomes available because
additional headers are included, this may change checksums even though none of
the types used have actully changed.)

This approach also allows to get rid of "#ifdef __GENKSYMS__" hacks in the code,
which are currently used in some vendor kernels to work around checksum changes.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 scripts/genksyms/genksyms.c |   34 ++++++++++++++++++++++++++++++----
 scripts/genksyms/genksyms.h |    1 +
 2 files changed, 31 insertions(+), 4 deletions(-)

Index: b/scripts/genksyms/genksyms.c
===================================================================
--- a/scripts/genksyms/genksyms.c
+++ b/scripts/genksyms/genksyms.c
@@ -191,11 +191,26 @@ struct symbol *__add_symbol(const char *
 				/* fall through */ ;
 			else if (sym->type == type &&
 				 equal_list(sym->defn, defn)) {
+				if (!sym->is_declared && sym->is_override) {
+					print_location();
+					print_type_name(type, name);
+					fprintf(stderr, " modversion is "
+						"unchanged\n");
+				}
 				sym->is_declared = 1;
 				return sym;
 			} else if (!sym->is_declared) {
-				status = is_unknown_symbol(sym) ?
-					STATUS_DEFINED : STATUS_MODIFIED;
+				if (sym->is_override && flag_preserve) {
+					print_location();
+					fprintf(stderr, "ignoring ");
+					print_type_name(type, name);
+					fprintf(stderr, " modversion change\n");
+					sym->is_declared = 1;
+					return sym;
+				} else {
+					status = is_unknown_symbol(sym) ?
+						STATUS_DEFINED : STATUS_MODIFIED;
+				}
 			} else {
 				error_with_pos("redefinition of %s", name);
 				return sym;
@@ -229,6 +244,7 @@ struct symbol *__add_symbol(const char *
 
 	sym->is_declared = !is_reference;
 	sym->status = status;
+	sym->is_override = 0;
 
 	if (flag_debug) {
 		fprintf(debugfile, "Defn for %s %s == <",
@@ -348,9 +364,16 @@ static void read_reference(FILE *f)
 	while (!feof(f)) {
 		struct string_list *defn = NULL;
 		struct string_list *sym, *def;
-		int is_extern = 0;
+		int is_extern = 0, is_override = 0;
+		struct symbol *subsym;
 
 		sym = read_node(f);
+		if (sym && sym->tag == SYM_NORMAL &&
+		    !strcmp(sym->string, "override")) {
+			is_override = 1;
+			free_node(sym);
+			sym = read_node(f);
+		}
 		if (!sym)
 			continue;
 		def = read_node(f);
@@ -365,8 +388,9 @@ static void read_reference(FILE *f)
 			defn = def;
 			def = read_node(f);
 		}
-		add_reference_symbol(xstrdup(sym->string), sym->tag,
+		subsym = add_reference_symbol(xstrdup(sym->string), sym->tag,
 					      defn, is_extern);
+		subsym->is_override = is_override;
 		free_node(sym);
 	}
 }
@@ -744,6 +768,8 @@ int main(int argc, char **argv)
 		while (visited_symbols != (struct symbol *)-1L) {
 			struct symbol *sym = visited_symbols;
 
+			if (sym->is_override)
+				fputs("override ", dumpfile);
 			if (sym->type != SYM_NORMAL) {
 				putc(symbol_type_name[sym->type][0], dumpfile);
 				putc('#', dumpfile);
Index: b/scripts/genksyms/genksyms.h
===================================================================
--- a/scripts/genksyms/genksyms.h
+++ b/scripts/genksyms/genksyms.h
@@ -49,6 +49,7 @@ struct symbol {
 	int is_extern;
 	int is_declared;
 	enum symbol_status status;
+	int is_override;
 };
 
 typedef struct string_list **yystype;


