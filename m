Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZKISkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZKISkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751808AbZKISkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:40:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42701 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZKISkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:40:46 -0500
Message-ID: <4AF86211.3070103@zytor.com>
Date: Mon, 09 Nov 2009 10:40:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org, hare@suse.de, akpm@linux-foundation.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add back _end symbol that is missing	from
 Symbol.map
References: <200911041519.nA4FJWEW030164@imap1.linux-foundation.org> <tip-d1e4d37b79e944f6351ae38eb1ca7c9f7b506e76@git.kernel.org> <20091108113805.GA11847@merkur.ravnborg.org> <20091108114829.GQ11372@elte.hu> <20091108123825.GA11904@merkur.ravnborg.org>
In-Reply-To: <20091108123825.GA11904@merkur.ravnborg.org>
Content-Type: multipart/mixed;
 boundary="------------050904010904070705020906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050904010904070705020906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/08/2009 04:38 AM, Sam Ravnborg wrote:
> I think ld discards zero size sections. No need to keep them around
> if they are empty.
> 
> Following patch should fix it up in a better way.
> I reused most of Hannes changelog.

Part of me wonders if this isn't better handled by just making relocs.c
deal with _end as a special case (and of course making it possible to
add others.)

Here is a distinctively non-minimal patch -- I used a modified version
of relocs.c for the Syslinux project, and this is basically a backport
of the changes I did for that.  It uses a regex to match either
known-absolute or known-relative symbols; the remaining changes are
mostly just dealing with particularly stupid code like using printf() to
do the work of fwrite(), and using select() where appropriate.

Sam, Ingo: I'd appreciate your opinions before checking anything in on this.

	-hpa

--------------050904010904070705020906
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

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
index 3c68fe2..b2f811d 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -291,9 +291,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
-	.end : AT(ADDR(.end) - LOAD_OFFSET) {
-		_end = .;
-	}
+	_end = .;
 
         STABS_DEBUG
         DWARF_DEBUG

--------------050904010904070705020906--
