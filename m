Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYEJCKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYEJCKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 22:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYEJCKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 22:10:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42677 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751079AbYEJCKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 22:10:16 -0400
Message-Id: <20080510021015.319814569@sgi.com>
References: <20080510020947.803480649@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:09:48 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Cc: travis@sgi.com
Subject: [patch 1/6] x86: Unify current.h
Content-Disposition: inline; filename=x86_unify_current_h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply stitch these together. There are just two definitions that are shared
but the file is resonably small and putting these things together shows that
further unifications requires a unification of the per cpu / pda handling
between both arches.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/current.h    |   42 ++++++++++++++++++++++++++++++++++++++----
 include/asm-x86/current_32.h |   17 -----------------
 include/asm-x86/current_64.h |   27 ---------------------------
 3 files changed, 38 insertions(+), 48 deletions(-)

Index: linux-2.6/include/asm-x86/current.h
===================================================================
--- linux-2.6.orig/include/asm-x86/current.h	2008-05-07 16:33:51.126164691 -0700
+++ linux-2.6/include/asm-x86/current.h	2008-05-09 18:28:05.666268549 -0700
@@ -1,5 +1,39 @@
+#ifndef _X86_CURRENT_H
+#define _X86_CURRENT_H
+
 #ifdef CONFIG_X86_32
-# include "current_32.h"
-#else
-# include "current_64.h"
-#endif
+#include <linux/compiler.h>
+#include <asm/percpu.h>
+
+struct task_struct;
+
+DECLARE_PER_CPU(struct task_struct *, current_task);
+static __always_inline struct task_struct *get_current(void)
+{
+	return x86_read_percpu(current_task);
+}
+
+#else /* X86_32 */
+
+#ifndef __ASSEMBLY__
+#include <asm/pda.h>
+
+struct task_struct;
+
+static __always_inline struct task_struct *get_current(void)
+{
+	return read_pda(pcurrent);
+}
+
+#else /* __ASSEMBLY__ */
+
+#include <asm/asm-offsets.h>
+#define GET_CURRENT(reg) movq %gs:(pda_pcurrent),reg
+
+#endif /* __ASSEMBLY__ */
+
+#endif /* X86_32 */
+
+#define current get_current()
+
+#endif /* X86_CURRENT_H */
Index: linux-2.6/include/asm-x86/current_32.h
===================================================================
--- linux-2.6.orig/include/asm-x86/current_32.h	2008-05-07 16:33:51.130164801 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,17 +0,0 @@
-#ifndef _I386_CURRENT_H
-#define _I386_CURRENT_H
-
-#include <linux/compiler.h>
-#include <asm/percpu.h>
-
-struct task_struct;
-
-DECLARE_PER_CPU(struct task_struct *, current_task);
-static __always_inline struct task_struct *get_current(void)
-{
-	return x86_read_percpu(current_task);
-}
-
-#define current get_current()
-
-#endif /* !(_I386_CURRENT_H) */
Index: linux-2.6/include/asm-x86/current_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/current_64.h	2008-05-07 16:33:51.138164773 -0700
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,27 +0,0 @@
-#ifndef _X86_64_CURRENT_H
-#define _X86_64_CURRENT_H
-
-#if !defined(__ASSEMBLY__)
-struct task_struct;
-
-#include <asm/pda.h>
-
-static inline struct task_struct *get_current(void)
-{
-	struct task_struct *t = read_pda(pcurrent);
-	return t;
-}
-
-#define current get_current()
-
-#else
-
-#ifndef ASM_OFFSET_H
-#include <asm/asm-offsets.h>
-#endif
-
-#define GET_CURRENT(reg) movq %gs:(pda_pcurrent),reg
-
-#endif
-
-#endif /* !(_X86_64_CURRENT_H) */

-- 
