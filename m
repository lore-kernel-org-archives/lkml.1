Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZKOOTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZKOOTq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 09:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbZKOOTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 09:19:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:59502 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbZKOOTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 09:19:44 -0500
Date: Sun, 15 Nov 2009 14:18:37 GMT
From: tip-bot for Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, mitake@dcl.info.waseda.ac.jp,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258285013-4759-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1258285013-4759-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add new perf_atoll() function to parse string representing size in bytes
Message-ID: <tip-d2fb8b4151a92223da6a84006f8f248ebeb6677d@git.kernel.org>
Git-Commit-ID: d2fb8b4151a92223da6a84006f8f248ebeb6677d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2fb8b4151a92223da6a84006f8f248ebeb6677d
Gitweb:     http://git.kernel.org/tip/d2fb8b4151a92223da6a84006f8f248ebeb6677d
Author:     Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
AuthorDate: Sun, 15 Nov 2009 20:36:53 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 14:54:23 +0100

perf tools: Add new perf_atoll() function to parse string representing size in bytes

This patch modifies util/string.[ch] to add new function:
perf_atoll() to parse string representing size in bytes.

This function parses (\d+)(b|B|kb|KB|mb|MB|gb|GB) (e.g. "256MB")
and returns its numeric value. (e.g. 268435456)

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1258285013-4759-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/string.c |   84 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/string.h |    1 +
 2 files changed, 85 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index 04743d3..2270435 100644
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
+#define K 1024LL
+/*
+ * perf_atoll()
+ * Parse (\d+)(b|B|kb|KB|mb|MB|gb|GB|tb|TB) (e.g. "256MB")
+ * and return its numeric value
+ */
+s64 perf_atoll(const char *str)
+{
+	unsigned int i;
+	s64 length = -1, unit = 1;
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
+			unit = K * K * K * K;
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
index 2c84bf6..e50b07f 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -5,6 +5,7 @@
 
 int hex2u64(const char *ptr, u64 *val);
 char *strxfrchar(char *s, char from, char to);
+s64 perf_atoll(const char *str);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
