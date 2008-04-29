Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYD2By7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYD2By7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYD2BxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:07 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56031 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751242AbYD2BxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:01 -0400
Message-Id: <20080429015300.946774085@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:35 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 4/9] x86: common thread_info definitions
Content-Disposition: inline; filename=merge_threadinfo2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merge the thread_info definition into one structure definition for both arches.

The __u32 is equal to unsigned long for 32 bit.

sysenter_return is used both for the IA32 emulation for 64 and x86_32.
Avoid complicated #ifdef by simply always including it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |   55 +++++++++---------------------------------
 1 file changed, 12 insertions(+), 43 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:47:10.563649517 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:47:14.822390659 -0700
@@ -11,47 +11,42 @@
 #include <asm/page.h>
 #include <asm/types.h>
 
-#ifdef CONFIG_X86_32
-
-#ifndef __ASSEMBLY__
-#include <asm/processor.h>
-#endif
-
 /*
  * low level task data that entry.S needs immediate access to
  * - this struct should fit entirely inside of one cache line
  * - this struct shares the supervisor stack pages
- * - if the contents of this structure are changed,
- *   the assembly constants must also be changed
  */
 #ifndef __ASSEMBLY__
+struct task_struct;
+struct exec_domain;
+#include <asm/processor.h>
 
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	struct exec_domain	*exec_domain;	/* execution domain */
-	unsigned long		flags;		/* low level flags */
-	unsigned long		status;		/* thread-synchronous flags */
+	__u32			flags;		/* low level flags */
+	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
-	int			preempt_count;	/* 0 => preemptable,
+	int 			preempt_count;	/* 0 => preemptable,
 						   <0 => BUG */
-	mm_segment_t		addr_limit;	/* thread address space:
-						   0-0xBFFFFFFF user-thread
-						   0-0xFFFFFFFF kernel-thread
-						*/
-	void			*sysenter_return;
+	mm_segment_t		addr_limit;
 	struct restart_block    restart_block;
+	void __user		*sysenter_return;
+#ifdef CONFIG_X86_32
 	unsigned long           previous_esp;   /* ESP of the previous stack in
 						   case of nested (IRQ) stacks
 						*/
 	__u8			supervisor_stack[0];
+#endif
 };
-
 #else /* !__ASSEMBLY__ */
 
 #include <asm/asm-offsets.h>
 
 #endif
 
+#ifdef CONFIG_X86_32
+
 #define PREEMPT_ACTIVE		0x10000000
 #ifdef CONFIG_4KSTACKS
 #define THREAD_SIZE            (4096)
@@ -182,32 +177,6 @@ static inline struct thread_info *curren
 #include <asm/pda.h>
 
 /*
- * low level task data that entry.S needs immediate access to
- * - this struct should fit entirely inside of one cache line
- * - this struct shares the supervisor stack pages
- */
-#ifndef __ASSEMBLY__
-struct task_struct;
-struct exec_domain;
-#include <asm/processor.h>
-
-struct thread_info {
-	struct task_struct	*task;		/* main task structure */
-	struct exec_domain	*exec_domain;	/* execution domain */
-	__u32			flags;		/* low level flags */
-	__u32			status;		/* thread synchronous flags */
-	__u32			cpu;		/* current CPU */
-	int 			preempt_count;	/* 0 => preemptable,
-						   <0 => BUG */
-	mm_segment_t		addr_limit;
-	struct restart_block    restart_block;
-#ifdef CONFIG_IA32_EMULATION
-	void __user		*sysenter_return;
-#endif
-};
-#endif
-
-/*
  * macros/functions for gaining access to the thread information structure
  * preempt_count needs to be 1 initially, until the scheduler is functional.
  */

-- 
