Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZITSnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZITSnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbZITSni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:43:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62596 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197AbZITSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:43:38 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 1/4] kbuild: Don't define ALIGN and ENTRY when preprocessing linker scripts.
Date: Sun, 20 Sep 2009 14:43:10 -0400
Message-Id: <1253472193-21106-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253472193-21106-1-git-send-email-tabbott@ksplice.com>
References: <1253472193-21106-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a reference to <linux/linkage.h> to x86's <asm/cache.h> causes
the x86 linker script to have syntax errors, because the ALIGN and
ENTRY keywords get redefined to the assembly implementations of those.
One could fix this by adjusting the include structure, but I think any
solution based on that approach would be fragile.

Currently, it is impossible when writing a header to do something
different for assembly files and linker scripts, even though there are
clearly cases where one wants them to define macros differently for
the two (ENTRY being an excellent example).  So I think the right
solution here is to introduce a new preprocessor definition,
tentatively called __LINKER_SCRIPT__ that is set along with
__ASSEMBLY__ for linker scripts, and to use that to not define ALIGN
and ENTRY in linker scripts.  I suspect we'll find other uses for this
mechanism in the future.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 include/linux/linkage.h |    2 ++
 scripts/Makefile.build  |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index 691f591..be874bb 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -57,6 +57,7 @@
 
 #ifdef __ASSEMBLY__
 
+#ifndef __LINKER_SCRIPT__
 #define ALIGN __ALIGN
 #define ALIGN_STR __ALIGN_STR
 
@@ -66,6 +67,7 @@
   ALIGN; \
   name:
 #endif
+#endif /* __LINKER_SCRIPT__ */
 
 #ifndef WEAK
 #define WEAK(name)	   \
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 5c4b7a4..e51e213 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -269,7 +269,8 @@ targets += $(extra-y) $(MAKECMDGOALS) $(always)
 # Linker scripts preprocessor (.lds.S -> .lds)
 # ---------------------------------------------------------------------------
 quiet_cmd_cpp_lds_S = LDS     $@
-      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -o $@ $<
+      cmd_cpp_lds_S = $(CPP) $(cpp_flags) -D__ASSEMBLY__ -D__LINKER_SCRIPT__ \
+		      -o $@ $<
 
 $(obj)/%.lds: $(src)/%.lds.S FORCE
 	$(call if_changed_dep,cpp_lds_S)
-- 
1.6.3.3

