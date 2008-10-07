Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYJGVJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYJGVJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYJGVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:09:29 -0400
Received: from mga03.intel.com ([143.182.124.21]:10728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635AbYJGVJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:09:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,375,1220252400"; 
   d="scan'208";a="56400118"
Message-Id: <20081007210549.450462000@linux-os.sc.intel.com>
References: <20081007210549.314011000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 07 Oct 2008 14:04:28 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] xsave: set FP, SSE bits in the xsave header in the user sigcontext
Content-Disposition: inline; filename=fix_signal_handling_with_xsave_init_optimization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a processor implementation discern that a processor state component is in
its initialized state, it may modify the corresponding bit in the
xsave header.xstate_bv as '0'. State in the memory layout setup by 'xsave'
will be consistent with the bit values in the header.

During signal handling, legacy applications may change the FP/SSE bits
in the sigcontext memory layout without touching the FP/SSE header bits
in the xsave header. So always set FP/SSE bits in the xsave header
while saving the sigcontext state to the user space. During signal return,
this will enable the kernel to capture any changes to the FP/SSE bits by the
legacy applications which don't touch xsave headers.

xsave aware apps can change the xstate_bv in the xsave header aswell
as change any contents in the memory layout. xrestor as part of sigreturn
will capture all the changes.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c	2008-10-06 13:25:16.000000000 -0700
+++ tip/arch/x86/kernel/xsave.c	2008-10-06 13:30:09.000000000 -0700
@@ -114,6 +114,8 @@
 
 	if (task_thread_info(tsk)->status & TS_XSAVE) {
 		struct _fpstate __user *fx = buf;
+		struct _xstate __user *x = buf;
+		u64 xstate_bv;
 
 		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
 				     sizeof(struct _fpx_sw_bytes));
@@ -121,6 +123,29 @@
 		err |= __put_user(FP_XSTATE_MAGIC2,
 				  (__u32 __user *) (buf + sig_xstate_size
 						    - FP_XSTATE_MAGIC2_SIZE));
+
+		/*
+		 * Read the xstate_bv which we copied (directly from the cpu or
+		 * from the state in task struct) to the user buffers and
+		 * set the FP/SSE bits.
+		 */
+		err |= __get_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+
+		/*
+		 * For legacy compatible, we always set FP/SSE bits in the bit
+		 * vector while saving the state to the user context. This will
+		 * enable us capturing any changes(during sigreturn) to
+		 * the FP/SSE bits by the legacy applications which don't touch
+		 * xstate_bv in the xsave header.
+		 *
+		 * xsave aware apps can change the xstate_bv in the xsave
+		 * header as well as change any contents in the memory layout.
+		 * xrestore as part of sigreturn will capture all the changes.
+		 */
+		xstate_bv |= XSTATE_FPSSE;
+
+		err |= __put_user(xstate_bv, &x->xstate_hdr.xstate_bv);
+
 		if (err)
 			return err;
 	}
Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c	2008-10-06 12:29:28.000000000 -0700
+++ tip/arch/x86/kernel/i387.c	2008-10-06 13:25:18.000000000 -0700
@@ -468,9 +468,23 @@
 
 static int save_i387_xsave(void __user *buf)
 {
+	struct task_struct *tsk = current;
 	struct _fpstate_ia32 __user *fx = buf;
 	int err = 0;
 
+	/*
+	 * For legacy compatible, we always set FP/SSE bits in the bit
+	 * vector while saving the state to the user context.
+	 * This will enable us capturing any changes(during sigreturn) to
+	 * the FP/SSE bits by the legacy applications which don't touch
+	 * xstate_bv in the xsave header.
+	 *
+	 * xsave aware applications can change the xstate_bv in the xsave
+	 * header as well as change any contents in the memory layout.
+	 * xrestore as part of sigreturn will capture all the changes.
+	 */
+	tsk->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+
 	if (save_i387_fxsave(fx) < 0)
 		return -1;
 

-- 

