Return-Path: <linux-kernel-owner+w=401wt.eu-S1765937AbYEHSv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765937AbYEHSv1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838AbYEHSvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:51:16 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:26185 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbYEHSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=NhekcUwZeQinqGUzPwuAj++1eKxmuSGiwAxbW8aA82bm59Km8VKf6FUWmBJ40URnJHxpvMmC7+Da68/xFb0pCwEWzxq6zxL3cXeRte8YIIe/2/qk7DWvXNv3+sg4s5Hw7SGRXFKc8GecxQEqrhHfMBFc1uRNqn0S5pafLRbRJ4U=
Date: Thu, 8 May 2008 20:51:07 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: fix debug handler for kmemcheck
Message-ID: <20080508185107.GA3102@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Patch description says everything :-)

This actually comes from my kmemcheck git repository at
git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git

but it's not in x86.git. CCing LKML in case anybody cares :-)


Vegard


>From 68400903a6348769152f9a2ed102bad0a4774912 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 1 May 2008 19:10:07 +0200
Subject: [PATCH] x86: fix debug handler for kmemcheck

This changes the 64-bit debug exception handler to match the 32-bit version
(which is also correct).

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/kernel/traps_64.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 8069073..72923ba 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -915,18 +915,13 @@ asmlinkage void __kprobes do_debug(struct pt_regs * regs,
 
 	get_debugreg(condition, 6);
 
-#ifdef CONFIG_KMEMCHECK
 	/* Catch kmemcheck conditions first of all! */
 	if (condition & DR_STEP) {
-		if (!(regs->flags & X86_VM_MASK) && !user_mode(regs) &&
-			((void *)regs->ip != system_call) &&
-			((void *)regs->ip != x86_debug) &&
-			((void *)regs->ip != ia32_sysenter_target)) {
+		if (kmemcheck_active(regs)) {
 			kmemcheck_hide(regs);
 			return;
 		}
 	}
-#endif
 
 	/*
 	 * The processor cleared BTF, so don't mark that we need it set.
-- 
1.5.4.1

