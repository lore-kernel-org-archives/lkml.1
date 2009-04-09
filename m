Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbZDIWZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbZDIWZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764357AbZDIWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:25:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:20055 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757707AbZDIWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:25:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,163,1239001200"; 
   d="scan'208";a="129896625"
Subject: [patch] x64: fix FPU corruption with signals and preemption
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: hpa@linux.intel.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 09 Apr 2009 15:24:34 -0700
Message-Id: <1239315874.27006.8026.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x64: fix FPU corruption with signals and preemption

Impact: fix FPU state corruption

In 64bit signal delivery path, clear_used_math() was happening before saving
the current active FPU state on to the user stack for signal handling. Between
clear_used_math() and the state store on to the user stack, potentially we
can get a page fault for the user address and can block. Infact, while testing
we were hitting the might_fault() in __clear_user() which can do a schedule().

At a later point in time, we will schedule back into this process and
resume the save state (using "xsave/fxsave" instruction) which can lead
to DNA fault. And as used_math was cleared before, we will reinit the FP state
in the DNA fault and continue. This reinit will result in loosing the
FPU state of the process.

Move clear_used_math() to a point after the FPU state has been stored
onto the user stack.

This issue is present from a long time (even before the xsave changes
and the x86 merge). But it can easily be exposed in 2.6.28.x and 2.6.29.x
series because of the __clear_user() in this path, which has an explicit
__cond_resched() leading to a context switch with CONFIG_PREEMPT_VOLUNTARY.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org			[2.6.28.x, 2.6.29.x]
---

Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c
+++ tip/arch/x86/kernel/xsave.c
@@ -89,7 +89,7 @@ int save_i387_xstate(void __user *buf)
 
 	if (!used_math())
 		return 0;
-	clear_used_math(); /* trigger finit */
+
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
 		/*
 	 	 * Start with clearing the user buffer. This will present a
@@ -114,6 +114,8 @@ int save_i387_xstate(void __user *buf)
 			return -1;
 	}
 
+	clear_used_math(); /* trigger finit */
+
 	if (task_thread_info(tsk)->status & TS_XSAVE) {
 		struct _fpstate __user *fx = buf;
 		struct _xstate __user *x = buf;


