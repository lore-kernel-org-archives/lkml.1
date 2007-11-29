Return-Path: <linux-kernel-owner+w=401wt.eu-S933730AbXK2U7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933730AbXK2U7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbXK2U7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:59:31 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:4944 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbXK2U7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:59:30 -0500
Subject: [PATCH] Reduce stack used by lib/hexdump.c
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <474F0A68.1080809@oracle.com>
References: <1196359724.22120.22.camel@localhost>
	 <20071129102400.dac158d8.randy.dunlap@oracle.com>
	 <1196361860.22120.27.camel@localhost>  <474F0A68.1080809@oracle.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 12:57:53 -0800
Message-Id: <1196369873.22120.69.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

200 bytes on stack might be a bit much.

Size goes up to
   text    data     bss     dec     hex filename
   1142       0       0    1142     476 lib/hexdump.o
Without the WARN_ON
   1053       0       0    1053     41d lib/hexdump.o
Before this patch
   1004       0       0    1004     3ec lib/hexdump.o

Win some/lose some...

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/lib/hexdump.c b/lib/hexdump.c
index 70e23fb..be94934 100644
--- a/lib/hexdump.c
+++ b/lib/hexdump.c
@@ -140,13 +140,20 @@ EXPORT_SYMBOL(hex_dump_to_buffer);
  * Example output using %DUMP_PREFIX_ADDRESS and 4-byte mode:
  * ffffffff88089af0: 73727170 77767574 7b7a7978 7f7e7d7c  pqrstuvwxyz{|}~.
  */
+
+#define HEX_LINE_SIZE 200
+
 void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 			int rowsize, int groupsize,
 			const void *buf, size_t len, bool ascii)
 {
 	const u8 *ptr = buf;
 	int i, linelen, remaining = len;
-	unsigned char linebuf[200];
+	unsigned char *linebuf;
+
+	linebuf = kmalloc(HEX_LINE_SIZE, GFP_KERNEL);
+	if (!linebuf) {
+		WARN_ON(1);
+		return;
+	}
 
 	if (rowsize != 16 && rowsize != 32)
 		rowsize = 16;
@@ -155,7 +162,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 		linelen = min(remaining, rowsize);
 		remaining -= rowsize;
 		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
-				linebuf, sizeof(linebuf), ascii);
+				linebuf, HEX_LINE_SIZE, ascii);
 
 		switch (prefix_type) {
 		case DUMP_PREFIX_ADDRESS:
@@ -170,6 +177,7 @@ void print_hex_dump(const char *level, const char *prefix_str, int prefix_type,
 			break;
 		}
 	}
+	kfree(linebuf);
 }
 EXPORT_SYMBOL(print_hex_dump);
 


