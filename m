Return-Path: <linux-kernel-owner+w=401wt.eu-S933156AbZLNW2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156AbZLNW2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932615AbZLNW2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:28:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:45536 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181AbZLNW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:28:08 -0500
Date: Mon, 14 Dec 2009 22:27:38 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mmarek@suse.cz, tglx@linutronix.de, sedat.dilek@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mmarek@suse.cz, sedat.dilek@gmail.com
In-Reply-To: <4AF86211.3070103@zytor.com>
References: <4AF86211.3070103@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Regex support and known-movable symbols for relocs, fix _end
Message-ID: <tip-873b5271f878a11729fb4602c6ce967d0ff81119@git.kernel.org>
Git-Commit-ID: 873b5271f878a11729fb4602c6ce967d0ff81119
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  873b5271f878a11729fb4602c6ce967d0ff81119
Gitweb:     http://git.kernel.org/tip/873b5271f878a11729fb4602c6ce967d0ff81119
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Mon, 14 Dec 2009 13:55:20 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 14 Dec 2009 13:55:20 -0800

x86: Regex support and known-movable symbols for relocs, fix _end

This adds a new category of symbols to the relocs program: symbols
which are known to be relative, even though the linker emits them as
absolute; this is the case for symbols that live in the linker script,
which currently applies to _end.

Unfortunately the previous workaround of putting _end in its own empty
section was defeated by newer binutils, which remove empty sections
completely.

This patch also changes the symbol matching to use regular expressions
instead of hardcoded C for specific patterns.

This is a decidedly non-minimal patch: a modified version of the
relocs program is used as part of the Syslinux build, and this 	is
basically a backport to Linux of some of those changes; they have
thus been well tested.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4AF86211.3070103@zytor.com>
Acked-by: Michal Marek <mmarek@suse.cz>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 arch/x86/boot/compressed/relocs.c |   87 +++++++++++++++++++++++++------------
 arch/x86/kernel/vmlinux.lds.S     |    4 +-
 2 files changed, 60 insertions(+), 31 deletions(-)

diff --git a/arch/x86/boot/compressed/relocs.c b/arch/x86/boot/compressed/relocs.c
index bbeb0c3..89bbf4e 100644
--- a/arch/x86/boot/compressed/relocs.c
+++ b/arch/x86/boot/compressed/relocs.c
@@ -9,6 +9,9 @@
 #include <byteswap.h>
 #define USE_BSD
 #include <endian.h>
+#include <regex.h>
+
+static void die(char *fmt, ...);
 
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
 static Elf32_Ehdr ehdr;
@@ -30,25 +33,47 @@ static struct section *secs;
  * the address for which it has been compiled. Don't warn user about
  * absolute relocations present w.r.t these symbols.
  */
-static const char* safe_abs_relocs[] = {
-		"xen_irq_disable_direct_reloc",
-		"xen_save_fl_direct_reloc",
-};
+static const char abs_sym_regex[] =
+	"^(xen_irq_disable_direct_reloc$|"
+	"xen_save_fl_direct_reloc$|"
+	"VDSO|"
+	"__crc_)";
+static regex_t abs_sym_regex_c;
+static int is_abs_reloc(const char *sym_name)
+{
+	return !regexec(&abs_sym_regex_c, sym_name, 0, NULL, 0);
+}
 
-static int is_safe_abs_reloc(const char* sym_name)
+/*
+ * These symbols are known to be relative, even if the linker marks them
+ * as absolute (typically defined outside any section in the linker script.)
+ */
+static const char rel_sym_regex[] =
+	"^_end$";
+static regex_t rel_sym_regex_c;
+static int is_rel_reloc(const char *sym_name)
 {
-	int i;
+	return !regexec(&rel_sym_regex_c, sym_name, 0, NULL, 0);
+}
 
