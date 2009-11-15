Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZKOKTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZKOKTI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:19:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZKOKTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:19:08 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60370 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbZKOKTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:19:07 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH v3] perf tools: New function to parse string representing size in bytes
Date: Sun, 15 Nov 2009 19:19:03 +0900
Message-Id: <1258280343-4359-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091115.185220.212229853.mitake@dcl.info.waseda.ac.jp>
References: <20091115.185220.212229853.mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies util/string.[ch] to add new function: bytesexp2int()
to parse string representing size in bytes.

This patch is version 3. According to Ingo's advice,
I fixed some points which violate kernel coding rule.

And I found that atoi()'s kindness.
When atoi() meets character not digit, this stops reading argument and
starts converting. e.g. atoi("1TB") -> 1
So I changed parameter type of bytesexp2int() from char * to const char *.
I think this is more natural style than old one.

This function parse (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
and return its numeric value. (e.g. 268435456)

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/string.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/string.h |    1 +
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 04743d3..30ca7f3 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,7 @@
 #include <string.h>
+#include <stdlib.h>
 #include "string.h"
+#include "util.h"
 
 static int hex(char ch)
 {
@@ -43,3 +45,85 @@ char *strxfrchar(char *s, char from, char to)
 
 	return s;
 }
+
+#define K 1024
+/*
+ * bytesexp2int()
+ * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
+ * and return its numeric value
+ */
+long long int bytesexp2int(const char *str)
+{
+	unsigned int i;
+	long long int length = -1, unit = 1;
+
+	if (!isdigit(str[0]))
+		goto out_err;
+
+	for (i = 1; i < strlen(str); i++) {
+		switch (str[i]) {
+		case 'B':
+		case 'b':
+			break;
+		case 'K':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto kilo;
+		case 'k':
+			if (str[i + 1] != 'b')
+				goto out_err;
+kilo:
+			unit = K;
+			break;
+		case 'M':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto mega;
+		case 'm':
+			if (str[i + 1] != 'b')
+				goto out_err;
+mega:
+			unit = K * K;
+			break;
+		case 'G':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto giga;
+		case 'g':
+			if (str[i + 1] != 'b')
+				goto out_err;
+giga:
+			unit = K * K * K;
+			break;
+		case 'T':
+			if (str[i + 1] != 'B')
+				goto out_err;
+			else
+				goto tera;
+		case 't':
+			if (str[i + 1] != 'b')
+				goto out_err;
+tera:
+			unit = (long long int)K * K * K * K;
+			break;
+		case '\0':	/* only specified figures */
+			unit = 1;
+			break;
+		default:
+			if (!isdigit(str[i]))
+				goto out_err;
+			break;
+		}
+	}
+
+	length = atoll(str) * unit;
+	goto out;
+
+out_err:
+	length = -1;
+out:
+	return length;
+}
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 2c84bf6..7e32233 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -5,6 +5,7 @@
 
 int hex2u64(const char *ptr, u64 *val);
 char *strxfrchar(char *s, char from, char to);
+long long int bytesexp2int(const char *str);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.6.5.2

