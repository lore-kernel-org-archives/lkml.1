Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbYEAXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbYEAXFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 19:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbYEAXFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 19:05:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:8045 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758507AbYEAXFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 19:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oCcNrDgdmL5vb3BFsOycBiGUliMYXasmk5DAdd2DfXWCodi2JUx1fI4l1DlRWm9hoZ3oh/qouND8Dr5Y9jwTea4vaJsC3mWAJbKLh/AZFyANNb1SPmkMPUdL6O8r1uQeqXUOlqkw5NquHru9A7KS4Tqj0OQVJTsj/rDw9OfTmdE=
Subject: [PATCH 1/9] lib: add ascii hex helper functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 16:05:34 -0700
Message-Id: <1209683134.24729.203.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone rolls their own version around the tree, centralize
in lib/hexdump.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/kernel.h |    6 +++++-
 lib/hexdump.c          |   25 +++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4d46e29..20cae9a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -276,7 +276,11 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
 				const void *buf, size_t len, bool ascii);
 extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
 			const void *buf, size_t len);
-#define hex_asc(x)	"0123456789abcdef"[x]
+
+extern const char hex_asc[];
+extern int hex_to_int(char c);
+#define hex_asc_lo(x)	hex_asc[((x) & 0x0f)]
+#define hex_asc_hi(x)	hex_asc[((x) & 0xf0) >> 4]
 
 #define pr_emerg(fmt, arg...) \
 	printk(KERN_EMERG fmt, ##arg)
diff --git a/lib/hexdump.c b/lib/hexdump.c
index 3435465..fa1a76e 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -12,6 +12,27 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+const char hex_asc[] = "0123456789abcdef";
+
+/**
+ * hex_to_int - convert a single hex ASCII char to an integer value
+ * @ch: char to convert, not case sensitive [a-f][A-F][0-9]
+ *
+ * Returns -1 if the char is not a valid hexadecimal character
+ */
+int hex_to_int(char ch)
+{
+	/*
+	 * Make ch lower-case, works only for digits and letters
+	 */
+	ch |= 0x20;
+	if (ch >= 'a' && ch <= 'f')
+		return ch - 'a' + 10;
+	if (ch >= '0' && ch <= '9')
+		return ch - '0';
+	return -1;
+}
+
 /**
  * hex_dump_to_buffer - convert a blob of data to "hex ASCII" in memory
  * @buf: data blob to dump
@@ -93,8 +114,8 @@ void hex_dump_to_buffer(const void *buf, size_t len, int rowsize,
 		for (j = 0; (j < rowsize) && (j < len) && (lx + 4) < linebuflen;
 		     j++) {
 			ch = ptr[j];
-			linebuf[lx++] = hex_asc(ch >> 4);
-			linebuf[lx++] = hex_asc(ch & 0x0f);
+			linebuf[lx++] = hex_asc_hi(ch);
+			linebuf[lx++] = hex_asc_lo(ch);
 			linebuf[lx++] = ' ';
 		}
 		ascii_column = 3 * rowsize + 2;
-- 
1.5.5.1.305.g7c84


