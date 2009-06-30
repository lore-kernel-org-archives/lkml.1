Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZF3MTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZF3MTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 08:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbZF3MS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 08:18:56 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:47139 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZF3MSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 08:18:55 -0400
Message-Id: <4A4A1ED10200007800008379@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 13:18:57 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <sam@ravnborg.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] reduce kallsyms table size on 64-bit arch-s
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures (the patch carries it out for x86-64) can reduce the
kallsyms pointer table's size by half through the use of relative 32-
bit pointers. Since the kallsyms tables get created as assembly files
anyway, the adjustment is strait forward and only requires a little bit
of abstraction at the consuming side.

Further, independent of architecture, kallsyms_num_syms and
kallsyms_markers[] can use 32-bit types.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig   |    1 +
 init/Kconfig       |    3 +++
 kernel/kallsyms.c  |   31 +++++++++++++++++++++----------
 scripts/kallsyms.c |   19 ++++++++++++++++---
 4 files changed, 41 insertions(+), 13 deletions(-)

--- linux-2.6.31-rc1/arch/x86/Kconfig	2009-06-26 17:49:41.000000000 +0200
+++ 2.6.31-rc1-kallsyms-reduce-size/arch/x86/Kconfig	2009-04-29 15:59:50.000000000 +0200
@@ -14,6 +14,7 @@ config X86_32
 
 config X86_64
 	def_bool 64BIT
+	select KALLSYMS_RELATIVE_POINTERS if KALLSYMS
 
 ### Arch settings
 config X86
--- linux-2.6.31-rc1/init/Kconfig	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-kallsyms-reduce-size/init/Kconfig	2009-04-27 12:04:03.000000000 +0200
@@ -802,6 +802,9 @@ config KALLSYMS_ALL
 
 	   Say N.
 
+config KALLSYMS_RELATIVE_POINTERS
+	bool
+
 config KALLSYMS_EXTRA_PASS
 	bool "Do an extra kallsyms pass"
 	depends on KALLSYMS
--- linux-2.6.31-rc1/kernel/kallsyms.c	2009-06-26 17:50:00.000000000 +0200
+++ 2.6.31-rc1-kallsyms-reduce-size/kernel/kallsyms.c	2009-06-30 11:11:22.000000000 +0200
@@ -34,20 +34,27 @@
  * These will be re-linked against their real values
  * during the second link stage.
  */
+#ifdef CONFIG_KALLSYMS_RELATIVE_POINTERS
+extern const signed int kallsyms_offsets[] __attribute__((weak));
+#define kallsyms_address(idx) ((unsigned long)_text + kallsyms_offsets[idx])
+#else
 extern const unsigned long kallsyms_addresses[] __attribute__((weak));
+#define kallsyms_address(idx) kallsyms_addresses[idx]
+#endif
+
 extern const u8 kallsyms_names[] __attribute__((weak));
 
 /*
  * Tell the compiler that the count isn't in the small data section if the arch
  * has one (eg: FRV).
  */
-extern const unsigned long kallsyms_num_syms
+extern const unsigned int kallsyms_num_syms
 __attribute__((weak, section(".rodata")));
 
 extern const u8 kallsyms_token_table[] __attribute__((weak));
 extern const u16 kallsyms_token_index[] __attribute__((weak));
 
-extern const unsigned long kallsyms_markers[] __attribute__((weak));
+extern const unsigned int kallsyms_markers[] __attribute__((weak));
 
 static inline int is_kernel_inittext(unsigned long addr)
 {
@@ -176,7 +183,7 @@ unsigned long kallsyms_lookup_name(const
 		off = kallsyms_expand_symbol(off, namebuf);
 
 		if (strcmp(namebuf, name) == 0)
-			return kallsyms_addresses[i];
+			return kallsyms_address(i);
 	}
 	return module_kallsyms_lookup_name(name);
 }
@@ -192,7 +199,7 @@ int kallsyms_on_each_symbol(int (*fn)(vo
 
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf);
-		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
+		ret = fn(data, namebuf, NULL, kallsyms_address(i));
 		if (ret != 0)
 			return ret;
 	}
