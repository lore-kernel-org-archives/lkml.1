Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbZHHC0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbZHHC0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 22:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756655AbZHHC0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 22:26:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:26774 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbZHHC0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 22:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=U5Hi04aLbsERjj80TIXhos0rNcmZf4IJrWjeiQhVKMW2L7dZKinB427VpV1ZtYeDJm
         Vd/uxQCD80TRXpDjLpQG/hUqbIJa3oNzUcZPGLPjlpPaCwYv/d+F5ep+3Va9toiBlAw7
         ARVZzcOpvZouVIiGtvGGP6VACtABv+rVW2XaM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>
Subject: [PATCH 1/4] perf tools: callchain: Warn only once in empty node detection
Date: Sat,  8 Aug 2009 04:26:34 +0200
Message-Id: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fill a new node that is found to be empty (sign of a bug),
we print a message each time that happens. Sometimes we reach thousands
of lines printed.

Just warn only once in that case (and use stderr instead of stdout).

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
---
 tools/perf/util/callchain.c |    3 ++-
 tools/perf/util/util.h      |    3 +++
 tools/perf/util/wrapper.c   |   16 ++++++++++++++++
 3 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 98c5627..ce0c6d4 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <errno.h>
+#include "util.h"
 
 #include "callchain.h"
 
@@ -203,7 +204,7 @@ fill_node(struct callchain_node *node, struct ip_callchain *chain,
 	}
 	node->val_nr = chain->nr - start;
 	if (!node->val_nr)
-		printf("Warning: empty node in callchain tree\n");
+		fprintf_once(stderr, "Warning: empty node in callchain tree\n");
 }
 
 static void
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 68fe157..386ea40 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -148,6 +148,9 @@ static inline const char *skip_prefix(const char *str, const char *prefix)
 	return strncmp(str, prefix, len) ? NULL : str + len;
 }
 
+extern int fprintf_once(FILE *fp, const char *fmt, ...)
+	__attribute__((format (printf, 2, 3)));
+
 #if defined(NO_MMAP) || defined(USE_WIN32_MMAP)
 
 #ifndef PROT_READ
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 4574ac2..026c87c 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -205,3 +205,19 @@ int xmkstemp(char *template)
 		die("Unable to create temporary file: %s", strerror(errno));
 	return fd;
 }
+
+int fprintf_once(FILE *fp, const char *fmt, ...)
+{
+	va_list args;
+	int ret;
+	static int once;
+
+	if (once++)
+		return 1;
+
+	va_start(args, fmt);
+	ret = vfprintf(fp, fmt, args);
+	va_end(args);
+
+	return ret;
+}
-- 
1.6.2.3

