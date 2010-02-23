Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0BWVt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 16:49:29 -0500
Received: from hera.kernel.org ([140.211.167.34]:35512 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab0BWVt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 16:49:27 -0500
Date: Tue, 23 Feb 2010 21:49:01 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       roland@redhat.com, suresh.b.siddha@intel.com, oleg@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       oleg@redhat.com
In-Reply-To: <20100222225240.494688491@sbs-t61.sc.intel.com>
References: <20100222225240.494688491@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] x86, ptrace: Simplify xstateregs_get()
Message-ID: <tip-ff7fbc72e0c3ef7e94a27a3a918fd09ec9a30204@git.kernel.org>
Git-Commit-ID: ff7fbc72e0c3ef7e94a27a3a918fd09ec9a30204
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Feb 2010 21:49:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff7fbc72e0c3ef7e94a27a3a918fd09ec9a30204
Gitweb:     http://git.kernel.org/tip/ff7fbc72e0c3ef7e94a27a3a918fd09ec9a30204
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 22 Feb 2010 14:51:33 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 13:45:27 -0800

x86, ptrace: Simplify xstateregs_get()

48 bytes (bytes 464..511) of the xstateregs payload come from the
kernel defined structure (xstate_fx_sw_bytes). Rest comes from the
xstate regs structure in the thread struct. Instead of having multiple
user_regset_copyout()'s, simplify the xstateregs_get() by first
copying the SW bytes into the xstate regs structure in the thread structure
and then using one user_regset_copyout() to copyout the xstateregs.

Requested-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100222225240.494688491@sbs-t61.sc.intel.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/i387.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 7a8a193..81e23bf 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -243,34 +243,18 @@ int xstateregs_get(struct task_struct *target, const struct user_regset *regset,
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
 
