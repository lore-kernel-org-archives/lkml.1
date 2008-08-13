Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYHMSmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYHMSmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbYHMSmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:42:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:27562 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbYHMSmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,202,1217833200"; 
   d="scan'208";a="325955622"
Message-Id: <20080813183857.107206000@linux-os.sc.intel.com>
References: <20080813183856.964126000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 13 Aug 2008 11:38:14 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/3] x86, xsave: clear the user buffer before doing fxsave/xsave
Content-Disposition: inline; filename=init_fpstate_user_buf.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fxsave/xsave instructions will not touch all the bytes in the
fxsave/xsave frame. Clear the user buffer before doing fxsave/xsave
directly to user buffer during the sigcontext setup.

This is essentially needed in the context of xsave(for example,
some of the fields in the xsave header are not touched by the xsave
and defined as must be zero).

This will also present uniform and clean context to the user (from
which user can safely do fxrstor/xrstor).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/xsave.c
===================================================================
--- tip.orig/arch/x86/kernel/xsave.c	2008-08-11 15:26:47.000000000 -0700
+++ tip/arch/x86/kernel/xsave.c	2008-08-11 15:44:33.000000000 -0700
@@ -92,6 +92,12 @@
 		return 0;
 	clear_used_math(); /* trigger finit */
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		/*
+	 	 * Start with clearing the user buffer. This will present a
+	 	 * clean context for the bytes not touched by the fxsave/xsave.
+		 */
+		__clear_user(buf, sig_xstate_size);
+
 		if (task_thread_info(tsk)->status & TS_XSAVE)
 			err = xsave_user(buf);
 		else

-- 

