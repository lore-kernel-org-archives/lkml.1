Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbZFJWS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbZFJWS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbZFJWSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:18:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51413 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755739AbZFJWSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:18:21 -0400
Date: Thu, 11 Jun 2009 00:18:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/printk for v2.6.31
Message-ID: <20090610221819.GA31173@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest printk-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git printk-for-linus

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (1):
      vsprintf: introduce %pf format specifier

Zhaolei (1):
      printk: add support of hh length modifier for printk


 lib/vsprintf.c |   56 +++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 7536ace..756ccaf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -408,6 +408,8 @@ enum format_type {
 	FORMAT_TYPE_LONG_LONG,
 	FORMAT_TYPE_ULONG,
 	FORMAT_TYPE_LONG,
+	FORMAT_TYPE_UBYTE,
+	FORMAT_TYPE_BYTE,
 	FORMAT_TYPE_USHORT,
 	FORMAT_TYPE_SHORT,
 	FORMAT_TYPE_UINT,
@@ -573,12 +575,15 @@ static char *string(char *buf, char *end, char *s, struct printf_spec spec)
 }
 
 static char *symbol_string(char *buf, char *end, void *ptr,
-				struct printf_spec spec)
+				struct printf_spec spec, char ext)
 {
 	unsigned long value = (unsigned long) ptr;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
-	sprint_symbol(sym, value);
+	if (ext != 'f')
+		sprint_symbol(sym, value);
+	else
+		kallsyms_lookup(value, NULL, NULL, NULL, sym);
 	return string(buf, end, sym, spec);
 #else
 	spec.field_width = 2*sizeof(void *);
@@ -690,7 +695,8 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr,
  *
  * Right now we handle:
  *
- * - 'F' For symbolic function descriptor pointers
+ * - 'F' For symbolic function descriptor pointers with offset
+ * - 'f' For simple symbolic function names without offset
  * - 'S' For symbolic direct pointers
  * - 'R' For a struct resource pointer, it prints the range of
  *       addresses (not the name nor the flags)
@@ -713,10 +719,11 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 
 	switch (*fmt) {
 	case 'F':
+	case 'f':
 		ptr = dereference_function_descriptor(ptr);
 		/* Fallthrough */
 	case 'S':
-		return symbol_string(buf, end, ptr, spec);
+		return symbol_string(buf, end, ptr, spec, *fmt);
 	case 'R':
 		return resource_string(buf, end, ptr, spec);
 	case 'm':
@@ -853,11 +860,15 @@ qualifier:
 	spec->qualifier = -1;
 	if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L' ||
 	    *fmt == 'Z' || *fmt == 'z' || *fmt == 't') {
-		spec->qualifier = *fmt;
-		++fmt;
-		if (spec->qualifier == 'l' && *fmt == 'l') {
-			spec->qualifier = 'L';
-			++fmt;
+		spec->qualifier = *fmt++;
+		if (unlikely(spec->qualifier == *fmt)) {
+			if (spec->qualifier == 'l') {
+				spec->qualifier = 'L';
+				++fmt;
+			} else if (spec->qualifier == 'h') {
+				spec->qualifier = 'H';
+				++fmt;
+			}
 		}
 	}
 
@@ -919,6 +930,11 @@ qualifier:
 		spec->type = FORMAT_TYPE_SIZE_T;
 	} else if (spec->qualifier == 't') {
 		spec->type = FORMAT_TYPE_PTRDIFF;
+	} else if (spec->qualifier == 'H') {
+		if (spec->flags & SIGN)
+			spec->type = FORMAT_TYPE_BYTE;
+		else
+			spec->type = FORMAT_TYPE_UBYTE;
 	} else if (spec->qualifier == 'h') {
 		if (spec->flags & SIGN)
 			spec->type = FORMAT_TYPE_SHORT;
@@ -943,7 +959,8 @@ qualifier:
  *
  * This function follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  *
  * The return value is the number of characters which would
@@ -1087,6 +1104,12 @@ int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 			case FORMAT_TYPE_PTRDIFF:
 				num = va_arg(args, ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+				num = (unsigned char) va_arg(args, int);
+				break;
+			case FORMAT_TYPE_BYTE:
+				num = (signed char) va_arg(args, int);
+				break;
 			case FORMAT_TYPE_USHORT:
 				num = (unsigned short) va_arg(args, int);
 				break;
@@ -1363,6 +1386,10 @@ do {									\
 			case FORMAT_TYPE_PTRDIFF:
 				save_arg(ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+			case FORMAT_TYPE_BYTE:
+				save_arg(char);
+				break;
 			case FORMAT_TYPE_USHORT:
 			case FORMAT_TYPE_SHORT:
 				save_arg(short);
@@ -1391,7 +1418,8 @@ EXPORT_SYMBOL_GPL(vbin_printf);
  *
  * The format follows C99 vsnprintf, but has some extensions:
  * %pS output the name of a text symbol
- * %pF output the name of a function pointer
+ * %pF output the name of a function pointer with its offset
+ * %pf output the name of a function pointer without its offset
  * %pR output the address range in a struct resource
  * %n is ignored
  *
@@ -1538,6 +1566,12 @@ int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
 			case FORMAT_TYPE_PTRDIFF:
 				num = get_arg(ptrdiff_t);
 				break;
+			case FORMAT_TYPE_UBYTE:
+				num = get_arg(unsigned char);
+				break;
+			case FORMAT_TYPE_BYTE:
+				num = get_arg(signed char);
+				break;
 			case FORMAT_TYPE_USHORT:
 				num = get_arg(unsigned short);
 				break;
