Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbYG2Rl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbYG2Rl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYG2Rk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:34002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbYG2RkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="320702108"
Message-Id: <20080729173158.529239000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:26 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 9/9] x86, xsave: update xsave header bits during ptrace fpregs set
Content-Disposition: inline; filename=fix_ptrace_set_fpregs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FP/SSE bits may be zero in the xsave header(representing the init state).
Update these bits during the ptrace fpregs set operation, to indicate the
non-init state.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/kernel/i387.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/i387.c	2008-07-28 18:50:08.000000000 -0700
+++ tip-0728/arch/x86/kernel/i387.c	2008-07-28 18:51:29.000000000 -0700
@@ -214,6 +214,13 @@
 	 */
 	target->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 
+	/*
+	 * update the header bits in the xsave header, indicating the
+	 * presence of FP and SSE state.
+	 */
+	if (cpu_has_xsave)
+		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FPSSE;
+
 	return ret;
 }
 
@@ -414,6 +421,12 @@
 	if (!ret)
 		convert_to_fxsr(target, &env);
 
+	/*
+	 * update the header bit in the xsave header, indicating the
+	 * presence of FP.
+	 */
+	if (cpu_has_xsave)
+		target->thread.xstate->xsave.xsave_hdr.xstate_bv |= XSTATE_FP;
 	return ret;
 }
 

-- 

