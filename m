Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZBFGFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZBFGFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZBFGFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:05:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:54824 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZBFGF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:05:29 -0500
Message-Id: <20090206060527.369616736@goodmis.org>
References: <20090206060328.181057235@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Feb 2009 01:03:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michael Neuling <mikey@neuling.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] powerpc, ftrace: fix compile error when modules not configured
Content-Disposition: inline; filename=0002-powerpc-ftrace-fix-compile-error-when-modules-not.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Michael Neuling reported a compile bug when dynamic ftrace was
configured in and modules were not. This was due to the ftrace
code referencing module specific structures.

Reported-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/powerpc/kernel/ftrace.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
index a913f91..88c641d 100644
--- a/arch/powerpc/kernel/ftrace.c
+++ b/arch/powerpc/kernel/ftrace.c
@@ -113,6 +113,8 @@ static int test_24bit_addr(unsigned long ip, unsigned long addr)
 	return create_branch((unsigned int *)ip, addr, 0);
 }
 
+#ifdef CONFIG_MODULES
+
 static int is_bl_op(unsigned int op)
 {
 	return (op & 0xfc000003) == 0x48000001;
@@ -323,6 +325,7 @@ __ftrace_make_nop(struct module *mod,
 	return 0;
 }
 #endif /* PPC64 */
+#endif /* CONFIG_MODULES */
 
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
@@ -342,6 +345,7 @@ int ftrace_make_nop(struct module *mod,
 		return ftrace_modify_code(ip, old, new);
 	}
 
+#ifdef CONFIG_MODULES
 	/*
 	 * Out of range jumps are called from modules.
 	 * We should either already have a pointer to the module
@@ -366,9 +370,13 @@ int ftrace_make_nop(struct module *mod,
 		mod = rec->arch.mod;
 
 	return __ftrace_make_nop(mod, rec, addr);
-
+#else
+	/* We should not get here without modules */
+	return -EINVAL;
+#endif /* CONFIG_MODULES */
 }
 
+#ifdef CONFIG_MODULES
 #ifdef CONFIG_PPC64
 static int
 __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -457,6 +465,7 @@ __ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	return 0;
 }
 #endif /* CONFIG_PPC64 */
+#endif /* CONFIG_MODULES */
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
@@ -475,6 +484,7 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 		return ftrace_modify_code(ip, old, new);
 	}
 
+#ifdef CONFIG_MODULES
 	/*
 	 * Out of range jumps are called from modules.
 	 * Being that we are converting from nop, it had better
@@ -486,6 +496,10 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	}
 
 	return __ftrace_make_call(rec, addr);
+#else
+	/* We should not get here without modules */
+	return -EINVAL;
+#endif /* CONFIG_MODULES */
 }
 
 int ftrace_update_ftrace_func(ftrace_func_t func)
-- 
1.5.6.5

-- 