@@ -208,7 +215,11 @@ static unsigned long get_symbol_pos(unsi
 	unsigned long i, low, high, mid;
 
 	/* This kernel should never had been booted. */
+#ifdef CONFIG_KALLSYMS_RELATIVE_POINTERS
+	BUG_ON(!kallsyms_offsets);
+#else
 	BUG_ON(!kallsyms_addresses);
+#endif
 
 	/* Do a binary search on the sorted kallsyms_addresses array. */
 	low = 0;
@@ -216,7 +227,7 @@ static unsigned long get_symbol_pos(unsi
 
 	while (high - low > 1) {
 		mid = low + (high - low) / 2;
-		if (kallsyms_addresses[mid] <= addr)
+		if (kallsyms_address(mid) <= addr)
 			low = mid;
 		else
 			high = mid;
@@ -226,15 +237,15 @@ static unsigned long get_symbol_pos(unsi
 	 * Search for the first aliased symbol. Aliased
 	 * symbols are symbols with the same address.
 	 */
-	while (low && kallsyms_addresses[low-1] == kallsyms_addresses[low])
+	while (low && kallsyms_address(low-1) == kallsyms_address(low))
 		--low;
 
-	symbol_start = kallsyms_addresses[low];
+	symbol_start = kallsyms_address(low);
 
 	/* Search for next non-aliased symbol. */
 	for (i = low + 1; i < kallsyms_num_syms; i++) {
-		if (kallsyms_addresses[i] > symbol_start) {
-			symbol_end = kallsyms_addresses[i];
+		if (kallsyms_address(i) > symbol_start) {
+			symbol_end = kallsyms_address(i);
 			break;
 		}
 	}
@@ -401,7 +412,7 @@ static unsigned long get_ksymbol_core(st
 	unsigned off = iter->nameoff;
 
 	iter->module_name[0] = '\0';
-	iter->value = kallsyms_addresses[iter->pos];
+	iter->value = kallsyms_address(iter->pos);
 
 	iter->type = kallsyms_get_symbol_type(off);
 
--- linux-2.6.31-rc1/scripts/kallsyms.c	2009-06-26 17:50:01.000000000 +0200
+++ 2.6.31-rc1-kallsyms-reduce-size/scripts/kallsyms.c	2009-04-27 12:04:03.000000000 +0200
@@ -295,7 +295,8 @@ static void write_src(void)
 	char buf[KSYM_NAME_LEN];
 
 	printf("#include <asm/types.h>\n");
-	printf("#if BITS_PER_LONG == 64\n");
+	printf("#if BITS_PER_LONG == 64"
+	       " && !defined(CONFIG_KALLSYMS_RELATIVE_POINTERS)\n");
 	printf("#define PTR .quad\n");
 	printf("#define ALGN .align 8\n");
 	printf("#else\n");
@@ -312,7 +313,12 @@ static void write_src(void)
 	 * .o files.  This prevents .tmp_kallsyms.o or any other
 	 * object from referencing them.
 	 */
+	printf("#ifdef CONFIG_KALLSYMS_RELATIVE_POINTERS\n");
+	output_label("kallsyms_offsets");
+	printf("#define _text\n");
+	printf("#else\n");
 	output_label("kallsyms_addresses");
+	printf("#endif\n");
 	for (i = 0; i < table_cnt; i++) {
 		if (toupper(table[i].sym[0]) != 'A') {
 			if (_text <= table[i].addr)
@@ -322,13 +328,20 @@ static void write_src(void)
 				printf("\tPTR\t_text - %#llx\n",
 					_text - table[i].addr);
 		} else {
+			printf("#if BITS_PER_LONG > 32"
+			       " && defined(CONFIG_KALLSYMS_RELATIVE_POINTERS)\n");
+			printf("\t.err /* Absolute symbols not allowed on "
+			       "this architecture, found '%s' */\n",
+			       table[i].sym + 1);
+			printf("#else\n");
 			printf("\tPTR\t%#llx\n", table[i].addr);
+			printf("#endif\n");
 		}
 	}
 	printf("\n");
 
 	output_label("kallsyms_num_syms");
-	printf("\tPTR\t%d\n", table_cnt);
+	printf("\t.long\t%u\n", table_cnt);
 	printf("\n");
 
 	/* table of offset markers, that give the offset in the compressed stream
@@ -357,7 +370,7 @@ static void write_src(void)
 
 	output_label("kallsyms_markers");
 	for (i = 0; i < ((table_cnt + 255) >> 8); i++)
-		printf("\tPTR\t%d\n", markers[i]);
+		printf("\t.long\t%u\n", markers[i]);
 	printf("\n");
 
 	free(markers);


