Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZCJH5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZCJH5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 03:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZCJH41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 03:56:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:56885 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305AbZCJH4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 03:56:24 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/5] percpu: make x86 addr <-> pcpu ptr conversion macros generic
Date: Tue, 10 Mar 2009 16:53:48 +0900
Message-Id: <1236671631-9305-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236671631-9305-1-git-send-email-tj@kernel.org>
References: <1236671631-9305-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 07:54:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: generic addr <-> pcpu ptr conversion macros

There's nothing arch specific about x86 __addr_to_pcpu_ptr() and
__pcpu_ptr_to_addr().  With proper __per_cpu_load and __per_cpu_start
defined, they'll do the right thing regardless of actual layout.

Move these macros from arch/x86/include/asm/percpu.h to mm/percpu.c
and allow archs to override it as necessary.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/percpu.h |    8 --------
 mm/percpu.c                   |   16 +++++++++++++++-
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/percpu.h b/arch/x86/include/asm/percpu.h
index 8f1d2fb..aee103b 100644
--- a/arch/x86/include/asm/percpu.h
+++ b/arch/x86/include/asm/percpu.h
@@ -43,14 +43,6 @@
 #else /* ...!ASSEMBLY */
 
 #include <linux/stringify.h>
-#include <asm/sections.h>
-
-#define __addr_to_pcpu_ptr(addr)					\
-	(void *)((unsigned long)(addr) - (unsigned long)pcpu_base_addr	\
-		 + (unsigned long)__per_cpu_start)
-#define __pcpu_ptr_to_addr(ptr)						\
-	(void *)((unsigned long)(ptr) + (unsigned long)pcpu_base_addr	\
-		 - (unsigned long)__per_cpu_start)
 
 #ifdef CONFIG_SMP
 #define __percpu_arg(x)		"%%"__stringify(__percpu_seg)":%P" #x
diff --git a/mm/percpu.c b/mm/percpu.c
index bfe6a3a..c6f38a2 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -46,7 +46,8 @@
  * - define CONFIG_HAVE_DYNAMIC_PER_CPU_AREA
  *
  * - define __addr_to_pcpu_ptr() and __pcpu_ptr_to_addr() to translate
- *   regular address to percpu pointer and back
+ *   regular address to percpu pointer and back if they need to be
+ *   different from the default
  *
  * - use pcpu_setup_first_chunk() during percpu area initialization to
  *   setup the first chunk containing the kernel static percpu area
@@ -67,11 +68,24 @@
 #include <linux/workqueue.h>
 
 #include <asm/cacheflush.h>
+#include <asm/sections.h>
 #include <asm/tlbflush.h>
 
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */
 
+/* default addr <-> pcpu_ptr mapping, override in asm/percpu.h if necessary */
+#ifndef __addr_to_pcpu_ptr
+#define __addr_to_pcpu_ptr(addr)					\
+	(void *)((unsigned long)(addr) - (unsigned long)pcpu_base_addr	\
+		 + (unsigned long)__per_cpu_start)
+#endif
+#ifndef __pcpu_ptr_to_addr
+#define __pcpu_ptr_to_addr(ptr)						\
+	(void *)((unsigned long)(ptr) + (unsigned long)pcpu_base_addr	\
+		 - (unsigned long)__per_cpu_start)
+#endif
+
 struct pcpu_chunk {
 	struct list_head	list;		/* linked to pcpu_slot lists */
 	struct rb_node		rb_node;	/* key is chunk->vm->addr */
-- 
1.6.0.2

