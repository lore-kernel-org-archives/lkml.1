Return-Path: <linux-kernel-owner+w=401wt.eu-S1758329AbYDKFA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329AbYDKFA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 01:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbYDKFAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 01:00:22 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:21210 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYDKFAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 01:00:21 -0400
Date: Fri, 11 Apr 2008 01:00:20 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, roland@redhat.com
Subject: [PATCH] reorganize <linux/linkage.h>
Message-ID: <20080411050019.GC27073@phobos.i.cabal.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 54a015104136974262afa4b8ddd943ea70dec8a2 adds some new magic
asmlinkage_protect gizmo, but that can only be used from C code, not
assembly. Protect relevant bits of <linux/linkage.h> with !__ASSEMBLY__
so this can't leak into assembly source.

Fixes a couple build errors on my boxes,
  AS      arch/parisc/kernel/pacache.o
In file included from arch/parisc/kernel/pacache.S:40:
include/linux/linkage.h:34: error: syntax error in macro parameter list
make[1]: *** [arch/parisc/kernel/pacache.o] Error 1

(__ALIGN gets used in both kernel and assembly context, so make sure it
is outside of the ifdeffery.)

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
---
diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index b163c5c..e848f74 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -3,6 +3,13 @@
 
 #include <asm/linkage.h>
 
+#ifndef __ALIGN
+#define __ALIGN		.align 4,0x90
+#define __ALIGN_STR	".align 4,0x90"
+#endif
+
+#if !defined(__ASSEMBLY__)
+
 #ifdef __cplusplus
 #define CPP_ASMLINKAGE extern "C"
 #else
@@ -34,12 +41,11 @@
 # define asmlinkage_protect(n, ret, args...)	do { } while (0)
 #endif
 
-#ifndef __ALIGN
-#define __ALIGN		.align 4,0x90
-#define __ALIGN_STR	".align 4,0x90"
-#endif
+#define NORET_TYPE    /**/
+#define ATTRIB_NORET  __attribute__((noreturn))
+#define NORET_AND     noreturn,
 
-#ifdef __ASSEMBLY__
+#else
 
 #define ALIGN __ALIGN
 #define ALIGN_STR __ALIGN_STR
@@ -80,10 +86,6 @@
   END(name)
 #endif
 
-#endif
-
-#define NORET_TYPE    /**/
-#define ATTRIB_NORET  __attribute__((noreturn))
-#define NORET_AND     noreturn,
+#endif /*__ASSEMBLY__*/
 
 #endif
