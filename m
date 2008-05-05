Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbYEESvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbYEESvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761840AbYEESs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:48:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41916 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765389AbYEESsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:48:25 -0400
Date: Mon, 5 May 2008 11:48:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: x86: Unify current.h
Message-ID: <Pine.LNX.4.64.0805051146210.11469@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are just two definitions that are shared but the resulting combined 
file is resonably small. Putting these two arch headers together shows 
that further unifications requires a unification of the per cpu / pda 
handling between both arches (zero based or some variation thereof).

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/current.h    |   40 ++++++++++++++++++++++++++++++++++++----
 include/asm-x86/current_32.h |   17 -----------------
 include/asm-x86/current_64.h |   27 ---------------------------
 3 files changed, 36 insertions(+), 48 deletions(-)

Index: linux-next/include/asm-x86/current.h
===================================================================
--- linux-next.orig/include/asm-x86/current.h	2008-05-04 22:33:42.299851061 -0700
+++ linux-next/include/asm-x86/current.h	2008-05-05 11:22:16.531407871 -0700
@@ -1,5 +1,37 @@
+#ifndef _X86_CURRENT_H
+#define _X86_CURRENT_H
+
+struct task_struct;
+
 #ifdef CONFIG_X86_32
-# include "current_32.h"
-#else
-# include "current_64.h"
-#endif
+#include <linux/compiler.h>
+#include <asm/percpu.h>
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
Index: linux-next/include/asm-x86/current_32.h
===================================================================
--- linux-next.orig/include/asm-x86/current_32.h	2008-05-04 22:48:44.689850207 -0700
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
Index: linux-next/include/asm-x86/current_64.h
===================================================================
--- linux-next.orig/include/asm-x86/current_64.h	2008-05-04 22:48:44.709851154 -0700
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
