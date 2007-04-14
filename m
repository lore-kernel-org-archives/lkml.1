Return-Path: <linux-kernel-owner+w=401wt.eu-S965536AbXDNVVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536AbXDNVVr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXDNVUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:20:18 -0400
Received: from gw.goop.org ([64.81.55.164]:59517 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbXDNVUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:13 -0400
Message-Id: <20070414204923.521637202@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:41:56 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 02/28] Account for module percpu space separately from kernel percpu
Content-Disposition: inline; filename=separate-module-percpu-space.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than using a single constant PERCPU_ENOUGH_ROOM, compute it as
the sum of kernel_percpu + PERCPU_MODULE_RESERVE.  This is now common
to all architectures; if an architecture wants to set
PERCPU_ENOUGH_ROOM to something special, then it may do so (ia64 is
the only one which does).

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Andi Kleen <ak@suse.de>

---
 include/asm-alpha/percpu.h   |   14 --------------
 include/asm-sparc64/percpu.h |   10 ----------
 include/asm-x86_64/percpu.h  |   10 ----------
 include/linux/percpu.h       |    9 ++++++++-
 kernel/module.c              |    2 +-
 5 files changed, 9 insertions(+), 36 deletions(-)

===================================================================
--- a/include/asm-alpha/percpu.h
+++ b/include/asm-alpha/percpu.h
@@ -1,19 +1,5 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
-
-/*
- * Increase the per cpu area for Alpha so that
- * modules using percpu area can load.
- */
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
 
 #include <asm-generic/percpu.h>
 
===================================================================
--- a/include/asm-sparc64/percpu.h
+++ b/include/asm-sparc64/percpu.h
@@ -4,16 +4,6 @@
 #include <linux/compiler.h>
 
 #ifdef CONFIG_SMP
-
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
 
 extern void setup_per_cpu_areas(void);
 
===================================================================
--- a/include/asm-x86_64/percpu.h
+++ b/include/asm-x86_64/percpu.h
@@ -10,16 +10,6 @@
 #ifdef CONFIG_SMP
 
 #include <asm/pda.h>
-
-#ifdef CONFIG_MODULES
-# define PERCPU_MODULE_RESERVE 8192
-#else
-# define PERCPU_MODULE_RESERVE 0
-#endif
-
-#define PERCPU_ENOUGH_ROOM \
-	(ALIGN(__per_cpu_end - __per_cpu_start, SMP_CACHE_BYTES) + \
-	 PERCPU_MODULE_RESERVE)
 
 #define __per_cpu_offset(cpu) (cpu_pda(cpu)->data_offset)
 #define __my_cpu_offset() read_pda(data_offset)
===================================================================
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -11,8 +11,15 @@
 
 /* Enough to cover all DEFINE_PER_CPUs in kernel, including modules. */
 #ifndef PERCPU_ENOUGH_ROOM
-#define PERCPU_ENOUGH_ROOM 32768
+#ifdef CONFIG_MODULES
+#define PERCPU_MODULE_RESERVE	8192
+#else
+#define PERCPU_MODULE_RESERVE	0
 #endif
+
+#define PERCPU_ENOUGH_ROOM						\
+	(__per_cpu_end - __per_cpu_start + PERCPU_MODULE_RESERVE)
+#endif	/* PERCPU_ENOUGH_ROOM */
 
 /*
  * Must be an lvalue. Since @var must be a simple identifier,
===================================================================
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -430,7 +430,7 @@ static int percpu_modinit(void)
 	pcpu_size = kmalloc(sizeof(pcpu_size[0]) * pcpu_num_allocated,
 			    GFP_KERNEL);
 	/* Static in-kernel percpu data (used). */
-	pcpu_size[0] = -ALIGN(__per_cpu_end-__per_cpu_start, SMP_CACHE_BYTES);
+	pcpu_size[0] = -(__per_cpu_end-__per_cpu_start);
 	/* Free room. */
 	pcpu_size[1] = PERCPU_ENOUGH_ROOM + pcpu_size[0];
 	if (pcpu_size[1] < 0) {

-- 

