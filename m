Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0BVW5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:57:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:1756 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643Ab0BVW5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:57:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,521,1262592000"; 
   d="scan'208";a="542933998"
Message-Id: <20100222225240.494688491@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 22 Feb 2010 14:51:33 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       suresh.b.siddha@intel.com
Subject: [patch 2/3] x86, ptrace: simplify xstateregs_get()
References: <20100222225240.397523600@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=simplify_xstateregs_get.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

48 bytes (bytes 464..511) of the xstateregs payload come from the
kernel defined structure (xstate_fx_sw_bytes). Rest comes from the
xstate regs structure in the thread struct. Instead of having multiple
user_regset_copyout()'s, simplify the xstateregs_get() by first
copying the SW bytes into the xstate regs structure in the thread structure
and then using one user_regset_copyout() to copyout the xstateregs.

Requested-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/i387.c |   30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c
+++ tip/arch/x86/kernel/i387.c
@@ -243,34 +243,18 @@ int xstateregs_get(struct task_struct *t
 		return ret;
 
 	/*
-	 * First copy the fxsave bytes 0..463.
+	 * Copy the 48bytes defined by the software first into the xstate
+	 * memory layout in the thread struct, so that we can copy the entire
+	 * xstateregs to the user using one user_regset_copyout().
 	 */
-	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.xstate->xsave, 0,
-				  offsetof(struct user_xstateregs,
-					   i387.xstate_fx_sw));
-	if (ret)
-		return ret;
-
-	/*
-	 * Copy the 48bytes defined by software.
-	 */
-	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  xstate_fx_sw_bytes,
-				  offsetof(struct user_xstateregs,
-					   i387.xstate_fx_sw),
-				  offsetof(struct user_xstateregs,
-					   xsave_hdr));
-	if (ret)
-		return ret;
+	memcpy(&target->thread.xstate->fxsave.sw_reserved,
+	       xstate_fx_sw_bytes, sizeof(xstate_fx_sw_bytes));
 
 	/*
-	 * Copy the rest of xstate memory layout.
+	 * Copy the xstate memory layout.
 	 */
 	ret = user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				  &target->thread.xstate->xsave.xsave_hdr,
-				  offsetof(struct user_xstateregs,
-					   xsave_hdr), -1);
+				  &target->thread.xstate->xsave, 0, -1);
 	return ret;
 }
 


