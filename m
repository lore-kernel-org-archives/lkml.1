Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZKVMRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZKVMRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZKVMRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:17:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbZKVMRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:17:31 -0500
Date: Sun, 22 Nov 2009 14:13:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] perf: use default compiler mode by default
Message-ID: <20091122121335.GA24254@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc with no flags typically is a sane default for systems to use, and
looking at the running kernel is probably broken for cross-builds
anyway, so let's not do this.  Add EXTRA_CFLAGS so that users can
override default gcc mode if they want to.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 tools/perf/Makefile |   20 +++-----------------
 1 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d0bdaf2..ab35b0f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -148,6 +148,8 @@ all::
 # broken, or spawning external process is slower than built-in grep perf has).
 #
 # Define LDFLAGS=-static to build a static binary.
+#
+# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for cross-builds.
 
 PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
@@ -160,22 +162,6 @@ uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
 uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
 uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
 
-#
-# Add -m32 for cross-builds:
-#
-ifdef NO_64BIT
-  MBITS := -m32
-else
-  #
-  # If we're on a 64-bit kernel (except ia64), use -m64:
-  #
-  ifneq ($(uname_M),ia64)
-    ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-      MBITS := -m64
-    endif
-  endif
-endif
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -212,7 +198,7 @@ ifndef PERF_DEBUG
   CFLAGS_OPTIMIZE = -O6
 endif
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = -ggdb3 -Wall -Wextra -std=gnu99 -Werror $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
-- 
1.6.5.2.143.g8cc62