-	for (i = 0; i < ARRAY_SIZE(safe_abs_relocs); i++) {
-		if (!strcmp(sym_name, safe_abs_relocs[i]))
-			/* Match found */
-			return 1;
-	}
-	if (strncmp(sym_name, "VDSO", 4) == 0)
-		return 1;
-	if (strncmp(sym_name, "__crc_", 6) == 0)
-		return 1;
-	return 0;
+static void regex_init(void)
+{
+        char errbuf[128];
+        int err;
+	
+        err = regcomp(&abs_sym_regex_c, abs_sym_regex,
+                      REG_EXTENDED|REG_NOSUB);
+        if (err) {
+                regerror(err, &abs_sym_regex_c, errbuf, sizeof errbuf);
+                die("%s", errbuf);
+        }
+
+        err = regcomp(&rel_sym_regex_c, rel_sym_regex,
+                      REG_EXTENDED|REG_NOSUB);
+        if (err) {
+                regerror(err, &rel_sym_regex_c, errbuf, sizeof errbuf);
+                die("%s", errbuf);
+        }
 }
 
 static void die(char *fmt, ...)
@@ -131,7 +156,7 @@ static const char *rel_type(unsigned type)
 #undef REL_TYPE
 	};
 	const char *name = "unknown type rel type name";
-	if (type < ARRAY_SIZE(type_name)) {
+	if (type < ARRAY_SIZE(type_name) && type_name[type]) {
 		name = type_name[type];
 	}
 	return name;
@@ -448,7 +473,7 @@ static void print_absolute_relocs(void)
 			 * Before warning check if this absolute symbol
 			 * relocation is harmless.
 			 */
-			if (is_safe_abs_reloc(name))
+			if (is_abs_reloc(name) || is_rel_reloc(name))
 				continue;
 
 			if (!printed) {
@@ -501,21 +526,26 @@ static void walk_relocs(void (*visit)(Elf32_Rel *rel, Elf32_Sym *sym))
 			sym = &sh_symtab[ELF32_R_SYM(rel->r_info)];
 			r_type = ELF32_R_TYPE(rel->r_info);
 			/* Don't visit relocations to absolute symbols */
-			if (sym->st_shndx == SHN_ABS) {
+			if (sym->st_shndx == SHN_ABS &&
+			    !is_rel_reloc(sym_name(sym_strtab, sym))) {
 				continue;
 			}
-			if (r_type == R_386_NONE || r_type == R_386_PC32) {
+			switch (r_type) {
+			case R_386_NONE:
+			case R_386_PC32:
 				/*
 				 * NONE can be ignored and and PC relative
 				 * relocations don't need to be adjusted.
 				 */
-			}
-			else if (r_type == R_386_32) {
+				break;
+			case R_386_32:
 				/* Visit relocations that need to be adjusted */
 				visit(rel, sym);
-			}
-			else {
-				die("Unsupported relocation type: %d\n", r_type);
+				break;
+			default:
+				die("Unsupported relocation type: %s (%d)\n",
+				    rel_type(r_type), r_type);
+				break;
 			}
 		}
 	}
@@ -571,16 +601,15 @@ static void emit_relocs(int as_text)
 	}
 	else {
 		unsigned char buf[4];
-		buf[0] = buf[1] = buf[2] = buf[3] = 0;
 		/* Print a stop */
-		printf("%c%c%c%c", buf[0], buf[1], buf[2], buf[3]);
+		fwrite("\0\0\0\0", 4, 1, stdout);
 		/* Now print each relocation */
 		for (i = 0; i < reloc_count; i++) {
 			buf[0] = (relocs[i] >>  0) & 0xff;
 			buf[1] = (relocs[i] >>  8) & 0xff;
 			buf[2] = (relocs[i] >> 16) & 0xff;
 			buf[3] = (relocs[i] >> 24) & 0xff;
-			printf("%c%c%c%c", buf[0], buf[1], buf[2], buf[3]);
+			fwrite(buf, 4, 1, stdout);
 		}
 	}
 }
@@ -598,6 +627,8 @@ int main(int argc, char **argv)
 	FILE *fp;
 	int i;
 
+	regex_init();
+
 	show_absolute_syms = 0;
 	show_absolute_relocs = 0;
 	as_text = 0;
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index f3f2104..f92a0da 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -319,9 +319,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
-	.end : AT(ADDR(.end) - LOAD_OFFSET) {
-		_end = .;
-	}
+	_end = .;
 
         STABS_DEBUG
         DWARF_DEBUG
