Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZKQRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZKQRFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZKQRFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:05:50 -0500
Received: from mga14.intel.com ([143.182.124.37]:24379 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755607AbZKQRFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:05:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,759,1249282800"; 
   d="scan'208";a="212526488"
From: "Luck, Tony" <tony.luck@intel.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Paul Mackerras" <paulus@samba.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ia64 support for tools/perf/
Date: Tue, 17 Nov 2009 09:05:56 -0800
Message-Id: <4b02d7f43514327a@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiler on ia64 rejects the "-m64" option.
Add arch specific pieces to perf.h

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

I expect there is a more elegant solution to the Makefile issue. Feel
free to throw away that part of this patch and replace it with something
prettier :-)

 tools/perf/Makefile |    8 +++++---
 tools/perf/perf.h   |    6 ++++++
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e190d5..078bcef 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -164,10 +164,12 @@ ifdef NO_64BIT
   MBITS := -m32
 else
   #
-  # If we're on a 64-bit kernel, use -m64:
+  # If we're on a 64-bit kernel (except ia64), use -m64:
   #
-  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-    MBITS := -m64
+  ifneq ($(uname_M),ia64)
+    ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
+      MBITS := -m64
+    endif
   endif
 endif
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 8cc4623..26be918 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -47,6 +47,12 @@
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
+#ifdef __ia64__
+#include "../../arch/ia64/include/asm/unistd.h"
+#define rmb()		asm volatile ("mf" ::: "memory")
+#define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
