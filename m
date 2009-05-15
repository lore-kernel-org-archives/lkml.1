Return-Path: <linux-kernel-owner+w=401wt.eu-S1762878AbZEOQR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878AbZEOQR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 12:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZEOQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 12:17:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:6205 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262AbZEOQRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 12:17:21 -0400
X-IronPort-AV: E=Sophos;i="4.41,200,1241409600"; 
   d="scan'208";a="51374072"
From: Ian Campbell <ian.campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ian.campbell@citrix.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Fix print out of function which called WARN_ON()
Date: Fri, 15 May 2009 17:17:16 +0100
Message-Id: <1242404236-17624-1-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 15 May 2009 16:17:21.0335 (UTC) FILETIME=[9FF75C70:01C9D578]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All WARN_ON()'s currently appear to come from warn_slowpath_null e.g.:
 WARNING: at kernel/softirq.c:143 warn_slowpath_null+0x1c/0x20()

This is because since:

  commit 57adc4d2dbf968fdbe516359688094eef4d46581
  Author: Andi Kleen <andi@firstfloor.org>
  Date:   Wed May 6 16:02:53 2009 -0700

      Eliminate thousands of warnings with gcc 3.2 build

the caller of warn_slowpath_fmt really is warn_flowpath_null not the
interesting caller next up the chain. Since __builtin_return_address(X) for X >
0 is not reliable, pass the real caller as an argument to warn_slowpath_fmt.

[If there was a __builtin_this_address() I would use that for the WARN() case
for consistency, I don't know of such a thing though]

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/asm-generic/bug.h |    5 +++--
 kernel/panic.c            |   11 ++++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 4f4f6e9..39d8dbd 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -59,12 +59,13 @@ struct bug_entry {
 #ifndef __WARN
 #ifndef __ASSEMBLY__
 extern void warn_slowpath_fmt(const char *file, const int line,
-		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
+		unsigned long caller,
+		const char *fmt, ...) __attribute__((format(printf, 4, 5)));
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
 #define __WARN()		warn_slowpath_null(__FILE__, __LINE__)
-#define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, arg)
+#define __WARN_printf(arg...)	warn_slowpath_fmt(__FILE__, __LINE__, 0UL, arg)
 #else
 #define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #endif
diff --git a/kernel/panic.c b/kernel/panic.c
index 874ecf1..4e1d746 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -340,13 +340,16 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_slowpath_fmt(const char *file, int line, const char *fmt, ...)
+void warn_slowpath_fmt(const char *file, int line, unsigned long caller,
+		       const char *fmt, ...)
 {
 	va_list args;
 	char function[KSYM_SYMBOL_LEN];
-	unsigned long caller = (unsigned long)__builtin_return_address(0);
 	const char *board;
 
+	if (!caller)
+		caller = (unsigned long)__builtin_return_address(0);
+
 	sprint_symbol(function, caller);
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
@@ -372,7 +375,9 @@ EXPORT_SYMBOL(warn_slowpath_fmt);
 void warn_slowpath_null(const char *file, int line)
 {
 	static const char *empty = "";
-	warn_slowpath_fmt(file, line, empty);
+	warn_slowpath_fmt(file, line,
+			  (unsigned long)__builtin_return_address(0),
+			  empty);
 }
 EXPORT_SYMBOL(warn_slowpath_null);
 #endif
-- 
1.5.6.5

