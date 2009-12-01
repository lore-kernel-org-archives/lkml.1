Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584AbZLAUcC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbZLAUcC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:32:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbZLAUcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:32:01 -0500
Received: from jamieiles.v.servelocity.net ([85.8.132.214]:34787 "EHLO
	jamieiles.v.servelocity.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbZLAUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:32:00 -0500
X-Greylist: delayed 1199 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Dec 2009 15:31:59 EST
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf tools: allow cross compiling of perf tools
Date: Tue,  1 Dec 2009 20:11:50 +0000
Message-Id: <1259698310-11025-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For embedded systems we need to cross compile applications on
the build machine. Use the CROSS_COMPILE variable like the kernel
itself.

Additionally, we can't use uname to determine whether we should
build for 64 bit. Use the -dumpmachine flag of GCC to determine
the target arch.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/Makefile |   56 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7e190d5..aed4812 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -150,27 +150,6 @@ PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN
 -include PERF-VERSION-FILE
 
-uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
-uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
-uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
-uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
-uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
-uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
-
-#
-# Add -m32 for cross-builds:
-#
-ifdef NO_64BIT
-  MBITS := -m32
-else
-  #
-  # If we're on a 64-bit kernel, use -m64:
-  #
-  ifneq ($(patsubst %64,%,$(uname_M)),$(uname_M))
-    MBITS := -m64
-  endif
-endif
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -239,8 +218,16 @@ lib = lib
 
 export prefix bindir sharedir sysconfdir
 
-CC = gcc
-AR = ar
+# CROSS_COMPILE specify the prefix used for all executables used
+# during compilation. Only gcc and related bin-utils executables
+# are prefixed with $(CROSS_COMPILE).
+# CROSS_COMPILE can be set on the command line
+# make CROSS_COMPILE=ia64-linux-
+# Alternatively CROSS_COMPILE can be set in the environment.
+# Default value for CROSS_COMPILE is not to prefix executables
+CROSS_COMPILE ?=
+CC = $(CROSS_COMPILE)gcc
+AR = $(CROSS_COMPILE)ar
 RM = rm -f
 TAR = tar
 FIND = find
@@ -252,6 +239,29 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')
+uname_M := $(shell sh -c 'uname -m 2>/dev/null || echo not')
+uname_O := $(shell sh -c 'uname -o 2>/dev/null || echo not')
+uname_R := $(shell sh -c 'uname -r 2>/dev/null || echo not')
+uname_P := $(shell sh -c 'uname -p 2>/dev/null || echo not')
+uname_V := $(shell sh -c 'uname -v 2>/dev/null || echo not')
+machine := $(shell sh -c '$(CC) -dumpmachine | cut -d- -f1')
+
+#
+# Add -m32 for cross-builds:
+# Note: not all architectures have a -m32/-m64 so only define it if we
+# explicitly force to 32 bits or detect a 64 bit arch.
+#
+ifdef FORCE_32BIT
+  MBITS := -m32
+else
+  #
+  # If we're on a 64-bit kernel, use -m64:
+  #
+  ifneq ($(patsubst %64,%,$(machine)),$(machine))
+    MBITS := -m64
+  endif
+endif
 
 
 ### --- END CONFIGURATION SECTION ---
-- 
1.6.3.3

