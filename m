Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbXE3VhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbXE3VhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757538AbXE3Vg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:36:28 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63004 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003AbXE3Vg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:36:27 -0400
Date: Wed, 30 May 2007 14:34:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hugh@veritas.com
Subject: [PATCH 1/3] hexdump: more output formatting
Message-Id: <20070530143428.2f20446a.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
	<46540DB2.5000605@googlemail.com>
	<Pine.LNX.4.64.0705231016330.20031@schroedinger.engr.sgi.com>
	<4654AC94.6080601@googlemail.com>
	<20070523150122.f9946f37.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231526350.22666@schroedinger.engr.sgi.com>
	<20070523153730.e0e9e91d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705231635370.23144@schroedinger.engr.sgi.com>
	<20070523182145.7d7f1f7e.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705232000140.24066@schroedinger.engr.sgi.com>
	<20070524073131.GA17501@elte.hu>
	<Pine.LNX.4.64.0705241418270.31613@schroedinger.engr.sgi.com>
	<20070524142908.f39f42ea.akpm@linux-foundation.org>
	<20070524145517.1f32cd94.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0705241533510.32401@schroedinger.engr.sgi.com>
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

Add a prefix string parameter.  Callers are responsible for any
string length/alignment that they want to see in the output.  I.e.,
callers should pad strings to achieve alignment if they want that.

Add rowsize parameter.  This is the number of raw data bytes
to be printed per line.  Must be 16 or 32.

Add a group_size parameter.  This allows callers to dump values
as 1-byte, 2-byte, 4-byte, or 8-byte numbers.  Default is
1-byte numbers.  If the total length is not an even multiple
of group_size, 1-byte numbers are printed.

Add an "ascii" output parameter.  This causes ASCII data output
following the hex data output.

Clean up some doc examples.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/kernel.h |   10 ++--
 lib/hexdump.c          |  120 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 99 insertions(+), 31 deletions(-)

--- linux-2622-rc2mm1-slub.orig/include/linux/kernel.h
+++ linux-2622-rc2mm1-slub/include/linux/kernel.h
@@ -218,10 +218,12 @@ enum {
 	DUMP_PREFIX_ADDRESS,
 	DUMP_PREFIX_OFFSET
 };
-extern void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
-				size_t linebuflen);
-extern void print_hex_dump(const char *level, int prefix_type,
-				void *buf, size_t len);
+extern void hex_dump_to_buffer(const void *buf, size_t len,
+				int rowsize, int group_size,
+				char *linebuf, size_t linebuflen, bool ascii);
+extern void print_hex_dump(const char *level, const char *prefix_str,
+				int prefix_type, int rowsize, int group_size,
+				void *buf, size_t len, bool ascii);
 #define hex_asc(x)	"0123456789abcdef"[x]
 
 #ifdef DEBUG
--- linux-2622-rc2mm1-slub.orig/lib/hexdump.c
+++ linux-2622-rc2mm1-slub/lib/hexdump.c
@@ -16,42 +16,92 @@
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
+ * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @group_size: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @linebuf: where to put the converted data
  * @linebuflen: total size of @linebuf, including space for terminating NUL
+ * @ascii: include ASCII after the hex output
  *
  * hex_dump_to_buffer() works on one "line" of output at a time, i.e.,
- * 16 bytes of input data converted to hex + ASCII output.
+ * 16 or 32 bytes of input data converted to hex + ASCII output.
  *
  * Given a buffer of u8 data, hex_dump_to_buffer() converts the input data
  * to a hex + ASCII dump at the supplied memory location.
  * The converted output is always NUL-terminated.
  *
  * E.g.:
