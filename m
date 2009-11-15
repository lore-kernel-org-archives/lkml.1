Return-Path: <linux-kernel-owner+w=401wt.eu-S1751844AbZKODut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbZKODut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 22:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbZKODut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 22:50:49 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:57156 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZKODus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 22:50:48 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf tools: New function to parse string representing size in bytes
Date: Sun, 15 Nov 2009 12:50:45 +0900
Message-Id: <1258257045-1363-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies util/string.[ch] to add new function: bytesexp2int()
to parse string representing size in bytes.

Below is the description of bytesexp2int().

Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
and return its numeric value. (e.g. 268435456)

The parameter str is not changed before and after calling,
but it changed temporally and internally for atoi().
So type of str is char *, not const char *.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/string.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/string.h |    1 +
 2 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 04743d3..bbedb06 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,4 +1,5 @@
 #include <string.h>
+#include <stdlib.h>
 #include "string.h"
 
 static int hex(char ch)
@@ -43,3 +44,91 @@ char *strxfrchar(char *s, char from, char to)
 
 	return s;
 }
+
+static int digit(char ch)
+{
+	if ('0' <= ch && ch <= '9')
+		return 1;
+	return 0;
+}
+
+#define K 1024
+/*
+ * bytesexp2int()
+ * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
+ * and return its numeric value
+ *
+ * The parameter str is not changed before and after calling,
+ * but it changed temporally and internally for atoi().
+ * So type of str is char *, not const char *.
+ */
+int bytesexp2int(char *str)
+{
+	int i, unit = 1;
+	char shelter = '\0';
+	size_t length = -1;
+
+	if (!digit(str[0]))
+		goto err;
+	
+	for (i = 1; i < (int)strlen(str); i++) {
+		switch (str[i]) {
+		case 'B':
+		case 'b':
+			break;
+		case 'K':
+			if (str[i + 1] != 'B')
+				goto err;
+			else
+				goto kilo;
+		case 'k':
+			if (str[i + 1] != 'b')
+				goto err;
+kilo:
+			unit = K;
+			break;
+		case 'M':
+			if (str[i + 1] != 'B')
+				goto err;
+			else
+				goto mega;
+		case 'm':
+			if (str[i + 1] != 'b')
+				goto err;
+mega:
+			unit = K * K;
+			break;
+		case 'G':
+			if (str[i + 1] != 'B')
+				goto err;
+			else
+				goto giga;
+		case 'g':
+			if (str[i + 1] != 'b')
+				goto err;
+giga:
+			unit = K * K * K;
+			break;
+		case '\0':	/* only specified figures */
+			unit = 1;
+			break;
+		default:
+			if (!digit(str[i]))
+				goto err;
+			break;
+		}
+	}
+
+	shelter = str[i];
+	str[i] = (char)'\0';
+	length = atoi(str) * unit;
+	if (shelter != '\0')
+		str[i] = shelter;
+
+	goto end;
+
+err:
+	length = -1;
+end:
+	return length;
+}
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 2c84bf6..adbf077 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -5,6 +5,7 @@
 
 int hex2u64(const char *ptr, u64 *val);
 char *strxfrchar(char *s, char from, char to);
+int bytesexp2int(char *str);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.6.5.2

