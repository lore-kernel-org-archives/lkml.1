Return-Path: <linux-kernel-owner+w=401wt.eu-S936185AbYEBTBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936185AbYEBTBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbYEBTBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:01:31 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:30418 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYEBTBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:01:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=E0cwKSgA5mJNQvPiQueqh8/AVu/4al6oBn5GHYraX8h5NKMjFPqycEXwk7vidu9W8k9qVUMg8ZvT4aTCVcrWekye3IDX18MXzrHwVFQKfSPpDl1CzRm2bHPEBaHAVUrQGbgexO04QKVZfFSs/qvC2xepSikMCxq2yqJJWDawUJA=
Subject: [PATCH 01/12] lib: add ascii hex helper functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:51 -0700
Message-Id: <1209754911.26173.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Everyone rolls their own version around the tree, centralize
in lib/hexdump.c.  Move the only existing users of hex_asc over
to the hi/lo helpers.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/pnp/support.c  |    8 ++++----
 include/linux/kernel.h |    6 +++++-
 lib/hexdump.c          |   25 +++++++++++++++++++++++--
 3 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/pnp/support.c b/drivers/pnp/support.c
index 3eba85e..95b076c 100644
--- a/drivers/pnp/support.c
+++ b/drivers/pnp/support.c
@@ -45,10 +45,10 @@ void pnp_eisa_id_to_string(u32 id, char *str)
 	str[0] = 'A' + ((id >> 26) & 0x3f) - 1;
 	str[1] = 'A' + ((id >> 21) & 0x1f) - 1;
 	str[2] = 'A' + ((id >> 16) & 0x1f) - 1;
-	str[3] = hex_asc((id >> 12) & 0xf);
-	str[4] = hex_asc((id >>  8) & 0xf);
-	str[5] = hex_asc((id >>  4) & 0xf);
-	str[6] = hex_asc((id >>  0) & 0xf);
+	str[3] = hex_asc_hi(id >> 8);
+	str[4] = hex_asc_lo(id >> 8);
+	str[5] = hex_asc_hi(id);
+	str[6] = hex_asc_lo(id);
 	str[7] = '\0';
 }
 
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
1.5.5.1.350.gbbbf


