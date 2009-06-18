Return-Path: <linux-kernel-owner+w=401wt.eu-S1762611AbZFRHtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762611AbZFRHtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 03:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761189AbZFRHtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 03:49:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:44382 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759354AbZFRHtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 03:49:12 -0400
Date: Thu, 18 Jun 2009 07:48:34 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter tools: Add and use isprint()
Message-ID: <tip-a73c7d84a1975b44c0ebd03c2dec288af1426349@git.kernel.org>
Git-Commit-ID: a73c7d84a1975b44c0ebd03c2dec288af1426349
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 18 Jun 2009 07:48:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a73c7d84a1975b44c0ebd03c2dec288af1426349
Gitweb:     http://git.kernel.org/tip/a73c7d84a1975b44c0ebd03c2dec288af1426349
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 18 Jun 2009 09:44:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Jun 2009 09:46:00 +0200

perf_counter tools: Add and use isprint()

Introduce isprint() to print out raw event dumps to ASCII, etc.

(This is an extension to upstream Git's ctype.c.)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
[ removed openssl.h inclusion from util.h - it leaked ctype.h ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/builtin-report.c |    2 +-
 tools/perf/util/ctype.c     |   17 +++++++++++------
 tools/perf/util/util.h      |   19 ++++++++-----------
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e14e986..9a3805f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -1285,7 +1285,7 @@ static void trace_event(event_t *event)
 			for (j = 0; j < 15-(i & 15); j++)
 				cdprintf("   ");
 			for (j = 0; j < (i & 15); j++) {
-				if (issane(raw_event[i-15+j]))
+				if (isprint(raw_event[i-15+j]))
 					cdprintf("%c", raw_event[i-15+j]);
 				else
 					cdprintf(".");
diff --git a/tools/perf/util/ctype.c b/tools/perf/util/ctype.c
index b90ec00..0b791bd 100644
--- a/tools/perf/util/ctype.c
+++ b/tools/perf/util/ctype.c
@@ -11,16 +11,21 @@ enum {
 	D = GIT_DIGIT,
 	G = GIT_GLOB_SPECIAL,	/* *, ?, [, \\ */
 	R = GIT_REGEX_SPECIAL,	/* $, (, ), +, ., ^, {, | * */
+	P = GIT_PRINT_EXTRA,	/* printable - alpha - digit - glob - regex */
+
+	PS = GIT_SPACE | GIT_PRINT_EXTRA,
 };
 
 unsigned char sane_ctype[256] = {
+/*	0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F			    */
+
 	0, 0, 0, 0, 0, 0, 0, 0, 0, S, S, 0, 0, S, 0, 0,		/*   0.. 15 */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,		/*  16.. 31 */
-	S, 0, 0, 0, R, 0, 0, 0, R, R, G, R, 0, 0, R, 0,		/*  32.. 47 */
-	D, D, D, D, D, D, D, D, D, D, 0, 0, 0, 0, 0, G,		/*  48.. 63 */
-	0, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  64.. 79 */
-	A, A, A, A, A, A, A, A, A, A, A, G, G, 0, R, 0,		/*  80.. 95 */
-	0, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  96..111 */
-	A, A, A, A, A, A, A, A, A, A, A, R, R, 0, 0, 0,		/* 112..127 */
+	PS,P, P, P, R, P, P, P, R, R, G, R, P, P, R, P,		/*  32.. 47 */
+	D, D, D, D, D, D, D, D, D, D, P, P, P, P, P, G,		/*  48.. 63 */
+	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  64.. 79 */
+	A, A, A, A, A, A, A, A, A, A, A, G, G, P, R, P,		/*  80.. 95 */
+	P, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,		/*  96..111 */
+	A, A, A, A, A, A, A, A, A, A, A, R, R, P, P, 0,		/* 112..127 */
 	/* Nothing in the 128.. range */
 };
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index ce9b514..b8cfed7 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -100,11 +100,6 @@
 #include <iconv.h>
 #endif
 
-#ifndef NO_OPENSSL
-#include <openssl/ssl.h>
-#include <openssl/err.h>
-#endif
-
 /* On most systems <limits.h> would have given us this, but
  * not on some systems (e.g. GNU/Hurd).
  */
@@ -332,18 +327,20 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef tolower
 #undef toupper
 extern unsigned char sane_ctype[256];
-#define GIT_SPACE 0x01
-#define GIT_DIGIT 0x02
-#define GIT_ALPHA 0x04
-#define GIT_GLOB_SPECIAL 0x08
-#define GIT_REGEX_SPECIAL 0x10
+#define GIT_SPACE		0x01
+#define GIT_DIGIT		0x02
+#define GIT_ALPHA		0x04
+#define GIT_GLOB_SPECIAL	0x08
+#define GIT_REGEX_SPECIAL	0x10
+#define GIT_PRINT_EXTRA		0x20
+#define GIT_PRINT		0x3E
 #define sane_istest(x,mask) ((sane_ctype[(unsigned char)(x)] & (mask)) != 0)
 #define isascii(x) (((x) & ~0x7f) == 0)
 #define isspace(x) sane_istest(x,GIT_SPACE)
 #define isdigit(x) sane_istest(x,GIT_DIGIT)
 #define isalpha(x) sane_istest(x,GIT_ALPHA)
 #define isalnum(x) sane_istest(x,GIT_ALPHA | GIT_DIGIT)
-#define issane(x)  sane_istest(x,GIT_SPACE | GIT_DIGIT | GIT_ALPHA | GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
+#define isprint(x) sane_istest(x,GIT_PRINT)
 #define is_glob_special(x) sane_istest(x,GIT_GLOB_SPECIAL)
 #define is_regex_special(x) sane_istest(x,GIT_GLOB_SPECIAL | GIT_REGEX_SPECIAL)
 #define tolower(x) sane_case((unsigned char)(x), 0x20)
