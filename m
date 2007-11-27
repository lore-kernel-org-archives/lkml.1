Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbXK0APl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbXK0APl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXK0AOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:33 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45354 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756883AbXK0AOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:30 -0500
Message-Id: <20071127001430.083503280@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:11 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       tony.luck@intel.com
Subject: [patch 04/14] ia64: Remove the __SMALL_ADDR_AREA attribute for per cpu access
Content-Disposition: inline; filename=remove_ia64_model_section
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The model(small) attribute is not supported by gcc 4.X. The tests
will always be negative today.

Cc: linux-ia64@vger.kernel.org
Cc: tony.luck@intel.com
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/ia64/scripts/check-model.c   |    1 -
 arch/ia64/scripts/toolchain-flags |    6 ------
 include/asm-ia64/percpu.h         |   12 +++---------
 3 files changed, 3 insertions(+), 16 deletions(-)

Index: linux-2.6/include/asm-ia64/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/percpu.h	2007-11-22 15:55:47.634454755 -0800
+++ linux-2.6/include/asm-ia64/percpu.h	2007-11-22 15:56:15.974704716 -0800
@@ -15,24 +15,18 @@
 
 #include <linux/threads.h>
 
-#ifdef HAVE_MODEL_SMALL_ATTRIBUTE
-# define __SMALL_ADDR_AREA	__attribute__((__model__ (__small__)))
-#else
-# define __SMALL_ADDR_AREA
-#endif
-
 #define DECLARE_PER_CPU(type, name)				\
-	extern __SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
+	extern __typeof__(type) per_cpu__##name
 
 /* Separate out the type, so (int[3], foo) works. */
 #define DEFINE_PER_CPU(type, name)				\
 	__attribute__((__section__(".data.percpu")))		\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name
+	__typeof__(type) per_cpu__##name
 
 #ifdef CONFIG_SMP
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)			\
 	__attribute__((__section__(".data.percpu.shared_aligned")))	\
-	__SMALL_ADDR_AREA __typeof__(type) per_cpu__##name		\
+	__typeof__(type) per_cpu__##name				\
 	____cacheline_aligned_in_smp
 #else
 #define DEFINE_PER_CPU_SHARED_ALIGNED(type, name)	\
Index: linux-2.6/arch/ia64/scripts/check-model.c
===================================================================
--- linux-2.6.orig/arch/ia64/scripts/check-model.c	2007-11-22 15:56:40.890455063 -0800
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1 +0,0 @@
-int __attribute__ ((__model__ (__small__))) x;
Index: linux-2.6/arch/ia64/scripts/toolchain-flags
===================================================================
--- linux-2.6.orig/arch/ia64/scripts/toolchain-flags	2007-11-22 15:57:07.329204964 -0800
+++ linux-2.6/arch/ia64/scripts/toolchain-flags	2007-11-22 15:57:27.229018356 -0800
@@ -35,12 +35,6 @@ if [ $res -eq 0 ]; then
     CPPFLAGS="$CPPFLAGS -DHAVE_WORKING_TEXT_ALIGN"
 fi
 
-if ! $CC -c $dir/check-model.c -o $out 2>&1 | grep  __model__ | grep -q attrib
-then
-    CPPFLAGS="$CPPFLAGS -DHAVE_MODEL_SMALL_ATTRIBUTE"
-fi
-rm -f $out
-
 # Check whether assembler supports .serialize.{data,instruction} directive.
 
 $CC -c $dir/check-serialize.S -o $out 2>/dev/null

-- 
