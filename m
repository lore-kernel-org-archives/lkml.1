Return-Path: <linux-kernel-owner+w=401wt.eu-S1767558AbXEDArL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767558AbXEDArL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 20:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767557AbXEDArK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 20:47:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33390 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767552AbXEDArH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 20:47:07 -0400
Date: Thu, 3 May 2007 17:49:24 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
Subject: [PATCH v2] lib/hexdump
Message-Id: <20070503174924.d0cbafa3.randy.dunlap@oracle.com>
In-Reply-To: <20070502161533.cbf38b4b.randy.dunlap@oracle.com>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
	<20070502154557.b463c9c3.akpm@linux-foundation.org>
	<46391730.2080003@oracle.com>
	<20070502160635.31dd91e6.akpm@linux-foundation.org>
	<20070502161533.cbf38b4b.randy.dunlap@oracle.com>
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


> > Ho hum.  Perhaps a middle ground is to implement hexdump-to-memory as the
> > core function.  hex_dumper() becomes a simple wrapper around that.  (but
> > how big is its buffer?  One line would be OK, I guess)
> 
> Yeah, I almost did it that way.  We'll see.
> 
> > > OK, that's one way to do it.  I'll wait a bit for other comments.
> > 
> > Good luck ;)

		next try:


From: Randy Dunlap <randy.dunlap@oracle.com>

Based on ace_dump_mem() from Grant Likely for the Xilinx 
SystemACE CompactFlash interface.

Add print_hex_dump() & hex_dumper() to lib/hexdump.c and linux/kernel.h.

This patch adds the functions print_hex_dump() & hex_dumper().
print_hex_dump() can be used to perform a hex + ASCII dump of data to syslog,
in an easily viewable format, thus providing a common text hex dump format.

hex_dumper() provides a dump-to-memory function.  It converts one "line"
of output (16 bytes of input) at a time.

Example usages:
	print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
	hex_dumper(frame->data, frame->len, linebuf, sizeof(linebuf));

Example output using %DUMP_PREFIX_OFFSET:
0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
Example output using %DUMP_PREFIX_ADDRESS:
ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---

 include/linux/kernel.h |   10 ++++
 lib/Makefile           |    2 
 lib/hexdump.c          |  105 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 116 insertions(+), 1 deletion(-)

--- linux-2.6.21-git4.orig/include/linux/kernel.h
+++ linux-2.6.21-git4/include/linux/kernel.h
@@ -202,6 +202,16 @@ extern enum system_states {
 
 extern void dump_stack(void);
 
+enum {
+	DUMP_PREFIX_NONE,
+	DUMP_PREFIX_ADDRESS,
+	DUMP_PREFIX_OFFSET
+};
+extern void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen);
+extern void print_hex_dump(const char *level, int prefix_type,
+				void *buf, size_t len);
+#define hextoasc(x)	"0123456789abcdef"[x]
+
 #ifdef DEBUG
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt,arg...) \
--- linux-2.6.21-git4.orig/lib/Makefile
+++ linux-2.6.21-git4/lib/Makefile
@@ -13,7 +13,7 @@ lib-$(CONFIG_SMP) += cpumask.o
 lib-y	+= kobject.o kref.o kobject_uevent.o klist.o
 
 obj-y += div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
-	 bust_spinlocks.o
+	 bust_spinlocks.o hexdump.o
 
 ifeq ($(CONFIG_DEBUG_KOBJECT),y)
 CFLAGS_kobject.o += -DDEBUG
--- /dev/null
+++ linux-2.6.21-git4/lib/hexdump.c
@@ -0,0 +1,105 @@
+/*
+ * lib/hexdump.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation. See README and COPYING for
+ * more details.
+ */
+
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+/**
+ * hex_dumper - convert a blob of data to "hex ASCII" in memory
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ * @linebuf: where to put the converted data
+ * @linebuflen: total size of @linebuf, including space for terminating NUL
+ *
+ * hex_dumper() works on one "line" of output at a time, i.e.,
+ * 16 bytes of input data converted to hex + ASCII output.
+ *
+ * Given a buffer of u8 data, hex_dumper() converts the input data to a
+ * hex + ASCII dump at the supplied memory location.
+ * The converted output is always NUL-terminated.
+ *
+ * E.g.:
+ *	hex_dumper(frame->data, frame->len, linebuf, sizeof(linebuf));
+ *
+ * Prints the offsets of the block of memory, not addresses:
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ */
+void hex_dumper(void *buf, size_t len, char *linebuf, size_t linebuflen)
+{
+	const u8 *ptr = buf;
+	u8 ch;
+	int j, lx = 0;
+
+	for (j = 0; (j < 16) && (j < len) && (lx + 3) < linebuflen; j++) {
+		if (j && !(j % 4))
+			linebuf[lx++] = ' ';
+		ch = ptr[j];
+		linebuf[lx++] = hextoasc(ch >> 4);
+		linebuf[lx++] = hextoasc(ch & 0x0f);
+	}
+	if (lx < linebuflen)
+		linebuf[lx++] = '-';
+	for (j = 0; (j < 16) && (j < len) && (lx + 2) < linebuflen; j++) {
+		linebuf[lx++] = isprint(ptr[j]) ?  ptr[j] : '.';
+		if (j == 7)
+			linebuf[lx++] = ' ';
+	}
+	linebuf[lx++] = '\0';
+}
+EXPORT_SYMBOL(hex_dumper);
+
+/**
+ * print_hex_dump - print a text hex dump to syslog for a binary blob of data
+ * @level: kernel log level (e.g. KERN_DEBUG)
+ * @prefix_type: controls whether prefix of an offset, address, or none
+ *  is printed (%DUMP_PREFIX_OFFSET, %DUMP_PREFIX_ADDRESS, %DUMP_PREFIX_NONE)
+ * @buf: data blob to dump
+ * @len: number of bytes in the @buf
+ *
+ * Given a buffer of u8 data, print_hex_dump() prints a hex + ASCII dump
+ * to the kernel log at the specified kernel log level, with an optional
+ * leading prefix.
+ *
+ * E.g.:
+ *   print_hex_dump(KERN_DEBUG, DUMP_PREFIX_ADDRESS, frame->data, frame->len);
+ *
+ * Example output using %DUMP_PREFIX_OFFSET:
+ * 0009ab42: 40414243 44454647 48494a4b 4c4d4e4f-@ABCDEFG HIJKLMNO
+ * Example output using %DUMP_PREFIX_ADDRESS:
+ * ffffffff88089af0: 70717273 74757677 78797a7b 7c7d7e7f-pqrstuvw xyz{|}~.
+ */
+void print_hex_dump(const char *level, int prefix_type, void *buf, size_t len)
+{
+	u8 *ptr = buf;
+	int i, linelen, remaining = len;
+	unsigned char linebuf[100];
+
+	for (i = 0; i < len; i += 16) {
+		linelen = min(remaining, 16);
+		remaining -= 16;
+		hex_dumper(ptr + i, linelen, linebuf, sizeof(linebuf));
+
+		switch (prefix_type)
+		{
+		case DUMP_PREFIX_ADDRESS:
+			printk("%s%*p: %s\n", level,
+				(int)(2 * sizeof(void *)), ptr + i, linebuf);
+			break;
+		case DUMP_PREFIX_OFFSET:
+			printk("%s%.8x: %s\n", level, i, linebuf);
+			break;
+		default:
+			printk("%s%s\n", level, linebuf);
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(print_hex_dump);
