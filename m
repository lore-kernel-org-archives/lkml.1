Return-Path: <linux-kernel-owner+w=401wt.eu-S936562AbXFGFQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936562AbXFGFQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 01:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754404AbXFGFQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 01:16:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35429 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbXFGFQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 01:16:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linux-kernel@vger.kernel.org
Subject: [patch/rfc] implement memmem() locally in kallsyms.c
Date: Thu, 7 Jun 2007 01:16:31 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706070116.32042.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch basically copies the gnulib version of memmem() into
scripts/kallsyms.c.  While a useful function, it isn't in POSIX so some
systems (like Darwin) choose to omit it.  How do others feel ?

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -26,8 +26,6 @@
  *
  */
 
-#define _GNU_SOURCE
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -56,6 +54,37 @@ int token_profit[0x10000];
 unsigned char best_table[256][2];
 unsigned char best_table_len[256];
 
+/* memmem(), while useful, is not in POSIX, so create a local version
+ * so we can compile on non-GNU systems (Darwin, *BSD, etc...)
+ */
+void *memmem(const void *haystack, size_t haystack_len,
+             const void *needle, size_t needle_len)
+{
+	const char *begin;
+	const char *const last_possible =
+		(const char *)haystack + haystack_len - needle_len;
+
+	/* The first occurrence of the empty string is deemed to occur at
+	 * the beginning of the string.
+	 */
+	if (needle_len == 0)
+		return (void *)haystack;
+
+	/* Sanity check, otherwise the loop might search through the whole
+	 * memory.
+	 */
+	if (haystack_len < needle_len)
+		return NULL;
+
+	for (begin = (const char *)haystack; begin <= last_possible; ++begin)
+		if (begin[0] == ((const char *)needle)[0] &&
+		    !memcmp((const void *)&begin[1],
+		            (const void *)((const char *)needle + 1),
+		            needle_len - 1))
+			return (void *)begin;
+
+	return NULL;
+}
 
 static void usage(void)
 {
