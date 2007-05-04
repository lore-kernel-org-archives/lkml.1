Return-Path: <linux-kernel-owner+w=401wt.eu-S1161369AbXEDSVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161369AbXEDSVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161483AbXEDSVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:21:21 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:15335 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161434AbXEDSUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:20:52 -0400
Date: Fri, 4 May 2007 11:22:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>, hugh@veritas.com
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
Subject: Re: [PATCH v2] lib/hexdump update on feedback
Message-Id: <20070504112230.d24b00b6.randy.dunlap@oracle.com>
In-Reply-To: <84144f020705040239l757b35b5jf3ab4cb0d4b1a016@mail.gmail.com>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
	<20070502154557.b463c9c3.akpm@linux-foundation.org>
	<46391730.2080003@oracle.com>
	<20070502160635.31dd91e6.akpm@linux-foundation.org>
	<20070502161533.cbf38b4b.randy.dunlap@oracle.com>
	<20070503174924.d0cbafa3.randy.dunlap@oracle.com>
	<84144f020705040239l757b35b5jf3ab4cb0d4b1a016@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Rename hex_dumper() to hex_dump_to_buffer().
Rename hextoasc() macro to hex_asc()
	[remove conflicts with sky/skfp/skge drivers].
Change output format to remove '-' in middle of ASCII output and
	add space between hex and ASCII output.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kernel.h |    4 ++--
 lib/hexdump.c          |   40 ++++++++++++++++++++--------------------
 2 files changed, 22 insertions(+), 22 deletions(-)

--- linux-2.6.21-git4.orig/include/linux/kernel.h
+++ linux-2.6.21-git4/include/linux/kernel.h
@@ -207,11 +207,11 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
-extern void hex_dumper(const void *buf, size_t len, char *linebuf,
+extern void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
 				size_t linebuflen);
 extern void print_hex_dump(const char *level, int prefix_type,
 				void *buf, size_t len);
-#define hextoasc(x)	"0123456789abcdef"[x]
+#define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
--- linux-2.6.21-git4.orig/lib/hexdump.c
+++ linux-2.6.21-git4/lib/hexdump.c
@@ -13,26 +13,27 @@
 #include <linux/module.h>
 
 /**
- * hex_dumper - convert a blob of data to "hex ASCII" in memory
+ * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
  *
- * hex_dumper() works on one "line" of output at a time, i.e.,
+ * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
  * 16 bytes of input data converted to hex + ASCII output.
  *
- * Given a buffer of u8 data, hex_dumper() converts the input data to a
- * hex + ASCII dump at the supplied memory location.
+ * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
+ * to a hex + ASCII dump at the supplied memory location.
  * The converted output is always NUL-terminated.
  *
  * E.g.:
- *	hex_dumper(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *	hex_dump_to_buffer(frame->data, frame->len, linebuf, sizeof(linebuf));
  *
- * Prints the offsets of the block of memory, not addresses:
- * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ * example output buffer:
+ * 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
  */
-void hex_dumper(const void *buf, size_t len, char *linebuf, size_t linebuflen)
+void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
+			size_t linebuflen)
 {
 	const u8 *ptr = buf;
 	u8 ch;
@@ -42,19 +43,18 @@ void hex_dumper(const void *buf, size_t 
 		if (j && !(j % 4))
 			linebuf[lx++] = ' ';
 		ch = ptr[j];
-		linebuf[lx++] = hextoasc(ch >> 4);
-		linebuf[lx++] = hextoasc(ch & 0x0f);
+		linebuf[lx++] = hex_asc(ch >> 4);
+		linebuf[lx++] = hex_asc(ch & 0x0f);
 	}
-	if (lx < linebuflen)
-		linebuf[lx++] = '-';
-	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++) {
-		linebuf[lx++] = isprint(ptr[j]) ?  ptr[j] : '.';
-		if (j == 7)
-			linebuf[lx++] = ' ';
+	if ((lx + 2) < linebuflen) {
+		linebuf[lx++] = ' ';
+		linebuf[lx++] = ' ';
 	}
+	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
+		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
 	linebuf[lx++] = '\0';
 }
-EXPORT_SYMBOL(hex_dumper);
+EXPORT_SYMBOL(hex_dump_to_buffer);
 
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
@@ -72,9 +72,9 @@ EXPORT_SYMBOL(hex_dumper);
  *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
  *
  * Example output using %DUMP_PREFIX_OFFSET:
- * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
  * Example output using %DUMP_PREFIX_ADDRESS:
- * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.
+ * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f  pqrstuvwxyz{|}~.
  */
 void print_hex_dump(const char *level, int prefix_type, void *buf, size_t len)
 {
@@ -85,7 +85,7 @@ void print_hex_dump(const char *level, i
 	for (i = 0; i < len; i += 16) {
 		linelen = min(remaining, 16);
 		remaining -= 16;
-		hex_dumper(ptr + i, linelen, linebuf, sizeof(linebuf));
+		hex_dump_to_buffer(ptr + i, linelen, linebuf, sizeof(linebuf));
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
