Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZKWWrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZKWWrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZKWWrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:47:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:4269 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZKWWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:47:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=rD6qYpissBj+E7x49JyzSBDYvM9se9+MTSbuofmMQ/38i818NS4eVvA95COmz5i/wn
         pTizSf+p+twRiTgSDezmI0TfmJltM7EFNDn1Wb/064RMX0E2acnaliLpDQjjmFxSb/QF
         JfGde7Pmne+AckEFcWYhQWJSwQocUFh6BSeBo=
Message-ID: <4B0B10FA.7030402@tuffmail.co.uk>
Date: Mon, 23 Nov 2009 22:47:22 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Alex Chiang <achiang@hp.com>, Tony Luck <tony.luck@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] modpost: fix modules on ia64 - use @fptr() on exported function
 symbols
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On function descriptor architectures (powerpc and ia64), we need to export
the address of the function descriptor and not the actual function.
The C compiler naturally does this for us.  However we now export vmlinux
symbols using the assembler, in order to sort the exports.

This is not a problem on powerpc.  On powerpc, the function descriptor
is simply "printk" (the action function entry point is ".printk").
But ia64 assembly needs special handling.  The function descriptor for
printk(), for example, is "@fptr(printk)".

I have tested that modpost now generates the desired assembly code when
run against an IA64 module.  I have not tested with an actual IA64
vmlinux, assembler, compiler or processor.  I assume that the IA64
assembler defines __ia64__, just as the i386 assembler defines __i386__.

Reported-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 include/linux/mod_export.h |   17 +++++++++++++++--
 scripts/mod/modpost.c      |   22 +++++++++++++++++++++-
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/include/linux/mod_export.h b/include/linux/mod_export.h
index 394795e..3f4e38a 100644
--- a/include/linux/mod_export.h
+++ b/include/linux/mod_export.h
@@ -111,6 +111,12 @@ struct kernel_symbol {
 #define SYM(sym) PASTE(SYMBOL_PREFIX, sym)
 #endif
 
+#ifdef __ia64__
+#define FSYM(x) @fptr(SYM(x))
+#else
+#define FSYM(x) SYM(x)
+#endif
+
 
 #ifdef CONFIG_MODVERSIONS
 #define __CRC_SYMBOL(sym, crcsec)				\
@@ -125,7 +131,7 @@ struct kernel_symbol {
 #define __CRC_SYMBOL(sym, section)
 #endif
 
-#define __EXPORT_SYMBOL(sym, sec, strsec, crcsec)		\
+#define __EXPORT_SYMBOL_VALUE(sym, symvalue, sec, strsec, crcsec) \
 	.globl SYM(sym);					\
 								\
 	__CRC_SYMBOL(sym, crcsec)				\
@@ -138,10 +144,17 @@ struct kernel_symbol {
 	.pushsection sec, "a";					\
 	ALGN;							\
 	SYM(__ksymtab_##sym):					\
-	PTR SYM(sym);						\
+	PTR symvalue;						\
 	PTR SYM(__kstrtab_##sym);				\
 	.popsection;
 
+#define __EXPORT_DATA_SYMBOL(sym, sec, strsec, crcsec)		\
+	__EXPORT_SYMBOL_VALUE(sym, SYM(sym), sec, strsec, crcsec)
+
+#define __EXPORT_FUNCTION_SYMBOL(sym, sec, strsec, crcsec)	\
+	__EXPORT_SYMBOL_VALUE(sym, FSYM(sym), sec, strsec, crcsec)
+
+
 #endif /* __MODPOST_EXPORTS__ */
 
 #endif /* __GENKSYMS__ */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index b5a801d..31256d7 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -158,6 +158,7 @@ struct symbol {
 	unsigned int kernel:1;     /* 1 if symbol is from kernel
 				    *  (only for external modules) **/
 	unsigned int preloaded:1;  /* 1 if symbol from Module.symvers */
+	unsigned int function:1;   /* 1 if symbol refers to a function */
 	enum export  export;       /* Type of export */
 	char name[0];
 };
@@ -582,6 +583,17 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 	}
 }
 
+static void mark_function_symbols(Elf_Sym *sym, const char *symname)
+{
+	struct symbol *export_symbol;
+
+	export_symbol = find_symbol(symname);
+	if (!export_symbol)
+		return;
+
+	export_symbol->function = (ELF_ST_TYPE(sym->st_info) == STT_FUNC);
+}
+
 /**
  * Parse tag=value strings from .modinfo section
  **/
@@ -1619,6 +1631,13 @@ static void read_symbols(char *modname)
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
 	}
+
+	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
+		symname = info.strtab + sym->st_name;
+
+		mark_function_symbols(sym, symname);
+	}
+
 	if (!is_vmlinux(modname) ||
 	     (is_vmlinux(modname) && vmlinux_section_warnings))
 		check_sec_ref(mod, modname, &info);
@@ -2027,10 +2046,11 @@ static void write_exports(const char *fname)
 	for (i = 0; i < n; i++) {
 		sym = symbols[i];
 
-		buf_printf(&buf, "__EXPORT_SYMBOL(%s,"
+		buf_printf(&buf, "__EXPORT_%s_SYMBOL(%s,"
 					" __ksymtab%s_sorted,"
 					" __ksymtab_strings_sorted,"
 					" __kcrctab%s_sorted)\n",
+					sym->function ? "FUNCTION" : "DATA",
 					sym->name,
 					section_names[sym->export],
 					section_names[sym->export]);
-- 
1.6.3.3



