Return-Path: <linux-kernel-owner+w=401wt.eu-S1763740AbXGQOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763740AbXGQOIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761446AbXGQOHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:07:53 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35907 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbXGQOHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:49 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 02/33] kbuild: New 'cc-fullversion' macro
Date: Tue, 17 Jul 2007 16:08:31 +0200
Message-Id: <11846813432423-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813423231-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Segher Boessenkool <segher@kernel.crashing.org>

Prints a six-digit string including the GCC patchlevel.  Also fix
the 'usage' comment for cc-version.

Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Kbuild.include |    7 ++++++-
 scripts/gcc-version.sh |   15 ++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 06c1a37..677bc6c 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -100,9 +100,14 @@ cc-option-align = $(subst -functions=0,,\
 	$(call cc-option,-falign-functions=0,-malign-functions=0))
 
 # cc-version
-# Usage gcc-ver := $(call cc-version,$(CC))
+# Usage gcc-ver := $(call cc-version)
 cc-version = $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-version.sh $(CC))
 
+# cc-fullversion
+# Usage gcc-ver := $(call cc-fullversion)
+cc-fullversion = $(shell $(CONFIG_SHELL) \
+	$(srctree)/scripts/gcc-version.sh -p $(CC))
+
 # cc-ifversion
 # Usage:  EXTRA_CFLAGS += $(call cc-ifversion, -lt, 0402, -O1)
 cc-ifversion = $(shell [ $(call cc-version, $(CC)) $(1) $(2) ] && echo $(3))
diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
index bb4fbea..8a1d187 100644
--- a/scripts/gcc-version.sh
+++ b/scripts/gcc-version.sh
@@ -1,14 +1,23 @@
 #!/bin/sh
 #
-# gcc-version gcc-command
+# gcc-version [-p] gcc-command
 #
 # Prints the gcc version of `gcc-command' in a canonical 4-digit form
 # such as `0295' for gcc-2.95, `0303' for gcc-3.3, etc.
 #
+# With the -p option, prints the patchlevel as well, for example `029503' for
+# gcc-2.95.3, `030301' for gcc-3.3.1, etc.
+#
+
+if [ $1 = "-p" ] ; then with_patchlevel=1; shift; fi
 
 compiler="$*"
 
 MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
 MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
-printf "%02d%02d\\n" $MAJOR $MINOR
-
+if [ "x$with_patchlevel" != "x" ] ; then
+	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -xc - | tail -n 1)
+	printf "%02d%02d%02d\\n" $MAJOR $MINOR $PATCHLEVEL
+else
+	printf "%02d%02d\\n" $MAJOR $MINOR
+fi
-- 
1.5.0.6