- *	hex_dump_to_buffer(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *   hex_dump_to_buffer(frame->data, frame->len, 1, linebuf, sizeof(linebuf));
  *
  * example output buffer:
- * 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
+ * 40 41 42 43 44 45 46 47-48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
  */
-void hex_dump_to_buffer(const void *buf, size_t len, char *linebuf,
-			size_t linebuflen)
+void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
+			int group_size, char *linebuf, size_t linebuflen,
+			bool ascii)
 {
 	const u8 *ptr = buf;
 	u8 ch;
 	int j, lx = 0;
 
-	for (j = 0; (j < 16) && (j < len) && (lx + 3) < linebuflen; j++) {
-		if (j && !(j % 4))
+	if (rowsize != 16 && rowsize != 32)
+		rowsize = 16;
+
+	if (!len)
+		goto nil;
+	if (len > rowsize)		/* limit to one line at a time */
+		len = rowsize;
+	if ((len % group_size) != 0)	/* no mixed size output */
+		group_size = 1;
+
+	switch (group_size) {
+	case 8: {
+		const u64 *ptr8 = buf;
+		int ngroups = len / group_size;
+
+		for (j = 0; j < ngroups; j++)
+			lx += scnprintf(linebuf + lx, linebuflen - lx,
+				"%16.16llx ", (unsigned long long)*(ptr8 + j));
+		break;
+	}
+
+	case 4: {
+		const u32 *ptr4 = buf;
+		int ngroups = len / group_size;
+
+		for (j = 0; j < ngroups; j++)
+			lx += scnprintf(linebuf + lx, linebuflen - lx,
+				"%8.8x ", *(ptr4 + j));
+		break;
+	}
+
+	case 2: {
+		const u16 *ptr2 = buf;
+		int ngroups = len / group_size;
+
+		for (j = 0; j < ngroups; j++)
+			lx += scnprintf(linebuf + lx, linebuflen - lx,
+				"%4.4x ", *(ptr2 + j));
+		break;
+	}
+
+	default:
+		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
+		     j++) {
+			ch = ptr[j];
+			linebuf[lx++] = hex_asc(ch >> 4);
+			linebuf[lx++] = hex_asc(ch & 0x0f);
 			linebuf[lx++] = ' ';
-		ch = ptr[j];
-		linebuf[lx++] = hex_asc(ch >> 4);
-		linebuf[lx++] = hex_asc(ch & 0x0f);
+		}
+		break;
 	}
-	if ((lx + 2) < linebuflen) {
-		linebuf[lx++] = ' ';
+	if (!ascii)
+		goto nil;
+
+	if ((lx + 1) < linebuflen)
 		linebuf[lx++] = ' ';
-	}
-	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++)
+	for (j = 0; (j < rowsize) && (j < len) && (lx + 2) < linebuflen; j++)
 		linebuf[lx++] = isprint(ptr[j]) ? ptr[j] : '.';
+nil:
 	linebuf[lx++] = '\0';
 }
 EXPORT_SYMBOL(hex_dump_to_buffer);
@@ -59,44 +109,60 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
 /**
  * print_hex_dump - print a text hex dump to syslog for a binary blob of data
  * @level: kernel log level (e.g. KERN_DEBUG)
+ * @prefix_str: string to prefix each line with;
+ *  caller supplies trailing spaces for alignment if desired
  * @prefix_type: controls whether prefix of an offset, address, or none
  *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @rowsize: number of bytes to print per line; must be 16 or 32
+ * @group_size: number of bytes to print at a time (1, 2, 4, 8; default = 1)
  * @buf: data blob to dump
  * @len: number of bytes in the @buf
+ * @ascii: include ASCII after the hex output
  *
  * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
  * to the kernel log at the specified kernel log level, with an optional
  * leading prefix.
  *
+ * print_hex_dump() works on one "line" of output at a time, i.e.,
+ * 16 or 32 bytes of input data converted to hex + ASCII output.
+ * print_hex_dump() iterates over the entire input @buf, breaking it into
+ * "line size" chunks to format and print.
+ *
  * E.g.:
  *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
  *
- * Example output using %DUMP_PREFIX_OFFSET:
- * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f  @ABCDEFGHIJKLMNO
- * Example output using %DUMP_PREFIX_ADDRESS:
- * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f  pqrstuvwxyz{|}~.
+ * Example output using %DUMP_PREFIX_OFFSET and 1-byte mode:
+ * 0009ab42: 40 41 42 43 44 45 46 47-48 49 4a 4b 4c 4d 4e 4f  @ABCDEFGHIJKLMNO
+ * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
+ * ffffffff88089af0: 73727170 77767574-7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
  */
-void print_hex_dump(const char *level, int prefix_type, void *buf, size_t len)
+void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
+			int rowsize, int group_size,
+			void *buf, size_t len, bool ascii)
 {
 	u8 *ptr = buf;
 	int i, linelen, remaining = len;
-	unsigned char linebuf[100];
+	unsigned char linebuf[200];
+
+	if (rowsize != 16 && rowsize != 32)
+		rowsize = 16;
 
-	for (i = 0; i < len; i += 16) {
-		linelen = min(remaining, 16);
-		remaining -= 16;
-		hex_dump_to_buffer(ptr + i, linelen, linebuf, sizeof(linebuf));
+	for (i = 0; i < len; i += rowsize) {
+		linelen = min(remaining, rowsize);
+		remaining -= rowsize;
+		hex_dump_to_buffer(ptr + i, linelen, rowsize, group_size,
+				linebuf, sizeof(linebuf), ascii);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
-			printk("%s%*p: %s\n", level,
+			printk("%s%s%*p: %s\n", level, prefix_str,
 				(int)(2 * sizeof(void *)), ptr + i, linebuf);
 			break;
 		case DUMP_PREFIX_OFFSET:
-			printk("%s%.8x: %s\n", level, i, linebuf);
+			printk("%s%s%.8x: %s\n", level, prefix_str, i, linebuf);
 			break;
 		default:
-			printk("%s%s\n", level, linebuf);
+			printk("%s%s%s\n", level, prefix_str, linebuf);
 			break;
 		}
 	}
