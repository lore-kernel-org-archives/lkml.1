Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZBINmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZBINmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbZBINky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:37859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940AbZBINkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:52 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/11] stackprotector: update make rules
Date: Mon,  9 Feb 2009 22:39:53 +0900
Message-Id: <1234186798-16820-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: no default -fno-stack-protector if stackp is enabled, cleanup

Stackprotector make rules had the following problems.

* cc support test and warning are scattered across makefile and
  kernel/panic.c.

* -fno-stack-protector was always added regardless of configuration.

Update such that cc support test and warning are contained in makefile
and -fno-stack-protector is added iff stackp is turned off.  While at
it, prepare for 32bit support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Makefile                                  |    3 ++-
 arch/x86/Makefile                         |   17 ++++++++++-------
 kernel/panic.c                            |    4 ----
 scripts/gcc-x86_64-has-stack-protector.sh |    4 +++-
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/Makefile b/Makefile
index d0634bc..1ab7cef 100644
--- a/Makefile
+++ b/Makefile
@@ -532,8 +532,9 @@ KBUILD_CFLAGS += $(call cc-option,-Wframe-larger-than=${CONFIG_FRAME_WARN})
 endif
 
 # Force gcc to behave correct even for buggy distributions
-# Arch Makefiles may override this setting
+ifndef CONFIG_CC_STACKPROTECTOR
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
+endif
 
 ifdef CONFIG_FRAME_POINTER
 KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index eb7b986..8597305 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -70,14 +70,17 @@ else
         # this works around some issues with generating unwind tables in older gccs
         # newer gccs do it by default
         KBUILD_CFLAGS += -maccumulate-outgoing-args
+endif
 
-        stackp := $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh
-        stackp-$(CONFIG_CC_STACKPROTECTOR) := $(shell $(stackp) \
-                "$(CC)" "-fstack-protector -DGCC_HAS_SP" )
-        stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(stackp) \
-                "$(CC)" -fstack-protector-all )
-
-        KBUILD_CFLAGS += $(stackp-y)
+ifdef CONFIG_CC_STACKPROTECTOR
+	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC)),y)
+                stackp-y := -fstack-protector
+                stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
+                KBUILD_CFLAGS += $(stackp-y)
+        else
+                $(warning stack protector enabled but no compiler support)
+        endif
 endif
 
 # Don't unroll struct assignments with kmemcheck enabled
diff --git a/kernel/panic.c b/kernel/panic.c
index 33cab3d..32fe4ef 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -359,10 +359,6 @@ EXPORT_SYMBOL(warn_slowpath);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 
-#ifndef GCC_HAS_SP
-#warning You have selected the CONFIG_CC_STACKPROTECTOR option, but the gcc used does not support this.
-#endif
-
 /*
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
diff --git a/scripts/gcc-x86_64-has-stack-protector.sh b/scripts/gcc-x86_64-has-stack-protector.sh
index 325c0a1..2d69fcd 100644
--- a/scripts/gcc-x86_64-has-stack-protector.sh
+++ b/scripts/gcc-x86_64-has-stack-protector.sh
@@ -2,5 +2,7 @@
 
 echo "int foo(void) { char X[200]; return 3; }" | $1 -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
-	echo $2
+	echo y
+else
+	echo n
 fi
-- 
1.6.0.2

